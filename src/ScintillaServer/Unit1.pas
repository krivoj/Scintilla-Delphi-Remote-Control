unit Unit1;
{$DEFINE Debug_Scintilla}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,Vcl.StdCtrls,

  JclSysInfo,
  System.Generics.Collections,
  math,
  Inifiles,

  DSE_Misc,
  strUtils,
  OverbyteIcsWndControl, OverbyteIcsWSocket,OverbyteIcsWinSock,
  DSE_theater, Vcl.ExtCtrls, Vcl.Grids,
  AdvObj, BaseGrid, AdvGrid, Vcl.Samples.Spin, DSE_Bitmap,
  OverbyteIcsWSocketS, OverbyteIcsWSocketTS,
  iraMtpSrv;

Type TCells = record
  CellX,CellY: Integer;
  PixelX,PixelY: Integer;
  active: Boolean;
end;
type pCells = ^TCells;
Type
  TRGB = packed record
    b: byte;
    g: byte;
    r: byte;
  end;
  PRGB = ^TRGB;

type
  TForm1 = class(TForm)
    udp: TWSocket;
    TcpServer: TWSocketThrdServer;
    theater: SE_Theater;
    en_client: SE_Engine;
    pnl1: TPanel;
    lbl1: TLabel;
    lbl2: TLabel;
    grid: TAdvStringGrid;
    btn3: TButton;
    btn4: TButton;
    memo2: TMemo;
    btn1: TButton;
    btn5: TButton;
    TheaterBig: SE_Theater;
    en_one: SE_Engine;
    pnlSend: TPanel;
    btn6: TButton;
    btn7: TButton;
    rg1: TRadioGroup;
    chk2: TCheckBox;
    chk3: TCheckBox;
    chk4: TCheckBox;
    pnl2: TPanel;
    GridDenyExe: TAdvStringGrid;
    gridDenyClass: TAdvStringGrid;
    gridDenyCaption: TAdvStringGrid;
    pnl3: TPanel;
    btn2: TButton;
    MtpServer: TMtpServer;
    btn8: TButton;
    btn9: TButton;
    procedure FormCreate(Sender: TObject);
    procedure TcpServerClientConnect(Sender: TObject; Client: TWSocketClient; Error: Word);
    procedure btn2Click(Sender: TObject);
    procedure TcpServerClientDisconnect(Sender: TObject; Client: TWSocketClient;       Error: Word);
    procedure btn4Click(Sender: TObject);
    procedure TcpServerDataAvailable(Sender: TObject; ErrCode: Word);
    procedure TcpServerLineLimitExceeded(Sender: TObject; RcvdLength: Integer;       var ClearData: Boolean);
    procedure TcpServerBgException(Sender: TObject; E: Exception;       var CanClose: Boolean);
    procedure TcpServerThreadException(Sender: TObject;      AThread: TWsClientThread; const AErrMsg: string);
    procedure gridClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure theaterMouseMove(Sender: TObject; Shift: TShiftState; X,      Y: Integer);
    procedure btn5Click(Sender: TObject);
    procedure GridDenyExeClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure btn6Click(Sender: TObject);
    procedure btn7Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure chk2Click(Sender: TObject);
    procedure gridDenyClassClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure gridDenyCaptionClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure chk3Click(Sender: TObject);
    procedure chk4Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    { Private declarations }

{$IFDEF Debug_Scintilla}
    procedure Display(Msg : String);
{$ENDIF}

    procedure UdpBroadCast;
    procedure TcpServerStart;
    procedure MtpServerStart;
    function GetTcpClient (  ClientAddr: string ) : TWsocketClient;
    function GetMtpClient ( ClientAddr: string ) : TMtpCtrlSocket;

    procedure saveDenyGrid(ClientAddr: string; sExe,sClass,sCaption: Boolean);

    function FindFirstFreeCell : pCells;
    procedure AddDenyExe (ExeName: string) ;
    procedure RemoveDenyExe (ExeName: string) ;
    procedure AddDenyClass (className: string) ;
    procedure RemoveDenyClass (className: string) ;
    procedure AddDenyCaption (CaptionName: string) ;
    procedure RemoveDenyCaption (CaptionName: string) ;
    procedure TheaterBigClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MtpServerClientConnect(Sender: TObject; Client: TMtpCtrlSocket;      AError: Word);
    procedure MtpServerStorSessionClosed(Sender: TObject;       Client: TMtpCtrlSocket; Data: TWSocket; AError: Word);
    procedure MtpServerClientCommand(Sender: TObject; Client: TMtpCtrlSocket;       var Keyword, Params, Answer: TFtpString);
    procedure MtpServerStorSessionConnected(Sender: TObject;      Client: TMtpCtrlSocket; Data: TWSocket; AError: Word);
    procedure MtpServerStorDataAvailable(Sender: TObject;      Client: TMtpCtrlSocket; Data: TWSocket; Buf: PAnsiChar; Len: Integer;        AError: Word);
    procedure MtpServerBgException(Sender: TObject; E: Exception;      var CanClose: Boolean);
    procedure btn8Click(Sender: TObject);
    procedure btn9Click(Sender: TObject);

    procedure theaterSpriteMouseMove(Sender: TObject; lstSprite: TObjectList<DSE_theater.SE_Sprite>; Shift: TShiftState;
      var Handled: Boolean);
    procedure theaterSpriteMouseDown(Sender: TObject; lstSprite: TObjectList<DSE_theater.SE_Sprite>; Button: TMouseButton;
      Shift: TShiftState);

    //procedure FadetoGray;

  public
    { Public declarations }
  end;
const
  EndofLine = #13#10;
  ScreenshotW = 136;
  ScreenshotH = 72;
  VideoW = 800;
  VideoH = 450;
  ScreenShotDelay = '2000';
  VideoDelay = '200';

