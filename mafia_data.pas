unit mafia_data;

interface

uses
    Classes, SyncObjs;

const
    TopMaxPlayers = 20;

    setRoles: set of 1..255 = [1..9, 51, 101..104, 151, 201..203];

type
  MafUser = record
    id: Word;
    name: String;
    IP: String;
    compID: String;
    pol: integer;
    plays : Word;
    points : Integer;
    wins : Word;
    draws : Word;
    rate : String;
    gamepoints: Integer;
    died: Byte;
    delayedDeath: Byte;
    gamestate: byte;
    {������ ������
      0: ����
      1: ������
      2: ��������
      3: ������
      4: �����
      5: ������
      6: ����������
      7: �����
      8: �����
      9: ����
      51: �������

      101: ����
      102: ������
      103: �������
      104: ���������

      151: ������

      201: ������
      202: ����� ���
      203: ���������
    }
    gamestate_start: byte;
    activity: Byte;
    {���������� ��, � ������ ����}
    activity2: Byte;
    {��� ���, ��� ��������� ���� + �����}
    night_place: Byte;
    {��������� ����� (���� �������� � ��������� ������ ����������, ��... ���)}
    lastactivity: Byte;
    {��������� ��������(����� ������ ���� 2 ���� ������ � ������ � ���� ��)}
    voting: ShortInt;
    {����������� �������}
    use_mask: Byte;
    {
      0:�� �����������
      1:�� ���� ����
      2:������������ � ����(������ �������)
    }

    use_radio: Byte;
    {
      0:�� ������������
      1:������������ � ����(������ �������)
      2 � �����: ���������
    }

    no_activity_days: Byte;
    {���������� ���� �� �������� ������ �� ����������� �� ������� ������������}

  end;

  PMafUser = ^MafUser;
  TwoByte = array[0..1] of Byte;

  TRoleText = array[0..255, 0..3] of String;

