unit uFrequencyFormatter;

interface

uses
  uUnitFormatter;

type
  TFrequencyFormatter = class(TUnitFormatter)
  public
    constructor Create;
  end;

implementation

{ TFrequencyFormatter }

constructor TFrequencyFormatter.Create;
begin
  inherited;
  
  UnitName := 'Hz';
end;

end.