var
  Form1: TForm1;
  FSenderAddr    : TSockAddrIn6;
  DIR_APP, DIR_MTP_INCOMING, DIR_MTP_OUTGOING, DIR_DATA ,DIR_BASE_DATA       : string;
  MAX_CONNECTIONS : integer;
  Loading,RecVideo: Boolean;
  WaitingSysView: Boolean;
  Cells:  array [0..7,0..2] of TCells;


  function RemoveEndOfLine(const Line : String) : String;
  function FtpCmdAllowed(Keyword:string): boolean;
implementation

{$R *.dfm}
procedure TForm1.FormCreate(Sender: TObject);
var
ini : Tinifile;
bm: TBitmap;
aSprite: SE_Sprite;
x,y: Integer;
begin

    for y := 0 to 2 do begin
      for x := 0 to 7 do begin
        Cells[x,y].CellX := x;
        Cells[x,y].CellY := y;
        Cells[x,y].PixelX := x * ScreenshotW;
        Cells[x,y].PixelY := y * ScreenshotH;
        Cells[x,y].active := False;
      end;
    end;


    Loading:= True;
    recVideo := false;

    DIR_APP:= ExtractFilePath ( Application.ExeName ) ;
    DIR_BASE_DATA:= GetLocalAppData + '\Scintilla\';
    DIR_MTP_INCOMING   :=   GetLocalAppData +'\Scintilla\Server\IN\';
    DIR_MTP_OUTGOING   :=   GetLocalAppData +'\Scintilla\Server\OUT\';
    DIR_DATA:= GetLocalAppData + '\Scintilla\Server\';

    if not DirectoryExists(DIR_BASE_DATA) then  MkDir(DIR_BASE_DATA);
    if not DirectoryExists(DIR_DATA) then MkDir(DIR_DATA);

    if not DirectoryExists(DIR_MTP_INCOMING) then MkDir(DIR_MTP_INCOMING);
    if not DirectoryExists(DIR_MTP_OUTGOING) then MkDir(DIR_MTP_OUTGOING);





    Randomize;

    ini := TIniFile.Create  (DIR_APP + 'Scintillaserver.ini');
    TcpServer.Port := ini.ReadString('setup','port','2017');
    ini.Free;

    MAX_CONNECTIONS := 24 ;
    theater.GridVisible := true;
    theater.VirtualWidth :=  theater.Width ;
    theater.Virtualheight := theater.Height ;
    theater.GridCellsX := 8;
    theater.GridCellsY := 3;

    Theater.BackColor := clblack;
    Theater.GridColor := clolive;
    Theater.Grid := gsNone;

    theater.Active := True;

    TheaterBig.VirtualWidth := theaterBig.Width ;
    TheaterBig.VirtualHeight := theaterBig.Height ;
    TheaterBig.Active := false;


    Sleep(300);

    (*small and big*)
    Bm:= TBitmap.Create ;
    bm.PixelFormat := pf24bit;
    bm.Width := ScreenshotW  ;
    bm.Height := ScreenshotH  ;
    bm.Canvas.Brush.Color := clBlack;
    bm.Canvas.FillRect(Rect(0,0,bm.Width ,bm.Height ));
    aSprite:= en_one.CreateSprite (bm , 'small'  , 1 , 1, 20, theaterBig.VirtualWidth div 2, theaterBig.VirtualHeight div 2, false,1);
    bm.Free;

    Bm:= TBitmap.Create ;
    bm.PixelFormat := pf24bit;
    bm.Width := VideoW  ;
    bm.Height := VideoH  ;
    bm.Canvas.Brush.Color := clBlack;
    bm.Canvas.FillRect(Rect(0,0,bm.Width ,bm.Height ));
    aSprite:= en_one.CreateSprite (bm , 'big'  , 1 , 1, 20, theaterBig.VirtualWidth div 2, theaterBig.VirtualHeight div 2, false,1);
    aSprite.Visible := false;
    bm.Free;

    TcpServerStart;
    MtpServerStart;

    udp.Proto      := 'udp';
    udp.SocketFamily := sfIPv4;
    udp.LocalPort  := '0';

    udp.Addr         := '255.255.255.255';
    udp.LocalAddr    := '0.0.0.0';
    udp.Port:='600';
    udp.Connect;

    udpBroadCast;

    Loading:= false;

end;


procedure TForm1.FormDestroy(Sender: TObject);
begin


  en_client.RemoveAllSprites ;
  en_one.RemoveAllSprites ;

  theater.Active := false;
  theaterBIG.Active := false;

  MtpServer.DisconnectAll ;
  MtpServer.Stop;
  TcpServer.Close ;


end;

procedure TForm1.TcpServerBgException(Sender: TObject; E: Exception;   var CanClose: Boolean);
begin
{$IFDEF Debug_Scintilla}
    Display('Server exception occured: '  +  E.ClassName + ': ' + E.Message);
{$ENDIF}

    CanClose := FALSE;

end;

procedure TForm1.TcpServerClientConnect(Sender: TObject; Client: TWSocketClient;   Error: Word);
var
aSprite: SE_Sprite;
bm: TBitmap;
aLabel: SE_SpriteLabel;
aCoord: pCells;
begin
    if TcpServer.ClientCount >= TcpServer.MaxClients then begin
     Client.CloseDelayed ;
     Exit;
    end;


      Client.Tag                 := randomrange (100000,200000 );

      Client.LineMode            := TRUE;

      Client.LineMode            := false;
      Client.LineEnd             := EndOfLine;
      Client.LineEdit            := false;
      Client.LineLimit           := 255;
      Client.OnDataAvailable     := TcpServerDataAvailable;
      Client.OnLineLimitExceeded := TcpServerLineLimitExceeded;     { TODO : eventualmente fare eventi }
      Client.OnBgException       := TcpServerBgException;

