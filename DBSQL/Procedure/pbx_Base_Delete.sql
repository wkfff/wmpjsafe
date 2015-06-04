IF OBJECT_ID('dbo.pbx_Base_Delete') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_Delete
go

--  ********************************************************************************************
--  ||                                                                                        
--  ||   �������ƣ�pbx_Base_Delete                                                 
--  ||   ���̹��ܣ�ɾ��������Ϣ
--  ||=========================================================================================
--  ||   ����˵����  ��������         ����            ����                     �������
--  ||            -----------------------------------------------------------------------------
--  ||  	@TypeId	 	varchar(25),                    --ID
--  ||  	@DbName		varchar(50)						--����                                        
--  ********************************************************************************************

CREATE  PROCEDURE pbx_Base_Delete
    (
      @typeid VARCHAR(50) ,
      @dbname VARCHAR(50)
    )
AS 
    DECLARE @SQL VARCHAR(500)
    DECLARE @GOODS_ID VARCHAR(25)
    DECLARE @dTempQty NUMERIC(22, 10)
    DECLARE @dTempTotal NUMERIC(22, 10)
    DECLARE @sonnum NUMERIC(10)
    DECLARE @parid VARCHAR(50)
    DECLARE @szName VARCHAR(50)
    DECLARE @Iniover VARCHAR(50) 
    DECLARE @szTypeIDTemp VARCHAR(25)
    DECLARE @errorNo INT
    DECLARE @UpdateTag INT --������Ϣ���±�ʶ
    DECLARE @tmpEmp VARCHAR(50) ,
        @tmpsontypeid VARCHAR(50) ,
        @tmpRstate INT

 -- Select @szName = 'iniover',@UpdateTag=0
 --	EXEC P_HH_GETSYSVALUE @szName, @Iniover output
 
    IF @dbname = 'tbx_Ptype'  GOTO DelPtype
	
--	���PTYPE�Ƿ��ܹ�ɾ��
    DelPtype:
	-- ɾ����������ͽ�Ϊ0����Ʒ���ڳ���漰�����еļ�¼
    --DELETE FROM IniGoodsStocks WHERE Qty = 0 AND Total = 0 AND pgholInqty = 0
	--DELETE FROM GoodsStocks    WHERE Qty = 0 AND Total = 0 AND pgholInqty = 0

    IF EXISTS ( SELECT  1 FROM tbx_Ptype WHERE   [PTYPEID] = @TYPEID AND deleted = 1 ) GOTO BASEDEL
    IF EXISTS ( SELECT  1 FROM tbx_Ptype WHERE   [PTYPEID] = @TYPEID AND [PSONNUM] <> 0 ) GOTO SONERROR
	     
	SELECT @UpdateTag = 0 
    --���»�����Ϣ��ʶ
    --EXEC dbo.P_hh_XW_BaseUpdateTag @BaseType = @dbname, @UpdateTag = @UpdateTag OUTPUT 
    
    UPDATE  tbx_Ptype
    SET     [DELETED] = 1 ,
            [updatetag] = @UpdateTag
    WHERE   [PTYPEID] = @TYPEID 
    
    IF @@ROWCOUNT = 0 
        RETURN -1 
    ELSE 
        BEGIN 
            SELECT  @PARID = [PARID] FROM tbx_Ptype WHERE   [PTYPEID] = @TYPEID
            SELECT  @SONNUM = [PSONNUM] FROM tbx_Ptype WHERE   [PTYPEID] = @PARID
            
            UPDATE  tbx_Ptype
            SET     [PSONNUM] = @SONNUM - 1 ,
                    [updatetag] = @UpdateTag
            WHERE   [PTYPEID] = @PARID
                
            --EXEC xw_DeletePtype @TYPEID             --ɾ���൥λ��Ϣ
        
			--���������Ϣ��Ȩ          
		
            RETURN 0
        END
	
	BASEDEL:
		RETURN -100
	SONERROR:
		RETURN -101 -- �˼�¼Ϊһ����㣬����ɾ��
go
