unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  MMSystem;

const
  DEFAULT_PATH_BTN_SOUND = 'btn.wav';

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    Memo1: TMemo;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    class procedure ShowRules(FilePath: string);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

class procedure TForm1.ShowRules(FilePath: string);
var
  MessageForm: TForm1;
begin
  MessageForm := TForm1.Create(nil);
  try
    MessageForm.Memo1.ScrollBars := ssVertical;
    MessageForm.Memo1.Lines.LoadFromFile(FilePath, TEncoding.UTF8);
    MessageForm.Memo1.ReadOnly := True;
    MessageForm.ShowModal;
  finally
    MessageForm.Free;
  end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  dwVolume: DWORD;
  NormalizedVolume: Integer;
begin
  PlaySound(DEFAULT_PATH_BTN_SOUND,0,SND_FILENAME OR SND_NOSTOP OR SND_ASYNC);
  Close;
end;

end.
