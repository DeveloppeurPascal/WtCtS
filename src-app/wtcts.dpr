program wtcts;

uses
  System.StartUpCopy,
  FMX.Forms,
  f_principale in 'f_principale.pas' {Form1},
  u_urlOpen in '..\lib-externes\librairies\u_urlOpen.pas',
  u_md5 in '..\lib-externes\librairies\u_md5.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait, TFormOrientation.InvertedPortrait];
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
