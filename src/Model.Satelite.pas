unit Model.Satelite;

interface

uses
  Generics.Collections,
  Rest.Json;

type

  TUrlClass = class
  private
    FFull: String;
    FLarge: String;
    FSmall: String;
    FTiny: String;
  public
    property full: String read FFull write FFull;
    property large: String read FLarge write FLarge;
    property small: String read FSmall write FSmall;
    property tiny: String read FTiny write FTiny;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TUrlClass;
  end;

  TSourcesClass = class
  private
    FAspect: Double;
    FInterval: Integer;
    FName: String;
    FSpacecraft: String;
    FUrl: TUrlClass;
  public
    property aspect: Double read FAspect write FAspect;
    property interval: Integer read FInterval write FInterval;
    property name: String read FName write FName;
    property spacecraft: String read FSpacecraft write FSpacecraft;
    property url: TUrlClass read FUrl write FUrl;
    constructor Create;
    destructor Destroy; override;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TSourcesClass;
  end;

  TSatelite = class
  private
    FSources: TArray<TSourcesClass>;
  public
    property sources: TArray<TSourcesClass> read FSources write FSources;
    destructor Destroy; override;
    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TSatelite;
  end;

implementation

  { TUrlClass }

function TUrlClass.ToJsonString: string;
begin
  Result := TJson.ObjectToJsonString(self);
end;

class function TUrlClass.FromJsonString(AJsonString: string): TUrlClass;
begin
  Result := TJson.JsonToObject<TUrlClass>(AJsonString);
end;

  { TSourcesClass }

constructor TSourcesClass.Create;
begin
  inherited;
  FUrl := TUrlClass.Create();
end;

destructor TSourcesClass.Destroy;
begin
  FUrl.Free;
  inherited;
end;

function TSourcesClass.ToJsonString: string;
begin
  Result := TJson.ObjectToJsonString(self);
end;

class function TSourcesClass.FromJsonString(AJsonString: string): TSourcesClass;
begin
  Result := TJson.JsonToObject<TSourcesClass>(AJsonString)
end;

  { TDownlinkApp }

destructor TSatelite.Destroy;
var
  LsourcesItem: TSourcesClass;
begin
  for LsourcesItem in FSources do
    LsourcesItem.Free;
  inherited;
end;

function TSatelite.ToJsonString: string;
begin
  Result := TJson.ObjectToJsonString(self);
end;

class function TSatelite.FromJsonString(AJsonString: string): TSatelite;
begin
  Result := TJson.JsonToObject<TSatelite>(AJsonString)
end;

end.
