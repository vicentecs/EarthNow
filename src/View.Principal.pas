unit View.Principal;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Threading,

  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.Graphics,
  Vcl.Imaging.jpeg,
  Vcl.Menus,
  Vcl.OleCtrls,
  Vcl.StdCtrls,

  ShellAPI,
  Windows,

  SHDocVw,

  Controller.EarthNow;

type
  TfrmEarthNow = class(TForm)
    btnAtualizar: TButton;
    btnAplicar: TButton;
    lblLista: TLabel;
    wb1: TWebBrowser;
    tmrAtualiza: TTimer;
    trycn1: TTrayIcon;
    pm1: TPopupMenu;
    Abrir: TMenuItem;
    Fechar: TMenuItem;
    lstSatalites: TListBox;
    lblAtualizacao: TLabel;
    lblImagem: TLabel;
    lblUltimaDT: TLabel;
    cbbIntervalo: TComboBox;
    lblAtualiza: TLabel;
    lblSobre: TLabel;
    procedure btnAtualizarClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAplicarClick(Sender: TObject);
    procedure tmrAtualizaTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure trycn1DblClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FecharClick(Sender: TObject);
    procedure AbrirClick(Sender: TObject);
    procedure lstSatalitesClick(Sender: TObject);
    procedure lblSobreClick(Sender: TObject);
    procedure cbbIntervaloChange(Sender: TObject);
  private
      { Private declarations }
    FEarNow: TControllerEarNow;
    FSair: Boolean;
    function BuscarDados: Boolean;
    property Sair: Boolean read FSair write FSair default False;

    procedure AtualizaLbData;
    procedure AplicarImg;
    procedure MostrarAPP;
    procedure OcultarAPP;
  public
      { Public declarations }
  end;

var
  frmEarthNow: TfrmEarthNow;

implementation

{$R *.dfm}

procedure TfrmEarthNow.AbrirClick(Sender: TObject);
begin
  MostrarAPP;
end;

procedure TfrmEarthNow.AplicarImg;
begin
  if lstSatalites.ItemIndex < 0 then
    Exit;

  FEarNow.AplicarImg(lstSatalites.ItemIndex);
  AtualizaLbData;
end;

procedure TfrmEarthNow.AtualizaLbData;
begin
  FEarNow.AtualizaLabelDt(lblAtualizacao, lblUltimaDT);
end;

procedure TfrmEarthNow.btnAplicarClick(Sender: TObject);
var
  aTask: ITask;
begin
  aTask := TTask.Create(
    procedure
    begin
      btnAplicar.Enabled := False;
      try
        AplicarImg;
      finally
        btnAplicar.Enabled := True;
      end;
    end);
  aTask.Start;
end;

procedure TfrmEarthNow.btnAtualizarClick(Sender: TObject);
begin
  try
    if not BuscarDados then
      ShowMessage('Não foi possivel buscars os dados ');
    Exit;
  except
    on E: Exception do
      ShowMessage('Falha ao baixar os dados: ' + E.Message);
  end;
end;

function TfrmEarthNow.BuscarDados: Boolean;
begin
  Result := FEarNow.AlimentaSatelites(lstSatalites);
  lstSatalitesClick(lstSatalites);
end;

procedure TfrmEarthNow.cbbIntervaloChange(Sender: TObject);
begin
   FEarNow.SetIntervaloi(cbbIntervalo.ItemIndex);
end;

procedure TfrmEarthNow.FecharClick(Sender: TObject);
begin
  Sair := True;
  Close;
end;

procedure TfrmEarthNow.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Sair then
    Exit
  else
    CanClose := False;

  OcultarAPP;
end;

procedure TfrmEarthNow.FormCreate(Sender: TObject);
begin
  try
    FEarNow := TControllerEarNow.Create;
    BuscarDados;
    AtualizaLbData;
    FEarNow.AtualizaIntervalo(cbbIntervalo);
    tmrAtualiza.Enabled := True;
  except
    on E: Exception do
  end;
end;

procedure TfrmEarthNow.FormDestroy(Sender: TObject);
begin
  if Assigned(FEarNow) then
    FEarNow.Free;
end;

procedure TfrmEarthNow.lblSobreClick(Sender: TObject);
begin
  ShellAPI.ShellExecute(0, 'Open', PChar('https://github.com/vicentecs/EarthNow'), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmEarthNow.lstSatalitesClick(Sender: TObject);
var
  Url: string;
begin
  Url := FEarNow.UrlMini(lstSatalites.ItemIndex);
  if wb1.LocationURL <> Url then
    wb1.Navigate(Url);
  FEarNow.SetSatelite(lstSatalites.ItemIndex);
end;

procedure TfrmEarthNow.MostrarAPP;
begin
  Self.Show;
  Self.WindowState := wsNormal;
  Application.BringToFront;
end;

procedure TfrmEarthNow.OcultarAPP;
begin
  Self.Hide;
  Self.WindowState := wsMinimized;
end;

procedure TfrmEarthNow.tmrAtualizaTimer(Sender: TObject);
var
  aTask: ITask;
begin
  if cbbIntervalo.ItemIndex = 0 then
    Exit;

  aTask := TTask.Create(
    procedure
    begin
      tmrAtualiza.Enabled := False;
      try
        if FEarNow.DeveAtualizar(lstSatalites.ItemIndex) then
          AplicarImg;
      finally
        tmrAtualiza.Enabled := True;
      end;
    end);
  aTask.Start;
end;

procedure TfrmEarthNow.trycn1DblClick(Sender: TObject);
begin
  MostrarAPP;
end;

end.
