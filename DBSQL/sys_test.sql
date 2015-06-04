IF OBJECT_ID('dbo.sys_test') IS NOT NULL 
    DROP PROCEDURE dbo.sys_test
go

CREATE	PROCEDURE sys_test
    (
      @parid INT ,
      @fullname VARCHAR(50) ,
      @usercode VARCHAR(50) ,
      @rlttypeid VARCHAR(25) OUTPUT ,
      @errorValue INT OUTPUT
    )
AS 
    DECLARE @nreturntype INT
    DECLARE @typeid_1 VARCHAR(25)
    DECLARE @nsonnum INT
    DECLARE @nsoncount INT
    DECLARE @parrec INT
    DECLARE @leveal INT
    DECLARE @deleted INT
	--INSERT INTO dbo.FrmMoudleNoParams ( MoudleNo ,FMPKey ,DefaultCaption ,ShowCaption ,ClassName ,ParamList , DefaultParams )
	--VALUES  (@parid, @fullname, @usercode , '系统加载模块' , 'TfrmLoadItemSet' , '' , '' )

	SELECT * FROM FrmMoudleNoParams
    SELECT @rlttypeid = 'sad'
	SELECT @errorValue = 12
    GOTO success
    success:
    RETURN 0

go