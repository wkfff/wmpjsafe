{***************************
Ȩ����صĽӿ�
mx 2016-08-22
****************************}

unit uModelLimitIntf;

interface

uses DBClient, Classes, uParamObject, uBaseInfoDef, uModelBaseIntf, uOtherDefine;

const
  //Ȩ������
  Limit_Un = 0; //δ����
  Limit_Base = 1; //������Ϣ
  Limit_Bill = 2; //����
  Limit_Report = 3; //����
  Limit_Data = 4; //����
  Limit_Other = 5; //����

type
  IModelLimit = interface(IModelBase)
    ['{32E62488-975F-461D-AE3F-160AE3962F27}']
    function LoadLimitData(ALimitType: Integer; AUserID: string; ACdsLimit: TClientDataSet): Integer; //�����û���Ӧ���͵�Ȩ��
  end;

implementation

end.

