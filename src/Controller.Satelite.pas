unit Controller.Satelite;

interface

uses
  System.Classes,
  System.IOUtils,
  System.SysUtils,
  RESTRequest4D,
  Model.Satelite;

type

  TControllerSatelite = class
  private
    FSatelites: TSatelite;
  public
    property Satelites: TSatelite read FSatelites write FSatelites;
    function BuscarDados(AList: TStrings): Boolean;
    function GetNome(AItem: Integer): string;
  end;

implementation

  { TConstroleSatalite }

function TControllerSatelite.BuscarDados(AList: TStrings): Boolean;
var
  LResponse: IResponse;
  list: TSourcesClass;
begin
  if AList = nil then
    raise Exception.Create('Informe o AList');

  LResponse := TRequest.New.BaseURL('https://downlinkapp.com/sources.json').Accept('application/json').Get;
  Result := LResponse.StatusCode = 200;
  if not Result then
    Exit;

  if Assigned(FSatelites) then
    FSatelites.Free;
  FSatelites := TSatelite.FromJsonString(LResponse.Content);

  AList.Clear;
  for list in FSatelites.sources do
    AList.Add(list.spacecraft + ' ' + list.name);
end;

function TControllerSatelite.GetNome(AItem: Integer): string;
var
  Source: TSourcesClass;
begin
  Source := FSatelites.sources[AItem];
  if Source.url.large.IsEmpty then
    Exit('');

  Result := Concat(TPath.GetTempPath, Source.name.Replace(' ', '_'),
    ExtractFileExt(Source.url.large.Replace('/', '\')));
end;

end.
