(*:Main unit for the iraHookDLL. Implements system-wide keyboard, mouse,
   shell, and CBT hooks. Supports multiple listeners, automatic unhooking on
   process detach, and only installs the hooks that are needed. Supports
   notification listeners and filter listeners (should be used with care because
   SendMessage used for filtering can effectively block the whole system if
   listener is not processing messages). Each listener can only listen to one
   hook because hook code is sent as a message ID. All internal IDs are
   generated from the module name so you only have to rename the DLL to make it
   peacefully coexist with another iraHookDLL DLL. Designed to work with (but
   not limited to) iraHookComps.


</pre>*)(*
   History:
     1.03a: 2005-04-18
       - Changed mutex and file mapping security descriptors to allow for cross-desktop
         process cooperation.
     1.03: 2001-11-08
       - Added support for filtering listeners.
     1.02: 2001-10-10
       - Added support for the Computer-based training (CBT) hook.
     1.01: 2001-10-06
       - Modified to work with more than on listener.
       - Internals simplified and modularized.
     1.0: 2001-09-25
       - Created and released.
*)


//{$DEFINE Debug_iraHook}

unit iraHook;

interface

uses
  Windows,
  Messages,
  iraHookCommon ;
  // !!!NEVER!!! use SysUtils or other Delphi units

  {:Process has attached to the DLL. Not exported.
  }
  procedure ProcessAttached;

  {:Process has detached from the DLL. Not exported.
  }
  procedure ProcessDetached;

//exports

  {:Attach the window handle to the hook. Returns error code (see
    iraHookCommon for more information). Exported.
  }
  function AttachReceiver(hookType: TiraHookType; receiver: THandle; isFiltering: boolean): integer; stdcall;

  {:Detach the window handle from the hook. Returns error code (see
    iraHookCommon for more information). Exported.
  }
  function DetachReceiver(hookType: TiraHookType; receiver: THandle): integer; stdcall;

  {:Return error status of the first problematic wrapper or NO_ERROR if all
    wrappers were installed without a problem. Exported.
  }
  function LastError: DWORD; stdcall;

implementation

uses
  iraSecurity;

const
  //:Maximum number of receivers attached to each hook.
  CMaxReceivers = 128;

type
  {:Receiver.
  }
  TiraHookReceiver = record
    Filtering: boolean;
    Handle   : THandle;
  end; { TiraHookReceiver }

  {:Receiver list.
  }
  TiraHookReceivers = record
    Count    : integer;
    Receivers: array [0..CMaxReceivers-1] of TiraHookReceiver;
  end; { TiraHookReceivers }

  {:Dynamic hook data.
  }
  TiraSharedHookData = record
    HookCallback : HHOOK;
    Receivers    : TiraHookReceivers;
  end; { TGpSharedHookData }
  PiraSharedHookData = ^TiraSharedHookData;

  {:Static hook data (hook descriptors).
  }
  TiraStaticHookData = record
    HookType    : integer;
    HookCallback: TFNHookProc;
  end; { TGpStaticHookData }

type
  {:Generic hook wrapper class.
  }
  TiraHookWrapper = class
  private
    wrpHookMutex: THandle;
    wrpLastError: DWORD;
    wrpMemFile  : THandle;
    wrpReceivers: TiraHookReceivers;  // per-process list of receivers
    wrpShared   : PiraSharedHookData; // memory mapped file
    wrpStatic   : TiraStaticHookData;
    {$IFDEF Debug_iraHook}
    wrpBaseName : string;
    {$ENDIF Debug_iraHook}
  protected
    function  Hook: integer; virtual;
    function  Unhook: integer; virtual;
  public
    constructor Create(baseName: string; hookType: integer; hookCallback: TFNHookProc);
    destructor  Destroy; override;
    function  AttachReceiver(receiver: THandle; isFiltering: boolean): integer;
    function  DetachReceiver(receiver: THandle): integer;
    procedure Broadcast(code: integer; wParam: WPARAM; lParam: LPARAM; var Result: LRESULT);
    procedure CallNextHook(code: integer; wParam: WPARAM; lParam: LPARAM; var Result: LRESULT);
    property  LastError: DWORD read wrpLastError;
  end; { TiraHookWrapper }

  {:Generic class wrapping all implemented hooks (actually, their wrapper
    classes).
  }
  TiraHookWrappers = class
  private
    wrpWrappers: array [TiraHookType] of TiraHookWrapper;
  protected
    function GetItems(idx: TiraHookType): TiraHookWrapper; virtual;
  public
    constructor Create;
    destructor  Destroy; override;
    function  AttachReceiver(hookType: TiraHookType; receiver: THandle; isFiltering: boolean): integer;
    function  DetachReceiver(hookType: TiraHookType; receiver: THandle): integer;
    procedure Broadcast(hookType: TiraHookType; code: integer; wParam: WPARAM; lParam: LPARAM; var Result: LRESULT);
    procedure CallNextHook(hookType: TiraHookType; code: integer; wParam: WPARAM; lParam: LPARAM; var Result: LRESULT);
    function  LastError: DWORD;
    property  Items[idx: TiraHookType]: TiraHookWrapper read GetItems; default;
  end; { TiraHookWrappers }

