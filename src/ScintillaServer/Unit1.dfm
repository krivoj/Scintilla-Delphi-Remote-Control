object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Scintilla Server'
  ClientHeight = 779
  ClientWidth = 1092
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
  object theater: SE_Theater
    Left = 0
    Top = 0
    Width = 1080
    Height = 437
    MouseScrollRate = 1.000000000000000000
    MouseWheelInvert = False
    MouseWheelValue = 0
    MouseWheelZoom = False
    MousePan = True
    MouseScroll = False
    BackColor = clBlack
    AnimationInterval = 20
    GridInfoCell = True
    GridVisible = False
    GridColor = clGray
    GridCellWidth = 135
    GridCellHeight = 146
    GridCellsX = 8
    GridCellsY = 3
    GridHexSmallWidth = 10
    CollisionDelay = 0
    ShowPerformance = False
    OnSpriteMouseMove = theaterSpriteMouseMove
    OnSpriteMouseDown = theaterSpriteMouseDown
    WrapHorizontal = False
    WrapVertical = False
    VirtualWidth = 1080
    Virtualheight = 437
    TabOrder = 0
    OnMouseMove = theaterMouseMove
  end
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 1073
    Height = 457
    TabOrder = 1
    Visible = False
    object lbl1: TLabel
      Left = 299
      Top = 21
      Width = 136
      Height = 14
      Alignment = taCenter
      AutoSize = False
      Caption = 'lbl1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
    end
    object lbl2: TLabel
      Left = 637
      Top = 21
      Width = 136
      Height = 17
      Alignment = taCenter
      AutoSize = False
      Caption = 'lbl1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
    end
    object grid: TAdvStringGrid
      Left = 15
      Top = 81
      Width = 1049
      Height = 361
      Cursor = crDefault
      ColCount = 3
      DrawingStyle = gdsClassic
      FixedCols = 0
      ScrollBars = ssVertical
      TabOrder = 0
      HoverRowCells = [hcNormal, hcSelected]
      OnClickCell = gridClickCell
      ActiveCellFont.Charset = DEFAULT_CHARSET
      ActiveCellFont.Color = clWindowText
      ActiveCellFont.Height = -11
      ActiveCellFont.Name = 'Tahoma'
      ActiveCellFont.Style = [fsBold]
      ControlLook.FixedGradientHoverFrom = clGray
      ControlLook.FixedGradientHoverTo = clWhite
      ControlLook.FixedGradientDownFrom = clGray
      ControlLook.FixedGradientDownTo = clSilver
      ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
      ControlLook.DropDownHeader.Font.Color = clWindowText
      ControlLook.DropDownHeader.Font.Height = -11
      ControlLook.DropDownHeader.Font.Name = 'Tahoma'
      ControlLook.DropDownHeader.Font.Style = []
      ControlLook.DropDownHeader.Visible = True
      ControlLook.DropDownHeader.Buttons = <>
      ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
      ControlLook.DropDownFooter.Font.Color = clWindowText
      ControlLook.DropDownFooter.Font.Height = -11
      ControlLook.DropDownFooter.Font.Name = 'Tahoma'
      ControlLook.DropDownFooter.Font.Style = []
      ControlLook.DropDownFooter.Visible = True
      ControlLook.DropDownFooter.Buttons = <>
      Filter = <>
      FilterDropDown.Font.Charset = DEFAULT_CHARSET
      FilterDropDown.Font.Color = clWindowText
      FilterDropDown.Font.Height = -11
      FilterDropDown.Font.Name = 'Tahoma'
      FilterDropDown.Font.Style = []
      FilterDropDown.TextChecked = 'Checked'
      FilterDropDown.TextUnChecked = 'Unchecked'
      FilterDropDownClear = '(All)'
      FilterEdit.TypeNames.Strings = (
        'Starts with'
        'Ends with'
        'Contains'
        'Not contains'
        'Equal'
        'Not equal'
        'Larger than'
        'Smaller than'
        'Clear')
      FixedColWidth = 453
      FixedRowHeight = 22
      FixedFont.Charset = DEFAULT_CHARSET
      FixedFont.Color = clWindowText
      FixedFont.Height = -11
      FixedFont.Name = 'Tahoma'
      FixedFont.Style = [fsBold]
      FloatFormat = '%.2f'
      HoverButtons.Buttons = <>
      HoverButtons.Position = hbLeftFromColumnLeft
      HTMLSettings.ImageFolder = 'images'
      HTMLSettings.ImageBaseName = 'img'
      PrintSettings.DateFormat = 'dd/mm/yyyy'
      PrintSettings.Font.Charset = DEFAULT_CHARSET
      PrintSettings.Font.Color = clWindowText
      PrintSettings.Font.Height = -11
      PrintSettings.Font.Name = 'Tahoma'
      PrintSettings.Font.Style = []
      PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
      PrintSettings.FixedFont.Color = clWindowText
      PrintSettings.FixedFont.Height = -11
      PrintSettings.FixedFont.Name = 'Tahoma'
      PrintSettings.FixedFont.Style = []
      PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
      PrintSettings.HeaderFont.Color = clWindowText
      PrintSettings.HeaderFont.Height = -11
      PrintSettings.HeaderFont.Name = 'Tahoma'
      PrintSettings.HeaderFont.Style = []
      PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
      PrintSettings.FooterFont.Color = clWindowText
      PrintSettings.FooterFont.Height = -11
      PrintSettings.FooterFont.Name = 'Tahoma'
      PrintSettings.FooterFont.Style = []
      PrintSettings.PageNumSep = '/'
      SearchFooter.FindNextCaption = 'Find &next'
      SearchFooter.FindPrevCaption = 'Find &previous'
      SearchFooter.Font.Charset = DEFAULT_CHARSET
      SearchFooter.Font.Color = clWindowText
      SearchFooter.Font.Height = -11
      SearchFooter.Font.Name = 'Tahoma'
      SearchFooter.Font.Style = []
      SearchFooter.HighLightCaption = 'Highlight'
      SearchFooter.HintClose = 'Close'
      SearchFooter.HintFindNext = 'Find next occurrence'
      SearchFooter.HintFindPrev = 'Find previous occurrence'
      SearchFooter.HintHighlight = 'Highlight occurrences'
      SearchFooter.MatchCaseCaption = 'Match case'
      ShowSelection = False
      SortSettings.DefaultFormat = ssAutomatic
      Version = '7.9.0.3'
      WordWrap = False
      ColWidths = (
        453
        206
        355)
      RowHeights = (
        22
        22
        22
        22
        22
        22
        22
        22
        22
        22)
    end
    object btn3: TButton
      Left = 13
      Top = 5
      Width = 129
      Height = 30
      Caption = 'Refresh List'
      TabOrder = 1
      OnClick = btn3Click
    end
    object btn4: TButton
      Left = 936
      Top = 5
      Width = 129
      Height = 30
      Caption = 'Close'
      TabOrder = 2
      OnClick = btn4Click
    end
    object btn1: TButton
      Left = 148
      Top = 5
      Width = 129
      Height = 30
      Caption = 'Apply rules'
      TabOrder = 3
      OnClick = btn1Click
    end
    object btn5: TButton
      Left = 801
      Top = 5
      Width = 129
      Height = 30
      Caption = 'Apply rules to all clients'
      TabOrder = 4
      OnClick = btn5Click
    end
    object TheaterBig: SE_Theater
      Left = 451
      Top = 3
      Width = 136
      Height = 72
      MouseScrollRate = 1.000000000000000000
      MouseWheelInvert = False
      MouseWheelValue = 0
      MouseWheelZoom = False
      MousePan = True
      MouseScroll = False
      BackColor = clBlack
      AnimationInterval = 0
      GridInfoCell = False
      GridVisible = False
      GridColor = clSilver
      GridCellWidth = 70
      GridCellHeight = 70
      GridCellsX = 40
      GridCellsY = 40
      GridHexSmallWidth = 10
      CollisionDelay = 0
      ShowPerformance = False
      WrapHorizontal = False
      WrapVertical = False
      VirtualWidth = 136
      Virtualheight = 72
      TabOrder = 5
      OnClick = TheaterBigClick
    end
    object btn8: TButton
      Left = 13
      Top = 41
      Width = 129
      Height = 30
      Caption = 'Shutdown'
      TabOrder = 6
      OnClick = btn8Click
    end
    object btn9: TButton
      Left = 148
      Top = 41
      Width = 129
      Height = 30
      Caption = 'Restart Windows'
      TabOrder = 7
      OnClick = btn9Click
    end
  end
  object memo2: TMemo
    Left = 753
    Top = 486
    Width = 297
    Height = 273
    Lines.Strings = (
      'memo1')
    TabOrder = 2
  end
  object pnlSend: TPanel
    Left = 373
    Top = 198
    Width = 288
    Height = 232
    TabOrder = 3
    Visible = False
    object btn6: TButton
      Left = 155
      Top = 172
      Width = 129
      Height = 41
      Caption = 'Close'
      TabOrder = 0
      OnClick = btn6Click
    end
    object btn7: TButton
      Left = 6
      Top = 172
      Width = 129
      Height = 41
      Caption = 'Apply rules'
      TabOrder = 1
      OnClick = btn7Click
    end
    object rg1: TRadioGroup
      Left = 8
      Top = 8
      Width = 265
      Height = 73
      ItemIndex = 0
      Items.Strings = (
        'Add entries'
        'Overwrite all entries')
      TabOrder = 2
    end
    object chk2: TCheckBox
      Left = 16
      Top = 96
      Width = 161
      Height = 17
      Caption = 'Exe Entries'
      Checked = True
      State = cbChecked
      TabOrder = 3
      OnClick = chk2Click
    end
    object chk3: TCheckBox
      Left = 16
      Top = 119
      Width = 161
      Height = 17
      Caption = 'ClassName Entries'
      Checked = True
      State = cbChecked
      TabOrder = 4
      OnClick = chk3Click
    end
    object chk4: TCheckBox
      Left = 16
      Top = 142
      Width = 161
      Height = 17
      Caption = 'Caption Entries'
      Checked = True
      State = cbChecked
      TabOrder = 5
      OnClick = chk4Click
    end
  end
  object pnl2: TPanel
    Left = 0
    Top = 535
    Width = 1073
    Height = 293
    TabOrder = 4
    Visible = False
    object GridDenyExe: TAdvStringGrid
      Left = 13
      Top = 20
      Width = 452
      Height = 259
      Cursor = crDefault
      ColCount = 1
      DrawingStyle = gdsClassic
      FixedCols = 0
      RowCount = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
      HoverRowCells = [hcNormal, hcSelected]
      OnClickCell = GridDenyExeClickCell
      ActiveCellFont.Charset = DEFAULT_CHARSET
      ActiveCellFont.Color = clWindowText
      ActiveCellFont.Height = -11
      ActiveCellFont.Name = 'Tahoma'
      ActiveCellFont.Style = [fsBold]
      ControlLook.FixedGradientHoverFrom = clGray
      ControlLook.FixedGradientHoverTo = clWhite
      ControlLook.FixedGradientDownFrom = clGray
      ControlLook.FixedGradientDownTo = clSilver
      ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
      ControlLook.DropDownHeader.Font.Color = clWindowText
      ControlLook.DropDownHeader.Font.Height = -11
      ControlLook.DropDownHeader.Font.Name = 'Tahoma'
      ControlLook.DropDownHeader.Font.Style = []
      ControlLook.DropDownHeader.Visible = True
      ControlLook.DropDownHeader.Buttons = <>
      ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
      ControlLook.DropDownFooter.Font.Color = clWindowText
      ControlLook.DropDownFooter.Font.Height = -11
      ControlLook.DropDownFooter.Font.Name = 'Tahoma'
      ControlLook.DropDownFooter.Font.Style = []
      ControlLook.DropDownFooter.Visible = True
      ControlLook.DropDownFooter.Buttons = <>
      Filter = <>
      FilterDropDown.Font.Charset = DEFAULT_CHARSET
      FilterDropDown.Font.Color = clWindowText
      FilterDropDown.Font.Height = -11
      FilterDropDown.Font.Name = 'Tahoma'
      FilterDropDown.Font.Style = []
      FilterDropDown.TextChecked = 'Checked'
      FilterDropDown.TextUnChecked = 'Unchecked'
      FilterDropDownClear = '(All)'
      FilterEdit.TypeNames.Strings = (
        'Starts with'
        'Ends with'
        'Contains'
        'Not contains'
        'Equal'
        'Not equal'
        'Larger than'
        'Smaller than'
        'Clear')
      FixedColWidth = 428
      FixedRowHeight = 22
      FixedFont.Charset = DEFAULT_CHARSET
      FixedFont.Color = clWindowText
      FixedFont.Height = -11
      FixedFont.Name = 'Tahoma'
      FixedFont.Style = [fsBold]
      FloatFormat = '%.2f'
      HoverButtons.Buttons = <>
      HoverButtons.Position = hbLeftFromColumnLeft
      HTMLSettings.ImageFolder = 'images'
      HTMLSettings.ImageBaseName = 'img'
      PrintSettings.DateFormat = 'dd/mm/yyyy'
      PrintSettings.Font.Charset = DEFAULT_CHARSET
      PrintSettings.Font.Color = clWindowText
      PrintSettings.Font.Height = -11
      PrintSettings.Font.Name = 'Tahoma'
      PrintSettings.Font.Style = []
      PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
      PrintSettings.FixedFont.Color = clWindowText
      PrintSettings.FixedFont.Height = -11
      PrintSettings.FixedFont.Name = 'Tahoma'
      PrintSettings.FixedFont.Style = []
      PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
      PrintSettings.HeaderFont.Color = clWindowText
      PrintSettings.HeaderFont.Height = -11
      PrintSettings.HeaderFont.Name = 'Tahoma'
      PrintSettings.HeaderFont.Style = []
      PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
      PrintSettings.FooterFont.Color = clWindowText
      PrintSettings.FooterFont.Height = -11
      PrintSettings.FooterFont.Name = 'Tahoma'
      PrintSettings.FooterFont.Style = []
      PrintSettings.PageNumSep = '/'
      SearchFooter.FindNextCaption = 'Find &next'
      SearchFooter.FindPrevCaption = 'Find &previous'
      SearchFooter.Font.Charset = DEFAULT_CHARSET
      SearchFooter.Font.Color = clWindowText
      SearchFooter.Font.Height = -11
      SearchFooter.Font.Name = 'Tahoma'
      SearchFooter.Font.Style = []
      SearchFooter.HighLightCaption = 'Highlight'
      SearchFooter.HintClose = 'Close'
      SearchFooter.HintFindNext = 'Find next occurrence'
      SearchFooter.HintFindPrev = 'Find previous occurrence'
      SearchFooter.HintHighlight = 'Highlight occurrences'
      SearchFooter.MatchCaseCaption = 'Match case'
      ShowSelection = False
      SortSettings.DefaultFormat = ssAutomatic
      Version = '7.9.0.3'
      WordWrap = False
      ColWidths = (
        428)
      RowHeights = (
        22
        22)
    end
    object gridDenyClass: TAdvStringGrid
      Left = 471
      Top = 20
      Width = 202
      Height = 259
      Cursor = crDefault
      ColCount = 1
      DrawingStyle = gdsClassic
      FixedCols = 0
      RowCount = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 1
      HoverRowCells = [hcNormal, hcSelected]
      OnClickCell = gridDenyClassClickCell
      ActiveCellFont.Charset = DEFAULT_CHARSET
      ActiveCellFont.Color = clWindowText
      ActiveCellFont.Height = -11
      ActiveCellFont.Name = 'Tahoma'
      ActiveCellFont.Style = [fsBold]
      ControlLook.FixedGradientHoverFrom = clGray
      ControlLook.FixedGradientHoverTo = clWhite
      ControlLook.FixedGradientDownFrom = clGray
      ControlLook.FixedGradientDownTo = clSilver
      ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
      ControlLook.DropDownHeader.Font.Color = clWindowText
      ControlLook.DropDownHeader.Font.Height = -11
      ControlLook.DropDownHeader.Font.Name = 'Tahoma'
      ControlLook.DropDownHeader.Font.Style = []
      ControlLook.DropDownHeader.Visible = True
      ControlLook.DropDownHeader.Buttons = <>
      ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
      ControlLook.DropDownFooter.Font.Color = clWindowText
      ControlLook.DropDownFooter.Font.Height = -11
      ControlLook.DropDownFooter.Font.Name = 'Tahoma'
      ControlLook.DropDownFooter.Font.Style = []
      ControlLook.DropDownFooter.Visible = True
      ControlLook.DropDownFooter.Buttons = <>
      Filter = <>
      FilterDropDown.Font.Charset = DEFAULT_CHARSET
      FilterDropDown.Font.Color = clWindowText
      FilterDropDown.Font.Height = -11
      FilterDropDown.Font.Name = 'Tahoma'
      FilterDropDown.Font.Style = []
      FilterDropDown.TextChecked = 'Checked'
      FilterDropDown.TextUnChecked = 'Unchecked'
      FilterDropDownClear = '(All)'
      FilterEdit.TypeNames.Strings = (
        'Starts with'
        'Ends with'
        'Contains'
        'Not contains'
        'Equal'
        'Not equal'
        'Larger than'
        'Smaller than'
        'Clear')
      FixedColWidth = 174
      FixedRowHeight = 22
      FixedFont.Charset = DEFAULT_CHARSET
      FixedFont.Color = clWindowText
      FixedFont.Height = -11
      FixedFont.Name = 'Tahoma'
      FixedFont.Style = [fsBold]
      FloatFormat = '%.2f'
      HoverButtons.Buttons = <>
      HoverButtons.Position = hbLeftFromColumnLeft
      HTMLSettings.ImageFolder = 'images'
      HTMLSettings.ImageBaseName = 'img'
      PrintSettings.DateFormat = 'dd/mm/yyyy'
      PrintSettings.Font.Charset = DEFAULT_CHARSET
      PrintSettings.Font.Color = clWindowText
      PrintSettings.Font.Height = -11
      PrintSettings.Font.Name = 'Tahoma'
      PrintSettings.Font.Style = []
      PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
      PrintSettings.FixedFont.Color = clWindowText
      PrintSettings.FixedFont.Height = -11
      PrintSettings.FixedFont.Name = 'Tahoma'
      PrintSettings.FixedFont.Style = []
      PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
      PrintSettings.HeaderFont.Color = clWindowText
      PrintSettings.HeaderFont.Height = -11
      PrintSettings.HeaderFont.Name = 'Tahoma'
      PrintSettings.HeaderFont.Style = []
      PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
      PrintSettings.FooterFont.Color = clWindowText
      PrintSettings.FooterFont.Height = -11
      PrintSettings.FooterFont.Name = 'Tahoma'
      PrintSettings.FooterFont.Style = []
      PrintSettings.PageNumSep = '/'
      SearchFooter.FindNextCaption = 'Find &next'
      SearchFooter.FindPrevCaption = 'Find &previous'
      SearchFooter.Font.Charset = DEFAULT_CHARSET
      SearchFooter.Font.Color = clWindowText
      SearchFooter.Font.Height = -11
      SearchFooter.Font.Name = 'Tahoma'
      SearchFooter.Font.Style = []
      SearchFooter.HighLightCaption = 'Highlight'
      SearchFooter.HintClose = 'Close'
      SearchFooter.HintFindNext = 'Find next occurrence'
      SearchFooter.HintFindPrev = 'Find previous occurrence'
      SearchFooter.HintHighlight = 'Highlight occurrences'
      SearchFooter.MatchCaseCaption = 'Match case'
      ShowSelection = False
      SortSettings.DefaultFormat = ssAutomatic
      Version = '7.9.0.3'
      WordWrap = False
      ColWidths = (
        174)
      RowHeights = (
        22
        22)
    end
    object gridDenyCaption: TAdvStringGrid
      Left = 679
      Top = 20
      Width = 385
      Height = 259
      Cursor = crDefault
      ColCount = 1
      DrawingStyle = gdsClassic
      FixedCols = 0
      RowCount = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 2
      HoverRowCells = [hcNormal, hcSelected]
      OnClickCell = gridDenyCaptionClickCell
      ActiveCellFont.Charset = DEFAULT_CHARSET
      ActiveCellFont.Color = clWindowText
      ActiveCellFont.Height = -11
      ActiveCellFont.Name = 'Tahoma'
      ActiveCellFont.Style = [fsBold]
      ControlLook.FixedGradientHoverFrom = clGray
      ControlLook.FixedGradientHoverTo = clWhite
      ControlLook.FixedGradientDownFrom = clGray
      ControlLook.FixedGradientDownTo = clSilver
      ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
      ControlLook.DropDownHeader.Font.Color = clWindowText
      ControlLook.DropDownHeader.Font.Height = -11
      ControlLook.DropDownHeader.Font.Name = 'Tahoma'
      ControlLook.DropDownHeader.Font.Style = []
      ControlLook.DropDownHeader.Visible = True
      ControlLook.DropDownHeader.Buttons = <>
      ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
      ControlLook.DropDownFooter.Font.Color = clWindowText
      ControlLook.DropDownFooter.Font.Height = -11
      ControlLook.DropDownFooter.Font.Name = 'Tahoma'
      ControlLook.DropDownFooter.Font.Style = []
      ControlLook.DropDownFooter.Visible = True
      ControlLook.DropDownFooter.Buttons = <>
      Filter = <>
      FilterDropDown.Font.Charset = DEFAULT_CHARSET
      FilterDropDown.Font.Color = clWindowText
      FilterDropDown.Font.Height = -11
      FilterDropDown.Font.Name = 'Tahoma'
      FilterDropDown.Font.Style = []
      FilterDropDown.TextChecked = 'Checked'
      FilterDropDown.TextUnChecked = 'Unchecked'
      FilterDropDownClear = '(All)'
      FilterEdit.TypeNames.Strings = (
        'Starts with'
        'Ends with'
        'Contains'
        'Not contains'
        'Equal'
        'Not equal'
        'Larger than'
        'Smaller than'
        'Clear')
      FixedColWidth = 351
      FixedRowHeight = 22
      FixedFont.Charset = DEFAULT_CHARSET
      FixedFont.Color = clWindowText
      FixedFont.Height = -11
      FixedFont.Name = 'Tahoma'
      FixedFont.Style = [fsBold]
      FloatFormat = '%.2f'
      HoverButtons.Buttons = <>
      HoverButtons.Position = hbLeftFromColumnLeft
      HTMLSettings.ImageFolder = 'images'
      HTMLSettings.ImageBaseName = 'img'
      PrintSettings.DateFormat = 'dd/mm/yyyy'
      PrintSettings.Font.Charset = DEFAULT_CHARSET
      PrintSettings.Font.Color = clWindowText
      PrintSettings.Font.Height = -11
      PrintSettings.Font.Name = 'Tahoma'
      PrintSettings.Font.Style = []
      PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
      PrintSettings.FixedFont.Color = clWindowText
      PrintSettings.FixedFont.Height = -11
      PrintSettings.FixedFont.Name = 'Tahoma'
      PrintSettings.FixedFont.Style = []
      PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
      PrintSettings.HeaderFont.Color = clWindowText
      PrintSettings.HeaderFont.Height = -11
      PrintSettings.HeaderFont.Name = 'Tahoma'
      PrintSettings.HeaderFont.Style = []
      PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
      PrintSettings.FooterFont.Color = clWindowText
      PrintSettings.FooterFont.Height = -11
      PrintSettings.FooterFont.Name = 'Tahoma'
      PrintSettings.FooterFont.Style = []
      PrintSettings.PageNumSep = '/'
      SearchFooter.FindNextCaption = 'Find &next'
      SearchFooter.FindPrevCaption = 'Find &previous'
      SearchFooter.Font.Charset = DEFAULT_CHARSET
      SearchFooter.Font.Color = clWindowText
      SearchFooter.Font.Height = -11
      SearchFooter.Font.Name = 'Tahoma'
      SearchFooter.Font.Style = []
      SearchFooter.HighLightCaption = 'Highlight'
      SearchFooter.HintClose = 'Close'
      SearchFooter.HintFindNext = 'Find next occurrence'
      SearchFooter.HintFindPrev = 'Find previous occurrence'
      SearchFooter.HintHighlight = 'Highlight occurrences'
      SearchFooter.MatchCaseCaption = 'Match case'
      ShowSelection = False
      SortSettings.DefaultFormat = ssAutomatic
      Version = '7.9.0.3'
      WordWrap = False
      ColWidths = (
        351)
      RowHeights = (
        22
        22)
    end
  end
  object pnl3: TPanel
    Left = 898
    Top = 443
    Width = 178
    Height = 41
    TabOrder = 5
    object btn2: TButton
      Left = 2
      Top = 0
      Width = 129
      Height = 41
      Caption = 'udpBroadcast'
      TabOrder = 0
      OnClick = btn2Click
    end
  end
  object udp: TWSocket
    LineEnd = #13#10
    Proto = 'tcp'
    LocalAddr = '0.0.0.0'
    LocalAddr6 = '::'
    LocalPort = '0'
    SocksLevel = '5'
    ExclusiveAddr = False
    ComponentOptions = []
    SocketErrs = wsErrTech
    Left = 992
    Top = 504
  end
  object TcpServer: TWSocketThrdServer
    LineEnd = #13#10
    OnLineLimitExceeded = TcpServerLineLimitExceeded
    Port = '2017'
    Proto = 'tcp'
    LocalAddr = '0.0.0.0'
    LocalAddr6 = '::'
    LocalPort = '0'
    MultiThreaded = True
    SocksLevel = '5'
    ExclusiveAddr = False
    ComponentOptions = []
    OnDataAvailable = TcpServerDataAvailable
    OnBgException = TcpServerBgException
    SocketErrs = wsErrTech
    Banner = 'Welcome to Scintilla Server'
    OnClientDisconnect = TcpServerClientDisconnect
    OnClientConnect = TcpServerClientConnect
    MultiListenSockets = <>
    ClientsPerThread = 1
    OnThreadException = TcpServerThreadException
    Left = 872
    Top = 560
  end
  object en_client: SE_Engine
    PixelCollision = False
    HiddenSpritesMouseMove = False
    IsoPriority = False
    Priority = 0
    Theater = theater
    Left = 1048
    Top = 496
  end
  object en_one: SE_Engine
    ClickSprites = False
    PixelCollision = False
    HiddenSpritesMouseMove = False
    IsoPriority = False
    Priority = 0
    Theater = TheaterBig
    Left = 1048
    Top = 544
  end
  object MtpServer: TMtpServer
    Addr = '0.0.0.0'
    BindFtpData = False
    SocketFamily = sfIPv4
    Port = 'ftp'
    ListenBackLog = 5
    MultiListenSockets = <>
    UserData = 0
    MaxClients = 0
    TimeoutSecsLogin = 0
    TimeoutSecsIdle = 0
    TimeoutSecsXfer = 0
    AlloExtraSpace = 1000000
    MaxAttempts = 12
    OnClientConnect = MtpServerClientConnect
    OnClientCommand = MtpServerClientCommand
    OnStorSessionConnected = MtpServerStorSessionConnected
    OnStorSessionClosed = MtpServerStorSessionClosed
    OnStorDataAvailable = MtpServerStorDataAvailable
    OnBgException = MtpServerBgException
    Left = 1040
    Top = 608
  end
end
