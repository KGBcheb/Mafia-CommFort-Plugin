unit libfunc;

interface

uses
  Windows, MyIniFiles, comm_info, comm_data, libqueue, SysUtils;

  procedure MsgToChannel(Channel, Msg:string);
  procedure StatusToChannel(Channel, Msg:string);
  procedure PrivateMsg(Name, Msg:string);
  procedure PrivateStatus(Name, Msg:string);
  procedure PersonalMsg(Name, Msg:string; Importance: Dword=0);
  procedure ChangeTopic(Channel, Msg:string);
  procedure ChangeGreeting(Channel, Msg:string);
  procedure ChangeState(Msg:string);
  procedure CreateChannel(Channel:string; Visible,JoinRegime: Integer);
  procedure QuitChannel(Channel:string);
  procedure BanUser(TypeBan,TypeIdent,TypeAnonym: Word; BanTime:Double;
                    Ident,Channel,Reason: String);
  procedure CloseChannel(Channel: String);

  function GetTimeFromStr(Str : String): Word;
  function CheckStr(Str : String): String;
  function unCheckStr(Str : String): String;
  function GetRandomTextFromIni(FileName:String; TextId : String): String;

  procedure Pause(time: Cardinal);

  function FormatNick(Name:String): String;

  function GetDllPath: String; stdcall;
  function ExtractFileNameEx(FileName: string; ShowExtension: Boolean): string;

  function GetConfigFullName(FileName: string): string;

implementation
  procedure MsgToChannel(Channel, Msg:string);
  begin
    if msg_send_type<2 then
      PCorePlugin^.AddMessageToChannel(BOT_NAME, Channel,0,msg_format_begin+Msg+msg_format_end)
    else
      PCorePlugin^.AddMessageToChannel(BOT_NAME, Channel,1,msg_format_begin+Msg+msg_format_end);
  end;

  procedure StatusToChannel(Channel, Msg:string);
  begin
    PCorePlugin^.AddMessageToChannel(BOT_NAME, Channel,msg_send_type mod 2,msg_format_begin+Msg+msg_format_end);
  end;

  procedure PrivateMsg(Name, Msg:string);
  begin
    PCorePlugin^.AddPrivateMessage(BOT_NAME, 0,Name,Msg);
  end;

  procedure PrivateStatus(Name, Msg:string);
  begin
    PCorePlugin^.AddPrivateMessage(BOT_NAME, 1,Name,Msg);
  end;

  procedure PersonalMsg(Name, Msg:string; Importance: Dword=0);
  begin
    PCorePlugin^.AddPersonalMessage(BOT_NAME, 0, Name,Msg);
  end;

  procedure ChangeTopic(Channel, Msg:string);
  begin
    PCorePlugin^.AddTheme(BOT_NAME, Channel,Msg);
  end;

  procedure ChangeGreeting(Channel, Msg:string);
  begin
    PCorePlugin^.AddGreeting(BOT_NAME, Channel,Msg);
  end;

  procedure ChangeState(Msg:string);
  begin
    PCorePlugin^.AddState(BOT_NAME, Msg);
  end;

  procedure CreateChannel(Channel:string; Visible,JoinRegime: Integer);
  begin
    PCorePlugin^.AddChannel(BOT_NAME, Channel,Visible,JoinRegime);
  end;

  procedure QuitChannel(Channel:string);
  begin
    PCorePlugin^.LeaveChannel(BOT_NAME, Channel);
  end;

  procedure BanUser(TypeBan,TypeIdent,TypeAnonym: Word; BanTime:Double;
                    Ident,Channel,Reason: String);
  begin
    PCorePlugin^.AddRestriction(BOT_NAME, TypeBan,TypeIdent,
      TypeAnonym,BanTime,Ident,Channel,Reason);
  end;

  procedure CloseChannel(Channel: String);
  begin
    PCorePlugin^.RemoveChannel(BOT_NAME, Channel);
  end;

  function CheckStr(Str : String): String;
  begin
    Result := StringReplace(Str, '[', '&'+IntToStr(Byte('['))+';', [rfReplaceAll]);
    Result := StringReplace(Result, ']', '&'+IntToStr(Byte(']'))+';', [rfReplaceAll]);
  end;

  function unCheckStr(Str : String): String;
  begin
    Result := StringReplace(Str, '&'+IntToStr(Byte('['))+';', '[', [rfReplaceAll]);
    Result := StringReplace(Result, '&'+IntToStr(Byte(']'))+';', ']', [rfReplaceAll]);
  end;

  function GetRandomTextFromIni(FileName:String; TextId : String): String;
  var
    Ini : TIniFile;
    I, Count: Word;
  begin
    Randomize;
    Ini := TIniFile.Create(FileName);
    Count := Ini.ReadInteger(TextId, 'Count', 1);
    I:=Random(Count)+1;
    Result := Ini.ReadString(TextId, 'Text'+IntToStr(I), '');
    Ini.Free;
  end;

