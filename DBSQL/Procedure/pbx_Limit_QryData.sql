IF OBJECT_ID('dbo.pbx_Limit_QryData') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Limit_QryData
go

--��ѯ�û����ɫȨ��

CREATE PROCEDURE pbx_Limit_QryData
    (
      @RUID VARCHAR(50) , --��ɫ���û�ID
      @RUType INT ,  --0δ���壬1��ɫID��2�û�ID
      @LimitType INT ,  --0δ���ã�1������Ϣ��2���ݣ�3����4���ݣ�5����
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
