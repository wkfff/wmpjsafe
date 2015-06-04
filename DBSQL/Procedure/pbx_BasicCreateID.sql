IF OBJECT_ID('dbo.pbx_BasicCreateID') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_BasicCreateID
go

--  ********************************************************************************************
--  ||                                                                                        
--  ||   pbx_BasicCreateID                                                 
--  ||   ���̹��ܣ���ӻ�����Ϣ--����id��
--  ||=========================================================================================
--  ||   ����˵����  ��������         ����            ����                     �������
--  ||            -----------------------------------------------------------------------------
--  ||  	@parid		varchar(25),			--��id
--  ||  	@dbname 	varchar(30),			--����
--  ||  	@createdid	varchar(25) output,		--typeid
--  ||  	@nson		int output,			--sonnum
--  ||  	@ncount 	int output,			--soncount
--  ||  	@nparrec	int output			--parrec
--  ||=========================================================================================                                         
--  ********************************************************************************************

CREATE         PROCEDURE pbx_BasicCreateID
    (
      @parid VARCHAR(50) ,			--��id
      @dbname VARCHAR(30) ,			--����
      @createdid VARCHAR(50) OUTPUT ,		--typeid
      @nson INT OUTPUT ,			--sonnum
      @ncount INT OUTPUT ,			--soncount
      @nparrec INT OUTPUT			--parrec
    )
AS 
    DECLARE @execsql VARCHAR(500)
    DECLARE @sztypeid VARCHAR(50)
    DECLARE @root_id VARCHAR(25)
    DECLARE @bank_id VARCHAR(25)
    DECLARE @fixed_id VARCHAR(25)
    DECLARE @expense_id VARCHAR(25)
    DECLARE @goods_income_id VARCHAR(25)
    DECLARE @par VARCHAR(25)
    DECLARE @sonnum INT
    DECLARE @soncount INT
    DECLARE @temprec INT
    DECLARE @iniover VARCHAR(10)
    DECLARE @tempsql VARCHAR(400) 
    DECLARE @flag INT
    SELECT  @root_id = '00000'

--��� @parid�ǲ��Ǹ���

    SET @flag = 0
    
    IF @dbname = 'tbx_Ptype' SELECT  @flag = CASE WHEN psonnum > 0 THEN 1 ELSE 0 END FROM tbx_Ptype WHERE   ptypeid = @parid
    
    IF @flag = 1 GOTO nocheckpard

--exec getsysvalue 'iniover', @iniover output �Ƿ���

    IF @dbname = 'tbx_Ptype' 
    BEGIN
		PRINT '���ݼ��'
--�ж���Ʒ�Ƿ������ȡID������
--if exists(select 1 from itemSaleDetail where [ptypeid]=@parid)  goto error102
    END

    nocheckpard:
--	����id��
    SET nocount ON
    IF @dbname = 'tbx_Ptype' DECLARE checkid_cursor CURSOR FOR SELECT  ptypeid ,psonnum ,parid ,soncount ,prec FROM tbx_Ptype WHERE ptypeid = @parid OPEN checkid_cursor

    FETCH NEXT FROM checkid_cursor INTO @sztypeid, @sonnum, @par, @soncount, @temprec

    SELECT  @nson = @sonnum
    SELECT  @ncount = @soncount
    SELECT  @nparrec = @temprec
	
    IF ( @@fetch_status = -2 )
        OR ( @@fetch_status = -1 ) 
        BEGIN
            CLOSE checkid_cursor
            DEALLOCATE checkid_cursor
            GOTO error103
        END
    ELSE 
        BEGIN 
            DECLARE @tempid VARCHAR(5) , @nreturn INT
            SELECT  @soncount = @soncount + 1
            EXEC @nreturn= pbx_IntToStr @soncount, @tempid OUT
            IF @nreturn = -1 
                BEGIN
                    CLOSE checkid_cursor
                    DEALLOCATE checkid_cursor
                    GOTO error101
                END 
            ELSE 
                BEGIN
                    IF @sztypeid = '00000' 
                        SELECT  @createdid = @tempid
                    ELSE 
                        BEGIN
                            SELECT  @createdid = RTRIM(@sztypeid) + @tempid
                        END
                END
        END

    CLOSE checkid_cursor
    DEALLOCATE checkid_cursor
    GOTO succee

    succee:
    RETURN 0

    error101:  --���ݿ����ʧ�ܣ�
    RETURN -101

    error102:  --�ڳ���Ŀ�н����˺��Ŀ�н���ϸ�н�����������Ӷ���
    RETURN -102

    error103:  --��id�Ų����ڣ�
    RETURN -103

    error104:  --ϵͳ�У��ڲ���¼�����������
    RETURN -104

go
