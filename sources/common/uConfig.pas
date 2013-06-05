unit uConfig;

interface

function GetDatabasePath: string;

implementation

function GetDatabasePath: string;
begin
  // TODO: визначати шлях від exe-файлу
  Result := 'd:\projects\golden_temp\product\data\database.fdb';
end;

end.
