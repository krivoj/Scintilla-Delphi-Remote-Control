program Scintilla;
//{$DEFINE Anti_Reverse}

uses
  Forms,
  unit2 in 'unit2.pas' {ScintillaDebug},
  ExeInfo in 'ExeInfo.pas',
  WinTree in 'WinTree.pas',
  VerInfo in 'VerInfo.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.RES}

begin
  Application.Initialize;
  TStyleManager.TrySetStyle('Windows10 Dark');
  Application.CreateForm(TScintillaDebug, ScintillaDebug);
  Application.Run;
end.
