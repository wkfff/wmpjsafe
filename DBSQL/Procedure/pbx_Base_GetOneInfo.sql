if object_id ('dbo.pbx_Base_GetOneInfo') is not null
    drop procedure dbo.pbx_Base_GetOneInfo
go
--  ********************************************************************************************
--  ||                                                                                        
--  ||   �������ƣ�p_hh_getonebaseinfo                                                
--  ||   ���̹��ܣ�ȡ�û�����Ϣ������¼
--  ||=========================================================================================
--  ||   ����˵����  ��������         ����            ����                              �������
--  ||            -----------------------------------------------------------------------------
--  ||            @cmode 	char(5)		:������Ϣ���Ͳ���			in
--  ||            @sztypeid 	varchar(25)	:�ڵ�typeid			in
--  ||=========================================================================================   
--  ||   ������ʷ��  ����         ����         ����          ����
--  ||            -----------------------------------------------------------------------------
--  ||              alter         mx         2015.03.26   first alter                                     
--  ********************************************************************************************

CREATE     procedure pbx_Base_GetOneInfo(
	@cmode 		varchar(5),
	@sztypeid 	varchar(50)
)
as

declare @rowcount_var int
--���ذ�
if @cmode = 'I' 
begin
	select a.*
	from tbx_PackageInfo a 
	where a.ITypeId= @sztypeid 
	select @rowcount_var = @@rowcount
end

if @rowcount_var = 1 
	return 0
else 
	return -1105             -- �ü�¼�ѱ�ɾ�������ݲ����������飡

go
