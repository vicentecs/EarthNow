unit Controller.Aplicativo;

interface

uses
  System.SysUtils,
  Winapi.Windows;

type

  TAplicativo = class
  public
    class function EmUso: Boolean;
    class function Mostrar(const AppName: String): Boolean;
    class function VersaoExe: String;
  end;

implementation

  { TAplicativo }

class function TAplicativo.EmUso: Boolean;
begin
  CreateMutex(nil, False, PChar(ExtractFileName(Trim(ParamStr(0)))));
  Result := (GetLastError = ERROR_ALREADY_EXISTS);
end;

class function TAplicativo.Mostrar(const AppName: String): Boolean;
var
  wnd: HWND;
begin
  if AppName.IsEmpty then
    raise Exception.Create('AppName em branco');

  wnd := FindWindow(nil, PChar(AppName));
  Result := wnd <> 0;
  If Result then
    SetForegroundwindow(wnd);
end;

class function TAplicativo.VersaoExe: String;
type
  PFFI = ^vs_FixedFileInfo;
var
  F: PFFI;
  Handle: Dword;
  Len: Longint;
  Data: PChar;
  Buffer: Pointer;
  Tamanho: Dword;
  Parquivo: PChar;
  Arquivo: String;
begin
  Arquivo := ParamStr(0);
  Parquivo := StrAlloc(Length(Arquivo) + 1);
  StrPcopy(Parquivo, Arquivo);
  Len := GetFileVersionInfoSize(Parquivo, Handle);
  Result := '';
  if Len > 0 then
  begin
    Data := StrAlloc(Len + 1);
    if GetFileVersionInfo(Parquivo, Handle, Len, Data) then
    begin
      VerQueryValue(Data, '', Buffer, Tamanho);
      F := PFFI(Buffer);
      Result := Format('%d.%d.%d.%d',
        [HiWord(F^.dwFileVersionMs),
        LoWord(F^.dwFileVersionMs),
        HiWord(F^.dwFileVersionLs),
        LoWord(F^.dwFileVersionLs)]);
    end;
    StrDispose(Data);
  end;
  StrDispose(Parquivo);
end;

end.
