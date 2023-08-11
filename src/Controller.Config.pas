unit Controller.Config;

interface

uses
  System.Json,
  System.Classes,
  System.IOUtils,
  System.SysUtils,

  Model.Config;

type
  TControllerConfig = class
  private
    FConfig: TConfig;
    FPathApp: string;
    function GetDtAtualizacao: TDateTime;
    function Getsatelite: Integer;
    function GetTempoAtualiza: Integer;
    function GetUltimoSat: Integer;
    procedure SetDtAtualizacao(const Value: TDateTime);
    procedure SetSatelite(const Value: Integer);
    procedure SetTempoAtualiza(const Value: Integer);
    procedure SetUltimoSat(const Value: Integer);

    function GetNomeConfig: String;
    procedure CarregaDados;
  public
    constructor Create;
    destructor Destroy; override;
    property Satelite: Integer read Getsatelite write SetSatelite;
    property UltimoSat: Integer read GetUltimoSat write SetUltimoSat;
    property DtAtualizacao: TDateTime read GetDtAtualizacao write SetDtAtualizacao;
    property TempoAtualiza: Integer read GetTempoAtualiza write SetTempoAtualiza;
    procedure GravarDados;
  end;

implementation

  { TControllerConfig }

procedure TControllerConfig.CarregaDados;
var
  Json: TStringList;
  arq: string;
begin
  arq := GetNomeConfig;
  if not FileExists(arq) then
  begin
    if not Assigned(FConfig) then
      FConfig := TConfig.Create;
    Exit;
  end;

  if Assigned(FConfig) then
    FConfig.Free;

  Json := TStringList.Create;
  try
    Json.LoadFromFile(arq);
    FConfig := TConfig.FromJsonString(Json.Text);
  finally
    Json.Free;
    if not Assigned(FConfig) then
      FConfig := TConfig.Create;
  end;
end;

constructor TControllerConfig.Create;
begin
  inherited;
  FPathApp := TPath.GetHomePath + PathDelim + 'EarthNow' + PathDelim;
  if not DirectoryExists(FPathApp) then
    ForceDirectories(FPathApp);
  CarregaDados;
end;

destructor TControllerConfig.Destroy;
begin
  if Assigned(FConfig) then
  begin
    GravarDados;
    FConfig.Free;
  end;
end;

function TControllerConfig.GetDtAtualizacao: TDateTime;
begin
  Result := FConfig.DtAtualizacao;
end;

function TControllerConfig.GetNomeConfig: String;
begin
  Result := FPathApp + 'config.json';
end;

function TControllerConfig.Getsatelite: Integer;
begin
  Result := FConfig.Satelite;
end;

function TControllerConfig.GetTempoAtualiza: Integer;
begin
  Result := FConfig.TempoAtualiza
end;

function TControllerConfig.GetUltimoSat: Integer;
begin
  Result := FConfig.UltimoSat;
end;

procedure TControllerConfig.GravarDados;
var
  ConfigJson: TStringList;
begin
  ConfigJson := TStringList.Create;
  try
    ConfigJson.Text := FConfig.ToJsonString;
    ConfigJson.SaveToFile(GetNomeConfig);
  finally
    ConfigJson.Free;
  end;
end;

procedure TControllerConfig.SetDtAtualizacao(const Value: TDateTime);
begin
  FConfig.DtAtualizacao := Value;
  GravarDados;
end;

procedure TControllerConfig.SetSatelite(const Value: Integer);
begin
  FConfig.Satelite := Value;
  GravarDados;
end;

procedure TControllerConfig.SetTempoAtualiza(const Value: Integer);
begin
  FConfig.TempoAtualiza := Value;
  GravarDados;
end;

procedure TControllerConfig.SetUltimoSat(const Value: Integer);
begin
  Fconfig.UltimoSat := Value;
  GravarDados;
end;

end.
