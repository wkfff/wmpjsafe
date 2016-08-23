IF OBJECT_ID('dbo.pbx_Limit_QryData') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Limit_QryData
go

--查询用户或角色权限

CREATE PROCEDURE pbx_Limit_QryData
    (
      @RUID VARCHAR(50) , --角色或用户ID
      @RUType INT ,  --0未定义，1角色ID，2用户ID
      @LimitType INT ,  --0未配置，1基本信息，2单据，3报表，4数据，5其它
      @ErrorValue VARCHAR(500) OUTPUT 
    )
AS 
    SET NOCOUNT ON
    DECLARE @aSQL VARCHAR(8000)

    IF ( @LimitType = 1 ) 
        BEGIN
            SELECT  la.LAGUID, la.LAName, ISNULL(lab.LAdd, 0) LAdd, ISNULL(lab.LClass, 0) LClass, ISNULL(lab.LDel, 0) LDel, ISNULL(lab.LModify, 0) LModify, ISNULL(lab.LPrint, 0) LPrint, ISNULL(lab.LView, 0) LView
            FROM    tbx_Limit_Action la
                    LEFT JOIN tbx_Limit_Action_Base lab ON la.LAGUID = lab.LAGUID
            WHERE   la.LAType = 1
            ORDER BY la.LARowIndex
        END

            
    --EXEC(@aSQL)        
    RETURN 0

GO 