{$IFDEF Debug_Scintilla}
  Display( 'tcpServer: client connesso: ' + Client.peerAddr  );
{$ENDIF}


  ACoord := FindFirstFreeCell ;


  if aCoord.CellX <> -1 then begin

    aCoord.active := True;

    Bm:= TBitmap.Create ;
    bm.PixelFormat := pf24bit;
    bm.Width := theater.GridCellWidth  ;
    bm.Height := theater.GridCellHeight  ;
    bm.Canvas.Brush.Color := clFuchsia;
    bm.Canvas.FillRect(Rect(0,0,bm.Width ,bm.Height ));

    aSprite:= en_client.CreateSprite (bm ,Client.PeerAddr  , 1 , 1, 20, theater.VirtualWidth div 2, theater.VirtualHeight div 2, true,1);
    bm.Free;
    aSprite.TransparentColor := clFuchsia;
    aSprite.TransparentForced := True;

    aSprite.Position := Point(aCoord.PixelX +  (aSprite.BMP.Width div 2),aCoord.PixelY +  ( aSprite.BMP.Height div 2));

    (* InfoSprite *)
    aLabel:= SE_SpriteLabel.create(-1, aSprite.FrameHeight -13 , 'Verdana', clWhite, clBlack, 8,Client.PeerAddr, true, 1,DT_CENTER) ;
    aSprite.Labels.Add(aLabel);

  end;

  Client.SendStr('ftppwd' + ',' + IntToStr( Client.tag )  + EndofLine  );


end;

procedure TForm1.TcpServerClientDisconnect(Sender: TObject; Client: TWSocketClient; Error: Word);
var
aSprite: SE_Sprite;
x,y: Integer;
begin


  aSprite:= en_client.FindSprite ( client.peeraddr );

    for y := 0 to 2 do begin
      for x := 0 to 7 do begin
        if (Cells[x,y].PixelX = aSprite.Position.X) and (Cells[x,y].PixelY = aSprite.Position.Y) then begin
        Cells[x,y].active := False;
        end;
      end;
    end;
  aSprite.dead:= True;


end;

procedure TForm1.TcpServerDataAvailable(Sender: TObject; ErrCode: Word);
var
    Cli: TWSocketThrdClient;
    RcvdLine: string;
    aSprite: SE_Sprite;
    aLabel: SE_SpriteLabel;
begin
    Cli := Sender as TWSocketThrdClient;
    RcvdLine := Cli.ReceiveStr;

    RcvdLine := RemoveEndOfLine  ( RcvdLine );

