IF OBJECT_ID('dbo.pbx_Base_UpdateP') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_UpdateP
go

--  ********************************************************************************************                                                                               
--  ||   �������ƣ�pbx_Base_UpdateP                                                 
--  ||   ���̹��ܣ��޸Ļ�����Ϣ--��Ʒ                                              
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
      @errorValue VARCHAR(50) OUTPUT  --������Ϣ����Ҫ�����������
    )
AS 
    DECLARE @OldCostMode INT
    DECLARE @OldProperty INT
    DECLARE @lSonNum INT
    DECLARE @OldIsSerial INT    
    DECLARE @dbname VARCHAR(30)
    DECLARE @checkValue INT
    DECLARE @UpdateTag INT --������Ϣ���±�ʶ
    SET nocount ON
	
    SELECT  @dbname = 'tbx_Ptype'

    IF EXISTS ( SELECT  [Pusercode]
                FROM    tbx_Ptype
                WHERE   PtypeId <> '00000'
                        AND [PtypeId] <> @typeid
                        AND [Pusercode] = @usercode
                        AND [deleted] <> 1 ) 
        GOTO error105


	--���Ҷ���Ѿ����ʣ������޸ĳɱ��㷨
	--����Ѿ����ʣ������޸ĳɱ��㷨
    --�ɷǼ�Ȩƽ������Ϊ��Ȩƽ��������ϲ�����
	--�ɼ�Ȩƽ�����ķ�Ϊ��Ȩƽ���������ж��Ƿ��и����

	SET @UpdateTag = 0
    --������Ϣ���±�ʶ  
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
    RETURN -1124                  -- '�ü�¼�ı�Ż�ȫ����������¼��ͬ����������ò�����'+char(13)+
					--          '����ļ�¼���ڻ�����Ϣ����ģ��������ã�' 
    error106:
    RETURN -1052  		-- ���ݿ����ʧ�ܣ����Ժ����ԣ�
go
