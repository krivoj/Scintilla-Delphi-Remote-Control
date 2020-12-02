unit iraHookLoader;

interface

uses
  Windows,
  iraHookCommon;

type
  TFNAttachReceiver = function (hookType: TiraHookType; receiver: THandle; isFiltering: boolean): integer; stdcall;
  TFNDetachReceiver = function (hookType: TiraHookType; receiver: THandle): integer; stdcall;
  TFNLastError      = function (): DWORD; stdcall;
var
  // Setto i puntatori alle funzioni di attach, detach e Lasterror
  fnAttachReceiver: TFNAttachReceiver;
  fnDetachReceiver: TFNDetachReceiver;
  fnLastError     : TFNLastError;

  function  LoadHookDLL(dllName: string): integer;

  procedure UnloadHookDLL;

  function  HookError(errorCode: integer): string;

implementation

uses
  SysUtils;


var
  dllHandle: HINST;
  dllCount : integer;

  function LoadHookDLL(dllName: string): integer;
  begin
    if dllHandle = 0 then begin
      dllHandle := LoadLibrary(PChar(dllName));
      if (dllHandle = 0) and (not SameText(ExtractFileExt(dllName),'.dll')) then
        dllHandle := LoadLibrary(PChar(ChangeFileExt(dllName,'.dll')));
      if dllHandle = 0 then
        Result := GetLastError
      else begin
        Inc(dllCount);
        @fnAttachReceiver := GetProcAddress(dllHandle,'AttachReceiver');
        @fnDetachReceiver := GetProcAddress(dllHandle,'DetachReceiver');
        @fnLastError      := GetProcAddress(dllHandle,'LastError');
        if (@fnAttachReceiver = nil) or
           (@fnDetachReceiver = nil) or
           (@fnLastError = nil) then
        begin                            
          Result := ERROR_EXPORTS;
          UnloadHookDLL;
        end
        else
          Result := 0;
      end;
    end
    else begin
      Inc(dllCount);
      Result := 0;
    end;
  end;

  procedure UnloadHookDLL;
  begin
    if dllHandle <> 0 then begin
      Dec(dllCount);
      if dllCount <= 0 then begin
        FreeLibrary(dllHandle);
        dllHandle := 0;
        dllCount := 0;
        @fnAttachReceiver := nil;
        @fnDetachReceiver := nil;
        @fnLastError      := nil;
      end;
    end;
  end;

  function HookError(errorCode: integer): string;
  begin
    if errorCode > 0 then
      Result := SysErrorMessage(errorCode)
    else if (errorCode >= Low(HookErrors)) and
            (errorCode <= High(HookErrors)) then
      Result := HookErrors[errorCode]
    else
      Result := Format('Error %d',[errorCode]);
  end;
  
initialization
  dllHandle := 0;
  dllCount := 0;
  fnAttachReceiver := nil;
  fnDetachReceiver := nil;
  fnLastError      := nil;
finalization
  if dllHandle <> 0 then
    MessageBox(0, 'iraHook DLL was not unloaded!', 'iraHookLoader', MB_OK + MB_ICONWARNING);
end.
