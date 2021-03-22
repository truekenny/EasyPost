program EasyPost;

uses
  Vcl.Forms,
  UnitM in 'UnitM.pas' {FormMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.ShowMainForm := False;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
