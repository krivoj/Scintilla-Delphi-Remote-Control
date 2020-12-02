unit iraHookComp;

interface

uses
  SysUtils, 
  Windows,
  Messages,
  Classes,
  Controls,
  iraHookCommon;

type
  {:Unfiltered event signature. This event reports all received hook messages
    before they are processed. Application can prevent further processing of
    these messages by setting Handled to True. This only effects component
    that triggered the unfiltered event - hooked message will not be filtered
    and will be delivered to the target process (most probably it already was
    delivered when process receives this event).
  }
  TiraSysHookUnfilteredEvent = procedure(Sender: TObject; Code, wParam, lParam: longint; var Handled: boolean) of object;

  {:Base parent for all systemwide hook component wrappers.
  }
  TiraSysHook = class(TComponent)
  private
    FActive      : boolean;
    FHookDLLName : string;
    FIsFiltering : boolean;
    FListenerWnd : THandle;
    FOnUnfiltered: TiraSysHookUnfilteredEvent;
    procedure HookMain(var Message: TMessage);
    procedure SetFiltering(const Value: boolean);
    property  AllowFiltering: boolean read FIsFiltering write SetFiltering;
  protected
    class function HookType: TiraHookType; virtual; abstract;
    function  MyName: string; virtual;
    procedure ProcessMessage(var Message: TMessage); virtual; abstract;
    procedure SetHookDLLName(const Value: string); virtual;
    procedure DoUnfiltered(code, wParam, lParam: longint;  var handled: boolean); virtual;
  public
    destructor  Destroy; override;
    function  Start: string;
    procedure Stop;
    property  Active: boolean read FActive;
  published
    property  HookDLL: string read FHookDLLName write SetHookDLLName;
    property  OnUnfiltered: TiraSysHookUnfilteredEvent read FOnUnfiltered write FOnUnfiltered;
  end; { TiraSysHook }

  {:Shell hook Accessibility event signature. 
  }
  TiraShellHookAccesibilityEvent = procedure(Sender: TObject; changedFeature: longint) of object;

  {:Shell hook notification event signature.
  }
  TiraShellNotifyEvent = procedure(Sender: TObject) of object;

  {:Shell hook notification event with window handle signature.
  }
  TiraShellNotifyWindowEvent = procedure(Sender: TObject; sourceWindow: THandle) of object;

  {:Shell hook Title redraw event signature.
  }
  TiraShellTitleRedrawEvent = procedure(Sender: TObject; sourceWindow: THandle; isFlashing: boolean) of object;

  {:WH_SHELL hook wrapper.
  }
  TiraShellHook = class(TiraSysHook)
  private
    FNotifyOwnEvents            : boolean;
    FOnAccessibilityStateChanged: TiraShellHookAccesibilityEvent;
    FOnActivateShellWindow      : TiraShellNotifyEvent;
    FOnLanguageChange           : TiraShellNotifyWindowEvent;
    FOnTaskManager              : TiraShellNotifyEvent;
    FOnWindowActivated          : TiraShellNotifyWindowEvent;
    FOnWindowCreated            : TiraShellNotifyWindowEvent;
    FOnWindowDestroyed          : TiraShellNotifyWindowEvent;
    FOnWindowTitleRedraw        : TiraShellTitleRedrawEvent;
  protected
    class function HookType: TiraHookType; override;
    procedure ProcessMessage(var Message: TMessage); override;
    procedure DoAccessibilityStateChanged(changedFeature: longint); virtual;
    procedure DoActivateShellWindow; virtual;
    procedure DoLanguageChange(sourceWindow: THandle); virtual;
    procedure DoWindowTitleRedraw(sourceWindow: THandle; isFlashing: boolean); virtual;
    procedure DoTaskManager; virtual;
    procedure DoWindowActivated(sourceWindow: THandle); virtual;
    procedure DoWindowCreated(sourceWindow: THandle); virtual;
    procedure DoWindowDestroyed(sourceWindow: THandle); virtual;
  published
    property  NotifyOwnEvents: boolean read FNotifyOwnEvents write FNotifyOwnEvents;
    property  OnAccessibilityStateChanged: TiraShellHookAccesibilityEvent read FOnAccessibilityStateChanged write FOnAccessibilityStateChanged;
    property  OnActivateShellWindow: TiraShellNotifyEvent read FOnActivateShellWindow write FOnActivateShellWindow;
    property  OnLanguageChange: TiraShellNotifyWindowEvent read FOnLanguageChange write FOnLanguageChange;
    property  OnTaskManager: TiraShellNotifyEvent read FOnTaskManager write FOnTaskManager;
    property  OnWindowActivated: TiraShellNotifyWindowEvent read FOnWindowActivated write FOnWindowActivated;
    property  OnWindowCreated: TiraShellNotifyWindowEvent read FOnWindowCreated write FOnWindowCreated;
    property  OnWindowDestroyed: TiraShellNotifyWindowEvent read FOnWindowDestroyed write FOnWindowDestroyed;
    property  OnWindowTitleRedraw: TiraShellTitleRedrawEvent read FOnWindowTitleRedraw write FOnWindowTitleRedraw;
  end; { TiraShellHook }

  {:Keyboard hook notification event signature.
  }
  TiraKeyboardNotifyEvent = procedure(Sender: TObject; VirtualKeyCode: longint;
    RepeatCount: word; ScanCode: byte; isExtendedKey, altIsDown,
    keyWasDownBefore, keyIsBeiniraressed: boolean;
    var filterEvent: boolean) of object;

  {:WH_KEYBOARD hook wrapper.
  }
  TiraKeyboardHook = class(TiraSysHook)
  private
    FOnKeyAction: TiraKeyboardNotifyEvent;
  protected
    class function HookType: TiraHookType; override;
    procedure ProcessMessage(var Message: TMessage); override;
    procedure DoKeyAction(VirtualKeyCode: longint; RepeatCount: word;
      ScanCode: byte; isExtendedKey, altIsDown, keyWasDownBefore,
      keyIsBeiniraressed: boolean; var filterEvent: boolean); virtual;
  published
    property  AllowFiltering;
    property  OnKeyAction: TiraKeyboardNotifyEvent
      read FOnKeyAction write FOnKeyAction;
  end; { TiraKeyboardHook }

  {:All possible type of mouse button movement.
  }
  TiraMouseButtonMovement = (mbmDown, mbmUp, mbmDouble);

  {:Mouse hook click notification signature.
  }
  TiraMouseClickNotifyEvent = procedure(Sender: TObject; sourceWindow: THandle;
    x, y: integer; button: TMouseButton;
    movement: TiraMouseButtonMovement) of object;

  {:Mouse hook movement notification signature.
  }
  TiraMouseMoveNotifyEvent = procedure(Sender: TObject; sourceWindow: THandle; x, y: integer) of object;

  {:WH_MOUSE hook wrapper.
  }
  TiraMouseHook = class(TiraSysHook)
  private
    FOnMouseClick: TiraMouseClickNotifyEvent;
    FOnMouseMove: TiraMouseMoveNotifyEvent;
  protected
    class function HookType: TiraHookType; override;
    procedure ProcessMessage(var Message: TMessage); override;
    procedure DoMouseClick(sourceWindow: THandle; x, y: integer; button: TMouseButton; movement: TiraMouseButtonMovement); virtual;
    procedure DoMouseMove(sourceWindow: THandle; x, y: integer); virtual;
  published
    property  OnMouseClick: TiraMouseClickNotifyEvent read FOnMouseClick write FOnMouseClick;
    property  OnMouseMove: TiraMouseMoveNotifyEvent  read FOnMouseMove write FOnMouseMove;
  end; { TiraMouseHook }

  TiraCBTActivateEvent = procedure(Sender: TObject; newWindow, activeWindow: THandle) of object;

  TiraCBTClickSkippedEvent = procedure(Sender: TObject; targetWindow: THandle; mouseMessage: longint) of object;

  TiraCBTNotifyWindowEvent  = procedure(Sender: TObject; windowHandle: THandle) of object;

  TiraCBTKeySkippedEvent = procedure(Sender: TObject; VirtualKeyCode: longint; RepeatCount: word; ScanCode: byte; isExtendedKey, altIsDown,
    keyWasDownBefore, keyIsBeiniraressed: boolean) of object;

  TiraCBTMinMaxEvent = procedure(Sender: TObject; targetWindow: THandle; showValue: word) of object;

  TiraCBTNotifyEvent = procedure(Sender: TObject) of object;

  TiraCBTSetFocusEvent = procedure(Sender: TObject; newWindow, oldWindow: THandle) of object;

  TiraCBTSysCommandEvent = procedure(Sender: TObject; sysCommand: longint) of object;

  TiraCBTHook = class(TiraSysHook)
  private
    FOnActivate    : TiraCBTActivateEvent;
    FOnClickSkipped: TiraCBTClickSkippedEvent;
    FOnCreateWnd   : TiraCBTNotifyWindowEvent;
    FOnDestroyWnd  : TiraCBTNotifyWindowEvent;
    FOnKeySkipped  : TiraCBTKeySkippedEvent;
    FOnMinMax      : TiraCBTMinMaxEvent;
    FOnMoveSize    : TiraCBTNotifyWindowEvent;
    FOnQueueSync   : TiraCBTNotifyEvent;
    FOnSetFocus    : TiraCBTSetFocusEvent;
    FOnSysCommand  : TiraCBTSysCommandEvent;
  protected
    class function HookType: TiraHookType; override;
    procedure ProcessMessage(var Message: TMessage); override;
    procedure DoActivate(newWindow, activeWindow: THandle); virtual;
    procedure DoClickSkipped(targetWindow: THandle; mouseMessage: longint); virtual;
    procedure DoCreateWnd(newWindow: THandle); virtual;
    procedure DoDestroyWnd(goneWindow: THandle); virtual;
    procedure DoKeySkipped(VirtualKeyCode: longint; RepeatCount: word; ScanCode: byte; isExtendedKey, altIsDown, keyWasDownBefore,
      keyIsBeiniraressed: boolean); virtual;
    procedure DoMinMax(targetWindow: THandle; showValue: word); virtual;
    procedure DoMoveSize(targetWindow: THandle); virtual;
    procedure DoQueueSync; virtual;
    procedure DoSetFocus(newWindow, oldWindow: THandle); virtual;
    procedure DoSysCommand(sysCommand: longint); virtual;
  published
    property OnActivate: TiraCBTActivateEvent read FOnActivate write FOnActivate;
    property OnClickSkipped: TiraCBTClickSkippedEvent read FOnClickSkipped write FOnClickSkipped;
    property OnCreateWnd: TiraCBTNotifyWindowEvent read FOnCreateWnd write FOnCreateWnd;
    property OnDestroyWnd: TiraCBTNotifyWindowEvent read FOnDestroyWnd write FOnDestroyWnd;
    property OnKeySkipped: TiraCBTKeySkippedEvent read FOnKeySkipped write FOnKeySkipped;
    property OnMinMax: TiraCBTMinMaxEvent read FOnMinMax write FOnMinMax;
    property OnMoveSize: TiraCBTNotifyWindowEvent read FOnMoveSize write FOnMoveSize;
    property OnQueueSync: TiraCBTNotifyEvent read FOnQueueSync write FOnQueueSync;
    property OnSetFocus: TiraCBTSetFocusEvent read FOnSetFocus write FOnSetFocus;
    property OnSysCommand: TiraCBTSysCommandEvent read FOnSysCommand write FOnSysCommand;
  end; { TiraCBTHook }

  procedure Register;

