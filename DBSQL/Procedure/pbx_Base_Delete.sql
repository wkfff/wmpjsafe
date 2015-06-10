IF OBJECT_ID('dbo.pbx_Base_Delete') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_Delete
go

--  ********************************************************************************************
--  ||                                                                                        
--  ||   过程名称：pbx_Base_Delete                                                 
--  ||   过程功能：删除基本信息
--  ||=========================================================================================
--  ||   参数说明：  参数名称         类型            意义                     输入输出
--  ||            -----------------------------------------------------------------------------
--  ||  	@TypeId	 	varchar(25),                    --ID
--  ||  	@DbName		varchar(50)						--表名                                        
--  ********************************************************************************************

CREATE  PROCEDURE pbx_Base_Delete
    (
      @cTypeid VARCHAR(50) ,
      @cMode VARCHAR(50)
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
    DECLARE @UpdateTag INT --基本信息更新标识
    DECLARE @tmpEmp VARCHAR(50) ,
        @tmpsontypeid VARCHAR(50) ,
        @tmpRstate INT

 -- Select @szName = 'iniover',@UpdateTag=0
 --	EXEC P_HH_GETSYSVALUE @szName, @Iniover output
 
    IF @cMode = 'P'  GOTO DelPtype
	
--	检查PTYPE是否能够删除
    DelPtype:
	-- 删除库存数量和金额都为0的商品在期初库存及库存表中的记录
    --DELETE FROM IniGoodsStocks WHERE Qty = 0 AND Total = 0 AND pgholInqty = 0
	--DELETE FROM GoodsStocks    WHERE Qty = 0 AND Total = 0 AND pgholInqty = 0

    IF EXISTS ( SELECT  1 FROM tbx_Ptype WHERE   [PTYPEID] = @cTypeid AND deleted = 1 ) GOTO BASEDEL
    IF EXISTS ( SELECT  1 FROM tbx_Ptype WHERE   [PTYPEID] = @cTypeid AND [PSONNUM] <> 0 ) GOTO SONERROR
	     
	SELECT @UpdateTag = 0 
    --更新基本信息标识
    --EXEC dbo.P_hh_XW_BaseUpdateTag @BaseType = @dbname, @UpdateTag = @UpdateTag OUTPUT 
    
    UPDATE  tbx_Ptype
    SET     [DELETED] = 1 ,
            [updatetag] = @UpdateTag
    WHERE   [PTYPEID] = @cTypeid 
    
    IF @@ROWCOUNT = 0 
        RETURN -1 
    ELSE 
        BEGIN 
            SELECT  @PARID = [PARID] FROM tbx_Ptype WHERE   [PTYPEID] = @cTypeid
            SELECT  @SONNUM = [PSONNUM] FROM tbx_Ptype WHERE   [PTYPEID] = @PARID
            
            UPDATE  tbx_Ptype
            SET     [PSONNUM] = @SONNUM - 1 ,
                    [updatetag] = @UpdateTag
            WHERE   [PTYPEID] = @PARID
                
            --EXEC xw_DeletePtype @TYPEID             --删除多单位信息
        
			--处理基本信息授权          
		
            RETURN 0
        END
	
	BASEDEL:
		RETURN -100
	SONERROR:
		RETURN -101 -- 此记录为一个结点，不能删除
go
