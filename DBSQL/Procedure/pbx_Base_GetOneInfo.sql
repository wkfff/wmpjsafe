if object_id ('dbo.pbx_Base_GetOneInfo') is not null
    drop procedure dbo.pbx_Base_GetOneInfo
go
--  ********************************************************************************************
--  ||                                                                                        
--  ||   过程名称：p_hh_getonebaseinfo                                                
--  ||   过程功能：取得基本信息单条记录
--  ||=========================================================================================
--  ||   参数说明：  参数名称         类型            意义                              输入输出
--  ||            -----------------------------------------------------------------------------
--  ||            @cmode 	char(5)		:基本信息类型参数			in
--  ||            @sztypeid 	varchar(25)	:节点typeid			in
--  ||=========================================================================================   
--  ||   过程历史：  操作         作者         日期          描述
--  ||            -----------------------------------------------------------------------------
--  ||              alter         mx         2015.03.26   first alter                                     
--  ********************************************************************************************

CREATE     procedure pbx_Base_GetOneInfo(
	@cmode 		varchar(5),
	@sztypeid 	varchar(50)
)
as

declare @rowcount_var int
--加载包
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
	return -1105             -- 该记录已被删除或数据不完整，请检查！

go
