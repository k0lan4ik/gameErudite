program main;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

const
    MIN_COUNT_PLAYERS = 2;
    MAX_COUNT_PLAYERS = 10;
    DEFAULT_PATH = 'words.txt';

type
  TPlayer = record
      letters : string[10];
      lastLetter: char;
      points: Integer;
      friendHelp: Boolean;
      fi_fi: Boolean;
  end;
  TPlayers = array [1..MAX_COUNT_PLAYERS] of TPlayer;
  TWordDictionary = array of string;
  TCountLetters = 1..10;

procedure CreateBankLetters(var bank: string);
var
  i, j, k:integer;
  tempchar:char;
begin
  randomize;
  bank:='��������������������������������������������������������������������������������������������������������������������������������������������������������������������';
  for i := 1 to length(bank)*2 do
  begin
    j:=random(length(bank))+1;
    k:=random(length(bank))+1;
    tempchar:=bank[k];
    bank[k]:=bank[j];
    bank[j]:=tempchar;
  end;
end;

procedure ReadWordDictionary(var dictionary: TWordDictionary);
var
  wordFile: TextFile;
  word: string;
  isWord: Boolean;
  i: Integer;
begin
  AssignFile(wordFile, DEFAULT_PATH);
  try
   Reset(wordFile);
   Readln(wordFile, word);
   SetLength(dictionary, StrToInt(word) + 1);
   for i := Low(dictionary) to High(dictionary)  do
   begin
     dictionary[i] := UTF8ToANSI(word);
      Readln(wordFile, word);
   end;
   CloseFile(wordFile);
  except
   Writeln('�� ������ ���� � ������ ����');
  end;


end;

procedure ReadPlayers(var players: TPlayers; var bank: string);
var n: Integer;
    correct: Boolean;
begin
  correct := True;
  while Correct do
    begin
    ReadLn(n);
    if (MIN_COUNT_PLAYERS <= n) and (n <= MAX_COUNT_PLAYERS) then
    begin
      Correct := False;
    end
    else
    begin
      writeln('������������ ����� �������, ������� ������ �����: ');
    end;
  end;
  for var i := 1 to n do
  begin
    players[i].Letters := copy(bank, 1, 10);
    delete(bank, 1, 10);
  end;
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

function CheckWordInDictionary(word: string; dictionary: TWordDictionary): Boolean;
(*var AddNewWord: Boolean;
    Choise: Char;*)
begin
  //AddNewWord := False;
  (*else
  begin
    writeln('������� ����� ��� � �������, ������ ��� ��������? �/� ');
    ReadLn(Choise);
    if Choise = '�' then
    begin
      //AddToDictionary
      (dictionary);  ���� �������� ������� ������� ����� ��������
    end;
  end; *)
end;

function IsAllAgreement(playersCount: Byte): Boolean;
begin

end;

procedure AddToDictionary(var dictionary: TWordDictionary);
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

    Readln;
    { TODO -oUser -cConsole Main : �������� ���������� ����}

end.


