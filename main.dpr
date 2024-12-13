program main;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

const
    MAX_COUNT_PLAYERS = 10;
    DEFAULT_PATH = '/dictionary.txt';

type
  TPlayer = record
      letters : string[10];
      lastLetter: char;
      points: Integer;
      friendHelp: Boolean;
      fi_fi: Boolean;
      prevSkip: Boolean;
  end;
  TPlayers = array [1..MAX_COUNT_PLAYERS] of TPlayer;
  TCountLetters = 1..10;

procedure CreateBankLetters(var bank: string);
var
  i, j, k:integer;
  tempchar:char;
begin
  randomize;
  bank:='��������������������������������������������������������������������������������������������������������������������������������';
  for i := 1 to 300 do
  begin
    j:=random(length(bank))+1;
    k:=random(length(bank))+1;
    tempchar:=bank[k];
    bank[k]:=bank[j];
    bank[j]:=tempchar;
  end;
end;

procedure ReadWordDictionary(var dictionary: string);
begin

end;

procedure ReadPlayers(var players: TPlayers; var bank: string);
begin

end;

function CutLetters(var bank: string; count: TCountLetters): string;
var
  tempstring:string;
begin
  tempstring:=copy(bank, 1, count);
  delete(bank, 1, count);
  result:=tempstring;
end;

procedure Game(var players: TPlayers;var bank, dictionary: string);
begin

end;

procedure PlayerStep(var players: TPlayers; var bank, dictionary: string; currentPlayer: Byte);
begin

end;

function CheckWordInPlayer(word, letters: string): Boolean;
begin

end;

function CheckWordInDictionary(word, dictionary: string): Boolean;
begin

end;

function IsAllAgreement(playersCount: Byte): Boolean;
begin

end;

procedure AddToDictionary(var dictionary: string);
begin

end;

procedure FiftyFifty(var player: TPlayer;var bank:string);
begin

end;

procedure FriendHelp(var players: TPlayers; currentPlayer: Byte);
begin

end;

function IsAllSkip(players: TPlayers): Boolean;
begin

end;

begin
  try
    { TODO -oUser -cConsole Main : �������� ���������� ����}
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.


