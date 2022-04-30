unit Controller.Atualizacao;

interface

uses
  System.Classes,
  System.IOUtils,
  System.SysUtils,

  Vcl.Dialogs,
  Winapi.Windows,
  ShellAPI,

  Model.Boss,
  RESTRequest4D,
  View.Download;

type
  TControllerAtualizacao = class
  private
    FBoss: TBoss;
    FVersao: String;
    FURLVersao: string;
    FURLExe: string;
    function BuscaJson: string;
    function DeveAtualizar(const AVersaoAPP, AVersaoAPI: String): Boolean;
    function GetUrlExe: string;
    function GetNomeExe(AUrlExe: String): string;
  public
    property URLVersao: string read FURLVersao write FURLVersao;
    property URLExe: string read FURLExe write FURLExe;
    property Versao: string read FVersao write FVersao;
    function Atualizar: Boolean;
    class function Executar(const AVersaoApp, AUrlVersao, AUrlExe: String): Boolean;
  end;

implementation

  { TControllerAtualizacao }

function TControllerAtualizacao.Atualizar: Boolean;
var
  sBoss: string;
  sURL: string;
  sExe: string;
begin
  Result := False;

  if FVersao.IsEmpty then
    Exit;

  sBoss := BuscaJson;
  if sBoss.IsEmpty then
    Exit;

  FBoss := TBoss.FromJsonString(sBoss);
  if not(Assigned(FBoss)) or FBoss.version.IsEmpty then
    Exit;

  if not DeveAtualizar(FVersao, FBoss.version) then
    Exit;

  ShowMessage(Format('Existe um atualização do APP da versão %s para %s, confirme para atualizar', [FVersao, FBoss.version]));

  sURL := GetUrlExe;
  sExe := GetNomeExe(sURL);
  Result := TfrmDownload.Executar(sURL, sExe);
  if Result then
    ShellAPI.ShellExecute(0, 'Open', PChar(sExe), PChar('/SILENT'), nil, SW_SHOWNORMAL);
end;

function TControllerAtualizacao.BuscaJson: string;
var
  LResponse: IResponse;
begin
  LResponse := TRequest.New.BaseURL(FURLVersao).Accept('application/json').Get;

  if LResponse.StatusCode <> 200 then
    Exit('');

  Result := LResponse.Content;
end;

function TControllerAtualizacao.DeveAtualizar(const AVersaoAPP, AVersaoAPI: String): Boolean;
var
  VersaoApp: TStringlist;
  VersaoApi: TStringlist;
  App1, App2, App3: Integer;
  Api1, Api2, Api3: Integer;
begin
  Result := False;
  VersaoApp := TStringlist.Create;
  VersaoApi := TStringlist.Create;
  try
    VersaoApp.Delimiter := '.';
    VersaoApp.DelimitedText := AVersaoAPP;
    VersaoApi.Delimiter := '.';
    VersaoApi.DelimitedText := AVersaoAPI;

    App1 := StrToIntDef(VersaoApp.Strings[0], 0);
    App2 := StrToIntDef(VersaoApp.Strings[1], 0);
    App3 := StrToIntDef(VersaoApp.Strings[2], 0);

    Api1 := StrToIntDef(VersaoApi.Strings[0], 0);
    Api2 := StrToIntDef(VersaoApi.Strings[1], 0);
    Api3 := StrToIntDef(VersaoApi.Strings[2], 0);

    if (Api1 > App1)  then
      Exit(True);

    if (Api1 <= App1) and (Api2 > App2) then
      Exit(True);

    if (Api1 <= App1) and (Api2 <= App2) and (Api3 > App3) then
      Exit(True);
  finally
    VersaoApp.Free;
    VersaoApi.Free;
  end;
end;

class function TControllerAtualizacao.Executar(const AVersaoApp, AUrlVersao, AUrlExe: String): Boolean;
begin
  with TControllerAtualizacao.Create do
  begin
    try
      Versao := AVersaoApp;
      UrlVersao := AUrlVersao;
      UrlExe := AUrlExe;
      Result := Atualizar;
    except
      on E: Exception do
        Result := False;
    end;
  end;
end;

function TControllerAtualizacao.GetNomeExe(AUrlExe: String): string;
begin
  Result := Concat(TPath.GetTempPath,ExtractFileName(AUrlExe.Replace('/', '\')));
end;

function TControllerAtualizacao.GetUrlExe: string;
begin
  Result := Format(FURLExe,[FBoss.version]);
end;

end.
