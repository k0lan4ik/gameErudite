program main;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

begin
  try
    { TODO -oUser -cConsole Main : �������� ���������� ����}
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
