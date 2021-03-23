object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'EasyPost'
  ClientHeight = 377
  ClientWidth = 1033
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Icon.Data = {
    0000010001001010000001002000680400001600000028000000100000002000
    0000010020000000000000040000000000000000000000000000000000000000
    00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
    00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
    00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
    00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
    00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
    00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
    00FF000000FF000000FF000000FF000000FF000000FF000000FF080808FF0B0B
    0BFF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
    00FF000000FF000000FF000000FF000000FF000000FF424242FFBCBCBCFFB8B8
    B8FF454545FF020202FF000000FF000000FF000000FF000000FF000000FF0000
    00FF000000FF000000FF000000FF030303FF5E5E5EFFB7B7B7FFCCCCCCFFD0D0
    D0FFAFAFAFFF6F6F6FFF050505FF000000FF000000FF000000FF000000FF0000
    00FF000000FF000000FF0C0C0CFF8A8A8AFFAEAEAEFFC6C6C6FFCCCCCCFFD0D0
    D0FFCECECEFFA5A5A5FF898989FF0F0F0FFF000000FF000000FF000000FF0000
    00FF000000FF1F1F1FFFAEAEAEFFC8C8C8FFC8C8C8FFC6C6C6FFCCCCCCFFD0D0
    D0FFCECECEFFC8C8C8FFC8C8C8FFB2B2B2FF272727FF000000FF000000FF0000
    00FF040404FFC3C3C3FFCBCBCBFFC8C8C8FFC8C8C8FFC6C6C6FFCCCCCCFFD0D0
    D0FFCECECEFFC8C8C8FFC8C8C8FFCBCBCBFFC3C3C3FF010101FF000000FF0000
    00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
    00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
    00FF040404FFC3C3C3FFCBCBCBFFC8C8C8FFC9C9C9FFC7C7C7FFCCCCCCFFD0D0
    D0FFCECECEFFC9C9C9FFC8C8C8FFCBCBCBFFC3C3C3FF010101FF000000FF0000
    00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
    00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
    00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
    00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
    00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
    00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
    00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
    00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
    00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
    00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object LabelCurrentClipboard: TLabel
    Left = 8
    Top = 8
    Width = 85
    Height = 13
    Caption = 'Current Clipboard'
  end
  object LabelLastClipboard: TLabel
    Left = 8
    Top = 157
    Width = 68
    Height = 13
    Caption = 'Last Clipboard'
  end
  object LabelPostResults: TLabel
    Left = 528
    Top = 8
    Width = 59
    Height = 13
    Caption = 'Post Results'
  end
  object MemoCurrent: TMemo
    Left = 8
    Top = 24
    Width = 502
    Height = 121
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object MemoLast: TMemo
    Left = 8
    Top = 176
    Width = 502
    Height = 121
    Color = clBtnFace
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object MemoResult: TMemo
    Left = 528
    Top = 24
    Width = 497
    Height = 341
    Color = clBtnFace
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object LabeledEditWrongPost: TLabeledEdit
    Left = 8
    Top = 344
    Width = 121
    Height = 21
    Color = clBtnFace
    EditLabel.Width = 56
    EditLabel.Height = 13
    EditLabel.Caption = 'Wrong Post'
    ReadOnly = True
    TabOrder = 3
    Text = '0'
  end
  object LabeledEditError: TLabeledEdit
    Left = 135
    Top = 344
    Width = 121
    Height = 21
    Color = clBtnFace
    EditLabel.Width = 24
    EditLabel.Height = 13
    EditLabel.Caption = 'Error'
    ReadOnly = True
    TabOrder = 4
    Text = '0'
  end
  object LabeledEditSuccess: TLabeledEdit
    Left = 262
    Top = 344
    Width = 121
    Height = 21
    Color = clBtnFace
    EditLabel.Width = 38
    EditLabel.Height = 13
    EditLabel.Caption = 'Success'
    ReadOnly = True
    TabOrder = 5
    Text = '0'
  end
  object LabeledEditSkip: TLabeledEdit
    Left = 389
    Top = 344
    Width = 121
    Height = 21
    Color = clBtnFace
    EditLabel.Width = 19
    EditLabel.Height = 13
    EditLabel.Caption = 'Skip'
    ReadOnly = True
    TabOrder = 6
    Text = '0'
  end
  object TrayIcon: TTrayIcon
    Icons = ImageListTray
    PopupMenu = PopupMenuTray
    Visible = True
    Left = 648
    Top = 72
  end
  object ImageListTray: TImageList
    Left = 704
    Top = 88
    Bitmap = {
      494C010101000800040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF080808FF0B0B0BFF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF424242FFBCBCBCFFB8B8B8FF454545FF020202FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF030303FF5E5E5EFFB7B7B7FFCCCCCCFFD0D0D0FFAFAFAFFF6F6F6FFF0505
      05FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0C0C
      0CFF8A8A8AFFAEAEAEFFC6C6C6FFCCCCCCFFD0D0D0FFCECECEFFA5A5A5FF8989
      89FF0F0F0FFF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF1F1F1FFFAEAE
      AEFFC8C8C8FFC8C8C8FFC6C6C6FFCCCCCCFFD0D0D0FFCECECEFFC8C8C8FFC8C8
      C8FFB2B2B2FF272727FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF040404FFC3C3C3FFCBCB
      CBFFC8C8C8FFC8C8C8FFC6C6C6FFCCCCCCFFD0D0D0FFCECECEFFC8C8C8FFC8C8
      C8FFCBCBCBFFC3C3C3FF010101FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF040404FFC3C3C3FFCBCB
      CBFFC8C8C8FFC9C9C9FFC7C7C7FFCCCCCCFFD0D0D0FFCECECEFFC9C9C9FFC8C8
      C8FFCBCBCBFFC3C3C3FF010101FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
  object PopupMenuTray: TPopupMenu
    Left = 760
    Top = 104
    object menuShowMainFormDebug: TMenuItem
      Caption = 'Show Main Form (Debug)'
      OnClick = menuShowMainFormDebugClick
    end
    object menuQuit: TMenuItem
      Caption = 'Quit'
      OnClick = menuQuitClick
    end
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 648
    Top = 144
  end
  object IdHTTP: TIdHTTP
    IOHandler = IdSSLIOHandlerSocketOpenSSL
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.AcceptLanguage = 'ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3'
    Request.BasicAuthentication = False
    Request.UserAgent = 'EasyPost'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 704
    Top = 160
  end
  object IdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 760
    Top = 176
  end
end
