unit comm_data;

interface

uses Windows, SysUtils;

type
  TUser = record
    Name : string;
    IP   : string;
    sex  : DWord;
  end;
  TUsers = array of TUser;

  TChannel = record
    Name  : string;
    Users : DWord;
    Theme : string;
  end;
  TChannels = array of TChannel;

  TRegUser = record
    Name : string;
    IP   : string;
  end;
  TRegUsers = array of TRegUser;

  TWaitUser = record
    Status: Word;
    Name  : string;
    IP    : string;
    ID    : string;
    date  : Double;
    msg   : string;
    moder : string;
    reason: string;
  end;
  TWaitUsers = array of TWaitUser;

  TRestriction = record
    restID : DWORD;
    date   : Double;
    remain : Double;
    ident  : DWord;
    Name   : string;
    IP     : string;
    IPrange: string;
    compID : string;
    banType: DWord;
    channel: string;
    moder  : string;
    reason : string;
  end;
  TRestrictions = array of TRestriction;

  TtypeCommFortProcess = procedure(dwPluginID : DWORD; dwMessageID : DWORD; bMessage : PChar; dwMessageLength : DWORD); stdcall;
  TtypeCommFortGetData = function(dwPluginID : DWORD; dwMessageID : DWORD; bInBuffer : TBytes; inBufferLength : DWORD; bOutBuffer : PChar; outBufferLength : DWORD) : DWORD; stdcall;
  TError = procedure(Sender: TObject; Error: Exception; Extratext: String='') of object;
  TPreMsg = function(Sender: TObject; bMessage : PCHAR; dwMessageLength : PDWORD): boolean of object;
  TAuthFail = procedure(Sender: TObject; Name : string; Reason: Word) of object;
  TJoinChannelFail = procedure(Sender: TObject; Name, Channel : string; Reason: Word) of object;
  TPrivMsg = procedure(Sender: TObject; Name: String; User : TUser; regime : integer; bMessage : string) of object;
  TPMsg = procedure(Sender: TObject; Name: String; User : TUser; bMessage : string) of object;
  TJoinBot = procedure(Sender: TObject; Name: string; channel : string; theme : string; greeting: string) of object;
  TPubMsg = procedure(Sender: TObject; Name: String; User : TUser; channel: string; regime : integer; bMessage : string) of object;
  TChnTheme = procedure(Sender: TObject; Name: String; User : TUser; channel: string; newtheme : string) of object;
  TUsrJoin = procedure(Sender: TObject; Name: String; User : TUser; channel: string) of object;
  TUsrLeft = procedure(Sender: TObject; Name: String; User : TUser; channel: string) of object;
  TChnName = procedure(Sender: TObject; User : TUser; newname: string; newicon: integer) of object;
  TChnIcon = procedure(Sender: TObject; User : TUser; newicon: integer) of object;
  TChnStt = procedure(Sender: TObject; User : TUser; newstate: string) of object;
  TChatUsrJoin = procedure(Sender: TObject; User : TUser) of object;
  TChatUsrLeft = procedure(Sender: TObject; User : TUser) of object;
  TonConStChg =  procedure(Sender: TObject; newstate : DWord) of object;

