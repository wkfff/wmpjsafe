IF OBJECT_ID('dbo.pbx_Base_UpdateP') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_UpdateP
go

--  ********************************************************************************************                                                                               
--  ||   过程名称：pbx_Base_UpdateP                                                 
--  ||   过程功能：修改基本信息--商品                                              
--  ********************************************************************************************
CREATE PROCEDURE pbx_Base_UpdateP
    (
      @typeId VARCHAR(25) ,
      @Parid VARCHAR(25) ,
      @FullName VARCHAR(66) ,
      @UserCode VARCHAR(50) ,
      @Name VARCHAR(30) ,
      @PNamepy VARCHAR(60) ,
      @Model VARCHAR(60) ,
      @Standard VARCHAR(120) ,
      @Area VARCHAR(30) ,
      @CostMode INT ,
      @UsefulLifeday INT ,
      @Comment VARCHAR(250) ,
      @IsStop INT ,
      @errorValue VARCHAR(50) OUTPUT  --基本信息都需要定义这个参数
    )
AS 
    DECLARE @OldCostMode INT
    DECLARE @OldProperty INT
    DECLARE @lSonNum INT
    DECLARE @OldIsSerial INT    
    DECLARE @dbname VARCHAR(30)
    DECLARE @checkValue INT
    DECLARE @UpdateTag INT --基本信息更新标识
    SET nocount ON
	
    SELECT  @dbname = 'tbx_Ptype'

    IF EXISTS ( SELECT  [Pusercode]
                FROM    tbx_Ptype
                WHERE   PtypeId <> '00000'
                        AND [PtypeId] <> @typeid
                        AND [Pusercode] = @usercode
                        AND [deleted] <> 1 ) 
        GOTO error105


	--如果叶子已经过帐，则不能修改成本算法
	--如果已经过帐，则不能修改成本算法
    --由非加权平均法改为加权平均法，则合并批次
	--由加权平均法改非为加权平均法，则判断是否有负库存

	SET @UpdateTag = 0
    --基本信息更新标识  
    --EXEC dbo.P_hh_XW_BaseUpdateTag @BaseType = @dbname, @UpdateTag = @UpdateTag OUTPUT
      
	UPDATE dbo.tbx_Ptype
	SET [Parid]= @Parid,
		[PUsercode] = @UserCode,
		[PFullname] = @FullName,
		[PComment] = @Comment,
		[Name] = @Name,		
		[pnamepy] = @PNamepy,
		[Standard] = @Standard,
		[Model] = @Model,
		[Area] = @Area,
		[UsefulLifeday] = @UsefulLifeday, 
		[Costmode] = @CostMode,
		[IsStop] = @IsStop,
		[Updatetag] = @UpdateTag
	WHERE PTypeId = @typeId

    IF @@ROWCOUNT = 0 
        GOTO error106
        

    success:
    RETURN 0	

    error105:
    RETURN -1124                  -- '该记录的编号或全名与其它记录相同，与你的配置不符！'+char(13)+
					--          '请更改记录或在基本信息设置模块更改配置！' 
    error106:
    RETURN -1052  		-- 数据库操作失败，请稍后重试！
go
