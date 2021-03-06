{ ------------------------------------
  功能说明：插件类祖先
  创建日期：2014/08/16
  作者：mx
  版权：mx
  ------------------------------------- }
unit uPluginBase;

interface

Type
  TPluginClass = Class of TPlugin;

  TPlugin = Class(TObject, IInterface)
  private
    FSys: IInterface;
    
  protected
    { IInterface }
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  public
    Constructor Create(Intf: IInterface); virtual;
    Destructor Destroy; override;

    procedure Init; virtual;
    procedure final; virtual;
    procedure Register(Flags: Integer; Intf: IInterface); virtual;
    property Sys: IInterface read FSys write FSys;
    
  End;

implementation

{ TPlugIn }

constructor TPlugin.Create(Intf: IInterface);
begin

end;

destructor TPlugin.Destroy;
begin

  inherited;
end;

function TPlugin.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TPlugin._AddRef: Integer;
begin
  Result := -1;
end;

function TPlugin._Release: Integer;
begin
  Result := -1;
end;

procedure TPlugin.Init;
begin

end;

procedure TPlugin.final;
begin

end;

procedure TPlugin.Register(Flags: Integer; Intf: IInterface);
begin

end;

end.
