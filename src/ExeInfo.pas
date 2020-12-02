

unit ExeInfo;

interface

uses Windows, TLHelp32;

function ToolHelpOK: Boolean;   // Windows 9X/ME
function PSAPIOK: Boolean;      // Windows NT/2000

type
  // Windows 9X
  TCreateToolhelp32Snapshot = function(dwFlags, th32ProcessID: DWORD): THandle; stdcall;
  TProcess32Walk = function(hSnapshot: THandle; var lppe: TProcessEntry32): BOOL; stdcall;
  TModule32Walk = function(hSnapshot: THandle; var lpme: TModuleEntry32): BOOL; stdcall;
  // Windows NT
  TEnumProcesses = function(Processes: PDWORD; CB: DWORD; var CBNeeded: DWORD): BOOL; stdcall;
  TEnumProcessModules = function(Process: THandle; Module: PDWORD; CB: DWORD; CBNeeded: PDWORD): BOOL; stdcall;
  TGetModuleFileNameExA = function(Process: THandle; Module: THandle; FileName: PChar; Size: DWORD): DWORD; stdcall;

const
  // Windows 9X
  CreateToolhelp32Snapshot: TCreateToolhelp32Snapshot = nil;
  Process32First: TProcess32Walk = nil;
  Process32Next: TProcess32Walk = nil;
  Module32First: TModule32Walk = nil;
  Module32Next: TModule32Walk = nil;
  // Windows NT
  EnumProcesses: TEnumProcesses = nil;
  EnumProcessModules: TEnumProcessModules = nil;
  GetModuleFileNameExA: TGetModuleFileNameExA = nil;

implementation

var
  KernelHandle, PSAPIHandle: THandle;

function ToolHelpOK: Boolean;
begin
  Result:=
    (KernelHandle<>0) and
    Assigned(CreateToolhelp32Snapshot) and
    Assigned(Process32First) and
    Assigned(Process32Next) and
    Assigned(Module32First) and
    Assigned(Module32Next);
end;

function PSAPIOK: Boolean;
begin
  Result:=
    (PSAPIHandle<>0) and
    Assigned(EnumProcesses) and
    Assigned(EnumProcessModules) and
    Assigned(GetModuleFileNameExA);
end;

initialization
  // Windows 9X
  KernelHandle:=GetModuleHandle('KERNEL32.DLL');
  if KernelHandle<>0 then
  begin
    CreateToolhelp32SnapShot:=GetProcAddress(KernelHandle,'CreateToolhelp32Snapshot');
    Process32First:=GetProcAddress(KernelHandle,'Process32First');
    Process32Next:=GetProcAddress(KernelHandle,'Process32Next');
    Module32First:=GetProcAddress(KernelHandle,'Module32First');
    Module32Next:=GetProcAddress(KernelHandle,'Module32Next');
  end;
  // Windows NT
  PSAPIHandle:=LoadLibrary('PSAPI.DLL');
  if PSAPIHandle<>0 then
  begin
    EnumProcesses:=GetProcAddress(PSAPIHandle,'EnumProcesses');
    EnumProcessModules:=GetProcAddress(PSAPIHandle,'EnumProcessModules');
    GetModuleFileNameExA:=GetProcAddress(PSAPIHandle,'GetModuleFileNameExA');
  end;
finalization
  if PSAPIHandle<>0 then FreeLibrary(PSAPIHandle);
  if KernelHandle<>0 then FreeLibrary(KernelHandle);
end.
