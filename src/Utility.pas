unit Utility;
interface


uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
Registry,SHDocVw,ShlObj,mshtml,  macadress,SHDocVW_TLB, MSHTML_TLB, ActiveX, OleCtrls,TlHelp32;


PROCEDURE EnableSysKeys(Enable: Boolean);    // Only Win98, WinME
procedure EnableAllPrivileges;
Function IsNT: Boolean;
function GetWindowExeName(Handle: THandle): String;
function GetWorkgroupName_ME: string;
function WinExit(flags: integer): boolean;
function SetPrivilege(privilegeName: string; enable: boolean): boolean;
implementation
function WinExit(flags: integer): boolean;
  function SetPrivilege(privilegeName: string; enable: boolean): boolean;
  var tpPrev,
      tp : TTokenPrivileges;
      token : THandle;
      dwRetLen : DWord;
  begin
    result := False;
    OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, token);
    tp.PrivilegeCount := 1;
    if LookupPrivilegeValue(nil, pchar(privilegeName), tp.Privileges[0].LUID) then
    begin
      if enable then
        tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED
      else
        tp.Privileges[0].Attributes := 0;
      dwRetLen := 0;
      result := AdjustTokenPrivileges(token, False, tp, SizeOf(tpPrev), tpPrev, dwRetLen);
    end;
    CloseHandle(token);
  end;
begin
  if SetPrivilege('SeShutdownPrivilege', true) then begin
    ExitWindowsEx(flags, 0);
    SetPrivilege('SeShutdownPrivilege', False)
  end;
end;

function GetWorkgroupName_ME: string;
//---------------------------------------------------------------------
var
  Reg: TRegistry;
begin
  Reg := TRegistry.create;
  Result := '(n/a)';
  with Reg do
  try
    RootKey := HKEY_LOCAL_MACHINE;
    if OpenKey('System\CurrentControlSet\Services\VxD\VNETSUP',
      false) then
      Result := ReadString('Workgroup');
  finally
    CloseKey;
    free;
  end;
end;

//-------------------------------------------------------------------------------------------
PROCEDURE EnableSysKeys(Enable: Boolean);    // Only Win98, WinME
//-------------------------------------------------------------------------------------------
var
  Param: DWORD;
begin
  Param := 0;
  SystemParametersInfo(SPI_SETFASTTASKSWITCH, UINT(not Enable), @Param, 0);
    // ALT+TAB, CTRL+ESC
  SystemParametersInfo(SPI_SCREENSAVERRUNNING, UINT(not Enable), @Param, 0);
    // CTRL+ALT+DEL
end;

Function IsNT: Boolean;
//---------------------------------------------------------------------
var
     OsInfo: TOSVERSIONINFO;
Begin

     OsInfo.dwOSVersionInfoSize := sizeof(TOSVERSIONINFO);
     GetVersionEx(OsInfo);

     Result := VER_PLATFORM_WIN32_NT = OsInfo.dwPlatformId;

End;
  function SetPrivilege(privilegeName: string; enable: boolean): boolean;
  var tpPrev,
      tp : TTokenPrivileges;
      token : THandle;
      dwRetLen : DWord;
  begin
    result := False;
    OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, token);
    tp.PrivilegeCount := 1;
    if LookupPrivilegeValue(nil, pchar(privilegeName), tp.Privileges[0].LUID) then
    begin
      if enable then
        tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED
      else
        tp.Privileges[0].Attributes := 0;
      dwRetLen := 0;
      result := AdjustTokenPrivileges(token, False, tp, SizeOf(tpPrev), tpPrev, dwRetLen);
    end;
    CloseHandle(token);
  end;

function GetWindowExeName(Handle: THandle): String;
{Given a window handlew, return the program name}
var
 PE: TProcessEntry32;
 Snap: THandle;
 ProcessId: cardinal;
begin
  result:='???';
  pe.dwsize:=sizeof(PE);
 GetWindowThreadProcessId(Handle,@ProcessId);
 Snap:= CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
 if Snap <> 0 then
 begin
   if Process32First(Snap, PE) then
     if PE.th32ProcessID = ProcessId then
       Result:= String(PE.szExeFile)
     else while Process32Next(Snap, PE) do
       if PE.th32ProcessID = ProcessId then
       begin
         Result:= String(PE.szExeFile);
         //if Result='Icq.exe' then PostMessage(Handle,WM_QUIT,0,0);

         break;
       end;
   CloseHandle(Snap);
 end;
end;

function BlockInput(fBlockInput: Boolean): DWord; stdcall; external 'user32.DLL';

end.
