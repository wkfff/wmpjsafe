-----------------------清空数据
--DROP TABLE tbx_PackageInfo
--GO
--DROP TABLE tbx_FrmMoudleNoParams
--GO 
--DROP TABLE tbx_DefSQLList
--GO 
------------------------

--记录加载包的相关信息,基本类型对应btItype
IF OBJECT_ID('dbo.tbx_PackageInfo') IS NULL 
    CREATE TABLE [dbo].[tbx_PackageInfo]
        (
          [ITypeId] VARCHAR(25) ,
          [Parid] VARCHAR(25) NOT NULL DEFAULT '' ,
          [ISonnum] int NOT NULL DEFAULT 0 ,
          [Soncount] int NOT NULL DEFAULT 0 , 
          [Leveal] int NOT NULL DEFAULT 1 ,
          [IUsercode] VARCHAR(20) NOT NULL DEFAULT '' ,
          [IFullname] VARCHAR(20) NOT NULL DEFAULT '' ,
          [INamepy] VARCHAR(20) NOT NULL DEFAULT '' ,
          [IComment] VARCHAR(255) NOT NULL DEFAULT '' ,
          [ISystem] INT NOT NULL DEFAULT 0 ,
          [IRec] INT NOT NULL IDENTITY(1, 1),
          [RowIndex] INT NOT NULL DEFAULT 0 ,
          [Deleted] bit NOT NULL DEFAULT 0,
          [Updatetag] INT NOT NULL DEFAULT 0  
          CONSTRAINT PK_tbx_PackageInfo PRIMARY KEY (ITypeId)
        )
    
GO

--记录MoudleNo对应的窗体和默认参数
IF OBJECT_ID('dbo.tbx_FrmMoudleNoParams') IS NULL 
    CREATE TABLE [dbo].[tbx_FrmMoudleNoParams]
        (
          [FMPID] [int] IDENTITY(1, 1) ,
          [MoudleNo] INT NOT NULL DEFAULT 0 ,
          [FMPKey] VARCHAR(50) NOT NULL DEFAULT '' ,
          [DefaultCaption] VARCHAR(50) NOT NULL ,
          [ShowCaption] VARCHAR(50) NOT NULL ,
          [ClassName] VARCHAR(50) NOT NULL ,
          [ParamList] VARCHAR(200) NOT NULL DEFAULT '' ,
          [DefaultParams] VARCHAR(200) NOT NULL DEFAULT '' 
          CONSTRAINT PK_tbx_FrmMoudleNoParams PRIMARY KEY ( FMPID )
        )
        
GO

--记录定义的SQL语句
IF OBJECT_ID('dbo.tbx_DefSQLList') IS NULL 
    CREATE TABLE [dbo].[tbx_DefSQLList]
        (
          [DSLID] [int] IDENTITY(1, 1) ,
          [SQLNo] INT NOT NULL DEFAULT 0 ,
          [DSLKey] VARCHAR(50) NOT NULL DEFAULT '' ,
          [SQLStr] VARCHAR(5000) NOT NULL DEFAULT '' ,
          [DSLRemark] VARCHAR(200) NOT NULL DEFAULT '' , 
          [DSLCreateTime] DATETIME NOT NULL DEFAULT 0 ,
          [DSLUpdateTime] DATETIME NOT NULL DEFAULT 0 
          CONSTRAINT PK_tbx_DefSQLList PRIMARY KEY ( DSLID )
        )
        
GO

--商品信息
IF OBJECT_ID('dbo.tbx_Ptype') IS NULL 
BEGIN
	CREATE TABLE tbx_Ptype
	(
		[PTypeId] VARCHAR(25) ,
		[Parid] VARCHAR(25) NOT NULL DEFAULT '' ,
		[PSonnum] int NOT NULL DEFAULT 0 ,
		[Soncount] int NOT NULL DEFAULT 0 , 
		[Leveal] int NOT NULL DEFAULT 1 ,
		[PUsercode] VARCHAR(20) NOT NULL DEFAULT '' ,
		[PFullname] VARCHAR(20) NOT NULL DEFAULT '' ,
		[PComment] VARCHAR(255) NOT NULL DEFAULT '' ,

		[pnamepy] [varchar] (66) NOT NULL DEFAULT (''),
		[Standard] [varchar] (120) NOT NULL DEFAULT (''),
		[Model] [varchar] (60) NOT NULL DEFAULT (''),
		[Area] [varchar] (30) NOT NULL DEFAULT (''),
		[Costmode] [int] NOT NULL DEFAULT (0),
		[IsStop] [int] NOT NULL DEFAULT (0),

		[PRec] INT NOT NULL IDENTITY(1, 1),
		[Parrec] INT NOT NULL DEFAULT 0,
		[RowIndex] INT NOT NULL DEFAULT 0 ,
		[Deleted] bit NOT NULL DEFAULT 0,
		[Updatetag] INT NOT NULL DEFAULT 0 

		CONSTRAINT PK_tbx_Ptype PRIMARY KEY ([PTypeId])
	)
	INSERT dbo.tbx_Ptype( PTypeId ,Parid ,PSonnum ,Soncount ,Leveal ,PUsercode ,PFullname ,PComment ,[Standard] ,Model ,Area ,Costmode ,IsStop ,Parrec ,RowIndex ,Deleted ,Updatetag)
	VALUES  ( '00000' ,'0' ,0 ,0 ,0 ,'000000000' ,'全部商品' ,'' ,'' ,'' ,'' ,0 ,0 ,0 ,0 ,0 ,0)
