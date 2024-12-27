unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Unit1, MMSystem, Vcl.MPlayer;

const
  MIN_COUNT_PLAYERS = 2;
  MAX_COUNT_PLAYERS = 10;
  WheelDelta = 10;
  DEFAULT_PATH_DIC = 'words.txt';
  DEFAULT_PATH_RULE = 'rule.txt';
  DEFAULT_PATH_BTN_SOUND = 'btn.wav';
  DEFAULT_PATH_MAIN_SOUND = 'audio.wav';
  DEFAULT_DIR_SAVE = 'Saves';
  DEFAULT_FORM_SAVE = '.bup';
  VOLUME = 50;

type

  TLetterButton = class(TButton)
  private
    FIsInWord: Boolean;
    FStartVertexLeft: Integer;
    FStartVertexTop: Integer;
    FId: Integer;
  public
    constructor Create(AOwner: TComponent; Id: Integer);
    property IsInWord: Boolean read FIsInWord write FIsInWord;
    property StartVertexLeft: Integer read FStartVertexLeft
      write FStartVertexLeft;
    property StartVertexTop: Integer read FStartVertexTop write FStartVertexTop;
    property Id: Integer read FId;
  end;

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

  TButtons = array of TButton;
  TLetterButtons = array of TLetterButton;

  TForm2 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button3: TButton;
    Panel2: TPanel;
    Panel3: TPanel;
    Button4: TButton;
    Button5: TButton;
    Button16: TButton;
    Label1: TLabel;
    Panel4: TPanel;
    Label2: TLabel;
    Button6: TButton;
    Button7: TButton;
    Panel5: TPanel;
    Label3: TLabel;
    Button8: TButton;
    Button9: TButton;
    Panel6: TPanel;
    Button10: TButton;
    Button11: TButton;
    Panel7: TPanel;
    Label4: TLabel;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Label5: TLabel;
    Button2: TButton;
    ScrollBox1: TScrollBox;
    MediaPlayer1: TMediaPlayer;
    procedure CreateNewGame(Sender: TObject);
    procedure OnClickLetter(Sender: TObject);
    procedure OnClickFifty(Sender: TObject);
    procedure OnClickFriend(Sender: TObject);
    procedure OnClickSave(Sender: TObject);
    procedure NextPlayer(Sender: TObject);
    procedure friendHelp(Sender: TObject);
    procedure FiftyFifty(Sender: TObject);
    procedure ConfimFriendHelp(Sender: TObject);
    procedure ConfimFiftyFifty(Sender: TObject);
    procedure Rule(Sender: TObject);
    procedure BackFromSave(Sender: TObject);
    procedure ConfimSave(Sender: TObject);
    procedure OpenSave(Sender: TObject);
    procedure ConfimCountPlayers(Sender: TObject);
    procedure AddCountPlayer(Sender: TObject);
    procedure OddCountPlayer(Sender: TObject);
    procedure OnLoad(Sender: TObject);
    procedure PastFriend(Sender: TObject);
    procedure NextFriend(Sender: TObject);
    procedure OnResize(Sender: TObject);
    procedure OnCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
      var Resize: Boolean);
    procedure MediaPlayer1Notify(Sender: TObject);

  private
    Word: TLetterButtons;
    LetterButtons: TLetterButtons;
    FriendButtons: array [0 .. 1] of TLetterButtons;
    SaveButtons: TButtons;
    bank: string;
    dictionary: TWordDictionary;
    players: TPlayers;
    SaveName: string;
    LSize, HSize: Real;
    currentPlayer, prevPlayer, countPlayer, friendPlayer, FWidgh, FHeight,
      px: Integer;
    sr: TSearchRec;
    // функционал
    procedure NewGame;
    procedure StartGame;
    procedure ReadSave;
    procedure ReadWordDictionary(var dictionary: TWordDictionary);
    procedure CreateBankLetters(var bank: string);
    procedure CreatePlayers(var players: TPlayers; countPlayers: Integer);
    function CutLetters(var bank: string; count: TCountLetters): string;
    function CheckWordInDictionary(Word: string;
      var dictionary: TWordDictionary; var index: Integer): Boolean;
    procedure DeleteLettersInPlayer(var player: TPlayer; Word: string);
    function CheckLettersInPlayer(var Word: String; letters: string): Boolean;
    procedure AddToDictionary(var dictionary: TWordDictionary; Word: string;
      index: Integer);
    function IsAllAgreement(playersCount, currentPlayer: Byte): Boolean;
    procedure SaveGame(players: TPlayers; bank: string; currentPlayer: Integer;
      SaveName: string);
    function IsAllSkip(players: TPlayers): Boolean;
    procedure CreateFiftyButtons(lettersPlayer: string);
    procedure CreateFirendButtons(lettersPlayer: string; lettersFriend: string;
      onlyFirst: Boolean);
    procedure CreateButtons(letters: string);
    procedure DeleteButtons(var Buttons: TLetterButtons); overload;
    procedure DeleteButtons(var Buttons: TButtons); overload;
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

