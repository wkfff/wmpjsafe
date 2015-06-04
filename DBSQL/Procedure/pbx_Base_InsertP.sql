IF OBJECT_ID('dbo.pbx_Base_InsertP') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_InsertP
go

--  ********************************************************************************************
--  ||                                                                                        
--  ||   过程名称：pbx_Base_InsertP                                                 
--  ||   过程功能：添加基本信息--商品
--  ********************************************************************************************

CREATE      PROCEDURE pbx_Base_InsertP
    (
      @Parid VARCHAR(25) ,
      @FullName VARCHAR(66) ,
      @UserCode VARCHAR(50) ,
      @Name VARCHAR(30) ,
      @PYM VARCHAR(60) ,
      @Model VARCHAR(60) ,
      @Standard VARCHAR(120) ,
      @Area VARCHAR(30) ,
      @CostMode INT ,
      @UsefulLifeday INT ,
      @Comment VARCHAR(250),
      @IsStop INT ,
      @RltTypeID VARCHAR(25) OUTPUT ,
      @errorValue VARCHAR(50) OUTPUT ,
      @uErueMode INT = 0 --数据插入标识 0 为程序插入  1为excel导入
    )
AS 
    DECLARE @nReturntype INT
    DECLARE @typeid_1 VARCHAR(25)
    DECLARE @nSonnum INT
    DECLARE @RepPtypeid VARCHAR(25)
    DECLARE @nSoncount INT
    DECLARE @ParRec INT
    DECLARE @leveal INT
    DECLARE @deleted INT
    DECLARE @dbname VARCHAR(30)
    DECLARE @checkValue INT
    DECLARE @UpdateTag INT --基本信息更新标识
    DECLARE @tmpEtypeid VARCHAR(25)
    DECLARE @ptypetype INT 
    SET nocount ON

    SELECT  @dbname = 'tbx_Ptype'

    EXEC @nReturntype = pbx_BasicCreateID @ParId, @dbname, @typeid_1 OUT, @nSonnum OUT, @nSoncount OUT, @ParRec OUT

    IF @nReturntype = -101 
        BEGIN
            SET @errorValue = '数据库操作失败，请稍后重试！'
            GOTO error101
        END
    IF @nReturntype = -102 
        BEGIN
            SET @errorValue = '此记录已经被使用，不能再分类！'
            GOTO error102
        END
    IF @nReturntype = -103 
        BEGIN
            SET @errorValue = '父亲ID号不存在！'
            GOTO error103
        END
    IF @nReturntype = -104 
        BEGIN
            SET @errorValue = '系统行不允许修改！'
            GOTO error104
        END
    IF (@uErueMode = 0 ) OR ( @uErueMode = 1 AND @UserCode <> '') --程序新增 或者 excel导入并且商品编号不为空
        BEGIN
            IF EXISTS ( SELECT  [ptypeid]
                        FROM    tbx_Ptype
                        WHERE   ptypeId <> '00000'
                                AND ( [ptypeId] = @typeid_1
                                      OR ( [pusercode] = @usercode )
                                    )
                                AND [deleted] <> 1 ) 
                BEGIN
                    SET @errorValue = '该记录的编号或与其它记录相同，与您的配置不符！'
                    GOTO error105
                END        	
        END
        
    IF @IsStop = 1 
        IF EXISTS ( SELECT  1
                    FROM    tbx_Ptype
                    WHERE   [ptypeId] = @typeid_1
                            AND psonnum > 0 ) 
            BEGIN
                SET @errorValue = '商品已经存在并且停用!'
                GOTO error110
            END
   
    BEGIN TRAN insertproc
    SELECT  @leveal = [leveal]
    FROM    tbx_Ptype
    WHERE   [ptypeid] = @Parid
    SELECT  @leveal = @leveal + 1

    --获得行序号的最大值
    DECLARE @RowIndex INT
    SELECT  @RowIndex = ISNULL(MAX(RowIndex) + 1, 0)
    FROM    tbx_Ptype
    WHERE   [Parid] = @Parid AND deleted = 0
            
    --基本信息更新标识  
    --EXEC dbo.P_hh_XW_BaseUpdateTag @BaseType = @dbname, UpdateTag = @UpdateTag OUTPUT
    SELECT @UpdateTag = 0

	INSERT dbo.tbx_Ptype( PTypeId ,Parid ,PSonnum ,Soncount ,Leveal ,PUsercode ,PFullname ,PComment ,[Standard] ,[Model] ,Area ,Costmode ,IsStop ,Parrec ,RowIndex ,Deleted ,Updatetag)
	VALUES  ( @typeid_1 ,@ParId ,0 ,0 ,@leveal ,@UserCode ,@FullName ,@Comment ,@Standard ,@Model ,@Area ,@CostMode ,@Isstop ,@Parrec ,@RowIndex ,0 ,@UpdateTag)
   
    SET @RltTypeID = @typeId_1
    IF @@ROWCOUNT = 0 
        BEGIN
            SET @errorValue = '数据库操作失败，请稍后重试！'
            GOTO error106
        END

    UPDATE  [tbx_Ptype]
    SET     [psonnum] = @nSonnum + 1 ,
            [soncount] = @nSoncount + 1 ,
            [updatetag] = @UpdateTag
    WHERE   [ptypeid] = @Parid

    IF @@ROWCOUNT = 0 
        BEGIN
            SET @errorValue = '数据库操作失败，请稍后重试！'
            GOTO error106
        END
	 
        --增加基本信息授权
        --IF EXISTS ( SELECT  1
        --            FROM    syscon
        --            WHERE   [order] = 15
        --                    AND [stats] = 1 ) 
        --    INSERT  INTO t_pright
        --            ( etypeid ,
        --              RightID ,
        --              RState
        --            )
        --            SELECT  a.etypeid ,
        --                    @typeId_1 ,
        --                    2
        --            FROM    ( SELECT    e.Etypeid
        --                      FROM      loginuser l ,
        --                                employee e
        --                      WHERE     l.etypeid = e.etypeid
        --                                AND e.deleted = 0
        --                                AND l.etypeid <> '00000'
        --                    ) a ,
        --                    ( SELECT    etypeid
        --                      FROM      t_pright
        --                      WHERE     ( RState = 2
        --                                  AND RightID = @Parid
        --                                  AND RightID <> '00000'
        --                                )
        --                    ) b
        --            WHERE   a.etypeid = b.etypeid
	

    COMMIT TRAN insertproc
    GOTO success

	success:
		RETURN 0

	error101:
		RETURN -1052                  -- 数据库操作失败，请稍后重试！

	error102:
		RETURN -1133                  -- 此记录已经过账，不能再分类！

	error103:
		RETURN -1134                  -- 父亲ID号不存在！

	error104:
		RETURN -1135                  -- 系统行不允许修改！

	error105:
		RETURN -1124                  -- '该记录的编号或全名与其它记录相同，与你的配置不符！'+char(13)+
						--          '请更改记录或在基本信息设置模块更改配置！' 
	error106: 
		ROLLBACK TRAN insertproc 
		RETURN -1052  			-- 数据库操作失败，请稍后重试！
	ERROR108:
		RETURN -1846			-- 此商品在订单中已使用，不允许分类！
	ERROR109:
		RETURN -1847    		-- 此商品在生产模板中已使用，不允许分类！
	ERROR110:
		RETURN -110
	error111:
		RETURN -111             --父亲ID商品为服务品
	error112:
		RETURN -1125
go
