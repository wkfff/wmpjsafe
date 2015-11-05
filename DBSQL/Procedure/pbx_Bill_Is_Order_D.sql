IF OBJECT_ID('dbo.pbx_Bill_Is_Order_D') IS NOT NULL 
    DROP PROCEDURE dbo.pbx_Bill_Is_Order_D
go

--  ********************************************************************************************                                                                                  
--  ||   过程名称：pbx_Bill_Is_Order_D                                               
--  ||   过程功能：添加订单的明细信息
--  ********************************************************************************************

CREATE  PROCEDURE [pbx_Bill_Is_Order_D]
    (
      @RowId VARCHAR(8000) ,
      @VchCode VARCHAR(50) ,
      @VchType VARCHAR(50) ,
      @ColRowNo VARCHAR(8000) ,
      @Atypeid VARCHAR(8000) ,
      @Btypeid VARCHAR(8000) ,
      @Etypeid VARCHAR(8000) ,
      @Dtypeid VARCHAR(8000) ,
      @Ktypeid VARCHAR(8000) ,
      @Ktypeid2 VARCHAR(8000) ,
      @PtypeId VARCHAR(8000) ,
      
      @CostMode VARCHAR(8000) ,
      @UnitRate VARCHAR(8000) ,
      @Unit VARCHAR(8000) ,
      
      @Blockno VARCHAR(8000) ,
      @Prodate VARCHAR(8000) ,
      @UsefulEndDate VARCHAR(8000) = '',
      @Jhdate VARCHAR(8000) ,
      
      @GoodsNo VARCHAR(8000) ,
      
      @Qty VARCHAR(8000) ,
      @Price VARCHAR(8000) ,
      @Total VARCHAR(8000) ,
      
      @Discount VARCHAR(8000) ,
      @DiscountPrice VARCHAR(8000) ,
      @DiscountTotal VARCHAR(8000) ,
      
      @TaxRate VARCHAR(8000) ,
      @TaxPrice VARCHAR(8000) ,
      @TaxTotal VARCHAR(8000) ,
      
      
      @AssQty VARCHAR(8000) ,
      @AssPrice VARCHAR(8000) ,
      @AssDiscountPrice VARCHAR(8000) ,
      @AssTaxPrice VARCHAR(8000) ,
      
      @CostTotal VARCHAR(8000) ,
      @CostPrice VARCHAR(8000) ,
      
      @OrderCode VARCHAR(8000) = '' ,
      @OrderDlyCode VARCHAR(8000) = '' ,
      @OrderVchType VARCHAR(8000) = '' ,

      @Comment VARCHAR(8000) ,
      @InputDate VARCHAR(8000) ,
      @Usedtype VARCHAR(8000) ,
      @Period VARCHAR(8000) ,
      @Tax_total VARCHAR(8000) ,
      @Tax VARCHAR(8000) ,
      


      @Pstatus VARCHAR(8000) = '' ,
      @YearPeriod VARCHAR(8000) = '' ,
      
      @ErrorValue VARCHAR(500) OUTPUT --返回错误信息 
    )