constructor TLetterButton.Create(AOwner: TComponent; Id: Integer);
begin
  inherited Create(AOwner);
  FId := Id;
  FIsInWord := false;
end;

function TForm2.IsAllSkip(players: TPlayers): Boolean;
var
  temp: Integer;
  skip: Boolean;
begin
  temp := low(players);
  skip := True;
  while skip and (temp <= high(players)) do
  begin
    if players[temp].lastLetter <> ' ' then
      skip := false;
    Inc(temp);
  end;
  result := skip;
end;

procedure TForm2.MediaPlayer1Notify(Sender: TObject);
begin
  if MediaPlayer1.NotifyValue = nvSuccessful then
    MediaPlayer1.Play;
end;

procedure TForm2.CreateBankLetters(var bank: string);
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

procedure TForm2.NewGame;
begin

  SaveName := FormatDateTime('dd_mm_yyyy_hhmmss', Now) + DEFAULT_FORM_SAVE;
  CreateBankLetters(bank);
  CreatePlayers(players, countPlayer);
  currentPlayer := Low(players);
  prevPlayer := High(players);
end;

procedure TForm2.StartGame;
begin
  ReadWordDictionary(dictionary);
  DeleteButtons(LetterButtons);
  CreateButtons(players[currentPlayer].letters);
  Button4.Enabled := players[currentPlayer].fi_fi;
  Button5.Enabled := players[currentPlayer].friendHelp;
  Label1.Caption := 'Игрок ' + IntToStr(currentPlayer + 1);
end;

procedure TForm2.ReadWordDictionary(var dictionary: TWordDictionary);
var
  wordFile: TextFile;
  Word: string;
  isWord: Boolean;
  i: Integer;
begin
  AssignFile(wordFile, DEFAULT_PATH_DIC);
  try
    Reset(wordFile);
    Readln(wordFile, Word);
    SetLength(dictionary, StrToInt(Word) + 1);
    for i := Low(dictionary) to High(dictionary) do
    begin
      dictionary[i] := Word;
      Readln(wordFile, Word);
    end;
    CloseFile(wordFile);
  except
    ShowMessage('Не найден словарь');
  end;

end;

procedure TForm2.CreatePlayers(var players: TPlayers; countPlayers: Integer);
begin
  SetLength(players, countPlayers);
  for var i := 0 to countPlayers - 1 do
  begin
    players[i].letters := CutLetters(bank, 10);
    players[i].points := 0;
    players[i].fi_fi := True;
    players[i].friendHelp := True;
  end;
end;

function TForm2.CutLetters(var bank: string; count: TCountLetters): string;
var
  tempstring: string;
begin
  tempstring := copy(bank, 1, count);
  delete(bank, 1, count);
  result := tempstring;
end;

procedure TForm2.DeleteLettersInPlayer(var player: TPlayer; Word: string);
var
  temp: Integer;
begin
  for temp := 1 to length(Word) do
  begin
    delete(player.letters, pos(Word[temp], player.letters), 1);
  end;
end;

function TForm2.IsAllAgreement(playersCount, currentPlayer: Byte): Boolean;
var
  temp, amountyes: Integer;
begin
  amountyes := 0;
  for temp := 1 to playersCount do
  begin
    if temp <> currentPlayer + 1 then
    begin
      if MessageDlg(('Игрок ' + IntToStr(temp) + #13 +
        'Вы согласны добавить в словарь слово?'), mtInformation, [mbYes, mbNo],
        0) = mrYes then
        Inc(amountyes);
    end;
  end;
  Inc(amountyes);
  result := (amountyes / playersCount) > 0.5;
end;

function TForm2.CheckWordInDictionary(Word: string;
  var dictionary: TWordDictionary; var index: Integer): Boolean;
var
  left, right, mid: Integer;
begin
  result := false;
  left := 1;
  right := StrToInt(dictionary[0]);
  while (left <= right) do
  begin
    mid := (left + right) div 2;
    if Word = dictionary[mid] then
    begin
      result := True;
      left := right + 1;
    end
    else if Word > dictionary[mid] then
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
  if not result then
  begin
    result := false;
  end;
end;

function TForm2.CheckLettersInPlayer(var Word: String; letters: string)
  : Boolean;
var
  ThereIs: Boolean;
  NumOfLetters: Integer;
  NumOfChar: Integer;
begin
  NumOfLetters := 1;
  ThereIs := True;
  while ThereIs and (NumOfLetters <= length(Word)) do
  begin
    NumOfChar := pos(Word[NumOfLetters], letters);
    if NumOfChar <> 0 then
    begin
      NumOfLetters := NumOfLetters + 1;
      delete(letters, NumOfChar, 1);
    end
    else
    begin
      ThereIs := false;
    end;
  end;
  result := ThereIs;