function GetTimeFromStr(Str : String): Word;
begin
  Result:=StrToIntDef(Str, 0);
  if StrToIntDef(Str, 0)<0 then
    Result:=0
  else
    if Result > 360 then
      Result:=360;
end;

procedure Pause(time: Cardinal);
var
  Buf: TBytes;
begin
  //Sleep(time);
  SetLength(Buf, 4);
  CopyMemory(@Buf[0], @time, 4);
  MsgQueue.InsertMsg(QUEUE_MSGTYPE_PAUSE, Buf, 4);
  Buf := nil;
end;

function FormatNick(Name:String): String;
begin
  Result:='[url=/message: '+Name+']'+Name+'[/url]';
end;

function GetDllPath: String; stdcall;
var
  TheFileName: array[0..MAX_PATH] of char;
begin
  FillChar(TheFileName, sizeof(TheFileName), #0);
  GetModuleFileName(hInstance, TheFileName, sizeof(TheFileName));
  Result:=TheFileName;
end;


{ **** UBPFD *********** by delphibase.endimus.com ****
>> ��������� ����� ����� �� ���� ��� ��� � ��� �����������.

�����������: ���
�����:       VID, snap@iwt.ru, ICQ:132234868, ���������
Copyright:   VID
����:        18 ������ 2002 �.
***************************************************** }

function ExtractFileNameEx(FileName: string; ShowExtension: Boolean): string;
//������� ���������� ��� �����, ��� ��� � ��� �����������.

//������� ���������
//FileName - ��� �����, ������� ���� ����������
//ShowExtension - ���� TRUE, �� ������� ��������� �������� ��� �����
// (��� ������� ���� ������� � ����), � ����������� ����� �����, �����, ���������
// �������� ��� �����, ��� ���������� ����� �����.
var
  I: Integer;
  S, S1: string;
begin
  //���������� ����� ������� ����� �����
  I := Length(FileName);
  //���� ����� FileName <> 0, ��
  if I <> 0 then
  begin
    //� ����� ����� ��������� FileName ���� ������ "\"
    while (FileName[i] <> '\') and (i > 0) do
      i := i - 1;
    // �������� � ���������� S �������� FileName ������� ����� ����������
    // "\", ����� ������� ���������� S �������� ��� ����� � �����������, �� ���
    // ������� ���� ������� � ����
    S := Copy(FileName, i + 1, Length(FileName) - i);
    i := Length(S);
    //���� ���������� S = '' �� ������ ���������� ''
    if i = 0 then
    begin
      Result := '';
      Exit;
    end;
    //�����, �������� ��� ����� ��� ����������
    while (S[i] <> '.') and (i > 0) do
      i := i - 1;
    //... � �������� ��� ��� ����� � ���������� s1
    S1 := Copy(S, 1, i - 1);
    //���� s1='' �� , ���������� s1=s
    if s1 = '' then
      s1 := s;
    //���� ���� �������� �������� ������� ���������� ��� ����� � ���
    // �����������, �� Result = s,
    //���� ��� ����������, �� Result = s1
    if ShowExtension = TRUE then
      Result := s
    else
      Result := s1;
  end
    //����� ������� ���������� ''
  else
    Result := '';
end;

function GetConfigFullName(FileName: string): string;
begin
  // ������� �������� ��������� ����� �� ���������� � ���������� ������� ��������
	Result:=config_dir +'\' + FileName;
  if not FileExists(Result) then
    Result:=ExtractFilePath(ParamStr(0))+'Plugins\' + PLUGIN_FILENAME + '\' + FileName;
  if not FileExists(Result) then
    Result:=ExtractFilePath(ParamStr(0))+'Plugins\Mafia\' + FileName;
end;

end.

