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
  TPlayers = array of TPlayer;
  TWordDictionary = array of string;
  TCountLetters = 1..10;

procedure CreateBankLetters(var bank: string);
var
  i, j, k:integer;
  tempchar:char;
begin
  randomize;
  bank:='ааааааааббббввввггггддддеееееееежжжжззззииииииииййййккккллллммммннннооооооооппппррррссссттттууууууууффффххххццццччччшшшшщщщщъъъъыыыыыыыыььььээээээээююююююююяяяяяяяя';
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
   Writeln('файл словаря не найден');
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
      writeln('Недопустимое число игроков, введите другое число: ');
    end;
  end;
  SetLength(players, n);
  for var i := 0 to n - 1 do
  begin
    players[i].Letters := CutLetters(bank, 10);
    players[i].points := 0;
    players[i].fi_fi := true;
    players[i].friendHelp := true;
  end;
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
var FindSome: Boolean;
    lengthDictionary: Integer;
    summ: Integer;
begin
  FindSome := True;
  lengthDictionary := StrToInt(dictionary[0]) div 2;
  summ := lengthDictionary;
  while (FindSome) and (summ <> 0) do
  begin
    if word < dictionary[lengthDictionary] then
    begin
      summ := summ div 2;
      lengthDictionary := lengthDictionary - summ;
    end
    else if word > dictionary[lengthDictionary] then
    begin
      summ := lengthDictionary div 2;
      lengthDictionary := lengthDictionary + summ;
    end
    else
    begin
      Result := True;
      FindSome := False;
    end;
  end;
  if FindSome then
    begin
      Result := False;
    end;
end;
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

var
  bank: string;
  dictionary: TWordDictionary;
  players: TPlayers;

begin
    CreateBankLetters(bank);
    ReadWordDictionary(dictionary);
    ReadPlayers(players,bank);

    Readln;
end.