implementation

uses
  Forms,
  DSiWin32,
  iraHookLoader;


procedure Register;
begin
  RegisterComponents('ira',[TiraShellHook,TiraKeyboardHook,TiraMouseHook,TiraCBTHook]);
end; { Register }

destructor TiraSysHook.Destroy;
begin
  Stop;
  inherited;
end; { TiraSysHook.Destroy }

procedure TiraSysHook.DoUnfiltered(code, wParam, lParam: longint;   var handled: boolean);
begin
  if assigned(FOnUnfiltered) then
    FOnUnfiltered(Self,code,wParam,lParam,handled);
end; { TiraSysHook.DoUnfiltered }

procedure TiraSysHook.HookMain(var Message: TMessage);
begin
  if Message.Msg < WM_USER then
    with Message do
      Result := DefWindowProc(FListenerWnd, Msg, wParam, lParam)
  else
    ProcessMessage(Message);
end; { TiraSysHook.HookMain }

//Solo per error reporting.
function TiraSysHook.MyName: string;
begin
  if Name <> '' then
    Result := Name
  else
    Result := ClassName;
end;

procedure TiraSysHook.SetFiltering(const Value: boolean);
begin
  if Active then
    raise Exception.Create('hook is active!');
  FIsFiltering := Value;
end;