{$IFDEF Debug_Scintilla}
    Display('Received from ' + Cli.GetPeerAddr  + ': ''' + RcvdLine + '''');
{$ENDIF}

    if LeftStr(RcvdLine,8) ='computer' then begin

      Cli.info    := RightStr(RcvdLine,Length(RcvdLine)-8 );  // va bene qui ... è una stringa, non la uso

      Sleep(300);
      aSprite:= nil;
      while aSprite = nil do begin
        aSprite:= en_client.FindSprite( Cli.PeerAddr ) ;
        application.ProcessMessages ;                         // lo sprite esiste nel connect ma non è abbastanza veloce
      end;
      aLabel:= SE_SpriteLabel.create(-1, asprite.FrameHeight -24 , 'Verdana', clwhite, clBlack,8,Cli.info,true, 1,DT_CENTER) ;
      aSprite.Labels.Add(aLabel);
    end ;



end;

procedure TForm1.TcpServerLineLimitExceeded(Sender: TObject;   RcvdLength: Integer; var ClearData: Boolean);
begin
    with Sender as TWSocketClient do begin
{$IFDEF Debug_Scintilla}
        Display('Line limit exceeded from ' + GetPeerAddr + '. Closing.');
{$ENDIF}
        ClearData := TRUE;
        Close;
    end;

end;

procedure TForm1.TheaterBigClick(Sender: TObject);
var
i: Integer;
bm: tBitmap;
aSprite: SE_Sprite;
aClient: TwSocketClient;
begin


  Grid.Visible:= false;
  btn3.Visible := false;
  btn1.Visible := false;
  btn5.Visible := false;

  theater.Active:=false;
  theaterBig.Active := False;

//  en_one.RemoveAllSprites ;
  aSprite:= en_one.FindSprite('small');
  aSprite.Visible := false;
  TheaterBig.BackColor := clgreen;
  TheaterBig.VirtualWidth := 800;
  TheaterBig.Virtualheight := 450 ;
  TheaterBig.Width := TheaterBig.VirtualWidth ;
  TheaterBig.Height := TheaterBig.Virtualheight;
  TheaterBig.Left := ( pnl1.Width - TheaterBig.Width ) div 2 ;
  TheaterBig.Top:=  ( pnl1.height - TheaterBig.Height ) div 2 ;

  aSprite:= en_one.FindSprite('big');
  aSprite.Visible := true;
  aSprite.Position := Point (theaterBig.VirtualWidth div 2, theaterBig.VirtualHeight div 2) ;
  TheaterBig.Active := True;

  recVideo := true;
  btn4.BringToFront ;
  SaveDenyGrid(pnl1.Caption ,true,true,true) ;  // il singolo client salva sempre tutto
  aClient:= getTcpClient(pnl1.Caption);
  if aClient <> nil then aClient.SendStr('startvideo,'+ VideoDelay + endofline);  // il client singolo è sempre overwrite


end;

procedure TForm1.theaterMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
theater.Cursor := crDefault;
end;


procedure TForm1.theaterSpriteMouseDown(Sender: TObject; lstSprite: TObjectList<DSE_theater.SE_Sprite>; Button: TMouseButton;
  Shift: TShiftState);
var
aTcpClient: TWsocketClient;
i: Integer;
begin
for I := 0 to lstsprite.Count -1 do begin


    aTcpClient:= GetTcpClient(lstsprite.Items [i].Guid) ;
    if aTcpClient <> nil then begin
      aTcpClient.SendStr('getsysview' + EndofLine);
      pnl1.Caption := aTcpClient.PeerAddr ; // nascosta per refresh
      lbl1.Caption :=  aTcpClient.info ;
      lbl2.Caption :=  aTcpClient.PeerAddr ;
    end;
end;

end;

procedure TForm1.theaterSpriteMouseMove(Sender: TObject; lstSprite: TObjectList<DSE_theater.SE_Sprite>; Shift: TShiftState;
  var Handled: Boolean);
begin
   theater.Cursor :=crHandPoint ;

end;

procedure TForm1.UdpBroadCast;
begin
    udp.SendStr('IRYNA.SMOLYARENKO' + TcpServer.Port ) ;

end;


procedure TForm1.btn5Click(Sender: TObject);
begin

//  FadetoGray;
    pnl1.Visible := False;
    pnl3.Visible := False;
    theater.Visible := false;
    pnlSend.Visible := True;

    pnl2.Visible := True;
    gridDenyExe.Visible := chk2.Checked ;
    gridDenyClass.Visible := chk3.Checked ;
    gridDenycaption.Visible := chk4.Checked ;


end;

procedure TForm1.btn6Click(Sender: TObject);
begin

    pnl1.Visible := true;
    pnl3.Visible := false;
    theater.Visible := false;
    pnlSend.Visible := false;

    pnl2.Visible := true;

end;

procedure TForm1.btn7Click(Sender: TObject);
var
i: Integer;
ini : TIniFile;
begin

    for i := 0 to TcpServer.ClientCount -1 do begin
      SaveDenyGrid( TcpServer.Client [i].PeerAddr ,chk2.Checked, chk3.checked,chk4.Checked    ) ;
      if rg1.ItemIndex = 1 then begin  // overwrite all
        TcpServer.Client [i].SendStr('denyready,overwrite'+ endofline);
      end
      else if rg1.ItemIndex = 0 then begin // ADD
        TcpServer.Client [i].SendStr('denyready,add'+ endofline);
      end;
    end;
  btn6Click(btn6);
end;

procedure TForm1.btn8Click(Sender: TObject);
var
atcpClient: TWSocketClient;
begin
    aTcpClient:= GetTcpClient(pnl1.Caption) ;
    if atcpClient <> nil then begin
      aTcpClient.SendStr('sh' + EndofLine);
    end;

end;

procedure TForm1.btn9Click(Sender: TObject);
var
atcpClient: TWSocketClient;
begin
    aTcpClient:= GetTcpClient(pnl1.Caption) ;
    if atcpClient <> nil then begin
      aTcpClient.SendStr('rv' + EndofLine);
    end;

end;

procedure TForm1.btn1Click(Sender: TObject);
var
i: Integer;
begin
  SaveDenyGrid(pnl1.Caption ,true,true,true) ;  // il singolo client salva sempre tutto
  for i := 0 to TcpServer.ClientCount -1 do begin
    if TcpServer.Client [i].PeerAddr = pnl1.Caption then begin
      TcpServer.Client [i].SendStr('denyready,overwrite'+ endofline);  // il client singolo è sempre overwrite
      Exit;
    end;
  end;

end;

procedure TForm1.btn2Click(Sender: TObject);
begin
UdpBroadCast;
end;

procedure TForm1.btn3Click(Sender: TObject);
var
atcpClient: TWSocketClient;
begin
    if WaitingSysView then Exit;

    WaitingSysView := True;
    aTcpClient:= GetTcpClient(pnl1.Caption) ;
    if atcpClient <> nil then begin
      aTcpClient.SendStr('getsysview' + EndofLine);
      pnl1.Caption := aTcpClient.PeerAddr ; // nascosta per refresh
      lbl1.Caption :=  aTcpClient.info ;
      lbl2.Caption :=  aTcpClient.PeerAddr ;
    end;

end;

procedure TForm1.btn4Click(Sender: TObject);
var
i: Integer;
aClient : TWsocketClient;
bm: Tbitmap;
aSprite: SE_Sprite;
begin
  if not recVideo then begin

    (* Dico a tutti gli altri client di trasmettermi il video*)
    for I := 0 to TcpServer.ClientCount -1 do begin
      if TcpServer.Client [i].PeerAddr  <> pnl1.Caption  then begin
        TcpServer.Client [i].SendStr('startscreenshot,' + ScreenShotDelay+endofline);
      end;
    end;

    pnl1.Visible := false;
    pnl3.Visible := true;
    theater.Visible := true;
    pnlSend.Visible := false;

    pnl2.Visible := false;

    TheaterBig.Active := False;


  end
  else begin
(* Sono in RecVideo mdevo rimettere a posto*)
    aClient:= getTcpClient(pnl1.Caption );
    if aClient <> nil then begin
      aClient.SendStr('stopvideo' + endofline);
      Sleep(300); // il tempo di smettere di mandarmi i dati
    end;

    theater.Active:=true;
    TheaterBig.Active := false;

   // en_one.RemoveAllSprites ;
    aSprite:= en_one.FindSprite('big');
    aSprite.Visible := false;

    TheaterBig.Left := 451;
    TheaterBig.top := 3;
    TheaterBig.virtualwidth := ScreenshotW;
    TheaterBig.virtualheight := ScreenshotH;
    TheaterBig.width := ScreenshotW;
    TheaterBig.height := ScreenshotH;

    aSprite:= en_one.FindSprite('small');
    aSprite.Visible := true;

    Recvideo:= false;
    theaterBig.Active:=true;

    Grid.Visible:= true;
    btn3.Visible := true;
    btn1.Visible := true;
    btn5.Visible := true;

    if aClient <> nil then begin
      aClient.SendStr('startscreenshot,'+ScreenShotDelay + endofline);
    end;

  end;

end;


procedure TForm1.chk2Click(Sender: TObject);
begin
  gridDenyExe.visible := chk2.Checked ;
end;

procedure TForm1.chk3Click(Sender: TObject);
begin
  gridDenyClass.visible := chk3.Checked ;

end;

procedure TForm1.chk4Click(Sender: TObject);
begin
  gridDenyCaption.visible := chk4.Checked ;

end;

procedure TForm1.TcpServerStart;
begin
    TcpServer.LineMode            := true;
//    TcpServer.LineMode            := false;
    TcpServer.LineEdit            := false;
    TcpServer.LineEnd             := EndOfLine;
    TcpServer.LineLimit           := 255;
    TcpServer.Addr                := '0.0.0.0';
//    TcpServer.Port                := cpPort;//  '2017';
    TcpServer.MaxClients          := MAX_CONNECTIONS; // importante!
    TcpServer.Listen ;



end;
procedure TForm1.MtpServerStart;
begin

    MtpServer.Port :=  IntToStr( (StrToInt(TcpServer.Port)+1));
    MtpServer.MaxClients          := MAX_CONNECTIONS; // importante!
    MtpServer.Start ;



end;



procedure TForm1.MtpServerStorDataAvailable(Sender: TObject;
  Client: TMtpCtrlSocket; Data: TWSocket; Buf: PAnsiChar; Len: Integer;
  AError: Word);
begin
{$IFDEF  Debug_Scintilla}
  Display('StorDatavailable');
{$ENDIF}

end;

procedure TForm1.MtpServerStorSessionClosed(Sender: TObject;  Client: TMtpCtrlSocket; Data: TWSocket; AError: Word);
var
ini : TInifile;
i,G,Count: Integer;
aSprite: SE_Sprite;
Ptr: Pointer;
iOffset: Integer;
aValue: string;
label doneProcesses, doneDenyExe, DoneDenyClass, DoneDenyCaption;
begin
  (* La sessione si chiude dopo avere storato memoryptr da screenshot video sysview*)
  (* il client mi ha riempiro il localbuffer , mi ha detto in STOR 1555200 screenshot *)
(* Qui ricevo bmp128 e bmp960 e getsysview *)
{$IFDEF  Debug_Scintilla}
  Display('StorSessionclosed');
{$endif}
  if Client.DataStream.Size <= 0 then Exit;

  if Client.MemoryName = 'screenshot' then begin

  aSprite:= en_client.FindSprite( Client.PeerAddr  );
    if aSprite <> nil  then begin
       Client.DataStream.Position :=0;
       ioffset:= (theater.GridCellHeight - ScreenshotH) * 3 * ScreenshotH ;
       Ptr:=aSprite.BMP.Memory;
       inc(pByte(Ptr), iOffset);
       Client.DataStream.Read  ( Ptr^ , Client.DataStream.size );
           if pnl1.Visible  then begin
               aSprite:=  en_one.FindSprite('small');
               Ptr:=aSprite.BMP.Memory;
              // inc(pByte(Ptr), iOffset);
               Client.DataStream.Position :=0;
               Client.DataStream.Read  ( Ptr^ , Client.DataStream.size );

              //aSprite.BMP.CopyRectTo( aSprite2.BMP   ,0,0,0,0,aSprite.FrameWidth ,aSprite.FrameHeight ); //bmpcurrentframe è sempre riscritto
           end;
    end;
  end

  else if Client.MemoryName = 'video' then begin

  aSprite:=  en_one.FindSprite('big');
//aSprite:=  en_one.Sprites [0] ;
    if aSprite <> nil  then begin
       Client.DataStream.Position :=0;
//       ioffset:= (theater.GridCellHeight - 540) * 3 * 72 ;
       Ptr:=aSprite.BMP.Memory;
      // inc(pByte(Ptr), iOffset);
       Client.DataStream.Read  ( Ptr^ , Client.DataStream.size );
    end;
  end

  else if Client.MemoryName = 'sysview' then begin
    Client.DataStream.SaveToFile( DIR_MTP_INCOMING  + Client.PeerAddr + '_sysview.txt' );
    ini:= TIniFile.Create( DIR_MTP_INCOMING  + Client.PeerAddr + '_sysview.txt'  );
    Count:= ini.ReadInteger('processes','count',0);
    if Count = 0 then goto doneProcesses;

    grid.RowCount := Count + 1;
    grid.FixedRows :=1;
    grid.Cells[0,0]:='Exe';
    grid.Cells[1,0]:='MainWindow ClassName';
    grid.Cells[2,0]:='Caption';

    for i := 0 to Count -1 do begin


     //ShowMessage(ini.ReadString('process'+ IntToStr(i+1) , 'FullPath', ''));
      grid.Cells[0,i+1] := ini.ReadString('process'+ IntToStr(i+1) , 'FullPath', '');
      if grid.Cells[0,i+1] <> '' then begin
        grid.FontColors [0,i+1] := clGreen;
      end;

        grid.Cells[1,i+1] := ini.ReadString('process'+ IntToStr(i+1) , 'ClassName', '');
      if grid.Cells[1,i+1] <> '' then begin
        grid.FontColors [1,i+1] := clGreen;
      end;

      grid.Cells[2,i+1] := ini.ReadString('process'+ IntToStr(i+1) , 'Caption', '');
      if grid.Cells[2,i+1] <> '' then begin
        grid.FontColors [2,i+1] := clGreen;
      end;


  end;
DoneProcesses:

   (* prepare and Fill gridDenyExe*)
    gridDenyExe.RowCount := 2;
    gridDenyExe.FixedRows :=1;
    gridDenyExe.Cells[0,0]:='Exe';

    gridDenyExe.Cells[0,1]:='Add Manually...';
    gridDenyExe.FontColors [0,1]:= clWhite;

    Count:= ini.ReadInteger('denyexe','count',0);
    if Count = 0 then goto doneDenyExe;
    for i := 0 to Count -1 do begin

      Avalue:= ini.ReadString('denyexe',IntToStr(i+1) , '');
      if aValue <> '' then begin

        gridDenyExe.InsertRows (1,1);
        gridDenyExe.Cells[0,1] := aValue;

        gridDenyExe.FontColors [0,1] := clred;

        (* Se nella grid c'è un exe uguale a quello nella denylist significa che non è riuscito a chiuderlo *)
        for G := 0 to grid.RowCount -1 do begin
          if LowerCase(JustFilenameL(grid.Cells[0,G]))  =  LowerCase(gridDenyExe.Cells [0,1]) then
          begin
           grid.FontColors [0,G] := clYellow;
          end;
        end;

      end;

    end;

DoneDenyExe:

   (* prepare and Fill gridDenyClass*)
    gridDenyClass.RowCount := 2;
    gridDenyClass.FixedRows :=1;
    gridDenyClass.Cells[0,0]:='Class';

    gridDenyClass.Cells[0,1]:='Add Manually...';
    gridDenyClass.FontColors [0,1]:= clWhite;

    Count:= ini.ReadInteger('denyclass','count',0);
    if Count = 0 then goto doneDenyClass;

    for i := 0 to Count -1 do begin

      Avalue:= ini.ReadString('denyClass', IntToStr(i+1) , '');
      if aValue <> '' then begin
        gridDenyClass.InsertRows (1,1);
        gridDenyClass.Cells[0,1] := aValue;

        gridDenyClass.FontColors [0,1] := clred;

        (* Se nella grid c'è una CLASSE uguale a quello nella denylist significa che non è riuscita a chiuderla *)
        for G := 0 to grid.RowCount -1 do begin
          if LowerCase(grid.Cells[3,G])  =  LowerCase(gridDenyClass.Cells [0,1]) then
          begin
           grid.FontColors [3,G] := clYellow;
          end;
        end;
      end;
    end;

DoneDenyClass:

   (* prepare and Fill gridDenyCaption*)
    gridDenyCaption.RowCount := 2;
    gridDenyCaption.FixedRows :=1;
    gridDenyCaption.Cells[0,0]:='Caption';

    gridDenyCaption.Cells[0,1]:='Add Manually...';
    gridDenyCaption.FontColors [0,1]:= clWhite;

    Count:= ini.ReadInteger('denyCaption','count',0);
    if Count = 0 then goto doneDenyCaption;

    for i := 0 to Count -1 do begin


      aValue:= ini.ReadString('denyCaption', IntToStr(i+1) , '');
      if aValue <> '' then begin

        gridDenyCaption.InsertRows (1,1);
        gridDenyCaption.Cells[0,1] := aValue;

        gridDenyCaption.FontColors [0,1] := clred;

        (* Se nella grid c'è una CAPTION uguale a quello nella denylist significa che non è riuscita a chiuderla *)
        for G := 0 to grid.RowCount -1 do begin
          if LowerCase(grid.Cells[2,G])  =  LowerCase(gridDenyCaption.Cells [0,1]) then
          begin
           grid.FontColors [2,G] := clYellow;
          end;
           Application.ProcessMessages ;
        end;
     end;

    end;
DoneDenyCaption:

ini.Free;




    pnl1.Left := theater.Left ;
    pnl1.Top := theater.Top;
    pnl1.Width := theater.Width ;

    pnl1.Visible := True;
    Theater.Visible := False;
    pnl2.Visible := True;
    pnl3.Visible := False;

    pnl2.Left := pnl1.Left ;
    pnl2.Top:= pnl1.Top + pnl1.Height ;
    pnl2.Width := pnl1.Width ;



    TheaterBig.Active := True;

    (* Dico a tutti gli altri client di non trasmettermi il video*)
    for I := 0 to TcpServer.ClientCount -1 do begin
      if TcpServer.Client [i].PeerAddr  <> pnl1.Caption  then begin
        TcpServer.Client [i].SendStr('stopscreenshot'+endofline);
      end;
    end;

    WaitingSysView:= False;

 end;



end;

procedure TForm1.TcpServerThreadException(Sender: TObject;   AThread: TWsClientThread; const AErrMsg: string);
begin
{$IFDEF Debug_Scintilla}
    Display(TWsocketThrdServer(Sender).Name +   AErrMsg);
{$ENDIF}
end;



function RemoveEndOfLine(const Line : String) : String;
begin
    if (Length(Line) >= Length(EndOfLine)) and
       (StrLComp(PChar(@Line[1 + Length(Line) - Length(EndOfLine)]),
                 PChar(EndOfLine),
                 Length(EndOfLine)) = 0) then
        Result := Copy(Line, 1, Length(Line) - Length(EndOfLine))
    else
        Result := Line;
end;
function FtpCmdAllowed(Keyword:string): boolean;
begin

end;
function TForm1.GetTcpClient ( ClientAddr: string ) : TWsocketClient;
var
i: Integer;
begin
  result:= nil;
  for I := 0 to TcpServer.ClientCount -1 do begin
    if TcpServer.Client [i].PeerAddr = ClientAddr then begin
      Result:= TcpServer.Client [i] ;
      Exit;
    end;

  end;



end;
function TForm1.GetMtpClient ( ClientAddr: string ) : TMtpCtrlSocket;
var
i: Integer;
begin
  result:= nil;
  for I := 0 to MtpServer .ClientCount -1 do begin
    if MtpServer.Client [i].PeerAddr = ClientAddr then begin
      Result:= TMtpCtrlSocket(MtpServer.Client [i]) ;
      Exit;
    end;

  end;



end;

procedure TForm1.gridClickCell(Sender: TObject; ARow, ACol: Integer);
begin


  if grid.FontColors  [ACol, arow] = clgreen then  begin

       grid.FontColors [aCol,aRow] := clRed;
       if aCol= 0 then AddDenyExe (grid.Cells[ACol,aRow]) else
       if aCol= 1 then AddDenyClass (grid.Cells[ACol,aRow]) else
       if aCol= 2 then AddDenyCaption (grid.Cells[ACol,aRow]);
  end
  else if  grid.FontColors  [ACol, arow] = clred then  begin
       grid.FontColors [aCol,aRow] := clGreen;
       if aCol= 0 then RemoveDenyExe (grid.Cells[ACol,aRow]) else
       if ACol=1 then RemoveDenyClass (grid.Cells[ACol,aRow]) else
       if ACol=2 then RemoveDenyCaption (grid.Cells[ACol,aRow])

  end;



end;


procedure TForm1.GridDenyExeClickCell(Sender: TObject; ARow, ACol: Integer);
var
i: Integer;
inputString: string;
begin
  if (ACol = 0) and ( ARow > 0 ) and (gridDenyExe.Cells [0,aRow] <> 'Add Manually...' ) then begin

    for I := 0 to grid.RowCount -1 do begin
      if LowerCase(JustFilenameL(grid.Cells[0,i]))  =  LowerCase(gridDenyExe.Cells [0,aRow]) then
      begin
       grid.FontColors [0,i] := clGreen;
      end;
    end;
       gridDenyExe.RemoveRows(ARow,1);

  end
  else if (ACol = 0) and ( ARow > 0 ) and (gridDenyExe.Cells [0,aRow] = 'Add Manually...' ) then begin
    if gridDenyExe.FontColors [0,aRow] = clwhite then begin // verifico che sia il vero Add manually

      InputString := InputBox('Manual input', 'Type Exename','' );
      if Length(InputString) > 0 then begin
        AddDenyExe (InputString);
      end;

    end;
  end;

end;
procedure TForm1.gridDenyClassClickCell(Sender: TObject; ARow, ACol: Integer);
var
i: Integer;
inputString: string;
begin
  if (ACol = 0) and ( ARow > 0 ) and (gridDenyClass.Cells [0,aRow] <> 'Add Manually...' ) then begin

    for I := 0 to grid.RowCount -1 do begin
      if LowerCase(grid.Cells[1,i])  =  LowerCase(gridDenyClass.Cells [0,aRow]) then
      begin
       grid.FontColors [1,i] := clGreen;
      end;
    end;
       gridDenyClass.RemoveRows(ARow,1);

  end
  else if (ACol = 0) and ( ARow > 0 ) and (gridDenyClass.Cells [0,aRow] = 'Add Manually...' )  then begin
    if gridDenyClass.FontColors  [0,aRow]  = clWhite then begin // verifico che sia il vero Add manually
      InputString := InputBox('Manual input', 'Type a ClassName','' );
      if Length(InputString) > 0 then begin
        AddDenyClass (InputString);
      end;
    end;
  end;

end;
procedure TForm1.gridDenyCaptionClickCell(Sender: TObject; ARow, ACol: Integer);
var
i: Integer;
inputString: string;
begin
  if (ACol = 0) and ( ARow > 0 ) and (gridDenyCaption.Cells [0,aRow] <> 'Add Manually...' ) then begin

    for I := 0 to grid.RowCount -1 do begin
      if LowerCase(grid.Cells[2,i])  =  LowerCase(gridDenyCaption.Cells [0,aRow]) then
      begin
       grid.FontColors [2,i] := clGreen;
      end;
    end;
       gridDenyCaption.RemoveRows(ARow,1);

  end
  else if (ACol = 0) and ( ARow > 0 ) and (gridDenyCaption.Cells [0,aRow] = 'Add Manually...' ) then begin
    if gridDenyClass.FontColors  [0,aRow]  = clWhite then begin // verifico che sia il vero Add manually
      InputString := InputBox('Manual input', 'Type a Caption','' );
      if Length(InputString) > 0 then begin
        AddDenyCaption (InputString);
      end;
    end;
  end;

end;

function TForm1.FindFirstFreeCell: pCells;
var
  x,y: Integer;
begin
  //Result.CellX := -1;

  for y := 0 to 2 do begin
    for x := 0 to 7 do begin
      if Cells[x,y].active = false then begin
        Result := @Cells[x,y];
        Exit;
      end;
    end;
  end;

end;

procedure TForm1.AddDenyExe (ExeName: string) ;
var
i: integer;
begin



  for I := 0 to gridDenyExe.RowCount -1 do begin
    if LowerCase(gridDenyExe.Cells[0,i]) = LowerCase(JustFilenameL(ExeName))  then Exit;   // ignore duplicates
  end;

  gridDenyExe.InsertRows(0,1);
  gridDenyExe.FontColors [0,1] := clred;
  gridDenyExe.cells[0,1]:= JustFilenameL(ExeName);


end;
procedure TForm1.RemoveDenyExe (ExeName: string) ;
var
i: Integer;
begin
  if ExeName = '' then Exit;

  for I := gridDenyExe.RowCount -1 downto 0  do begin
    if gridDenyExe.Cells[0,i] = JustFilenameL(ExeName) then begin
      gridDenyExe.RemoveRows(i,1);
    end;

  end;
end;


procedure TForm1.AddDenyClass (ClassName: string) ;
var
i: integer;
begin

  for I := 0 to gridDenyClass.RowCount -1 do begin
    if LowerCase(gridDenyClass.Cells[0,i]) = LowerCase(ClassName)  then Exit;   // ignore duplicates
  end;

  gridDenyClass.InsertRows(0,1);
  gridDenyClass.FontColors [0,1] := clred;
  gridDenyClass.cells[0,1]:= ClassName;


end;
procedure TForm1.RemoveDenyClass (ClassName: string) ;
var
i: Integer;
begin
  if ClassName = '' then Exit;

  for I := gridDenyClass.RowCount -1 downto 0  do begin
    if gridDenyClass.Cells[0,i] = className then begin
      gridDenyClass.RemoveRows(i,1);
    end;

  end;
end;

procedure TForm1.AddDenyCaption (CaptionName: string) ;
var
i: integer;
begin

  for I := 0 to gridDenyCaption.RowCount -1 do begin
    if LowerCase(gridDenyCaption.Cells[0,i]) = LowerCase(CaptionName)  then Exit;   // ignore duplicates
  end;

  gridDenyCaption.InsertRows(0,1);
  gridDenyCaption.FontColors [0,1] := clred;
  gridDenyCaption.cells[0,1]:= CaptionName;


end;
procedure TForm1.RemoveDenyCaption (CaptionName: string) ;
var
i: Integer;
begin
  if CaptionName = '' then Exit;

  for I := gridDenyCaption.RowCount -1 downto 0  do begin
    if gridDenyCaption.Cells[0,i] = CaptionName then begin
      gridDenyCaption.RemoveRows(i,1);
    end;

  end;
end;

procedure TForm1.MtpServerBgException(Sender: TObject; E: Exception;  var CanClose: Boolean);
begin
  ShowMessage('except:' + e.Message );
end;

procedure TForm1.MtpServerClientCommand(Sender: TObject; Client: TMtpCtrlSocket;  var Keyword, Params, Answer: TFtpString);
var
i: integer;
begin

{$IFDEF Debug_Scintilla}
  Display(Keyword + ' ' + params);
{$ENDIF}
  if Keyword = 'RETR' then begin
    Client.DataStream.Position := 0;
    client.DataStream.LoadFromFile(DIR_MTP_OUTGOING + Client.peerAddr + '_deny.txt' ) ;
  end;


end;

procedure TForm1.MtpServerClientConnect(Sender: TObject; Client: TMtpCtrlSocket;  AError: Word);
begin
    if MtpServer.ClientCount  >= MtpServer.MaxClients then begin
     Client.CloseDelayed ;
     Exit;
    end;

{$IFDEF Debug_Scintilla}
  Display( 'Mtp: client connesso: ' + Client.peerAddr  );
{$ENDIF}


end;

procedure TForm1.saveDenyGrid(ClientAddr: string; sExe,sClass,sCaption: Boolean);
var
    ini : TIniFile ;
    i: Integer;
begin
    (* Salvo le tre tipologie *)

    if FileExists(DIR_MTP_OUTGOING + ClientAddr + '_deny.txt') then DeleteFile(DIR_MTP_OUTGOING + ClientAddr + '_deny.txt');

    ini := TIniFile.Create  (DIR_MTP_OUTGOING + ClientAddr + '_deny.txt');

  if sExe then begin

    ini.writeInteger('denyexe','count', griddenyexe.RowCount -2); // header + add manually...
    for I := 1 to griddenyexe.RowCount -1 do begin
      if griddenyexe.Fontcolors [0,i] <> clWhite then begin // add manually purple

        ini.WriteString('denyexe',IntToStr(i) , LowerCase(griddenyexe.Cells[0,i]) ) ;

      end;
     end;
  end;

  if sClass then begin
    ini.writeInteger('denyclass','count', griddenyClass.RowCount -2); // header + add manually...
    for I := 1 to griddenyClass.RowCount -1 do begin
      if griddenyClass.Fontcolors [0,i] <> clWhite then begin // add manually purple

        ini.WriteString('denyclass',IntToStr(i) , LowerCase(griddenyclass.Cells[0,i]) ) ;

      end;
     end;
  end;

  if sCaption then begin
    ini.writeInteger('denycaption','count', griddenyCaption.RowCount -2); // header + add manually...
    for I := 1 to griddenyCaption.RowCount -1 do begin
      if griddenyCaption.Fontcolors [0,i] <> clWhite then begin // add manually purple

        ini.WriteString('denyCaption',IntToStr(i) , LowerCase(griddenyCaption.Cells[0,i]) ) ;

      end;
     end;
  end;


    ini.Free;
end;
(*
  procedure TForm1.FadetoGray;
  var
    Win: HWND;
    DC: HDC;
    Bmp,DstBitmap: TBitmap;
    FileName: string;
    WinRect: TRect;
    Width: Integer;
    Height: Integer;
    x,y: Integer;
    ppx: PRGB;
    dst: pbyte;
    v: Byte;

  begin
    //  Application.ProcessMessages; // Was Sleep(500);
    //  Win := GetForegroundWindow;
      Win:= Form1.Handle ;
    //  if FullWindow then
    //  begin
    //    GetWindowRect(Win, WinRect);
    //    DC := GetWindowDC(Win);
    //  end else
   //   begin
        Winapi.Windows.GetClientRect(Win, WinRect);
        DC := GetDC(Win);
    //  end;

        Width := WinRect.Right - WinRect.Left;
        Height := WinRect.Bottom - WinRect.Top;

          Bmp := TBitmap.Create;
          Bmp.Height := Height;
          Bmp.Width := Width;
          Bmp.PixelFormat := pf24bit;
          BitBlt(Bmp.Canvas.Handle, 0, 0, Width, Height, DC, 0, 0, SRCCOPY);

          for y := 0 to height - 1 do  begin
            ppx := Bmp.ScanLine[y];
            for x := 0 to Bmp.Width -1 do begin
              with ppx^ do begin
                v := (r * 21 + g * 71 + b * 8) div 100;
                r := v;
                g := v;
                b := v;
              end;
              inc(ppx);
            end;
           end;
       Bmp.SaveToFile(DIR_DATA +'fadetogray.bmp');
       Bmp.Free;
       ReleaseDC(Win, DC);

      ImgGray.Picture.LoadFromFile (DIR_DATA + 'fadetogray.bmp');

      imgGray.Left :=0;
      imgGray.Top:=0;
      imgGray.Width := Form1.Width ;
      imgGray.Height := Form1.Height ;

      pnlSend.Visible := True;
      Application.ProcessMessages ;
      pnl1.Visible := false;
      pnlSettings.Visible := False;
      theater.Visible := False;
      imgGray.Visible :=true;
      imgGray.BringToFront ;
      pnlSend.Visible := True;
      pnlSend.BringToFront ;

  end;

*)
{$IFDEF Debug_Scintilla}
procedure TForm1.Display(Msg : String);
var
msg2: string;
begin
  Msg2:=Msg;
  //ReplaceS(Msg2,'|', '    ' );
  if memo2.Lines.Count  > 1000 then begin  { Prevent TMemo overflow }
        memo2.LineS.Clear ;
  end;
  memo2.Lines.add (msg2);
end;
{$endif}


procedure TForm1.MtpServerStorSessionConnected(Sender: TObject;
  Client: TMtpCtrlSocket; Data: TWSocket; AError: Word);
begin
{$IFDEF  Debug_Scintilla}
  memo2.Lines.Add('StorSessionConnected');
{$endif}

end;

end.
