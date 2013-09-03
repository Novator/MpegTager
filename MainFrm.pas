{******************************************************************}
{                                                                  }
{ 2003(fw) Ironsoft Lab, Perm, Russia                              }
{ http://ironsite.narod.ru                                         }
{ Written by Iron (Michael Galyuk), ironsoft@mail.ru               }
{                                                                  }
{ Код распространяется на правах лицензии GNU GPL                  }
{ При использовании кода ссылка на автора обязательна              }
{                                                                  }
{ Software distributed under the License is distributed on an      }
{ "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or   }
{ implied.                                                         }
{                                                                  }
{ КОД РАСПРОСТРАНЯЕТСЯ ПО ПРИНЦИПУ "КАК ЕСТЬ", НИКАКИХ             }
{ ГАРАНТИЙ НЕ ПРЕДУСМАТРИВАЕТСЯ, ВЫ ИСПОЛЬЗУЕТЕ ЕГО НА СВОЙ РИСК.  }
{ АВТОР НЕ НЕСЕТ ОТВЕТСТВЕННОСТИ ЗА ПРИЧИНЕННЫЙ УЩЕРБ СВЯЗАННЫЙ    }
{ С ЕГО ИСПОЛЬЗОВАНИЕМ (ПРАВИЛЬНЫМ ИЛИ НЕПРАВИЛЬНЫМ).              }
{                                                                  }
{******************************************************************}

unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons, ExtCtrls, CheckLst, FileCtrl, ShellApi,
  Mask, ToolEdit;

type
  TMainForm = class(TForm)
    PageControl: TPageControl;
    ProcessTabSheet: TTabSheet;
    SetupTabSheet: TTabSheet;
    AboutTabSheet: TTabSheet;
    FilePanel: TPanel;
    RecursePanel: TPanel;
    ProtoSplitter: TSplitter;
    StatusBar: TStatusBar;
    ProtoPanel: TPanel;
    ProtoListBox: TListBox;
    NameGenGroupBox: TGroupBox;
    CaseCheckBox: TCheckBox;
    AddAuthorCheckBox: TCheckBox;
    NumCheckBox: TCheckBox;
    ExampleEdit: TEdit;
    ExampleLabel: TLabel;
    LogoImage: TImage;
    NameLabel: TLabel;
    FirmLabel: TLabel;
    UrlLabel: TLabel;
    AuthorLabel: TLabel;
    MailLabel: TLabel;
    LangPanel: TPanel;
    ClearLogPanel: TPanel;
    ReadmePanel: TPanel;
    SubDirCheckBox: TCheckBox;
    DirExStaticText: TStaticText;
    FieldPanel: TPanel;
    AbortPanel: TPanel;
    CheckListBox: TCheckListBox;
    TagNumCheckBox: TCheckBox;
    TagLabel: TLabel;
    TagComboBox: TComboBox;
    PathPanel: TPanel;
    DirectoryEdit: TDirectoryEdit;
    ProcessPanel: TPanel;
    ShotNameCheckBox: TCheckBox;
    ProcessBitBtn: TBitBtn;
    FileRadioGroup: TRadioGroup;
    DirLabel: TLabel;
    WinCheckBox: TCheckBox;
    procedure ProtoSplitterCanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckListBoxClick(Sender: TObject);
    procedure AbortPanelClick(Sender: TObject);
    procedure ProcessBitBtnClick(Sender: TObject);
    procedure AbortPanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AbortPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DriveComboBoxChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ShotNameCheckBoxClick(Sender: TObject);
    procedure NumCheckBoxClick(Sender: TObject);
    procedure LangPanelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ClearLogPanelClick(Sender: TObject);
    procedure ReadmePanelClick(Sender: TObject);
    procedure UrlLabelClick(Sender: TObject);
    procedure MailLabelClick(Sender: TObject);
    procedure AddAuthorCheckBoxClick(Sender: TObject);
    procedure SubDirCheckBoxClick(Sender: TObject);
    procedure CaseCheckBoxClick(Sender: TObject);
    procedure DirectoryEditAfterDialog(Sender: TObject; var Name: String;
      var Action: Boolean);
    procedure FileRadioGroupClick(Sender: TObject);
    procedure DirectoryEditKeyPress(Sender: TObject; var Key: Char);
    procedure WinCheckBoxClick(Sender: TObject);
  private
  public
    procedure ShowMes(S: string);
    procedure ShowFileMes(S: string);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.ProtoSplitterCanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
const
  Max = 30;
begin
  Accept := NewSize > Max;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  ProcessBitBtn.Left := ProcessPanel.Width - ProcessBitBtn.Width - 2;
  DirectoryEdit.Width := DirectoryEdit.Parent.ClientWidth - DirectoryEdit.Left - 2;
  WinCheckBox.Left := DirectoryEdit.Left + DirectoryEdit.Width - WinCheckBox.Width;
  FileRadioGroup.Width := FileRadioGroup.Parent.ClientWidth - FileRadioGroup.Left - 2;
end;

var
  Process: Boolean = False;

procedure TMainForm.DriveComboBoxChange(Sender: TObject);
begin
  try
    {DirectoryListBox.Drive := DriveComboBox.Drive;}
    {RecurseCheckBoxClick(nil);}
  except
  end;
end;

function IniFileName: string;
begin
  Result := ChangeFileExt(Application.ExeName, '.ini');
end;

function StrToBool(S: string): Boolean;
begin
  Result := (Length(S)>0) and (S[1]='1');
end;

const
  CopyrStr: array[0..123] of Char =
    #169' Ironsoft Lab, 2002'#0#10#174' Programmed by Michael Galyuk'#0
    +'Russia, Perm, ironsoft@mail.ru, http://www.ironsite.narod.ru'#0;
  AboutCount: Byte = 0;

  MaxLang = 1;
  NumOfLangStr = 36;
  LangStrings: array[0..MaxLang, 0..NumOfLangStr] of PChar =
    (('&Обработать', 'Обработка', 'О программе', 'Настройки', '&нумерация',
      '&добавлять автора',
      '&подкаталоги для авторов', '&Выбор файлов', 'Протоко&л', 'Пример',
      '&только короткие', '&исправить буквы', 'Switch to English', 'Обработка',
      'Файлы не найдены', 'Всего переименовано', 'Обработка каталога',
      'Имя файла длиннее заголовка', 'Файл переименован',
      'Не удалось переименовать', 'не найден "TAG"', 'Не удалось открыть',
      'Выберите каталог с mp3-файлами для преобразования', 'ReadMeRus.txt',
      'Генерация имени', 'Отдельные'#13#10'Весь каталог'#13#10'Рекурсивно',
      'Очистить лог', 'Прочти это', ' = и&мя каталога',
      'Все вложенные папки!!!', 'Все файлы в этом каталоге!', 'Прервать',
      'Поиск файлов...', 'Сбой при поиске', '&порядок просмотра тэгов',
      '- &брать из тэгов', '&Каталог'
      ),
     ('&Process', 'Processing', 'About', 'Setup', '&numbered', '&add author',
      's&ub dir for authors', '&File choosing', 'Pro&tocol', 'Example',
      '&shot name only', 'c&orrect case', 'Switch to Russian', 'Processing',
      'Files is not founded', 'Total renamed', 'Process directory',
      'Filename is longer then title', 'File is renamed', 'Cannot rename',
      'TAG dont found', 'Cannot open', 'Choose directory for processing',
      'ReadMeEng.txt', 'Name generation', 'Selective'#13#10'All catalog'#13#10'Recurcive',
      'Clear log', 'Read this',
      ' = directory name',
      'All subdirectories!!!', 'All files in the directory!', 'Abort',
      'File search...', 'Error in search', 'tag &viewing order', ' - get fro&m tags',
      '&Directory'
     ));
  Lang: Integer = 0;

procedure TMainForm.FormShow(Sender: TObject);
var
  F: TextFile;
  I: Integer;
  S: string;
begin
  AssignFile(F, IniFileName);
  {$I-} Reset(F); {$I+}
  I := IOResult;
  if I=0 then
  begin
    while not Eof(F) and (I<=10) do
    begin
      ReadLn(F, S);
      case I of
        (*0:
          if Length(S)>0 then
            try
              {DriveComboBox.Drive := S[1];}
            except
            end;*)
        0:
          try
            {DirectoryListBox.Directory := S;}
            DirectoryEdit.Text := S;
          except
            {DirectoryListBox.Directory := '';}
            DirectoryEdit.Text := '';
          end;
        1:
          NumCheckBox.Checked := StrToBool(S);
        2:
          AddAuthorCheckBox.Checked := StrToBool(S);
        3:
          CaseCheckBox.Checked := StrToBool(S);
        4:
          try
            FileRadioGroup.ItemIndex := StrToInt(S);
          except
            FileRadioGroup.ItemIndex := 0;
          end;
        5:
          ShotNameCheckBox.Checked := StrToBool(S);
        6:
          SubDirCheckBox.Checked := StrToBool(S);
        7:
          try
            Lang := StrToInt(S);
            if (0>Lang) or (Lang>MaxLang) then
              Lang := 0;
          except
            Lang := 0;
          end;
        8:
          TagNumCheckBox.Checked := StrToBool(S);
        9:
          try
            TagComboBox.ItemIndex := StrToInt(S)
          except
            TagComboBox.ItemIndex := 0
          end;
        10:
          begin
            WinCheckBox.Checked := StrToBool(S);
            try
              WinCheckBoxClick(nil);
            except
            end;
          end;
      end;
      Inc(I);
    end;
    CloseFile(F);
  end;
  case Lang of
    1: LangPanelClick(nil);
  end;

  DriveComboBoxChange(nil);
  FileRadioGroupClick(nil);
  ShotNameCheckBoxClick(nil);
  AddAuthorCheckBoxClick(nil);
end;

function BoolToChar(Value: Boolean): Char;
begin
  if Value then
    Result := '1'
  else
    Result := '0';
end;

procedure TMainForm.FormDestroy(Sender: TObject);
var
  F: TextFile;
begin
  AssignFile(F, IniFileName);
  {$I-} Rewrite(F); {$I+}
  if IOResult=0 then
  begin
    (*WriteLn(F, {DriveComboBox.Drive}'');*)
    WriteLn(F, {DirectoryListBox.Directory}DirectoryEdit.Text);
    WriteLn(F, BoolToChar(NumCheckBox.Checked));
    WriteLn(F, BoolToChar(AddAuthorCheckBox.Checked));
    WriteLn(F, BoolToChar(CaseCheckBox.Checked));
    WriteLn(F, IntToStr({RecurseCheckBox.Checked}FileRadioGroup.ItemIndex));
    WriteLn(F, BoolToChar(ShotNameCheckBox.Checked));
    WriteLn(F, BoolToChar(SubDirCheckBox.Checked));
    WriteLn(F, IntToStr(Lang));
    WriteLn(F, BoolToChar(TagNumCheckBox.Checked));
    WriteLn(F, IntToStr(TagComboBox.ItemIndex));
    WriteLn(F, BoolToChar(WinCheckBox.Checked));
    CloseFile(F);
  end;
end;

function LogFileName: string;
begin
  Result := ChangeFileExt(Application.ExeName, '.log');
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  try
    ProtoListBox.Items.LoadFromFile(LogFileName);
  except
  end;
end;

{function ReplaceStr(S, S1, S2: string): string;
var
  I, L: Integer;
begin
  L := Length(S1);
  I := Pos(S1, S);
  while I>0 do
  begin
    S := Copy(S, 1, I-1)+S2+Copy(S, I+L, Length(S)-I-L+1);
    I := Pos(S1, S);
  end;
  Result := S;
end;}

procedure TMainForm.LangPanelClick(Sender: TObject);
begin
  if Sender<>nil then
  begin
    if Lang=0 then
      Lang := 1
    else
      Lang := 0;
  end;
  ProcessBitBtn       .Caption := LangStrings[Lang, 0];
  ProcessTabSheet     .Caption := LangStrings[Lang, 1];
  SetupTabSheet       .Caption := LangStrings[Lang, 3];
  AboutTabSheet       .Caption := LangStrings[Lang, 2];
  NumCheckBox         .Caption := LangStrings[Lang, 4];
  AddAuthorCheckBox   .Caption := LangStrings[Lang, 5];
  //SubDirCheckBox      .Caption := LangStrings[Lang, 6];
  //RecurseCheckBox     .Caption := LangStrings[Lang, 7];
  FileRadioGroup.Caption := LangStrings[Lang, 7];
  //ProtoGroupBox       .Caption := LangStrings[Lang, 8];
  ExampleLabel        .Caption := LangStrings[Lang, 9];
  ShotNameCheckBox    .Caption := LangStrings[Lang, 10];
  CaseCheckBox        .Caption := LangStrings[Lang, 11];
  LangPanel           .Caption := LangStrings[Lang, 12];
  NameGenGroupBox     .Caption := LangStrings[Lang, 24];
  //AllCheckBox         .Caption := LangStrings[Lang, 25];
  FileRadioGroup.Items.Text := {ReplaceStr(}LangStrings[Lang, 25]{, '|', #13#10)};
  ClearLogPanel       .Caption := LangStrings[Lang, 26];
  ReadmePanel         .Caption := LangStrings[Lang, 27];
  SubDirCheckBox      .Caption := LangStrings[Lang, 28];
  AbortPanel          .Caption := LangStrings[Lang, 31];
  TagLabel            .Caption := LangStrings[Lang, 34];
  TagNumCheckBox      .Caption := LangStrings[Lang, 35];
  DirLabel            .Caption := LangStrings[Lang, 36];
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    ProtoListBox.Hide;
    with ProtoListBox.Items do
    begin
      while Count>500 do
        Delete(0);
      {if Count>0 then}
      SaveToFile(LogFileName);
    end;
  except
  end;
end;

procedure AddProto(S: string);
begin
  MainForm.ProtoListBox.Items.Add(S);
end;

procedure TMainForm.ShowMes(S: string);
begin
  StatusBar.SimpleText := S;
  Application.ProcessMessages;
end;

procedure TMainForm.ShowFileMes(S: string);
begin
  FieldPanel.Caption := S;
  Application.ProcessMessages;
end;

procedure TMainForm.AbortPanelClick(Sender: TObject);
begin
  Process := False;
  AbortPanel.Hide;
end;

procedure TMainForm.AbortPanelMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    (Sender as TPanel).BevelOuter := bvLowered;
end;

procedure TMainForm.AbortPanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  (Sender as TPanel).BevelOuter := bvRaised;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  LogoImage.Picture.Icon := Application.Icon;
  TagComboBox.ItemIndex := 0;
end;

function FillFileList(RootDir: string; Rec: Boolean; List: TStrings): Boolean;

  procedure AddDirFiles(Dir: string);
  var
    SearchRec: TSearchRec;
    Res: Integer;
  begin
    Res := FindFirst(Dir+'*.*', faAnyFile, SearchRec);
    if (Res=0) and Process then
    begin
      while Res=0 do
      begin
        if (SearchRec.Attr and faDirectory)>0 then
        begin
          if Rec and (SearchRec.Name<>'.') and (SearchRec.Name<>'..') then
            AddDirFiles(Dir + SearchRec.Name + '\')
        end
        else begin
          if UpperCase(ExtractFileExt(SearchRec.Name))='.MP3' then
          begin
            try
              List.Add(SearchRec.Name);
            except
              Process := False;
            end;
          end;
        end;
        Res := FindNext(SearchRec);
        Application.ProcessMessages;
      end;
      FindClose(SearchRec);
    end;
  end;

begin
  Result := False;
  Process := True;
  try
    try
      AddDirFiles(RootDir);
    except
      Process := False;
    end;
    Result := Process;
  finally
    Process := False;
  end;
end;

procedure TMainForm.FileRadioGroupClick(Sender: TObject);
var
  S: string;
  L: Integer;
begin
  {if RecurseCheckBox.Checked then
    AllCheckBox.Checked := True;
  AllCheckBox.Enabled := not RecurseCheckBox.Checked;}
  {S := DirectoryListBox.Directory;}
  S := DirectoryEdit.Text;
  if Length(S)=0 then
  begin
    GetDir(0, S);
    DirectoryEdit.Text := S;
  end;
  L := Length(S);
  if (L>0) and (S[L]<>'\') and (S[L]<>'/') then
    S := S + '\';
  PathPanel.Caption := S;

  CheckListBox.Visible := FileRadioGroup.ItemIndex=0;
  if CheckListBox.Visible then
  begin
    AbortPanelClick(nil);
    CheckListBox.Hide;
    ShowFileMes(LangStrings[Lang, 32]);
    CheckListBox.Clear;
    AbortPanel.Show;
    FilePanel.Cursor := crHourGlass;
    if FillFileList(PathPanel.Caption, False, CheckListBox.Items) then
    begin
      AbortPanel.Hide;
      ShowFileMes('');
      CheckListBox.Show;
    end
    else
      ShowFileMes(LangStrings[Lang, 33]);
    FilePanel.Cursor := crDefault;
    AbortPanel.Hide;
  end
  else begin
    if FileRadioGroup.ItemIndex=2 then
      ShowFileMes(LangStrings[Lang, 29])
    else
      ShowFileMes(LangStrings[Lang, 30]);
  end;
  CheckListBoxClick(nil);
end;

procedure TMainForm.CheckListBoxClick(Sender: TObject);
var
  I: Integer;
begin
  if CheckListBox.Visible then
  begin
    CheckListBox.Enabled := {not AllCheckBox.Checked}FileRadioGroup.ItemIndex=0;
    CheckListBox.ParentColor := not CheckListBox.Enabled;
    if not CheckListBox.ParentColor then
      CheckListBox.Color := clWindow;
    I := 0;
    while (I<CheckListBox.Items.Count) and not CheckListBox.Checked[I] do
      Inc(I);
    ProcessBitBtn.Enabled := I<CheckListBox.Items.Count;
  end
  else
    ProcessBitBtn.Enabled := True;
end;

{===}

function RusUpCase(K: Char): Char;
begin
  if K in ['а'..'я'] then
    Result := Char(Ord(K)-32)
  else
    if K='ё' then
      Result := 'Ё'
    else
      Result := UpCase(K)
end;

function RusLowCase(K: Char): Char;
begin
  if K in ['A'..'Z', 'А'..'Я'] then
    Result := Char(Ord(K)+32)
  else
    if K='Ё' then
      Result := 'ё'
    else
      Result := K;
end;

function RusLowerCase(const S: string): string;
var
  I: Integer;
begin
  Result := S;
  for I := 1 to Length(Result) do
    Result[I] := RusLowCase(Result[I]);
end;

var
  AddAuthor: Boolean = True;
  Numbered: Boolean = True;
  CorrCase: Boolean = False;
  SubDir: Boolean = False;
  ShotNameOnly: Boolean = True;
  TagNumber: Boolean = False;
  TagOrder: Integer = 0;

procedure TMainForm.ShotNameCheckBoxClick(Sender: TObject);
begin
  ShotNameOnly := ShotNameCheckBox.Checked;
end;

procedure GenerateName(var S: string; NS, D, Number: string; Count: Integer);
var
  I: Integer;
begin
  S := Trim(S);
  if AddAuthor then
  begin
    if Length(NS)>0 then
      S := Trim(NS)+' - '+S
    else
      if SubDir then
      begin
        D := Trim(D);
        I := Length(D);
        if (I>0) and ((D[I]='\') or (D[I]='/')) then
          Delete(D, I, 1);
        I := Length(D);
        while (I>0) and not((D[I]='\') or (D[I]='/')) do
          Dec(I);
        if I>0 then
          Delete(D, 1, I);
        D := Trim(D);
        if Length(D)>0 then
          S := D+' - '+S;
      end;
  end;
  if Numbered then
  begin
    I := Length(IntToStr(Count));
    if I<2 then
      I := 2;
    NS := Number;
    while Length(NS)<I do
      NS := '0'+NS;
    S := NS+' - '+S;
  end;
  I := Length(S);
  while I>0 do
  begin
    if S[I] in ['*', '.', ':', '/', '\', '?'] then
      S[I] := '_';
    Dec(I);
  end;
  I := Pos('__', S);
  while I>0 do
  begin
    Delete(S, I, 1);
    I := Pos('__', S);
  end;
  S := Trim(S);
  if CorrCase then
  begin
    S := RusLowerCase(S);
    I := Length(S);
    while I>0 do
    begin
      if (I=1) or not(S[I-1] in ['A'..'Z', 'a'..'z', 'А'..'Я', 'а'..'я', 'ё',
        'Ё', ''''])
      then
        S[I] := RusUpCase(S[I]);
      Dec(I);
    end;
  end;
  S := ChangeFileExt(S, '.mp3');
end;

procedure TMainForm.NumCheckBoxClick(Sender: TObject);
begin
  TagNumCheckBox.Visible := NumCheckBox.Checked;
  CaseCheckBoxClick(nil);
end;

procedure TMainForm.CaseCheckBoxClick(Sender: TObject);
var
  A, S: string;
begin
  AddAuthor := AddAuthorCheckBox.Checked;
  Numbered := NumCheckBox.Checked;
  CorrCase := CaseCheckBox.Checked;
  SubDir := SubDirCheckBox.Checked;
  TagNumber := TagNumCheckBox.Checked;
  TagOrder := TagComboBox.ItemIndex;
  if DirExStaticText.Visible then
    A := ''
  else
    A := 'METALLICA';
  S := 'Jump in the fire';
  GenerateName(S, A, DirExStaticText.Caption, '1', 1);
  ExampleEdit.Text := S;
end;

procedure TMainForm.SubDirCheckBoxClick(Sender: TObject);
begin
  DirExStaticText.Visible := SubDirCheckBox.Visible and SubDirCheckBox.Checked;
  CaseCheckBoxClick(nil);
end;

procedure TMainForm.AddAuthorCheckBoxClick(Sender: TObject);
begin
  SubDirCheckBox.Visible := AddAuthorCheckBox.Checked;
  SubDirCheckBoxClick(nil);
end;

type
  TMpegTag = packed record
    mtName: array[0..29] of Char;        {Hазвание 30 байт ASCII}
    mtAuthor: array[0..29] of Char;      {Исполнитель 30 байт ASCII}
    mtAlbum: array[0..29] of Char;       {Альбом 30 байт ASCII}
    mtYear: array[0..3] of Char;         {Год 4 байта ASCII}
    mtComment: array[0..28] of Char;     {Комментарий 30 байт ASCII}
    mtNumber: Byte;                      {Номер (для формата ID3v1.1)}
    mtStyle: Byte;                       {Жанр}
  end;
var
  F: file of Byte;
  Tg: array[0..4] of Char;
  MpTag1: TMpegTag;
  MpTag2: array[0..511] of Char;
  P, C, I: Integer;
  S1, S2, S3, S4: string;
  TagIsFound: Boolean;

const
  TagNameSize = 4;
type
  TTagName = packed array[0..TagNameSize-1] of Char;

function GetTagValFromBuf(var TN: TTagName; Buf: PChar; Len: Integer): string;
var
  I: Integer;
  L: Byte;
begin
  if Len>TagNameSize+7 then
  begin
    I := 0;
    while (I<TagNameSize) and (TN[I]=Buf[I]) do
      Inc(I);
    L := PByte(@Buf[TagNameSize+3])^;
    if I<TagNameSize then
    begin
      I := TagNameSize+6+L;
      Result := GetTagValFromBuf(TN, @Buf[I], Len-I)
    end
    else begin
      Result := '';
      if L>0 then
        Dec(L);
      I := TagNameSize+7;
      while (L>0) and (I<Len) do
      begin
        Result := Result + Buf[I];
        Inc(I);
        Dec(L);
      end;
    end;
  end
  else
    Result := '';
end;

const
  TAG1 = 'TAG';
  TAG2 = 'ID3'#3;
var
  TN1: TTagName = 'TIT2';
  TN2: TTagName = 'TPE1';
  TN3: TTagName = 'TRCK';
  Recurse: Boolean = False;
  FileCount, ProcFiles: Integer;
  NameList: TCheckListBox = nil;

procedure ProcessMpegNames(Dir: string);
var
  SongList: TStringList;
  SearchRec: TSearchRec;
  Res: Integer;

  function GetTag1: Boolean;
  begin
    Result := False;
    C := SizeOf(MpTag1);
    P := FileSize(F)-C;
    Seek(F, P-3);
    FillChar(Tg, SizeOf(Tg), #0);
    I := 3;
    BlockRead(F, Tg, I);
    if Tg=TAG1 then
    begin
      Seek(F, P);
      FillChar(MpTag1, SizeOf(MpTag1), #0);
      I := C;
      BlockRead(F, MpTag1, I);
      S2 := Trim(Copy(StrPas(MpTag1.mtName), 1, SizeOf(MpTag1.mtName)));       {MpTag.mtAlbum}
      S3 := Trim(Copy(StrPas(MpTag1.mtAuthor), 1, SizeOf(MpTag1.mtAuthor)));
      if TagNumber and (MpTag1.mtComment[28]=#0) and (MpTag1.mtNumber<>0) then
        S4 := IntToStr(MpTag1.mtNumber);
      Result := True;
    end;
  end;

  function GetTag2: Boolean;
  begin
    Result := False;
    C := SizeOf(MpTag2);
    P := 0;
    Seek(F, P);        
    FillChar(Tg, SizeOf(Tg), #0);        
    I := 4;        
    BlockRead(F, Tg, I);        
    if Tg=TAG2 then
    begin        
      Seek(F, P+10);
      FillChar(MpTag2, SizeOf(MpTag2), #0);
      I := C;
      BlockRead(F, MpTag2, I);
      S2 := GetTagValFromBuf(TN1, @MpTag2, SizeOf(MpTag2));
      S3 := GetTagValFromBuf(TN2, @MpTag2, SizeOf(MpTag2));
      if TagNumber then
        S4 := GetTagValFromBuf(TN3, @MpTag2, SizeOf(MpTag2));
      Result := True;
    end;
  end;

begin
  Res := FindFirst(Dir+'*.*', faAnyFile, SearchRec);
  if Res=0 then
  begin
    SongList := TStringList.Create;
    try
      AddProto(LangStrings[Lang, 16]+' ['+Dir+']');
      if NameList=nil then
      begin
        while Res=0 do
        begin
          if (SearchRec.Attr and faDirectory)>0 then
          begin
            if Recurse and (SearchRec.Name<>'.')
              and (SearchRec.Name<>'..')
            then
              ProcessMpegNames(Dir + SearchRec.Name + '\')
          end
          else begin
            if UpperCase(ExtractFileExt(SearchRec.Name))='.MP3' then
              SongList.Add(SearchRec.Name);
          end;
          Res := FindNext(SearchRec)
        end;
      end
      else begin
        for I := 0 to NameList.Items.Count-1 do
          if NameList.Checked[I] then
            SongList.Add(NameList.Items.Strings[I]);
      end;
      if Numbered then
        SongList.Sort;
      for Res := 0 to SongList.Count-1 do
      begin
        Inc(FileCount);
        S1 := SongList.Strings[Res];
        AssignFile(F, Dir+S1);
        FileMode := 0;
        {$I-} Reset(F); {$I+}
        if IOResult = 0 then
        begin
          S4 := '';
          if TagOrder=0 then
            TagIsFound := GetTag1 or GetTag2
          else
            TagIsFound := GetTag2 or GetTag1;
          CloseFile(F);
          if not TagIsFound then
          begin
            AddProto('['+S1+'] '+LangStrings[Lang, 20]);
            S2 := ''; S3 := '';
          end;
          if (Length(S2)>0) or (Length(S3)>0) then
          begin
            if ShotNameOnly and (Length(S1)>Length(S2)+4) then
              AddProto(LangStrings[Lang, 17]+' ['+S1+']>['+S2+']')
            else begin
              if TagNumber then
              begin
                S4 := Trim(S4);
                P := Pos('/', S4);
                if P=0 then
                  P := Pos('\', S4);
                if P>0 then
                  S4 := Trim(Copy(S4, 1, P-1));
              end;
              if Length(S4)=0 then
                S4 := IntToStr(Res+1);
              GenerateName(S2, S3, Dir, S4, SongList.Count);
              if RenameFile(Dir+S1, Dir+S2) then
              begin
                Inc(ProcFiles);
                AddProto(LangStrings[Lang, 18]+' ['+S1+']->['+S2+']');
              end
              else
                AddProto(LangStrings[Lang, 19]+' ['+S1+']>['+S2+']');
            end;
          end;
        end
        else
          AddProto(LangStrings[Lang, 21]+' ['+S1+']');
      end;
    finally
      SongList.Free;
      FindClose(SearchRec);
    end;
  end;
end;

{===}

procedure TMainForm.ProcessBitBtnClick(Sender: TObject);
begin
  AbortPanelClick(nil);
  if CheckListBox.Visible then
    NameList := CheckListBox
  else
    NameList := nil;
  Recurse := FileRadioGroup.ItemIndex=2;
  ProcessMpegNames(PathPanel.Caption);
  FileRadioGroupClick(nil);
end;


procedure TMainForm.ClearLogPanelClick(Sender: TObject);
begin
  ProtoListBox.Items.Clear;
end;

procedure TMainForm.ReadmePanelClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, nil,
    PChar(ExtractFilePath(Application.ExeName)+LangStrings[Lang, 23]),
    nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.UrlLabelClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, nil,
    PChar(UrlLabel.Caption), nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.MailLabelClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, nil,
    PChar('mailto:'+MailLabel.Caption+'?subject='+Caption),
    nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.DirectoryEditAfterDialog(Sender: TObject;
  var Name: String; var Action: Boolean);
begin
  if Action then
  begin
    DirectoryEdit.Text := Name;
    FileRadioGroupClick(nil);
  end;
end;


procedure TMainForm.DirectoryEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then
    FileRadioGroupClick(nil);
end;

procedure TMainForm.WinCheckBoxClick(Sender: TObject);
begin
  if WinCheckBox.Checked and (DirectoryEdit.DialogKind<>dkWin32) then
    DirectoryEdit.DialogKind := dkWin32
  else
    if not WinCheckBox.Checked and (DirectoryEdit.DialogKind<>dkVCL) then
      DirectoryEdit.DialogKind := dkVCL;
end;

end.