// Setta il nome della DLL
procedure TiraSysHook.SetHookDLLName(const Value: string);
begin
  if FActive then
    MessageBox(0, PChar('can''t change DLL name while hook is active!'),
      PChar(MyName), MB_OK + MB_ICONERROR)
  else
    FHookDLLName := Value;
end;

function TiraSysHook.Start: string;
var
  hookRes: integer;
begin
  if not FActive then begin
    if FHookDLLName = '' then
      Result := 'Missing DLL name!'
    else begin
      hookRes := LoadHookDLL(FHookDllName);
      if hookRes <> 0 then
        Result := HookError(hookRes)
      else begin
        FListenerWnd := DSiAllocateHwnd(HookMain);
        if FListenerWnd = 0 then
          Result := 'Listener Error'
        else begin
          hookRes := fnAttachReceiver(HookType,FListenerWnd,FIsFiltering);
          if hookRes <> 0 then begin
            DSiDeallocateHWnd(FListenerWnd);
            FListenerWnd := 0;
            Result := HookError(hookRes);
          end
          else begin
            Result := '';
            FActive := true;
          end;
        end;
      end;
    end;
  end;
end;

procedure TiraSysHook.Stop;
begin
  if FActive then begin
    if FListenerWnd <> 0 then begin
      DSiDeallocateHWnd(FListenerWnd);
      FListenerWnd := 0;
    end;
    UnloadHookDLL;
    FActive := false;
  end;
