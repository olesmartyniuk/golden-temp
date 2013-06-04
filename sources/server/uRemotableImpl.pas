{ Invokable implementation File for TGoldenTemp which implements IGoldenTemp }

unit uRemotableImpl;

interface

uses
  Soap.InvokeRegistry,
  System.Types,
  Soap.XSBuiltIns,
  uRemotable;

type

  { TGoldenTemp }
  TServerImpl = class(TInvokableClass, IAdministrator)
    public
  end;

implementation

initialization

{ Invokable classes must be registered }
InvRegistry.RegisterInvokableClass(TServerImpl);

end.