END
	
DELETE dbo.tbx_PackageInfo
GO 
---初始化加载项
INSERT dbo.tbx_PackageInfo ( ITypeId ,Parid ,ISonnum ,Soncount ,Leveal ,IUsercode ,IFullname ,INamepy ,IComment ,ISystem ,RowIndex)
VALUES  ( '00000' ,'' ,7 ,7 ,0 ,'全部加载项' ,'全部加载项' ,'全部加载项' ,'全部加载项' ,1, 0)
INSERT dbo.tbx_PackageInfo ( ITypeId ,Parid ,ISonnum ,Soncount ,Leveal ,IUsercode ,IFullname ,INamepy ,IComment ,ISystem ,RowIndex)
VALUES  ( '00001' ,'00000' ,0 ,0 ,1 ,'Other.bpl' ,'Other.bpl' ,'Other.bpl' ,'其它操作' ,1, 0)
INSERT dbo.tbx_PackageInfo ( ITypeId ,Parid ,ISonnum ,Soncount ,Leveal ,IUsercode ,IFullname ,INamepy ,IComment ,ISystem ,RowIndex)
VALUES  ( '00002' ,'00000' ,0 ,0 ,1 ,'BusinessIntf.bpl' ,'BusinessIntf.bpl' ,'BusinessIntf.bpl' ,'业务接口' ,1, 1)
INSERT dbo.tbx_PackageInfo ( ITypeId ,Parid ,ISonnum ,Soncount ,Leveal ,IUsercode ,IFullname ,INamepy ,IComment ,ISystem ,RowIndex)
VALUES  ( '00003' ,'00000' ,0 ,0 ,1 ,'BusinessLayer.bpl' ,'BusinessLayer.bpl' ,'BusinessLayer.bpl' ,'业务层' ,1, 2)
INSERT dbo.tbx_PackageInfo ( ITypeId ,Parid ,ISonnum ,Soncount ,Leveal ,IUsercode ,IFullname ,INamepy ,IComment ,ISystem ,RowIndex)
VALUES  ( '00004' ,'00000' ,0 ,0 ,1 ,'BaseForm.bpl' ,'BaseForm.bpl' ,'BaseForm.bpl' ,'父类窗体' ,1, 3)
INSERT dbo.tbx_PackageInfo ( ITypeId ,Parid ,ISonnum ,Soncount ,Leveal ,IUsercode ,IFullname ,INamepy ,IComment ,ISystem ,RowIndex)
VALUES  ( '00005' ,'00000' ,0 ,0 ,1 ,'SysConfig.bpl' ,'SysConfig.bpl' ,'SysConfig.bpl' ,'系统设置' ,1, 4)
INSERT dbo.tbx_PackageInfo ( ITypeId ,Parid ,ISonnum ,Soncount ,Leveal ,IUsercode ,IFullname ,INamepy ,IComment ,ISystem ,RowIndex)
VALUES  ( '00006' ,'00000' ,0 ,0 ,1 ,'BaseInfo.bpl' ,'BaseInfo.bpl' ,'BaseInfo.bpl' ,'基本信息' ,1, 5)
INSERT dbo.tbx_PackageInfo ( ITypeId ,Parid ,ISonnum ,Soncount ,Leveal ,IUsercode ,IFullname ,INamepy ,IComment ,ISystem ,RowIndex)
VALUES  ( '00007' ,'00000' ,0 ,0 ,1 ,'TestBpl.bpl' ,'TestBpl.bpl' ,'TestBpl.bpl' ,'测试BPL' ,0, 6)
INSERT dbo.tbx_PackageInfo ( ITypeId ,Parid ,ISonnum ,Soncount ,Leveal ,IUsercode ,IFullname ,INamepy ,IComment ,ISystem ,RowIndex)
VALUES  ( '00008' ,'00000' ,0 ,0 ,1 ,'Testdll.dll' ,'Testdll.dll' ,'Testdll.dll' ,'测试DLL' ,0, 7)
GO 

DELETE dbo.tbx_FrmMoudleNoParams
GO 
--初始化窗体和对应的模块编号参数, MoudleNo要与uMoudleNoDef的对应
INSERT INTO dbo.tbx_FrmMoudleNoParams ( MoudleNo ,FMPKey ,DefaultCaption ,ShowCaption ,ClassName ,ParamList , DefaultParams )
VALUES  (101, '{1382E20F-642F-4662-A863-7F90F6E04CC7}' , '系统加载模块' , '系统加载模块' , 'TfrmLoadItemSet' , '' , '' )
GO

DELETE tbx_DefSQLList
GO
--初始化定义的SQL语句
INSERT INTO dbo.tbx_DefSQLList ( SQLNo ,DSLKey ,SQLStr ,DSLRemark ,DSLCreateTime ,DSLUpdateTime)
VALUES  (4001 ,'{DF1C4EA1-D1F2-4150-99CB-317DF61FB17E}' ,'select * from tbx_PackageInfo' ,'查询要加载的包' , GETDATE() ,GETDATE())
GO