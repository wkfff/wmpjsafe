IF OBJECT_ID('dbo.pbx_Base_InsertP') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Base_InsertP
go

--  ********************************************************************************************
--  ||                                                                                        
--  ||   �������ƣ�pbx_Base_InsertP                                                 
--  ||   ���̹��ܣ���ӻ�����Ϣ--��Ʒ
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
      @uErueMode INT = 0 --���ݲ����ʶ 0 Ϊ�������  1Ϊexcel����
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
    DECLARE @UpdateTag INT --������Ϣ���±�ʶ
    DECLARE @tmpEtypeid VARCHAR(25)
    DECLARE @ptypetype INT 
    SET nocount ON

    SELECT  @dbname = 'tbx_Ptype'

    EXEC @nReturntype = pbx_BasicCreateID @ParId, @dbname, @typeid_1 OUT, @nSonnum OUT, @nSoncount OUT, @ParRec OUT

    IF @nReturntype = -101 
        BEGIN
            SET @errorValue = '���ݿ����ʧ�ܣ����Ժ����ԣ�'
            GOTO error101
        END
    IF @nReturntype = -102 
        BEGIN
            SET @errorValue = '�˼�¼�Ѿ���ʹ�ã������ٷ��࣡'
            GOTO error102
        END
    IF @nReturntype = -103 
        BEGIN
            SET @errorValue = '����ID�Ų����ڣ�'
            GOTO error103
        END
    IF @nReturntype = -104 
        BEGIN
            SET @errorValue = 'ϵͳ�в������޸ģ�'
            GOTO error104
        END
    IF (@uErueMode = 0 ) OR ( @uErueMode = 1 AND @UserCode <> '') --�������� ���� excel���벢����Ʒ��Ų�Ϊ��
        BEGIN
            IF EXISTS ( SELECT  [ptypeid]
                        FROM    tbx_Ptype
                        WHERE   ptypeId <> '00000'
                                AND ( [ptypeId] = @typeid_1
                                      OR ( [pusercode] = @usercode )
                                    )
                                AND [deleted] <> 1 ) 
                BEGIN
                    SET @errorValue = '�ü�¼�ı�Ż���������¼��ͬ�����������ò�����'
                    GOTO error105
                END        	
        END
        
    IF @IsStop = 1 
        IF EXISTS ( SELECT  1
                    FROM    tbx_Ptype
                    WHERE   [ptypeId] = @typeid_1
                            AND psonnum > 0 ) 
            BEGIN
                SET @errorValue = '��Ʒ�Ѿ����ڲ���ͣ��!'
                GOTO error110
            END
   
    BEGIN TRAN insertproc
    SELECT  @leveal = [leveal]
    FROM    tbx_Ptype
    WHERE   [ptypeid] = @Parid
    SELECT  @leveal = @leveal + 1

    --�������ŵ����ֵ
    DECLARE @RowIndex INT
    SELECT  @RowIndex = ISNULL(MAX(RowIndex) + 1, 0)
    FROM    tbx_Ptype
    WHERE   [Parid] = @Parid AND deleted = 0
            
    --������Ϣ���±�ʶ  
    --EXEC dbo.P_hh_XW_BaseUpdateTag @BaseType = @dbname, UpdateTag = @UpdateTag OUTPUT
    SELECT @UpdateTag = 0

	INSERT dbo.tbx_Ptype( PTypeId ,Parid ,PSonnum ,Soncount ,Leveal ,PUsercode ,PFullname ,PComment ,[Standard] ,[Model] ,Area ,Costmode ,IsStop ,Parrec ,RowIndex ,Deleted ,Updatetag)
	VALUES  ( @typeid_1 ,@ParId ,0 ,0 ,@leveal ,@UserCode ,@FullName ,@Comment ,@Standard ,@Model ,@Area ,@CostMode ,@Isstop ,@Parrec ,@RowIndex ,0 ,@UpdateTag)
   
    SET @RltTypeID = @typeId_1
    IF @@ROWCOUNT = 0 
        BEGIN
            SET @errorValue = '���ݿ����ʧ�ܣ����Ժ����ԣ�'
            GOTO error106
        END

    UPDATE  [tbx_Ptype]
    SET     [psonnum] = @nSonnum + 1 ,
            [soncount] = @nSoncount + 1 ,
            [updatetag] = @UpdateTag
    WHERE   [ptypeid] = @Parid

    IF @@ROWCOUNT = 0 
        BEGIN
            SET @errorValue = '���ݿ����ʧ�ܣ����Ժ����ԣ�'
            GOTO error106
        END
	 
        --���ӻ�����Ϣ��Ȩ
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
		RETURN -1052                  -- ���ݿ����ʧ�ܣ����Ժ����ԣ�

	error102:
		RETURN -1133                  -- �˼�¼�Ѿ����ˣ������ٷ��࣡

	error103:
		RETURN -1134                  -- ����ID�Ų����ڣ�

	error104:
		RETURN -1135                  -- ϵͳ�в������޸ģ�

	error105:
		RETURN -1124                  -- '�ü�¼�ı�Ż�ȫ����������¼��ͬ����������ò�����'+char(13)+
						--          '����ļ�¼���ڻ�����Ϣ����ģ��������ã�' 
	error106: 
		ROLLBACK TRAN insertproc 
		RETURN -1052  			-- ���ݿ����ʧ�ܣ����Ժ����ԣ�
	ERROR108:
		RETURN -1846			-- ����Ʒ�ڶ�������ʹ�ã���������࣡
	ERROR109:
		RETURN -1847    		-- ����Ʒ������ģ������ʹ�ã���������࣡
	ERROR110:
		RETURN -110
	error111:
		RETURN -111             --����ID��ƷΪ����Ʒ
	error112:
		RETURN -1125
go
