program sign_app;

uses
  Forms,
  signmain in 'signmain.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '����e��ʵ���Ա���ƿ�ϵͳ';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
