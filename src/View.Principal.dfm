object frmEarthNow: TfrmEarthNow
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Earth Now - '
  ClientHeight = 459
  ClientWidth = 775
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    775
    459)
  PixelsPerInch = 96
  TextHeight = 13
  object lblLista: TLabel
    Left = 8
    Top = 13
    Width = 81
    Height = 13
    Caption = '&Lista de Satelites'
    FocusControl = lstSatalites
  end
  object lblAtualizacao: TLabel
    Left = 263
    Top = 438
    Width = 87
    Height = 13
    Anchors = [akLeft]
    Caption = 'Ultima Atualiza'#231#227'o'
    Visible = False
  end
  object lblImagem: TLabel
    Left = 263
    Top = 13
    Width = 38
    Height = 13
    Caption = '&Imagem'
    FocusControl = wb1
  end
  object lblUltimaDT: TLabel
    Left = 359
    Top = 438
    Width = 3
    Height = 13
    Anchors = [akLeft]
    Visible = False
  end
  object lblAtualiza: TLabel
    Left = 8
    Top = 214
    Width = 46
    Height = 13
    Caption = 'A&tualizar:'
    FocusControl = cbbIntervalo
  end
  object lblSobre: TLabel
    Left = 8
    Top = 438
    Width = 66
    Height = 13
    Anchors = [akLeft]
    Caption = 'By Vicente CS'
    DragCursor = crHandPoint
    OnClick = lblSobreClick
  end
  object btnAtualizar: TButton
    Left = 8
    Top = 183
    Width = 105
    Height = 25
    Caption = '&Atualizar Lista'
    TabOrder = 1
    OnClick = btnAtualizarClick
  end
  object btnAplicar: TButton
    Left = 551
    Top = 426
    Width = 100
    Height = 25
    Anchors = [akLeft]
    Caption = 'Aplicar Imagem'
    TabOrder = 4
    OnClick = btnAplicarClick
  end
  object wb1: TWebBrowser
    Left = 263
    Top = 32
    Width = 494
    Height = 380
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 3
    ControlData = {
      4C0000000E330000462700000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object lstSatalites: TListBox
    Left = 8
    Top = 32
    Width = 249
    Height = 145
    ItemHeight = 13
    TabOrder = 0
    OnClick = lstSatalitesClick
  end
  object cbbIntervalo: TComboBox
    Left = 8
    Top = 233
    Width = 241
    Height = 21
    AutoComplete = False
    Style = csDropDownList
    ItemIndex = 1
    TabOrder = 2
    Text = 'A cada 20 minutos'
    OnChange = cbbIntervaloChange
    Items.Strings = (
      'Nunca'
      'A cada 20 minutos'
      'A cada 60 minutos')
  end
  object btnLimparCache: TButton
    Left = 657
    Top = 426
    Width = 100
    Height = 25
    Anchors = [akLeft]
    Caption = 'L&impar Cache'
    TabOrder = 5
    OnClick = btnLimparCacheClick
  end
  object tmrAtualiza: TTimer
    Enabled = False
    Interval = 60000
    OnTimer = tmrAtualizaTimer
    Left = 376
    Top = 120
  end
  object trycn1: TTrayIcon
    PopupMenu = pm1
    Visible = True
    OnDblClick = trycn1DblClick
    Left = 440
    Top = 120
  end
  object pm1: TPopupMenu
    Left = 504
    Top = 120
    object Abrir: TMenuItem
      Caption = 'Abrir'
      OnClick = AbrirClick
    end
    object Fechar: TMenuItem
      Caption = 'Fechar'
      OnClick = FecharClick
    end
  end
  object tmrMinimizar: TTimer
    Enabled = False
    Interval = 1
    OnTimer = tmrMinimizarTimer
    Left = 296
    Top = 120
  end
end
