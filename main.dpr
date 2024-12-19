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
    letters: string[10];
    lastLetter: char;
    points: Integer;
    friendHelp: Boolean;
    fi_fi: Boolean;
  end;

  TPlayers = array of TPlayer;
  TWordDictionary = array of string;
  TCountLetters = 1 .. 10;

procedure CreateBankLetters(var bank: string);
var
  i, j, k: Integer;
  tempchar: char;
begin
  randomize;
  bank := 'ааааааааббббввввггггддддеееееееежжжжззззииииииииййййккккллллммммннннооооооооппппррррссссттттууууууууффффххххццццччччшшшшщщщщъъъъыыыыыыыыььььээээээээююююююююяяяяяяяя';
  for i := 1 to length(bank) * 2 do
  begin
    j := random(length(bank)) + 1;
    k := random(length(bank)) + 1;
    tempchar := bank[k];
    bank[k] := bank[j];
    bank[j] := tempchar;
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
    for i := Low(dictionary) to High(dictionary) do
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
  tempstring: string;
begin
  tempstring := copy(bank, 1, count);
  delete(bank, 1, count);
  result := tempstring;
end;

procedure ReadPlayers(var players: TPlayers; var bank: string);
var
  n: Integer;
  correct: Boolean;
begin
  correct := True;
  while correct do
  begin
    Readln(n);
    if (MIN_COUNT_PLAYERS <= n) and (n <= MAX_COUNT_PLAYERS) then
    begin
      correct := False;
    end
    else
    begin
      Writeln('Недопустимое число игроков, введите другое число: ');
    end;
  end;
  SetLength(players, n);
  for var i := 0 to n - 1 do
  begin
    players[i].letters := CutLetters(bank, 10);
    players[i].points := 0;
    players[i].fi_fi := True;
    players[i].friendHelp := True;
  end;
end;

procedure Game(var players: TPlayers; var bank, dictionary: string);
begin

end;

procedure PlayerStep(var players: TPlayers; var bank, dictionary: string;
  currentPlayer: Byte);
begin

end;

function CheckWordInPlayer(word, letters: string): Boolean;
begin

end;

procedure AddToDictionary(var dictionary: TWordDictionary; word: string;
  index: Integer);
var
  len, value, cod, i: Integer;
  f: TextFile;
begin
  len := length(dictionary);
  if index >= len then
    index := len + 1;
  SetLength(dictionary, len + 1);
  Move(dictionary[index], dictionary[index + 1],
    (len - index) * sizeof(dictionary[index]));
  dictionary[Index] := word;
  dictionary[0] := IntToStr(StrToInt(dictionary[0]) + 1);
  AssignFile(f, DEFAULT_PATH);
  Rewrite(f);
  for i := Low(dictionary) to High(dictionary) do
    Writeln(f, dictionary[i]);
  CloseFile(f);
end;

function CheckWordInDictionary(word: string;
  var dictionary: TWordDictionary): Boolean;
(* var AddNewWord: Boolean;
  Choise: Char; *)
var
  FindSome: Boolean;
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
      result := True;
      FindSome := False;
    end;
  end;
  if FindSome then
  begin
    Writeln('Нет такого слова (0 если есть)');
    var
      i: string;
    Readln(i);
    if i = '0' then
      AddToDictionary(dictionary, word, lengthDictionary);
    result := False;
  end;
end;
// AddNewWord := False;
(* else
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

procedure FiftyFifty(var player: TPlayer; var bank: string);
var
  change5: string;
  temp_letters: string[10];
  correct_input: Boolean;
  i, f, count_letters: Integer;
begin
  correct_input := False;
  while not correct_input do
  begin
    i := 1;
    f := 1;
    count_letters := 0;
    temp_letters := player.letters;
    Writeln('Ваш набор букв: ', player.letters);
    write('Введите буквы для обмена: ');
    Readln(change5);
    correct_input := True;
    { if length(change5) <> 5 then
      begin
      correct_input := False;
      writeln('Вы ввели неверное количество букв.');
      end; }
    for var l := 1 to length(change5) do
    begin
      if change5[l] <> ' ' then
        count_letters := count_letters + 1;
    end;
    if count_letters <> 5 then
    begin
      correct_input := False;
      Writeln('Вы ввели неверное количество букв.');
    end;
    while (i < 6) and (correct_input) do
    begin
      if change5[f] <> ' ' then
      begin
        if pos(change5[f], temp_letters) = 0 then
        begin
          correct_input := False;
          Writeln('Неверный ввод. Не все введенные вами буквы имеются в вашем наборе.');
        end
        else
        begin
          delete(temp_letters, pos(change5[f], temp_letters, 1), 1);
        end;
        i := i + 1;
      end;
      f := f + 1;
    end;
  end;

  for var k := 1 to 5 do
  begin
    player.letters := temp_letters;
  end;
  player.letters := player.letters + CutLetters(bank, 5);
end;

procedure friendHelp(var players: TPlayers; currentPlayer: Byte);
begin

end;

function IsAllSkip(players: TPlayers): Boolean;
begin

end;

var
  bank: string;
  dictionary: TWordDictionary;
  players: TPlayers;
  word: string;

begin
  // CreateBankLetters(bank);
  ReadWordDictionary(dictionary);
  // ReadPlayers(players, bank);
  // FiftyFifty(players[0], bank);
  // Readln;}
  While True do
  begin
    Readln(word);
    if CheckWordInDictionary(word, dictionary) then
      Writeln('Слово есть');
  end;
  Readln;

end.