var
  //:Wrappers for all implemented hooks.
  Wrappers: TiraHookWrappers;

{:Shell hook callback.
}
function ShellHookCallback(code: integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
  wrapper: TiraHookWrapper;
begin
  wrapper := Wrappers[htShell];
  Result := 0;
  if assigned(wrapper) and assigned(wrapper.wrpShared) then begin
    WaitForSingleObject(wrapper.wrpHookMutex, INFINITE);
    try
      if code >= 0 then
        Wrappers.Broadcast(htShell,code,wParam,lParam,Result);
    finally ReleaseMutex(wrapper.wrpHookMutex); end;
      Wrappers.CallNextHook(htShell,code,wParam,lParam,Result);
  end;
end; { ShellHookCallback }

{:Keyboard hook callback.
}
function KbdHookCallback(code: integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
  wrapper: TiraHookWrapper;
begin
  wrapper := Wrappers[htKeyboard];
  Result := 0;
  if assigned(wrapper) and assigned(wrapper.wrpShared) then begin
    WaitForSingleObject(wrapper.wrpHookMutex, INFINITE);
    try
      if code = HC_ACTION then
        Wrappers.Broadcast(htKeyboard,code,wParam,lParam,Result);
    finally ReleaseMutex(wrapper.wrpHookMutex); end;
      Wrappers.CallNextHook(htKeyboard,code,wParam,lParam,Result);
  end;
end; { KbdHookCallback }


{:Mouse hook callback.
}
function MouseHookCallback(code: integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
  WND: HWND;
  Point: TPoint;
  pMouseHook: PMouseHookStruct;
  wrapper   : TiraHookWrapper;
begin
  wrapper := Wrappers[htMouse];
  Result := 0;


  if assigned(wrapper) and assigned(wrapper.wrpShared) then begin
    WaitForSingleObject(wrapper.wrpHookMutex, INFINITE);
    try
      if code = HC_ACTION then begin
        pMouseHook := PMouseHookStruct(lParam);

        Point:= pMouseHook.pt;

        // convert screen coordinates to window coordinates
        ScreenToClient(pMouseHook.hwnd,Point);
        // search child window
        WND:=ChildWindowFromPoint(pMouseHook.hwnd,Point);
       //  if zero then...
        if WND=0 then WND:=pMouseHook.hwnd;
  //      wrapper.cy.SendString( FindWindow('Form1',nil),
  //       '0,'+ Inttostr(wparam) + ',' + Inttostr(lparam) + ',' +  Inttostr(WND) , 1000);
        // post message directly to main form
                                                  //  PostMessage(FindWindow('Tform1',nil),MouseHookMessage,WND,MsgID);

      //  Wrappers.Broadcast(htMouse,wParam,
      //    (pMouseHook^.pt.x and $FFFF) or (pMouseHook^.pt.y shl 16),
      //    pMouseHook^.hwnd, Result);


        Wrappers.Broadcast(htMouse,code, wParam, WND, Result);
//        Wrappers.Broadcast(htMouse,code, wParam, (pMouseHook^.pt.x and $FFFF) or (pMouseHook^.pt.y shl 16), WND);
      end;

    finally ReleaseMutex(wrapper.wrpHookMutex); end;
      Wrappers.CallNextHook(htMouse,code,wParam,lParam,Result);
  end;
end; { MouseHookCallback }

{:CBT hook callback.
}
function CBTHookCallback(code: integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
  wrapper: TiraHookWrapper;
begin
  wrapper := Wrappers[htCBT];
  Result := 0;
  if assigned(wrapper) and assigned(wrapper.wrpShared) then begin
    WaitForSingleObject(wrapper.wrpHookMutex, INFINITE);
    try
      if code = HCBT_ACTIVATE then
        Wrappers.Broadcast(htCBT,code,wParam,PCBTActivateStruct(lParam)^.hWndActive, Result)
      else if code = HCBT_CLICKSKIPPED then
        Wrappers.Broadcast(htCBT,code,wParam,PMouseHookStruct(lParam)^.hwnd,Result)
      else if code >=0 then
        Wrappers.Broadcast(htCBT,code,wParam,lParam,Result);
    finally ReleaseMutex(wrapper.wrpHookMutex); end;
      Wrappers.CallNextHook(htCBT,code,wParam,lParam,Result);
  end;
end; { CBTHookCallback }

(*Copied from the SysUtils to prevent exception handling etc from being loaded.*)
function StrScan(const Str: PChar; Chr: Char): PChar; assembler;
asm
        PUSH    EDI
        PUSH    EAX
        MOV     EDI,Str
        MOV     ECX,0FFFFFFFFH
        XOR     AL,AL
        REPNE   SCASB
        NOT     ECX
        POP     EDI
        MOV     AX,Chr//GG
        REPNE   SCASB
        MOV     EAX,0
        JNE     @@1
        MOV     EAX,EDI
        DEC     EAX
@@1:    POP     EDI
end;

function LastDelimiter(const Delimiters, S: string): Integer;
var
  P: PChar;
begin
  Result := Length(S);
  P := PChar(Delimiters);
  while Result > 0 do begin
    if (S[Result] <> #0) and (StrScan(P, S[Result]) <> nil) then
      Exit;
    Dec(Result);
  end;
end;

function ExtractFileName(const FileName: string): string;
var
  I: Integer;
begin
  I := LastDelimiter('\:', FileName);
  Result := Copy(FileName, I + 1, MaxInt);
end;

function ChangeFileExt(const FileName, Extension: string): string;
var
  I: Integer;
begin
  I := LastDelimiter('.\:',Filename);
  if (I = 0) or (FileName[I] <> '.') then I := MaxInt;
  Result := Copy(FileName, 1, I - 1) + Extension;
end;
(*End of SysUtils functions.*)

{$IFDEF Debug_iraHook}
{ Debugging }

{:Debug logger. Sends one line to the c:\iraHook.log file.
  @param   msg Message to be written to the debug file.
}        
procedure DebugLog(msg: string);
var
  f: textfile;
begin
  Assign(f,'c:\iraHook.log');
  if not FileExists('c:\iraHook.log') then
    Rewrite(f)
  else
    Append(f);
  Writeln(f,FormatDateTime('yyyy-mm-dd"T"hh:mm:ss',Now)+' '+msg);
  Close(f);
end; { DebugLog }
{$ENDIF Debug_iraHook}

{ TiraHookReceivers class-like interface }

{:Returns index of the receiver or -1 if not found.
}
function Receivers_IndexOf(var receivers: TiraHookReceivers; receiver: THandle): integer;
begin
  for Result := 0 to receivers.Count-1 do
    if receivers.Receivers[Result].Handle = receiver then
      Exit;
  Result := -1;
end; { Receivers_IndexOf }

{:Adds receiver to the receiver list and returns its index. Returns -1 if list
  is full.
}
function Receivers_Add(var receivers: TiraHookReceivers; receiver: THandle; isFiltering: boolean): integer;
begin
  if receivers.Count >= (CMaxReceivers-1) then
    Result := -1
  else begin
    Inc(receivers.Count);
    Result := receivers.Count-1;
    with receivers.Receivers[Result] do begin
      Handle    := receiver;
      Filtering := isFiltering;
    end; //with
  end;
end; { Receivers_Add }

{:Returns number of receivers in the list.
}
function Receivers_Count(var receivers: TiraHookReceivers): integer;
begin
  Result := receivers.Count;
end; { Receivers_Count }

{:Clears receiver list.
}
procedure Receivers_Clear(var receivers: TiraHookReceivers);
begin
  receivers.Count := 0;
end; { Receivers_Clear }

{:Deletes receiver from the list. If receiver is not found in the list, nothing
  happens.
}
procedure Receivers_Delete(var receivers: TiraHookReceivers; position: integer);
begin
  if (position >= 0) and (position < receivers.Count) then begin
    if position <> (receivers.Count-1) then
      receivers.Receivers[position] := receivers.Receivers[receivers.Count-1];
    Dec(receivers.Count);
  end;
end; { Receivers_Delete }

{:Returns index-th (0-based) item from the list.
}
function Receivers_Item(var receivers: TiraHookReceivers; index: integer): TiraHookReceiver;
begin
  Result := receivers.Receivers[index];
end; { Receivers_Item }

{ Exports }

{:Called from the DLL whenever a new process is attached. Creates local instance
  of hook wrappers.
}
procedure ProcessAttached;
begin
  wrappers := TiraHookWrappers.Create;
  {$IFDEF Debug_iraHook}
  DebugLog(Format('ProcessAttached: %d',[GetCurrentProcessID]));
  {$ENDIF Debug_iraHook}
end; { ProcessAttached }

{:Called from the DLL whenever a process is detached. Frees local instance of
  hook wrappers, removing all leftover hooks for that process in the process.
}
procedure ProcessDetached;
begin
  {$IFDEF Debug_iraHook}
  DebugLog(Format('ProcessDetached: %d',[GetCurrentProcessID]));
  {$ENDIF Debug_iraHook}
  wrappers.Free;
  wrappers := nil;
end; { ProcessDetached }

{:Attaches receiver to the specified hook. Installs hook if needed.
}
function AttachReceiver(hookType: TiraHookType; receiver: THandle; isFiltering: boolean): integer; stdcall;
begin
  {$IFDEF Debug_iraHook}
  DebugLog(Format('AttachReceiver: %d %d',[Ord(hookType),receiver]));
  {$ENDIF Debug_iraHook}
  Result := Wrappers.AttachReceiver(hookType,receiver,isFiltering);
end; { AttachReceiver }

{:Detaches receiver from the specified hook. Removes hook if nobody listens to
  it anymore.
}
function DetachReceiver(hookType: TiraHookType; receiver: THandle): integer; stdcall;
begin
  {$IFDEF Debug_iraHook}
  DebugLog(Format('DetachReceiver: %d %d',[Ord(hookType),receiver]));
  {$ENDIF Debug_iraHook}
  Result := Wrappers.DetachReceiver(hookType,receiver);
end; { DetachReceiver }

{:Returns last error code.
}
function LastError: DWORD; stdcall;
begin
  Result := Wrappers.LastError;
end; { LastError }

{ TiraHookWrapper }

{:Attaches receiver to the list and installs the hook if it was not installed
  before.
  @param    isFiltering If True, DLL will use SendMessage to send notifications
                        to the listener. Result of the SendMessage call will be
                        returned as the hook procedure result.
                        If False, DLL will use PostMessage to send notifications
                        to the listener.
}
function TiraHookWrapper.AttachReceiver(receiver: THandle; isFiltering: boolean): integer;
var
  iReceiver: integer;
begin
  {$IFDEF Debug_iraHook}
  DebugLog(Format('AttachReceiver: %d',[receiver]));
  {$ENDIF Debug_iraHook}
  Result := 0;
  if not assigned(wrpShared) then
    Exit;
  WaitForSingleObject(wrpHookMutex, INFINITE);
  try
    iReceiver := Receivers_IndexOf(wrpShared^.Receivers,receiver);
    {$IFDEF Debug_iraHook}
    DebugLog(Format('  IndexOf: %d',[iReceiver]));
    {$ENDIF Debug_iraHook}
    if iReceiver >= 0 then // already registered
      Result := ERROR_ALREADY_REGISTERED
    else begin
      // Add receiver into the global list
      if Receivers_Add(wrpShared^.Receivers,receiver,isFiltering) < 0 then
        Result := ERROR_TOO_MANY_RECEIVERS;
      // Add receiver into a per-process list
      Receivers_Add(wrpReceivers,receiver,isFiltering);
      {$IFDEF Debug_iraHook}
      DebugLog(Format('  Count: %d',[Receivers_Count(wrpShared^.Receivers)]));
      DebugLog(Format('  Per-process count: %d',[Receivers_Count(wrpReceivers)]));
      {$ENDIF Debug_iraHook}
      if Receivers_Count(wrpShared^.Receivers) = 1 then // first receiver - install the hook
        Result := Hook
      else
        Result := ERROR_NO_ERROR;
    end;
  finally ReleaseMutex(wrpHookMutex); end;
end; { TiraHookWrapper.AttachReceiver }

{:Sends a message to all listeners and set hook result.
}
procedure TiraHookWrapper.Broadcast(code: integer; wParam: WPARAM; lParam: LPARAM;  var Result: LRESULT);
var
  iReceiver: integer;
  msgRes   : DWORD;
  receiver : TiraHookReceiver;
  sentOK   : boolean;
begin
  iReceiver := 0;
  while iReceiver < Receivers_Count(wrpShared^.Receivers) do begin
    receiver := Receivers_Item(wrpShared^.Receivers,iReceiver);
    if receiver.Filtering then begin
      sentOK := SendMessageTimeout(receiver.Handle, WM_USER+code, wParam, lParam,
           SMTO_ABORTIFHUNG OR SMTO_BLOCK, 5000{ms}, msgRes) <> 0;
      if Result = 0 then
        Result := msgRes;
    end
    else 
      sentOK := PostMessage(receiver.Handle,WM_USER+code, wParam, lParam) or
        (GetLastError <> ERROR_INVALID_WINDOW_HANDLE);
    if sentOK then
      Inc(iReceiver)
    else
      Receivers_Delete(wrpShared^.Receivers,iReceiver);
  end;
end; { TiraHookWrapper.Broadcast }

{:Call next hook procedure and set hook result.
}
procedure TiraHookWrapper.CallNextHook(code: integer; wParam: WPARAM; lParam: LPARAM; var Result: LRESULT);
var
  res: LRESULT;
begin
  res := CallNextHookEx(wrpShared^.HookCallback, code, wParam, lParam);
  if Result = 0 then
    Result := res;
end; { TiraHookWrapper.CallNextHook }

{:Creates a hook wrapper. Creates synchronisation mutex and creates or attaches
  to the global hook data area (shared memory file).
}
constructor TiraHookWrapper.Create(baseName: string; hookType: integer; hookCallback: TFNHookProc);
var
  wasCreated: boolean;
begin
  {$IFDEF Debug_iraHook}
  wrpBaseName := baseName;
  {$ENDIF Debug_iraHook}


  wrpStatic.HookType := hookType;
  wrpStatic.HookCallback := hookCallback;
  Receivers_Clear(wrpReceivers);
  wrpHookMutex := CreateMutex_AllowEveryone(true, PChar(baseName + 'Mutex'));
  if wrpHookMutex = 0 then
    wrpLastError := GetLastError
  else begin
    try
      wrpMemFile := CreateFileMapping_AllowEveryone(INVALID_HANDLE_VALUE, PAGE_READWRITE,
        0, SizeOf(TiraSharedHookData), PChar(baseName + 'Shared'));
      if wrpMemFile = 0 then
        wrpLastError := GetLastError
      else begin
        wasCreated := (GetLastError = NO_ERROR);
        wrpShared := MapViewOfFile(wrpMemFile, FILE_MAP_WRITE, 0, 0, 0);
        if wrpShared = nil then
          wrpLastError := GetLastError
        else if wasCreated then
          FillChar(wrpShared^, SizeOf(TiraSharedHookData), 0);
      end;
    finally ReleaseMutex(wrpHookMutex); end;
  end;
end; { TiraHookWrapper.Create }

{:Destroys hook wrapper object. If any listener in this process is still in the
  list, removes it. If global list of listeners is empty at the end, removes
  the hook.
}
destructor TiraHookWrapper.Destroy;
var
  iReceiver: integer;
begin
  // Unhook still hooked receivers in this process.

  for iReceiver := Receivers_Count(wrpReceivers)-1 downto 0 do begin
    {$IFDEF Debug_iraHook}
    DebugLog(Format('Removing still attached receiver: %d',
      [Receivers_Item(wrpReceivers,iReceiver).Handle]));
    {$ENDIF Debug_iraHook}
    DetachReceiver(Receivers_Item(wrpReceivers,iReceiver).Handle);
  end;
  UnmapViewOfFile(wrpShared);
  CloseHandle(wrpMemFile);
  CloseHandle(wrpHookMutex);
  inherited;
end; { TiraHookWrapper.Destroy }

{:Detaches receiver from the specified hook. Removes hook if nobody listens to it
  anymore.
}
function TiraHookWrapper.DetachReceiver(receiver: THandle): integer;
var
  iReceiver: integer;
begin
  {$IFDEF Debug_iraHook}
  DebugLog(Format('DetachReceiver: %d',[receiver]));
  {$ENDIF Debug_iraHook}
  Result := 0;
  if not assigned(wrpShared) then
    Exit;
  WaitForSingleObject(wrpHookMutex, INFINITE);
  try
    iReceiver := Receivers_IndexOf(wrpShared^.Receivers,receiver);
    {$IFDEF Debug_iraHook}
    DebugLog(Format('  IndexOf: %d',[iReceiver]));
    {$ENDIF Debug_iraHook}
    if iReceiver < 0 then // not registered
      Result := ERROR_NOT_REGISTERED
    else begin
      // Remove receiver from a per-process list
      Receivers_Delete(wrpReceivers,Receivers_IndexOf(wrpReceivers,receiver));
      // Remove receiver from the global list
      Receivers_Delete(wrpShared^.Receivers,iReceiver);
      {$IFDEF Debug_iraHook}
      DebugLog(Format('  Count: %d',[Receivers_Count(wrpShared^.Receivers)]));
      DebugLog(Format('  Per-process count: %d',[Receivers_Count(wrpReceivers)]));
      {$ENDIF Debug_iraHook}
      if Receivers_Count(wrpShared^.Receivers) = 0 then // last receiver - unhook
        Result := Unhook
      else
        Result := 0;
    end;
  finally ReleaseMutex(wrpHookMutex); end;
end; { TiraHookWrapper.DetachReceiver }

{:Installs systemwide hook.
}
function TiraHookWrapper.Hook: integer;
begin
  Result := 0;
  if not assigned(wrpShared) then
    Exit;
  WaitForSingleObject(wrpHookMutex, INFINITE);
  try
    if wrpShared^.HookCallback <> 0 then
      Result := ERROR_ALREADY_HOOKED
    else begin
      {$IFDEF Debug_iraHook}
      DebugLog('Hooking '+wrpBaseName);
      {$ENDIF Debug_iraHook}
      wrpShared^.HookCallback :=
        SetWindowsHookEx(wrpStatic.HookType,wrpStatic.HookCallback,HInstance,0);
      if wrpShared^.HookCallback = 0 then
        Result := GetLastError;
    end;
  finally ReleaseMutex(wrpHookMutex); end;
end; { TiraHookWrapper.Hook }

{:Removes systemwide hook.
}
function TiraHookWrapper.Unhook: integer;
begin
  Result := 0;
  if not assigned(wrpShared) then
    Exit;
  WaitForSingleObject(wrpHookMutex, INFINITE);
  try
    if wrpShared^.HookCallback <> 0 then begin
      {$IFDEF Debug_iraHook}
      DebugLog('Unhooking '+wrpBaseName);
      {$ENDIF Debug_iraHook}
      if not UnhookWindowsHookEx(wrpShared^.HookCallback) then
        Result := GetLastError;
      wrpShared^.HookCallback := 0;
    end;
    Receivers_Clear(wrpShared^.Receivers);
  finally ReleaseMutex(wrpHookMutex); end;
end; { TiraHookWrapper.Unhook }

{ TiraHookWrappers }

{:Attaches receiver to the specified hook. Installs hook if needed.
}
function TiraHookWrappers.AttachReceiver(hookType: TiraHookType;
  receiver: THandle; isFiltering: boolean): integer;
begin
  Result := wrpWrappers[hookType].AttachReceiver(receiver,isFiltering);
end; { TiraHookWrappers.AttachReceiver }

{:Sends a message to all listeners and set hook result.
}
procedure TiraHookWrappers.Broadcast(hookType: TiraHookType; code: integer;
  wParam: WPARAM; lParam: LPARAM; var Result: LRESULT);
begin
  if assigned(wrpWrappers[hookType]) then
    wrpWrappers[hookType].Broadcast(code,wParam,lParam,Result);
end; { TiraHookWrappers.Broadcast }

{:Call next hook procedure for the specified hook and set hook result.
}
procedure TiraHookWrappers.CallNextHook(hookType: TiraHookType;
  code: integer; wParam: WPARAM; lParam: LPARAM; var Result: LRESULT);
begin
  if assigned(wrpWrappers[hookType]) then
    wrpWrappers[hookType].CallNextHook(code,wParam,lParam,Result);
end; { TiraHookWrappers.CallNextHook }

{:Creates wrappers for all supported hooks.
}
constructor TiraHookWrappers.Create;
var
  irahBaseName: array [0..MAX_PATH] of char;
  strBaseName: string;
begin
  if GetModuleFileName(HInstance, irahBaseName, SizeOf(irahBaseName)-1)= 0 then begin
    MessageBox(0,'iraHook','Failed to retrieve own module name!',MB_OK);
    Halt;
  end;
  strBaseName := 'IRA_HOOK_'+ChangeFileExt(ExtractFileName(irahBaseName),'')+'_';
  wrpWrappers[htShell] :=
    TiraHookWrapper.Create(strBaseName+'SHELL', WH_SHELL, @ShellHookCallback);
  wrpWrappers[htKeyboard] :=
    TiraHookWrapper.Create(strBaseName+'KEYBOARD', WH_KEYBOARD, @KbdHookCallback);
  wrpWrappers[htMouse] :=
    TiraHookWrapper.Create(strBaseName+'MOUSE', WH_MOUSE, @MouseHookCallback);
  wrpWrappers[htCBT] :=
    TiraHookWrapper.Create(strBaseName+'CBT', WH_CBT, @CBTHookCallback);




end; { TiraHookWrappers.Create }

{:Destroys wrappers for all supported hooks, removing all active listeners from
  this process in the process.
}
destructor TiraHookWrappers.Destroy;
var
  iWrapper: TiraHookType;
begin
  for iWrapper := Low(TiraHookType) to High(TiraHookType) do begin
    wrpWrappers[iWrapper].Free;
    wrpWrappers[iWrapper] := nil;
  end;
end; { TiraHookWrappers.Destroy }

{:Detaches receiver from the specified hook. Removes hook if nobody listens to
  it anymore.
}
function TiraHookWrappers.DetachReceiver(hookType: TiraHookType;
  receiver: THandle): integer;
begin
  Result := wrpWrappers[hookType].DetachReceiver(receiver);
end; { TiraHookWrappers.DetachReceiver }

{:Returns specified hook wrapper.
}
function TiraHookWrappers.GetItems(idx: TiraHookType): TiraHookWrapper;
begin
  Result := wrpWrappers[idx];
end; { TiraHookWrappers.GetItems }

{:Returns last error code of the first wrapper that is in the error state.
}
function TiraHookWrappers.LastError: DWORD;
var
  iWrapper: TiraHookType;
begin
  Result := 0;
  for iWrapper := Low(TiraHookType) to High(TiraHookType) do
    if wrpWrappers[iWrapper].LastError <> NO_ERROR then begin
      Result := wrpWrappers[iWrapper].LastError;
      break; //for
    end;
end; { TiraHookWrappers.LastError }

end.
