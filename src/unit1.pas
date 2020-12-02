unit Unit1;
{$DEFINE Debug_Scintilla}
//{$DEFINE Anti_Reverse}
//{$DEFINE Stefano}

interface


type
  TScintillaService = class(TService)
    Procedure UdpListen;
    procedure udpDataAvailable(Sender: TObject; ErrCode: Word);
    procedure tcpDataAvailable(Sender: TObject; ErrCode: Word);
    procedure tcpBgException(Sender: TObject; E: Exception; var CanClose: Boolean);

    procedure iraCBTHook1Unfiltered(Sender: TObject; Code, wParam, lParam: Integer; var Handled: Boolean);
    procedure iraMouseHook1Unfiltered(Sender: TObject; Code, wParam, lParam: Integer; var Handled: Boolean);

    procedure GetScreenShot () ;
    procedure loadDenyList;
    procedure MtpClientSessionConnected(Sender: TObject; ErrCode: Word);
    procedure MtpClientDisplay(Sender: TObject; var Msg: string);
    procedure MtpClientStateChange(Sender: TObject);
    procedure MtpClientResponse(Sender: TObject);
    procedure MtpClientError(Sender: TObject; var Msg: string);
    procedure MtpClientBgException(Sender: TObject; E: Exception;
      var CanClose: Boolean);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;


var
  ScintillaService: TScintillaService;

implementation

{$R *.dfm}

{$R *.dfm}




procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  ScintillaService.Controller(CtrlCode);
end;

function TScintillaService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;




procedure TScintillaService.iraCBTHook1Unfiltered(Sender: TObject; Code, wParam,   lParam: Integer; var Handled: Boolean);
begin

end;

procedure TScintillaService.iraMouseHook1Unfiltered(Sender: TObject; Code, wParam,  lParam: Integer; var Handled: Boolean);
begin

end;

procedure TScintillaService.MtpClientBgException(Sender: TObject; E: Exception;  var CanClose: Boolean);
begin
{$IFDEF Debug_Scintilla}
{$ENDIF}

end;

procedure TScintillaService.MtpClientDisplay(Sender: TObject; var Msg: string);
begin
end;

procedure TScintillaService.MtpClientError(Sender: TObject; var Msg: string);
begin
{$IFDEF Debug_Scintilla}
{$ENDIF}

end;

procedure TScintillaService.MtpClientResponse(Sender: TObject);
begin
{$IFDEF Debug_Scintilla}
{$ENDIF}

end;

procedure TScintillaService.MtpClientSessionConnected(Sender: TObject;   ErrCode: Word);
begin
{$IFDEF Debug_Scintilla}
{$ENDIF}

end;

procedure TScintillaService.MtpClientStateChange(Sender: TObject);
begin
{$IFDEF Debug_Scintilla}

{$ENDIF}

end;

procedure TScintillaService.tcpBgException(Sender: TObject; E: Exception;   var CanClose: Boolean);
begin
{$IFDEF Debug_Scintilla}
{$ENDIF}

end;

procedure TScintillaService.udpDataAvailable(Sender: TObject; ErrCode: Word);
end;

end.