end;

procedure TForm2.AddToDictionary(var dictionary: TWordDictionary; Word: string;
  index: Integer);
var
  value, cod, i: Integer;
  f: TextFile;
begin
  Insert(Word, dictionary, index);
  dictionary[Index] := Word;
  dictionary[0] := IntToStr(StrToInt(dictionary[0]) + 1);
  AssignFile(f, DEFAULT_PATH_DIC);
  Rewrite(f);
  for i := Low(dictionary) to High(dictionary) do
    Writeln(f, dictionary[i]);
  CloseFile(f);
end;

procedure TForm2.ReadSave;
var
  SaveFile: TextFile;
  i, len: Integer;
  str: string;
begin
  AssignFile(SaveFile, DEFAULT_DIR_SAVE + '\' + SaveName);
  Reset(SaveFile);
  Readln(SaveFile, len);
  SetLength(players, len);
  for i := 0 to len - 1 do
  begin
    Readln(SaveFile, players[i].letters);
    Readln(SaveFile, players[i].lastLetter);
    Readln(SaveFile, players[i].points);
    Readln(SaveFile, str);
    players[i].friendHelp := StrToBool(str);
    Readln(SaveFile, str);
    players[i].fi_fi := StrToBool(str);
  end;
  Readln(SaveFile, currentPlayer);
  Readln(SaveFile, bank);
  CloseFile(SaveFile);
end;

procedure TForm2.SaveGame(players: TPlayers; bank: string;
  currentPlayer: Integer; SaveName: string);
var
  SaveFile: TextFile;
  i: Integer;
begin
  AssignFile(SaveFile, DEFAULT_DIR_SAVE + '\' + SaveName);
  Rewrite(SaveFile);
  Writeln(SaveFile, length(players));
  for i := Low(players) to High(players) do
  begin
    Writeln(SaveFile, players[i].letters);
    Writeln(SaveFile, players[i].lastLetter);
    Writeln(SaveFile, players[i].points);
    Writeln(SaveFile, players[i].friendHelp);
    Writeln(SaveFile, players[i].fi_fi);
  end;
  Writeln(SaveFile, currentPlayer);
  Writeln(SaveFile, bank);
  CloseFile(SaveFile);
end;

procedure TForm2.ConfimSave(Sender: TObject);
var
  i: Integer;
begin
  PlaySound(DEFAULT_PATH_BTN_SOUND, 0, SND_FILENAME OR SND_NOSTOP OR SND_ASYNC);
  Panel6.Visible := false;
  Panel2.Visible := True;
  for i := Low(SaveButtons) to High(SaveButtons) do
    if not SaveButtons[i].Enabled then
      SaveName := SaveButtons[i].Caption;
  ReadSave;
  StartGame;
end;

procedure TForm2.BackFromSave(Sender: TObject);
begin
  PlaySound(DEFAULT_PATH_BTN_SOUND, 0, SND_FILENAME OR SND_NOSTOP OR SND_ASYNC);
  Panel6.Visible := false;
  Panel1.Visible := True;
  DeleteButtons(SaveButtons);
end;

procedure TForm2.AddCountPlayer(Sender: TObject);
begin
  PlaySound(DEFAULT_PATH_BTN_SOUND, 0, SND_FILENAME OR SND_NOSTOP OR SND_ASYNC);
  Inc(countPlayer);
  if countPlayer >= MAX_COUNT_PLAYERS then
    Button12.Enabled := false;
  if countPlayer > MIN_COUNT_PLAYERS then
    Button13.Enabled := True;
  Label5.Caption := IntToStr(countPlayer);
end;

procedure TForm2.OddCountPlayer(Sender: TObject);
begin
  PlaySound(DEFAULT_PATH_BTN_SOUND, 0, SND_FILENAME OR SND_NOSTOP OR SND_ASYNC);
  Dec(countPlayer);
  if countPlayer < MAX_COUNT_PLAYERS then
    Button12.Enabled := True;
  if countPlayer <= MIN_COUNT_PLAYERS then
    Button13.Enabled := false;
  Label5.Caption := IntToStr(countPlayer);
end;

procedure TForm2.ConfimCountPlayers(Sender: TObject);
begin
  PlaySound(DEFAULT_PATH_BTN_SOUND, 0, SND_FILENAME OR SND_NOSTOP OR SND_ASYNC);
  Panel2.Visible := True;
  Panel7.Visible := false;
  NewGame;
  StartGame;
end;

procedure TForm2.NextPlayer(Sender: TObject);
var
  strWord: string;
  index, maxpoints: Integer;
  isRight: Boolean;
begin
  PlaySound(DEFAULT_PATH_BTN_SOUND, 0, SND_FILENAME OR SND_NOSTOP OR SND_ASYNC);
  strWord := '';
  for index := Low(Word) to High(Word) do
  begin
    strWord := strWord + Word[index].Caption;
  end;

  if strWord = '' then
  begin
    players[currentPlayer].lastLetter := ' ';
    strWord := 'Вы пропустили ход ' + #13;
  end
  else
  begin
    if CheckWordInDictionary(strWord, dictionary, index) then
    begin
      isRight := CheckLettersInPlayer(strWord, players[currentPlayer].letters)
    end
    else
    begin
      if MessageDlg('Данного слова нет в словаре, добавить?', mtInformation,
        [mbYes, mbNo], 0) = mrYes then
      begin
        if IsAllAgreement(length(players), currentPlayer) then
        begin
          AddToDictionary(dictionary, strWord, index);
          isRight := CheckLettersInPlayer(strWord,
            players[currentPlayer].letters)
        end
        else
        begin
          isRight := false;
        end;
      end
      else
      begin
        isRight := false;
      end;

    end;
    players[currentPlayer].lastLetter := strWord[High(strWord)];
    if isRight then
    begin

      if strWord[Low(strWord)] = players[prevPlayer].lastLetter then
        Inc(players[currentPlayer].points, length(strWord) * 2)
      else
        Inc(players[currentPlayer].points, length(strWord));
      DeleteLettersInPlayer(players[currentPlayer], strWord);
      players[currentPlayer].letters := players[currentPlayer].letters +
        CutLetters(bank, length(strWord));
      strWord := ('Вы правильно ввели слово' + #13);
    end
    else
    begin
      Dec(players[currentPlayer].points, length(strWord));
      strWord := 'Вы неправильно ввели слово' + #13;
    end;
  end;

  strWord := strWord + 'Ваши очки: ' + IntToStr(players[currentPlayer].points);
  MessageDlg(strWord, mtInformation, [mbOk], 0);

  if IsAllSkip(players) then
  begin
    strWord := '';
    maxpoints := players[low(players)].points;
    for index := Low(players) to High(players) do
    begin
      if players[index].points > maxpoints then
        maxpoints := players[index].points;
    end;
    for index := Low(players) to High(players) do
    begin
      if players[index].points = maxpoints then
        strWord := strWord + ('Победил игрок ' + IntToStr(index + 1) +
          ' набрав ' + IntToStr(maxpoints)) + #13;
    end;
    SetLength(players, 0);
    Panel1.Visible := True;
    Panel2.Visible := false;
    MessageDlg(strWord, mtInformation, [mbOk], 0);
    DeleteFile(DEFAULT_DIR_SAVE + '\' + SaveName);
    if not CreateDir(DEFAULT_DIR_SAVE) and
      (FindFirst(DEFAULT_DIR_SAVE + '\*' + DEFAULT_FORM_SAVE, faAnyFile, sr) = 0)
    then
    begin
      Button2.Enabled := True;
    end
    else
      Button2.Enabled := false;
  end
  else
  begin
    DeleteButtons(LetterButtons);
    prevPlayer := currentPlayer;
    if currentPlayer = High(players) then
      currentPlayer := Low(players)
    else
      Inc(currentPlayer);

    SetLength(Word, 0);
    CreateButtons(players[currentPlayer].letters);
    Button4.Enabled := players[currentPlayer].fi_fi;
    Button5.Enabled := players[currentPlayer].friendHelp;
    Label1.Caption := 'Игрок ' + IntToStr(currentPlayer + 1);
    // запуск следующего игрока
    SaveGame(players, bank, currentPlayer, SaveName);
  end;
end;

procedure TForm2.CreateNewGame(Sender: TObject);
begin
  PlaySound(DEFAULT_PATH_BTN_SOUND, 0, SND_FILENAME OR SND_NOSTOP OR SND_ASYNC);
  Panel7.Visible := True;
  Panel1.Visible := false;
  countPlayer := 2;
end;

procedure TForm2.OpenSave(Sender: TObject);
var
  Button: TButton;
  i, px: Integer;
begin
  PlaySound(DEFAULT_PATH_BTN_SOUND, 0, SND_FILENAME OR SND_NOSTOP OR SND_ASYNC);
  Panel6.Visible := True;
  Panel1.Visible := false;
  FindFirst(DEFAULT_DIR_SAVE + '\*' + DEFAULT_FORM_SAVE, faAnyFile, sr);
  i := 1;
  px := ScrollBox1.Height div 10;
  ScrollBox1.VertScrollBar.Range := 0;
  repeat
    SetLength(SaveButtons, i);
    Button := TButton.Create(ScrollBox1);
    Button.Parent := ScrollBox1; // Устанавливаем форму как родителя кнопки
    Button.Top := px * (i - 1); // Располагаем кнопки друг под друго
    Button.Width := ScrollBox1.ClientWidth;
    Button.Height := px;
    Button.Font.Height := px - 10;
    Button.Caption := sr.Name;
    Button.Anchors := [akLeft, akRight];
    Button.OnClick := OnClickSave;
    SaveButtons[i - 1] := Button;
    Inc(i)
  until FindNext(sr) <> 0;
  ScrollBox1.VertScrollBar.Range := ScrollBox1.ControlCount * px;
  ScrollBox1.Repaint;

  // ScrollBox1.Realign;
  FindClose(sr);
end;

procedure TForm2.Rule(Sender: TObject);
begin
  PlaySound(DEFAULT_PATH_BTN_SOUND, 0, SND_FILENAME OR SND_NOSTOP OR SND_ASYNC);
  TForm1.ShowRules(DEFAULT_PATH_RULE);
end;

procedure TForm2.FiftyFifty(Sender: TObject);
begin
  PlaySound(DEFAULT_PATH_BTN_SOUND, 0, SND_FILENAME OR SND_NOSTOP OR SND_ASYNC);
  if length(bank) > 5 then
  begin
    Panel5.Visible := True;
    Panel3.Visible := false;
    (Sender as TButton).Enabled := false;
    Button5.Enabled := false;
    DeleteButtons(LetterButtons);
    Dec(players[currentPlayer].points, 2);
    CreateFiftyButtons(players[currentPlayer].letters);
  end
  else
    MessageDlg('В банке меньше 5 букв', mtInformation, [mbOk], 0);

end;

procedure TForm2.friendHelp(Sender: TObject);
var
  nextPl: Integer;
  canUse: Boolean;
begin
  PlaySound(DEFAULT_PATH_BTN_SOUND, 0, SND_FILENAME OR SND_NOSTOP OR SND_ASYNC);
  canUse := false;
  nextPl := Low(players);
  while (nextPl <= High(players)) and not canUse do
  begin
    if (length(players[nextPl].letters) > 0) and (nextPl <> currentPlayer) then
      canUse := True;
    Inc(nextPl);
  end;
  if Length(players[currentPlayer].letters) < 1 then
    canUse := false;
  if canUse then
  begin
    Panel4.Visible := True;
    Panel3.Visible := false;
    (Sender as TButton).Enabled := false;
    Button4.Enabled := false;
    if currentPlayer = High(players) then
      friendPlayer := Low(players)
    else
      friendPlayer := currentPlayer + 1;
    DeleteButtons(LetterButtons);
    CreateFirendButtons(players[currentPlayer].letters,
      players[friendPlayer].letters, false);
    if currentPlayer = High(players) then
      nextPl := Low(players)
    else
      nextPl := currentPlayer + 1;
    Label2.Caption := 'Игрок ' + IntToStr(nextPl + 1);
  end
  else
    MessageDlg('Недостаточно букв у вас / противников', mtInformation, [mbOk], 0);
end;

procedure TForm2.PastFriend(Sender: TObject);
begin
  PlaySound(DEFAULT_PATH_BTN_SOUND, 0, SND_FILENAME OR SND_NOSTOP OR SND_ASYNC);
  if length(players) > 2 then
  begin
    if friendPlayer = Low(players) then
    begin
      if High(players) <> currentPlayer then
        friendPlayer := High(players)
      else
        friendPlayer := High(players) - 1;
    end
    else if friendPlayer - 1 <> currentPlayer then
      Dec(friendPlayer)
    else if friendPlayer - 1 = Low(players) then
    begin
      if High(players) <> currentPlayer then
        friendPlayer := High(players)
      else
        friendPlayer := High(players) - 1;
    end
    else
      Dec(friendPlayer, 2);
    DeleteButtons(FriendButtons[1]);
    Button8.Enabled := false;
    CreateFirendButtons(players[currentPlayer].letters,
      players[friendPlayer].letters, True);
    Label2.Caption := 'Игрок ' + IntToStr(friendPlayer + 1);

  end;
end;

procedure TForm2.NextFriend(Sender: TObject);
begin
  PlaySound(DEFAULT_PATH_BTN_SOUND, 0, SND_FILENAME OR SND_NOSTOP OR SND_ASYNC);
  if length(players) > 2 then
  begin
    if friendPlayer >= High(players) then
    begin
      if Low(players) <> currentPlayer then
        friendPlayer := Low(players)
      else
        friendPlayer := Low(players) + 1;
    end
    else if friendPlayer + 1 <> currentPlayer then
      Inc(friendPlayer)
    else if friendPlayer + 1 = High(players) then
    begin
      if Low(players) <> currentPlayer then
        friendPlayer := Low(players)
      else
        friendPlayer := Low(players) + 1;
    end
    else
      Inc(friendPlayer, 2);

    DeleteButtons(FriendButtons[1]);
    Button8.Enabled := false;
    CreateFirendButtons(players[currentPlayer].letters,
      players[friendPlayer].letters, True);
    Label2.Caption := 'Игрок ' + IntToStr(friendPlayer + 1);
  end;
end;

procedure TForm2.ConfimFriendHelp(Sender: TObject);
var
  temp: AnsiChar;
  i, j: Integer;
begin
  PlaySound(DEFAULT_PATH_BTN_SOUND, 0, SND_FILENAME OR SND_NOSTOP OR SND_ASYNC);
  for i := Low(FriendButtons[0]) to High(FriendButtons[0]) do
  begin
    if FriendButtons[0][i].Enabled = false then
      for j := Low(FriendButtons[1]) to High(FriendButtons[1]) do
        if FriendButtons[1][j].Enabled = false then
        begin
          temp := players[friendPlayer].letters[j + 1];
          players[friendPlayer].letters[j + 1] := players[currentPlayer]
            .letters[i + 1];
          players[currentPlayer].letters[i + 1] := temp;
        end;
  end;

  Button8.Enabled := false;
  Panel3.Visible := True;
  Panel4.Visible := false;
  players[currentPlayer].friendHelp := false;
  Button4.Enabled := players[currentPlayer].fi_fi;
  SetLength(Word, 0);
  DeleteButtons(LetterButtons);
  DeleteButtons(FriendButtons[0]);
  DeleteButtons(FriendButtons[1]);
  CreateButtons(players[currentPlayer].letters);
end;

procedure TForm2.ConfimFiftyFifty(Sender: TObject);
var
  i: Integer;
begin
  PlaySound(DEFAULT_PATH_BTN_SOUND, 0, SND_FILENAME OR SND_NOSTOP OR SND_ASYNC);
  for i := Low(Word) to High(Word) do
  begin
    delete(players[currentPlayer].letters,
      pos(Word[i].Caption, players[currentPlayer].letters), 1);
  end;
  players[currentPlayer].letters := players[currentPlayer].letters +
    CutLetters(bank, 5);
  Panel3.Visible := True;
  Panel5.Visible := false;
  players[currentPlayer].fi_fi := false;
  Button5.Enabled := players[currentPlayer].friendHelp;
  SetLength(Word, 0);
  DeleteButtons(LetterButtons);
  CreateButtons(players[currentPlayer].letters);
end;

procedure TForm2.DeleteButtons(var Buttons: TLetterButtons);
var
  i: Integer;
begin
  for i := Low(Buttons) to High(Buttons) do
  begin
    if Assigned(Buttons[i]) then
    begin
      Buttons[i].Free;
      Buttons[i] := nil;
    end;
  end;
  SetLength(Buttons, 0);
end;

procedure TForm2.DeleteButtons(var Buttons: TButtons);
var
  i: Integer;
begin
  for i := Low(Buttons) to High(Buttons) do
  begin
    if Assigned(Buttons[i]) then
    begin
      Buttons[i].Free;
      Buttons[i] := nil;
    end;
  end;
  SetLength(Buttons, 0);
end;

procedure TForm2.CreateFiftyButtons(lettersPlayer: string);
var
  i: Integer;
  Button: TLetterButton;
begin
  SetLength(Word, 0);
  SetLength(LetterButtons, Length(players[currentPlayer].letters)); // Создаем массив из 10 кнопок
  for i := 1 to 10 do
  begin
    Button := TLetterButton.Create(Self, i);
    Button.Parent := Panel5; // Устанавливаем форму как родителя кнопки
    Button.left := Panel5.Width div 2 + 5 - (px + 10) * 6 + (px + 10) * i;
    Button.StartVertexLeft := 0;
    Button.Top := Panel5.Height div 2 - px;
    // Располагаем кнопки друг под другом
    Button.StartVertexTop := 0;
    Button.Width := px;
    Button.Height := px;
    Button.Font.Height := px - 10;
    Button.Caption := lettersPlayer[i];
    Button.Anchors := [];
    Button.IsInWord := false;
    Button.OnClick := OnClickFifty;
    LetterButtons[i - 1] := Button;
  end;
end;

procedure TForm2.OnCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
  var Resize: Boolean);
begin
  If Panel3.Width <> NewWidth Then
    FWidgh := (Sender as TForm).Width; // (Sender as TForm).Width;
  if (Sender as TForm).Height <> NewHeight then
    FHeight := (Sender as TForm).Height;
end;

procedure TForm2.OnClickFifty(Sender: TObject);
var
  btn: TLetterButton;
begin
  PlaySound(DEFAULT_PATH_BTN_SOUND, 0, SND_FILENAME OR SND_NOSTOP OR SND_ASYNC);
  btn := (Sender as TLetterButton);
  btn.Enabled := false;
  SetLength(Word, length(Word) + 1);
  Word[High(Word)] := btn;
  if length(Word) > 4 then
  begin
    if length(Word) > 5 then
    begin
      Word[Low(Word)].Enabled := True;
      delete(Word, Low(Word), 1);
    end;
    Button9.Enabled := True;
  end;
end;

procedure TForm2.CreateFirendButtons(lettersPlayer: string;
  lettersFriend: string; onlyFirst: Boolean);
var
  i: Integer;
  Button: TLetterButton;
begin

  SetLength(FriendButtons[1],  Length(players[friendPlayer].letters)); // Создаем массив из 10 кнопок
  for i := 1 to Length(FriendButtons[1]) do
  begin
    Button := TLetterButton.Create(Self, i + 9);
    Button.Parent := Panel4; // Устанавливаем форму как родителя кнопки
    Button.left := Panel3.Width div 2 - px div 2 - (px + 50) * 4 +
      (px + 50) * i;
    Button.StartVertexLeft := Button.left;
    Button.Top := px * 2; // Располагаем кнопки друг под другом
    Button.StartVertexTop := Button.Top;
    Button.Width := px;
    Button.Height := px;
    Button.Font.Height := px - 10;
    Button.Caption := lettersFriend[i];
    Button.Anchors := [];
    Button.IsInWord := false;
    Button.OnClick := OnClickFriend;
    FriendButtons[1][i - 1] := Button;
  end;
  if not onlyFirst then
  begin
    SetLength(FriendButtons[0], Length(players[currentPlayer].letters));
    for i := 1 to Length(FriendButtons[0]) do
    begin
      Button := TLetterButton.Create(Self, i - 1);
      Button.Parent := Panel4; // Устанавливаем форму как родителя кнопки
      Button.left := Panel3.Width div 2 - px div 2 - (px + 50) * 4 +
        (px + 50) * i;
      Button.StartVertexLeft := Button.left;
      Button.Top := px * 4; // Располагаем кнопки друг под другом
      Button.StartVertexTop := Button.Top;
      Button.Width := px;
      Button.Height := px;
      Button.Font.Height := px - 10;
      Button.Caption := lettersPlayer[i];
      Button.Anchors := [];
      Button.IsInWord := false;
      Button.OnClick := OnClickFriend;
      FriendButtons[0][i - 1] := Button;
    end;
  end;

end;

procedure TForm2.OnClickFriend(Sender: TObject);
var
  i, j: Integer;
  btn: TLetterButton;
begin
  PlaySound(DEFAULT_PATH_BTN_SOUND, 0, SND_FILENAME OR SND_NOSTOP OR SND_ASYNC);
  btn := (Sender as TLetterButton);
  j := btn.Id div 10;
  for i := Low(FriendButtons[j]) to High(FriendButtons[j]) do
  begin
    if not FriendButtons[j][i].Enabled then
      FriendButtons[j][i].Enabled := True;
  end;
  btn.Enabled := false;
  j := btn.Id div 10 xor 1;
  for i := Low(FriendButtons[j]) to High(FriendButtons[j]) do
  begin
    if not FriendButtons[j][i].Enabled then
      Button8.Enabled := True
  end;
end;

procedure TForm2.CreateButtons(letters: string);
var
  i: Integer;
  Button: TLetterButton;
begin

  SetLength(LetterButtons, length(players[currentPlayer].letters));
  // Создаем массив из 10 кнопок
  for i := Low(LetterButtons) to High(LetterButtons) do
  begin
    Button := TLetterButton.Create(Self, i + 1);
    Button.Parent := Panel3; // Устанавливаем форму как родителя кнопки
    Button.left := Panel3.Width div 2 - px div 2 - (px + Panel3.Width div 10) *
      2 + (px + Panel3.Width div 10) * (i mod 5);
    Button.StartVertexLeft := Button.left;
    Button.Top := px * (2 + 2 * (i div 5));
    // Располагаем кнопки друг под другом
    Button.StartVertexTop := Button.Top;
    Button.Width := px;
    Button.Height := px;
    Button.Font.Height := px - 10;
    Button.Caption := letters[i + 1];
    Button.Anchors := [];
    Button.IsInWord := false;

    if letters[i + 1] = players[prevPlayer].lastLetter then
    begin
      Button.Font.Style := [fsBold];
    end;

    Button.OnClick := OnClickLetter;
    LetterButtons[i] := Button;
  end;
end;

procedure TForm2.OnClickLetter(Sender: TObject);
var
  i, lastLeft, temp: Integer;
  btn: TLetterButton;
begin
  PlaySound(DEFAULT_PATH_BTN_SOUND, 0, SND_FILENAME OR SND_NOSTOP OR SND_ASYNC);
  btn := (Sender as TLetterButton);
  if btn.IsInWord then
  begin
    i := Low(Word);
    var
    letter := false;
    while i <= High(Word) do
    begin
      if not letter then
      begin
        if Word[i].Id = btn.Id then
        begin
          delete(Word, i, 1);
          letter := True;
          lastLeft := btn.left;
        end
        else
          Inc(i);
      end
      else
      begin
        temp := Word[i].left;
        Word[i].left := lastLeft;
        lastLeft := temp;
        Inc(i);
      end;
    end;
    btn.IsInWord := false;
    btn.left := btn.StartVertexLeft;
    btn.Top := btn.StartVertexTop;
  end
  else
  begin
    btn.IsInWord := True;
    SetLength(Word, length(Word) + 1);
    btn.Top := Round(25 * HSize);
    btn.left := Round(25 * LSize) + Round((px + 5 * LSize) * High(Word));
    Word[High(Word)] := btn;
  end;
end;

procedure TForm2.OnLoad(Sender: TObject);
var
  dwVolume: DWORD;
  NormalizedVolume: Integer;
begin
  FWidgh := 0; // (Sender as TForm).Width;
  FHeight := 0;
  LSize := 1;
  HSize := 1;
  NormalizedVolume := (VOLUME * 65535) div 100;
  dwVolume := NormalizedVolume or (NormalizedVolume shl 16);
  waveOutSetVolume(0, dwVolume);
  MediaPlayer1.Close;
  MediaPlayer1.FileName := DEFAULT_PATH_MAIN_SOUND;
  MediaPlayer1.Open;
  MediaPlayer1.Play;
  px := Panel3.Height div 7;
  if not CreateDir(DEFAULT_DIR_SAVE) and
    (FindFirst(DEFAULT_DIR_SAVE + '\*' + DEFAULT_FORM_SAVE, faAnyFile, sr) = 0)
  then
  begin
    Button2.Enabled := True;
  end;
end;

procedure TForm2.OnResize(Sender: TObject);
var
  i, j: Integer;
  PV: array [3 .. 5] of Boolean;
begin
  PV[3] := Panel3.Visible;
  PV[4] := Panel4.Visible;
  PV[5] := Panel5.Visible;

  Panel3.Visible := True;
  Panel4.Visible := True;
  Panel5.Visible := True;
  if FHeight <> 0 then
  begin
    HSize := HSize * FHeight / (Sender as TForm).Height;
    ScaleControls(Round((Sender as TForm).Height / FHeight * 100), 100);
    px := Round((Sender as TForm).Height / FHeight * px);

    for i := Low(LetterButtons) to High(LetterButtons) do
    begin
      if LetterButtons[i].StartVertexTop <> 0 then
      begin
        LetterButtons[i].StartVertexTop :=
          Round((Sender as TForm).Height / FHeight * LetterButtons[i]
          .StartVertexTop);
        if not LetterButtons[i].IsInWord then
          LetterButtons[i].Top := LetterButtons[i].StartVertexTop
        else
          LetterButtons[i].Top := Round(25 * HSize);
      end;
    end;
  end;

  If FWidgh <> 0 Then
  begin
    // ScaleControls(Round((Sender as TForm).Width / FWidgh * 100), 100);
    LSize := LSize * (Sender as TForm).Width / FWidgh;
    for i := Low(LetterButtons) to High(LetterButtons) do
    begin
      if LetterButtons[i].StartVertexLeft <> 0 then
      begin
        LetterButtons[i].StartVertexLeft := Panel3.Width div 2 - px div 2 -
          (px + Panel3.Width div 10) * 2 + (px + Panel3.Width div 10) *
          (i mod 5);

        if not LetterButtons[i].IsInWord then
          LetterButtons[i].left := LetterButtons[i].StartVertexLeft
        else
          for j := Low(Word) to High(Word) do
            if Word[j].Id = LetterButtons[i].Id then
              LetterButtons[i].left := Round(25 * LSize) +
                Round((px + 5 * LSize) * j);
      end
      else
        LetterButtons[i].left := Panel5.Width div 2 + 5 - (px + 10) * 5 +
          (px + 10) * i;
    end;

    // FWidgh := Panel3.Width;
  end;

  Panel3.Visible := PV[3];
  Panel4.Visible := PV[4];
  Panel5.Visible := PV[5];
end;

procedure TForm2.OnClickSave(Sender: TObject);
var
  i: Integer;
begin
  PlaySound(DEFAULT_PATH_BTN_SOUND, 0, SND_FILENAME OR SND_NOSTOP OR SND_ASYNC);
  for i := Low(SaveButtons) to High(SaveButtons) do
    if not SaveButtons[i].Enabled then
      SaveButtons[i].Enabled := True;
  (Sender as TButton).Enabled := false;
  Button10.Enabled := True;
end;

end.