AS 
    DECLARE @dUnitRateTemp NUMERIC(22, 10)


    DECLARE @nDlyOrder INT ,
        @StrOrderDly INT ,
        @Rnet INT
    DECLARE @splitstr VARCHAR(10)
    SET @splitstr = 'ǎǒǜ'

    IF EXISTS ( SELECT  1
                FROM    ptype p ,
                        ( SELECT    PtypeId.col PtypeId ,
                                    pgManCode.col pgManCode
                          FROM      dbo.f_splitSTR(@szRowId, @splitstr) szRowId
                                    LEFT JOIN dbo.f_splitSTR(@PtypeId, @splitstr) PtypeId ON szRowId.Id = PtypeId.Id
                                    LEFT JOIN dbo.f_splitSTR(@pgManCode, @splitstr) pgManCode ON szRowId.Id = pgManCode.Id
                        ) b
                WHERE   p.ptypeid = b.ptypeid
                        AND p.pgManCode <> b.pgManCode ) 
        BEGIN
            SELECT TOP 1
                    p.ptypeid
            FROM    ptype p ,
                    ( SELECT    PtypeId.col PtypeId ,
                                pgManCode.col pgManCode
                      FROM      dbo.f_splitSTR(@szRowId, @splitstr) szRowId
                                LEFT JOIN dbo.f_splitSTR(@PtypeId, @splitstr) PtypeId ON szRowId.Id = PtypeId.Id
                                LEFT JOIN dbo.f_splitSTR(@pgManCode, @splitstr) pgManCode ON szRowId.Id = pgManCode.Id
                    ) b
            WHERE   p.ptypeid = b.ptypeid
                    AND p.pgManCode <> b.pgManCode
            RETURN -2
        END


    BEGIN TRAN OrderSaveDly

    SELECT  @StrOrderDly = ISNULL(MAX(dlyorder), 0)
    FROM    dbo.BakDlyOrder

    INSERT  INTO [dbo].[bakdlyorder]
            ( [vchcode] ,
              [ColRowNo] ,
              [atypeId] ,
              [btypeId] ,
              [etypeId] ,
              [DeptId] ,
              [ktypeId] ,
              [ktypeId2] ,
              [PtypeId] ,
              [Qty] ,
              SideQty ,
              [discount] ,
              [discountprice] ,
              [costtotal] ,
              [costPrice] ,
              [blockno] ,
              [goodsno] ,
              [price] ,
              [total] ,
              [Prodate] ,
              [Jhdate] ,
              [TaxPrice] ,
              [TaxTotal] ,
              [comment] ,
              [date] ,
              [usedtype] ,
              [period] ,
              [tax_total] ,
              [tax] ,
              [discounttotal] ,
              AssQty ,
              AssPrice ,
              AssDiscountPrice ,
              AssTaxPrice ,
              UnitRate ,
              [costmode] ,
              [vchtype] ,
              [redword] ,
              [unit] ,
              [orderCode] ,
              [orderDlyCode] ,
              [orderVchType] ,
              [Pstutas] ,
              [YearPeriod] ,
              pgholqty ,
              pgholInqty ,
              UsefulEndDate
            )
            SELECT  CAST(@vchcode AS INT) ,
                    ISNULL(ColRowNo.Col, '') ,
                    ISNULL(atypeId.Col, '') ,
                    ISNULL(btypeId.Col, '') ,
                    ISNULL(etypeId.Col, '') ,
                    ISNULL(DtypeId.Col, '') ,
                    ISNULL(ktypeId.Col, '') ,
                    ISNULL(ktypeId2.Col, '') ,
                    ISNULL(p.PtypeId, '') ,
                    dbo.f_CovToQty(ISNULL(p.uRate, 1) * ISNULL(dassQty.Col, 0)) qty ,
                    ISNULL(SideQty.Col, 0) ,
                    ISNULL(discount.Col, 0) ,
                    dbo.f_CovToPrice(ISNULL(dassdiscountprice.Col, 0) / ISNULL(p.uRate, 1)) discountprice ,
                    ISNULL(costtotal.Col, 0) ,
                    ISNULL(costprice.Col, 0) ,
                    ISNULL(Blockno.Col, '') ,
                    ISNULL(goodsno.Col, '') ,
                    dbo.f_CovToPrice(ISNULL(dassprice.Col, 0) / ISNULL(p.uRate, 1)) price ,
                    ISNULL(total.Col, 0) ,
                    ISNULL(ProDate.Col, '') ,
                    ISNULL(JhDate.Col, '') ,
                    dbo.f_CovToPrice(ISNULL(dassTaxprice.Col, 0) / ISNULL(p.uRate, 1)) TaxPrice ,
                    ISNULL(TaxTotal.col, 0) ,
                    ISNULL(Comment.Col, '') ,
                    ISNULL([date].Col, '') ,
                    ISNULL(usedtype.Col, 0) ,
                    ISNULL(period.Col, 0) ,
                    ISNULL(tax_total.Col, 0) ,
                    ISNULL(tax.Col, 0) ,
                    ISNULL(discounttotal.Col, 0) ,
                    ISNULL(dAssQty.Col, 0) ,
                    ISNULL(dAssPrice.Col, 0) ,
                    ISNULL(dAssDiscountPrice.Col, 0) ,
                    ISNULL(dAssTaxPrice.Col, 0) ,
                    ISNULL(p.uRate, 0) ,
                    ISNULL(nCostMode.Col, 0) ,
                    CAST(@vchtype AS INT) ,
                    'F' red ,
                    ISNULL(p.unit, 0) ,
                    ISNULL(orderCode.col, 0) ,
                    ISNULL(orderDlyCode.col, 0) ,
                    ISNULL(orderVchType.col, 0) ,
                    CASE WHEN nPstatus.Col = '' THEN 0
                         ELSE ISNULL(nPstatus.Col, 0)
                    END ,
                    CASE WHEN nYearPeriod.Col = '' THEN 0
                         ELSE ISNULL(nYearPeriod.Col, 0)
                    END ,
                    CASE WHEN pgholqty.Col = '' THEN 0
                         ELSE ISNULL(pgholqty.Col, 0)
                    END ,
                    CASE WHEN dpgholInqty.Col = '' THEN 0
                         ELSE ISNULL(dpgholInqty.Col, 0)
                    END ,
                    ISNULL(UsefulEndDate.Col, '')
            FROM    dbo.f_splitSTR(@szRowId, @splitstr) szRowId
                    LEFT JOIN dbo.f_splitSTR(@ColRowNo, @splitstr) ColRowNo ON szRowId.Id = ColRowNo.Id
                    LEFT JOIN dbo.f_splitSTR(@atypeId, @splitstr) atypeId ON szRowId.Id = atypeId.Id
                    LEFT JOIN dbo.f_splitSTR(@btypeId, @splitstr) btypeId ON szRowId.Id = btypeId.Id
                    LEFT JOIN dbo.f_splitSTR(@etypeId, @splitstr) etypeId ON szRowId.Id = etypeId.Id
                    LEFT JOIN dbo.f_splitSTR(@szProjectid, @splitstr) DtypeId ON szRowId.Id = DtypeId.Id
                    LEFT JOIN dbo.f_splitSTR(@ktypeId, @splitstr) ktypeId ON szRowId.Id = ktypeId.Id
                    LEFT JOIN dbo.f_splitSTR(@ktypeId2, @splitstr) ktypeId2 ON szRowId.Id = ktypeId2.Id