var
  // ������� ���������
  game_chan : String;
  help_chan : String;
  main_chan : array[1..8] of String;
  mask_price : Word;
  radio_price : Word;
  radio_nights: Word;

  fast_game: Boolean;

  time_start : Word;
  time_night : Word;
  time_morning : Word;
  time_day : Word;
  time_evening : Word;
  time_accept: Word;
  time_pause: Word;
  time_ban: Double;

  ip_filter, id_filter: Boolean;
  start_night: Boolean;
  show_night_actions: Boolean;
  ban_on_death, ban_private_on_death: Boolean;
  stat_to_private: Boolean;
  top_default: Byte;
  ban_reason, ban_private_reason, unban_reason: String;
  topic_play, topic_wait, topic_playergetting: String;
  load_settings_on_start, export_stats, update_greeting: Boolean;
  changegametype_notify: Byte;
  changegametype_games, changegametype_current_games: Byte;
  show_votepoints: Boolean;
  kill_for_no_activity: Byte;

  Gametype: record
    Name: String;
    MinPlayers, PlayersForSpecialMaf, PlayersForNeutral, RandomHelpers: Byte;
    MafCount: Single;
    UseYakuza, UseNeutral, UseSpecialMaf, UseShop, ComKillManiac: Boolean;
    ManiacCanUseCurse: Boolean;
    ShowRolesOnStart, NeutralCanWin, InstantCheck, ShowNightComments: Boolean;
    InfectionChance: Byte;
    ComType: Byte;
    UseRole: array [3..255] of Byte;
    RoleMinPlayers: array [3..99] of Byte;
    RoleKnowCom: array [3..99] of Boolean;
  end;

  points_cost: array [1..255] of Integer;

  State : Byte; { ��������� �����
    0 : ���������
    1 : ����� �������
    2 : ����
    3 : ����������
    4 : ����
    5 : �����
    255 : �������������
  }

  maf_state, y_state: Byte;
  {
    1 - ������ ���� ���� �� �����
  }
  maf_phrase, y_phrase: String;

  //--------------------------------------
  com_state: byte;
  {
    0: ����
    1: �����������
    2: ������ �������
    3: ������ ����
    4: ������ �������
    5: ������ ������, ������� !�����������
  }

  com_target: byte;   //���� ���������
  com_player: byte;   //��� ��������
  com_phrase: String;
  //--------------------------------------

  //--------------------------------------
  putana_state: byte;
  {
    0: ����/�� � ����
    1: �����������
    2: �����������
  }

  putana_target: byte;   //���� ������
  putana_player: byte;   //���� ������
  putana_phrase: String;
  //--------------------------------------

  //--------------------------------------
  judge_state: byte;
  {
    0: ����/�� � ����
    1: �����������
    2: �����������
  }

  judge_target: byte;   //���� �����
  judge_player: byte;   //��� �����
  judge_phrase: String;
  //--------------------------------------

  //--------------------------------------
  serj_player: byte;   //��� �������
  //--------------------------------------

  //--------------------------------------
  doctor_state: byte;
  {
    0: ����/�� � ����
    1: �����������
    2: �����
  }

  doctor_target: byte;   //���� ����
  doctor_player: byte;   //��� ���
  doctor_heals_himself: byte; //����� �� ��� ����
  //--------------------------------------

  //--------------------------------------
  highlander_phrase: String;
  highlander_under_attack: Boolean;
  //--------------------------------------

  //--------------------------------------
  sherif_state: byte;
  {
    0: ����/�� � ����
    1: �����������
    2: �������
    3: ������ �����
  }

  sherif_target: byte;   //���� ������
  sherif_player: byte;   //��� �����
  sherif_phrase: String;
  //--------------------------------------

  //--------------------------------------
  homeless_state: byte;
  {
    0: ����/�� � ����
    1: �����������
    2: ���������
  }

  homeless_target: byte;   //���� �����
  homeless_player: byte;   //��� ����
  homeless_phrase: String;
  //--------------------------------------

  //--------------------------------------
  killer_state: byte;
  {
    0: ����/�� � ����
    1: �����������
    2: ������ ��������� ������
    3: ������ �����
  }

  killer_target: byte;   //���� �������
  killer_player: byte;   //��� ������
  killer_phrase: String;
  //--------------------------------------

  //--------------------------------------
  lawyer_state: byte;
  {
    0: ����/�� � ����
    1: �����������
    2: ���������
  }

  lawyer_target: byte;   //���� ��������
  lawyer_player: byte;   //��� �������
  //--------------------------------------

  //--------------------------------------
  podrivnik_state: byte;
  {
    0: ����/�� � ����
    1-3: �����������
    4: ���
  }

  podrivnik_target: byte;   //���� ����������
  podrivnik_player: byte;   //��� ���������
  podrivnik_phrase: String;
  //--------------------------------------

  //--------------------------------------
  maniac_state: byte;
  {
    0: ����/�� � ����
    1: �����������
    2: ������ ��������� ������
    3: ������ �����
    10: ���������
  }

  maniac_target: byte;   //���� �������
  maniac_player: byte;   //��� ������
  maniac_use_curse: byte; // ����������� �� ���������
  maniac_phrase: String;
  //--------------------------------------

  //--------------------------------------
  robin_state: byte;
  {
    0: ����/�� � ����
    1: �����������
    2: �� �������
    3: �� ����������
  }

  robin_target: byte;   //���� ����� ����
  robin_player: byte;   //��� ����� ���
  robin_phrase: String;
  //--------------------------------------

  //--------------------------------------
  robber_state: byte;
  {
    0: ����/�� � ����
    1: �����������
    2: ���������
  }

  robber_target: byte;   //���� ���������
  robber_player: byte;   //��� ���������
  robber_phrase: String;
  //--------------------------------------

  maf_chan: String;     //������
  y_chan: String;     //������

  maf_ingame: Byte;

  get_state: Byte;      //������ ������ �������
  night_state: Byte;    //������ ���� (��� ���������������� ����� �����)

  TopPoints : array [1..TopMaxPlayers] of record
    Name: String;
    Points: Integer;
  end;
  TopRate : array [1..TopMaxPlayers] of record
    Name: String;
    Rate: Single;
  end;
  TopRole : array [1..255] of record
    Name: String;
    Plays: Integer;
  end;

  NightPlaces: array [0..2] of String;

  UpdateTopCriticalSection: TCriticalSection;

  Messages: TStringList;

implementation

end.