end;


{:Forwarder}
procedure TiraShellHook.DoAccessibilityStateChanged(changedFeature: longint);
begin
  if assigned(FOnAccessibilityStateChanged) then
    FOnAccessibilityStateChanged(self, changedFeature);
end;

procedure TiraShellHook.DoActivateShellWindow;
begin
  if assigned(FOnActivateShellWindow) then
    FOnActivateShellWindow(self);
end;

procedure TiraShellHook.DoLanguageChange(sourceWindow: THandle);
begin
  if assigned(FOnLanguageChange) then
    FOnLanguageChange(self,sourceWindow)
end;

procedure TiraShellHook.DoTaskManager;
begin
  if assigned(FOnTaskManager) then
    FOnTaskManager(self);
end;

procedure TiraShellHook.DoWindowActivated(sourceWindow: THandle);
begin
  if assigned(FOnWindowActivated) then
    FOnWindowActivated(self,sourceWindow);
end;

procedure TiraShellHook.DoWindowCreated(sourceWindow: THandle);
begin
  if assigned(FOnWindowCreated) then
    FOnWindowCreated(self,sourceWindow);
end;

procedure TiraShellHook.DoWindowDestroyed(sourceWindow: THandle);
begin
  if assigned(FOnWindowDestroyed) then
    FOnWindowDestroyed(self,sourceWindow);
end;

procedure TiraShellHook.DoWindowTitleRedraw(sourceWindow: THandle;
  isFlashing: boolean);
begin
  if assigned(FOnWindowTitleRedraw) then
    FOnWindowTitleRedraw(self,sourceWindow,isFlashing);
end;

class function TiraShellHook.HookType: TiraHookType;
begin
  Result := htShell;
end;

procedure TiraShellHook.ProcessMessage(var Message: TMessage);
var
  code   : DWORD;
  handled: boolean;
begin
  if Message.Msg >= WM_USER then begin
    Message.Result := 0;
    code := Message.msg-WM_USER;
    handled := false;
    DoUnfiltered(code,Message.wParam,Message.lParam,  handled);
    if not handled then begin
      case code of
        HSHELL_ACCESSIBILITYSTATE :
          DoAccessibilityStateChanged(Message.wParam);
        HSHELL_ACTIVATESHELLWINDOW:
          DoActivateShellWindow;
        HSHELL_LANGUAGE:
          if (HWND(Message.wParam) <> Application.Handle) or NotifyOwnEvents then
            DoLanguageChange(Message.wParam);
        HSHELL_REDRAW:
          if (HWND(Message.wParam) <> Application.Handle) or NotifyOwnEvents then
            DoWindowTitleRedraw(Message.wParam,Message.lParam <> 0);
        HSHELL_TASKMAN:
          DoTaskManager;
        HSHELL_WINDOWACTIVATED:
          if (HWND(Message.wParam) <> Application.Handle) or NotifyOwnEvents then
            DoWindowActivated(Message.wParam);
        HSHELL_WINDOWCREATED:
          if (HWND(Message.wParam) <> Application.Handle) or NotifyOwnEvents then
            DoWindowCreated(Message.wParam);
        HSHELL_WINDOWDESTROYED:
          if (HWND(Message.wParam) <> Application.Handle) or NotifyOwnEvents then
            DoWindowDestroyed(Message.wParam);
      end; //case
    end;
  end;
end; { TiraShellHook.ProcessMessage }

