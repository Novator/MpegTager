{******************************************************************}
{                                                                  }
{ 2003(fw) Ironsoft Lab, Perm, Russia                              }
{ http://ironsite.narod.ru                                         }
{ Written by Iron (Michael Galyuk), ironsoft@mail.ru               }
{                                                                  }
{ ��� ���������������� �� ������ �������� GNU GPL                  }
{ ��� ������������� ���� ������ �� ������ �����������              }
{                                                                  }
{ Software distributed under the License is distributed on an      }
{ "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or   }
{ implied.                                                         }
{                                                                  }
{ ��� ���������������� �� �������� "��� ����", �������             }
{ �������� �� �����������������, �� ����������� ��� �� ���� ����.  }
{ ����� �� ����� ��������������� �� ����������� ����� ���������    }
{ � ��� �������������� (���������� ��� ������������).              }
{                                                                  }
{******************************************************************}

program MpegTag;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Mpeg Tager';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
