
library iraHookDLL;

uses
  Windows,
  iraHook in 'iraHook.pas',
  iraHookCommon in 'iraHookCommon.pas';

procedure DLLEntryPoint(reason: integer);
begin  if reason = DLL_PROCESS_DETACH then    iraHook.ProcessDetached;end; { DLLEntryPoint }exports  AttachReceiver,
  DetachReceiver,
  LastError;

begin
  DisableThreadLibraryCalls(HInstance);
  iraHook.ProcessAttached;
  DLLProc := @DLLEntryPoint;
end.