const

  PM_PLUGIN_JOIN_VIRTUAL_USER   = 1001; //plugin -> commfort: ���������� ������������ ������������: �����(���) + �����(IP-�����) + �����(��� ������) + �����(������) + �����(������)
  PM_PLUGIN_LEAVE_VIRTUAL_USER  = 1002; //plugin -> commfort: ��������� ������������ ������������: �����(���)
  PM_PLUGIN_SNDMSG_PUB          = 1020; //plugin -> commfort: ������������ ��������� � �����: �����(��� ������������ ������������) + �����(�����) + �����(�����) + �����(���������) ������: 0 - ����� ����������� ������ 1 - ����� ����������� ���������� (F9)
  PM_PLUGIN_SNDMSG_PRIV         = 1021; //plugin -> commfort: ������������ ��������� � ������: �����(��� ������������ ������������) + �����(�����)+�����(��� ������������)+�����(���������) ������: 0 - ����� ����������� ������ 1 - ����� ����������� ���������� (F9)
  PM_PLUGIN_SNDMSG_PM           = 1022; //plugin -> commfort: ��������� ������ ���������:  �����(��� ������������ ������������) + �����(��� ��������) + �����(��� ������������)+�����(���������)
  PM_PLUGIN_THEME_CHANGE        = 1023; //plugin -> commfort: �������� ���� ������: �����(��� ������������ ������������) + �����(�����)+�����(����� ����)
  PM_PLUGIN_GREETING_CHANGE     = 1024; //plugin -> commfort: �������� ����������� ������: �����(�����)+�����(����� �����������)
  PM_PLUGIN_SNDIMG_PUB          = 1080; //plugin -> commfort: ������������ ����������� � �����: �����(��� ������������ ������������) + �����(�����) + ������(������ ����������� � ������� jpg)
  PM_PLUGIN_SNDIMG_PRIV         = 1081; //plugin -> commfort: ������������ ����������� � ������: �����(��� ������������ ������������) + �����(��� ������������) + ������(������ ����������� � ������� jpg)


  PM_PLUGIN_STATUS_CHANGE       = 1025; //plugin -> commfort: �������� ���������: �����(��� ������������ ������������) + �����(����� ���������)
  PM_PLUGIN_RENAME_CHANNEL      = 1029; //plugin -> commfort: ������������ ����� : �����(��� ������������ ������������) + �����(�����) + �����(����� �������� ������)

  PM_PLUGIN_RESTRICT_SET        = 1040; //plugin -> commfort: �������� �����������: �����(��� ������������ ������������) + �����(��� �������������) + �����(������ �������������) + ����� (��� �����������) + �����(����� �����������) + ����() + �����(������� �����������) + �����(��� �����������)
  PM_PLUGIN_RESTRICT_DEL        = 1041; //plugin -> commfort: ����� �����������: �����(��� ������������ ������������) + �����(ID �����������) + �����(�������)
  PM_PLUGIN_CHANNEL_DEL         = 1028; //plugin -> commfort: ������� (�������) �����: �����(��� ������������ ������������) + �����(�����)
  PM_PLUGIN_CHANGE_ICON         = 1026; //plugin -> commfort: �������� ������: �����(��� ������������ ������������) + �����(����� ������)
  PM_PLUGIN_ANNOUNCMENT_ADD     = 1050; //plugin -> commfort: ������������ ����������: �����(��� ������������ ������������) + �����(ID �������) + �����(���������) + �����(����� ����������) + �����(��� ��������) + �����(��� ������� ������������) + ����(���� �������� ����������)
  PM_PLUGIN_ANNOUNCMENT_DEL     = 1051; //plugin -> commfort: ������� ����������: �����(��� ������������ ������������) + �����(ID ����������)
  PM_PLUGIN_COMMENT_ADD         = 1055; //plugin -> commfort: ������������ �����������: �����(��� ������������ ������������) + �����(ID ����������) + �����(����� �����������)
  PM_PLUGIN_COMMENT_DEL         = 1056; //plugin -> commfort: ������� �����������: �����(��� ������������ ������������) + �����(ID �����������)
  PM_PLUGIN_PASSWORD_CHANGE     = 1070; //plugin -> commfort: �������� ������: �����(��� ������������ ������������) + �����(��� ������������, ������� ���������� �������� ������) + �����(��� ������) + �����(����� ������)
  PM_PLUGIN_ACCOUNT_DEL         = 1071; //plugin -> commfort: ������� ������� ������ � ������� : �����(��� ������������ ������������) + �����(��� ���������� ������������)
  PM_PLUGIN_ACCOUNT_AGREE       = 1033; //plugin -> commfort: ������� ��������� ������� ������: �����(��� ������������ ������������) + �����(����������� ������� ������)
  PM_PLUGIN_ACCOUNT_DISAGREE    = 1034; //plugin -> commfort: ��������� ��������� ������� ������: �����(��� ������������ ������������) + �����(����������� ������� ������) + �����(�������)

  PM_PLUGIN_STOP                = 2100; //plugin -> commfort: ���������� ������
  PM_PLUGIN_CHANNEL_JOIN        = 1026; //plugin -> commfort: �������/������������ � ������ ������: �����(��� ������������ ������������) + �����(�����)+�����(���������)+�����(����� �����) ���������: 0 - ����� ������� � ������ ������� 1 - ����� �������� � ������ ������� ����� �����: 0 - ���� �������� ���� ������������� 1 - ���� �������� ������ �� ����������� ��������! ���� ������������ ����� ������������ ���������� �� ����� ��� � 16 ����� �������.
  PM_PLUGIN_CHANNEL_LEAVE       = 1027; //plugin -> commfort: �������� ����� �����

  PM_PLUGIN_AUTH_FAIL           = 1090; //commfort -> plugin: ����������� ������������ ������������ ����������: �����(��� ������������ ������������) + �����(��� �������)
  PM_PLUGIN_JOINCHANNEL_FAIL    = 1091; //commfort -> plugin: ����������� � ������ ������������ ������������ ����������:�����(��� ������������ ������������) + �����(�����) + �����(��� �������)
  PM_PLUGIN_MSG_PRIV            = 1060; //commfort -> plugin: ��������� � ������: �����(��� ������������ ������������) + ������������()+�����(�����)+�����(���������) ������: 0 - ����� ����������� ������ 1 - ����� ����������� ���������� (F9)
  PM_PLUGIN_MSG_PM              = 1061; //commfort -> plugin: ������ ���������: �����(��� ������������ ������������) + ������������()+�����(���������)
  PM_PLUGIN_JOIN_BOT            = 1062; //commfort -> plugin: ����������� � ������ ����: �����(��� ������������ ������������) + �����(�����)+�����(����)+�����(�����������)
  PM_PLUGIN_MSG_PUB             = 1070; //commfort -> plugin: ���������� ��������� � �����: �����(��� ������������ ������������) + ������������()+�����(�����)+�����(�����)+�����(���������) ������: 0 - ����� ����������� ������ 1 - ����� ����������� ���������� (F9)
  PM_PLUGIN_THEME_CHANGED       = 1071; //commfort -> plugin: ����� ���� ������: �����(��� ������������ ������������, ������� ������������ � ������ ������) + ������������()+�����(�����)+�����(����� ����)
  PM_PLUGIN_USER_JOINEDCHANNEL  = 1072; //commfort -> plugin: ����������� � ������ ������� ������������: �����(��� ������������ ������������, ������� ������������ � ������ ������) + ������������()+�����(�����)
  PM_PLUGIN_USER_LEAVEDCHANNEL  = 1073; //commfort -> plugin: ����� �� ������ ������� ������������: �����(��� ������������ ������������, ������� ������������ � ������ ������) + ������������()+�����(�����)
  PM_PLUGIN_ICON_CHANGED        = 1076; //commfort -> plugin: ����� ������: ������������()+�����(����� ����� ������)
  PM_PLUGIN_STATUS_CHANGED      = 1077; //commfort -> plugin: ����� ���������: ������������()+�����(����� ���������)
  PM_PLUGIN_USER_JOINED         = 1078; //commfort -> plugin: ������������ ������������� � ����: ������������()
  PM_PLUGIN_USER_LEAVED         = 1079; //commfort -> plugin: ������������ ������� ���: ������������()

  GD_PROGRAM_TYPE               = 2000; //plugin -> commfort: ��� ���������. ���� ������ (���������): [������� ��������]. ���� ������ (��������): �����(��� ���������)
  GD_PROGRAM_VERSION            = 2001; //plugin -> commfort: ������ ���������. ���� ������ (���������): [������� ��������]. ���� ������ (��������): �����(������ ���������)
  GD_PLUGIN_TEMPPATH            = 2010; //plugin -> commfort: ������������� ���� ��� ��������� ������ ��������. ���� ������ (���������): [������� ��������]. ���� ������ (��������): �����(����)
  GD_MAXIMAGESIZE               = 1030; //plugin -> commfort: ������������ ������ ����������� � ������. ���� ������ (���������): [������� ��������]. ���� ������ (��������): �����(����������) + (�����(�������� ������) + �����(���������� ������������� � ������) + �����(���� ������))*����������
  GD_CHANNELS_GET               = 1040; //plugin -> commfort: ������ ����� �������. ���� ������ (���������): �����(�������� ������). ���� ������ (��������): �����(������������ ����� � ������) + �����(������������ ������ � ��������)
  GD_USERS_GET                  = 1041; //plugin -> commfort: ������ ������������� � ����. ���� ������ (���������): [������� ��������]. ���� ������ (��������): �����(����������) + ������������()*����������
  GD_USERCHANNELS_GET           = 1080; //plugin -> commfort: ������ �������, � ������� ��������� ����������� ������������. ���� ������ (���������): �����(��� ������������ ������������). ���� ������ (��������): �����(����������) + (�����(�������� ������) + �����(���������� ������������� � ������) + �����(���� ������))*����������
  GD_CHANNELUSERS_GET           = 1081; //plugin -> commfort: ������ ������������� � ������, � �������� ��������� ����������� ������������. ���� ������ (���������): �����(��� ������������ ������������) + �����(�����). ���� ������ (��������): �����(����������) + ������������()*����������
  GD_REGUSERS_GET               = 1042; //plugin -> commfort: ������ ������������������ �������������. ���� ������ (���������): [������� ��������]. ���� ������ (��������): �����(����������) + ������������()*����������
  GD_WAITUSERS_GET              = 1043; //plugin -> commfort: ������ ������ �� ���������. ���� ������ (���������): [������� ��������]. ���� ������ (��������): �����(����������) + (�����(������) + ����_�_�����() + �����(���) + �����(IP-�����) + �����(ID ����������) + �����(���������) + �����(������� ������ ����������, ������������� ������) + �����(������� ����������))*����������
  GD_RESTRICTIONS_GET           = 1044; //plugin -> commfort: ������ �����������. ���� ������ (���������): [������� ��������]. ���� ������ (��������): �����(����������) + (�����(ID �����������) + ����_�_�����(�������� ������) + ����(���������� �� ��������� �����������) + �����(��� �������������) + �����(������� ������) + �����(IP-�����) + �����(�������� IP-�������) + �����(ID ����������) + �����(��� �����������) + �����(�����) + �����(������� ������ ����������) + �����(�������))*����������
  GD_IPSTATE_GET                = 1050; //plugin -> commfort: ��������� ������� IP-������. ���� ������ (���������): �����(��� ������������). ���� ������ (��������): �����(��������� ������� IP-������)
  GD_PASSWORD_GET               = 1060; //plugin -> commfort: ������ ������� ������. ���� ������ (���������): �����(��� ������������). ���� ������ (��������): �����(32 ���������� MD5 ���-��� ������)
  GD_IP_GET                     = 1061; //plugin -> commfort: IP-����� ������������. ���� ������ (���������): �����(��� ������������). ���� ������ (��������): �����(IP-�����)
  GD_ID_GET                     = 1062; //plugin -> commfort: ID ���������� ������������. ���� ������ (���������): �����(��� ������������). ���� ������ (��������): �����(ID ����������)

  GD_PLUGIN_SERVER_OR_CLIENT    = 2800; //plugin -> commfort: �������������� �������
  GD_PLUGIN_NAME                = 2810; //plugin -> commfort: �������� �������

  PRE_PLUGIN_MSG                = 0;  //commfort -> plugin: ������������ ���������
  PRE_PLUGIN_THEME              = 1;  //commfort -> plugin: ������������ ���
  PRE_PLUGIN_ANNOUNCMENT        = 2;  //commfort -> plugin: ������������ ����������

  PM_CLIENT_SNDMSG_PUB          = 50;
  PM_CLIENT_SNDMSG_PRIV         = 63;
  PM_CLIENT_SNDMSG_PM           = 70;
  PM_CLIENT_THEME_CHANGE        = 61;
  PM_CLIENT_GREETING_CHANGE     = 62;
  PM_CLIENT_SNDIMG_PUB          = 51; // plugin -> commfort: ��������� ����������� � ����� �����. �����(�������� ������) + �����(������ �����������) + ������(������ �����������). �������: 0 - bmp, 1 - jpg, 2 - bmp.
  PM_CLIENT_SNDIMG_PRIV         = 64; //plugin -> commfort: ��������� ����������� � ������. �����(��� ������������) + �����(������ �����������) + ������(������ �����������). �������: 0 - bmp, 1 - jpg, 2 - bmp.
  PM_CLIENT_CHANNEL_JOIN        = 67;
  PM_CLIENT_CHANNEL_LEAVE       = 66; //plugin -> commfort: �������� ����� �����
  PM_CLIENT_PRIVATE_LEAVE       = 65; //plugin -> commfort: �������� ��������� �����

  PM_CLIENT_CONSTATUS_CHANGED   = 3; //commfort -> plugin: ����� � �������� (������ ������): �����(����� ��������� ����� � ��������)
  PM_CLIENT_MSG_PUB             = 5; //commfort -> plugin: ���������� ��������� � �����: ������������()+�����(�����)+�����(�����)+�����(���������) ������: 0 - ����� ����������� ������ 1 - ����� ����������� ���������� (F9)
  PM_CLIENT_MSG_PRIV            = 10;//commfort -> plugin: ��������� � ������: ������������()+�����(�����)+�����(���������) ������: 0 - ����� ����������� ������ 1 - ����� ����������� ���������� (F9) 2 - ����������� � ��������� ����� (����� � ���� ������ ����� "[image]") 3 - ������ ���������

  GD_CLIENT_CURRENT_USER_GET    = 12; //plugin -> commfort: ������� ������������. ���� ������ (���������): [������� ��������]. ���� ������ (��������): ������������(������� ������������)
  GD_CLIENT_CONSTATE_GET        = 11; //plugin -> commfort: ��������� ����� � ��������.
  GD_CLIENT_RIGHT_GET           = 19; //plugin -> commfort: ����� ������� ������� ������. ���� ������ (���������): �����(��� �����) + �����(�����). ���� ������ (��������): �����(��� ���������� �����)
  GD_CLIENT_CHANNELUSERS_GET    = 17; //plugin -> commfort: ������ ������������� � ������. ���� ������ (���������): �����(�����). ���� ������ (��������): �����(����������) + ������������()*����������

  MAX_NAME = 30;

  PLU_VER  = '3.6.0';

  PLU_NAME = '����� (����) '+PLU_VER;

var
  msg_format_begin, msg_format_end: String;
  msg_send_type: Byte;
  BOT_NAME: String;
  BOT_PASS: String;
  BOT_ISFEMALE: Byte;
  BOT_IP: String;
  PROG_TYPE:Byte;

  // ���� � ������
  config_dir: String;

  file_config: String;
  file_messages: String;
  file_gametypes: String;
  file_users: String;
  file_data: String;
  file_log: String;
  file_template: String;
  file_template_greeting: String;

  file_export_stats:String;

implementation

end.
