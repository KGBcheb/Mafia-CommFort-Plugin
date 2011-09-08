unit settings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Tabs, StdCtrls,  ShellAPI,
  comm_info, mafia, mafia_data, comm_data, MyIniFiles, ComCtrls, Spin;

type
  TfrmSettings = class(TForm)
    btnApply: TButton;
    PageCtrl: TPageControl;
    TabSheetMain: TTabSheet;
    TabSheetTime: TTabSheet;
    TabSheetPoints: TTabSheet;
    TabSheetStatistic: TTabSheet;
    TabSheetGametype: TTabSheet;
    ScrollBoxGametype: TScrollBox;
    ScrollBoxStatistic: TScrollBox;
    ScrollBoxPoints: TScrollBox;
    ScrollBoxTime: TScrollBox;
    ScrollBoxMain: TScrollBox;
    TabSheetGamettypeRoles: TTabSheet;
    ScrollBoxGametypeRoles: TScrollBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure NumEditChange (Sender : TObject);
    procedure FloatEditChange (Sender : TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    procedure AddParameterEdit(TabIndex: Integer; ParCaption: String; Ini: TIniFile; Section, Ident, Default: String; InputType:Byte=0; TopInterval:Integer=1);
    procedure AddParameterNumEdit(TabIndex: Integer; ParCaption: String; Ini: TIniFile; Section, Ident: String; Default:Integer=0; Min: Integer=0; Max: Integer=32000; Increment:Word=1; TopInterval:Integer=1);
    procedure AddParameterCombo(TabIndex: Integer; ParCaption: String; Ini: TIniFile; Section, Ident: String; Default: Word; ItemList: TStringList; TopInterval:Integer=1);
    procedure AddParameterYesNo(TabIndex: Integer; ParCaption: String; Ini: TIniFile; Section, Ident: String; Default: Word; TopInterval:Integer=1);
  public
    { Public declarations }
  end;

  TLabelList = array of TLabel;
  TEditList = array of TComponent;

var
  frmSettings: TfrmSettings;
  lblList: array of TLabelList;
  edtList: array of TEditList;
  updownList: array of TUpDown;
  updownListCount: Byte;
  prntList: Array of TWinControl;
  RoleText2: TRoleText;

implementation

{$R *.dfm}

procedure TfrmSettings.AddParameterEdit(TabIndex: Integer; ParCaption: String; Ini: TIniFile; Section, Ident, Default: String; InputType:Byte=0; TopInterval:Integer=1);
{
  InputType:
    1 - ������ �����
}
var
  I, Top: Integer;
begin
  I:=prntList[TabIndex].Tag;
  if I=0 then
    Top:=10
  else
    if (lblList[TabIndex][I-1].Height<20) then
      Top:=lblList[TabIndex][I-1].Top+22+TopInterval
    else
      Top:=lblList[TabIndex][I-1].Top+lblList[TabIndex][I-1].Height+TopInterval;
  lblList[TabIndex][I]:=TLabel.Create(Self);
  lblList[TabIndex][I].Anchors := [akLeft, akTop, akBottom];
  lblList[TabIndex][I].WordWrap:=True;
  lblList[TabIndex][I].AutoSize:=True;
  lblList[TabIndex][I].Caption:=ParCaption;
  lblList[TabIndex][I].Top:=Top;
  lblList[TabIndex][I].Left:=5;
  lblList[TabIndex][I].Width:=250;
  lblList[TabIndex][I].Height:=20;
  lblList[TabIndex][I].Parent:=prntList[TabIndex];

  edtList[TabIndex][I]:=TEdit.Create(Self);
  if InputType>0 then
     TEdit(edtList[TabIndex][I]).Tag:=StrToIntDef(Ini.ReadString(Section, Ident, Default), 0);
  TEdit(edtList[TabIndex][I]).Text:=Ini.ReadString(Section, Ident, Default);
  TEdit(edtList[TabIndex][I]).Top:=Top;
  TEdit(edtList[TabIndex][I]).Left:=305;
  TEdit(edtList[TabIndex][I]).Width:=200;
  TEdit(edtList[TabIndex][I]).Height:=20;
  TEdit(edtList[TabIndex][I]).ShowHint:=True;
  TEdit(edtList[TabIndex][I]).Hint:=ParCaption;
  TEdit(edtList[TabIndex][I]).Parent:=prntList[TabIndex];
  if InputType=1 then
    TEdit(edtList[TabIndex][I]).NumbersOnly:=True
  else
    if InputType=2 then
        TEdit(edtList[TabIndex][I]).OnExit:=NumEditChange;
  if InputType=3 then
     TEdit(edtList[TabIndex][I]).OnExit:=FloatEditChange;
  Inc(I);
  prntList[TabIndex].Tag:=I;
end;


procedure TfrmSettings.AddParameterNumEdit(TabIndex: Integer; ParCaption: String; Ini: TIniFile; Section, Ident: String; Default:Integer=0; Min: Integer=0; Max: Integer=32000; Increment:Word=1; TopInterval:Integer=1);
var
  I, Top: Integer;
begin
  I:=prntList[TabIndex].Tag;
  if I=0 then
    Top:=10
  else
    if (lblList[TabIndex][I-1].Height<20) then
      Top:=lblList[TabIndex][I-1].Top+22+TopInterval
    else
      Top:=lblList[TabIndex][I-1].Top+lblList[TabIndex][I-1].Height+TopInterval;
  lblList[TabIndex][I]:=TLabel.Create(Self);
  lblList[TabIndex][I].Anchors := [akLeft, akTop, akBottom];
  lblList[TabIndex][I].WordWrap:=True;
  lblList[TabIndex][I].AutoSize:=True;
  lblList[TabIndex][I].Caption:=ParCaption;
  lblList[TabIndex][I].Top:=Top;
  lblList[TabIndex][I].Left:=5;
  lblList[TabIndex][I].Width:=250;
  lblList[TabIndex][I].Height:=20;
  lblList[TabIndex][I].Parent:=prntList[TabIndex];

  edtList[TabIndex][I]:=TSpinEdit.Create(Self);
  TSpinEdit(edtList[TabIndex][I]).Increment:=Increment;
  TSpinEdit(edtList[TabIndex][I]).MinValue:=Min;
  TSpinEdit(edtList[TabIndex][I]).MaxValue:=Max;
  TSpinEdit(edtList[TabIndex][I]).Value:=Ini.ReadInteger(Section, Ident, Default);
  TSpinEdit(edtList[TabIndex][I]).Tag:=Ini.ReadInteger(Section, Ident, Default);
  TSpinEdit(edtList[TabIndex][I]).Top:=Top;
  TSpinEdit(edtList[TabIndex][I]).Left:=305;
  TSpinEdit(edtList[TabIndex][I]).Width:=200;
  TSpinEdit(edtList[TabIndex][I]).Height:=20;
  TSpinEdit(edtList[TabIndex][I]).ShowHint:=True;
  TSpinEdit(edtList[TabIndex][I]).Hint:=ParCaption;
  TSpinEdit(edtList[TabIndex][I]).Parent:=prntList[TabIndex];
  TSpinEdit(edtList[TabIndex][I]).OnExit:=NumEditChange;
  Inc(I);
  prntList[TabIndex].Tag:=I;
end;

procedure TfrmSettings.AddParameterCombo(TabIndex: Integer; ParCaption: String; Ini: TIniFile; Section, Ident: String; Default: Word; ItemList: TStringList; TopInterval:Integer=1);
var
  I, Top, Value: Integer;
begin
  I:=prntList[TabIndex].Tag;
  if I=0 then
    Top:=10
  else
    if (lblList[TabIndex][I-1].Height<20) then
      Top:=lblList[TabIndex][I-1].Top+22+TopInterval
    else
      Top:=lblList[TabIndex][I-1].Top+lblList[TabIndex][I-1].Height+TopInterval;
  lblList[TabIndex][I]:=TLabel.Create(Self);
  lblList[TabIndex][I].WordWrap:=True;
  lblList[TabIndex][I].AutoSize:=True;
  lblList[TabIndex][I].Caption:=ParCaption;
  lblList[TabIndex][I].Top:=Top;
  lblList[TabIndex][I].Left:=5;
  lblList[TabIndex][I].Width:=250;
  lblList[TabIndex][I].Height:=20;
  lblList[TabIndex][I].Parent:=prntList[TabIndex];

  edtList[TabIndex][I]:=TComboBox.Create(Self);
  TComboBox(edtList[TabIndex][I]).Parent:=prntList[TabIndex];
  TComboBox(edtList[TabIndex][I]).Style:=csDropDownList;
  TComboBox(edtList[TabIndex][I]).Items:=ItemList;
  Value:=Ini.ReadInteger(Section, Ident, Default);
  if (Value < TComboBox(edtList[TabIndex][I]).Items.Count) and (Value>=0)  then
    TComboBox(edtList[TabIndex][I]).ItemIndex:=Value
  else
    TComboBox(edtList[TabIndex][I]).ItemIndex:=TComboBox(edtList[TabIndex][I]).Items.Count-1;
  TComboBox(edtList[TabIndex][I]).Top:=Top;
  TComboBox(edtList[TabIndex][I]).Left:=305;
  TComboBox(edtList[TabIndex][I]).Width:=200;
  TComboBox(edtList[TabIndex][I]).Height:=20;
  TComboBox(edtList[TabIndex][I]).ShowHint:=True;
  TComboBox(edtList[TabIndex][I]).Hint:=ParCaption;
  Inc(I);
  prntList[TabIndex].Tag:=I;
end;

procedure TfrmSettings.AddParameterYesNo(TabIndex: Integer; ParCaption: String; Ini: TIniFile; Section, Ident: String; Default: Word; TopInterval:Integer=1);
var
  Strings: TStringList;
begin
  Strings:=TStringList.Create();
  Strings.Add('���');
  Strings.Add('��');
  AddParameterCombo(TabIndex, ParCaption, Ini, Section, Ident, Default, Strings, TopInterval);
  Strings.Free;
end;

// ���������� ��������
procedure TfrmSettings.btnApplyClick(Sender: TObject);
var
  Ini: TIniFile;
  I,K,J: Integer;
  SecName: String;
begin

  Ini:=TIniFile.Create(file_config);
  //---------------------------------------------------------------------------
  // ������ ������� - �������� ���������
  Ini.WriteString('Mafia', 'Channel', TEdit(edtList[0][0]).Text);
  Ini.WriteString('Mafia', 'ChannelHelp', TEdit(edtList[0][1]).Text);
  Ini.WriteString('Mafia', 'ChannelMain1', TEdit(edtList[0][2]).Text);
  Ini.WriteInteger('Mafia', 'ReloadSettingsOnStart', TComboBox(edtList[0][3]).ItemIndex);
  Ini.WriteInteger('Mafia', 'IPFilter', TComboBox(edtList[0][4]).ItemIndex);
  Ini.WriteInteger('Mafia', 'IDFilter', TComboBox(edtList[0][5]).ItemIndex);
  Ini.WriteString('Mafia', 'BotName', TEdit(edtList[0][6]).Text);
  Ini.WriteString('Mafia', 'BotPass', TEdit(edtList[0][7]).Text);
  Ini.WriteInteger('Mafia', 'BotIsFemale', TComboBox(edtList[0][8]).ItemIndex);
  Ini.WriteString('Mafia', 'BotIP', TEdit(edtList[0][9]).Text);
  Ini.WriteString('Mafia', 'BotState', TEdit(edtList[0][10]).Text);
  Ini.WriteInteger('Mafia', 'BanOnDeath', TComboBox(edtList[0][11]).ItemIndex);
  Ini.WriteInteger('Mafia', 'BanPrivateOnDeath', TComboBox(edtList[0][12]).ItemIndex);
  Ini.WriteString('Mafia', 'BanReason', TEdit(edtList[0][13]).Text);
  Ini.WriteString('Mafia', 'UnbanReason', TEdit(edtList[0][14]).Text);
  Ini.WriteInteger('Mafia', 'StatToPrivate', TComboBox(edtList[0][15]).ItemIndex);
  Ini.WriteInteger('Mafia',  'MaskPrice', TSpinEdit(edtList[0][16]).Value);
  Ini.WriteInteger('Mafia',  'RadioPrice', TSpinEdit(edtList[0][17]).Value);
  Ini.WriteInteger('Mafia',  'RadioNights', TSpinEdit(edtList[0][18]).Value);
  Ini.WriteInteger('Mafia', 'FastGame', TComboBox(edtList[0][19]).ItemIndex);
  Ini.WriteInteger('Mafia', 'StartFromNight', TComboBox(edtList[0][20]).ItemIndex);
  Ini.WriteInteger('Mafia', 'ShowNightActions', TComboBox(edtList[0][21]).ItemIndex);
  Ini.WriteInteger('Mafia', 'MessagesType', TComboBox(edtList[0][22]).ItemIndex);
  Ini.WriteInteger('Mafia', 'ChangeGametypeNotify', TComboBox(edtList[0][23]).ItemIndex);
  Ini.WriteInteger('Mafia',  'ChangeGametypeGamesCount', TSpinEdit(edtList[0][24]).Value);
  //---------------------------------------------------------------------------

  //---------------------------------------------------------------------------
  // ������ ������� - �����
  Ini.WriteInteger('Mafia',  'TimeStart', TSpinEdit(edtList[1][0]).Value);
  Ini.WriteInteger('Mafia',  'TimeAccept', TSpinEdit(edtList[1][1]).Value);
  Ini.WriteInteger('Mafia',  'TimeNight', TSpinEdit(edtList[1][2]).Value);
  Ini.WriteInteger('Mafia',  'TimeMorning', TSpinEdit(edtList[1][3]).Value);
  Ini.WriteInteger('Mafia',  'TimeDay', TSpinEdit(edtList[1][4]).Value);
  Ini.WriteInteger('Mafia',  'TimeLastWord', TSpinEdit(edtList[1][5]).Value);
  Ini.WriteInteger('Mafia',  'TimeEvening', TSpinEdit(edtList[1][6]).Value);
  Ini.WriteInteger('Mafia',  'TimePause', TSpinEdit(edtList[1][7]).Value);
  //---------------------------------------------------------------------------

  //---------------------------------------------------------------------------
  // ������ ������� - ����
  K:=0;
  for I:=1 to 255 do
    if I in [1..18, 151..158] then
    begin
      Ini.WriteInteger('MafiaPoints', IntToStr(I), TSpinEdit(edtList[2][K]).Value);
      Inc(K);
    end;
  //---------------------------------------------------------------------------


  //---------------------------------------------------------------------------
  // ��������� ������� - ����������
  Ini.WriteInteger('Stats', 'UpdateGreeting', TComboBox(edtList[3][0]).ItemIndex);
  Ini.WriteInteger('Stats', 'Export', TComboBox(edtList[3][1]).ItemIndex);
  Ini.WriteString('Stats',  'File', TEdit(edtList[3][2]).Text);
  //---------------------------------------------------------------------------
  SecName:=Ini.ReadString('Mafia', 'DefaultGametype', 'Gametype_0');
  Ini.Free;

  Ini:=TIniFile.Create(file_gametypes);
  //---------------------------------------------------------------------------
  // ����� ������� - ��� ����
  Ini.WriteString(SecName, 'Name', TEdit(edtList[4][0]).Text);
  Ini.WriteString(SecName, 'Command', TEdit(edtList[4][1]).Text);
  Ini.WriteInteger(SecName, 'MinPlayers', TSpinEdit(edtList[4][2]).Value);
  Ini.WriteInteger(SecName, 'ShowNightComments', TComboBox(edtList[4][3]).ItemIndex);
  Ini.WriteInteger(SecName, 'ShowRolesOnStart', TComboBox(edtList[4][4]).ItemIndex);
  Ini.WriteInteger(SecName, 'UseShop', TComboBox(edtList[4][5]).ItemIndex);
  Ini.WriteInteger(SecName, 'UseYakuza', TComboBox(edtList[4][6]).ItemIndex);
  Ini.WriteInteger(SecName, 'UseNeutral', TComboBox(edtList[4][7]).ItemIndex);
  Ini.WriteInteger(SecName, 'PlayersForNeutral', TSpinEdit(edtList[4][8]).Value);
  Ini.WriteInteger(SecName, 'NeutralCanWin', TComboBox(edtList[4][9]).ItemIndex);
  Ini.WriteString(SecName, 'MafCount', TEdit(edtList[4][10]).Text);
  Ini.WriteInteger(SecName, 'UseSpecialMaf', TComboBox(edtList[4][11]).ItemIndex);
  Ini.WriteInteger(SecName, 'PlayersForSpecialMaf', TSpinEdit(edtList[4][12]).Value);
  Ini.WriteInteger(SecName, 'ComType', TComboBox(edtList[4][13]).ItemIndex);
  Ini.WriteInteger(SecName, 'ComKillManiac', TComboBox(edtList[4][14]).ItemIndex);
  Ini.WriteInteger(SecName, 'ManiacCanUseCurse', TComboBox(edtList[4][15]).ItemIndex);
  Ini.WriteInteger(SecName, 'InfectionChance', TSpinEdit(edtList[4][16]).Value);
  Ini.WriteInteger(SecName, 'InstantCheck', TComboBox(edtList[4][17]).ItemIndex);
  Ini.WriteInteger(SecName, 'ComHelpers', TSpinEdit(edtList[4][18]).Value);
  //---------------------------------------------------------------------------
  // ������ ������� - ��� ���� - ����
  J:=0;
  for K := 3 to 99 do
    if K in setRoles then
    begin
      Ini.WriteInteger(SecName, 'UseRole_'+IntToStr(K), TComboBox(edtList[5][J]).ItemIndex);
      Ini.WriteInteger(SecName, 'RoleMinPlayers_'+IntToStr(K), TSpinEdit(edtList[5][J+1]).Value);
      Ini.WriteInteger(SecName, 'RoleKnowCom_'+IntToStr(K), TComboBox(edtList[5][J+2]).ItemIndex);
      Inc(J, 3);
    end;
  for K:=102 to 255 do
    if (K in setRoles) and not (K in [101,151]) then
    begin
      Ini.WriteInteger(SecName, 'UseRole_'+IntToStr(K), TComboBox(edtList[5][J]).ItemIndex);
      Inc(J);
    end;
  //---------------------------------------------------------------------------
  Ini.Free;
end;

procedure TfrmSettings.NumEditChange (Sender : TObject);
begin
  TEdit(Sender).Text:=IntToStr(StrToIntDef(TEdit(Sender).Text, TEdit(Sender).Tag));
end;

procedure TfrmSettings.FloatEditChange (Sender : TObject);
begin
  TEdit(Sender).Text:=FloatToStr(StrToFloatDef(TEdit(Sender).Text, TEdit(Sender).Tag));
end;

procedure TfrmSettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
  PageCtrl.Free;
  btnApply.Free;
  frmSettings:=nil;
end;

procedure TfrmSettings.FormHide(Sender: TObject);
var I, K: Integer;
begin
  for I := 0 to PageCtrl.PageCount - 1 do
  begin
    for K := 0 to PageCtrl.Pages[I].Tag - 1 do
    begin
      lblList[I][K].Free;
      edtList[I][K].Free;
    end;
    lblList[I]:=nil;
    edtList[I]:=nil;
  end;
  lblList:=nil;
  edtList:=nil;
end;

procedure TfrmSettings.FormShow(Sender: TObject);
var
  I, K: Integer;
  Ini: TIniFile;
  Strings: TStringList;
  SecName: String;
  ErrFlag: Boolean;
begin
  ErrFlag:=False;
  try
    //config_dir:=PCorePlugin^.AskPluginTempPath+'\Mafia';

    file_config:=ExtractFilePath(ParamStr(0))+'Plugins\Mafia\config.ini';
    file_messages:=ExtractFilePath(ParamStr(0))+'Plugins\Mafia\messages.ini';
    file_gametypes:=ExtractFilePath(ParamStr(0))+'Plugins\Mafia\gametypes.ini';
    //file_users:=config_dir+'\users.ini';

  except
    ErrFlag:=True;
  end;
  if ErrFlag then
  begin
    MessageBox(0, '��������� ������ ��� ���������.', '������', MB_ICONEXCLAMATION);
    Self.Close();
  end
  else if not FileExists(file_config) or not FileExists(file_gametypes) or not FileExists(file_messages) then
  begin
    MessageBox(0, '����������� ���� ��� ��������� ������, ����������� ��� ������ �������.', '������', MB_ICONEXCLAMATION);
    //ShellExecute(0, 'open', PChar('"'+PCorePlugin^.AskPluginTempPath+'\Mafia"'), nil, nil, SW_SHOWNORMAL);
    Self.Close();
  end
  else
  begin
  RoleText2:=LoadRoles();

  updownListCount:=0;

  SetLength(PrntList, PageCtrl.PageCount);
  SetLength(lblList, PageCtrl.PageCount);
  SetLength(edtList, PageCtrl.PageCount);
  SetLength(UpDownList, 20);

  for I := 0 to PageCtrl.PageCount - 1 do
   PrntList[I]:=PageCtrl.Pages[I];

  PrntList[0]:=ScrollBoxMain;
  PrntList[1]:=ScrollBoxTime;
  PrntList[2]:=ScrollBoxPoints;
  PrntList[3]:=ScrollBoxStatistic;
  PrntList[4]:=ScrollBoxGametype;
  PrntList[5]:=ScrollBoxGametypeRoles;


  for I := 0 to PageCtrl.PageCount - 1 do
   PrntList[I].Tag:=0;

  Ini:=TIniFile.Create(file_config);

  //---------------------------------------------------------------------------
  // ������ ������� - �������� ���������
  SetLength(lblList[0], 32);
  SetLength(edtList[0], 32);

  AddParameterEdit(0, '����� ����', Ini, 'Mafia', 'Channel', '�����');
  AddParameterEdit(0, '����� ������', Ini, 'Mafia', 'ChannelHelp', '�����(�������� � �������)');
  AddParameterEdit(0, '�������� ����� ����', Ini, 'Mafia', 'ChannelMain1', 'main');
  AddParameterYesNo(0, '�������� �������� ��� ������ ����', Ini, 'Mafia', 'ReloadSettingsOnStart', 1);
  AddParameterYesNo(0, '������ �� IP', Ini, 'Mafia', 'IPFilter', 0);
  AddParameterYesNo(0, '������ �� ID', Ini, 'Mafia', 'IDFilter', 0);
  AddParameterEdit(0, '��� ����', Ini, 'Mafia', 'BotName', 'Mafiozi');
  AddParameterEdit(0, '������ ����', Ini, 'Mafia', 'BotPass', 'mafiarulez');
  Strings:=TStringList.Create();
  Strings.Add('�������');
  Strings.Add('�������');
  AddParameterCombo(0, '��� ����', Ini, 'Mafia', 'BotIsFemale', 1, Strings);
  Strings.Free;
  AddParameterEdit(0, 'IP ����', Ini, 'Mafia', 'BotIP', 'N/A');
  AddParameterEdit(0, '��������� ����', Ini, 'Mafia', 'BotState', '��� ���� �����');
  AddParameterYesNo(0, '��������� ���������� ��������� ������', Ini, 'Mafia', 'BanOnDeath', 1);
  AddParameterYesNo(0, '��������� ��������� ��������� ������', Ini, 'Mafia', 'BanPrivateOnDeath', 0);
  AddParameterEdit(0, '������� ������� ���������� ���������', Ini, 'Mafia', 'BanReason', '��������� �� ����');
  AddParameterEdit(0, '������� ������ �����������', Ini, 'Mafia', 'UnbanReason', '��������� ����');
  AddParameterYesNo(0, '���������� ���������� � ������', Ini, 'Mafia', 'StatToPrivate', 0);
  AddParameterNumEdit(0, '���� �������������� ���������', Ini, 'Mafia', 'MaskPrice', 20, 0, 500, 5);
  AddParameterNumEdit(0, '���� �����', Ini, 'Mafia', 'RadioPrice', 15, 0, 500, 5);
  AddParameterNumEdit(0, '����� �������� ����� (�����)', Ini, 'Mafia', 'RadioNights', 1, 1, 50, 1);
  AddParameterYesNo(0, '������� �� ��������� ����������� �����, ����� ������� ��� ������', Ini, 'Mafia', 'FastGame', 1);
  Strings:=TStringList.Create();
  Strings.Add('� ����');
  Strings.Add('� ����');
  AddParameterCombo(0, '������ ����', Ini, 'Mafia', 'StartFromNight', 1, Strings);
  Strings.Free;
  AddParameterYesNo(0, '���������� ���������� ������� �����', Ini, 'Mafia', 'ShowNightActions', 0);
  Strings:=TStringList.Create();
  Strings.Add('�� ���������');
  Strings.Add('���������� ������ �����������');
  Strings.Add('���������� ������ ����������� (F9)');
  AddParameterCombo(0, '��� ���������', Ini, 'Mafia', 'MessagesType', 0, Strings);
  Strings.Free;

  Strings:=TStringList.Create();
  Strings.Add('��� ��������');
  Strings.Add('�������� ����');
  Strings.Add('��������� � �����');
  Strings.Add('�������� ���� � �������� ��������� � �����');
  AddParameterCombo(0, '��� �������� ��� ����� �������� ������', Ini, 'Mafia', 'ChangeGametypeNotify', 1, Strings);
  Strings.Free;

  AddParameterNumEdit(0, '������������� ������ ����� ���� ����� X ���', Ini, 'Mafia', 'ChangeGametypeGamesCount', 0, 0, 500, 5);
  //---------------------------------------------------------------------------

  //---------------------------------------------------------------------------
  // ������ ������� - �����
  SetLength(lblList[1], 8);
  SetLength(edtList[1], 8);

  AddParameterNumEdit(1, '����� �� ����� ������� (�)', Ini, 'Mafia', 'TimeStart', 60, 20, 600, 10);
  AddParameterNumEdit(1, '����� �� ������������� ���� (�)', Ini, 'Mafia', 'TimeAccept', 30, 0, 180, 10);
  AddParameterNumEdit(1, '����������������� ���� (�)', Ini, 'Mafia', 'TimeNight', 60, 30, 600, 10);
  AddParameterNumEdit(1, '����������������� ���� (�)', Ini, 'Mafia', 'TimeMorning', 25, 10, 600, 10);
  AddParameterNumEdit(1, '����������������� ��� (�)', Ini, 'Mafia', 'TimeDay', 60, 20, 600, 10);
  AddParameterNumEdit(1, '����� �� ��������� ����� (�)', Ini, 'Mafia', 'TimeLastWord', 15, 0, 600, 10);
  AddParameterNumEdit(1, '����������������� ������ (�)', Ini, 'Mafia', 'TimeEvening', 20, 0, 600, 10);
  AddParameterNumEdit(1, '����� ����� ����� ����������� ���� (��)', Ini, 'Mafia', 'TimePause', 1000, 1, 15000, 500);
  //---------------------------------------------------------------------------

  //---------------------------------------------------------------------------
  // ������ ������� - ����
  SetLength(lblList[2], 255);
  SetLength(edtList[2], 255);

  for I:=1 to 255 do
    if I in [1..18, 151..158] then
      AddParameterNumEdit(2, Ini.ReadString('MafiaPoints', 'Help_'+IntToStr(i), ''), Ini, 'MafiaPoints', IntToStr(i), 0, -100,100,1);
  //---------------------------------------------------------------------------

  //---------------------------------------------------------------------------
  // �������� ������� - ����������
  SetLength(lblList[3], 3);
  SetLength(edtList[3], 3);

  AddParameterYesNo(3, '��������� �����������', Ini, 'Stats', 'UpdateGreeting', 0);
  AddParameterYesNo(3, '������� ���������� �� ������� ����', Ini, 'Stats', 'Export', 0);
  AddParameterEdit(3, '��� ����� ��� �������� ����������', Ini, 'Stats', 'File', 'C:\MafStats.html');

  //---------------------------------------------------------------------------
  SecName:=Ini.ReadString('Mafia', 'DefaultGametype', 'Gametype_0');
  Ini.Free;

  Ini:=TIniFile.Create(file_gametypes);
  //---------------------------------------------------------------------------
  // ����� ������� - ��� ����
  SetLength(lblList[4], 50);
  SetLength(edtList[4], 50);
  PageCtrl.Pages[4].Caption:='"'+SecName+'" - ��������';
  AddParameterEdit(4, '�������� ����', Ini, SecName, 'Name', '������� ����');
  AddParameterEdit(4, '������� ��� ����� ������: !���� ', Ini, SecName, 'Command', '�� ���������');
  AddParameterNumEdit(4, '����������� ���������� �������', Ini, SecName, 'MinPlayers', 6, 5, 100, 1);
  AddParameterYesNo(4, '��������������� �������� ������ ��������', Ini, SecName, 'ShowNightComments', 0);
  AddParameterYesNo(4, '���������� ���� � ������ ����', Ini, SecName, 'ShowRolesOnStart', 0);
  AddParameterYesNo(4, '������������ �������', Ini, SecName, 'UseShop', 1);
  Strings:=TStringList.Create();
  Strings.Add('�� � ����');
  Strings.Add('� ����');
  AddParameterCombo(4, '�������� �����', Ini, SecName, 'UseYakuza', 0, Strings);
  Strings.Free;
  Strings:=TStringList.Create();
  Strings.Add('�� � ����');
  Strings.Add('� ����');
  AddParameterCombo(4, '����������� ��������', Ini, SecName, 'UseNeutral', 1, Strings);
  Strings.Free;
  AddParameterNumEdit(4, '����������� ���������� ������� ��� ��������� ������������ ���������', Ini, SecName, 'PlayersForNeutral', 8, 0, 254, 1);
  Strings:=TStringList.Create();
  Strings.Add('���������� ����, ������ �������');
  Strings.Add('���������� ����');
  AddParameterCombo(4, '����������� �������� �������� � ����� ������ ����� �������', Ini, SecName, 'NeutralCanWin', 0, Strings);
  Strings.Free;
  AddParameterEdit(4, '����������_������� = ����������_������� /', Ini, SecName, 'MafCount', '3', 3);
  Strings:=TStringList.Create();
  Strings.Add('�� � ����');
  Strings.Add('� ����');
  AddParameterCombo(4, '������ ���', Ini, SecName, 'UseSpecialMaf', 1, Strings);
  Strings.Free;
  AddParameterNumEdit(4, '����������� ���������� ������� ��� ��������� ������� ����', Ini, SecName, 'PlayersForSpecialMaf', 12, 0, 254, 1);
  Strings:=TStringList.Create();
  Strings.Add('����������');
  Strings.Add('�����������');
  Strings.Add('��������');
  AddParameterCombo(4, '��� ���������', Ini, SecName, 'ComType', 0, Strings);
  Strings.Free;
  AddParameterYesNo(4, '���������� �������� ����� ������� ��� ��������', Ini, SecName, 'ComKillManiac', 1);
  AddParameterYesNo(4, '������ ����� ������������ ���������', Ini, SecName, 'ManiacCanUseCurse', 1);
  AddParameterNumEdit(4, '����������� ��������� ������� (%)', Ini, SecName, 'InfectionChance', 50, 0, 100, 10);
  AddParameterYesNo(4, '������������ �������� ����������, ��������� � ������', Ini, SecName, 'InstantCheck', 0);
  AddParameterNumEdit(4, '���������� ��������� ���������� ���������', Ini, SecName, 'ComHelpers', 2, 0, 8, 1);
  //---------------------------------------------------------------------------
  // ������ ������� - ��� ���� - ����
  SetLength(lblList[5], 255);
  SetLength(edtList[5], 255);
  PageCtrl.Pages[5].Caption:='"'+SecName+'" - ����';
  for K := 3 to 99 do
    if K in setRoles then
    begin
      Strings:=TStringList.Create();
      Strings.Add('�� � ����');
      Strings.Add('���� �� ��������� ����������');
      Strings.Add('� ����');
      AddParameterCombo(5, RoleText2[K, 0], Ini, SecName, 'UseRole_'+IntToStr(K), 1, Strings, 15);
      Strings.Free;
      AddParameterNumEdit(5, '����������� �������� ������� ��� ��������� '+RoleText2[K, 3]+' (���� �������� ����������� ��������� "� ����")', Ini, SecName, 'RoleMinPlayers_'+IntToStr(K), 0, 0, 100, 1);
      AddParameterYesNo(5, RoleText2[K, 0]+' � '+RoleText2[2,0]+' ����� ���� �����', Ini, SecName, 'RoleKnowCom_'+IntToStr(K), 0);
    end;
  for K:=102 to 255 do
    if (K in setRoles) and not (K in [101,151]) then
    begin
      Strings:=TStringList.Create();
      Strings.Add('�� � ����');
      Strings.Add('� ����');
      AddParameterCombo(5, RoleText2[K, 0], Ini, SecName, 'UseRole_'+IntToStr(K), 2, Strings, 5);
      Strings.Free;
    end;
  //---------------------------------------------------------------------------
  Ini.Free;
  end;
end;

end.