--left join dbo.f_splitSTR(@PtypeId,@splitstr) PtypeId  on szRowId.Id = PtypeId.Id
--left join dbo.f_splitSTR(@Qty,@splitstr) Qty  on szRowId.Id = Qty.Id
                    LEFT JOIN dbo.f_splitSTR(@SideQty, @splitstr) SideQty ON szRowId.Id = SideQty.Id
                    LEFT JOIN dbo.f_splitSTR(@discount, @splitstr) discount ON szRowId.Id = discount.Id
--left join dbo.f_splitSTR(@discountprice,@splitstr) discountprice  on szRowId.Id = discountprice.Id
                    LEFT JOIN dbo.f_splitSTR(@costtotal, @splitstr) costtotal ON szRowId.Id = costtotal.Id
                    LEFT JOIN dbo.f_splitSTR(@costprice, @splitstr) costprice ON szRowId.Id = costprice.Id
                    LEFT JOIN dbo.f_splitSTR(@Blockno, @splitstr) Blockno ON szRowId.Id = Blockno.Id
                    LEFT JOIN dbo.f_splitSTR(@goodsno, @splitstr) goodsno ON szRowId.Id = goodsno.Id
--left join dbo.f_splitSTR(@price,@splitstr) price  on szRowId.Id = price.Id
                    LEFT JOIN dbo.f_splitSTR(@total, @splitstr) total ON szRowId.Id = total.Id
                    LEFT JOIN dbo.f_splitSTR(@ProDate, @splitstr) ProDate ON szRowId.Id = ProDate.Id
                    LEFT JOIN dbo.f_splitSTR(@JhDate, @splitstr) JhDate ON szRowId.Id = JhDate.Id
