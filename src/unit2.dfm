object ScintillaDebug: TScintillaDebug
  Left = 0
  Top = 0
  ClientHeight = 768
  ClientWidth = 691
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lbl3: TLabel
    Left = 319
    Top = 349
    Width = 282
    Height = 20
    AutoSize = False
    WordWrap = True
  end
  object lbl4: TLabel
    Left = 319
    Top = 381
    Width = 282
    Height = 20
    AutoSize = False
    WordWrap = True
  end
  object lbl5: TLabel
    Left = 319
    Top = 413
    Width = 282
    Height = 20
    AutoSize = False
    WordWrap = True
  end
  object Memo1: TMemo
    Left = 355
    Top = 107
    Width = 318
    Height = 230
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object pnlName: TPanel
    Left = 355
    Top = 8
    Width = 301
    Height = 93
    BevelOuter = bvNone
    Caption = 'Scintilla'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGreen
    Font.Height = -37
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentColor = True
    ParentFont = False
    TabOrder = 1
  end
  object pnl1: TPanel
    Left = 8
    Top = 47
    Width = 305
    Height = 250
    TabOrder = 2
    object lblText: TLabel
      Left = 20
      Top = 16
      Width = 22
      Height = 13
      Caption = 'Text'
    end
    object lblProcessTitle: TLabel
      Left = 20
      Top = 32
      Width = 51
      Height = 13
      Caption = 'Process ID'
    end
    object lblInstance: TLabel
      Left = 20
      Top = 48
      Width = 62
      Height = 13
      Caption = 'App instance'
    end
    object lblHandle: TLabel
      Left = 20
      Top = 64
      Width = 33
      Height = 13
      Caption = 'Handle'
    end
    object lblParent: TLabel
      Left = 20
      Top = 80
      Width = 67
      Height = 13
      Caption = 'Parent handle'
    end
    object lblFunction: TLabel
      Left = 20
      Top = 112
      Width = 41
      Height = 13
      Caption = 'Function'
    end
    object lblMenu: TLabel
      Left = 20
      Top = 128
      Width = 61
      Height = 13
      Caption = 'Menu handle'
    end
    object lblControlID: TLabel
      Left = 20
      Top = 96
      Width = 49
      Height = 13
      Caption = 'Control ID'
    end
    object lblClass: TLabel
      Left = 20
      Top = 147
      Width = 52
      Height = 13
      Caption = 'ClassName'
    end
    object lblModuleHandle: TLabel
      Left = 17
      Top = 164
      Width = 69
      Height = 13
      Caption = 'Module handle'
    end
    object lbl1: TLabel
      Left = 12
      Top = 190
      Width = 79
      Height = 13
      Caption = 'MainParent Text'
    end
    object lbl2: TLabel
      Left = 12
      Top = 206
      Width = 82
      Height = 13
      Caption = 'MainParent Class'
    end
    object edtText: TEdit
      Left = 104
      Top = 8
      Width = 237
      Height = 13
      HelpContext = 2
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      TabOrder = 0
      Text = 'edtText'
    end
    object edtProcess: TEdit
      Left = 104
      Top = 24
      Width = 237
      Height = 13
      HelpContext = 3
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      TabOrder = 1
      Text = 'edtProcess'
    end
    object edtInstance: TEdit
      Left = 104
      Top = 40
      Width = 237
      Height = 13
      HelpContext = 6
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      TabOrder = 2
      Text = 'edtInstance'
    end
    object edtHandle: TEdit
      Left = 104
      Top = 56
      Width = 237
      Height = 13
      HelpContext = 7
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      TabOrder = 3
      Text = 'edtHandle'
    end
    object edtParent: TEdit
      Left = 104
      Top = 72
      Width = 237
      Height = 13
      HelpContext = 8
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      TabOrder = 4
      Text = 'edtParent'
    end
    object edtFunction: TEdit
      Left = 104
      Top = 104
      Width = 237
      Height = 13
      HelpContext = 9
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      TabOrder = 5
      Text = 'edtFunction'
    end
    object edtMenu: TEdit
      Left = 104
      Top = 120
      Width = 237
      Height = 13
      HelpContext = 10
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      TabOrder = 6
      Text = 'edtMenu'
    end
    object edtControlID: TEdit
      Left = 104
      Top = 88
      Width = 237
      Height = 13
      HelpContext = 8
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      TabOrder = 7
      Text = 'edtControlID'
    end
    object edtClass: TEdit
      Left = 104
      Top = 148
      Width = 237
      Height = 13
      HelpContext = 17
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      TabOrder = 8
      Text = 'edtClass'
    end
    object edtModuleHandle: TEdit
      Left = 104
      Top = 165
      Width = 237
      Height = 13
      HelpContext = 23
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      TabOrder = 9
      Text = 'edtModuleHandle'
    end
    object edt1: TEdit
      Left = 113
      Top = 190
      Width = 237
      Height = 13
      HelpContext = 2
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      TabOrder = 10
      Text = 'edtText'
    end
    object edt2: TEdit
      Left = 113
      Top = 209
      Width = 237
      Height = 13
      HelpContext = 2
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      TabOrder = 11
      Text = 'edtText'
    end
  end
  object TPanel
    Left = 8
    Top = 303
    Width = 305
    Height = 218
    TabOrder = 3
    object lblExeName: TLabel
      Left = 12
      Top = 24
      Width = 45
      Height = 13
      Caption = 'File name'
    end
    object lblExePath: TLabel
      Left = 12
      Top = 8
      Width = 41
      Height = 13
      Caption = 'File path'
    end
    object lblCompanyName: TLabel
      Left = 12
      Top = 168
      Width = 74
      Height = 13
      Caption = 'Company name'
    end
    object lblProductName: TLabel
      Left = 12
      Top = 88
      Width = 66
      Height = 13
      Caption = 'Product name'
    end
    object lblLegalCopyright: TLabel
      Left = 12
      Top = 120
      Width = 73
      Height = 13
      Caption = 'Legal copyright'
    end
    object lblLegalTrademarks: TLabel
      Left = 12
      Top = 136
      Width = 82
      Height = 13
      Caption = 'Legal trademarks'
    end
    object lblFileDescription: TLabel
      Left = 12
      Top = 56
      Width = 71
      Height = 13
      Caption = 'File description'
    end
    object lblOriginalFilename: TLabel
      Left = 12
      Top = 40
      Width = 82
      Height = 13
      Caption = 'Original file name'
    end
    object lblFileVersion: TLabel
      Left = 12
      Top = 72
      Width = 54
      Height = 13
      Caption = 'File version'
    end
    object lblProductVersion: TLabel
      Left = 12
      Top = 152
      Width = 75
      Height = 13
      Caption = 'Product version'
    end
    object lblInternalName: TLabel
      Left = 12
      Top = 104
      Width = 67
      Height = 13
      Caption = 'Internal name'
    end
    object lblComments: TLabel
      Left = 12
      Top = 184
      Width = 50
      Height = 13
      Caption = 'Comments'
    end
    object edtExeName: TEdit
      Left = 112
      Top = 24
      Width = 229
      Height = 13
      HelpContext = 4
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      TabOrder = 0
      Text = 'edtExeName'
    end
    object edtExePath: TEdit
      Left = 112
      Top = 8
      Width = 229
      Height = 13
      HelpContext = 94
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      TabOrder = 1
      Text = 'edtExePath'
    end
    object edtCompanyName: TEdit
      Left = 112
      Top = 168
      Width = 229
      Height = 13
      HelpContext = 103
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      TabOrder = 2
      Text = 'edtCompanyName'
    end
    object edtProductName: TEdit
      Left = 112
      Top = 88
      Width = 229
      Height = 13
      HelpContext = 98
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      TabOrder = 3
      Text = 'edtProductName'
    end
    object edtLegalCopyright: TEdit
      Left = 112
      Top = 120
      Width = 229
      Height = 13
      HelpContext = 100
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      TabOrder = 4
      Text = 'edtLegalCopyright'
    end
    object edtLegalTrademarks: TEdit
      Left = 112
      Top = 136
      Width = 229
      Height = 13
      HelpContext = 101
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      TabOrder = 5
      Text = 'edtLegalTrademarks'
    end
    object edtFileDescription: TEdit
      Left = 112
      Top = 56
      Width = 229
      Height = 13
      HelpContext = 96
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      TabOrder = 6
      Text = 'edtFileDescription'
    end
    object edtOriginalFilename: TEdit
      Left = 112
      Top = 40
      Width = 229
      Height = 13
      HelpContext = 95
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      TabOrder = 7
      Text = 'edtOriginalFilename'
    end
    object edtFileVersion: TEdit
      Left = 112
      Top = 72
      Width = 229
      Height = 13
      HelpContext = 97
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      TabOrder = 8
      Text = 'edtFileVersion'
    end
    object edtProductVersion: TEdit
      Left = 112
      Top = 152
      Width = 229
      Height = 13
      HelpContext = 102
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      TabOrder = 9
      Text = 'edtProductVersion'
    end
    object edtInternalName: TEdit
      Left = 112
      Top = 104
      Width = 229
      Height = 13
      HelpContext = 99
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      TabOrder = 10
      Text = 'edtInternalName'
    end
    object edtComments: TEdit
      Left = 112
      Top = 184
      Width = 229
      Height = 13
      HelpContext = 104
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      TabOrder = 11
      Text = 'edtComments'
    end
  end
  object memo2: TMemo
    Left = 8
    Top = 521
    Width = 620
    Height = 239
    Lines.Strings = (
      'Memo1')
    TabOrder = 4
  end
  object rg1: TRadioGroup
    Left = 319
    Top = 442
    Width = 185
    Height = 73
    Caption = 'Options'
    ItemIndex = 0
    Items.Strings = (
      'Log Only'
      'Kill Processes')
    TabOrder = 5
  end
  object udp: TWSocket
    LineEnd = #13#10
    Proto = 'udp'
    LocalAddr = '0.0.0.0'
    LocalAddr6 = '::'
    LocalPort = '0'
    SocksLevel = '5'
    ExclusiveAddr = False
    ComponentOptions = []
    OnDataAvailable = udpDataAvailable
    SocketErrs = wsErrTech
    Left = 512
    Top = 446
  end
  object tcp: TWSocket
    LineEnd = #13#10
    Proto = 'tcp'
    LocalAddr = '0.0.0.0'
    LocalAddr6 = '::'
    LocalPort = '0'
    SocksLevel = '5'
    ExclusiveAddr = False
    ComponentOptions = []
    OnDataAvailable = tcpDataAvailable
    OnSessionClosed = tcpSessionClosed
    OnSessionConnected = tcpSessionConnected
    OnBgException = tcpBgException
    SocketErrs = wsErrTech
    Left = 551
    Top = 446
  end
  object iraCBTHook1: TiraCBTHook
    HookDLL = 'iraHookDLL.dll'
    OnUnfiltered = iraCBTHook1Unfiltered
    Left = 664
    Top = 448
  end
  object iraMouseHook1: TiraMouseHook
    HookDLL = 'iraHookDLL.dll'
    OnUnfiltered = iraMouseHook1Unfiltered
    Left = 663
    Top = 504
  end
  object MtpClient: TMtpClient
    StreamSize = 0
    Timeout = 0
    Port = 'ftp'
    DataPortRangeStart = 0
    DataPortRangeEnd = 0
    LocalAddr = '0.0.0.0'
    LocalAddr6 = '::'
    DisplayFileFlag = True
    OnDisplay = MtpClientDisplay
    OnError = MtpClientError
    OnResponse = MtpClientResponse
    OnSessionConnected = MtpClientSessionConnected
    OnSessionClosed = MtpClientSessionClosed
    OnStateChange = MtpClientStateChange
    OnBgException = MtpClientBgException
    SocketFamily = sfIPv4
    Left = 591
    Top = 502
  end
  object Thread: SE_ThreadTimer
    Interval = 2000
    KeepAlive = True
    OnTimer = ThreadTimer
    Left = 600
    Top = 456
  end
end
