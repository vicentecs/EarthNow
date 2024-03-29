program EarthNow;

uses
  Vcl.Forms,
  Vcl.Dialogs,
  System.SysUtils,
  Model.Satelite in 'Model.Satelite.pas',
  Controller.Satelite in 'Controller.Satelite.pas',
  Controller.Aplicativo in 'Controller.Aplicativo.pas',
  Model.Config in 'Model.Config.pas',
  View.Principal in 'View.Principal.pas' {frmEarthNow},
  Controller.Config in 'Controller.Config.pas',
  Controller.EarthNow in 'Controller.EarthNow.pas',
  Model.Boss in 'Model.Boss.pas',
  Controller.Atualizacao in 'Controller.Atualizacao.pas',
  View.Download in 'View.Download.pas' {frmDownload};

{$R *.res}

begin
  if TAplicativo.EmUso  then
  begin
    if not TAplicativo.Mostrar('TfrmEarthNow') then
      ShowMessage('O aplicativo j� est� aberto.');
    Exit;
  end;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmEarthNow, frmEarthNow);
  Application.Run;
end.