--left join dbo.f_splitSTR(@TaxPrice,@splitstr) TaxPrice  on szRowId.Id = TaxPrice.Id
                    LEFT JOIN dbo.f_splitSTR(@TaxTotal, @splitstr) TaxTotal ON szRowId.Id = TaxTotal.Id
                    LEFT JOIN dbo.f_splitSTR(@Comment, @splitstr) Comment ON szRowId.Id = Comment.Id
                    LEFT JOIN dbo.f_splitSTR(@date, @splitstr) [date] ON szRowId.Id = [date].Id
                    LEFT JOIN dbo.f_splitSTR(@usedtype, @splitstr) usedtype ON szRowId.Id = usedtype.Id
                    LEFT JOIN dbo.f_splitSTR(@period, @splitstr) period ON szRowId.Id = period.Id
                    LEFT JOIN dbo.f_splitSTR(@tax_total, @splitstr) tax_total ON szRowId.Id = tax_total.Id
                    LEFT JOIN dbo.f_splitSTR(@tax, @splitstr) tax ON szRowId.Id = tax.Id
                    LEFT JOIN dbo.f_splitSTR(@discounttotal, @splitstr) discounttotal ON szRowId.Id = discounttotal.Id
                    LEFT JOIN dbo.f_splitSTR(@dAssQty, @splitstr) dAssQty ON szRowId.Id = dAssQty.Id
                    LEFT JOIN dbo.f_splitSTR(@dAssPrice, @splitstr) dAssPrice ON szRowId.Id = dAssPrice.Id
                    LEFT JOIN dbo.f_splitSTR(@dAssDiscountPrice, @splitstr) dAssDiscountPrice ON szRowId.Id = dAssDiscountPrice.Id
                    LEFT JOIN dbo.f_splitSTR(@dAssTaxPrice, @splitstr) dAssTaxPrice ON szRowId.Id = dAssTaxPrice.Id
--left join dbo.f_splitSTR(@dUnitRate,@splitstr) dUnitRate  on szRowId.Id = dUnitRate.Id
                    LEFT JOIN dbo.f_splitSTR(@nCostMode, @splitstr) nCostMode ON szRowId.Id = nCostMode.Id

--left join dbo.f_splitSTR(@unit,@splitstr) unit  on szRowId.Id = unit.Id
                    LEFT JOIN dbo.f_splitSTR(@orderCode, @splitstr) orderCode ON szRowId.Id = orderCode.Id
                    LEFT JOIN dbo.f_splitSTR(@orderDlyCode, @splitstr) orderDlyCode ON szRowId.Id = orderDlyCode.Id
                    LEFT JOIN dbo.f_splitSTR(@orderVchType, @splitstr) orderVchType ON szRowId.Id = orderVchType.Id
                    LEFT JOIN dbo.f_splitSTR(@nPstatus, @splitstr) nPstatus ON szRowId.Id = nPstatus.Id
                    LEFT JOIN dbo.f_splitSTR(@nYearPeriod, @splitstr) nYearPeriod ON szRowId.Id = nYearPeriod.Id
                    LEFT JOIN dbo.f_splitSTR(@pgholqty, @splitstr) pgholqty ON szRowId.Id = pgholqty.Id
                    LEFT JOIN dbo.f_splitSTR(@dpgholInqty, @splitstr) dpgholInqty ON szRowId.Id = dpgholInqty.Id
                    LEFT JOIN dbo.f_splitSTR(@UsefulEndDate, @splitstr) UsefulEndDate ON szRowId.ID = UsefulEndDate.ID
                    LEFT JOIN ( SELECT  [ID] ,
                                        p.PtypeId ,
                                        unit ,
                                        ISNULL(URate, 1) URate
                                FROM    ( SELECT    PtypeId.Id ,
                                                    PtypeId.col PtypeId ,
                                                    unit.col unit
                                          FROM      dbo.f_splitSTR(@PtypeId, @splitstr) PtypeId ,
                                                    dbo.f_splitSTR(@unit, @splitstr) unit
                                          WHERE     PtypeId.Id = unit.ID
                                        ) p
                                        LEFT JOIN Xw_ptypeunit unit ON p.ptypeid = unit.PtypeId
                                                                       AND unit.ordid = p.unit
                              ) p ON szRowId.Id = p.Id
            WHERE   szRowId.col <> ''
            ORDER BY szRowId.Id

    IF @@ERROR <> 0 
        GOTO ErrorRollback
    SET @nDlyOrder = @@IDENTITY

    COMMIT TRAN OrderSaveDly

    SELECT  dlyorder
    FROM    BakDlyOrder
    WHERE   dlyorder > @StrOrderDly
            AND dlyorder <= @nDlyOrder
    ORDER BY dlyorder

    GOTO Success

    Success:		 --成功完成函数
    RETURN 0
    ErrorGeneral:    --检查数据是错误，不需要回滚
    RETURN -1   
    ErrorRollback:   --数据操作是错误，需要回滚
    ROLLBACK TRAN OrderSaveDly 
    RETURN -2 

go
