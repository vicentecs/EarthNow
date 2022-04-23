unit Model.Config;

interface

uses
  REST.Json;

type

  TConfig = class
  private
    Fsatelite: Integer;
    FUltimoSat: Integer;
    FDtAtualizacao: TDateTime;
    FTempoAtualiza: Integer;
  public
    property Satelite: Integer read Fsatelite write Fsatelite default 0;
    property UltimoSat: Integer read FUltimoSat write FUltimoSat default -1;
    property DtAtualizacao: TDateTime read FDtAtualizacao write FDtAtualizacao;
    property TempoAtualiza: Integer read FTempoAtualiza write FTempoAtualiza default 20;

    function ToJsonString: string;
    class function FromJsonString(AJsonString: string): TConfig;
  end;

implementation

  { TConfig }

class function TConfig.FromJsonString(AJsonString: string): TConfig;
begin
  Result := TJson.JsonToObject<TConfig>(AJsonString);
end;

function TConfig.ToJsonString: string;
begin
  Result := TJson.ObjectToJsonString(self);
end;

end.
