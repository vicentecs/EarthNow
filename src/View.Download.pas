unit View.Download;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdComponent, IdAntiFreeze, IdTCPConnection,
  IdHTTP, Vcl.ComCtrls, Vcl.StdCtrls, IdIOHandler, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, Vcl.ExtCtrls, IdIOHandlerSocket, IdAntiFreezeBase, IdBaseComponent, IdTCPClient;

type
  TfrmDownload = class(TForm)
    ProgressBar: TProgressBar;
    lblAndamento: TLabel;
    IdHTTP1: TIdHTTP;
    IdAntiFreeze1: TIdAntiFreeze;
    idslhndlrscktpnsl1: TIdSSLIOHandlerSocketOpenSSL;
    tmrAtivar: TTimer;
    procedure IdHTTP1Work(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    procedure IdHTTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
    procedure IdHTTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure tmrAtivarTimer(Sender: TObject);
  private
      { Private declarations }
    FURL: String;
    FArquivo: string;
    FBaixado: Boolean;
    FCancelado: Boolean;
    function RetornaKiloBytes(ValorAtual: real): string;
    procedure Baixar;
  public
      { Public declarations }
    property URL: String read FURL write FURL;
    property Arquivo: string read FArquivo write FArquivo;
    property Baixado: Boolean read FBaixado write FBaixado;
    class function Executar(const AURL, AArquivo: String): Boolean;
  end;

var
  frmDownload: TfrmDownload;

implementation

{$R *.dfm}

procedure TfrmDownload.Baixar;
var
  Stream: TMemoryStream;
begin
  try
    Stream := TMemoryStream.Create;
    try
      if FileExists(FArquivo) then
        DeleteFile(FArquivo);
      IdHTTP1.Get(FURL, Stream);
      Stream.SaveToFile(FArquivo);
      FBaixado := FileExists(FArquivo);
    finally
      FreeAndNil(Stream);
    end;
  except
    on E: Exception do
      FBaixado := False;
  end;
end;

class function TfrmDownload.Executar(const AURL, AArquivo: String): Boolean;
begin
  with TfrmDownload.Create(nil) do
  begin
    URL := AURL;
    Arquivo := AArquivo;
    ShowModal;
    Result := Baixado;
  end;
end;

procedure TfrmDownload.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FBaixado = False then
  begin
    FCancelado := True;
    IdHTTP1.Disconnect;
  end;
end;

procedure TfrmDownload.FormShow(Sender: TObject);
begin
  tmrAtivar.Enabled := True;
end;

procedure TfrmDownload.IdHTTP1Work(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
var
  Percent: Integer;
begin
  if AWorkMode <> wmRead then
    Exit;

  ProgressBar.Position := AWorkCount;
  Percent := Trunc((AWorkCount / ProgressBar.Max) * 100);
  lblAndamento.Caption := Format('Baixando arquivo %s%% | Baixado %s',
    [FormatFloat('##0', Percent), RetornaKiloBytes(AWorkCount)]);
  lblAndamento.Refresh;
end;

procedure TfrmDownload.IdHTTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
  if AWorkMode <> wmRead then
    Exit;

  ProgressBar.Max := AWorkCountMax;
  ProgressBar.Position := 0;
end;

procedure TfrmDownload.IdHTTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  if AWorkMode <> wmRead then
    Exit;

  if FCancelado = False then
    FBaixado := True;
  ProgressBar.Position := ProgressBar.Max;
  lblAndamento.Caption := 'Arquivo baixado: 100%';
  lblAndamento.Refresh;
  Close;
end;

function TfrmDownload.RetornaKiloBytes(ValorAtual: real): string;
begin
  Result := FormatFloat('0.000 KBs', ((ValorAtual / 1024) / 1024));
end;

procedure TfrmDownload.tmrAtivarTimer(Sender: TObject);
begin
  tmrAtivar.Enabled := False;
  Baixar;
end;

end.
