{ Invokable interface IGoldenTemp }

unit uRemotable;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns;

type

  { Invokable interfaces must derive from IInvokable }
  IAdministrator = interface(IInvokable)
  ['{D361AF3B-5126-44C5-932E-BA887421C94D}']

    { Methods of Invokable interface must not use the default }
    { calling convention; stdcall is recommended }
  end;

implementation

initialization
  { Invokable interfaces must be registered }
  InvRegistry.RegisterInterface(TypeInfo(IAdministrator));

end.
