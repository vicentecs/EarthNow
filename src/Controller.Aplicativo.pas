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

end.