{ TiraKeyboardHook }

{:Forwarder for the OnKeyAction event.
}
procedure TiraKeyboardHook.DoKeyAction(VirtualKeyCode: longint;
  RepeatCount: word; ScanCode: byte; isExtendedKey, altIsDown, keyWasDownBefore,
  keyIsBeiniraressed: boolean; var filterEvent: boolean);
begin
  if assigned(FOnKeyAction) then
    FOnKeyAction(self,VirtualKeyCode,RepeatCount,ScanCode,isExtendedKey,
      altIsDown,keyWasDownBefore,keyIsBeiniraressed,filterEvent);
end; { TiraKeyboardHook.DoKeyAction }

{:Returns type of this hook.
}
class function TiraKeyboardHook.HookType: TiraHookType;
begin
  Result := htKeyboard;
end; { TiraKeyboardHook.HookType }

{:Dispatch hook messages.
}
procedure TiraKeyboardHook.ProcessMessage(var Message: TMessage);
var
  code       : DWORD;
  filter     : boolean;
  flags      : byte;
  handled    : boolean;
  repeatCount: word;
  scanCode   : byte;
begin
  if Message.Msg >= WM_USER then begin
    Message.Result := 0;
    code := Message.msg-WM_USER;
    handled := false;
    DoUnfiltered(code,Message.wParam,Message.lParam, handled);
    if not handled then begin
      if code = HC_ACTION then begin
        repeatCount := Message.lParam AND $FFFF;
        scanCode    := (Message.lParam SHR 16) AND $FF;
        flags       := Message.lParam SHR 24;
        filter := false;
        DoKeyAction(Message.wParam, repeatCount, scanCode,
          (flags AND 1) <> 0, (flags AND 32) <> 0, (flags AND 64) <> 0,
          (flags AND 128) = 0, filter);
        if Filter then
          Message.Result := 1;
      end;
    end;
  end;
end; { TiraKeyboardHook.ProcessMessage }

{ TiraMouseHook }

{:Forwarder for the OnMouseClick event.
}
procedure TiraMouseHook.DoMouseClick(sourceWindow: THandle; x, y: integer;   button: TMouseButton; movement: TiraMouseButtonMovement);
begin
  if assigned(FOnMouseClick) then
    FOnMouseClick(self, sourceWindow, x, y, button, movement);
end; { TiraMouseHook.DoMouseClick }

{:Forwarder for the OnMouseMove event.
}
procedure TiraMouseHook.DoMouseMove(sourceWindow: THandle; x, y: integer);
begin
  if assigned(FOnMouseMove) then
    FOnMouseMove(self, sourceWindow, x, y);
end; { TiraMouseHook.DoMouseMove }

{:Returns type of this hook.
}
class function TiraMouseHook.HookType: TiraHookType;
begin
  Result := htMouse;
end; { TiraMouseHook.HookType }

{:Dispatch hook messages.
}
procedure TiraMouseHook.ProcessMessage(var Message: TMessage);
var
  button  : TMouseButton;
  code    : DWORD;
  handled : boolean;
  movement: TiraMouseButtonMovement;
  x       : integer;
  y       : integer;
begin
  if Message.Msg >= WM_USER then begin
    Message.Result := 0;
    code := Message.msg-WM_USER;
    handled := false;
    DoUnfiltered(code,Message.wParam, Message.LParam , handled);
    if not handled then begin
      x := Message.wParam AND $FFFF;
      y := (Message.wParam SHR 16) AND $FFFF;
      if (code AND $F) = 0 then
        DoMouseMove(Message.lParam,x,y)
      else begin
        case ((code AND $F)-1) div 3 of
          0: button := mbLeft;
          1: button := mbRight;
          2: button := mbMiddle;
          else button := mbLeft; //fallback
        end; //case
        case ((code AND $F)-1) mod 3 of
          0: movement := mbmDown;
          1: movement := mbmUp;
          2: movement := mbmDouble;
          else {cannot happen} movement := mbmDown; {to keep Delphi happy}
        end; //case
        DoMouseClick(Message.lParam,x,y,button,movement);
      end;
    end;
  end;
end; { TiraMouseHook.ProcessMessage }

{ TiraCBTHook }

procedure TiraCBTHook.DoActivate(newWindow, activeWindow: THandle);
begin
  if assigned(FOnActivate) then
    FOnActivate(self, newWindow, activeWindow);
end; { TiraCBTHook.DoActivate }

