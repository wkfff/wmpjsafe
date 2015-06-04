IF OBJECT_ID('dbo.pbx_Base_GetOneInfo') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_GetOneInfo
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

CREATE     PROCEDURE pbx_Base_GetOneInfo
    (
      @cmode VARCHAR(5) ,
      @sztypeid VARCHAR(50)
    )
AS 
    DECLARE @rowcount_var INT
--���ذ�
    IF @cmode = 'I' 
        BEGIN
            SELECT  a.*
            FROM    tbx_PackageInfo a
            WHERE   a.ITypeId = @sztypeid 
            SELECT  @rowcount_var = @@rowcount
        END
    ELSE 
        IF @cmode = 'P' 
            BEGIN
                SELECT  a.*
                FROM    dbo.tbx_Ptype a
                WHERE   a.PTypeId = @sztypeid 
                SELECT  @rowcount_var = @@rowcount
            END

    IF @rowcount_var = 1 
        RETURN 0
    ELSE 
        RETURN -1105             -- �ü�¼�ѱ�ɾ�������ݲ����������飡

go
