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
  IdHTTP,
  IdSSLOpenSSL,

  Controller.Config,
  Controller.Satelite,
  Model.Satelite;

type
  TControllerEarNow = class
  private
    FSatelite: TControllerSatelite;
    FConfig: TControllerConfig;
    function DeveAtualiza(ArqBMP: string): Boolean;
    function BaixarImg(pArqOri, pArqDesd: String): Boolean;
    procedure AlterarBG(pImagemBMP: string; pTile: Boolean);
  public
    constructor Create;

    function AlimentaSatelites(var AList: TListBox): Boolean;
    function ConvertJPG_BMP(xFile: string): String;
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

  { TControllerEarNow }

function TControllerEarNow.AlimentaSatelites(var AList: TListBox): Boolean;
begin
  Result := FSatelite.BuscarDados(AList.items);
  if Result then
    AList.ItemIndex := FConfig.Satelite;
end;

procedure TControllerEarNow.AlterarBG(pImagemBMP: string; pTile: Boolean);
var
  Reg: TRegIniFile;
begin
  Reg := TRegIniFile.Create('Control Panel\Desktop');

  with Reg do
  begin
    WriteString('', 'Wallpaper', pImagemBMP);
    WriteString('', 'WallpaperStyle', '6');
    if (pTile) then
      WriteString('', 'TileWallpaper', '1')
    else
      WriteString('', 'TileWallpaper', '0')
  end;
  Reg.Free;
  SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, nil, SPIF_SENDWININICHANGE);
end;

procedure TControllerEarNow.AplicarImg(AItem: Integer);
var
  Source: TSourcesClass;
  ArqJPG: string;
  ArqBMP: string;
begin
  if AItem < 0 then
    raise Exception.Create('Informe o AItem');

  Source := FSatelite.Satelites.sources[AItem];
  if Source.url.large.IsEmpty then
    Exit;

  ArqJPG := FSatelite.GetNome(AItem);
  ArqBMP := ChangeFileExt(ArqJPG, '.bmp');

  if DeveAtualiza(ArqBMP) then
  begin
    if not BaixarImg(Source.url.large, ArqJPG) then
      Exit;

    ArqBMP := ConvertJPG_BMP(ArqJPG);

    if ArqBMP.IsEmpty or not FileExists(ArqBMP) then
      Exit;

    FConfig.UltimoSat := AItem;
    FConfig.DtAtualizacao := Now;
  end;

  if FileExists(ArqJPG) then
    DeleteFile(PChar(ArqJPG));

  if ArqBMP.IsEmpty or not FileExists(ArqBMP) then
    Exit;

  AlterarBG(ArqBMP, False);
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
  HTTP1: TIdHTTP;
  IdSSL1: TIdSSLIOHandlerSocketOpenSSL;
begin
  if FileExists(pArqDesd) then
    DeleteFile(PChar(pArqDesd));

  Stream := TMemoryStream.Create;
  HTTP1 := TIdHTTP.Create(nil);
  IdSSL1 := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  try
    HTTP1.IOHandler := IdSSL1;
    IdSSL1.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];

    HTTP1.Request.Connection := 'Keep-Alive';
    HTTP1.Request.UserAgent :=
      'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36';
    HTTP1.Request.Accept := 'application/json, text/javascript, */*; q=0.01';
    HTTP1.Request.ContentType := 'application/x-www-form-urlencoded; charset=UTF-8';
    HTTP1.Request.CharSet := 'utf-8';
    HTTP1.HandleRedirects := True;
    HTTP1.Get(pArqOri, Stream);
    Stream.SaveToFile(pArqDesd);
    Result := FileExists(pArqDesd);
  finally
    FreeAndNil(HTTP1);
    FreeAndNil(IdSSL1);
    FreeAndNil(Stream);
  end;
end;

function TControllerEarNow.ConvertJPG_BMP(xFile: string): String;
var
  Bmp1: Vcl.Graphics.TBitmap;
  JPG: TJPegImage;
  Arq: string;
begin
  if ExtractFileExt(xFile) <> '.jpg' then
  begin
      // ShowMessage('Formato diferente de jpg' + sLineBreak + 'Formato atual : ' + ExtractFileExt(xFile));
    Exit;
  end;

  JPG := TJPegImage.Create;
  try
    JPG.LoadFromFile(xFile);
    Bmp1 := Vcl.Graphics.TBitmap.Create;
      // Bmp2 := TBitmap.Create;
    try
      Arq := ChangeFileExt(xFile, '.bmp');
      Bmp1.Assign(JPG);
      Bmp1.SaveToFile(Arq);

        // Bmp1.Assign(JPG);
        // Bmp2.SetSize(Screen.DesktopWidth, Screen.DesktopHeight);
        // Bmp2.Canvas.Brush.Color:= clBtnFace;
        // Bmp2.Canvas.FillRect(Bmp2.Canvas.ClipRect);
        // Bmp2.Canvas.StretchDraw(Rect(0, 0, Screen.DesktopWidth, Screen.DesktopHeight), Bmp1);
        // Bmp2.SaveToFile(Arq);

      Result := Arq;
    finally
      FreeAndNil(Bmp1);
    end;
  finally
    FreeAndNil(JPG);
  end;
end;

constructor TControllerEarNow.Create;
begin
  inherited;
  FSatelite := TControllerSatelite.Create;
  FConfig := TControllerConfig.Create;
end;

function TControllerEarNow.DeveAtualiza(ArqBMP: string): Boolean;
var
  BmpDt: TDateTime;
begin
  if not FileExists(ArqBMP) then
    Exit(True);

  FileAge(ArqBMP, BmpDt);
  Result := IncMinute(BmpDt, FConfig.TempoAtualiza) < Now;
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
