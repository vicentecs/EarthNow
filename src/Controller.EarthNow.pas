unit Controller.EarthNow;

interface

uses
  System.Classes,
  System.DateUtils,
  System.SysUtils,
  System.Win.Registry,
  Vcl.Imaging.jpeg,
  Vcl.Graphics,
  Vcl.StdCtrls,
  Winapi.Windows,
  Controller.Config,
  Controller.Satelite,
  Model.Satelite;

type
  TControllerEarNow = class
  private
    FSatelite: TControllerSatelite;
    FConfig: TControllerConfig;
    function DeveAtualiza(Imagem: string): Boolean;
    function BaixarImg(pArqOri, pArqDesd: String): Boolean;
    procedure AlterarBG(pImagem: string; pTile: Boolean);
  public
    constructor Create;

    function AlimentaSatelites(var AList: TListBox): Boolean;
    function UrlMini(AItem: Integer): string;
    function DeveAtualizar(AItem: Integer): Boolean;

    procedure AplicarImg(AItem: Integer);
    procedure AtualizaIntervalo(var ACombo: TCombobox);
    procedure AtualizaLabelDt(var ALabelCap, ALabelDt: TLabel);
    procedure LimparCache;

    procedure SetSatelite(ASat: Integer);
    procedure SetIntervaloi(AIntervalor: Integer);
  end;

implementation

uses
  RESTRequest4D;

  { TControllerEarNow }

function TControllerEarNow.AlimentaSatelites(var AList: TListBox): Boolean;
begin
  Result := FSatelite.BuscarDados(AList.items);
  if Result then
    AList.ItemIndex := FConfig.Satelite;
end;

procedure TControllerEarNow.AlterarBG(pImagem: string; pTile: Boolean);
var
  Reg: TRegIniFile;
begin
  Reg := TRegIniFile.Create('Control Panel\Desktop');
  try
    with Reg do
    begin
      WriteString('', 'Wallpaper', pImagem);
      WriteString('', 'WallpaperStyle', '6');
      if (pTile) then
        WriteString('', 'TileWallpaper', '1')
      else
        WriteString('', 'TileWallpaper', '0')
    end;
  finally
    Reg.Free;
    SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, nil, SPIF_SENDWININICHANGE);
  end;
end;

procedure TControllerEarNow.AplicarImg(AItem: Integer);
var
  Source: TSourcesClass;
  ArqJPG: string;
begin
  if AItem < 0 then
    raise Exception.Create('Informe o AItem');

  Source := FSatelite.Satelites.sources[AItem];
  if Source.url.large.IsEmpty then
    raise Exception.Create('url em branco');

  ArqJPG := FSatelite.GetNome(AItem);
  if DeveAtualiza(ArqJPG) then
  begin
    if not BaixarImg(Source.url.large, ArqJPG) then
      raise Exception.Create(Format('falha no donload:%s%s%s%s',[sLineBreak,Source.url.large,sLineBreak,ArqJPG]));

    FConfig.UltimoSat := AItem;
    FConfig.DtAtualizacao := Now;
  end;

  AlterarBG(ArqJPG, False);
end;

procedure TControllerEarNow.AtualizaIntervalo(var ACombo: TCombobox);
begin
  case FConfig.TempoAtualiza of
    - 1:
      ACombo.ItemIndex := 0;
    20:
      ACombo.ItemIndex := 1;
    60:
      ACombo.ItemIndex := 2;
  end;
end;

procedure TControllerEarNow.AtualizaLabelDt(var ALabelCap, ALabelDt: TLabel);
begin
  ALabelCap.Visible := FConfig.DtAtualizacao > 0;
  ALabelDt.Visible := ALabelCap.Visible;
  if not ALabelCap.Visible then
    Exit;
  ALabelDt.Caption := DateTimeToStr(FConfig.DtAtualizacao);
end;

function TControllerEarNow.BaixarImg(pArqOri, pArqDesd: String): Boolean;
var
  Stream: TMemoryStream;
  LResponse: IResponse;
begin
  if FileExists(pArqDesd) then
    DeleteFile(PChar(pArqDesd));

  LResponse := TRequest.New.BaseURL(pArqOri)
    .Accept('application/x-www-form-urlencoded').Get;
  Result := LResponse.StatusCode = 200;
  if not Result then
    Exit;

  Stream := TMemoryStream.Create;
  try
    Stream.LoadFromStream(LResponse.ContentStream);
    Stream.SaveToFile(pArqDesd);
  finally
    FreeAndNil(Stream);
  end;
end;

constructor TControllerEarNow.Create;
begin
  inherited;
  FSatelite := TControllerSatelite.Create;
  FConfig := TControllerConfig.Create;
end;

function TControllerEarNow.DeveAtualiza(Imagem: string): Boolean;
var
  ImgDt: TDateTime;
begin
  if not FileExists(Imagem) then
    Exit(True);

  FileAge(Imagem, ImgDt);
  Result := IncMinute(ImgDt, FConfig.TempoAtualiza) < Now;
end;

function TControllerEarNow.DeveAtualizar(AItem: Integer): Boolean;
begin
  Result := ((FConfig.UltimoSat <> AItem)) or
    ((FConfig.UltimoSat = AItem) and (IncMinute(FConfig.DtAtualizacao, FConfig.TempoAtualiza) < Now));
end;

procedure TControllerEarNow.LimparCache;
var
  item: Integer;
  ArqJPG: string;
  ArqBMP: string;
begin
  for item := 0 to Pred(Length(FSatelite.Satelites.sources)) do
  begin
    ArqJPG := FSatelite.GetNome(item);
    if FileExists(ArqJPG) then
      DeleteFile(PChar(ArqJPG));
    ArqBMP := ChangeFileExt(ArqJPG, '.bmp');
    if FileExists(ArqBMP) then
      DeleteFile(PChar(ArqBMP));
  end;
end;

procedure TControllerEarNow.SetIntervaloi(AIntervalor: Integer);
begin
  case AIntervalor of
    0:
      FConfig.TempoAtualiza := -1; // nenhum
    1:
      FConfig.TempoAtualiza := 20; // 20 min
    2:
      FConfig.TempoAtualiza := 60; // 60 min
  end;
  FConfig.GravarDados;
end;

procedure TControllerEarNow.SetSatelite(ASat: Integer);
begin
  FConfig.Satelite := ASat;
  FConfig.GravarDados;
end;

function TControllerEarNow.UrlMini(AItem: Integer): string;
begin
  Result := FSatelite.Satelites.sources[AItem].url.tiny;
end;

end.
