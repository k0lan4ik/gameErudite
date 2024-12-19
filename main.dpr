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
      dictionary[i] := word;
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

function CheckLettersInPlayer(var players: TPlayers; var word: String; letters: string; currentPlayer: Byte): Boolean;
var ThereIs: Boolean;
    NumOfLetters: Integer;
    NumOfChar: Integer;
begin
  NumOfLetters := 1;
  ThereIs := True;
  while ThereIs and (NumOfLetters <= length(word)) do
  begin
    NumOfChar := pos(word[NumOfLetters], players[currentPlayer].letters);
    if NumOfChar <> 0 then
    begin
      NumOfLetters := NumOfLetters + 1;
      delete(players[currentPlayer].letters, NumOfChar, 1);
    end
    else
    begin
      ThereIs := False;
    end;
  end;
  Result := ThereIs;
end;

procedure AddToDictionary(var dictionary: TWordDictionary; word: string;
  index: Integer);
var
  len, value, cod, i: Integer;
  f: TextFile;
begin
  len := length(dictionary);
  Insert(word, dictionary, index);
  { Move(dictionary[index], dictionary[index + 1],
    (len - index - 1)); }
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
  left, right, mid, index: Integer;
begin
  result := False;
  left := 1;
  right := StrToInt(dictionary[0]);
  while (left <= right) do
  begin
    mid := (left + right) div 2;
    if word = dictionary[mid] then
    begin
      Result := True;
      left := right + 1;
    end
    else if word > dictionary[mid] then
    begin
      left := mid + 1;
      index := left;
    end
    else
    begin
      right := mid - 1;
      index := mid;
    end;
  end;
  if not Result then
  begin
    Writeln('Нет такого слова (0 если есть)');
    var
      i: string;
    Readln(i);
    if i = '0' then
      AddToDictionary(dictionary, word, index);
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
var
  temp, indexgivenchar, indextakenchar, correctvalue: Integer;
  givenchar, takenchar, tempchar: ansichar;
  tempstring: string;
  uncorrect: Boolean;
begin
  write('Ваш набор букв: ');
  // setout(players[CurrentPlayer].letters);
  temp := 0;
  while temp < length(players) do
  begin
    if temp <> currentPlayer then
    begin
      write('Набор игрока ', temp + 1, ': ');
      // setout(players[temp].letters);
    end;
    Inc(temp);
  end;
  uncorrect := True;
  while uncorrect do
  begin
    Writeln('Выберите букву которую вы хотите поменять');
    Readln(givenchar);
    indexgivenchar := pos(givenchar, players[currentPlayer].letters);
    if indexgivenchar <> 0 then
      uncorrect := False
    else
      Writeln('У вас нет такой буквы');
  end;
  uncorrect := True;
  while uncorrect do
  begin
    correctvalue := 1;
    while correctvalue <> 0 do
    begin
      Writeln('Введите номер игрока с которым хотите поменяться');
      Readln(tempstring);
      temp := length(tempstring);
      while tempstring[temp] = ' ' do
        Dec(temp);
      delete(tempstring, temp + 1, length(tempstring) - temp);
      Val(tempstring, temp, correctvalue);
    end;
    Dec(temp);
    if temp = currentPlayer then
      Writeln('Вы не можете поменяться с собой')
    else if (temp < 0) or (temp > length(players) - 1) then
      Writeln('Такого игрока не существует')
    else
      uncorrect := False;
  end;
  uncorrect := True;
  while uncorrect do
  begin
    Writeln('Выберете букву которую хотите взять у игрока ', temp + 1);
    Readln(takenchar);
    indextakenchar := pos(takenchar, players[temp].letters);
    if indextakenchar <> 0 then
      uncorrect := False
    else
      Writeln('У него нет такой буквы');
  end;
  players[currentPlayer].letters[indexgivenchar] := takenchar;
  players[temp].letters[indextakenchar] := givenchar;
end;

function IsAllSkip(players: TPlayers): Boolean;
var
  temp: Integer;
  skip: Boolean;
begin
  temp := low(players);
  skip := True;
  while skip and (temp <= high(players)) do
  begin
    if players[temp].lastLetter <> ' ' then
      skip := False;
    Inc(temp);
  end;
  result := skip;
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
