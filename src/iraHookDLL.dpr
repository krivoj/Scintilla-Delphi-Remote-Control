
library iraHookDLL;

uses
  Windows,
  iraHook in 'iraHook.pas',
  iraHookCommon in 'iraHookCommon.pas';

procedure DLLEntryPoint(reason: integer);
begin
  DetachReceiver,
  LastError;

begin
  DisableThreadLibraryCalls(HInstance);
  iraHook.ProcessAttached;
  DLLProc := @DLLEntryPoint;
end.
