unit uModelLimit;

interface

uses
  Classes, Windows, SysUtils, DBClient, uPubFun, uParamObject, uBusinessLayerPlugin,
  uBaseInfoDef, uModelParent, uModelLimitIntf;

type
  TModelLimit = class(TModelBase, IModelLimit) //权限设置
  private
    function LoadLimitData(ALimitType: Integer; AUserID: string; ACdsLimit: TClientDataSet): Integer; //加载用户对应类型的权限
  protected

  public

  end;

implementation

uses uModelFunCom, uOtherIntf;

{ TModelLimit }

function TModelLimit.LoadLimitData(ALimitType: Integer; AUserID: string;
  ACdsLimit: TClientDataSet): Integer;
var
  aList: TParamObject;
  aSQL: string;
begin
  aList := TParamObject.Create;
  try
    aList.Add('@RUID', AUserID);
    aList.Add('@RUType', 1);
    aList.Add('@LimitType', ALimitType);
    Result := gMFCom.ExecProcBackData('pbx_Limit_QryData', aList, ACdsLimit);
  finally
    aList.Free;
  end;
end;

initialization
  gClassIntfManage.addClass(TModelLimit, IModelLimit);

end.

