{***************************
权限相关的接口
mx 2016-08-22
****************************}

unit uModelLimitIntf;

interface

uses DBClient, Classes, uParamObject, uBaseInfoDef, uModelBaseIntf, uOtherDefine;

const
  //权限类型
  Limit_Un = 0; //未配置
  Limit_Base = 1; //基本信息
  Limit_Bill = 2; //单据
  Limit_Report = 3; //报表
  Limit_Data = 4; //数据
  Limit_Other = 5; //其它

type
  IModelLimit = interface(IModelBase)
    ['{32E62488-975F-461D-AE3F-160AE3962F27}']
    function LoadLimitData(ALimitType: Integer; AUserID: string; ACdsLimit: TClientDataSet): Integer; //加载用户对应类型的权限
  end;

implementation

end.

