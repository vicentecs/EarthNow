unit Model.Boss;

interface

uses Generics.Collections, Rest.Json;

type

  TBoss = class
  private
    FDescription: String;
    FHomepage: String;
    FName: String;
    FVersion: String;
  public
    property description: String read FDescription write FDescription;
    property homepage: String read FHomepage write FHomepage;
    property name: String read FName write FName;
    property version: String read FVersion write FVersion;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TBoss;
  end;

implementation

  { TRootClass }

function TBoss.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TBoss.FromJsonString(AJsonString: string): TBoss;
begin
  result := TJson.JsonToObject<TBoss>(AJsonString)
end;

end.
