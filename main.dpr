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
var change5: string;
    temp_letters: string[10];
    correct_input: boolean;
    i, f, count_letters: integer;
begin
  correct_input := False;
  while not correct_input do
  begin
    i := 1;
    f := 1;
    count_letters := 0;
    temp_letters := player.letters;
    writeln('Ваш набор букв: ', player.letters);
    write('Введите буквы для обмена: ');
    readln(change5);
    correct_input := True;
    {if length(change5) <> 5 then
    begin
      correct_input := False;
      writeln('Вы ввели неверное количество букв.');
    end;}
    for var l := 1 to length(change5) do
    begin
      if change5[l] <> ' ' then
      count_letters := count_letters + 1;
    end;
    if count_letters <> 5 then
    begin
      correct_input := False;
      writeln('Вы ввели неверное количество букв.');
    end;
    while (i < 6) and (correct_input) do
    begin
      if change5[f] <> ' ' then
      begin
        if pos(change5[f], temp_letters) = 0 then
        begin
          correct_input := False;
          writeln('Неверный ввод. Не все введенные вами буквы имеются в вашем наборе.');
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

procedure setout(letters:string);
var
  temp:integer;
begin
  for temp := 1 to length(letters) do
    write(letters[temp], ' ');
  writeln;
end;

procedure FriendHelp(var players: TPlayers; currentPlayer: Byte);
var
  temp, indexgivenchar, indextakenchar, correctvalue:integer;
  givenchar, takenchar, tempchar:ansichar;
  tempstring: string;
  uncorrect:boolean;
begin
  write('Ваш набор букв: ');
  setout(players[CurrentPlayer].letters);
  temp:=0;
  while temp < length(players) do
  begin
    if temp <> currentPlayer then
    begin
      write('Набор игрока ', temp+1, ': ');
      setout(players[temp].letters);
    end;
    Inc(temp);
  end;
  uncorrect:=true;
  while uncorrect do
  begin
    writeln('Выберите букву которую вы хотите поменять');
    readln(givenchar);
    indexgivenchar:=pos(givenchar, players[currentPlayer].letters);
    if indexgivenchar <> 0 then
      uncorrect:=false
    else
      writeln('У вас нет такой буквы');
  end;
  uncorrect:=true;
  while uncorrect do
  begin
    correctvalue:=1;
    while correctvalue <> 0 do
    begin
      writeln('Введите номер игрока с которым хотите поменяться');
      readln(tempstring);
      temp:=length(tempstring);
      while tempstring[temp] = ' ' do
        Dec(temp);
      delete(tempstring, temp+1, length(tempstring)-temp);
      Val(tempstring, temp, correctvalue);
    end;
    Dec(temp);
    if temp = currentPlayer then
      writeln('Вы не можете поменяться с собой')
    else if (temp < 0) or (temp > length(players)-1) then
      writeln ('Такого игрока не существует')
    else
      uncorrect:=false;
  end;
  uncorrect:=true;
  while uncorrect do
  begin
    Writeln('Выберете букву которую хотите взять у игрока ', temp+1);
    readln(takenchar);
    indextakenchar:=pos(takenchar, players[temp].letters);
    if indextakenchar <> 0 then
      uncorrect:=false
    else
      writeln('У него нет такой буквы');
  end;
  players[currentPlayer].letters[indexgivenchar]:=takenchar;
  players[temp].letters[indextakenchar]:=givenchar;
end;

function IsAllSkip(players: TPlayers): Boolean;
var
  temp:integer;
  skip:boolean;
begin
  temp:=low(players);
  skip:=true;
  while skip and (temp <= high(players)) do
  begin
    if players[temp].lastletter <> ' ' then
      skip:=false;
    Inc(temp);
  end;
  result:=skip;
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