procedure TiraCBTHook.DoClickSkipped(targetWindow: THandle;
  mouseMessage: longint);
begin
  if assigned(FOnClickSkipped) then
    FOnClickSkipped(self, targetWindow, mouseMessage);
end; { TiraCBTHook.DoClickSkipped }

procedure TiraCBTHook.DoCreateWnd(newWindow: THandle);
begin
  if assigned(FOnCreateWnd) then
    FOnCreateWnd(self, newWindow);
end; { TiraCBTHook.DoCreateWnd }

procedure TiraCBTHook.DoDestroyWnd(goneWindow: THandle);
begin
  if assigned(FOnDestroyWnd) then
    FOnDestroyWnd(self, goneWindow);
end; { TiraCBTHook.DoDestroyWnd }

procedure TiraCBTHook.DoKeySkipped(VirtualKeyCode: longint; RepeatCount: word;
  ScanCode: byte; isExtendedKey, altIsDown, keyWasDownBefore,
  keyIsBeiniraressed: boolean);
begin
  if assigned(FOnKeySkipped) then
    FOnKeySkipped(self, VirtualKeyCode, RepeatCount, ScanCode, isExtendedKey,
      altIsDown, keyWasDownBefore, keyIsBeiniraressed);
end; { TiraCBTHook.DoKeySkipped }

procedure TiraCBTHook.DoMinMax(targetWindow: THandle; showValue: word);
begin
  if assigned(FOnMinMax) then
    FOnMinMax(self, targetWindow, showValue);
end; { TiraCBTHook.DoMinMax }

procedure TiraCBTHook.DoMoveSize(targetWindow: THandle);
begin
  if assigned(FOnMoveSize) then
    FOnMoveSize(self, targetWindow);
end; { TiraCBTHook.DoMoveSize }

procedure TiraCBTHook.DoQueueSync;
begin
  if assigned(FOnQueueSync) then
    FOnQueueSync(self);
end; { TiraCBTHook.DoQueueSync }

procedure TiraCBTHook.DoSetFocus(newWindow, oldWindow: THandle);
begin
  if assigned(FOnSetFocus) then
    FOnSetFocus(self, newWindow, oldWindow);
end; { TiraCBTHook.DoSetFocus }

procedure TiraCBTHook.DoSysCommand(sysCommand: longint);
begin
  if assigned(FOnSysCommand) then
    FOnSysCommand(self, sysCommand);
end; { TiraCBTHook.DoSysCommand }

{:Returns type of this hook.
}
class function TiraCBTHook.HookType: TiraHookType;
begin
  Result := htCBT;
end; { TiraCBTHook.HookType }

{:Dispatch hook messages.
}
procedure TiraCBTHook.ProcessMessage(var Message: TMessage);
var
  code       : DWORD;
  flags      : byte;
  handled    : boolean;
  repeatCount: word;
  scanCode   : byte;
begin
  if Message.Msg >= WM_USER then begin
    Message.Result := 0;
    code := Message.msg-WM_USER;
    handled := false;
    DoUnfiltered(code,Message.wParam,Message.lParam, handled);
    if not handled then begin
      case code of
        HCBT_ACTIVATE:
          DoActivate(Message.wParam,Message.lParam);
        HCBT_CLICKSKIPPED:
          DoClickSkipped(Message.lParam,Message.wParam);
        HCBT_CREATEWND:
          DoCreateWnd(Message.wParam);
        HCBT_DESTROYWND:
          DoDestroyWnd(Message.wParam);
        HCBT_KEYSKIPPED:
          begin
            repeatCount := Message.lParam AND $FFFF;
            scanCode    := (Message.lParam SHR 16) AND $FF;
            flags       := Message.lParam SHR 24;
            DoKeySkipped(Message.wParam, repeatCount, scanCode,
              (flags AND 1) <> 0, (flags AND 32) <> 0, (flags AND 64) <> 0,
              (flags AND 128) = 0);
          end; // HCBT_KEYSKIPPED
        HCBT_MINMAX:
          DoMinMax(Message.wParam,Message.LParamLo);
        HCBT_MOVESIZE:
          DoMoveSize(Message.wParam);
        HCBT_QS:
          DoQueueSync;
        HCBT_SETFOCUS:
          DoSetFocus(Message.wParam,Message.lParam);
        HCBT_SYSCOMMAND:
          DoSysCommand(Message.wParam);
      end; //case
    end;
  end;
end; { TiraCBTHook.ProcessMessage }

end.
