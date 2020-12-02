

unit iraHookCommon;

interface

uses
  Windows;

{Error codes returned from IraSysHook.AttachReceiver, IraSysHook.DetachReceiver,
  and IraSysHookLoader.LoadHookDLL.
}
const
  ERROR_FIRST = 0;

  ERROR_NO_ERROR = ERROR_FIRST;
  ERROR_EXPORTS = ERROR_NO_ERROR-1;
  ERRROR_ALREADY_REGISTERED = ERROR_EXPORTS-1;
  ERROR_NOT_REGISTERED = ERRROR_ALREADY_REGISTERED-1;
  ERROR_TOO_MANY_RECEIVERS = ERROR_NOT_REGISTERED-1;
  ERROR_ALREADY_HOOKED = ERROR_TOO_MANY_RECEIVERS-1;
  LAST_ERROR = ERROR_ALREADY_HOOKED;

var
  //:Error codes for the correcsponding error messages.
  HookErrors: array [LAST_ERROR..ERROR_FIRST] of string;

type
  //:Implemented hooks.
  TiraHookType = (htShell, htKeyboard, htMouse, htCBT);

implementation

resourcestring
  sNoError           = 'No error.';
  sNoExports         = 'error exporting functions.';
  sAlreadyRegistered = 'Receiver already registered.';
  sNotRegistered     = 'Receiver not registered.';
  sTooManyReceivers  = 'Too many receivers.';
  sAlreadyHooked     = 'System hook already active.';

initialization
  HookErrors[ERROR_NO_ERROR]           := sNoError;
  HookErrors[ERROR_EXPORTS]            := sNoExports;
  HookErrors[ERRROR_ALREADY_REGISTERED]:= sAlreadyRegistered;
  HookErrors[ERROR_NOT_REGISTERED]     := sNotRegistered;
  HookErrors[ERROR_TOO_MANY_RECEIVERS] := sTooManyReceivers;
  HookErrors[ERROR_ALREADY_HOOKED]     := sAlreadyHooked;
end.
