unit uModelLimit;

interface

uses
  Classes, Windows, SysUtils, DBClient, uPubFun, uParamObject, uBusinessLayerPlugin,
  uBaseInfoDef, uModelParent, uModelLimitIntf;

type
  TModelLimit = class(TModelBase, IModelLimit) //Ȩ������
  private
    function LoadLimitData(ALimitType: Integer; AUserID: string; ACdsLimit: TClientDataSet): Integer; //�����û���Ӧ���͵�Ȩ��
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

