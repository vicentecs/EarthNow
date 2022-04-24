object frmDownload: TfrmDownload
  Left = 0
  Top = 0
  Caption = 'Download'
  ClientHeight = 105
  ClientWidth = 485
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblAndamento: TLabel
    Left = 16
    Top = 45
    Width = 55
    Height = 13
    Caption = 'Andamento'
  end
  object ProgressBar: TProgressBar
    Left = 16
    Top = 64
    Width = 449
    Height = 26
    TabOrder = 0
  end
  object IdHTTP1: TIdHTTP
    IOHandler = idslhndlrscktpnsl1
    OnWork = IdHTTP1Work
    OnWorkBegin = IdHTTP1WorkBegin
    OnWorkEnd = IdHTTP1WorkEnd
    AllowCookies = True
    HandleRedirects = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 240
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 160
  end
  object idslhndlrscktpnsl1: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Method = sslvSSLv23
    SSLOptions.SSLVersions = [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2]
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 320
  end
  object tmrAtivar: TTimer
    Enabled = False
    Interval = 1
    OnTimer = tmrAtivarTimer
    Left = 96
    Top = 8
  end
end
