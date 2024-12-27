object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1088#1072#1074#1080#1083#1072
  ClientHeight = 446
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesktopCenter
  DesignSize = (
    624
    446)
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 1
    Width = 625
    Height = 393
    Caption = 'Panel1'
    TabOrder = 0
    object Memo1: TMemo
      Left = 16
      Top = 16
      Width = 593
      Height = 361
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 24
      Font.Name = 'Segoe UI'
      Font.Style = []
      Lines.Strings = (
        'Memo1')
      ParentFont = False
      TabOrder = 0
    end
  end
  object BitBtn1: TBitBtn
    Left = 504
    Top = 400
    Width = 112
    Height = 41
    Anchors = []
    Caption = 'OK'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 20
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = BitBtn1Click
  end
end
