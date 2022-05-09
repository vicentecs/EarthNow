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

  Controller.EarthNow,
  Controller.Atualizacao,
  Controller.Aplicativo;

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
    btnLimparCache: TButton;
    tmrMinimizar: TTimer;
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
    procedure btnLimparCacheClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tmrMinimizarTimer(Sender: TObject);
  private
      { Private declarations }
    FEarNow: TControllerEarNow;
    FSair: Boolean;
    function BuscarDados: Boolean;
    property Sair: Boolean read FSair write FSair default False;

    procedure AtualizarLbData;
    procedure AtualizarMiniatura;
    procedure AplicarImg;
    procedure MostrarAPP;
    procedure OcultarAPP;
    procedure TimeMinimizar;
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
  AtualizarMiniatura;
  AtualizarLbData;
end;

procedure TfrmEarthNow.AtualizarLbData;
begin
  FEarNow.AtualizaLabelDt(lblAtualizacao, lblUltimaDT);
end;

procedure TfrmEarthNow.AtualizarMiniatura;
var
  Url: string;
begin
  Url := FEarNow.UrlMini(lstSatalites.ItemIndex);
  if Url <> EmptyStr then
    wb1.Navigate(Url);
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
        FEarNow.SetSatelite(lstSatalites.ItemIndex);
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

procedure TfrmEarthNow.btnLimparCacheClick(Sender: TObject);
begin
  btnLimparCache.Enabled := False;
  try
    FEarNow.LimparCache;
  finally
    btnLimparCache.Enabled := True;
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
  if Sair or not Self.Visible then
    Exit
  else
    CanClose := False;

  OcultarAPP;
end;

procedure TfrmEarthNow.FormCreate(Sender: TObject);
begin
  try
    if TControllerAtualizacao.Executar(TAplicativo.VersaoExe,
      'https://raw.githubusercontent.com/vicentecs/EarthNow/main/boss.json',
      'https://github.com/vicentecs/EarthNow/releases/download/v%s/Setup-EarthNow.exe' ) then
      Application.Terminate;

    TimeMinimizar;
    Caption := Caption + TAplicativo.VersaoExe;
    FEarNow := TControllerEarNow.Create;
    BuscarDados;
    AtualizarLbData;
    FEarNow.AtualizaIntervalo(cbbIntervalo);
  except
    on E: Exception do
  end;
end;

procedure TfrmEarthNow.FormDestroy(Sender: TObject);
begin
  if Assigned(FEarNow) then
    FEarNow.Free;
end;

procedure TfrmEarthNow.FormShow(Sender: TObject);
begin
  tmrAtualiza.Enabled := True;
end;

procedure TfrmEarthNow.lblSobreClick(Sender: TObject);
begin
  ShellAPI.ShellExecute(0, 'Open', PChar('https://github.com/vicentecs/EarthNow'), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmEarthNow.lstSatalitesClick(Sender: TObject);
begin
  AtualizarMiniatura;
end;

procedure TfrmEarthNow.MostrarAPP;
begin
  Self.Show;
  Self.WindowState := wsNormal;
  Application.BringToFront;
end;

procedure TfrmEarthNow.OcultarAPP;
begin
  if not Self.Visible then
    Self.Visible := True;
  Self.Hide;
  Self.WindowState := wsMinimized;
end;

procedure TfrmEarthNow.TimeMinimizar;
var
  I: Integer;
begin
  for I := 1 to ParamCount do
    if LowerCase(ParamStr(i)) = '-startup' then
      tmrMinimizar.Enabled := True;
end;

procedure TfrmEarthNow.tmrMinimizarTimer(Sender: TObject);
begin
  tmrMinimizar.Enabled := False;
  OcultarAPP;
end;

procedure TfrmEarthNow.tmrAtualizaTimer(Sender: TObject);
const
  INTERVALO = 60000;
var
  aTask: ITask;
begin
  if tmrAtualiza.Interval <> INTERVALO then
    tmrAtualiza.Interval := INTERVALO;

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
