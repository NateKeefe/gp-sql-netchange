
IF OBJECT_ID(N'[dbo].[ScribeNetChange]') IS NULL
	exec('CREATE TABLE [dbo].[ScribeNetChange](
			[EntityName] [nvarchar](100) NOT NULL,
			[Id] [nvarchar](250) NOT NULL,
			[LastModifiedDateTime] [datetime] NOT NULL,
			[LastModifiedBy] [nvarchar](100) NOT NULL,
			[ScribeFirstRecordedModifiedDateTime] [datetime] NOT NULL,
			CONSTRAINT [PK_ScribeNetChange] PRIMARY KEY CLUSTERED 
			(
				[EntityName] ASC,
				[Id] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]')
            
IF OBJECT_ID(N'[dbo].[ScribeNetChange]') IS NOT NULL AND NOT EXISTS(SELECT Name FROM sysindexes WHERE Name = N'IX_ScribeNetChange_LastModified')
	exec('CREATE NONCLUSTERED INDEX [IX_ScribeNetChange_LastModified] ON [dbo].[ScribeNetChange]
		(
			[LastModifiedDateTime] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]')

IF OBJECT_ID(N'[dbo].[ScribeOnline_PriceLevel]') IS NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_PriceLevel] AS 
SELECT
PL.CREATDDT as [CreatedDate],
PL.DSCRIPTN as [Description],
PL.MODIFDT as [ModifiedDate],
PL.PRCLEVEL as [PriceLevel],
NT.TXTFIELD as [Notes], 
(select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK)
 where ((EntityName=''IV40800'' and Id=RTRIM(PL.PRCLEVEL)) or (EntityName=''SY03900'' and Id=CAST(PL.NOTEINDX as varchar)))) as [LastModifiedDateTime],
 UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK)
  where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK)
 where ((EntityName=''IV40800'' and Id=RTRIM(PL.PRCLEVEL)) or (EntityName=''SY03900'' and Id=CAST(PL.NOTEINDX as varchar))))),'''')) as [LastModifiedBy]
FROM IV40800 PL with (NOLOCK) Left Outer Join SY03900 NT with (NOLOCK) on PL.NOTEINDX=NT.NOTEINDX
')

IF OBJECT_ID(N'[dbo].[ScribeOnline_NextAvailableNumber]') IS NULL
	exec('CREATE TABLE [dbo].[ScribeOnline_NextAvailableNumber](
	[EntityName] [nvarchar](50) NOT NULL,
	[Prefix] [nvarchar](50) NOT NULL,
	[NumberOfDigits] int NOT NULL,
	[LastIndexGenerated] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_ScribeOnline_NextAvailableNumber] PRIMARY KEY CLUSTERED 
(
	[EntityName] ASC,
	[Prefix] ASC,
	[NumberOfDigits] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]')


IF OBJECT_ID(N'[dbo].[ScribeOnline_ItemCurrency]') IS NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_ItemCurrency] AS 
SELECT
CURNCYID as [CurrencyID],
CURRNIDX as [CurrencyIndex],
DECPLCUR as [DecimalPlacesCurrency],
ITEMNMBR as [ItemNumber],
LISTPRCE as [ListPrice],
(select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK)
 where (EntityName=''IV00105'' and Id=RTRIM(ITEMNMBR)+''|''+RTRIM(CURNCYID))) as [LastModifiedDateTime],
 UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK)
  where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK)
 where (EntityName=''IV00105'' and Id=RTRIM(ITEMNMBR)+''|''+RTRIM(CURNCYID)))),'''')) as [LastModifiedBy]
FROM IV00105')

IF OBJECT_ID(N'[dbo].[ScribeOnline_ItemPriceList]') IS NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_ItemPriceList] AS 
SELECT
CURNCYID as [CurrencyID],
FROMQTY as [FromQTY],
ITEMNMBR as [ItemNumber],
PRCLEVEL as [PriceLevel],
QTYBSUOM as [QTYInBaseUOfM],
TOQTY as [ToQTY],
UOFM as [UOfM],
UOMPRICE as [UOfMPrice],
(select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK)
 where (EntityName=''IV00108'' and Id=RTRIM(ITEMNMBR)+''|''+RTRIM(CURNCYID)+''|''+RTRIM(PRCLEVEL)+''|''+RTRIM(UOFM)+''|''+RTRIM(TOQTY))) as [LastModifiedDateTime],
 UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK)
  where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK)
 where (EntityName=''IV00108'' and Id=RTRIM(ITEMNMBR)+''|''+RTRIM(CURNCYID)+''|''+RTRIM(PRCLEVEL)+''|''+RTRIM(UOFM)+''|''+RTRIM(TOQTY)))),'''')) as [LastModifiedBy]
FROM IV00108')
IF OBJECT_ID(N'[dbo].[ScribeOnline_ItemPriceListLine]') IS NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_ItemPriceListLine] AS 
SELECT
CURNCYID as [CurrencyID],
ITEMNMBR as [ItemNumber],
PRCLEVEL as [PriceLevel],
QTYBSUOM as [QTYInBaseUOfM],
RNDGAMNT as [RoundingAmount],
ROUNDHOW as [RoundHow],
ROUNDTO as [RoundTo],
UMSLSOPT as [UOfMSalesOptions],
UOFM as [UOfM],
(select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK)
 where (EntityName=''IV00107'' and Id=RTRIM(ITEMNMBR)+''|''+RTRIM(CURNCYID)+''|''+RTRIM(PRCLEVEL)+''|''+RTRIM(UOFM))) as [LastModifiedDateTime],
 UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK)
  where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK)
 where (EntityName=''IV00107'' and Id=RTRIM(ITEMNMBR)+''|''+RTRIM(CURNCYID)+''|''+RTRIM(PRCLEVEL)+''|''+RTRIM(UOFM)))),'''')) as [LastModifiedBy]
FROM IV00107')


IF OBJECT_ID(N'[dbo].[ScribeOnline_ItemMaster]') IS NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_ItemMaster] AS
SELECT
IM.ABCCODE as [ABCCode],
IM.ALTITEM1 as [AlternateItem1],
IM.ALTITEM2 as [AlternateItem2],
IM.ALWBKORD as [AllowBackOrders],
IM.ASMVRIDX as [AssemblyVarianceIndex],
IM.CGSINFLX as [COGSInflationIndex],
IM.CGSMCIDX as [COGSMonetaryCorrectionIndex],
IM.CNTRYORGN as [CountryOrigin],
IM.CREATDDT as [CreatedDate],
IM.CURRCOST as [CurrentCost],
IM.DECPLCUR as [DecimalPlacesCurrency],
IM.DECPLQTY as [DecimalPlacesQTYS],
IM.DPSHPIDX as [DropShipIndex],
IM.INACTIVE as [Inactive],
IM.INCLUDEINDP as [IncludeinDemandPlanning],
IM.INVMCIDX as [InventoryMonetaryCorrectionIndex],
IM.ITEMCODE as [ItemCode],
IM.ITEMDESC as [ItemDescription],
IM.ITEMNMBR as [ItemNumber],
IM.ITEMSHWT as [ItemShippingWeight],
IM.ITEMTYPE as [ItemType],
IM.ITMCLSCD as [ItemClassCode],
IM.ITMGEDSC as [ItemGenericDescription],
IM.ITMPLNNNGTYP as [ItemPlanningType],
IM.ITMSHNAM as [ItemShortName],
IM.ITMTRKOP as [ItemTrackingOption],
IM.ITMTSHID as [ItemTaxScheduleID],
IM.IVCOGSIX as [IVCOGSIndex],
IM.IVDMGIDX as [IVDamagedIndex],
IM.IVINFIDX as [InventoryInflationIndex],
IM.IVINSVIX as [IVInServiceIndex],
IM.IVINUSIX as [IVInUseIndex],
IM.IVIVINDX as [IVIVIndex],
IM.IVIVOFIX as [IVIVOffsetIndex],
IM.IVRETIDX as [InventoryReturnsIndex],
IM.IVSLDSIX as [IVSalesDiscountsIndex],
IM.IVSLRNIX as [IVSalesReturnsIndex],
IM.IVSLSIDX as [IVSalesIndex],
IM.IVVARIDX as [IVVariancesIndex],
IM.KPCALHST as [KeepCalendarHistory],
IM.KPDSTHST as [KeepDistributionHistory],
IM.KPERHIST as [KeepPeriodHistory],
IM.KPTRXHST as [KeepTrxHistory],
IM.KTACCTSR as [KitCOGSAccountSource],
IM.LASTGENLOT as [LastGeneratedLotNumber],
IM.LASTGENSN as [LastGeneratedSerialNumber],
IM.LOCNCODE as [LocationCode],
IM.Lot_Split_Quantity as [LotSplitQuantity],
IM.LOTEXPWARN as [LotExpireWarning],
IM.LOTEXPWARNDAYS as [LotExpireWarningDays],
IM.LOTTYPE as [LotType],
IM.MINSHELF1 as [MinShelfLife1],
IM.MINSHELF2 as [MinShelfLife2],
IM.MODIFDT as [ModifiedDate],
IM.MSTRCDTY as [MasterRecordType],
NT.TXTFIELD as [Notes],
IM.PINFLIDX as [PurchInflationIndex],
IM.PRCHSUOM as [PurchasingUOfM],
IM.PRCLEVEL as [PriceLevel],
IM.PriceGroup as [PriceGroup],
IM.PRICMTHD as [PriceMethod],
IM.Purchase_Item_Tax_Schedu as [PurchaseItemTaxScheduleID],
IM.Purchase_Tax_Options as [PurchaseTaxOptions],
IM.PURMCIDX as [PurchMonetaryCorrectionIndex],
IM.PURPVIDX as [PurchasePriceVarianceIndex],
IM.Revalue_Inventory as [RevalueInventory],
IM.SELNGUOM as [SellingUOfM],
IM.STNDCOST as [StandardCost],
IM.STTSTCLVLPRCNTG as [StatisticalValuePercentage],
IM.TAXOPTNS as [TaxOptions],
IM.TCC as [TaxCommodityCode],
IM.Tolerance_Percentage as [TolerancePercentage],
IM.UOMSCHDL as [UOfMSchedule],
IM.UPPVIDX as [UnrealizedPurchasePriceVarianceIndex],
IM.USCATVLS_1 as [UserCategoryValues1],
IM.USCATVLS_2 as [UserCategoryValues2],
IM.USCATVLS_3 as [UserCategoryValues3],
IM.USCATVLS_4 as [UserCategoryValues4],
IM.USCATVLS_5 as [UserCategoryValues5],
IM.USCATVLS_6 as [UserCategoryValues6],
IM.VCTNMTHD as [ValuationMethod],
IM.WRNTYDYS as [WarrantyDays],
(select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK)
 where (EntityName=''IV00101'' and Id=RTRIM(IM.ITEMNMBR)) or (EntityName=''SY03900'' and Id=CAST(IM.NOTEINDX as varchar))) as [LastModifiedDateTime],
 UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK)
  where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK)
 where (EntityName=''IV00101'' and Id=RTRIM(IM.ITEMNMBR)) or (EntityName=''SY03900'' and Id=CAST(IM.NOTEINDX as varchar)))),'''')) as [LastModifiedBy]
FROM IV00101 IM with (NOLOCK) Left Outer Join SY03900 NT with (NOLOCK) on IM.NOTEINDX=NT.NOTEINDX
')


IF OBJECT_ID(N'[dbo].[ScribeOnline_UnitOfMeasureSchedule]') IS NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_UnitOfMeasureSchedule] AS
SELECT
UO.BASEUOFM as [BaseUOfM],
NT.TXTFIELD as [Notes], 
UO.UMDPQTYS as [UOfMDecimalPlacesQTYS],
UO.UMSCHDSC as [UOfMScheduleDescription],
UO.UOMSCHDL as [UOfMSchedule],
(select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK)
 where (EntityName=''IV40201'' and Id=RTRIM(UO.UOMSCHDL)) or (EntityName=''SY03900'' and Id=CAST(UO.NOTEINDX as varchar))) as [LastModifiedDateTime],
 UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK)
  where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK)
 where (EntityName=''IV40201'' and Id=RTRIM(UO.UOMSCHDL)) or (EntityName=''SY03900'' and Id=CAST(UO.NOTEINDX as varchar)))),'''')) as [LastModifiedBy]
FROM IV40201 UO with (NOLOCK) Left Outer Join SY03900 NT with (NOLOCK) on UO.NOTEINDX=NT.NOTEINDX
')


IF OBJECT_ID(N'[dbo].[ScribeOnline_UnitOfMeasureScheduleDetail]') IS NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_UnitOfMeasureScheduleDetail] AS
SELECT
EQUIVUOM as [EquivalentUOfM],
EQUOMQTY as [EquivalentUOfMQTY],
QTYBSUOM as [QTYInBaseUOfM],
SEQNUMBR as [SequenceNumber],
UOFM as [UOfM],
UOFMLONGDESC as [UOfMLongDescription],
UOMSCHDL as [UOfMSchedule],
(select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK)
 where (EntityName=''IV40202'' and Id=RTRIM([UOMSCHDL])+''|''+RTRIM([SEQNUMBR]))) as [LastModifiedDateTime],
 UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK)
  where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK)
 where (EntityName=''IV40202'' and Id=RTRIM([UOMSCHDL])+''|''+RTRIM([SEQNUMBR])))),'''')) as [LastModifiedBy]
 FROM IV40202 with (NOLOCK)
')



IF OBJECT_ID(N'[dbo].[ScribeOnline_Invoice]') IS NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_Invoice] AS
SELECT
IH.ACCTAMNT as [AccountAmount],
IH.ACTLSHIP as [ActualShipDate],
IH.ADDRESS1 as [Address1],
IH.ADDRESS2 as [Address2],
IH.ADDRESS3 as [Address3],
IH.ALLOCABY as [AllocateBy],
IH.APLYWITH as [ApplyWithholding],
IH.BACHNUMB as [BatchNumber],
IH.BACKDATE as [BackOrderDate],
IH.BackoutTradeDisc as [BackoutTradeDiscountAmount],
IH.BCHSOURC as [BatchSource],
IH.BCKTXAMT as [BackoutTaxAmount],
IH.BKTFRTAM as [BackoutFreightAmount],
IH.BKTMSCAM as [BackoutMiscAmount],
IH.BSIVCTTL as [BasedOnInvoiceTotal],
IH.CCode as [CountryCode],
IH.CITY as [City],
IH.CMMSLAMT as [CommissionSaleAmount],
IH.CNTCPRSN as [ContactPerson],
IH.CODAMNT as [CODAmount],
IH.COMAPPTO as [CommissionAppliedTo],
IH.COMMAMNT as [CommissionAmount],
IH.COMMNTID as [CommentID],
IH.ContractExchangeRateStat as [ContractExchangeRateStatus],
IH.CORRCTN as [Correction],
IH.CORRNXST as [CorrectiontoNonexistingTransaction],
IH.COUNTRY as [Country],
IH.CREATDDT as [CreatedDate],
IH.CSTPONBR as [CustomerPONumber],
IH.CURNCYID as [CurrencyID],
IH.CURRNIDX as [CurrencyIndex],
IH.CUSTNAME as [CustomerName],
IH.CUSTNMBR as [CustomerNumber],
IH.DENXRATE as [DenominationExchangeRate],
IH.DEPRECVD as [DepositReceived],
IH.DIRECTDEBIT as [DirectDebit],
IH.DISAVAMT as [DiscountAvailableAmount],
IH.DISAVTKN as [DiscountAvailableTaken],
IH.DISCDATE as [DiscountDate],
IH.DISCFRGT as [DiscountAvailableFreight],
IH.DISCMISC as [DiscountAvailableMisc],
IH.DISCRTND as [DiscountReturned],
IH.DISTKNAM as [DiscountTakenAmount],
IH.DOCAMNT as [DocumentAmount],
IH.DOCDATE as [DocumentDate],
IH.DOCID as [DocumentID],
IH.DOCNCORR as [DocumentNumberCorrected],
IH.DSCDLRAM as [DiscountDollarAmount],
IH.DSCPCTAM as [DiscountPercentAmount],
IH.DSTBTCH1 as [DestBatch1],
IH.DSTBTCH2 as [DestBatch2],
IH.DTLSTREP as [DateLastRepeated],
IH.DUEDATE as [DueDate],
IH.DYSTINCR as [DaystoIncrement],
IH.ECTRX as [ECTransaction],
IH.EXCEPTIONALDEMAND as [ExceptionalDemand],
IH.EXCHDATE as [ExchangeDate],
IH.EXGTBLID as [ExchangeTableID],
IH.EXTDCOST as [ExtendedCost],
IH.FAXNUMBR as [FaxNumber],
IH.Flags as [Flags],
IH.FRGTTXBL as [FreightTaxable],
IH.FRTAMNT as [FreightAmount],
IH.FRTSCHID as [FreightScheduleID],
IH.FRTTXAMT as [FreightTaxAmount],
IH.FUFILDAT as [FulfillmentDate],
IH.GLPOSTDT as [GLPostingDate],
IH.GPSFOINTEGRATIONID as [GPSFOIntegrationID],
IH.INTEGRATIONID as [IntegrationID],
IH.INTEGRATIONSOURCE as [IntegrationSource],
IH.INVODATE as [InvoiceDate],
IH.LOCNCODE as [LocationCode],
IH.MCTRXSTT as [MCTransactionState],
IH.MISCAMNT as [MiscAmount],
IH.MISCTXBL as [MiscTaxable],
IH.MODIFDT as [ModifiedDate],
IH.MRKDNAMT as [MarkdownAmount],
IH.MSCSCHID as [MiscScheduleID],
IH.MSCTXAMT as [MiscTaxAmount],
IH.MSTRNUMB as [MasterNumber],
IH.NCOMAMNT as [NonCommissionedAmount],
NT.TXTFIELD as [Notes], 
IH.OBTAXAMT as [OriginatingBackoutTaxAmount],
IH.OCOMMAMT as [OriginatingCommissionAmount],
IH.ORACTAMT as [OriginatingAccountAmount],
IH.ORBKTFRT as [OriginatingBackoutFreightAmount],
IH.ORBKTMSC as [OriginatingBackoutMiscAmount],
IH.ORCODAMT as [OriginatingCODAmount],
IH.ORCOSAMT as [OriginatingCommissionSalesAmount],
IH.ORDATKN as [OriginatingDiscountAvailableTaken],
IH.ORDAVAMT as [OriginatingDiscountAvailableAmount],
IH.ORDAVFRT as [OriginatingDiscountAvailableFreight],
IH.ORDAVMSC as [OriginatingDiscountAvailableMisc],
IH.ORDDLRAT as [OriginatingDiscountDollarAmount],
IH.ORDEPRVD as [OriginatingDepositReceived],
IH.ORDISRTD as [OriginatingDiscountReturned],
IH.ORDISTKN as [OriginatingDiscountTakenAmount],
IH.ORDOCAMT as [OriginatingDocumentAmount],
IH.ORDRDATE as [OrderDate],
IH.OREMSUBT as [OriginatingRemainingSubtotal],
IH.OREXTCST as [OriginatingExtendedCost],
IH.ORFRTAMT as [OriginatingFreightAmount],
IH.ORFRTTAX as [OriginatingFreightTaxAmount],
IH.OrigBackoutTradeDisc as [OriginatingBackoutTradeDiscountAmount],
IH.ORIGNUMB as [OriginalNumber],
IH.ORIGTYPE as [OriginalType],
IH.ORMISCAMT as [OriginatingMiscAmount],
IH.ORMRKDAM as [OriginatingMarkdownAmount],
IH.ORMSCTAX as [OriginatingMiscTaxAmount],
IH.ORNCMAMT as [OriginatingNonCommissionedAmount],
IH.ORPMTRVD as [OriginatingPaymentReceived],
IH.ORSUBTOT as [OriginatingSubtotal],
IH.ORTAXAMT as [OriginatingTaxAmount],
IH.ORTDISAM as [OriginatingTradeDiscountAmount],
IH.OTAXTAMT as [OriginatingTaxableTaxAmount],
IH.PCKSLPNO as [PackingSlipNumber],
IH.PHNUMBR1 as [PhoneNumber1],
IH.PHNUMBR2 as [PhoneNumber2],
IH.PHONE3 as [Phone3],
IH.PICTICNU as [PickingTicketNumber],
IH.POSTEDDT as [PostedDate],
IH.PRBTADCD as [PrimaryBilltoAddressCode],
IH.PRCLEVEL as [PriceLevel],
IH.PROSPECT as [Prospect],
IH.PRSTADCD as [PrimaryShiptoAddressCode],
IH.PSTGSTUS as [PostingStatus],
IH.PTDUSRID as [PostedUserID],
IH.PYMTRCVD as [PaymentReceived],
IH.PYMTRMID as [PaymentTermsID],
IH.QUOEXPDA as [QuoteExpirationDate],
IH.QUOTEDAT as [QuoteDate],
IH.RATETPID as [RateTypeID],
IH.REFRENCE as [Reference],
IH.REMSUBTO as [RemainingSubtotal],
IH.REPTING as [Repeating],
IH.ReqShipDate as [RequestedShipDate],
IH.RETUDATE as [ReturnDate],
IH.RTCLCMTD as [RateCalculationMethod],
IH.SALEDATE as [SaleDate],
IH.SALSTERR as [SalesTerritory],
IH.SEQNCORR as [SequenceNumberCorrected],
IH.SHIPCOMPLETE as [ShipCompleteDocument],
IH.SHIPMTHD as [ShippingMethod],
IH.ShipToName as [ShipToName],
IH.SHPPGDOC as [ShippingDocument],
IH.SIMPLIFD as [Simplified],
IH.SLPRSNID as [SalespersonID],
IH.SOPHDRE1 as [SOPHDRErrors1],
IH.SOPHDRE2 as [SOPHDRErrors2],
IH.SOPHDRE3 as [SOPHDRErrors3],
IH.SOPHDRFL as [SOPHDRFlags],
IH.SOPLNERR as [SOPLINEErrors],
IH.SOPMCERR as [SOPMCPostingErrorMessages],
IH.SOPNUMBE as [SOPNumber],
IH.SOPSTATUS as [SOPStatus],
IH.SOPTYPE as [SOPType],
IH.STATE as [State],
IH.SUBTOTAL as [Subtotal],
IH.Tax_Date as [TaxDate],
IH.TAXAMNT as [TaxAmount],
IH.TAXEXMT1 as [TaxExempt1],
IH.TAXEXMT2 as [TaxExempt2],
IH.TAXSCHID as [TaxScheduleID],
IH.TIME1 as [Time],
IH.TIMEREPD as [TimesRepeated],
IH.TIMESPRT as [TimesPrinted],
IH.TIMETREP as [TimesToRepeat],
IH.TRDISAMT as [TradeDiscountAmount],
IH.TRDISPCT as [TradeDiscountPercent],
IH.TRXFREQU as [TRXFrequency],
IH.TRXSORCE as [TRXSource],
IH.TXBTXAMT as [TaxableTaxAmount],
IH.TXENGCLD as [TaxEngineCalled],
IH.TXRGNNUM as [TaxRegistrationNumber],
IH.TXSCHSRC as [TaxScheduleSource],
IH.UPSZONE as [UPSZone],
IH.USDOCID1 as [UseDocumentID1],
IH.USDOCID2 as [UseDocumentID2],
IH.USER2ENT as [UserToEnter],
IH.VOIDSTTS as [VoidStatus],
IH.WITHHAMT as [WithholdingAmount],
IH.WorkflowApprStatCreditLm as [WorkflowApprovalStatusCreditLimit],
IH.WorkflowApprStatusQuote as [WorkflowApprovalStatusQuote],
IH.WorkflowPriorityCreditLm as [WorkflowPriorityCreditLimit],
IH.WorkflowPriorityQuote as [WorkflowPriorityQuote],
IH.XCHGRATE as [ExchangeRate],
IH.ZIPCODE as [ZipCode],
(select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK)
 where (EntityName=''SOP10100'' and Id=RTRIM(IH.SOPNUMBE)+''|''+''3'') or (EntityName=''SY03900'' and Id=CAST(IH.NOTEINDX as varchar))) as [LastModifiedDateTime],
 UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK)
  where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK)
 where (EntityName=''SOP10100'' and Id=RTRIM(IH.SOPNUMBE)+''|''+''3'') or (EntityName=''SY03900'' and Id=CAST(IH.NOTEINDX as varchar)))),'''')) as [LastModifiedBy]
FROM SOP10100 IH with (NOLOCK) Left Outer Join SY03900 NT with (NOLOCK) on IH.NOTEINDX=NT.NOTEINDX
WHERE SOPTYPE=3
')


IF OBJECT_ID(N'[dbo].[ScribeOnline_InvoiceLine]') IS NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_InvoiceLine] AS
SELECT
ACTLSHIP as [ActualShipDate],
ADDRESS1 as [Address1],
ADDRESS2 as [Address2],
ADDRESS3 as [Address3],
ATYALLOC as [QTYAllocated],
BackoutTradeDisc as [BackoutTradeDiscountAmount],
BKTSLSAM as [BackoutSalesAmount],
BRKFLD1 as [BreakField1],
BRKFLD2 as [BreakField2],
BRKFLD3 as [BreakField3],
BSIVCTTL as [BasedOnInvoiceTotal],
BULKPICKPRNT as [BulkPickPrinted],
CCode as [CountryCode],
CITY as [City],
CMPNTSEQ as [ComponentSequence],
CNTCPRSN as [ContactPerson],
COMMNTID as [CommentID],
CONTENDDTE as [ContractEndDate],
CONTITEMNBR as [ContractItemNumber],
CONTLNSEQNBR as [ContractLineSEQNumber],
CONTNBR as [ContractNumber],
CONTSERIALNBR as [ContractSerialNumber],
CONTSTARTDTE as [ContractStartDate],
COUNTRY as [Country],
CSLSINDX as [CostOfSalesIndex],
CURRNIDX as [CurrencyIndex],
DECPLCUR as [DecimalPlacesCurrency],
DECPLQTY as [DecimalPlacesQTYS],
DISCSALE as [DiscountAvailableSales],
DMGDINDX as [DamagedIndex],
DROPSHIP as [DropShip],
EXCEPTIONALDEMAND as [ExceptionalDemand],
EXTDCOST as [ExtendedCost],
EXTQTYAL as [ExistingQtyAvailable],
EXTQTYSEL as [ExistingQtySelected],
FAXNUMBR as [FaxNumber],
Flags as [Flags],
FUFILDAT as [FulfillmentDate],
GPSFOINTEGRATIONID as [GPSFOIntegrationID],
INDPICKPRNT as [IndividualPickPrinted],
INSRINDX as [InServiceIndex],
INTEGRATIONID as [IntegrationID],
INTEGRATIONSOURCE as [IntegrationSource],
INUSINDX as [InUseIndex],
INVINDX as [InventoryIndex],
ISLINEINTRA as [IsLineIntrastat],
ITEMCODE as [ItemCode],
ITEMDESC as [ItemDescription],
ITEMNMBR as [ItemNumber],
ITMTSHID as [ItemTaxScheduleID],
IVITMTXB as [IVItemTaxable],
LNITMSEQ as [LineItemSequence],
LOCNCODE as [LocationCode],
MKDNINDX as [MarkdownIndex],
MRKDNAMT as [MarkdownAmount],
MRKDNPCT as [MarkdownPercent],
MRKDNTYP as [MarkdownType],
MULTIPLEBINS as [MultipleBins],
NONINVEN as [NonIV],
ODECPLCU as [OriginatingDecimalPlacesCurrency],
ORBKTSLS as [OriginatingBackoutSalesAmount],
ORDAVSLS as [OriginatingDiscountAvailableSales],
OREPRICE as [OriginatingRemainingPrice],
OREXTCST as [OriginatingExtendedCost],
ORGSEQNM as [OriginalSequenceNumberCorrected],
OrigBackoutTradeDisc as [OriginatingBackoutTradeDiscountAmount],
ORMRKDAM as [OriginatingMarkdownAmount],
ORTAXAMT as [OriginatingTaxAmount],
ORTDISAM as [OriginatingTradeDiscountAmount],
ORUNTCST as [OriginatingUnitCost],
ORUNTPRC as [OriginatingUnitPrice],
OTAXTAMT as [OriginatingTaxableTaxAmount],
OXTNDPRC as [OriginatingExtendedPrice],
PHONE1 as [Phone1],
PHONE2 as [Phone2],
PHONE3 as [Phone3],
PRCLEVEL as [PriceLevel],
PRSTADCD as [PrimaryShiptoAddressCode],
PURCHSTAT as [PurchasingStatus],
QTYBSUOM as [QTYInBaseUOfM],
QTYCANCE as [QTYCanceled],
QTYCANOT as [QTYCanceledOther],
QTYDMGED as [QTYDamaged],
QTYFULFI as [QTYFulfilled],
QTYINSVC as [QTYInService],
QTYINUSE as [QTYInUse],
QTYONHND as [QTYOnHand],
QTYONPO as [QTYOnPO],
QTYORDER as [QTYOrdered],
QTYPRBAC as [QTYPrevBackOrdered],
QTYPRBOO as [QTYPrevBOOnOrder],
QTYPRINV as [QTYPrevInvoiced],
QTYPRORD as [QTYPrevOrdered],
QTYPRVRECVD as [QTYPrevReceived],
QTYRECVD as [QTYReceived],
QTYREMAI as [QTYRemaining],
QTYREMBO as [QTYRemainingOnBO],
QTYRTRND as [QTYReturned],
QTYSLCTD as [QTYSelected],
QTYTBAOR as [QTYToBackOrder],
QTYTOINV as [QTYToInvoice],
QTYTORDR as [QTYToOrder],
QTYTOSHP as [QTYToShip],
QUANTITY as [QTY],
REMPRICE as [RemainingPrice],
ReqShipDate as [RequestedShipDate],
RTNSINDX as [ReturnsIndex],
SALSTERR as [SalesTerritory],
SHIPMTHD as [ShippingMethod],
ShipToName as [ShipToName],
SLPRSNID as [SalespersonID],
SLSINDX as [SalesIndex],
SOFULFILLMENTBIN as [SOFulfillmentBin],
SOPLNERR as [SOPLINEErrors],
SOPNUMBE as [SOPNumber],
SOPTYPE as [SOPType],
STATE as [State],
TAXAMNT as [TaxAmount],
TAXSCHID as [TaxScheduleID],
TRDISAMT as [TradeDiscountAmount],
TRXSORCE as [TRXSource],
TXBTXAMT as [TaxableTaxAmount],
TXSCHSRC as [TaxScheduleSource],
UNITCOST as [UnitCost],
UNITPRCE as [UnitPrice],
UOFM as [UOfM],
XFRSHDOC as [TransferredToShippingDocument],
XTNDPRCE as [ExtendedPrice],
ZIPCODE as [ZipCode],
(select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK)
 where (EntityName=''SOP10200'' and Id=RTRIM(SOPNUMBE)+''|''+RTRIM(SOPTYPE)+''|''+RTRIM([CMPNTSEQ])+''|''+RTRIM([LNITMSEQ]))) as [LastModifiedDateTime],
 UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK)
  where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK)
 where (EntityName=''SOP10200'' and Id=RTRIM(SOPNUMBE)+''|''+RTRIM(SOPTYPE)+''|''+RTRIM([CMPNTSEQ])+''|''+RTRIM([LNITMSEQ])))),'''')) as [LastModifiedBy]
FROM SOP10200 with (NOLOCK)
WHERE SOPTYPE=3
')

IF OBJECT_ID(N'[dbo].[ScribeOnline_InvoiceHistoryLine]') IS NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_InvoiceHistoryLine] AS
SELECT
ACTLSHIP as [ActualShipDate],
ADDRESS1 as [Address1],
ADDRESS2 as [Address2],
ADDRESS3 as [Address3],
ATYALLOC as [QTYAllocated],
BKTSLSAM as [BackoutSalesAmount],
BRKFLD1 as [BreakField1],
BRKFLD2 as [BreakField2],
BRKFLD3 as [BreakField3],
BSIVCTTL as [BasedOnInvoiceTotal],
CCode as [CountryCode],
CITY as [City],
CMPNTSEQ as [ComponentSequence],
CNTCPRSN as [ContactPerson],
COMMNTID as [CommentID],
CONTENDDTE as [ContractEndDate],
CONTITEMNBR as [ContractItemNumber],
CONTLNSEQNBR as [ContractLineSEQNumber],
CONTNBR as [ContractNumber],
CONTSERIALNBR as [ContractSerialNumber],
CONTSTARTDTE as [ContractStartDate],
COUNTRY as [Country],
CSLSINDX as [CostOfSalesIndex],
CURRNIDX as [CurrencyIndex],
DECPLCUR as [DecimalPlacesCurrency],
DECPLQTY as [DecimalPlacesQTYS],
DISCSALE as [DiscountAvailableSales],
DMGDINDX as [DamagedIndex],
DOCNCORR as [DocumentNumberCorrected],
DROPSHIP as [DropShip],
EXCEPTIONALDEMAND as [ExceptionalDemand],
EXTDCOST as [ExtendedCost],
EXTQTYAL as [ExistingQtyAvailable],
EXTQTYSEL as [ExistingQtySelected],
FAXNUMBR as [FaxNumber],
Flags as [Flags],
FUFILDAT as [FulfillmentDate],
INSRINDX as [InServiceIndex],
INUSINDX as [InUseIndex],
INVINDX as [InventoryIndex],
ISLINEINTRA as [IsLineIntrastat],
ITEMCODE as [ItemCode],
ITEMDESC as [ItemDescription],
ITEMNMBR as [ItemNumber],
ITMTSHID as [ItemTaxScheduleID],
IVITMTXB as [IVItemTaxable],
LNITMSEQ as [LineItemSequence],
LOCNCODE as [LocationCode],
MKDNINDX as [MarkdownIndex],
MRKDNAMT as [MarkdownAmount],
MRKDNPCT as [MarkdownPercent],
MRKDNTYP as [MarkdownType],
NONINVEN as [NonIV],
ODECPLCU as [OriginatingDecimalPlacesCurrency],
ORBKTSLS as [OriginatingBackoutSalesAmount],
ORDAVSLS as [OriginatingDiscountAvailableSales],
OREPRICE as [OriginatingRemainingPrice],
OREXTCST as [OriginatingExtendedCost],
ORGSEQNM as [OriginalSequenceNumberCorrected],
ORMRKDAM as [OriginatingMarkdownAmount],
ORTAXAMT as [OriginatingTaxAmount],
ORTDISAM as [OriginatingTradeDiscountAmount],
ORUNTCST as [OriginatingUnitCost],
ORUNTPRC as [OriginatingUnitPrice],
OTAXTAMT as [OriginatingTaxableTaxAmount],
OXTNDPRC as [OriginatingExtendedPrice],
PHONE1 as [Phone1],
PHONE2 as [Phone2],
PHONE3 as [Phone3],
PRCLEVEL as [PriceLevel],
PRSTADCD as [PrimaryShiptoAddressCode],
PURCHSTAT as [PurchasingStatus],
QTYBSUOM as [QTYInBaseUOfM],
QTYCANCE as [QTYCanceled],
QTYCANOT as [QTYCanceledOther],
QTYDMGED as [QTYDamaged],
QTYFULFI as [QTYFulfilled],
QTYINSVC as [QTYInService],
QTYINUSE as [QTYInUse],
QTYONHND as [QTYOnHand],
QTYORDER as [QTYOrdered],
QTYPRBAC as [QTYPrevBackOrdered],
QTYPRBOO as [QTYPrevBOOnOrder],
QTYPRINV as [QTYPrevInvoiced],
QTYPRORD as [QTYPrevOrdered],
QTYPRVRECVD as [QTYPrevReceived],
QTYRECVD as [QTYReceived],
QTYREMAI as [QTYRemaining],
QTYREMBO as [QTYRemainingOnBO],
QTYRTRND as [QTYReturned],
QTYSLCTD as [QTYSelected],
QTYTBAOR as [QTYToBackOrder],
QTYTOINV as [QTYToInvoice],
QTYTORDR as [QTYToOrder],
QUANTITY as [QTY],
REMPRICE as [RemainingPrice],
ReqShipDate as [RequestedShipDate],
RTNSINDX as [ReturnsIndex],
SALSTERR as [SalesTerritory],
SHIPMTHD as [ShippingMethod],
ShipToName as [ShipToName],
SLPRSNID as [SalespersonID],
SLSINDX as [SalesIndex],
SOPLNERR as [SOPLINEErrors],
SOPNUMBE as [SOPNumber],
SOPTYPE as [SOPType],
STATE as [State],
TAXAMNT as [TaxAmount],
TAXSCHID as [TaxScheduleID],
TRDISAMT as [TradeDiscountAmount],
TRXSORCE as [TRXSource],
TXBTXAMT as [TaxableTaxAmount],
TXSCHSRC as [TaxScheduleSource],
UNITCOST as [UnitCost],
UNITPRCE as [UnitPrice],
UOFM as [UOfM],
XTNDPRCE as [ExtendedPrice],
ZIPCODE as [ZipCode],
(select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK)
 where (EntityName=''SOP30300'' and Id=RTRIM([SOPNUMBE])+''|''+RTRIM([SOPTYPE])+''|''+RTRIM([CMPNTSEQ])+''|''+RTRIM([LNITMSEQ]))) as [LastModifiedDateTime],
 UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK)
  where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK)
 where (EntityName=''SOP30300'' and Id=RTRIM([SOPNUMBE])+''|''+RTRIM([SOPTYPE])+''|''+RTRIM([CMPNTSEQ])+''|''+RTRIM([LNITMSEQ])))),'''')) as [LastModifiedBy]
FROM SOP30300 with (NOLOCK)
WHERE SOPTYPE=3
')


IF OBJECT_ID(N'[dbo].[ScribeOnline_InvoiceHistory]') IS NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_InvoiceHistory] AS
SELECT
INVH.ACCTAMNT as [AccountAmount],
INVH.ACTLSHIP as [ActualShipDate],
INVH.ADDRESS1 as [Address1],
INVH.ADDRESS2 as [Address2],
INVH.ADDRESS3 as [Address3],
INVH.ALLOCABY as [AllocateBy],
INVH.APLYWITH as [ApplyWithholding],
INVH.BACHNUMB as [BatchNumber],
INVH.BACKDATE as [BackOrderDate],
INVH.BCHSOURC as [BatchSource],
INVH.BCKTXAMT as [BackoutTaxAmount],
INVH.BKTFRTAM as [BackoutFreightAmount],
INVH.BKTMSCAM as [BackoutMiscAmount],
INVH.BSIVCTTL as [BasedOnInvoiceTotal],
INVH.CCode as [CountryCode],
INVH.CITY as [City],
INVH.CMMSLAMT as [CommissionSaleAmount],
INVH.CNTCPRSN as [ContactPerson],
INVH.CODAMNT as [CODAmount],
INVH.COMAPPTO as [CommissionAppliedTo],
INVH.COMMAMNT as [CommissionAmount],
INVH.COMMNTID as [CommentID],
INVH.ContractExchangeRateStat as [ContractExchangeRateStatus],
INVH.CORRCTN as [Correction],
INVH.COUNTRY as [Country],
INVH.CREATDDT as [CreatedDate],
INVH.CSTPONBR as [CustomerPONumber],
INVH.CURNCYID as [CurrencyID],
INVH.CURRNIDX as [CurrencyIndex],
INVH.CUSTNAME as [CustomerName],
INVH.CUSTNMBR as [CustomerNumber],
INVH.DENXRATE as [DenominationExchangeRate],
INVH.DEPRECVD as [DepositReceived],
INVH.DIRECTDEBIT as [DirectDebit],
INVH.DISAVAMT as [DiscountAvailableAmount],
INVH.DISAVTKN as [DiscountAvailableTaken],
INVH.DISCDATE as [DiscountDate],
INVH.DISCFRGT as [DiscountAvailableFreight],
INVH.DISCMISC as [DiscountAvailableMisc],
INVH.DISCRTND as [DiscountReturned],
INVH.DISTKNAM as [DiscountTakenAmount],
INVH.DOCAMNT as [DocumentAmount],
INVH.DOCDATE as [DocumentDate],
INVH.DOCID as [DocumentID],
INVH.DOCNCORR as [DocumentNumberCorrected],
INVH.DSCDLRAM as [DiscountDollarAmount],
INVH.DSCPCTAM as [DiscountPercentAmount],
INVH.DSTBTCH1 as [DestBatch1],
INVH.DSTBTCH2 as [DestBatch2],
INVH.DTLSTREP as [DateLastRepeated],
INVH.DUEDATE as [DueDate],
INVH.DYSTINCR as [DaystoIncrement],
INVH.ECTRX as [ECTransaction],
INVH.EXCEPTIONALDEMAND as [ExceptionalDemand],
INVH.EXCHDATE as [ExchangeDate],
INVH.EXGTBLID as [ExchangeTableID],
INVH.EXTDCOST as [ExtendedCost],
INVH.FAXNUMBR as [FaxNumber],
INVH.Flags as [Flags],
INVH.FRGTTXBL as [FreightTaxable],
INVH.FRTAMNT as [FreightAmount],
INVH.FRTSCHID as [FreightScheduleID],
INVH.FRTTXAMT as [FreightTaxAmount],
INVH.FUFILDAT as [FulfillmentDate],
INVH.GLPOSTDT as [GLPostingDate],
INVH.INVODATE as [InvoiceDate],
INVH.LOCNCODE as [LocationCode],
INVH.MCTRXSTT as [MCTransactionState],
INVH.MISCAMNT as [MiscAmount],
INVH.MISCTXBL as [MiscTaxable],
INVH.MODIFDT as [ModifiedDate],
INVH.MRKDNAMT as [MarkdownAmount],
INVH.MSCSCHID as [MiscScheduleID],
INVH.MSCTXAMT as [MiscTaxAmount],
INVH.MSTRNUMB as [MasterNumber],
INVH.NCOMAMNT as [NonCommissionedAmount],
NT.TXTFIELD as [Notes], 
INVH.OBTAXAMT as [OriginatingBackoutTaxAmount],
INVH.OCOMMAMT as [OriginatingCommissionAmount],
INVH.ORACTAMT as [OriginatingAccountAmount],
INVH.ORBKTFRT as [OriginatingBackoutFreightAmount],
INVH.ORBKTMSC as [OriginatingBackoutMiscAmount],
INVH.ORCODAMT as [OriginatingCODAmount],
INVH.ORCOSAMT as [OriginatingCommissionSalesAmount],
INVH.ORDATKN as [OriginatingDiscountAvailableTaken],
INVH.ORDAVAMT as [OriginatingDiscountAvailableAmount],
INVH.ORDAVFRT as [OriginatingDiscountAvailableFreight],
INVH.ORDAVMSC as [OriginatingDiscountAvailableMisc],
INVH.ORDDLRAT as [OriginatingDiscountDollarAmount],
INVH.ORDEPRVD as [OriginatingDepositReceived],
INVH.ORDISRTD as [OriginatingDiscountReturned],
INVH.ORDISTKN as [OriginatingDiscountTakenAmount],
INVH.ORDOCAMT as [OriginatingDocumentAmount],
INVH.ORDRDATE as [OrderDate],
INVH.OREMSUBT as [OriginatingRemainingSubtotal],
INVH.OREXTCST as [OriginatingExtendedCost],
INVH.ORFRTAMT as [OriginatingFreightAmount],
INVH.ORFRTTAX as [OriginatingFreightTaxAmount],
INVH.ORIGNUMB as [OriginalNumber],
INVH.ORIGTYPE as [OriginalType],
INVH.ORMISCAMT as [OriginatingMiscAmount],
INVH.ORMRKDAM as [OriginatingMarkdownAmount],
INVH.ORMSCTAX as [OriginatingMiscTaxAmount],
INVH.ORNCMAMT as [OriginatingNonCommissionedAmount],
INVH.ORPMTRVD as [OriginatingPaymentReceived],
INVH.ORSUBTOT as [OriginatingSubtotal],
INVH.ORTAXAMT as [OriginatingTaxAmount],
INVH.ORTDISAM as [OriginatingTradeDiscountAmount],
INVH.OTAXTAMT as [OriginatingTaxableTaxAmount],
INVH.PCKSLPNO as [PackingSlipNumber],
INVH.PHNUMBR1 as [PhoneNumber1],
INVH.PHNUMBR2 as [PhoneNumber2],
INVH.PHONE3 as [Phone3],
INVH.PICTICNU as [PickingTicketNumber],
INVH.POSTEDDT as [PostedDate],
INVH.PRBTADCD as [PrimaryBilltoAddressCode],
INVH.PRCLEVEL as [PriceLevel],
INVH.PROSPECT as [Prospect],
INVH.PRSTADCD as [PrimaryShiptoAddressCode],
INVH.PSTGSTUS as [PostingStatus],
INVH.PTDUSRID as [PostedUserID],
INVH.PYMTRCVD as [PaymentReceived],
INVH.PYMTRMID as [PaymentTermsID],
INVH.QUOEXPDA as [QuoteExpirationDate],
INVH.QUOTEDAT as [QuoteDate],
INVH.RATETPID as [RateTypeID],
INVH.REFRENCE as [Reference],
INVH.REMSUBTO as [RemainingSubtotal],
INVH.REPTING as [Repeating],
INVH.ReqShipDate as [RequestedShipDate],
INVH.RETUDATE as [ReturnDate],
INVH.RTCLCMTD as [RateCalculationMethod],
INVH.SALEDATE as [SaleDate],
INVH.SALSTERR as [SalesTerritory],
INVH.SEQNCORR as [SequenceNumberCorrected],
INVH.SHIPCOMPLETE as [ShipCompleteDocument],
INVH.SHIPMTHD as [ShippingMethod],
INVH.ShipToName as [ShipToName],
INVH.SHPPGDOC as [ShippingDocument],
INVH.SIMPLIFD as [Simplified],
INVH.SLPRSNID as [SalespersonID],
INVH.SOPHDRE1 as [SOPHDRErrors1],
INVH.SOPHDRE2 as [SOPHDRErrors2],
INVH.SOPHDRFL as [SOPHDRFlags],
INVH.SOPLNERR as [SOPLINEErrors],
INVH.SOPNUMBE as [SOPNumber],
INVH.SOPSTATUS as [SOPStatus],
INVH.SOPTYPE as [SOPType],
INVH.STATE as [State],
INVH.SUBTOTAL as [Subtotal],
INVH.Tax_Date as [TaxDate],
INVH.TAXAMNT as [TaxAmount],
INVH.TAXEXMT1 as [TaxExempt1],
INVH.TAXEXMT2 as [TaxExempt2],
INVH.TAXSCHID as [TaxScheduleID],
INVH.TIME1 as [Time],
INVH.TIMEREPD as [TimesRepeated],
INVH.TIMESPRT as [TimesPrinted],
INVH.TIMETREP as [TimesToRepeat],
INVH.TRDISAMT as [TradeDiscountAmount],
INVH.TRDISPCT as [TradeDiscountPercent],
INVH.TRXFREQU as [TRXFrequency],
INVH.TRXSORCE as [TRXSource],
INVH.TXBTXAMT as [TaxableTaxAmount],
INVH.TXENGCLD as [TaxEngineCalled],
INVH.TXRGNNUM as [TaxRegistrationNumber],
INVH.TXSCHSRC as [TaxScheduleSource],
INVH.UPSZONE as [UPSZone],
INVH.USDOCID1 as [UseDocumentID1],
INVH.USDOCID2 as [UseDocumentID2],
INVH.USER2ENT as [UserToEnter],
INVH.VOIDSTTS as [VoidStatus],
INVH.WITHHAMT as [WithholdingAmount],
INVH.WorkflowApprStatCreditLm as [WorkflowApprovalStatusCreditLimit],
INVH.WorkflowApprStatusQuote as [WorkflowApprovalStatusQuote],
INVH.WorkflowPriorityCreditLm as [WorkflowPriorityCreditLimit],
INVH.WorkflowPriorityQuote as [WorkflowPriorityQuote],
INVH.XCHGRATE as [ExchangeRate],
INVH.ZIPCODE as [ZipCode],
(select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK)
 where ((EntityName=''SOP30200'' and Id=RTRIM(SOPNUMBE)+''|''+RTRIM(SOPTYPE)) or (EntityName=''SY03900'' and Id=CAST(INVH.NOTEINDX as varchar)))) as [LastModifiedDateTime],
 UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK)
  where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK)
 where ((EntityName=''SOP30200'' and Id=RTRIM(SOPNUMBE)+''|''+RTRIM(SOPTYPE)) or (EntityName=''SY03900'' and Id=CAST(INVH.NOTEINDX as varchar))))),'''')) as [LastModifiedBy]
  FROM SOP30200 INVH with (NOLOCK) Left Outer Join SY03900 NT with (NOLOCK) on INVH.NOTEINDX=NT.NOTEINDX
 WHERE SOPTYPE=3
')

IF OBJECT_ID(N'[dbo].[ScribeOnline_SalesOrderHistoryLine]') IS NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_SalesOrderHistoryLine] AS
SELECT
ACTLSHIP as [ActualShipDate],
ADDRESS1 as [Address1],
ADDRESS2 as [Address2],
ADDRESS3 as [Address3],
ATYALLOC as [QTYAllocated],
BKTSLSAM as [BackoutSalesAmount],
BRKFLD1 as [BreakField1],
BRKFLD2 as [BreakField2],
BRKFLD3 as [BreakField3],
BSIVCTTL as [BasedOnInvoiceTotal],
CCode as [CountryCode],
CITY as [City],
CMPNTSEQ as [ComponentSequence],
CNTCPRSN as [ContactPerson],
COMMNTID as [CommentID],
CONTENDDTE as [ContractEndDate],
CONTITEMNBR as [ContractItemNumber],
CONTLNSEQNBR as [ContractLineSEQNumber],
CONTNBR as [ContractNumber],
CONTSERIALNBR as [ContractSerialNumber],
CONTSTARTDTE as [ContractStartDate],
COUNTRY as [Country],
CSLSINDX as [CostOfSalesIndex],
CURRNIDX as [CurrencyIndex],
DECPLCUR as [DecimalPlacesCurrency],
DECPLQTY as [DecimalPlacesQTYS],
DISCSALE as [DiscountAvailableSales],
DMGDINDX as [DamagedIndex],
DOCNCORR as [DocumentNumberCorrected],
DROPSHIP as [DropShip],
EXCEPTIONALDEMAND as [ExceptionalDemand],
EXTDCOST as [ExtendedCost],
EXTQTYAL as [ExistingQtyAvailable],
EXTQTYSEL as [ExistingQtySelected],
FAXNUMBR as [FaxNumber],
Flags as [Flags],
FUFILDAT as [FulfillmentDate],
INSRINDX as [InServiceIndex],
INUSINDX as [InUseIndex],
INVINDX as [InventoryIndex],
ISLINEINTRA as [IsLineIntrastat],
ITEMCODE as [ItemCode],
ITEMDESC as [ItemDescription],
ITEMNMBR as [ItemNumber],
ITMTSHID as [ItemTaxScheduleID],
IVITMTXB as [IVItemTaxable],
LNITMSEQ as [LineItemSequence],
LOCNCODE as [LocationCode],
MKDNINDX as [MarkdownIndex],
MRKDNAMT as [MarkdownAmount],
MRKDNPCT as [MarkdownPercent],
MRKDNTYP as [MarkdownType],
NONINVEN as [NonIV],
ODECPLCU as [OriginatingDecimalPlacesCurrency],
ORBKTSLS as [OriginatingBackoutSalesAmount],
ORDAVSLS as [OriginatingDiscountAvailableSales],
OREPRICE as [OriginatingRemainingPrice],
OREXTCST as [OriginatingExtendedCost],
ORGSEQNM as [OriginalSequenceNumberCorrected],
ORMRKDAM as [OriginatingMarkdownAmount],
ORTAXAMT as [OriginatingTaxAmount],
ORTDISAM as [OriginatingTradeDiscountAmount],
ORUNTCST as [OriginatingUnitCost],
ORUNTPRC as [OriginatingUnitPrice],
OTAXTAMT as [OriginatingTaxableTaxAmount],
OXTNDPRC as [OriginatingExtendedPrice],
PHONE1 as [Phone1],
PHONE2 as [Phone2],
PHONE3 as [Phone3],
PRCLEVEL as [PriceLevel],
PRSTADCD as [PrimaryShiptoAddressCode],
PURCHSTAT as [PurchasingStatus],
QTYBSUOM as [QTYInBaseUOfM],
QTYCANCE as [QTYCanceled],
QTYCANOT as [QTYCanceledOther],
QTYDMGED as [QTYDamaged],
QTYFULFI as [QTYFulfilled],
QTYINSVC as [QTYInService],
QTYINUSE as [QTYInUse],
QTYONHND as [QTYOnHand],
QTYORDER as [QTYOrdered],
QTYPRBAC as [QTYPrevBackOrdered],
QTYPRBOO as [QTYPrevBOOnOrder],
QTYPRINV as [QTYPrevInvoiced],
QTYPRORD as [QTYPrevOrdered],
QTYPRVRECVD as [QTYPrevReceived],
QTYRECVD as [QTYReceived],
QTYREMAI as [QTYRemaining],
QTYREMBO as [QTYRemainingOnBO],
QTYRTRND as [QTYReturned],
QTYSLCTD as [QTYSelected],
QTYTBAOR as [QTYToBackOrder],
QTYTOINV as [QTYToInvoice],
QTYTORDR as [QTYToOrder],
QUANTITY as [QTY],
REMPRICE as [RemainingPrice],
ReqShipDate as [RequestedShipDate],
RTNSINDX as [ReturnsIndex],
SALSTERR as [SalesTerritory],
SHIPMTHD as [ShippingMethod],
ShipToName as [ShipToName],
SLPRSNID as [SalespersonID],
SLSINDX as [SalesIndex],
SOPLNERR as [SOPLINEErrors],
SOPNUMBE as [SOPNumber],
SOPTYPE as [SOPType],
STATE as [State],
TAXAMNT as [TaxAmount],
TAXSCHID as [TaxScheduleID],
TRDISAMT as [TradeDiscountAmount],
TRXSORCE as [TRXSource],
TXBTXAMT as [TaxableTaxAmount],
TXSCHSRC as [TaxScheduleSource],
UNITCOST as [UnitCost],
UNITPRCE as [UnitPrice],
UOFM as [UOfM],
XTNDPRCE as [ExtendedPrice],
ZIPCODE as [ZipCode],
(select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK)
 where (EntityName=''SOP30300'' and Id=RTRIM([SOPNUMBE])+''|''+RTRIM([SOPTYPE])+''|''+RTRIM([CMPNTSEQ])+''|''+RTRIM([LNITMSEQ]))) as [LastModifiedDateTime],
 UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK)
  where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK)
 where (EntityName=''SOP30300'' and Id=RTRIM([SOPNUMBE])+''|''+RTRIM([SOPTYPE])+''|''+RTRIM([CMPNTSEQ])+''|''+RTRIM([LNITMSEQ])))),'''')) as [LastModifiedBy]
FROM SOP30300 with (NOLOCK)
WHERE SOPTYPE=2
')



IF OBJECT_ID(N'[dbo].[ScribeOnline_SalesOrderHistory]') IS NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_SalesOrderHistory] AS
SELECT
SOH.ACCTAMNT as [AccountAmount],
SOH.ACTLSHIP as [ActualShipDate],
SOH.ADDRESS1 as [Address1],
SOH.ADDRESS2 as [Address2],
SOH.ADDRESS3 as [Address3],
SOH.ALLOCABY as [AllocateBy],
SOH.APLYWITH as [ApplyWithholding],
SOH.BACHNUMB as [BatchNumber],
SOH.BACKDATE as [BackOrderDate],
SOH.BCHSOURC as [BatchSource],
SOH.BCKTXAMT as [BackoutTaxAmount],
SOH.BKTFRTAM as [BackoutFreightAmount],
SOH.BKTMSCAM as [BackoutMiscAmount],
SOH.BSIVCTTL as [BasedOnInvoiceTotal],
SOH.CCode as [CountryCode],
SOH.CITY as [City],
SOH.CMMSLAMT as [CommissionSaleAmount],
SOH.CNTCPRSN as [ContactPerson],
SOH.CODAMNT as [CODAmount],
SOH.COMAPPTO as [CommissionAppliedTo],
SOH.COMMAMNT as [CommissionAmount],
SOH.COMMNTID as [CommentID],
SOH.ContractExchangeRateStat as [ContractExchangeRateStatus],
SOH.CORRCTN as [Correction],
SOH.COUNTRY as [Country],
SOH.CREATDDT as [CreatedDate],
SOH.CSTPONBR as [CustomerPONumber],
SOH.CURNCYID as [CurrencyID],
SOH.CURRNIDX as [CurrencyIndex],
SOH.CUSTNAME as [CustomerName],
SOH.CUSTNMBR as [CustomerNumber],
SOH.DENXRATE as [DenominationExchangeRate],
SOH.DEPRECVD as [DepositReceived],
SOH.DIRECTDEBIT as [DirectDebit],
SOH.DISAVAMT as [DiscountAvailableAmount],
SOH.DISAVTKN as [DiscountAvailableTaken],
SOH.DISCDATE as [DiscountDate],
SOH.DISCFRGT as [DiscountAvailableFreight],
SOH.DISCMISC as [DiscountAvailableMisc],
SOH.DISCRTND as [DiscountReturned],
SOH.DISTKNAM as [DiscountTakenAmount],
SOH.DOCAMNT as [DocumentAmount],
SOH.DOCDATE as [DocumentDate],
SOH.DOCID as [DocumentID],
SOH.DOCNCORR as [DocumentNumberCorrected],
SOH.DSCDLRAM as [DiscountDollarAmount],
SOH.DSCPCTAM as [DiscountPercentAmount],
SOH.DSTBTCH1 as [DestBatch1],
SOH.DSTBTCH2 as [DestBatch2],
SOH.DTLSTREP as [DateLastRepeated],
SOH.DUEDATE as [DueDate],
SOH.DYSTINCR as [DaystoIncrement],
SOH.ECTRX as [ECTransaction],
SOH.EXCEPTIONALDEMAND as [ExceptionalDemand],
SOH.EXCHDATE as [ExchangeDate],
SOH.EXGTBLID as [ExchangeTableID],
SOH.EXTDCOST as [ExtendedCost],
SOH.FAXNUMBR as [FaxNumber],
SOH.Flags as [Flags],
SOH.FRGTTXBL as [FreightTaxable],
SOH.FRTAMNT as [FreightAmount],
SOH.FRTSCHID as [FreightScheduleID],
SOH.FRTTXAMT as [FreightTaxAmount],
SOH.FUFILDAT as [FulfillmentDate],
SOH.GLPOSTDT as [GLPostingDate],
SOH.INVODATE as [InvoiceDate],
SOH.LOCNCODE as [LocationCode],
SOH.MCTRXSTT as [MCTransactionState],
SOH.MISCAMNT as [MiscAmount],
SOH.MISCTXBL as [MiscTaxable],
SOH.MODIFDT as [ModifiedDate],
SOH.MRKDNAMT as [MarkdownAmount],
SOH.MSCSCHID as [MiscScheduleID],
SOH.MSCTXAMT as [MiscTaxAmount],
SOH.MSTRNUMB as [MasterNumber],
SOH.NCOMAMNT as [NonCommissionedAmount],
NT.TXTFIELD as [Notes], 
SOH.OBTAXAMT as [OriginatingBackoutTaxAmount],
SOH.OCOMMAMT as [OriginatingCommissionAmount],
SOH.ORACTAMT as [OriginatingAccountAmount],
SOH.ORBKTFRT as [OriginatingBackoutFreightAmount],
SOH.ORBKTMSC as [OriginatingBackoutMiscAmount],
SOH.ORCODAMT as [OriginatingCODAmount],
SOH.ORCOSAMT as [OriginatingCommissionSalesAmount],
SOH.ORDATKN as [OriginatingDiscountAvailableTaken],
SOH.ORDAVAMT as [OriginatingDiscountAvailableAmount],
SOH.ORDAVFRT as [OriginatingDiscountAvailableFreight],
SOH.ORDAVMSC as [OriginatingDiscountAvailableMisc],
SOH.ORDDLRAT as [OriginatingDiscountDollarAmount],
SOH.ORDEPRVD as [OriginatingDepositReceived],
SOH.ORDISRTD as [OriginatingDiscountReturned],
SOH.ORDISTKN as [OriginatingDiscountTakenAmount],
SOH.ORDOCAMT as [OriginatingDocumentAmount],
SOH.ORDRDATE as [OrderDate],
SOH.OREMSUBT as [OriginatingRemainingSubtotal],
SOH.OREXTCST as [OriginatingExtendedCost],
SOH.ORFRTAMT as [OriginatingFreightAmount],
SOH.ORFRTTAX as [OriginatingFreightTaxAmount],
SOH.ORIGNUMB as [OriginalNumber],
SOH.ORIGTYPE as [OriginalType],
SOH.ORMISCAMT as [OriginatingMiscAmount],
SOH.ORMRKDAM as [OriginatingMarkdownAmount],
SOH.ORMSCTAX as [OriginatingMiscTaxAmount],
SOH.ORNCMAMT as [OriginatingNonCommissionedAmount],
SOH.ORPMTRVD as [OriginatingPaymentReceived],
SOH.ORSUBTOT as [OriginatingSubtotal],
SOH.ORTAXAMT as [OriginatingTaxAmount],
SOH.ORTDISAM as [OriginatingTradeDiscountAmount],
SOH.OTAXTAMT as [OriginatingTaxableTaxAmount],
SOH.PCKSLPNO as [PackingSlipNumber],
SOH.PHNUMBR1 as [PhoneNumber1],
SOH.PHNUMBR2 as [PhoneNumber2],
SOH.PHONE3 as [Phone3],
SOH.PICTICNU as [PickingTicketNumber],
SOH.POSTEDDT as [PostedDate],
SOH.PRBTADCD as [PrimaryBilltoAddressCode],
SOH.PRCLEVEL as [PriceLevel],
SOH.PROSPECT as [Prospect],
SOH.PRSTADCD as [PrimaryShiptoAddressCode],
SOH.PSTGSTUS as [PostingStatus],
SOH.PTDUSRID as [PostedUserID],
SOH.PYMTRCVD as [PaymentReceived],
SOH.PYMTRMID as [PaymentTermsID],
SOH.QUOEXPDA as [QuoteExpirationDate],
SOH.QUOTEDAT as [QuoteDate],
SOH.RATETPID as [RateTypeID],
SOH.REFRENCE as [Reference],
SOH.REMSUBTO as [RemainingSubtotal],
SOH.REPTING as [Repeating],
SOH.ReqShipDate as [RequestedShipDate],
SOH.RETUDATE as [ReturnDate],
SOH.RTCLCMTD as [RateCalculationMethod],
SOH.SALEDATE as [SaleDate],
SOH.SALSTERR as [SalesTerritory],
SOH.SEQNCORR as [SequenceNumberCorrected],
SOH.SHIPCOMPLETE as [ShipCompleteDocument],
SOH.SHIPMTHD as [ShippingMethod],
SOH.ShipToName as [ShipToName],
SOH.SHPPGDOC as [ShippingDocument],
SOH.SIMPLIFD as [Simplified],
SOH.SLPRSNID as [SalespersonID],
SOH.SOPHDRE1 as [SOPHDRErrors1],
SOH.SOPHDRE2 as [SOPHDRErrors2],
SOH.SOPHDRFL as [SOPHDRFlags],
SOH.SOPLNERR as [SOPLINEErrors],
SOH.SOPNUMBE as [SOPNumber],
SOH.SOPSTATUS as [SOPStatus],
SOH.SOPTYPE as [SOPType],
SOH.STATE as [State],
SOH.SUBTOTAL as [Subtotal],
SOH.Tax_Date as [TaxDate],
SOH.TAXAMNT as [TaxAmount],
SOH.TAXEXMT1 as [TaxExempt1],
SOH.TAXEXMT2 as [TaxExempt2],
SOH.TAXSCHID as [TaxScheduleID],
SOH.TIME1 as [Time],
SOH.TIMEREPD as [TimesRepeated],
SOH.TIMESPRT as [TimesPrinted],
SOH.TIMETREP as [TimesToRepeat],
SOH.TRDISAMT as [TradeDiscountAmount],
SOH.TRDISPCT as [TradeDiscountPercent],
SOH.TRXFREQU as [TRXFrequency],
SOH.TRXSORCE as [TRXSource],
SOH.TXBTXAMT as [TaxableTaxAmount],
SOH.TXENGCLD as [TaxEngineCalled],
SOH.TXRGNNUM as [TaxRegistrationNumber],
SOH.TXSCHSRC as [TaxScheduleSource],
SOH.UPSZONE as [UPSZone],
SOH.USDOCID1 as [UseDocumentID1],
SOH.USDOCID2 as [UseDocumentID2],
SOH.USER2ENT as [UserToEnter],
SOH.VOIDSTTS as [VoidStatus],
SOH.WITHHAMT as [WithholdingAmount],
SOH.WorkflowApprStatCreditLm as [WorkflowApprovalStatusCreditLimit],
SOH.WorkflowApprStatusQuote as [WorkflowApprovalStatusQuote],
SOH.WorkflowPriorityCreditLm as [WorkflowPriorityCreditLimit],
SOH.WorkflowPriorityQuote as [WorkflowPriorityQuote],
SOH.XCHGRATE as [ExchangeRate],
SOH.ZIPCODE as [ZipCode],
(select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK)
 where ((EntityName=''SOP30200'' and Id=RTRIM(SOPNUMBE)+''|''+RTRIM(SOPTYPE)) or (EntityName=''SY03900'' and Id=CAST(SOH.NOTEINDX as varchar)))) as [LastModifiedDateTime],
 UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK)
  where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK)
 where ((EntityName=''SOP30200'' and Id=RTRIM(SOPNUMBE)+''|''+RTRIM(SOPTYPE)) or (EntityName=''SY03900'' and Id=CAST(SOH.NOTEINDX as varchar))))),'''')) as [LastModifiedBy]
FROM SOP30200 SOH with (NOLOCK) Left Outer Join SY03900 NT with (NOLOCK) on SOH.NOTEINDX=NT.NOTEINDX
WHERE SOPTYPE=2
')



IF OBJECT_ID(N'[dbo].[ScribeOnline_fnRoundByMethod]') IS NULL
       exec(' CREATE FUNCTION [dbo].[ScribeOnline_fnRoundByMethod]
       (
       @Price decimal (18,5),
       @CurrencyDecimals int,
       @EndsWithOrMultipleOf decimal (18,5), 
       @RoundMethod int, -- 1 = Multiple of, 2 = Ends in
       @RoundDirection int -- 1 = None, 2 = Up, 3 = Down, 4 = Nearest
       )
       RETURNS decimal(18,5)
BEGIN
       -- Declare the return variable here
       DECLARE @UnitPrice decimal (18,5)

       IF @RoundDirection < 2 OR @RoundDirection > 4 OR @RoundMethod < 1 Or @RoundMethod > 2 
              SET @UnitPrice = @Price
       ELSE IF @RoundDirection > 1 AND @RoundDirection <= 4
              BEGIN
              IF @RoundMethod = 1 -- Multiple of
                     Begin
                           DECLARE @Multiples bigint
                           DECLARE @MDown decimal (18,3)
                           DECLARE @MUp decimal (18,3)
                           DECLARE @pNearestM decimal (18,3)

                           SET @Multiples = @Price / @EndsWithOrMultipleOf
                           SET @MDown = @EndsWithOrMultipleOf * @Multiples
                           SET @MUp = @EndsWithOrMultipleOf * (@Multiples + 1)
                           SET @pNearestM = CASE WHEN (@MUp - @Price) > (@EndsWithOrMultipleOf /2) THEN @MDown ELSE @MUp END
                     
                           -- 1 = None, 2 = Up, 3 = Down, 4 = Nearest
                           IF @RoundDirection = 2
                                  SET @UnitPrice = @MUp
                           ELSE IF @RoundDirection = 3
                                  SET @UnitPrice = @MDown
                           ELSE
                                  SET @UnitPrice = @pNearestM
                     End
              ELSE IF @RoundMethod = 2  -- Ends in
                     Begin
                           DECLARE @pUp decimal (18,3)
                           DECLARE @pDown decimal (18,3)
                           DECLARE @pNearest decimal (18,3)
                           
                                                                                  IF @EndsWithOrMultipleOf < 1
                                                BEGIN
                                                       DECLARE @1 int
                                                       DECLARE @2 decimal (18,3)
                                                       SET @1 = Floor(@Price)
                                                       SET @2 = @1 + @EndsWithOrMultipleOf

                                                       if @2 > @Price
                                                              BEGIN  
                                                                     SET @pUp = @2
                                                                     SET @pDown = @2 - 1
                                                              END
                                                       else 
                                                              BEGIN
                                                                     SET @pUp = @2 + 1
                                                                     SET @pDown = @2
                                                              END

                                                       SET @pNearest = CASE WHEN (@pUp - @Price) > (@Price - @pDown) THEN @pDown ELSE @pUp END 
                                                END
                                         ELSE
                                                BEGIN
                                                   DECLARE @RoundToFactor decimal
                                                   DECLARE @PriceFactor decimal
                                                   DECLARE @FactorUp decimal
                                                   DECLARE @FactorDown decimal

                                                   DECLARE @Rounded bigint
                                                   DECLARE @SignificanceFactor bigint
                                                   DECLARE @EndValueDigitsFactored bigint
                                                   DECLARE @EndingFactored bigint

                                                   -- First we need to calc the significance factor
                                                   DECLARE @FactorCurrencyPlaces bigint
                                                   SET @FactorCurrencyPlaces = POWER(10, @CurrencyDecimals)
                                                   SET @RoundToFactor = @EndsWithOrMultipleOf * @FactorCurrencyPlaces
                                                   SET @EndValueDigitsFactored = LEN(LTRIM(STR(@RoundToFactor)))
                                                   DECLARE @TempSignificanceFactor int
                                                   SET @TempSignificanceFactor = POWER(10, @EndValueDigitsFactored)
                           
                                                   DECLARE @TempEndValueDigitsFactored bigint
                                                   SET @TempEndValueDigitsFactored = LEN(LTRIM(STR(@TempSignificanceFactor)))
                           
                                                   SET @SignificanceFactor = POWER(10, @TempEndValueDigitsFactored)
                                                   -- Since this is Ends With, we want to FLOOR any values in those places to zero
                                                   -- First get the relevant items into an int high enough to do that
                                                   SET @EndingFactored = @EndsWithOrMultipleOf * @SignificanceFactor
                                                   SET @PriceFactor = @Price * @SignificanceFactor
                                                   -- Floor all decimal places up to the ends with

                                                   DECLARE @FloorFactor int
                                                   SET @FloorFactor = POWER(10, LEN(LTRIM(STR(@EndingFactored))))



                                                   SET @Rounded = FLOOR(@PriceFactor / (@FloorFactor)) * @FloorFactor
                           
                                                   -- Get the values as integers factored fopr significance
                                                   SET @FactorUp = @EndingFactored + @Rounded
                                                   SET @FactorDown = @EndingFactored + @Rounded - (@SignificanceFactor * 10)

                                                   -- Bring the values back down into the correct scale
                                                   SET @pUp = @FactorUp / @SignificanceFactor
                                                   SET @pDown = @FactorDown / @SignificanceFactor
                                                   SET @pNearest = CASE WHEN (@pUp - @Price) > (@EndsWithOrMultipleOf /2) THEN @pDown ELSE @pUp END              
                                            END
                           -- 1 = None, 2 = Up, 3 = Down, 4 = Nearest
                           IF @RoundDirection = 2 
                                  SET @UnitPrice = @pUp
                           ELSE IF @RoundDirection = 3
                                  SET @UnitPrice = @pDown
                           ELSE
                                  SET @UnitPrice = @pNearest
                     End
              ELSE
                     SET @UnitPrice = -1
                     
              END
       ELSE
              SET @UnitPrice = -1
              
       RETURN @UnitPrice
END')


IF OBJECT_ID(N'[dbo].[ScribeOnline_ItemUnitPriceByMethod]') IS NULL
       exec('CREATE VIEW [dbo].[ScribeOnline_ItemUnitPriceByMethod] AS

SELECT i.ITEMNMBR, r.CURNCYID, p.PRCLEVEL, o.UOFM, p.FROMQTY, p.TOQTY,  

UnitPrice = 
CASE
      WHEN PRICMTHD = 1 THEN
              dbo.ScribeOnline_fnRoundByMethod(UOMPRICE, r.DECPLCUR, o.RNDGAMNT, o.ROUNDHOW, o.ROUNDTO)
      WHEN PRICMTHD = 2 THEN
              dbo.ScribeOnline_fnRoundByMethod(Round(LISTPRCE * p.QTYBSUOM * (UOMPRICE / 100), r.DECPLCUR - 1),  r.DECPLCUR, o.RNDGAMNT, o.ROUNDHOW, o.ROUNDTO)
      WHEN PRICMTHD = 3 THEN
              dbo.ScribeOnline_fnRoundByMethod(Round(CURRCOST * p.QTYBSUOM * (1 + (UOMPRICE / 100)), r.DECPLCUR - 1), r.DECPLCUR, o.RNDGAMNT, o.ROUNDHOW, o.ROUNDTO)
      WHEN PRICMTHD = 4 THEN
              dbo.ScribeOnline_fnRoundByMethod(Round(STNDCOST * p.QTYBSUOM * (1 + (UOMPRICE / 100)), r.DECPLCUR - 1), r.DECPLCUR, o.RNDGAMNT, o.ROUNDHOW, o.ROUNDTO)
      WHEN PRICMTHD = 5 THEN
              dbo.ScribeOnline_fnRoundByMethod(Round(CURRCOST * p.QTYBSUOM / (1 - (UOMPRICE / 100)), r.DECPLCUR - 1), r.DECPLCUR, o.RNDGAMNT, o.ROUNDHOW, o.ROUNDTO)
      WHEN PRICMTHD = 6 THEN
              dbo.ScribeOnline_fnRoundByMethod(Round(STNDCOST * p.QTYBSUOM / (1 - (UOMPRICE / 100)), r.DECPLCUR - 1), r.DECPLCUR, o.RNDGAMNT, o.ROUNDHOW, o.ROUNDTO)
      ELSE 0
END

FROM dbo.IV00101 i /* Item Master */ with (NOLOCK) 
JOIN dbo.IV00105 r /* Item Currency Master */ with (NOLOCK) on r.ITEMNMBR = i.ITEMNMBR
JOIN dbo.IV00108 p /* Item Price List */ with (NOLOCK) on p.ITEMNMBR = i.ITEMNMBR AND p.CURNCYID = r.CURNCYID
JOIN dbo.IV00107 o with (NOLOCK) on o.ITEMNMBR = p.ITEMNMBR 
AND o.CURNCYID = p.CURNCYID 
AND o.PRCLEVEL = p.PRCLEVEL 
AND o.UOFM = p.UOFM
')


/****** Object:  StoredProcedure [dbo].[ScribeOnline_GetNextCustomerNumber]    Script Date: 6/7/2013 2:30:02 PM ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ScribeOnline_GetNextCustomerNumber]') AND type in (N'P', N'PC'))
EXEC ( N'-- =============================================
-- Author:           <Author,,Name>
-- Create date: <Create Date,,>
-- Description:      <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ScribeOnline_GetNextCustomerNumber] 
       -- Add the parameters for the stored procedure here
       @Prefix NVARCHAR (15), 
       @DecimalsOnRight int,
       @RetVal as NVARCHAR(15) out
AS
BEGIN
       -- SET NOCOUNT ON added to prevent extra result sets from
       -- interfering with SELECT statements.

	   SET NOCOUNT ON;

       DECLARE @highNumber int
       DECLARE @templateLength varchar (15)
       DECLARE @lastIndexGenerated int;

	   SET @templateLength = LEN(@Prefix + REPLICATE(''0'', @DecimalsOnRight))
           select @highNumber = (SELECT TOP 1 MAX(
										CASE 
										WHEN ISNUMERIC(RIGHT(RTRIM([CUSTNMBR]), @DecimalsOnRight)) = 1 THEN 
										     CAST(RIGHT(RTRIM([CUSTNMBR]), @DecimalsOnRight) as int)
										ELSE
											0 END) +1)
							 FROM 
							 RM00101 
							 WHERE                               
                                  LEN(RTRIM([CUSTNMBR])) >= @DecimalsOnRight
                                  AND
								  LEN(RTRIM([CUSTNMBR])) = @templateLength
								  AND
                                  @Prefix = LEFT([CUSTNMBR], LEN(RTRIM([CUSTNMBR])) - @DecimalsOnRight)
							 
							 
								  

select @lastIndexGenerated = CAST(LastIndexGenerated as int) from ScribeOnline_NextAvailableNumber WHERE EntityName=''CUSTOMER'' and Prefix = @Prefix and NumberOfDigits = @DecimalsOnRight

  IF @highNumber is NULL
       SET @highNumber = 1	  

  IF @lastIndexGenerated is NULL
	SET @lastIndexGenerated = 0	

IF (( @lastIndexGenerated < @highNumber AND LEN(@highNumber) > @DecimalsOnRight) or (@highNumber <=  @lastIndexGenerated AND LEN(@lastIndexGenerated + 1) > @DecimalsOnRight))
	BEGIN
		SET @RetVal = NULL
		RAISERROR (''Unable to generate the key because the result exceeded the number of digits specified.'',16,1)
	END

	ELSE
BEGIN		
  IF  @lastIndexGenerated < @highNumber
		
		IF @lastIndexGenerated = 0
			INSERT INTO ScribeOnline_NextAvailableNumber VALUES(''CUSTOMER'', @Prefix, @DecimalsOnRight, RIGHT(REPLICATE(''0'', @DecimalsOnRight) + CAST(@highNumber as NVARCHAR), @DecimalsOnRight))
		ELSE
			UPDATE ScribeOnline_NextAvailableNumber SET LastIndexGenerated=RIGHT(REPLICATE(''0'', @DecimalsOnRight) + CAST(@highNumber as NVARCHAR), @DecimalsOnRight) where EntityName = ''CUSTOMER'' and Prefix = @Prefix	and NumberOfDigits = @DecimalsOnRight								
	ELSE 
		BEGIN
			Set @highNumber = @lastIndexGenerated + 1
			UPDATE ScribeOnline_NextAvailableNumber SET LastIndexGenerated=RIGHT(REPLICATE(''0'', @DecimalsOnRight) + CAST(@highNumber as NVARCHAR), @DecimalsOnRight) where EntityName = ''CUSTOMER'' and Prefix = @Prefix	and NumberOfDigits = @DecimalsOnRight								
		END	

    
    SET @RetVal = @Prefix + RIGHT(REPLICATE(''0'', @DecimalsOnRight) + CAST(@highNumber as NVARCHAR), @DecimalsOnRight)	
END

END')




/****** Object:  StoredProcedure [dbo].[ScribeOnline_GetNextVendorID]    Script Date: 11/19/2013 1:38:58 PM ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ScribeOnline_GetNextVendorID]') AND type in (N'P', N'PC'))
EXEC ( N'

-- =============================================
-- Author:           <Author,,Name>
-- Create date: <Create Date,,>
-- Description:      <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ScribeOnline_GetNextVendorID] 
       -- Add the parameters for the stored procedure here
       @Prefix NVARCHAR (15), 
       @DecimalsOnRight int,
       @RetVal as NVARCHAR(15) out
AS
BEGIN
       -- SET NOCOUNT ON added to prevent extra result sets from
       -- interfering with SELECT statements.
       SET NOCOUNT ON;

       DECLARE @highNumber int
       DECLARE @templateLength varchar (15)
       DECLARE @lastIndexGenerated int;

	   SET @templateLength = LEN(@Prefix + REPLICATE(''0'', @DecimalsOnRight))
	       select @highNumber = (SELECT TOP 1 MAX(
										CASE 
										WHEN ISNUMERIC(RIGHT(RTRIM([VENDORID]), @DecimalsOnRight)) = 1 THEN 
										     CAST(RIGHT(RTRIM([VENDORID]), @DecimalsOnRight) as int)
										ELSE
											0 END) +1)
							 FROM 
							 PM00200 
							 WHERE                               
                                  LEN(RTRIM([VENDORID])) >= @DecimalsOnRight
                                  AND
								  LEN(RTRIM([VENDORID])) = @templateLength
								  AND
                                  @Prefix = LEFT([VENDORID], LEN(RTRIM([VENDORID])) - @DecimalsOnRight)
							 
							 
								  

select @lastIndexGenerated = CAST(LastIndexGenerated as int) from ScribeOnline_NextAvailableNumber WHERE EntityName=''VENDOR'' and Prefix = @Prefix and NumberOfDigits = @DecimalsOnRight

  IF @highNumber is NULL
       SET @highNumber = 1	  

  IF @lastIndexGenerated is NULL
	SET @lastIndexGenerated = 0	

IF (( @lastIndexGenerated < @highNumber AND LEN(@highNumber) > @DecimalsOnRight) or (@highNumber <=  @lastIndexGenerated AND LEN(@lastIndexGenerated + 1) > @DecimalsOnRight))
	BEGIN
		SET @RetVal = NULL
		RAISERROR (''Unable to generate the key because the result exceeded the number of digits specified.'',16,1)
	END

	ELSE
BEGIN		
  IF  @lastIndexGenerated < @highNumber
		
		IF @lastIndexGenerated = 0
			INSERT INTO ScribeOnline_NextAvailableNumber VALUES(''VENDOR'', @Prefix, @DecimalsOnRight, RIGHT(REPLICATE(''0'', @DecimalsOnRight) + CAST(@highNumber as NVARCHAR), @DecimalsOnRight))
		ELSE
			UPDATE ScribeOnline_NextAvailableNumber SET LastIndexGenerated=RIGHT(REPLICATE(''0'', @DecimalsOnRight) + CAST(@highNumber as NVARCHAR), @DecimalsOnRight) where EntityName = ''VENDOR'' and Prefix = @Prefix	and NumberOfDigits = @DecimalsOnRight								
	ELSE 
		BEGIN
			Set @highNumber = @lastIndexGenerated + 1
			UPDATE ScribeOnline_NextAvailableNumber SET LastIndexGenerated=RIGHT(REPLICATE(''0'', @DecimalsOnRight) + CAST(@highNumber as NVARCHAR), @DecimalsOnRight) where EntityName = ''VENDOR'' and Prefix = @Prefix	and NumberOfDigits = @DecimalsOnRight								
		END	

   
    SET @RetVal = @Prefix + RIGHT(REPLICATE(''0'', @DecimalsOnRight) + CAST(@highNumber as NVARCHAR), @DecimalsOnRight)

END
END

')



IF OBJECT_ID(N'[dbo].[ScribeOnline_Version]') IS NULL
	exec('CREATE TABLE [dbo].[ScribeOnline_Version](
	[ConnectorMajor] [int] NOT NULL,
	[ConnectorMinor] [int] NOT NULL,
	[ConnectorBuild] [int] NOT NULL,
	[ConnectorRevision] [int] NOT NULL,
	[AssemblyMajor] [int] NOT NULL,
	[AssemblyMinor] [int] NOT NULL,
	[AssemblyBuild] [int] NOT NULL,
	[AssemblyRevision] [int] NOT NULL,
	[FileMajor] [int] NOT NULL,
	[FileMinor] [int] NOT NULL,
	[FileBuild] [int] NOT NULL,
	[FileRevision] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL
) ON [PRIMARY]')


IF OBJECT_ID(N'[dbo].[ScribeOnline_ReceivablesBase]') IS NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_ReceivablesBase] AS 
select 
	1 "TrxState", -- WORK 
	RM10301.RMDTYPAL, 
	RMDNUMWK "DOCNUMBR", 
	DOCDESCR, 
	RM10301.DOCDATE, 
	BACHNUMB, 
	BCHSOURC,	 
	(SELECT CREATDDT FROM SY00500 with (NOLOCK) WHERE RM10301.BACHNUMB = SY00500.BACHNUMB AND RM10301.BCHSOURC = SY00500.BCHSOURC) AS BatchCreatedDate, 
	(SELECT TIME1 FROM SY00500 with (NOLOCK) WHERE RM10301.BACHNUMB = SY00500.BACHNUMB AND RM10301.BCHSOURC = SY00500.BCHSOURC) AS BatchCreatedTime, 
	RM10301.CUSTNMBR, 
	ADRSCODE, 
	SLPRSNID, 
	SALSTERR, 
	SHIPMTHD, 
	CSTPONBR, 
	CUSTNAME, 
	TAXSCHID, 
	SLSCHDID, 
	FRTSCHID, 
	MSCSCHID, 
	COSTAMNT, 
	MC020102.ORCSTAMT, 
	SLSAMNT, 
	MC020102.ORSLSAMT, 
	TRDISAMT, 
	ORTDISAM, 
	FRTAMNT, 
	MC020102.ORFRTAMT, 
	MISCAMNT, 
	MC020102.ORMISCAMT, 
	TAXAMNT, 
	MC020102.ORTAXAMT, 
	RM10301.CURNCYID, 
	GLPOSTDT, 
	POSTEDDT, 
	PTDUSRID, 
	Electronic, 
	ECTRX, 
	DIRECTDEBIT, 
	MC020102.XCHGRATE, 
	MC020102.EXCHDATE, 
	DOCAMNT "ORTRXAMT", 
	MC020102.ORORGTRX, 
	0 "CURTRXAM", 
	MC020102.ORCTRXAM, 
	PYMTRMID, 
	DUEDATE, 
	DISCDATE, 
	'''' "CPRCSTNM", 
	'''' "TRXSORCE", 
	'''' "DINVPDOF", 
	0 "DELETE1", 
	0 "VOIDSTTS", 
	''1900-01-01 00:00:00.000'' "VOIDDATE", 
	RM10301.DEX_ROW_TS, 
	LSTUSRED, 
 
	-- The following columns are for Receivables Debit Document and Return 
	CASHAMNT, 
	MC020102.ORCASAMT, 
	CBKIDCSH,  
	CASHDATE,                                           
	DCNUMCSH,               
	CHEKAMNT, 
	MC020102.ORCHKAMT, 
	CBKIDCHK, 
	CBKIDCRD, 
	CHEKNMBR,  
	CHEKDATE,                                           
	DCNUMCHK,               
	CRCRDAMT, 
	MC020102.ORCCDAMT, 
	CRCRDNAM,        
	RCTNCCRD,               
	CRCARDDT,                                               
	DCNUMCRD,  
 
	-- Debit Document Only, not used for return 
	DISTKNAM,   
	MC020102.ORDISTKN, 
	DISAVTKN, 
	MC020102.ORDATKN, 
	WROFAMNT,  
	MC020102.ORWROFAM, 
	GSTDSAMT, 
	-- Already referenced PYMTRMID,  
	DISAVAMT, 
	MC020102.ORDAVAMT, 
	-- Already referenced DISCDATE,  
	-- Already referenced DUEDATE,   
	DSCPCTAM, 
	DSCDLRAM,  
	MC020102.ORDDLRAT, 
 
	-- The following columns are for Receivables Invoice/Receivables Debit Memo/Service Repair/Return 
	COMAPPTO, 
	COMDLRAM, 
	MC020102.ORCOMAMT, 
 
	-- The following columns are for Receivables Credit Document 
	DISCRTND, 
	MC020102.ORDISRTD, 
	RM10301.DEX_ROW_ID,
	LSTEDTDT,
	BKTSLSAM,
	BKTFRTAM,
	BKTMSCAM,
	PPSAMDED,
	Tax_Date,
	APLYWITH,
	SALEDATE,
	CORRCTN,
	SIMPLIFD,
	BackoutTradeDisc,
	EFTFLAG 
from  
	RM10301 with (NOLOCK) left outer join MC020102 with (NOLOCK) on (	RM10301.RMDTYPAL = MC020102.RMDTYPAL and  
						RM10301.RMDNUMWK = MC020102.DOCNUMBR) 
 
union all 
 
select 
	2 "TrxState", -- OPEN 
	RM20101.RMDTYPAL, 
	RM20101.DOCNUMBR, 
	TRXDSCRN "DOCDESCR", 
	RM20101.DOCDATE, 
	BACHNUMB, 
	BCHSOURC, 
	'''', --BatchCreatedDate 
	'''', --BatchCreatedTime 
	RM20101.CUSTNMBR, 
	'''' "ADRSCODE", 
	SLPRSNID, 
	SLSTERCD "SALSTERR", 
	SHIPMTHD, 
	CSPORNBR "CSTPONBR", 
	(select CUSTNAME from RM00101 with (NOLOCK) where RM00101.CUSTNMBR = RM20101.CUSTNMBR) "CUSTNAME", 
	TAXSCHID, 
	SLSCHDID, 
	FRTSCHID, 
	MSCSCHID, 
	COSTAMNT, 
	MC020102.ORCSTAMT, 
	SLSAMNT, 
	MC020102.ORSLSAMT, 
	TRDISAMT, 
	ORTDISAM, 
	FRTAMNT, 
	MC020102.ORFRTAMT, 
	MISCAMNT, 
	MC020102.ORMISCAMT, 
	TAXAMNT, 
	MC020102.ORTAXAMT, 
	RM20101.CURNCYID, 
	GLPOSTDT, 
	POSTDATE "POSTEDDT", 
	PSTUSRID "PTDUSRID", 
	Electronic, 
	ECTRX, 
	DIRECTDEBIT, 
	MC020102.XCHGRATE, 
	MC020102.EXCHDATE, 
	ORTRXAMT, 
	MC020102.ORORGTRX, 
	CURTRXAM, 
	MC020102.ORCTRXAM, 
	PYMTRMID, 
	DUEDATE, 
	DISCDATE, 
	CPRCSTNM, 
	RM20101.TRXSORCE, 
	DINVPDOF, 
	DELETE1, 
	VOIDSTTS, 
	VOIDDATE, 
	RM20101.DEX_ROW_TS, 
	LSTUSRED, 
 
	-- The following columns are for Receivables Debit Document and Return 
	CASHAMNT,  
	MC020102.ORCASAMT, 
	CBKIDCSH,  
	''1900-01-01 00:00:00.000'' "CASHDATE",                                          
	'''' "DCNUMCSH",     	       
	0.00 "CHEKAMNT",  
	MC020102.ORCHKAMT, 
	CBKIDCHK,  
	CBKIDCRD, 
	CHEKNMBR,  
	''1900-01-01 00:00:00.000'' "CHEKDATE",                                       
	'''' "DCNUMCHK",             
	0.00 "CRCRDAMT",             
	MC020102.ORCCDAMT, 
	'''' "CRCRDNAM",      
	'''' "RCTNCCRD",             
	''1900-01-01 00:00:00.000'' "CRCARDDT",                                           
	'''' "DCNUMCRD", 
 
	-- Debit Document Only, not used for return 
	DISTKNAM, 
	MC020102.ORDISTKN, 
	DISAVTKN, 
	MC020102.ORDATKN, 
	WROFAMNT,    
	MC020102.ORWROFAM, 
	GSTDSAMT, 
	-- Already referenced PYMTRMID,  
	DISAVAMT, 
	MC020102.ORDAVAMT, 
	-- Already referenced DISCDATE,  
	-- Already referenced DUEDATE,   
	DSCPCTAM, 
	DSCDLRAM, 
	MC020102.ORDDLRAT, 
 
	-- The following columns are for Receivables Invoice/Receivables Debit Memo/Service Repair/Return 
	0 "COMAPPTO", 
	COMDLRAM, 
	MC020102.ORCOMAMT, 
 
	-- The following columns are for Receivables Credit Document 
	DISCRTND, 
	MC020102.ORDISRTD, 
	RM20101.DEX_ROW_ID,
	LSTEDTDT,
	BKTSLSAM,
	BKTFRTAM,
	BKTMSCAM,
	PPSAMDED,
	Tax_Date,
	APLYWITH,
	SALEDATE,
	CORRCTN,
	SIMPLIFD,
	BackoutTradeDisc,
	EFTFLAG 
 
from  
	RM20101 with (NOLOCK) left outer join MC020102 with (NOLOCK) on (	RM20101.RMDTYPAL = MC020102.RMDTYPAL and  
						RM20101.DOCNUMBR = MC020102.DOCNUMBR) 
 
union all 
 
select 
	3 "TrxState", -- HISTORY 
	RM30101.RMDTYPAL, 
	RM30101.DOCNUMBR, 
	TRXDSCRN "DOCDESCR", 
	RM30101.DOCDATE, 
	BACHNUMB, 
	BCHSOURC, 
	'''', --BatchCreatedDate 
	'''', --BatchCreatedTime 
	RM30101.CUSTNMBR, 
	'''' "ADRSCODE", 
	SLPRSNID, 
	SLSTERCD "SALSTERR", 
	SHIPMTHD, 
	CSPORNBR "CSTPONBR", 
	(select CUSTNAME from RM00101 with (NOLOCK) where RM00101.CUSTNMBR = RM30101.CUSTNMBR) "CUSTNAME", 
	TAXSCHID, 
	SLSCHDID, 
	FRTSCHID, 
	MSCSCHID, 
	COSTAMNT, 
	MC020102.ORCSTAMT, 
	SLSAMNT, 
	MC020102.ORSLSAMT, 
	TRDISAMT, 
	ORTDISAM, 
	FRTAMNT, 
	MC020102.ORFRTAMT, 
	MISCAMNT, 
	MC020102.ORMISCAMT, 
	TAXAMNT, 
	MC020102.ORTAXAMT, 
	RM30101.CURNCYID, 
	GLPOSTDT, 
	POSTDATE "POSTEDDT", 
	PSTUSRID "PTDUSRID", 
	Electronic, 
	ECTRX, 
	DIRECTDEBIT, 
	MC020102.XCHGRATE, 
	MC020102.EXCHDATE, 
	ORTRXAMT, 
	MC020102.ORORGTRX, 
	CURTRXAM, 
	MC020102.ORCTRXAM, 
	PYMTRMID, 
	DUEDATE, 
	DISCDATE, 
	CPRCSTNM, 
	RM30101.TRXSORCE, 
	DINVPDOF, 
	DELETE1, 
	VOIDSTTS, 
	VOIDDATE, 
	RM30101.DEX_ROW_TS, 
	LSTUSRED, 
 
	-- The following columns are for Receivables Debit Document and Return 
	CASHAMNT, 
	MC020102.ORCASAMT,  
	'''' "CBKIDCSH",   
	''1900-01-01 00:00:00.000'' "CASHDATE",                                       
	'''' "DCNUMCSH",             
	0.00 "CHEKAMNT", 	 
	MC020102.ORCHKAMT, 
	'''' "CBKIDCHK",        
	'''' "CBKIDCRD",  
	CHEKNMBR,  	 
	''1900-01-01 00:00:00.000'' "CHEKDATE",                                        
	'''' "DCNUMCHK",             
	0.00 "CRCRDAMT",             
	MC020102.ORCCDAMT, 
	'''' "CRCRDNAM",      
	'''' "RCTNCCRD",    
	''1900-01-01 00:00:00.000'' "CRCARDDT",                                             
	'''' "DCNUMCRD",           
	DISTKNAM,      
	MC020102.ORDISTKN,   
 
	-- Debit Document Only, not used for return 
	DISTKNAM "DISAVTKN", 
	MC020102.ORDATKN, 
	WROFAMNT, 
	MC020102.ORWROFAM, 
	GSTDSAMT,   
	-- Already referenced PYMTRMID,   
	DISAVAMT,  
	MC020102.ORDAVAMT, 
	-- Already referenced DISCDATE,   
	-- Already referenced DUEDATE,     
	DSCPCTAM, 
	DSCDLRAM, 
	MC020102.ORDDLRAT,   
 
	-- The following columns are for Receivables Invoice/Receivables Debit Memo/Service Repair/Return 
	0 "COMAPPTO", 
	COMDLRAM, 
	MC020102.ORCOMAMT, 
 
	-- The following columns are for Receivables Credit Document 
	DISCRTND, 
	MC020102.ORDISRTD, 
	RM30101.DEX_ROW_ID,
	LSTEDTDT,
	BKTSLSAM,
	BKTFRTAM,
	BKTMSCAM,
	PPSAMDED,
	Tax_Date,
	APLYWITH,
	SALEDATE,
	CORRCTN,
	SIMPLIFD,
	BackoutTradeDisc,
	EFTFLAG 
from  
	RM30101 with (NOLOCK) left outer join MC020102 with (NOLOCK) on (	RM30101.RMDTYPAL = MC020102.RMDTYPAL and  
						RM30101.DOCNUMBR = MC020102.DOCNUMBR) 
 ')
 
 IF OBJECT_ID(N'[dbo].[ScribeOnline_ReceivablesDistributionBase]') IS NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_ReceivablesDistributionBase] AS 
select 
	CASE POSTED WHEN 1 THEN 2 ELSE 1
		END       
   "TrxState", -- OPEN or Work
	RMDTYPAL, 
	DOCNUMBR, 
	SEQNUMBR, 
	DISTTYPE, 
	DistRef, 
	DSTINDX,
	(select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = RM10101.DSTINDX) "ACTNUMST", 
	DEBITAMT, 
	ORDBTAMT, 
	CRDTAMNT, 
	ORCRDAMT, 
	POSTED,
	CUSTNMBR,
	TRXSORCE,
	POSTEDDT,
	PSTGSTUS,
	CHANGED,
	DCSTATUS,
	PROJCTID,
	USERID,
	CATEGUSD,
	CURNCYID,
	CURRNIDX
	
from 
	RM10101 with (NOLOCK) 
 
union all 
 
select 
	3 "TrxState", -- History
	RMDTYPAL, 
	DOCNUMBR, 
	SEQNUMBR, 
	DISTTYPE, 
	DistRef,
	DSTINDX, 
	(select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = RM30301.DSTINDX) "ACTNUMST", 
	DEBITAMT, 
	ORDBTAMT, 
	CRDTAMNT, 
	ORCRDAMT, 
	1 "POSTED",
	CUSTNMBR,
	TRXSORCE,
	POSTEDDT,
	NULL as "PSTGSTUS",
	NULL as "CHANGED",
	NULL as "DCSTATUS",
	PROJCTID,
	USERID,
	CATEGUSD,
	CURNCYID,
	CURRNIDX
	
	from  
		RM30301 with (NOLOCK) 
	')


IF OBJECT_ID(N'[dbo].[ScribeOnline_ReceivablesTaxBase]') IS NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_ReceivablesTaxBase] AS 

select 
CASE POSTED WHEN 1 THEN 2 ELSE 1
		END       
   "TrxState", -- OPEN or Work
	RMDTYPAL, 
	DOCNUMBR, 
	TAXDTLID,        
	(select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = RM10601.ACTINDX) "ACTNUMST", 
	TAXAMNT, 
	ORTAXAMT, 
	STAXAMNT,               
	ORSLSTAX,               
	FRTTXAMT,               
	ORFRTTAX,               
	MSCTXAMT,               
	ORMSCTAX,               
	TAXDTSLS,               
	ORTOTSLS,              
	TDTTXSLS,               
	ORTXSLS,                
	BKOUTTAX,
	TRXSORCE,
	ACTINDX,
	BACHNUMB,
	CUSTNMBR
	  
 
from  
	RM10601  with (NOLOCK) 
 
union all 
 
select  
    3 "TrxState", -- History
	RMDTYPAL, 
	DOCNUMBR, 
	TAXDTLID,        
	(select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = RM30601.ACTINDX) "ACTNUMST", 
	TAXAMNT, 
	ORTAXAMT, 
	STAXAMNT,               
	ORSLSTAX,               
	FRTTXAMT,               
	ORFRTTAX,               
	MSCTXAMT,               
	ORMSCTAX,               
	TAXDTSLS,               
	ORTOTSLS,              
	TDTTXSLS,               
	ORTXSLS,                
	0 "BKOUTTAX",
	TRXSORCE,
	ACTINDX,
	BACHNUMB,
	CUSTNMBR 
 
from  
	RM30601 with (NOLOCK) ')



IF OBJECT_ID(N'[dbo].[ScribeOnline_PayablesBase]') IS NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_PayablesBase] AS 
select 
	1 "TrxState", -- WORK 
	BACHNUMB, 
	BCHSOURC, 
	(SELECT CREATDDT FROM SY00500 with (NOLOCK) WHERE PM10000.BACHNUMB = SY00500.BACHNUMB AND PM10000.BCHSOURC = SY00500.BCHSOURC) "BatchCreatedDate", 
	(SELECT TIME1 FROM SY00500 with (NOLOCK) WHERE PM10000.BACHNUMB = SY00500.BACHNUMB AND PM10000.BCHSOURC = SY00500.BCHSOURC) "BatchCreatedTime", 
	PM10000.VCHNUMWK "VCHRNMBR", 
	PM10000.VENDORID, 
	(select VENDNAME from PM00200 with (NOLOCK) where PM00200.VENDORID = PM10000.VENDORID) "VENDNAME", 
	DOCNUMBR, 
	PM10000.DOCTYPE, 
	PM10000.DOCDATE, 
	VADDCDPR, 
	VADCDTRO, 
	TAXSCHID, 
	TRXDSCRN, 
	PRCHAMNT, 
	MC020103.OPURAMT, 
	TRDISAMT, 
	MC020103.ORTDISAM, 
	TAXAMNT, 
	MC020103.ORTAXAMT, 
	FRTAMNT, 
	MC020103.OMISCAMT, 
	MSCCHAMT, 
	MC020103.ORFRTAMT, 
	DOCAMNT, 
	MC020103.ORDOCAMT, 
	CHRGAMNT, 
	MC020103.OCHGAMT, 
	TEN99AMNT, 
	MC020103.OR1099AM, 
	MC020103.XCHGRATE, 
	MC020103.EXCHDATE, 
	PORDNMBR, 
	SHIPMTHD, 
	PCHSCHID, 
	FRTSCHID, 
	MSCSCHID, 
	Tax_Date, 
	PM10000.CURNCYID, 
	PM10000.DEX_ROW_TS, 
	MDFUSRID, 
	POSTEDDT, 
	PTDUSRID, 
	'''' "TRXSORCE", 
	PSTGDATE, 
	0 "VOIDED", 
	ICDISTS, 
	ICTRX,                            
	PYMTRMID, 
	DUEDATE, 
	DSCDLRAM, 
	MC020103.ORDDLRAT, 
	PRCTDISC, 
	DISCDATE, 
	DISAMTAV, 
	MC020103.ODISAMTAV, 
	DISTKNAM, 
	MC020103.ORDISTKN, 
	APDSTKAM, 
	MC020103.ORGAPDISCTKN, 
	WROFAMNT, 
	MC020103.ORWROFAM, 
	CASHAMNT, 
	MC020103.ORCASAMT, 
	CAMCBKID, 
	CDOCNMBR, 
	CAMTDATE, 
	CAMPMTNM, 
	CHEKAMNT, 
	MC020103.ORCHKTTL, 
	CHAMCBID, 
	CHEKDATE, 
	CAMPYNBR, 
	CHEKNMBR, 
	CRCRDAMT, 
	MC020103.ORCCDAMT, 
	CCAMPYNM, 
	CARDNAME, 
	CCRCTNUM, 
	CRCARDDT, 
	0 "TTLPYMTS",             
	MC020103.OTOTPAY, 
	PM10000.DEX_ROW_ID,
	Electronic,
	MODIFDT,
	ECTRX,
	APLYWITH,
	CNTRLTYP,
	BKTFRTAM,
	BKTMSCAM,
	BKTPURAM,
	RETNAGAM,
	PRCHDATE,
	CORRCTN,
	SIMPLIFD 
from  
	PM10000 with (NOLOCK) left outer join MC020103 with (NOLOCK) on (PM10000.VCHNUMWK = MC020103.VCHRNMBR and PM10000.DOCTYPE = MC020103.DOCTYPE) 
 
union all 
 
select 
	2 "TrxState", -- OPEN 
	BACHNUMB, 
	BCHSOURC, 
	'''', --BatchCreatedDate 
	'''', --BatchCreatedTime 
	PM20000.VCHRNMBR, 
	PM20000.VENDORID, 
	(select VENDNAME from PM00200 with (NOLOCK) where PM00200.VENDORID = PM20000.VENDORID) "VENDNAME", 
	DOCNUMBR, 
	PM20000.DOCTYPE, 
	PM20000.DOCDATE, 
	'''', -- "VADDCDPR" 
	VADCDTRO, 
	TAXSCHID, 
	TRXDSCRN, 
	PRCHAMNT, 
	MC020103.OPURAMT, 
	TRDISAMT, 
	MC020103.ORTDISAM, 
	TAXAMNT, 
	MC020103.ORTAXAMT, 
	FRTAMNT, 
	MC020103.OMISCAMT, 
	MSCCHAMT, 
	MC020103.ORFRTAMT, 
	DOCAMNT, 
	MC020103.ORDOCAMT, 
	0.00, -- "CHRGAMNT" 
	MC020103.OCHGAMT, 
	TEN99AMNT, 
	MC020103.OR1099AM, 
	MC020103.XCHGRATE, 
	MC020103.EXCHDATE, 
	PORDNMBR, 
	SHIPMTHD, 
	PCHSCHID, 
	FRTSCHID, 
	MSCSCHID, 
	Tax_Date, 
	PM20000.CURNCYID, 
	PM20000.DEX_ROW_TS, 
	MDFUSRID, 
	POSTEDDT, 
	PTDUSRID, 
	TRXSORCE, 
	PSTGDATE, 
	VOIDED, 
	NULL, -- "ICDISTS" 
	ICTRX,                            
	PYMTRMID, 
	DUEDATE, 
	DSCDLRAM, 
	MC020103.ORDDLRAT, 
	PRCTDISC, 
	DISCDATE, 
	DISAMTAV, 
	MC020103.ODISAMTAV, 
	DISTKNAM, 
	MC020103.ORDISTKN, 
	0.00, -- "APDSTKAM" 
	MC020103.ORGAPDISCTKN, 
	WROFAMNT, 
	MC020103.ORWROFAM, 
	0.00, -- "CASHAMNT" 
	MC020103.ORCASAMT, 
	'''', -- "CAMCBKID" 
	'''', -- "CDOCNMBR" 
	''1900-01-01 00:00:00.000'', --  "CAMTDATE" 
	'''', --  "CAMPMTNM" 
	0.00, -- "CHEKAMNT" 
	MC020103.ORCHKTTL, 
	'''', -- "CHAMCBID" 
	''1900-01-01 00:00:00.000'', -- "CHEKDATE" 
	'''', -- "CAMPYNBR" 
	'''', -- "CHEKNMBR" 
	0.00, -- "CRCRDAMT" 
	MC020103.ORCCDAMT, 
	'''', -- "CCAMPYNM" 
	CARDNAME, 
	'''', -- "CCRCTNUM" 
	''1900-01-01 00:00:00.000'', -- "CRCARDDT" 
	TTLPYMTS,             
	MC020103.OTOTPAY, 
	PM20000.DEX_ROW_ID,
	Electronic,
	MODIFDT ,
	ECTRX,
	APLYWITH,
	CNTRLTYP,
	BKTFRTAM,
	BKTMSCAM,
	BKTPURAM,
	RETNAGAM,
	PRCHDATE,
	CORRCTN,
	SIMPLIFD
from  
	PM20000 with (NOLOCK) left outer join MC020103 with (NOLOCK) on (PM20000.VCHRNMBR = MC020103.VCHRNMBR and PM20000.DOCTYPE = MC020103.DOCTYPE) 
 
union all 
 
select 
	3 "TrxState", -- HISTORY 
	BACHNUMB, 
	BCHSOURC, 
	'''', --BatchCreatedDate 
	'''', --BatchCreatedTime 
	PM30200.VCHRNMBR, 
	PM30200.VENDORID, 
	(select VENDNAME from PM00200 with (NOLOCK) where PM00200.VENDORID = PM30200.VENDORID) "VENDNAME", 
	DOCNUMBR, 
	PM30200.DOCTYPE, 
	PM30200.DOCDATE, 
	'''', -- "VADDCDPR" 
	VADCDTRO, 
	TAXSCHID, 
	TRXDSCRN, 
	PRCHAMNT, 
	MC020103.OPURAMT, 
	TRDISAMT, 
	MC020103.ORTDISAM, 
	TAXAMNT, 
	MC020103.ORTAXAMT, 
	FRTAMNT, 
	MC020103.OMISCAMT, 
	MSCCHAMT, 
	MC020103.ORFRTAMT, 
	DOCAMNT, 
	MC020103.ORDOCAMT, 
	0.00, -- "CHRGAMNT" 
	MC020103.OCHGAMT, 
	TEN99AMNT, 
	MC020103.OR1099AM, 
	MC020103.XCHGRATE, 
	MC020103.EXCHDATE, 
	PORDNMBR, 
	SHIPMTHD, 
	PCHSCHID, 
	FRTSCHID, 
	MSCSCHID, 
	Tax_Date, 
	PM30200.CURNCYID, 
	PM30200.DEX_ROW_TS, 
	MDFUSRID, 
	POSTEDDT, 
	PTDUSRID, 
	TRXSORCE, 
	PSTGDATE, 
	VOIDED, 
	NULL, -- "ICDISTS" 
	ICTRX,                            
	PYMTRMID, 
	DUEDATE, 
	DSCDLRAM, 
	MC020103.ORDDLRAT, 
	PRCTDISC, 
	DISCDATE, 
	DISAMTAV, 
	MC020103.ODISAMTAV, 
	DISTKNAM, 
	MC020103.ORDISTKN, 
	0.00, -- "APDSTKAM" 
	MC020103.ORGAPDISCTKN, 
	WROFAMNT, 
	MC020103.ORWROFAM, 
	0.00, -- "CASHAMNT" 
	MC020103.ORCASAMT, 
	'''', -- "CAMCBKID" 
	'''', -- "CDOCNMBR" 
	''1900-01-01 00:00:00.000'', -- "CAMTDATE" 
	'''', -- "CAMPMTNM" 
	0.00, -- "CHEKAMNT" 
	MC020103.ORCHKTTL, 
	'''', -- "CHAMCBID" 
	''1900-01-01 00:00:00.000'', -- "CHEKDATE" 
	'''', -- "CAMPYNBR" 
	'''', -- "CHEKNMBR" 
	0.00, -- "CRCRDAMT" 
	MC020103.ORCCDAMT, 
	'''', -- "CCAMPYNM" 
	CARDNAME, 
	'''', -- "CCRCTNUM" 
	''1900-01-01 00:00:00.000'', -- "CRCARDDT" 
	TTLPYMTS,             
	MC020103.OTOTPAY, 
	PM30200.DEX_ROW_ID,
	Electronic,
	MODIFDT,
	ECTRX,
	APLYWITH,
	CNTRLTYP,
	BKTFRTAM,
	BKTMSCAM,
	BKTPURAM,
	RETNAGAM,
	PRCHDATE,
	CORRCTN,
	SIMPLIFD
from  
	PM30200 with (NOLOCK) left outer join MC020103 with (NOLOCK) on (PM30200.VCHRNMBR = MC020103.VCHRNMBR and PM30200.DOCTYPE = MC020103.DOCTYPE)
	')
IF OBJECT_ID(N'[dbo].[ScribeOnline_PayablesDistributionBase]') IS NULL
	exec('
CREATE VIEW [dbo].[ScribeOnline_PayablesDistributionBase] AS 
select 
	CASE PSTGSTUS WHEN 1 THEN 2 ELSE 1
		END  "TrxState", -- OPEN OR WORK
	(select DOCTYPE from PM10000 with (NOLOCK) WHERE PM10000.VCHRNMBR = PM10100.VCHRNMBR and PM10000.CNTRLTYP = CNTRLTYP) "DOCTYPE",
	VENDORID,
	VCHRNMBR, 
	DSTSQNUM, 
	DISTTYPE, 
	DistRef, 
	(select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PM10100.DSTINDX) "ACTNUMST", 
	DEBITAMT, 
	CRDTAMNT, 
	ORDBTAMT, 
	ORCRDAMT, 
	(select CMPANYID from DYNAMICS..SY01500 with (NOLOCK) where INTERID = PM10100.INTERID) "INTERID", 
	DSTINDX,
	PSTGSTUS , 
	PSTGDATE,
	CNTRLTYP,
	CHANGED,
	USERID,
	TRXSORCE,
	CURNCYID,
	CURRNIDX,
	APTVCHNM,
	APTODCTY,
	SPCLDIST,
	RATETPID,
	EXGTBLID,
	XCHGRATE,
	EXCHDATE,
	TIME1,
	RTCLCMTD,
	DECPLACS,
	EXPNDATE,
	ICCURRID,
	ICCURRIX,
	DENXRATE,
	MCTRXSTT,
	CorrespondingUnit                                           
from  
	PM10100 
 
union all 
 
select 
	3 "TrxState", -- HISTORY
	DOCTYPE,
	VENDORID, 
	VCHRNMBR, 
	DSTSQNUM, 
	DISTTYPE, 
	DistRef, 
	(select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PM30600.DSTINDX) "ACTNUMST", 
	DEBITAMT, 
	CRDTAMNT, 
	ORDBTAMT, 
	ORCRDAMT, 
	NULL, -- INTERID 
	DSTINDX,
	PSTGSTUS , 
	PSTGDATE,
	CNTRLTYP,
    CHANGED,
    USERID,
    TRXSORCE,
    CURNCYID,
    CURRNIDX,
    APTVCHNM,
    APTODCTY,
    SPCLDIST,
	NULL "RATETPID",
	NULL "EXGTBLID",
	NULL "XCHGRATE",
	NULL "EXCHDATE",
	NULL "TIME1",
	NULL "RTCLCMTD",
	NULL "DECPLACS",
	NULL "EXPNDATE",
	NULL "ICCURRID",
	NULL "ICCURRIX",
	NULL "DENXRATE",
	NULL "MCTRXSTT",
	NULL "CorrespondingUnit"        
 
from  
	PM30600 with (NOLOCK) 
	')

	
IF OBJECT_ID(N'[dbo].[ScribeOnline_PayablesTaxBase]') IS NULL
	exec('
	CREATE VIEW [dbo].[ScribeOnline_PayablesTaxBase] AS 
select 
	CASE POSTED WHEN 1 THEN 2 ELSE 1
		END 
	"TrxState", -- OPEN or Work
	VCHRNMBR, 
	TAXDTLID, 
	TAXAMNT, 
	ORTAXAMT, 
	PCTAXAMT, 
	ORPURTAX, 
	FRTTXAMT, 
	ORFRTTAX, 
	MSCTXAMT, 
	ORMSCTAX, 
	TDTTXPUR, 
	ORTXBPUR, 
	TXDTTPUR, 
	ORTOTPUR, 
	(select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PM10500.ACTINDX) "ACTNUMST", 
	BKOUTTAX, 
	POSTED,
	ACTINDX,
	TRXSORCE
from  
	PM10500 
 
 union all 
 
select 
	3 "TrxState", -- HISTORY 
	VCHRNMBR, 
	TAXDTLID, 
	TAXAMNT, 
	ORTAXAMT, 
	PCTAXAMT, 
	ORPURTAX, 
	FRTTXAMT, 
	ORFRTTAX, 
	MSCTXAMT, 
	ORMSCTAX, 
	TDTTXPUR, 
	ORTXBPUR, 
	TXDTTPUR, 
	ORTOTPUR, 
	(select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PM30700.ACTINDX) "ACTNUMST", 
	BKOUTTAX, 
	NULL "POSTED" ,
	ACTINDX,
	TRXSORCE
from  
	PM30700 
	')
	
IF OBJECT_ID(N'[dbo].[ScribeOnline_GLTransactionHeaderBase]') IS NULL
	exec('
CREATE VIEW [dbo].[ScribeOnline_GLTransactionHeaderBase] AS 
select  
	1 as "TrxState", -- Set to 1 for Work 
	BACHNUMB, 
	BCHSOURC,	 
	(SELECT CREATDDT FROM SY00500 with (NOLOCK) WHERE GL10000.BACHNUMB = SY00500.BACHNUMB AND GL10000.BCHSOURC = SY00500.BCHSOURC) AS BatchCreatedDate, 
	(SELECT TIME1 FROM SY00500 with (NOLOCK) WHERE GL10000.BACHNUMB = SY00500.BACHNUMB AND GL10000.BCHSOURC = SY00500.BCHSOURC) AS BatchCreatedTime, 
	JRNENTRY, 
	convert(bigint, RCTRXSEQ) as "RCTRXSEQ", 
	SOURCDOC, 
	REFRENCE,
	EXCHDATE,
	XCHGRATE,
	TRXTYPE,
	DOCDATE,
	OrigDTASeries,
	RVRSNGDT,
	BALFRCLC, 
	PSTGSTUS,
	SQNCLINE,
    GLHDRMSG,
    GLHDRMS2,
    TRXSORCE,
    RVTRXSRC,
	DTAControlNum,
    DTATRXType,
    DTA_Index,
    CURRNIDX,
    RATETPID,
    EXGTBLID,
    TIME1,
    RTCLCMTD,
    NOTEINDX,
    GLHDRVAL,
    PERIODID,
    OPENYEAR,
    CLOSEDYR,
    HISTRX,
    REVPRDID,
    REVYEAR,
    REVCLYR,
    REVHIST,
    ERRSTATE,
    ICTRX,
    ORCOMID,		
	TRXDATE, 
	LASTUSER, 
	LSTDTEDT, 
	DEX_ROW_TS, 
	USWHPSTD, 
	SERIES, 
	ORPSTDDT, 
	ORTRXSRC, 
	CURNCYID, 
	(select ISOCURRC from DYNAMICS..MC40200 with (NOLOCK) where CURNCYID = GL10000.CURNCYID) as "ISOCURRC", 
	(select CMPANYID from DYNAMICS..SY01500 with (NOLOCK) where GL10000.ORCOMID = INTERID) as "CMPANYID", 
	ORIGINJE, 
	VOIDED, 
	Ledger_ID, 
	0 "YEAR", -- This is a place holder so we can join on JRNENTRY and YEAR for Unioned tables 
	DEX_ROW_ID,
	RCRNGTRX 
from 
	GL10000 with (NOLOCK) 
	WHERE RCTRXSEQ = 0 
 
union all 
 
select distinct  
	2 as "TrxState", -- Set to 2 for Open 
	NULL as "BACHNUMB", -- BACHNUMB does not exist in OPEN record 
	NULL as "BCHSOURC", -- BCHSOURC does not exist in OPEN record 
	NULL as "BatchCreatedDate", --BatchCreatedDate 
	NULL as "BatchCreatedTime", --BatchCreatedTime 
	JRNENTRY, 
	convert(bigint, RCTRXSEQ) as "RCTRXSEQ", 
	SOURCDOC, 
	REFRENCE,
	EXCHDATE,
	XCHGRATE, 
	NULL as TRXTYPE,
	DOCDATE,
	OrigDTASeries,
	NULL as RVRSNGDT,
	NULL as BALFRCLC, 
	NULL as PSTGSTUS,
	NULL as SQNCLINE,
    NULL as GLHDRMSG,
    NULL as GLHDRMS2,
    TRXSORCE,
    NULL as RVTRXSRC,
	NULL as DTAControlNum,
    NULL as DTATRXType,
    DTA_Index,
    CURRNIDX,
    RATETPID,
    EXGTBLID,
    TIME1,
    RTCLCMTD,
    NOTEINDX,
    NULL as GLHDRVAL,
    PERIODID,
    OPENYEAR,
    NULL as CLOSEDYR,
    NULL as HISTRX,
    NULL as REVPRDID,
    NULL as REVYEAR,
    NULL as REVCLYR,
    NULL as REVHIST,
    NULL as ERRSTATE,
    ICTRX,
    ORCOMID,		
	TRXDATE, 
	LASTUSER, 
	LSTDTEDT, 
	MAX(DEX_ROW_TS) as "DEX_ROW_TS", 
	USWHPSTD, 
	SERIES, 
	ORPSTDDT, 
	ORTRXSRC, 
	CURNCYID, 
	(select ISOCURRC from DYNAMICS..MC40200 with (NOLOCK) where CURNCYID = GL20000.CURNCYID) as "ISOCURRC", 
	(select CMPANYID from DYNAMICS..SY01500 with (NOLOCK) where GL20000.ORCOMID = INTERID) as "CMPANYID", 
	ORIGINJE, 
	VOIDED, 
	Ledger_ID, 
	OPENYEAR, 
	Max(DEX_ROW_ID) as DEX_ROW_ID ,
	NULL as RCRNGTRX 
from  
	GL20000 with (NOLOCK) 
group by JRNENTRY, RCTRXSEQ, SOURCDOC, REFRENCE, EXCHDATE, XCHGRATE, DOCDATE, OrigDTASeries, TRXSORCE, DTA_Index, CURRNIDX, RATETPID, EXGTBLID, TIME1, RTCLCMTD,
    NOTEINDX, PERIODID, OPENYEAR, ICTRX, ORCOMID, TRXDATE, LASTUSER, LSTDTEDT, USWHPSTD, TRXSORCE, SERIES, ORPSTDDT, ORTRXSRC, CURNCYID, ORIGINJE, VOIDED, OPENYEAR, ORCOMID, Ledger_ID 
 
union all 
 
select distinct 
	3 as "TrxState", 
	NULL as "BACHNUMB", 
	NULL as "BCHSOURC", 
	NULL as "BatchCreatedDate", 
	NULL as "BatchCreateTime", 
	JRNENTRY, 
	convert(bigint, RCTRXSEQ) as "RCTRXSEQ", 
	SOURCDOC, 
	REFRENCE,
	EXCHDATE,
	XCHGRATE,
	NULL as TRXTYPE,
	DOCDATE,
	OrigDTASeries,
	NULL as RVRSNGDT,
	NULL as BALFRCLC, 
	NULL as PSTGSTUS, 
	NULL as SQNCLINE,
    NULL as GLHDRMSG,
    NULL as GLHDRMS2,
	TRXSORCE,
    NULL as RVTRXSRC,
	NULL as DTAControlNum,
    NULL as DTATRXType,
    DTA_Index,
    CURRNIDX,
    RATETPID,
    EXGTBLID,
    TIME1,
    RTCLCMTD,
    NOTEINDX,
    NULL as GLHDRVAL,
    PERIODID,
    NULL as OPENYEAR,
    NULL as CLOSEDYR,
    NULL as HISTRX,
    NULL as REVPRDID,
    NULL as REVYEAR,
    NULL as REVCLYR,
    NULL as REVHIST,
    NULL as ERRSTATE,
    ICTRX,
    ORCOMID,		
	TRXDATE, 
	LASTUSER, 
	LSTDTEDT, 
	MAX(DEX_ROW_TS) as "DEX_ROW_TS", 
	USWHPSTD, 
	SERIES, 
	ORPSTDDT, 
	ORTRXSRC, 
	CURNCYID, 
	(select ISOCURRC from DYNAMICS..MC40200 with (NOLOCK) where CURNCYID = GL30000.CURNCYID) as "ISOCURRC", 
	(select CMPANYID from DYNAMICS..SY01500 with (NOLOCK) where GL30000.ORCOMID = INTERID) as "CMPANYID", 
	ORIGINJE, 
	VOIDED, 
	Ledger_ID, 
	HSTYEAR,  
	Max(DEX_ROW_ID) as DEX_ROW_ID,
	NULL as RCRNGTRX  
from  
	GL30000 with (NOLOCK) 
group by JRNENTRY, RCTRXSEQ, SOURCDOC, REFRENCE, EXCHDATE, XCHGRATE, TRXSORCE, DOCDATE, OrigDTASeries, DTA_Index, CURRNIDX, RATETPID, EXGTBLID, TIME1, RTCLCMTD,
    NOTEINDX, PERIODID, ICTRX, ORCOMID, TRXDATE, LASTUSER, LSTDTEDT, USWHPSTD, TRXSORCE, SERIES, ORPSTDDT, ORTRXSRC, CURNCYID, ORIGINJE, VOIDED, HSTYEAR, ORCOMID, Ledger_ID 
')


IF OBJECT_ID(N'[dbo].[ScribeOnline_GLTransactionLineBase]') IS NULL
	exec('
CREATE VIEW [dbo].[ScribeOnline_GLTransactionLineBase] AS 
select  
	1 "TrxState", -- Set to 1 for Work 
	BACHNUMB, 
	JRNENTRY, 
	'''' "TRXDATE", 
	0  "RCTRXSEQ", 
	convert(bigint, SQNCLINE) "SQNCLINE", 
	XCHGRATE, 
	EXCHDATE, 
	DSCRIPTN,  
	ORCTRNUM, 
	ORDOCNUM, 
	ORMSTRID, 
	ORMSTRNM, 
	ORTRXTYP, 
	OrigSeqNum, 
	ORTRXDESC, 
	(select CMPANYID from DYNAMICS..SY01500 with (NOLOCK) where GL10001.INTERID = INTERID) "CMPANYID", 
	CRDTAMNT, 
	DEBITAMT, 
	ORCRDAMT, 
	ORDBTAMT, 
	ACTINDX, 
	(Select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = GL10001.ACTINDX) "ACTNUMST", 
	0 "YEAR", -- This is a place holder so we can join on JRNENTRY and YEAR for Unioned tables 
	DEX_ROW_ID 
from  
	GL10001  
 
union all 
 
select  
	2 "TrxState", -- Set to 2 for Open 
	'''', -- BACHNUMB does not exist in OPEN record 
	JRNENTRY, 
	TRXDATE, 
	convert(bigint, RCTRXSEQ), 
	convert(bigint, SEQNUMBR), 
	XCHGRATE, 
	EXCHDATE, 
	DSCRIPTN,  
	ORCTRNUM, 
	ORDOCNUM, 
	ORMSTRID, 
	ORMSTRNM, 
	ORTRXTYP, 
	OrigSeqNum, 
	REFRENCE,  
	NULL,  -- INTERID does not exist in OPEN record 
	CRDTAMNT, 
	DEBITAMT, 
	ORCRDAMT, 
	ORDBTAMT, 
	ACTINDX, 
	(Select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = GL20000.ACTINDX) "ACTNUMST", 
	OPENYEAR, 
	DEX_ROW_ID 
from  
	GL20000  
 
union all 
 
select  
	3 "TrxState", -- Set to 3 for History 
	'''', -- BACHNUMB does not exist in HISTORY record 
	JRNENTRY, 
	TRXDATE, 
	convert(bigint, RCTRXSEQ), 
	convert(bigint, SEQNUMBR),  
	XCHGRATE, 
	EXCHDATE, 
	DSCRIPTN,  
	ORCTRNUM, 
	ORDOCNUM, 
	ORMSTRID, 
	ORMSTRNM, 
	ORTRXTYP, 
	OrigSeqNum, 
	REFRENCE,  
	NULL,  -- INTERID does not exist in HISTORY record 
	CRDTAMNT, 
	DEBITAMT, 
	ORCRDAMT, 
	ORDBTAMT, 
	ACTINDX, 
	(Select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = GL30000.ACTINDX) "ACTNUMST", 
	HSTYEAR, 
	DEX_ROW_ID 
from  
	GL30000  ')


IF NOT EXISTS (SELECT id FROM sysobjects WHERE name='ScribeOnline_RMGetNextNumber' AND xtype='P ')
EXEC ('

CREATE   PROCEDURE [dbo].[ScribeOnline_RMGetNextNumber](
@RMDTYPAL   AS smallint,
@NextNumber  varchar(21) output)
AS
DECLARE @NextNum AS VARCHAR(21)
DECLARE @SplitPos AS int
DECLARE @Prefix AS VARCHAR(21)
DECLARE @Suffix AS int
DECLARE @NumLength AS int
DECLARE @NewNextNum AS VARCHAR(21)
--If they passed in their own number, just use it
IF (@NextNumber IS NOT NULL AND @NextNumber<>'''')
  RETURN
--Get the next document number
SELECT @NextNum=DOCNUMBR FROM RM40401 WITH (NOLOCK) WHERE RMDTYPAL=@RMDTYPAL
--Loop at this level to test whether next number is already in use
WHILE 1=1
  BEGIN
    --Extract the prefix and number parts
    SET @SplitPos = LEN(@NextNum)
    WHILE (SUBSTRING(@NextNum, @SplitPos, 1) BETWEEN ''0'' AND ''9'') AND (@SplitPos > 0)
      BEGIN
        SET @SplitPos = @SplitPos - 1
      END
	SET @SplitPos = @SplitPos + 1
    SET @Prefix = SUBSTRING(@NextNum, 1, @SplitPos - 1)
    SET @Suffix = CAST(SUBSTRING(@NextNum, @SplitPos, LEN(@NextNum)) AS int)
    SET @NumLength = LEN(@NextNum) - @SplitPos + 1
    --Build the new next-number
    SET @NewNextNum = @Prefix + 
          REPLICATE(''0'', @NumLength - LEN(CAST(@Suffix + 1 AS varchar))) + 
          CAST(@Suffix + 1 AS varchar)
    --Now test if this number is already in use, and increment if it is
    IF EXISTS(SELECT RMDNUMWK FROM RM10301 WITH (NOLOCK) 
    WHERE RMDTYPAL=@RMDTYPAL AND RMDNUMWK=@NextNum)
      BEGIN
        SET @NextNum=@NewNextNum
        CONTINUE
      END
    IF EXISTS(SELECT DOCNUMBR FROM RM20101 WITH (NOLOCK) 
    WHERE RMDTYPAL=@RMDTYPAL AND DOCNUMBR=@NextNum)
      BEGIN
        SET @NextNum=@NewNextNum
        CONTINUE
      END
    IF EXISTS(SELECT DOCNUMBR FROM RM30101 WITH (NOLOCK) 
    WHERE RMDTYPAL=@RMDTYPAL AND DOCNUMBR=@NextNum)
      BEGIN
        SET @NextNum=@NewNextNum
        CONTINUE
      END
    BREAK
  END
--Valid new number was found, update RM40401 and return the available number
UPDATE RM40401 SET DOCNUMBR=@NewNextNum WHERE RMDTYPAL=@RMDTYPAL
SET @NextNumber = @NextNum
')

IF NOT EXISTS (SELECT id FROM sysobjects WHERE name='ScribeOnline_EC_ERROR_TRANS' AND xtype='P ')
EXEC ('
CREATE PROCEDURE dbo.ScribeOnline_EC_ERROR_TRANS(@ErrCode int=0 OUTPUT, @ErrMessage varchar(8000)='''' OUTPUT, @ErrParms varchar(8000)='''' OUTPUT)
AS

    --Zero is no error, just return
    IF @ErrCode=0 AND (@ErrMessage IS NULL OR @ErrMessage='''')
        RETURN(0)
 
    --If for some reason error message is blank, copy error code
    --(Expecting ErrorMessage to be space-separated string of numeric codes)
    IF (@ErrMessage IS NULL OR @ErrMessage='''')
        SET @ErrMessage=@ErrCode

    --Parse through all codes
    DECLARE @iPos int
    DECLARE @sCode varchar(10)
    DECLARE @sDesc varchar(255)
    DECLARE @sParms varchar(1000)
    DECLARE @sNewMessage varchar(8000)
    DECLARE @sNewParms varchar(8000)
    SET @iPos=1
    SET @sNewMessage=''''
    SET @sNewParms=''''

    GetNextCode:

    SET @sCode=''''

    --Run spaces
    WHILE SUBSTRING(@ErrMessage,@iPos,1)=''''
        BEGIN
            SET @iPos=@iPos+1
            IF @iPos>LEN(@ErrMessage)
                GOTO NoMoreCodes
        END;
    
    --Collect next code
    SET @sCode=''''
    WHILE SUBSTRING(@ErrMessage,@iPos,1)<>''''
        BEGIN
            SET @sCode=@sCode+SUBSTRING(@ErrMessage,@iPos,1)
            SET @iPos=@iPos+1
            IF @iPos>LEN(@ErrMessage)
                BREAK
        END;

    --Lookup corresponding description
    IF ISNUMERIC(@sCode)=1
        IF EXISTS(SELECT ErrorDesc FROM DYNAMICS..taErrorCode WHERE ErrorCode=@sCode)
            SELECT @sDesc=ErrorDesc, @sParms=ErrorParms FROM DYNAMICS..taErrorCode WHERE ErrorCode=@sCode
        ELSE
            SET @sDesc=''No error description available.''
    ELSE
        SET @sDesc=@sCode

    IF @sNewMessage<>''''
        SET @sNewMessage=@sNewMessage+'', ''
    SET @sNewMessage=@sNewMessage + RTRIM(@sDesc) + '' ('' + @sCode + '')''

    IF @sParms<>''''
      BEGIN
        IF @sNewParms<>''''
          SET @sNewParms=@sNewParms+'' ''
        SET @sNewParms=@sNewParms + RTRIM(@sParms)
      END

    IF @ErrCode = 0
        SET @ErrCode = CAST(@sCode AS int)
    
    IF @iPos<=LEN(@ErrMessage)
        GOTO GetNextCode

    NoMoreCodes:

    SET @ErrMessage=''Error From Dynamics GP: '' + @sNewMessage
    SET @ErrParms=@sNewParms
    RETURN(0)
  
')


IF NOT EXISTS (SELECT id FROM sysobjects WHERE name='ScribeOnline_PMGetNextNumber' AND xtype='P ')
EXEC ('
CREATE    PROCEDURE [dbo].[ScribeOnline_PMGetNextNumber](
@DocType tinyint,
@NextNumber  varchar(21) output)
AS
DECLARE @NextNum AS VARCHAR(21)
DECLARE @SplitPos AS int
DECLARE @Prefix AS VARCHAR(21)
DECLARE @Suffix AS int
DECLARE @NumLength AS int
DECLARE @NewNextNum AS VARCHAR(21)
--If they passed in their own number, just use it
IF (@NextNumber IS NOT NULL AND @NextNumber<>'''')
  RETURN
--Check DocType
IF @DocType NOT IN (1,2)
  RAISERROR(''Document Type must be 1=PM Transaction or 2=PM Manual Check.'', 16, 1)
--Get the next document number
IF @DocType = 1
  SELECT @NextNum=NTVCHNUM FROM PM40100 WITH (NOLOCK) WHERE UNIQKEY=1
ELSE
  SELECT @NextNum=PMNPYNBR FROM PM40100 WITH (NOLOCK) WHERE UNIQKEY=1
--Loop at this level to test whether next number is already in use
WHILE 1=1
  BEGIN
    --Extract the prefix and number parts
    SET @SplitPos = LEN(@NextNum)
    WHILE (SUBSTRING(@NextNum, @SplitPos, 1) BETWEEN ''0'' AND ''9'') AND (@SplitPos > 1)
      BEGIN
        SET @SplitPos = @SplitPos - 1
      END
	SET @SplitPos = @SplitPos + 1
    SET @Prefix = SUBSTRING(@NextNum, 1, @SplitPos - 1)
    SET @Suffix = CAST(SUBSTRING(@NextNum, @SplitPos, LEN(@NextNum)) AS int)
    SET @NumLength = LEN(@NextNum) - @SplitPos + 1
    --Build the new next-number
    SET @NewNextNum = @Prefix + 
          REPLICATE(''0'', @NumLength - LEN(CAST(@Suffix + 1 AS varchar))) + 
          CAST(@Suffix + 1 AS varchar)
    --Now test if this number is already in use, and increment if it is
    IF @DocType = 1
      BEGIN
        IF EXISTS(SELECT CNTRLNUM FROM PM00400 WITH (NOLOCK) WHERE CNTRLNUM=@NextNum)
          BEGIN
            SET @NextNum=@NewNextNum
            CONTINUE
          END
        IF EXISTS(SELECT VCHNUMWK FROM PM10000 WITH (NOLOCK) WHERE VCHNUMWK=@NextNum)
          BEGIN
            SET @NextNum=@NewNextNum
            CONTINUE
          END
        IF EXISTS(SELECT VCHRNMBR FROM PM20000 WITH (NOLOCK) WHERE VCHRNMBR=@NextNum)
          BEGIN
            SET @NextNum=@NewNextNum
            CONTINUE
          END
        IF EXISTS(SELECT VCHRNMBR FROM PM30600 WITH (NOLOCK) WHERE VCHRNMBR=@NextNum)
          BEGIN
            SET @NextNum=@NewNextNum
            CONTINUE
          END
      END
    ELSE
      BEGIN
        IF EXISTS(SELECT PMNTNMBR FROM PM10400 WITH (NOLOCK) WHERE PMNTNMBR=@NextNum)
          BEGIN
            SET @NextNum=@NewNextNum
            CONTINUE
          END
      END
    BREAK
  END
--Valid new number was found, update PM40100 and return the available number
IF @DocType = 1
  UPDATE PM40100 SET NTVCHNUM=@NewNextNum WHERE UNIQKEY=1
ELSE
  UPDATE PM40100 SET PMNPYNBR=@NewNextNum WHERE UNIQKEY=1
SET @NextNumber = @NextNum
')

IF OBJECT_ID(N'[dbo].[ScribeOnline_Vendor]') IS NULL AND OBJECT_ID(N'[dbo].[PM00200]') IS NOT NULL

	IF OBJECT_ID(N'[dbo].[PA00901]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_Vendor] AS select        [PM00200].[VENDORID] AS [Key_Id],
       [PM00200].[VENDNAME] AS [Name],
       [PM00200].[VENDSHNM] AS [ShortName],
       [PM00200].[VNDCHKNM] AS [CheckName],
       [PM00200].[HOLD] AS [IsOnHold],
      CASE VENDSTTS WHEN 1 THEN 1 ELSE 0 END AS [IsActive],
      CASE VENDSTTS WHEN 3 THEN 1 ELSE 0 END AS [IsOneTime],
       [PM00200].[VNDCLSID] AS [ClassKey_Id],
       [PM00200].[VADDCDPR] AS [DefaultAddressKey_Id],
       [PM00200].[VADCDPAD] AS [PurchaseAddressKey_Id],
       [PM00200].[VADCDTRO] AS [RemitToAddressKey_Id],
       [PM00200].[VADCDSFR] AS [ShipFromAddressKey_Id],
       [PM00200].[ACNMVNDR] AS [VendorAccountNumber],
       [PM00200].[COMMENT1] AS [Comment1],
       [PM00200].[COMMENT2] AS [Comment2],
       [SY03900].[TXTFIELD] AS [Notes],
       [PM00200].[CURNCYID] AS [CurrencyKey_ISOCode],
       [PM00200].[RATETPID] AS [RateTypeKey_Id],
       [PM00200].[PYMTRMID] AS [PaymentTermsKey_Id],
       [PM00200].[DISGRPER] AS [DiscountGracePeriod],
       [PM00200].[DUEGRPER] AS [DueDateGracePeriod],
       [PM00200].[PYMNTPRI] AS [PaymentPriority],
       [PM00200].[MINORDER] AS [MinimumOrderAmount_Value],
       [PM00200].[TRDDISCT] AS [TradeDiscountPercent_Value],
       [PM00200].[TAXSCHID] AS [TaxSchedule],
       [PM00200].[TXIDNMBR] AS [TaxIdentificationNumber],
       [PM00200].[TXRGNNUM] AS [TaxRegistrationNumber],
       [PM00200].[CHEKBKID] AS [BankAccountKey_Id],
       [PM00200].[USERDEF1] AS [UserDefined1],
       [PM00200].[USERDEF2] AS [UserDefined2],
       [PM00200].[TEN99TYPE] AS [Tax1099Type],
       [PM00200].[TEN99BOXNUMBER] AS [Tax1099BoxNumber],
       [PM00200].[FREEONBOARD] AS [FreeOnBoard],
       [PM00200].[USERLANG] AS [UserLanguageKey_Id],
       [PM00200].[Revalue_Vendor] AS [AllowRevaluation],
       [PM00200].[Post_Results_To] AS [PostResultsTo],
       [PM00200].[KPCALHST] AS [HistoryOptions_KeepCalendarHistory],
       [PM00200].[KPERHIST] AS [HistoryOptions_KeepFiscalHistory],
       [PM00200].[KPTRXHST] AS [HistoryOptions_KeepTransactionHistory],
       [PM00200].[KGLDSTHS] AS [HistoryOptions_KeepDistributionHistory],
       [PM00200].[PTCSHACF] AS [DefaultCashAccountType],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = ACPURIDX) [AccruedPurchasesGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMFINIDX) [FinanceChargesGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMFRTIDX) [FreightGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMPRCHIX) [PurchasesGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMAPINDX) [AccountsPayableGLAccountKey_Id],
      (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMCSHIDX) [CashGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PURPVIDX) [PurchasePriceVarianceGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMTAXIDX) [TaxGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMDAVIDX) [TermsDiscountAvailableGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMDTKIDX) [TermsDiscountTakenGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMTDSCIX) [TradeDiscountGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMWRTIDX) [WriteoffGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMMSCHIX) [MiscellaneousGLAccountKey_Id],
       [PA00901].[PAddlDefpoformatouse] AS [ProjectAccountingOptions_DefaultPurchaseOrderFormat],
       [PA00901].[PAUnit_of_Measure] AS [ProjectAccountingOptions_UnitOfMeasure],
       [PA00901].[PAUNITCOST] AS [ProjectAccountingOptions_UnitCost_Value],
       [PA00901].[PAUD1] AS [ProjectAccountingOptions_UserDefined1],
       [PA00901].[PAUD2] AS [ProjectAccountingOptions_UserDefined2],
       [PM00200].[Workflow_Priority] AS [WorkflowPriority],
       [SY05400].[LANGNAME] AS [Language],
       [PM00200].[VNDCNTCT] AS [VendorContact],
       [PM00200].[ADDRESS1] AS [Address1],
       [PM00200].[ADDRESS2] AS [Address2],
       [PM00200].[ADDRESS3] AS [Address3],
       [PM00200].[CITY] AS [City],
       [PM00200].[STATE] AS [State],
       [PM00200].[ZIPCODE] AS [ZipCode],
       [PM00200].[COUNTRY] AS [Country],
       [PM00200].[PHNUMBR1] AS [PhoneNumber1],
       [PM00200].[PHNUMBR2] AS [PhoneNumber2],
       [PM00200].[PHONE3] AS [Phone3],
       [PM00200].[FAXNUMBR] AS [FaxNumber],
       [PM00200].[UPSZONE] AS [UPSZone],
       [PM00200].[SHIPMTHD] AS [ShippingMethod],
       [PM00200].[PARVENID] AS [ParentVendorID],
       [PM00200].[WRITEOFF] AS [Writeoff],
       [PM00200].[CREDTLMT] AS [CreditLimit],
       [PM00200].[CRLMTDLR] AS [CreditLimitDollar],
       [PM00200].[MODIFDT] AS [ModifiedDate],
       [PM00200].[CREATDDT] AS [CreatedDate],
       [PM00200].[MINPYPCT] AS [MinimumPaymentPercent],
       [PM00200].[MINPYDLR] AS [MinimumPaymentDollar],
       [PM00200].[MXIAFVND] AS [MaximumInvoiceAmountForVendors],
       [PM00200].[MAXINDLR] AS [MaximumInvoiceDollar],
       [PM00200].[MXWOFAMT] AS [MaximumWriteOffAmount],
       [PM00200].[SBPPSDED] AS [SubjectToPPSDeductions],
       [PM00200].[PPSTAXRT] AS [PPSTaxRate],
       [PM00200].[DXVARNUM] AS [DeductionExemptionVariationNumber],
       [PM00200].[CRTCOMDT] AS [CertificateCommencingDate],
       [PM00200].[CRTEXPDT] AS [CertificateExpirationDate],
       [PM00200].[RTOBUTKN] AS [ReportingObligationUndertaken],
       [PM00200].[XPDTOBLG] AS [ExpirationDateObligation],
       [PM00200].[PRSPAYEE] AS [PrescribedPayee],
       [PM00200].[PMRTNGIX] AS [PMRetainageIndex],
       [PM00200].[GOVCRPID] AS [GovernmentalCorporateID],
       [PM00200].[GOVINDID] AS [GovernmentalIndividualID],
       [PM00200].[TaxInvRecvd] AS [TaxInvoiceReceived],
       [PM00200].[WithholdingType] AS [WithholdingType],
       [PM00200].[WithholdingFormType] AS [WithholdingFormType],
       [PM00200].[WithholdingEntityType] AS [WithholdingEntityType],
       [PM00200].[TaxFileNumMode] AS [TaxFileNumberMode],
       [PM00200].[BRTHDATE] AS [BirthDate],
       [PM00200].[LaborPmtType] AS [LaborPaymentType],
       [PM00200].[CCode] AS [CountryCode],
       [PM00200].[DECLID] AS [DeclarantID],
       [PM00200].[CBVAT] AS [CashBasedVAT],
       [PM00200].[Workflow_Approval_Status] AS [WorkflowApprovalStatus],
       [PM00200].[MINPYTYP] AS [MinimumPaymentType],
       [PA00901].[PATMProfitType] AS [PATimeAndMaterialsProfitType],
       [PA00901].[PATMProfitAmount] AS [PATimeAndMaterialDollarAmount],
       [PA00901].[PATMProfitPercent] AS [PATimeAndMaterialPercentAmount],
       [PA00901].[PAFFProfitType] AS [PAFixedPriceProfitType],
       [PA00901].[PAFFProfitAmount] AS [PAFixedPriceDollarAmount],
       [PA00901].[PAFFProfitPercent] AS [PAFixedPricePercentAmount],
       [PA00901].[PAProfit_Type__CP] AS [PACostPlusProfitType],
       [PA00901].[PAProfitAmountCP] AS [PACostPlusDollarAmount],
       [PA00901].[PAProfitPercentCP] AS [PACostPlusPercentAmount],
       [PA00901].[PAfromemployee] AS [PAFromEmployee],
       [PA00901].[PA_Allow_Vendor_For_PO] AS [PAAllowVendorForPO],
       [PM00200].[DOCFMTID] AS [DocumentFormatID],
       [PM00200].[VADCD1099] AS [VendorAddressCode1099]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
         where ((EntityName=''PM00200'' and Id=RTRIM(PM00200.VENDORID)) 
		 or (EntityName=''GL00105'' and Id IN (CAST(PMAPINDX as nvarchar(250)), CAST(PMDAVIDX as nvarchar(250)), CAST(PMDTKIDX as nvarchar(250)), CAST(PMFINIDX as nvarchar(250)), CAST(PMPRCHIX as nvarchar(250)), CAST(PMTDSCIX as nvarchar(250)), CAST(PMMSCHIX as nvarchar(250)), CAST(PMFRTIDX as nvarchar(250)), CAST(PMTAXIDX as nvarchar(250)), CAST(PMWRTIDX as nvarchar(250)), CAST(ACPURIDX as nvarchar(250)), CAST(PURPVIDX as nvarchar(250)))) 
		 or (EntityName = ''SY03900'' and Id=CAST(PM00200.NOTEINDX as varchar)))) as [LastModifiedDateTime],
         UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
         where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
         where ((EntityName=''PM00200'' and Id=RTRIM(PM00200.VENDORID))
		 or (EntityName=''GL00105'' and Id IN (CAST(PMAPINDX as nvarchar(250)), CAST(PMDAVIDX as nvarchar(250)), CAST(PMDTKIDX as nvarchar(250)), CAST(PMFINIDX as nvarchar(250)), CAST(PMPRCHIX as nvarchar(250)), CAST(PMTDSCIX as nvarchar(250)), CAST(PMMSCHIX as nvarchar(250)), CAST(PMFRTIDX as nvarchar(250)), CAST(PMTAXIDX as nvarchar(250)), CAST(PMWRTIDX as nvarchar(250)), CAST(ACPURIDX as nvarchar(250)), CAST(PURPVIDX as nvarchar(250)))) 
		 or (EntityName = ''SY03900'' and Id=CAST(PM00200.NOTEINDX as varchar))))),'''')) as [LastModifiedBy]
         FROM PM00200 (NOLOCK)        
         left outer join PA00901 with (NOLOCK) on (PM00200.VENDORID = PA00901.VENDORID)   
         left outer join [DYNAMICS].dbo.SY05400 with (NOLOCK) on (PM00200.USERLANG = [DYNAMICS].dbo.SY05400.USERLANG) 
         left outer join SY03900 with (NOLOCK) on (PM00200.NOTEINDX = SY03900.NOTEINDX)      
         ')

		 else 
		
			exec('CREATE VIEW [dbo].[ScribeOnline_Vendor] AS select        [PM00200].[VENDORID] AS [Key_Id],
       [PM00200].[VENDNAME] AS [Name],
       [PM00200].[VENDSHNM] AS [ShortName],
       [PM00200].[VNDCHKNM] AS [CheckName],
       [PM00200].[HOLD] AS [IsOnHold],
      CASE VENDSTTS WHEN 1 THEN 1 ELSE 0 END AS [IsActive],
      CASE VENDSTTS WHEN 3 THEN 1 ELSE 0 END AS [IsOneTime],
       [PM00200].[VNDCLSID] AS [ClassKey_Id],
       [PM00200].[VADDCDPR] AS [DefaultAddressKey_Id],
       [PM00200].[VADCDPAD] AS [PurchaseAddressKey_Id],
       [PM00200].[VADCDTRO] AS [RemitToAddressKey_Id],
       [PM00200].[VADCDSFR] AS [ShipFromAddressKey_Id],
       [PM00200].[ACNMVNDR] AS [VendorAccountNumber],
       [PM00200].[COMMENT1] AS [Comment1],
       [PM00200].[COMMENT2] AS [Comment2],
       [SY03900].[TXTFIELD] AS [Notes],
       [PM00200].[CURNCYID] AS [CurrencyKey_ISOCode],
       [PM00200].[RATETPID] AS [RateTypeKey_Id],
       [PM00200].[PYMTRMID] AS [PaymentTermsKey_Id],
       [PM00200].[DISGRPER] AS [DiscountGracePeriod],
       [PM00200].[DUEGRPER] AS [DueDateGracePeriod],
       [PM00200].[PYMNTPRI] AS [PaymentPriority],
       [PM00200].[MINORDER] AS [MinimumOrderAmount_Value],
       [PM00200].[TRDDISCT] AS [TradeDiscountPercent_Value],
       [PM00200].[TAXSCHID] AS [TaxSchedule],
       [PM00200].[TXIDNMBR] AS [TaxIdentificationNumber],
       [PM00200].[TXRGNNUM] AS [TaxRegistrationNumber],
       [PM00200].[CHEKBKID] AS [BankAccountKey_Id],
       [PM00200].[USERDEF1] AS [UserDefined1],
       [PM00200].[USERDEF2] AS [UserDefined2],
       [PM00200].[TEN99TYPE] AS [Tax1099Type],
       [PM00200].[TEN99BOXNUMBER] AS [Tax1099BoxNumber],
       [PM00200].[FREEONBOARD] AS [FreeOnBoard],
       [PM00200].[USERLANG] AS [UserLanguageKey_Id],
       [PM00200].[Revalue_Vendor] AS [AllowRevaluation],
       [PM00200].[Post_Results_To] AS [PostResultsTo],
       [PM00200].[KPCALHST] AS [HistoryOptions_KeepCalendarHistory],
       [PM00200].[KPERHIST] AS [HistoryOptions_KeepFiscalHistory],
       [PM00200].[KPTRXHST] AS [HistoryOptions_KeepTransactionHistory],
       [PM00200].[KGLDSTHS] AS [HistoryOptions_KeepDistributionHistory],
       [PM00200].[PTCSHACF] AS [DefaultCashAccountType],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = ACPURIDX) [AccruedPurchasesGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMFINIDX) [FinanceChargesGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMFRTIDX) [FreightGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMPRCHIX) [PurchasesGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMAPINDX) [AccountsPayableGLAccountKey_Id],
      (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMCSHIDX) [CashGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PURPVIDX) [PurchasePriceVarianceGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMTAXIDX) [TaxGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMDAVIDX) [TermsDiscountAvailableGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMDTKIDX) [TermsDiscountTakenGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMTDSCIX) [TradeDiscountGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMWRTIDX) [WriteoffGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMMSCHIX) [MiscellaneousGLAccountKey_Id],
       NULL AS [ProjectAccountingOptions_DefaultPurchaseOrderFormat],
       (select NULL)  [ProjectAccountingOptions_UnitOfMeasure],
       (select NULL)  [ProjectAccountingOptions_UnitCost_Value],
       (select NULL)  [ProjectAccountingOptions_UserDefined1],
       (select NULL)  [ProjectAccountingOptions_UserDefined2],
       [PM00200].[Workflow_Priority] AS [WorkflowPriority],
       [SY05400].[LANGNAME] AS [Language],
       [PM00200].[VNDCNTCT] AS [VendorContact],
       [PM00200].[ADDRESS1] AS [Address1],
       [PM00200].[ADDRESS2] AS [Address2],
       [PM00200].[ADDRESS3] AS [Address3],
       [PM00200].[CITY] AS [City],
       [PM00200].[STATE] AS [State],
       [PM00200].[ZIPCODE] AS [ZipCode],
       [PM00200].[COUNTRY] AS [Country],
       [PM00200].[PHNUMBR1] AS [PhoneNumber1],
       [PM00200].[PHNUMBR2] AS [PhoneNumber2],
       [PM00200].[PHONE3] AS [Phone3],
       [PM00200].[FAXNUMBR] AS [FaxNumber],
       [PM00200].[UPSZONE] AS [UPSZone],
       [PM00200].[SHIPMTHD] AS [ShippingMethod],
       [PM00200].[PARVENID] AS [ParentVendorID],
       [PM00200].[WRITEOFF] AS [Writeoff],
       [PM00200].[CREDTLMT] AS [CreditLimit],
       [PM00200].[CRLMTDLR] AS [CreditLimitDollar],
       [PM00200].[MODIFDT] AS [ModifiedDate],
       [PM00200].[CREATDDT] AS [CreatedDate],
       [PM00200].[MINPYPCT] AS [MinimumPaymentPercent],
       [PM00200].[MINPYDLR] AS [MinimumPaymentDollar],
       [PM00200].[MXIAFVND] AS [MaximumInvoiceAmountForVendors],
       [PM00200].[MAXINDLR] AS [MaximumInvoiceDollar],
       [PM00200].[MXWOFAMT] AS [MaximumWriteOffAmount],
       [PM00200].[SBPPSDED] AS [SubjectToPPSDeductions],
       [PM00200].[PPSTAXRT] AS [PPSTaxRate],
       [PM00200].[DXVARNUM] AS [DeductionExemptionVariationNumber],
       [PM00200].[CRTCOMDT] AS [CertificateCommencingDate],
       [PM00200].[CRTEXPDT] AS [CertificateExpirationDate],
       [PM00200].[RTOBUTKN] AS [ReportingObligationUndertaken],
       [PM00200].[XPDTOBLG] AS [ExpirationDateObligation],
       [PM00200].[PRSPAYEE] AS [PrescribedPayee],
       [PM00200].[PMRTNGIX] AS [PMRetainageIndex],
       [PM00200].[GOVCRPID] AS [GovernmentalCorporateID],
       [PM00200].[GOVINDID] AS [GovernmentalIndividualID],
       [PM00200].[TaxInvRecvd] AS [TaxInvoiceReceived],
       [PM00200].[WithholdingType] AS [WithholdingType],
       [PM00200].[WithholdingFormType] AS [WithholdingFormType],
       [PM00200].[WithholdingEntityType] AS [WithholdingEntityType],
       [PM00200].[TaxFileNumMode] AS [TaxFileNumberMode],
       [PM00200].[BRTHDATE] AS [BirthDate],
       [PM00200].[LaborPmtType] AS [LaborPaymentType],
       [PM00200].[CCode] AS [CountryCode],
       [PM00200].[DECLID] AS [DeclarantID],
       [PM00200].[CBVAT] AS [CashBasedVAT],
       [PM00200].[Workflow_Approval_Status] AS [WorkflowApprovalStatus],
       [PM00200].[MINPYTYP] AS [MinimumPaymentType],
       (select NULL) [PATimeAndMaterialsProfitType],
       (select NULL) [PATimeAndMaterialDollarAmount],
       (select NULL)  [PATimeAndMaterialPercentAmount],
       (select NULL) [PAFixedPriceProfitType],
       (select NULL)  [PAFixedPriceDollarAmount],
       (select NULL) [PAFixedPricePercentAmount],
       (select NULL) [PACostPlusProfitType],
       (select NULL)  [PACostPlusDollarAmount],
       (select NULL)  [PACostPlusPercentAmount],
       (select NULL)  [PAFromEmployee],
       (select NULL)  [PAAllowVendorForPO],
       [PM00200].[DOCFMTID] AS [DocumentFormatID],
       [PM00200].[VADCD1099] AS [VendorAddressCode1099]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
         where ((EntityName=''PM00200'' and Id=RTRIM(PM00200.VENDORID)) 
		 or (EntityName=''GL00105'' and Id IN (CAST(PMAPINDX as nvarchar(250)), CAST(PMDAVIDX as nvarchar(250)), CAST(PMDTKIDX as nvarchar(250)), CAST(PMFINIDX as nvarchar(250)), CAST(PMPRCHIX as nvarchar(250)), CAST(PMTDSCIX as nvarchar(250)), CAST(PMMSCHIX as nvarchar(250)), CAST(PMFRTIDX as nvarchar(250)), CAST(PMTAXIDX as nvarchar(250)), CAST(PMWRTIDX as nvarchar(250)), CAST(ACPURIDX as nvarchar(250)), CAST(PURPVIDX as nvarchar(250)))) 
		 or (EntityName = ''SY03900'' and Id=CAST(PM00200.NOTEINDX as varchar)))) as [LastModifiedDateTime],
         UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
         where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
         where ((EntityName=''PM00200'' and Id=RTRIM(PM00200.VENDORID))
		 or (EntityName=''GL00105'' and Id IN (CAST(PMAPINDX as nvarchar(250)), CAST(PMDAVIDX as nvarchar(250)), CAST(PMDTKIDX as nvarchar(250)), CAST(PMFINIDX as nvarchar(250)), CAST(PMPRCHIX as nvarchar(250)), CAST(PMTDSCIX as nvarchar(250)), CAST(PMMSCHIX as nvarchar(250)), CAST(PMFRTIDX as nvarchar(250)), CAST(PMTAXIDX as nvarchar(250)), CAST(PMWRTIDX as nvarchar(250)), CAST(ACPURIDX as nvarchar(250)), CAST(PURPVIDX as nvarchar(250)))) 
		 or (EntityName = ''SY03900'' and Id=CAST(PM00200.NOTEINDX as varchar))))),'''')) as [LastModifiedBy]
         FROM PM00200 (NOLOCK)        
         left outer join [DYNAMICS].dbo.SY05400 with (NOLOCK) on (PM00200.USERLANG = [DYNAMICS].dbo.SY05400.USERLANG) 
         left outer join SY03900 with (NOLOCK) on (PM00200.NOTEINDX = SY03900.NOTEINDX)      
         ')
		 
		 IF OBJECT_ID(N'[dbo].[ScribeOnline_SalesItemWarehouseBinBase]') IS NULL AND OBJECT_ID(N'[dbo].[IV00112]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_SalesItemWarehouseBinBase] AS select distinct (select ATYALLOC from IV00112 where QTYTYPE = 1 and  
			Master.LOCNCODE = LOCNCODE and Master.ITEMNMBR = ITEMNMBR and Master.BIN = BIN) [AllocatedQuantity_Value],
      (select QUANTITY from IV00112 with (NOLOCK) where QTYTYPE = 5 and  
			Master.LOCNCODE = LOCNCODE and Master.ITEMNMBR = ITEMNMBR and Master.BIN = BIN) [DamagedQuantity_Value],
      (select QUANTITY from IV00112 with (NOLOCK) where QTYTYPE = 4 and  
			Master.LOCNCODE = LOCNCODE and Master.ITEMNMBR = ITEMNMBR and Master.BIN = BIN) [InServiceQuantity_Value],
      (select QUANTITY from IV00112 with (NOLOCK) where QTYTYPE = 3 and  
			Master.LOCNCODE = LOCNCODE and Master.ITEMNMBR = ITEMNMBR and Master.BIN = BIN) [InUseQuantity_Value],
       [Master].[BIN],
       [Master].[ITEMNMBR],
       [Master].[LOCNCODE],
      (select QUANTITY from IV00112 with (NOLOCK) where QTYTYPE = 1 and  
   Master.LOCNCODE = LOCNCODE and Master.ITEMNMBR = ITEMNMBR and Master.BIN = BIN) [OnHandQuantity_Value]
,
      	(select QUANTITY from IV00112 with (NOLOCK) where QTYTYPE = 2 and  
			Master.LOCNCODE = LOCNCODE and Master.ITEMNMBR = ITEMNMBR and Master.BIN = BIN) [ReturnedQuantity_Value]
		from [IV00112] Master with (NOLOCK)')	 
		 

/****** Object:  View [dbo].[ScribeOnline_Customer]    Script Date: 5/23/2016 4:15:21 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_Customer]') IS NULL AND OBJECT_ID(N'[dbo].[RM00101]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_Customer] AS select       (select [ACTNUMST] from [GL00105] with (NOLOCK) where [GL00105].[ACTINDX] = [RM00101].[RMARACC]) "AccountsReceivableGLAccountKey_Id",
       [RM00101].[Revalue_Customer] AS [AllowRevaluation],
       [RM00101].[BALNCTYP] AS [BalanceType],
       [RM00101].[BNKBRNCH] AS [BankBranch],
       [RM00101].[BANKNAME] AS [BankName],
       [RM00101].[PRBTADCD] AS [BillToAddressKey_Id],
      (select [ACTNUMST] from [GL00105] with (NOLOCK) where [GL00105].[ACTINDX] = [RM00101].[RMCSHACC]) "CashGLAccountKey_Id",
       [RM00101].[CUSTCLAS] AS [ClassKey_Id],
       [RM00101].[COMMENT1] AS [Comment1],
       [RM00101].[COMMENT2] AS [Comment2],
      (select [ACTNUMST] from [GL00105] with (NOLOCK) where [GL00105].[ACTINDX] = [RM00101].[RMCOSACC]) "CostOfGoodsSoldGLAccountKey_Id",
       [RM00101].[CREATDDT] AS [CreatedDate],
       [RM00101].[CRLMTPER] AS [CreditLimit_Period],
       [RM00101].[CRLMTPAM] AS [CreditLimit_PeriodAmount_Value],
       [RM00101].[ADRSCODE] AS [DefaultAddressKey_Id],
       [RM00101].[DEFCACTY] AS [DefaultCashAccountType],
       [RM00101].[DISGRPER] AS [DiscountGracePeriod],
       [RM00101].[DUEGRPER] AS [DueDateGracePeriod],
      (select [ACTNUMST] from [GL00105] with (NOLOCK) where [GL00105].[ACTINDX] = [RM00101].[RMFCGACC]) "FinanceChargesGLAccountKey_Id",
       [RM00101].[KPCALHST] AS [HistoryOptions_KeepCalendarHistory],
       [RM00101].[KPDSTHST] AS [HistoryOptions_KeepDistributionHistory],
       [RM00101].[KPERHIST] AS [HistoryOptions_KeepFiscalHistory],
       [RM00101].[KPTRXHST] AS [HistoryOptions_KeepTransactionHistory],
       [RM00101].[INCLUDEINDP] AS [IncludeInDemandPlanning],
      (select [ACTNUMST] from [GL00105] with (NOLOCK) where [GL00105].[ACTINDX] = [RM00101].[RMIVACC]) "InventoryGLAccountKey_Id",
      CASE [RM00101].[INACTIVE] WHEN 0 THEN 1 ELSE 0 END AS [IsActive],
       [RM00101].[HOLD] AS [IsOnHold],
       [RM00101].[CUSTNMBR] AS [Key_Id],
       [RM00101].[MODIFDT] AS [ModifiedDate],
       [RM00101].[CUSTNAME] AS [Name],
       [SY03900].[TXTFIELD] AS [Notes],
       [RM00101].[ORDERFULFILLDEFAULT] AS [OrderFullfillmentShortageDefault],
      (select [ACTNUMST] from [GL00105] with (NOLOCK) where [GL00105].[ACTINDX] = [RM00101].[RMOvrpymtWrtoffAcctIdx]) "OverpaymentWriteoffGLAccountKey_Id",
       [RM00101].[CCRDXPDT] AS [PaymentCardAccount_ExpirationDate],
       [RM00101].[CRCRDNUM] AS [PaymentCardAccount_Key_Number],
       [RM00101].[CRCARDID] AS [PaymentCardAccount_Key_PaymentCardTypeKey_Id],
      (select [ACTNUMST] from [GL00105] with (NOLOCK) where [GL00105].[ACTINDX] = [RM00101].[RMAVACC]) "PaymentTermsDiscountAvailableGLAccountKey_Id",
      (select [ACTNUMST] from [GL00105] with (NOLOCK) where [GL00105].[ACTINDX] = [RM00101].[RMTAKACC]) "PaymentTermsDiscountTakenGLAccountKey_Id",
       [RM00101].[PYMTRMID] AS [PaymentTermsKey_Id],
       [RM00101].[Post_Results_To] AS [PostResultsTo],
       [RM00101].[PRCLEVEL] AS [PriceLevelKey_Id],
       [RM00101].[CUSTPRIORITY] AS [Priority],
       [RM00101].[RATETPID] AS [RateTypeKey_Id],
      (select [ACTNUMST] from [GL00105] with (NOLOCK) where [GL00105].[ACTINDX] = [RM00101].[RMSLSACC]) "SalesGLAccountKey_Id",
      (select [ACTNUMST] from [GL00105] with (NOLOCK) where [GL00105].[ACTINDX] = [RM00101].[RMSORACC]) "SalesOrderReturnsGLAccountKey_Id",
       [RM00101].[Send_Email_Statements] AS [SendEmailStatements],
       [RM00101].[SHIPCOMPLETE] AS [ShipCompleteOnly],
       [RM00101].[PRSTADCD] AS [ShipToAddressKey_Id],
       [RM00101].[SHRTNAME] AS [Shortname],
       [RM00101].[STMTCYCL] AS [StatementCycle],
       [RM00101].[STMTNAME] AS [StatementName],
       [RM00101].[STADDRCD] AS [StatementToAddressKey_Id],
       [RM00101].[TXRGNNUM] AS [TaxRegistrationNumber],
       [RM00101].[CUSTDISC] AS [TradeDiscountPercent_Value],
       [RM00101].[USERDEF1] AS [UserDefined1],
       [RM00101].[USERDEF2] AS [UserDefined2],
       [RM00101].[USERLANG] AS [UserLanguageKey_Id],
      (select [ACTNUMST] from [GL00105] with (NOLOCK) where [GL00105].[ACTINDX] = [RM00101].[RMWRACC]) "WriteoffGLAccountKey_Id",
       [RM00101].[ADDRESS1] AS [Address1],
       [RM00101].[ADDRESS2] AS [Address2],
       [RM00101].[ADDRESS3] AS [Address3],
       [RM00101].[CBVAT] AS [CashBasedVAT],
       [RM00101].[CCode] AS [CountryCode],
       [RM00101].[CHEKBKID] AS [CheckbookID],
       [RM00101].[CITY] AS [City],
       [RM00101].[CNTCPRSN] AS [ContactPerson],
       [RM00101].[COUNTRY] AS [Country],
       [RM00101].[CPRCSTNM] AS [CorporateCustomerNumber],
       [RM00101].[CRLMTAMT] AS [CreditLimitAmount],
       [RM00101].[CRLMTTYP] AS [CreditLimitType],
       [RM00101].[DECLID] AS [DeclarantId],
       [RM00101].[FAX] AS [Fax],
       [RM00101].[FNCHATYP] AS [FinanceChargeAmtType],
       [RM00101].[FNCHPCNT] AS [FinanceChargePercent],
       [RM00101].[FRSTINDT] AS [FirstInvoiceDate],
       [RM00101].[GOVCRPID] AS [GovernmentalCorporateId],
       [RM00101].[GOVINDID] AS [GovernmentalIndividualId],
       [RM00101].[GPSFOINTEGRATIONID] AS [GPSFOIntegrationId],
       [RM00101].[INTEGRATIONID] AS [IntegrationId],
       [RM00101].[INTEGRATIONSOURCE] AS [IntegrationSource],
       [RM00101].[MINPYPCT] AS [MinimumPaymentPercent],
       [RM00101].[MINPYTYP] AS [MinimumPaymentType],
       [RM00101].[MXWOFTYP] AS [MaximumWriteoffType],
       [RM00101].[PHONE1] AS [Phone1],
       [RM00101].[PHONE2] AS [Phone2],
       [RM00101].[PHONE3] AS [Phone3],
       [RM00101].[SALSTERR] AS [SalesTerritory],
       [RM00101].[SHIPMTHD] AS [ShippingMethod],
       [RM00101].[SLPRSNID] AS [SalespersonId],
       [RM00101].[STATE] AS [State],
       [RM00101].[TAXEXMT1] AS [TaxExempt1],
       [RM00101].[TAXEXMT2] AS [TaxExempt2],
       [RM00101].[TAXSCHID] AS [TaxScheduleID],
       [RM00101].[UPSZONE] AS [UPSZone],
       [RM00101].[ZIP] AS [Zip],
       [RM00101].[MXWROFAM] AS [MaximumWriteoffAmount],
       [RM00101].[MINPYDLR] AS [MinimumPaymentDollar],
       [RM00101].[FINCHDLR] AS [FinanceChargeDollar],
       [RM00101].[DOCFMTID] AS [DocumentFormatId],
       [RM00101].[FINCHID] AS [FinanceChargeId],
       [RM00101].[CURNCYID] AS [CurrencyId]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
        where (EntityName=''RM00101'' and Id=RM00101.CUSTNMBR) or (EntityName = ''SY03900'' and Id=CAST(RM00101.NOTEINDX as varchar))) as [LastModifiedDateTime],
        UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
        where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
        where (EntityName=''RM00101'' and Id=RM00101.CUSTNMBR) or (EntityName = ''SY03900'' and Id=CAST(RM00101.NOTEINDX as varchar)))),''''))as [LastModifiedBy]
        from RM00101 with (NOLOCK) left outer join SY03900 with (NOLOCK) on (RM00101.NOTEINDX = SY03900.NOTEINDX)')

/****** Object:  View [dbo].[ScribeOnline_CustomerAddress]    Script Date: 5/23/2016 4:15:21 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_CustomerAddress]') IS NULL AND OBJECT_ID(N'[dbo].[RM00102]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_CustomerAddress] AS select        [RM00102].[CITY] AS [City],
       [RM00102].[CNTCPRSN] AS [ContactPerson],
       [RM00102].[COUNTRY] AS [CountryRegion],
       [RM00102].[CCode] AS [CountryRegionCodeKey_Id],
       [RM00102].[CREATDDT] AS [CreatedDate],
       [RM00102].[FAX] AS [Fax],
       [SY01200].[INETINFO] AS [InternetAddresses_AdditionalInformation],
       [SY01200].[EmailBccAddress] AS [InternetAddresses_EmailBccAddress],
       [SY01200].[EmailCcAddress] AS [InternetAddresses_EmailCcAddress],
       [SY01200].[EmailToAddress] AS [InternetAddresses_EmailToAddress],
       [SY01200].[INET1] AS [InternetAddresses_InternetField1],
       [SY01200].[INET2] AS [InternetAddresses_InternetField2],
       [SY01200].[INET3] AS [InternetAddresses_InternetField3],
       [SY01200].[INET4] AS [InternetAddresses_InternetField4],
       [SY01200].[INET5] AS [InternetAddresses_InternetField5],
       [SY01200].[INET6] AS [InternetAddresses_InternetField6],
       [SY01200].[INET7] AS [InternetAddresses_InternetField7],
       [SY01200].[INET8] AS [InternetAddresses_InternetField8],
       [SY01200].[Messenger_Address] AS [InternetAddresses_MessengerAddress],
       [RM00102].[CUSTNMBR] AS [Key_CustomerKey_Id],
       [RM00102].[ADRSCODE] AS [Key_Id],
       [RM00102].[ADDRESS1] AS [Line1],
       [RM00102].[ADDRESS2] AS [Line2],
       [RM00102].[ADDRESS3] AS [Line3],
       [RM00102].[MODIFDT] AS [ModifiedDate],
       [RM00102].[ShipToName] AS [Name],
       [RM00102].[PHONE1] AS [Phone1],
       [RM00102].[PHONE2] AS [Phone2],
       [RM00102].[PHONE3] AS [Phone3],
       [RM00102].[ZIP] AS [PostalCode],
       [RM00102].[SLPRSNID] AS [SalespersonKey_Id],
       [RM00102].[SALSTERR] AS [SalesTerritoryKey_Id],
       [RM00102].[SHIPMTHD] AS [ShippingMethodKey_Id],
       [RM00102].[STATE] AS [State],
       [RM00102].[TAXSCHID] AS [TaxScheduleKey_Id],
       [RM00102].[UPSZONE] AS [UPSZone],
       [RM00102].[USERDEF1] AS [UserDefined1],
       [RM00102].[USERDEF2] AS [UserDefined2],
       [RM00102].[GPSFOINTEGRATIONID] AS [GPSFOIntegrationId],
       [RM00102].[INTEGRATIONID] AS [IntegrationId],
       [RM00102].[INTEGRATIONSOURCE] AS [IntegrationSource],
       [RM00102].[DECLID] AS [DeclarantId],
       [RM00102].[Print_Phone_NumberGB] AS [PrintPhoneNumberGB],
       [RM00102].[LOCNCODE] AS [LocationCode]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
        where ((EntityName=''RM00102'' and Id=RTRIM(RM00102.CUSTNMBR)+''|''+RTRIM(RM00102.ADRSCODE)) or (EntityName=''SY01200'' and Id=RTRIM(SY01200.Master_ID)+''|''+RTRIM(SY01200.ADRSCODE)+''|''+RTRIM(SY01200.Master_Type)))) as [LastModifiedDateTime],
        UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
        where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
        where ((EntityName=''RM00102'' and Id=RTRIM(RM00102.CUSTNMBR)+''|''+RTRIM(RM00102.ADRSCODE)) or (EntityName=''SY01200'' and Id=RTRIM(SY01200.Master_ID)+''|''+RTRIM(RM00102.ADRSCODE)+''|''+RTRIM(SY01200.Master_Type))))),'''')) as [LastModifiedBy]
        FROM RM00102 with (NOLOCK) left outer join SY01200 with (NOLOCK) on ( 
		RM00102.CUSTNMBR = SY01200.Master_ID AND  
		RM00102.ADRSCODE = SY01200.ADRSCODE AND  
		SY01200.Master_Type = ''CUS'')')

/****** Object:  View [dbo].[ScribeOnline_SalesOrder]    Script Date: 5/23/2016 4:15:22 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_SalesOrder]') IS NULL AND OBJECT_ID(N'[dbo].[SOP10100]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_SalesOrder] AS select        [SOP10100].[ACTLSHIP] AS [ActualShipDate],
       [SOP10100].[BACKDATE] AS [BackorderDate],
       [SOP10100].[BACHNUMB] AS [BatchKey_Id],
       [SOP10100].[BCHSOURC] AS [BatchKey_Source],
       [SOP10100].[PRBTADCD] AS [BillToAddressKey_Id],
       [SOP10100].[COMMNTID] AS [CommentKey_Id],
       [SOP10100].[COMMAMNT] AS [CommissionAmount_Value],
       [SOP10100].[CMMSLAMT] AS [CommissionSaleAmount_Value],
       [SOP10100].[CREATDDT] AS [CreatedDate],
       [SOP10100].[CUSTNMBR] AS [CustomerKey_Id],
       [SOP10100].[CUSTNAME] AS [CustomerName],
       [SOP10100].[CSTPONBR] AS [CustomerPONumber],
       [SOP10100].[DOCDATE] AS [Date],
       [SOP10100].[DYSTINCR] AS [DaysToIncrement],
       [SOP10100].[DOCID] AS [DocumentTypeKey_Id],
       [SOP10100].[EXCHDATE] AS [ExchangeDate],
       [SOP10100].[XCHGRATE] AS [ExchangeRate],
       [SOP10100].[FRTAMNT] AS [FreightAmount_Value],
       [SOP10100].[FRTTXAMT] AS [FreightTaxAmount_Value],
       [SOP10100].[FRTSCHID] AS [FreightTaxScheduleKey_Id],
       [SOP10100].[FUFILDAT] AS [FulfillDate],
       [SOP10100].[INTEGRATIONID] AS [IntegrationId],
       [SOP10100].[INTEGRATIONSOURCE] AS [IntegrationSource],
       [SOP10100].[INVODATE] AS [InvoiceDate],
       [SOP10100].[REPTING] AS [IsRepeating],
       [SOP10100].[SOPNUMBE] AS [Key_Id],
       [SOP10100].[MSTRNUMB] AS [MasterNumber],
       [SOP10100].[MISCAMNT] AS [MiscellaneousAmount_Value],
       [SOP10100].[MSCTXAMT] AS [MiscellaneousTaxAmount_Value],
       [SOP10100].[MSCSCHID] AS [MiscellaneousTaxScheduleKey_Id],
       [SOP10100].[MODIFDT] AS [ModifiedDate],
       [SOP10100].[ORIGNUMB] AS [OriginalSalesDocumentKey_Id],
       [SOP10100].[ORIGTYPE] AS [OriginalSalesDocumentType],
       [SOP10100].[PYMTRMID] AS [PaymentTermsKey_Id],
       [SOP10100].[PRCLEVEL] AS [PriceLevelKey_Id],
       [SOP10100].[QUOTEDAT] AS [QuoteDate],
       [SOP10100].[REFRENCE] AS [Reference],
       [SOP10100].[ReqShipDate] AS [RequestedShipDate],
       [SOP10100].[RETUDATE] AS [ReturnDate],
       [SOP10100].[SLPRSNID] AS [SalespersonKey_Id],
       [SOP10100].[SALSTERR] AS [SalesTerritoryKey_Id],
       [SOP10100].[SHIPMTHD] AS [ShippingMethodKey_Id],
       [SOP10100].[CITY] AS [ShipToAddress_City],
       [SOP10100].[COUNTRY] AS [ShipToAddress_CountryRegion],
       [SOP10100].[CCode] AS [ShipToAddress_CountryRegionCodeKey_Id],
       [SOP10100].[ADDRESS1] AS [ShipToAddress_Line1],
       [SOP10100].[ADDRESS2] AS [ShipToAddress_Line2],
       [SOP10100].[ADDRESS3] AS [ShipToAddress_Line3],
       [SOP10100].[ZIPCODE] AS [ShipToAddress_PostalCode],
       [SOP10100].[STATE] AS [ShipToAddress_State],
       [SOP10100].[CNTCPRSN] AS [ShipToAddress_ContactPerson],
       [SOP10100].[ShipToName] AS [ShipToAddress_Name],
       [SOP10100].[PRSTADCD] AS [ShipToAddressKey_Id],
       [SOP10100].[TAXAMNT] AS [TaxAmount_Value],
       [SOP10100].[TAXEXMT1] AS [TaxExemptNumber1],
       [SOP10100].[TAXEXMT2] AS [TaxExemptNumber2],
       [SOP10100].[TXRGNNUM] AS [TaxRegistrationNumber],
       [SOP10100].[TAXSCHID] AS [TaxScheduleKey_Id],
       [SOP10100].[TIMETREP] AS [TimesToRepeat],
       [SOP10100].[DOCAMNT] AS [TotalAmount_Value],
       [SOP10100].[UPSZONE] AS [UPSZone],
       [SOP10106].[USRDAT01] AS [UserDefined_Date01],
       [SOP10106].[USRDAT02] AS [UserDefined_Date02],
       [SOP10106].[USRTAB01] AS [UserDefined_List01],
       [SOP10106].[USRTAB09] AS [UserDefined_List02],
       [SOP10106].[USRTAB03] AS [UserDefined_List03],
       [SOP10106].[USERDEF1] AS [UserDefined_Text01],
       [SOP10106].[USERDEF2] AS [UserDefined_Text02],
       [SOP10106].[USRDEF03] AS [UserDefined_Text03],
       [SOP10106].[USRDEF04] AS [UserDefined_Text04],
       [SOP10106].[USRDEF05] AS [UserDefined_Text05],
       [SOP10100].[ACCTAMNT] AS [AccountAmount],
       [SOP10100].[ALLOCABY] AS [AllocateBy],
       [SOP10100].[APLYWITH] AS [ApplyWithholding],
       [SOP10100].[BackoutTradeDisc] AS [BackoutTradeDiscountAmount],
       [SOP10100].[BCKTXAMT] AS [BackoutTaxAmount],
       [SOP10100].[BKTFRTAM] AS [BackoutFreightAmount],
       [SOP10100].[BKTMSCAM] AS [BackoutMiscAmount],
       [SOP10100].[BSIVCTTL] AS [BasedOnInvoiceTotal],
       [SOP10100].[CODAMNT] AS [CODAmount],
       [SOP10100].[COMAPPTO] AS [CommissionAppliedTo],
       [SOP10100].[ContractExchangeRateStat] AS [ContractExchangeRateStatus],
       [SOP10100].[CORRCTN] AS [Correction],
       [SOP10100].[CORRNXST] AS [CorrectiontoNonexistingTransaction],
       [SOP10100].[CURRNIDX] AS [CurrencyIndex],
       [SOP10100].[DENXRATE] AS [DenominationExchangeRate],
       [SOP10100].[DEPRECVD] AS [DepositReceived],
       [SOP10100].[DIRECTDEBIT] AS [DirectDebit],
       [SOP10100].[DISAVAMT] AS [DiscountAvailableAmount],
       [SOP10100].[DISAVTKN] AS [DiscountAvailableTaken],
       [SOP10100].[DISCDATE] AS [DiscountDate],
       [SOP10100].[DISCFRGT] AS [DiscountAvailableFreight],
       [SOP10100].[DISCMISC] AS [DiscountAvailableMisc],
       [SOP10100].[DISCRTND] AS [DiscountReturned],
       [SOP10100].[DISTKNAM] AS [DiscountTakenAmount],
       [SOP10100].[DOCNCORR] AS [DocumentNumberCorrected],
       [SOP10100].[DSCDLRAM] AS [DiscountDollarAmount],
       [SOP10100].[DSCPCTAM] AS [DiscountPercentAmount],
       [SOP10100].[DSTBTCH1] AS [DestBatch1],
       [SOP10100].[DSTBTCH2] AS [DestBatch2],
       [SOP10100].[DTLSTREP] AS [DateLastRepeated],
       [SOP10100].[DUEDATE] AS [DueDate],
       [SOP10100].[ECTRX] AS [ECTransaction],
       [SOP10100].[EXCEPTIONALDEMAND] AS [ExceptionalDemand],
       [SOP10100].[EXGTBLID] AS [ExchangeTableId],
       [SOP10100].[EXTDCOST] AS [ExtendedCost],
       [SOP10100].[FAXNUMBR] AS [Fax],
       [SOP10100].[Flags] AS [Flags],
       [SOP10100].[FRGTTXBL] AS [FreightTaxable],
       [SOP10100].[GLPOSTDT] AS [GLPostingDate],
       [SOP10100].[GPSFOINTEGRATIONID] AS [GPSFOIntegrationId],
       [SOP10100].[LOCNCODE] AS [LocationCode],
       [SOP10100].[MCTRXSTT] AS [MCTransactionState],
       [SOP10100].[MISCTXBL] AS [MiscTaxable],
       [SOP10100].[MRKDNAMT] AS [MarkdownAmount],
       [SOP10100].[NCOMAMNT] AS [NonCommissionedAmount],
       [SOP10100].[NOTEINDX] AS [NoteIndex],
       [SOP10100].[OBTAXAMT] AS [OriginatingBackoutTaxAmount],
       [SOP10100].[OCOMMAMT] AS [OriginatingCommissionAmount],
       [SOP10100].[ORACTAMT] AS [OriginatingAccountAmount],
       [SOP10100].[ORBKTFRT] AS [OriginatingBackoutFreightAmount],
       [SOP10100].[ORBKTMSC] AS [OriginatingBackoutMiscAmount],
       [SOP10100].[ORCODAMT] AS [OriginatingCODAmount],
       [SOP10100].[ORCOSAMT] AS [OriginatingCommissionSalesAmount],
       [SOP10100].[ORDATKN] AS [OriginatingDiscountAvailableTaken],
       [SOP10100].[ORDAVAMT] AS [OriginatingDiscountAvailableAmount],
       [SOP10100].[ORDAVFRT] AS [OriginatingDiscountAvailableFreight],
       [SOP10100].[ORDAVMSC] AS [OriginatingDiscountAvailableMisc],
       [SOP10100].[ORDDLRAT] AS [OriginatingDiscountDollarAmount],
       [SOP10100].[ORDEPRVD] AS [OriginatingDepositReceived],
       [SOP10100].[ORDISRTD] AS [OriginatingDiscountReturned],
       [SOP10100].[ORDISTKN] AS [OriginatingDiscountTakenAmount],
       [SOP10100].[ORDOCAMT] AS [OriginatingDocumentAmount],
       [SOP10100].[ORDRDATE] AS [OrderDate],
       [SOP10100].[OREMSUBT] AS [OriginatingRemainingSubtotal],
       [SOP10100].[OREXTCST] AS [OriginatingExtendedCost],
       [SOP10100].[ORFRTAMT] AS [OriginatingFreightAmount],
       [SOP10100].[ORFRTTAX] AS [OriginatingFreightTaxAmount],
       [SOP10100].[OrigBackoutTradeDisc] AS [OriginatingBackoutTradeDiscountAmount],
       [SOP10100].[ORMISCAMT] AS [OriginatingMiscAmount],
       [SOP10100].[ORMRKDAM] AS [OriginatingMarkdownAmount],
       [SOP10100].[ORMSCTAX] AS [OriginatingMiscTaxAmount],
       [SOP10100].[ORNCMAMT] AS [OriginatingNonCommissionedAmount],
       [SOP10100].[ORPMTRVD] AS [OriginatingPaymentReceived],
       [SOP10100].[ORSUBTOT] AS [OriginatingSubtotal],
       [SOP10100].[ORTAXAMT] AS [OriginatingTaxAmount],
       [SOP10100].[ORTDISAM] AS [OriginatingTradeDiscountAmount],
       [SOP10100].[OTAXTAMT] AS [OriginatingTaxableTaxAmount],
       [SOP10100].[PCKSLPNO] AS [PackingSlipNumber],
       [SOP10100].[PHNUMBR1] AS [Phone1],
       [SOP10100].[PHNUMBR2] AS [Phone2],
       [SOP10100].[PHONE3] AS [Phone3],
       [SOP10100].[PICTICNU] AS [PickingTicketNumber],
       [SOP10100].[POSTEDDT] AS [PostedDate],
       [SOP10100].[Print_Phone_NumberGB] AS [PrintPhoneNumberGB],
       [SOP10100].[PROSPECT] AS [Prospect],
       [SOP10100].[PSTGSTUS] AS [PostingStatus],
       [SOP10100].[PTDUSRID] AS [PostedUserID],
       [SOP10100].[PYMTRCVD] AS [PaymentReceived],
       [SOP10100].[QUOEXPDA] AS [QuoteExpirationDate],
       [SOP10100].[RATETPID] AS [RateTypeId],
       [SOP10100].[REMSUBTO] AS [RemainingSubtotal],
       [SOP10100].[RTCLCMTD] AS [RateCalculationMethod],
       [SOP10100].[SALEDATE] AS [SaleDate],
       [SOP10100].[SEQNCORR] AS [SequenceNumberCorrected],
       [SOP10100].[SHIPCOMPLETE] AS [ShipCompleteDocument],
       [SOP10100].[SHPPGDOC] AS [ShippingDocument],
       [SOP10100].[SIMPLIFD] AS [Simplified],
       [SOP10100].[SOPHDRE1] AS [SalesOrderHeaderErrors1],
       [SOP10100].[SOPHDRE2] AS [SalesOrderHeaderErrors2],
       [SOP10100].[SOPHDRE3] AS [SalesOrderHeaderErrors3],
       [SOP10100].[SOPHDRFL] AS [SalesOrderHeaderFlags],
       [SOP10100].[SOPLNERR] AS [SalesOrderLineErrors],
       [SOP10100].[SOPMCERR] AS [SOPMCPostingErrorMessages],
       [SOP10100].[SOPSTATUS] AS [SOPStatus],
       [SOP10100].[SUBTOTAL] AS [Subtotal],
       [SOP10100].[Tax_Date] AS [TaxDate],
       [SOP10100].[TIME1] AS [Time],
       [SOP10100].[TIMEREPD] AS [TimesRepeated],
       [SOP10100].[TIMESPRT] AS [TimesPrinted],
       [SOP10100].[TRDISAMT] AS [TradeDiscountAmount],
       [SOP10100].[TRDISPCT] AS [TradeDiscountPercent],
       [SOP10100].[TRXFREQU] AS [TRXFrequency],
       [SOP10100].[TRXSORCE] AS [TRXSource],
       [SOP10100].[TXBTXAMT] AS [TaxableTaxAmount],
       [SOP10100].[TXENGCLD] AS [TaxEngineCalled],
       [SOP10100].[TXSCHSRC] AS [TaxScheduleSource],
       [SOP10100].[USDOCID1] AS [UseDocumentID1],
       [SOP10100].[USDOCID2] AS [UseDocumentID2],
       [SOP10100].[USER2ENT] AS [UserToEnter],
       [SOP10100].[VOIDSTTS] AS [VoidStatus],
       [SOP10100].[WITHHAMT] AS [WithholdingAmount],
       [SOP10100].[WorkflowApprStatCreditLm] AS [WorkflowApprovalStatusCreditLimit],
       [SOP10100].[WorkflowApprStatusQuote] AS [WorkflowApprovalStatusQuote],
       [SOP10100].[WorkflowPriorityCreditLm] AS [WorkflowPriorityCreditLimit],
       [SOP10100].[WorkflowPriorityQuote] AS [WorkflowPriorityQuote],
       [SOP10100].[CURNCYID] AS [CurrencyId]
,
            (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
            where ((EntityName=''SOP10100'' and Id=RTRIM(SOP10100.SOPNUMBE)+''|''+RTRIM(SOP10100.SOPTYPE)) or (EntityName=''SOP10106'' and Id=RTRIM(SOP10100.SOPNUMBE)+''|''+RTRIM(SOP10100.SOPTYPE)))) as [LastModifiedDateTime],
            UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
            where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
            where ((EntityName=''SOP10100'' and Id=RTRIM(SOP10100.SOPNUMBE)+''|''+RTRIM(SOP10100.SOPTYPE)) or (EntityName=''SOP10106'' and Id=RTRIM(SOP10100.SOPNUMBE)+''|''+RTRIM(SOP10100.SOPTYPE))))),'''')) as [LastModifiedBy]
            FROM SOP10100 (nolock) left outer join SOP10106 with (NOLOCK) on (SOP10100.SOPNUMBE = SOP10106.SOPNUMBE and SOP10100.SOPTYPE = SOP10106.SOPTYPE)
            WHERE SOP10100.SOPTYPE = 2 ')

/****** Object:  View [dbo].[ScribeOnline_SalesOrderLine]    Script Date: 5/23/2016 4:15:23 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_SalesOrderLine]') IS NULL AND OBJECT_ID(N'[dbo].[SOP10200]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_SalesOrderLine] AS select        [SOP10200].[ACTLSHIP] AS [ActualShipDate],
       [SOP10200].[FUFILDAT] AS [FulfillDate],
       [SOP10200].[ATYALLOC] AS [QuantityAllocated_Value],
       [SOP10200].[QTYCANCE] AS [QuantityCanceled_Value],
       [SOP10200].[QTYFULFI] AS [QuantityFulfilled_Value],
       [SOP10200].[QTYTBAOR] AS [QuantityToBackorder_Value],
       [SOP10200].[QTYTOINV] AS [QuantityToInvoice_Value],
       [SOP10202].[CMMTTEXT] AS [Comment],
       [SOP10200].[COMMNTID] AS [CommentKey_Id],
      (SELECT [ACTNUMST] FROM [GL00105] with (NOLOCK) WHERE [GL00105].[ACTINDX] = [SOP10200].[CSLSINDX]) AS [CostOfSalesGLAccountKey_Id],
      (SELECT [ACTNUMST] FROM [GL00105] with (NOLOCK) WHERE [GL00105].[ACTINDX] = [SOP10200].[DMGDINDX]) AS [DamagedGLAccountKey_Id],
      (SELECT [ACTNUMST] FROM [GL00105] with (NOLOCK) WHERE [GL00105].[ACTINDX] = [SOP10200].[MKDNINDX]) AS [DiscountGLAccountKey_Id],
       [SOP10200].[EXTDCOST] AS [ExtendedCost_Value],
      (SELECT [ACTNUMST] FROM [GL00105] with (NOLOCK) WHERE [GL00105].[ACTINDX] = [SOP10200].[INSRINDX]) AS [InServiceGLAccountKey_Id],
      (SELECT [ACTNUMST] FROM [GL00105] with (NOLOCK) WHERE [GL00105].[ACTINDX] = [SOP10200].[INUSINDX]) AS [InUseGLAccountKey_Id],
       [SOP10200].[INTEGRATIONID] AS [IntegrationId],
       [SOP10200].[INTEGRATIONSOURCE] AS [IntegrationSource],
      (SELECT [ACTNUMST] FROM [GL00105] with (NOLOCK) WHERE [GL00105].[ACTINDX] = [SOP10200].[INVINDX]) AS [InventoryGLAccountKey_Id],
       [SOP10200].[DROPSHIP] AS [IsDropShip],
       [SOP10200].[NONINVEN] AS [IsNonInventory],
       [SOP10200].[ITEMDESC] AS [ItemDescription],
       [SOP10200].[ITEMNMBR] AS [ItemKey_Id],
       [SOP10200].[ITMTSHID] AS [ItemTaxScheduleKey_Id],
       [SOP10200].[LNITMSEQ] AS [Key_LineSequenceNumber],
       [SOP10200].[SOPNUMBE] AS [Key_SalesDocumentKey_Id],
       [SOP10200].[PRCLEVEL] AS [PriceLevelKey_Id],
       [SOP10200].[QUANTITY] AS [Quantity_Value],
       [SOP10200].[ReqShipDate] AS [RequestedShipDate],
      (SELECT [ACTNUMST] FROM [GL00105] with (NOLOCK) WHERE [GL00105].[ACTINDX] = [SOP10200].[RTNSINDX]) AS [ReturnsGLAccountKey_Id],
      (SELECT [ACTNUMST] FROM [GL00105] with (NOLOCK) WHERE [GL00105].[ACTINDX] = [SOP10200].[SLSINDX]) AS [SalesGLAccountKey_Id],
       [SOP10200].[SALSTERR] AS [SalesTerritoryKey_Id],
       [SOP10200].[SLPRSNID] AS [SalespersonKey_Id],
       [SOP10200].[CNTCPRSN] AS [ShipToAddress_ContactPerson],
       [SOP10200].[ShipToName] AS [ShipToAddress_Name],
       [SOP10200].[CCode] AS [ShipToAddress_CountryRegionCodeKey_Id],
       [SOP10200].[COUNTRY] AS [ShipToAddress_CountryRegion],
       [SOP10200].[CITY] AS [ShipToAddress_City],
       [SOP10200].[ADDRESS1] AS [ShipToAddress_Line1],
       [SOP10200].[ADDRESS2] AS [ShipToAddress_Line2],
       [SOP10200].[ADDRESS3] AS [ShipToAddress_Line3],
       [SOP10200].[ZIPCODE] AS [ShipToAddress_PostalCode],
       [SOP10200].[STATE] AS [ShipToAddress_State],
       [SOP10200].[PRSTADCD] AS [ShipToAddressKey_Id],
       [SOP10200].[SHIPMTHD] AS [ShippingMethodKey_Id],
       [SOP10200].[TAXAMNT] AS [TaxAmount_Value],
       [SOP10200].[TAXSCHID] AS [TaxScheduleKey_Id],
       [SOP10200].[UNITCOST] AS [UnitCost_Value],
       [SOP10200].[UNITPRCE] AS [UnitPrice_Value],
       [SOP10200].[UOFM] AS [UofM],
       [SOP10200].[BackoutTradeDisc] AS [BackoutTradeDiscountAmount],
       [SOP10200].[BKTSLSAM] AS [BackoutSalesAmount],
       [SOP10200].[BRKFLD1] AS [BreakField1],
       [SOP10200].[BRKFLD2] AS [BreakField2],
       [SOP10200].[BRKFLD3] AS [BreakField3],
       [SOP10200].[BSIVCTTL] AS [BasedOnInvoiceTotal],
       [SOP10200].[BULKPICKPRNT] AS [BulkPickPrinted],
       [SOP10200].[CMPNTSEQ] AS [ComponentSequence],
       [SOP10200].[CONTENDDTE] AS [ContractEndDate],
       [SOP10200].[CONTITEMNBR] AS [ContractItemNumber],
       [SOP10200].[CONTLNSEQNBR] AS [ContractLineSEQNumber],
       [SOP10200].[CONTNBR] AS [ContractNumber],
       [SOP10200].[CONTSERIALNBR] AS [ContractSerialNumber],
       [SOP10200].[CONTSTARTDTE] AS [ContractStartDate],
       [SOP10200].[CURRNIDX] AS [CurrencyIndex],
       [SOP10200].[DECPLCUR] AS [DecimalPlacesCurrency],
       [SOP10200].[DECPLQTY] AS [DecimalPlacesQuantities],
       [SOP10200].[DISCSALE] AS [DiscountAvailableSales],
       [SOP10200].[EXCEPTIONALDEMAND] AS [ExceptionalDemand],
       [SOP10200].[EXTQTYAL] AS [ExistingQuantityAvailable],
       [SOP10200].[EXTQTYSEL] AS [ExistingQuantitySelected],
       [SOP10200].[FAXNUMBR] AS [Fax],
       [SOP10200].[Flags] AS [Flags],
       [SOP10200].[GPSFOINTEGRATIONID] AS [GPSFOIntegrationID],
       [SOP10200].[INDPICKPRNT] AS [IndividualPickPrinted],
       [SOP10200].[ISLINEINTRA] AS [IsLineIntrastat],
       [SOP10200].[ITEMCODE] AS [ItemCode],
       [SOP10200].[IVITMTXB] AS [IVItemTaxable],
       [SOP10200].[LOCNCODE] AS [LocationCode],
       [SOP10200].[MRKDNAMT] AS [MarkdownAmount],
       [SOP10200].[MRKDNPCT] AS [MarkdownPercent],
       [SOP10200].[MRKDNTYP] AS [MarkdownType],
       [SOP10200].[MULTIPLEBINS] AS [MultipleBins],
       [SOP10200].[ODECPLCU] AS [OriginatingDecimalPlacesCurrency],
       [SOP10200].[ORBKTSLS] AS [OriginatingBackoutSalesAmount],
       [SOP10200].[ORDAVSLS] AS [OriginatingDiscountAvailableSales],
       [SOP10200].[OREPRICE] AS [OriginatingRemainingPrice],
       [SOP10200].[OREXTCST] AS [OriginatingExtendedCost],
       [SOP10200].[ORGSEQNM] AS [OriginalSequenceNumberCorrected],
       [SOP10200].[OrigBackoutTradeDisc] AS [OriginatingBackoutTradeDiscountAmount],
       [SOP10200].[ORMRKDAM] AS [OriginatingMarkdownAmount],
       [SOP10200].[ORTAXAMT] AS [OriginatingTaxAmount],
       [SOP10200].[ORTDISAM] AS [OriginatingTradeDiscountAmount],
       [SOP10200].[ORUNTCST] AS [OriginatingUnitCost],
       [SOP10200].[ORUNTPRC] AS [OriginatingUnitPrice],
       [SOP10200].[OTAXTAMT] AS [OriginatingTaxableTaxAmount],
       [SOP10200].[OXTNDPRC] AS [OriginatingExtendedPrice],
       [SOP10200].[PHONE1] AS [Phone1],
       [SOP10200].[PHONE2] AS [Phone2],
       [SOP10200].[PHONE3] AS [Phone3],
       [SOP10200].[PURCHSTAT] AS [PurchasingStatus],
       [SOP10200].[QTYBSUOM] AS [QuantityInBaseUOfM],
       [SOP10200].[QTYCANOT] AS [QuantityCanceledOther],
       [SOP10200].[QTYDMGED] AS [QuantityDamaged],
       [SOP10200].[QTYINSVC] AS [QuantityInService],
       [SOP10200].[QTYINUSE] AS [QuantityInUse],
       [SOP10200].[QTYONHND] AS [QuantityOnHand],
       [SOP10200].[QTYONPO] AS [QuantityOnPO],
       [SOP10200].[QTYORDER] AS [QuantityOrdered],
       [SOP10200].[QTYPRBAC] AS [QuantityPrevBackOrdered],
       [SOP10200].[QTYPRBOO] AS [QuantityPrevBOOnOrder],
       [SOP10200].[QTYPRINV] AS [QuantityPrevInvoiced],
       [SOP10200].[QTYPRORD] AS [QuantityPrevOrdered],
       [SOP10200].[QTYPRVRECVD] AS [QuantityPrevReceived],
       [SOP10200].[QTYRECVD] AS [QuantityReceived],
       [SOP10200].[QTYREMAI] AS [QuantityRemaining],
       [SOP10200].[QTYREMBO] AS [QuantityRemainingOnBO],
       [SOP10200].[QTYRTRND] AS [QuantityReturned],
       [SOP10200].[QTYSLCTD] AS [QuantitySelected],
       [SOP10200].[QTYTORDR] AS [QuantityToOrder],
       [SOP10200].[QTYTOSHP] AS [QuantityToShip],
       [SOP10200].[REMPRICE] AS [RemainingPrice],
       [SOP10200].[SOFULFILLMENTBIN] AS [SOFulfillmentBin],
       [SOP10200].[SOPLNERR] AS [SOPLINEErrors],
       [SOP10200].[TRDISAMT] AS [TradeDiscountAmount],
       [SOP10200].[TRXSORCE] AS [TRXSource],
       [SOP10200].[TXBTXAMT] AS [TaxableTaxAmount],
       [SOP10200].[TXSCHSRC] AS [TaxScheduleSource],
       [SOP10200].[XFRSHDOC] AS [TransferredToShippingDocument],
       [SOP10200].[XTNDPRCE] AS [ExtendedPrice],
       [SOP10200].[Print_Phone_NumberGB] AS [PrintPhoneNumberGB],
      (SELECT [ACTNUMST] FROM [GL00105] with (NOLOCK) WHERE [GL00105].[ACTINDX] = [SOP10200].[MKDNINDX]) AS [MarkdownAmountGLAccountId]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
         where ((EntityName=''SOP10200'' and Id=RTRIM(SOP10200.SOPNUMBE)+''|''+RTRIM(SOP10200.SOPTYPE)+''|''+RTRIM(SOP10200.CMPNTSEQ)+''|''+RTRIM(SOP10200.LNITMSEQ)) or (EntityName=''SOP10202'' and Id=RTRIM(SOP10202.SOPNUMBE)+''|''+RTRIM(SOP10202.SOPTYPE)+''|''+RTRIM(SOP10202.CMPNTSEQ)+''|''+RTRIM(SOP10202.LNITMSEQ)))) as [LastModifiedDateTime],
         UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
         where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
         where ((EntityName=''SOP10200'' and Id=RTRIM(SOP10200.SOPNUMBE)+''|''+RTRIM(SOP10200.SOPTYPE)+''|''+RTRIM(SOP10200.CMPNTSEQ)+''|''+RTRIM(SOP10200.LNITMSEQ)) or (EntityName=''SOP10202'' and Id=RTRIM(SOP10202.SOPNUMBE)+''|''+RTRIM(SOP10202.SOPTYPE)+''|''+RTRIM(SOP10202.CMPNTSEQ)+''|''+RTRIM(SOP10202.LNITMSEQ))))),'''')) as [LastModifiedBy]
         FROM SOP10200 with (NOLOCK) left outer join SOP10202 with (NOLOCK) on (SOP10200.SOPTYPE = SOP10202.SOPTYPE and SOP10200.SOPNUMBE = SOP10202.SOPNUMBE and SOP10200.LNITMSEQ = SOP10202.LNITMSEQ and SOP10200.CMPNTSEQ = SOP10202.CMPNTSEQ)
         WHERE SOP10200.SOPTYPE = 2 ')

/****** Object:  View [dbo].[ScribeOnline_GLTransaction]    Script Date: 5/23/2016 4:15:23 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_GLTransaction]') IS NULL AND OBJECT_ID(N'[dbo].[GL10000]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_GLTransaction] AS select        [ScribeOnline_GLTransactionHeaderBase].[TrxState] AS [TransactionState],
       [ScribeOnline_GLTransactionHeaderBase].[BACHNUMB] AS [BatchKey_Id],
       [ScribeOnline_GLTransactionHeaderBase].[BCHSOURC] AS [BatchKey_Source],
       [ScribeOnline_GLTransactionHeaderBase].[CURNCYID] AS [CurrencyKey_ISOCode],
       [ScribeOnline_GLTransactionHeaderBase].[EXCHDATE] AS [ExchangeDate],
       [ScribeOnline_GLTransactionHeaderBase].[XCHGRATE] AS [ExchangeRate],
       [ScribeOnline_GLTransactionHeaderBase].[VOIDED] AS [IsVoided],
       [ScribeOnline_GLTransactionHeaderBase].[TRXTYPE] AS [GLLedgerType],
       [ScribeOnline_GLTransactionHeaderBase].[DOCDATE] AS [Key_Date],
       [ScribeOnline_GLTransactionHeaderBase].[JRNENTRY] AS [Key_JournalId],
       [ScribeOnline_GLTransactionHeaderBase].[LASTUSER] AS [ModifiedBy],
       [ScribeOnline_GLTransactionHeaderBase].[LSTDTEDT] AS [ModifiedDate],
       [ScribeOnline_GLTransactionHeaderBase].[ORPSTDDT] AS [OriginatingDocument_PostedDate],
       [ScribeOnline_GLTransactionHeaderBase].[OrigDTASeries] AS [OriginatingDocument_Series],
       [ScribeOnline_GLTransactionHeaderBase].[USWHPSTD] AS [PostedBy],
       [ScribeOnline_GLTransactionHeaderBase].[REFRENCE] AS [Reference],
       [ScribeOnline_GLTransactionHeaderBase].[SOURCDOC] AS [SourceDocumentKey_Id],
       [ScribeOnline_GLTransactionHeaderBase].[RCTRXSEQ] AS [RecurringTRXSequence],
       [ScribeOnline_GLTransactionHeaderBase].[TRXDATE] AS [TRXDate],
       [ScribeOnline_GLTransactionHeaderBase].[RVRSNGDT] AS [ReversingDate],
       [ScribeOnline_GLTransactionHeaderBase].[RCRNGTRX] AS [RecurringTRX],
       [ScribeOnline_GLTransactionHeaderBase].[BALFRCLC] AS [BalanceForCalculation],
       [ScribeOnline_GLTransactionHeaderBase].[PSTGSTUS] AS [PostingStatus],
       [ScribeOnline_GLTransactionHeaderBase].[LASTUSER] AS [LastUser],
       [ScribeOnline_GLTransactionHeaderBase].[LSTDTEDT] AS [LastDateEdited],
       [ScribeOnline_GLTransactionHeaderBase].[USWHPSTD] AS [UserWhoPosted],
       [ScribeOnline_GLTransactionHeaderBase].[SQNCLINE] AS [SequenceLine],
       [ScribeOnline_GLTransactionHeaderBase].[GLHDRMSG] AS [GLHDRMessages],
       [ScribeOnline_GLTransactionHeaderBase].[GLHDRMS2] AS [GLHDRMessages2],
       [ScribeOnline_GLTransactionHeaderBase].[TRXSORCE] AS [TRXSource],
       [ScribeOnline_GLTransactionHeaderBase].[RVTRXSRC] AS [ReversingTRXSource],
       [ScribeOnline_GLTransactionHeaderBase].[SERIES] AS [Series],
       [ScribeOnline_GLTransactionHeaderBase].[ORTRXSRC] AS [OriginatingTRXSource],
       [ScribeOnline_GLTransactionHeaderBase].[DTAControlNum] AS [DTAControlNumber],
       [ScribeOnline_GLTransactionHeaderBase].[DTATRXType] AS [DTATRXType],
       [ScribeOnline_GLTransactionHeaderBase].[DTA_Index] AS [DTAIndex],
       [ScribeOnline_GLTransactionHeaderBase].[CURRNIDX] AS [CurrencyIndex],
       [ScribeOnline_GLTransactionHeaderBase].[RATETPID] AS [RateTypeId],
       [ScribeOnline_GLTransactionHeaderBase].[EXGTBLID] AS [ExchangeTableId],
       [ScribeOnline_GLTransactionHeaderBase].[TIME1] AS [Time],
       [ScribeOnline_GLTransactionHeaderBase].[RTCLCMTD] AS [RateCalculationMethod],
       [ScribeOnline_GLTransactionHeaderBase].[NOTEINDX] AS [NoteIndex],
       [ScribeOnline_GLTransactionHeaderBase].[GLHDRVAL] AS [GLHeaderValid],
       [ScribeOnline_GLTransactionHeaderBase].[PERIODID] AS [PeriodId],
       [ScribeOnline_GLTransactionHeaderBase].[OPENYEAR] AS [OpenYear],
       [ScribeOnline_GLTransactionHeaderBase].[CLOSEDYR] AS [ClosedYear],
       [ScribeOnline_GLTransactionHeaderBase].[HISTRX] AS [HistoryTRX],
       [ScribeOnline_GLTransactionHeaderBase].[REVPRDID] AS [ReversingPeriodId],
       [ScribeOnline_GLTransactionHeaderBase].[REVYEAR] AS [ReversingYear],
       [ScribeOnline_GLTransactionHeaderBase].[REVCLYR] AS [ReversingClosedYear],
       [ScribeOnline_GLTransactionHeaderBase].[REVHIST] AS [ReversingHistoryTRX],
       [ScribeOnline_GLTransactionHeaderBase].[ERRSTATE] AS [ErrorState],
       [ScribeOnline_GLTransactionHeaderBase].[ICTRX] AS [ICTRX],
       [ScribeOnline_GLTransactionHeaderBase].[ORCOMID] AS [OriginatingCompanyId],
       [ScribeOnline_GLTransactionHeaderBase].[ORIGINJE] AS [OriginatingJournalEntry],
       [ScribeOnline_GLTransactionHeaderBase].[Ledger_ID] AS [LedgerId],
       [ScribeOnline_GLTransactionHeaderBase].[DEX_ROW_ID] AS [DexRowId]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
        where ((EntityName=''GL10000'' and Id=RTRIM([BACHNUMB])+''|''+RTRIM([BCHSOURC])+''|''+RTRIM([JRNENTRY]))
		or (EntityName IN (''GL20000'', ''GL30000'') and Id=RTRIM([DEX_ROW_ID])))) as [LastModifiedDateTime],
		UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
        where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
        where ((EntityName=''GL10000'' and Id=RTRIM([BACHNUMB])+''|''+RTRIM([BCHSOURC])+''|''+RTRIM([JRNENTRY]))
		or (EntityName IN (''GL20000'', ''GL30000'') and Id=RTRIM([DEX_ROW_ID])))
				)),''''))as [LastModifiedBy]
        from [ScribeOnline_GLTransactionHeaderBase] with (NOLOCK)')

/****** Object:  View [dbo].[ScribeOnline_PayablesInvoice]    Script Date: 5/23/2016 4:15:24 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_PayablesInvoice]') IS NULL AND OBJECT_ID(N'[dbo].[PM10000]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_PayablesInvoice] AS select [ScribeOnline_PayablesBase].[VADDCDPR] AS [AddressKey_Id],
       [ScribeOnline_PayablesBase].[PYMTRMID] AS [PaymentTermsKey_Id],
       [ScribeOnline_PayablesBase].[CDOCNMBR] AS [Payment_Cash_DocumentId],
       [ScribeOnline_PayablesBase].[CASHAMNT] AS [Payment_Cash_Amount_Value],
       [ScribeOnline_PayablesBase].[CAMCBKID] AS [Payment_Cash_BankAccountKey_Id],
       [ScribeOnline_PayablesBase].[CAMTDATE] AS [Payment_Cash_Date],
       [ScribeOnline_PayablesBase].[CAMPMTNM] AS [Payment_Cash_Number],
       [ScribeOnline_PayablesBase].[CHEKAMNT] AS [Payment_Check_Amount_Value],
       [ScribeOnline_PayablesBase].[CHAMCBID] AS [Payment_Check_BankAccountKey_Id],
       [ScribeOnline_PayablesBase].[CHEKNMBR] AS [Payment_Check_CheckNumber],
       [ScribeOnline_PayablesBase].[CHEKDATE] AS [Payment_Check_Date],
       [ScribeOnline_PayablesBase].[CAMPYNBR] AS [Payment_Check_Number],
       [ScribeOnline_PayablesBase].[CRCRDAMT] AS [Payment_PaymentCard_Amount_Value],
       [ScribeOnline_PayablesBase].[CRCARDDT] AS [Payment_PaymentCard_Date],
       [ScribeOnline_PayablesBase].[CCAMPYNM] AS [Payment_PaymentCard_Number],
       [ScribeOnline_PayablesBase].[CCRCTNUM] AS [Payment_PaymentCard_ReceiptNumber],
       [ScribeOnline_PayablesBase].[CARDNAME] AS [Payment_PaymentCard_TypeKey_Id],
       [ScribeOnline_PayablesBase].[APDSTKAM] AS [Terms_DiscountAmountAppliedTaken_Value],
       [ScribeOnline_PayablesBase].[DISTKNAM] AS [Terms_DiscountTakenAmount_Value],
       [ScribeOnline_PayablesBase].[DISAMTAV] AS [Terms_DiscountAvailableAmount_Value],
       [ScribeOnline_PayablesBase].[DISCDATE] AS [Terms_DiscountDate],
       [ScribeOnline_PayablesBase].[DUEDATE] AS [Terms_DueDate],
       [ScribeOnline_PayablesBase].[WROFAMNT] AS [WriteoffAmount_Value],
       [ScribeOnline_PayablesBase].[TEN99AMNT] AS [Amount1099_Value],
       [ScribeOnline_PayablesBase].[BACHNUMB] AS [BatchKey_Id],
       [ScribeOnline_PayablesBase].[BCHSOURC] AS [BatchKey_Source],
       [ScribeOnline_PayablesBase].[CHRGAMNT] AS [ChargeAmount_Value],
       [ScribeOnline_PayablesBase].[CURNCYID] AS [CurrencyKey_ISOCode],
       [ScribeOnline_PayablesBase].[DOCDATE] AS [Date],
       [ScribeOnline_PayablesBase].[TRXDSCRN] AS [Description],
       [ScribeOnline_PayablesBase].[DOCAMNT] AS [DocumentAmount_Value],
       [ScribeOnline_PayablesBase].[EXCHDATE] AS [ExchangeDate],
       [ScribeOnline_PayablesBase].[XCHGRATE] AS [ExchangeRate],
       [ScribeOnline_PayablesBase].[FRTAMNT] AS [FreightAmount_Value],
       [ScribeOnline_PayablesBase].[FRTSCHID] AS [FreightTaxScheduleKey_Id],
       [ScribeOnline_PayablesBase].[PSTGDATE] AS [GeneralLedgerPostingDate],
       [ScribeOnline_PayablesBase].[ICDISTS] AS [HasIntercompanyDistributions],
       [ScribeOnline_PayablesBase].[ICTRX] AS [IsIntercompanyTransaction],
       [ScribeOnline_PayablesBase].[VOIDED] AS [IsVoided],
       [ScribeOnline_PayablesBase].[VCHRNMBR] AS [Key_Id],
       [ScribeOnline_PayablesBase].[MSCCHAMT] AS [MiscellaneousAmount_Value],
       [ScribeOnline_PayablesBase].[MSCSCHID] AS [MiscellaneousTaxScheduleKey_Id],
       [ScribeOnline_PayablesBase].[MDFUSRID] AS [ModifiedBy],
       [ScribeOnline_PayablesBase].[MODIFDT] AS [ModifiedDate],
       [ScribeOnline_PayablesBase].[PORDNMBR] AS [PONumber],
       [ScribeOnline_PayablesBase].[PTDUSRID] AS [PostedBy],
       [ScribeOnline_PayablesBase].[POSTEDDT] AS [PostedDate],
       [ScribeOnline_PayablesBase].[PCHSCHID] AS [PurchaseTaxScheduleKey_Id],
       [ScribeOnline_PayablesBase].[PRCHAMNT] AS [PurchasesAmount_Value],
       [ScribeOnline_PayablesBase].[VADCDTRO] AS [RemitToAddressKey_Id],
       [ScribeOnline_PayablesBase].[SHIPMTHD] AS [ShippingMethodKey_Id],
       [ScribeOnline_PayablesBase].[TAXAMNT] AS [TaxAmount_Value],
       [ScribeOnline_PayablesBase].[Tax_Date] AS [TaxDate],
       [ScribeOnline_PayablesBase].[TAXSCHID] AS [TaxScheduleKey_Id],
       [ScribeOnline_PayablesBase].[TRDISAMT] AS [TradeDiscountAmount_Value],
       [ScribeOnline_PayablesBase].[TrxState] AS [TransactionState],
       [ScribeOnline_PayablesBase].[DOCNUMBR] AS [VendorDocumentNumber],
       [ScribeOnline_PayablesBase].[VENDORID] AS [VendorKey_Id],
       [ScribeOnline_PayablesBase].[VENDNAME] AS [VendorName],
       [ScribeOnline_PayablesBase].[CNTRLTYP] AS [ControlType],
       [ScribeOnline_PayablesBase].[BKTFRTAM] AS [BackoutFreightAmount],
       [ScribeOnline_PayablesBase].[BKTMSCAM] AS [BackoutMiscAmount],
       [ScribeOnline_PayablesBase].[BKTPURAM] AS [BackoutPurchasesAmount],
       [ScribeOnline_PayablesBase].[PRCTDISC] AS [PercentDiscount],
       [ScribeOnline_PayablesBase].[DSCDLRAM] AS [ DiscountDollarAmount],
       [ScribeOnline_PayablesBase].[RETNAGAM] AS [RetainageAmount],
       [ScribeOnline_PayablesBase].[PRCHDATE] AS [PurchaseDate],
       [ScribeOnline_PayablesBase].[CORRCTN] AS [Correction],
       [ScribeOnline_PayablesBase].[SIMPLIFD] AS [Simplified],
       [ScribeOnline_PayablesBase].[APLYWITH] AS [ApplyWithholding],
       [ScribeOnline_PayablesBase].[Electronic] AS [Electronic],
       [ScribeOnline_PayablesBase].[ECTRX] AS [ECTransaction]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
        where (EntityName IN (''PM10000'',''PM20000'',''PM30200'') and Id=RTRIM([ScribeOnline_PayablesBase].[VCHRNMBR])+''|''+RTRIM([ScribeOnline_PayablesBase].[DOCTYPE]))) as [LastModifiedDateTime],
        UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
        where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
        where (EntityName IN (''PM10000'',''PM20000'',''PM30200'') and Id=RTRIM([ScribeOnline_PayablesBase].[VCHRNMBR])+''|''+RTRIM([ScribeOnline_PayablesBase].[DOCTYPE])))),''''))as [LastModifiedBy]
        from [ScribeOnline_PayablesBase] with (NOLOCK) WHERE [ScribeOnline_PayablesBase].[DOCTYPE] = 1')

/****** Object:  View [dbo].[ScribeOnline_PayablesFinanceCharge]    Script Date: 5/23/2016 4:15:24 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_PayablesFinanceCharge]') IS NULL AND OBJECT_ID(N'[dbo].[PM10000]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_PayablesFinanceCharge] AS select        [ScribeOnline_PayablesBase].[VADDCDPR] AS [AddressKey_Id],
       [ScribeOnline_PayablesBase].[CDOCNMBR] AS [Payment_Cash_DocumentId],
       [ScribeOnline_PayablesBase].[CASHAMNT] AS [Payment_Cash_Amount_Value],
       [ScribeOnline_PayablesBase].[CAMCBKID] AS [Payment_Cash_BankAccountKey_Id],
       [ScribeOnline_PayablesBase].[CAMTDATE] AS [Payment_Cash_Date],
       [ScribeOnline_PayablesBase].[CAMPMTNM] AS [Payment_Cash_Number],
       [ScribeOnline_PayablesBase].[CHEKAMNT] AS [Payment_Check_Amount_Value],
       [ScribeOnline_PayablesBase].[CHAMCBID] AS [Payment_Check_BankAccountKey_Id],
       [ScribeOnline_PayablesBase].[CHEKNMBR] AS [Payment_Check_CheckNumber],
       [ScribeOnline_PayablesBase].[CHEKDATE] AS [Payment_Check_Date],
       [ScribeOnline_PayablesBase].[CAMPYNBR] AS [Payment_Check_Number],
       [ScribeOnline_PayablesBase].[CRCRDAMT] AS [Payment_PaymentCard_Amount_Value],
       [ScribeOnline_PayablesBase].[CRCARDDT] AS [Payment_PaymentCard_Date],
       [ScribeOnline_PayablesBase].[CCAMPYNM] AS [Payment_PaymentCard_Number],
       [ScribeOnline_PayablesBase].[CCRCTNUM] AS [Payment_PaymentCard_ReceiptNumber],
       [ScribeOnline_PayablesBase].[CARDNAME] AS [Payment_PaymentCard_TypeKey_Id],
       [ScribeOnline_PayablesBase].[APDSTKAM] AS [Terms_DiscountAmountAppliedTaken_Value],
       [ScribeOnline_PayablesBase].[DISTKNAM] AS [Terms_DiscountTakenAmount_Value],
       [ScribeOnline_PayablesBase].[DISAMTAV] AS [Terms_DiscountAvailableAmount_Value],
       [ScribeOnline_PayablesBase].[DISCDATE] AS [Terms_DiscountDate],
       [ScribeOnline_PayablesBase].[DUEDATE] AS [Terms_DueDate],
       [ScribeOnline_PayablesBase].[WROFAMNT] AS [WriteoffAmount_Value],
       [ScribeOnline_PayablesBase].[TEN99AMNT] AS [Amount1099_Value],
       [ScribeOnline_PayablesBase].[BACHNUMB] AS [BatchKey_Id],
       [ScribeOnline_PayablesBase].[BCHSOURC] AS [BatchKey_Source],
       [ScribeOnline_PayablesBase].[CHRGAMNT] AS [ChargeAmount_Value],
       [ScribeOnline_PayablesBase].[CURNCYID] AS [CurrencyKey_ISOCode],
       [ScribeOnline_PayablesBase].[DOCDATE] AS [Date],
       [ScribeOnline_PayablesBase].[TRXDSCRN] AS [Description],
       [ScribeOnline_PayablesBase].[DOCAMNT] AS [DocumentAmount_Value],
       [ScribeOnline_PayablesBase].[EXCHDATE] AS [ExchangeDate],
       [ScribeOnline_PayablesBase].[XCHGRATE] AS [ExchangeRate],
       [ScribeOnline_PayablesBase].[FRTAMNT] AS [FreightAmount_Value],
       [ScribeOnline_PayablesBase].[FRTSCHID] AS [FreightTaxScheduleKey_Id],
       [ScribeOnline_PayablesBase].[PSTGDATE] AS [GeneralLedgerPostingDate],
       [ScribeOnline_PayablesBase].[ICDISTS] AS [HasIntercompanyDistributions],
       [ScribeOnline_PayablesBase].[ICTRX] AS [IsIntercompanyTransaction],
       [ScribeOnline_PayablesBase].[VOIDED] AS [IsVoided],
       [ScribeOnline_PayablesBase].[VCHRNMBR] AS [Key_Id],
       [ScribeOnline_PayablesBase].[MSCCHAMT] AS [MiscellaneousAmount_Value],
       [ScribeOnline_PayablesBase].[MSCSCHID] AS [MiscellaneousTaxScheduleKey_Id],
       [ScribeOnline_PayablesBase].[MDFUSRID] AS [ModifiedBy],
       [ScribeOnline_PayablesBase].[MODIFDT] AS [ModifiedDate],
       [ScribeOnline_PayablesBase].[PORDNMBR] AS [PONumber],
       [ScribeOnline_PayablesBase].[PTDUSRID] AS [PostedBy],
       [ScribeOnline_PayablesBase].[POSTEDDT] AS [PostedDate],
       [ScribeOnline_PayablesBase].[PCHSCHID] AS [PurchaseTaxScheduleKey_Id],
       [ScribeOnline_PayablesBase].[PRCHAMNT] AS [PurchasesAmount_Value],
       [ScribeOnline_PayablesBase].[VADCDTRO] AS [RemitToAddressKey_Id],
       [ScribeOnline_PayablesBase].[SHIPMTHD] AS [ShippingMethodKey_Id],
       [ScribeOnline_PayablesBase].[TAXAMNT] AS [TaxAmount_Value],
       [ScribeOnline_PayablesBase].[Tax_Date] AS [TaxDate],
       [ScribeOnline_PayablesBase].[TAXSCHID] AS [TaxScheduleKey_Id],
       [ScribeOnline_PayablesBase].[TRDISAMT] AS [TradeDiscountAmount_Value],
       [ScribeOnline_PayablesBase].[TrxState] AS [TransactionState],
       [ScribeOnline_PayablesBase].[DOCNUMBR] AS [VendorDocumentNumber],
       [ScribeOnline_PayablesBase].[VENDORID] AS [VendorKey_Id],
       [ScribeOnline_PayablesBase].[VENDNAME] AS [VendorName],
       [ScribeOnline_PayablesBase].[CNTRLTYP] AS [ControlType],
       [ScribeOnline_PayablesBase].[BKTFRTAM] AS [BackoutFreightAmount],
       [ScribeOnline_PayablesBase].[BKTMSCAM] AS [BackoutMiscAmount],
       [ScribeOnline_PayablesBase].[BKTPURAM] AS [BackoutPurchasesAmount],
       [ScribeOnline_PayablesBase].[PRCTDISC] AS [PercentDiscount],
       [ScribeOnline_PayablesBase].[DSCDLRAM] AS [ DiscountDollarAmount],
       [ScribeOnline_PayablesBase].[RETNAGAM] AS [RetainageAmount],
       [ScribeOnline_PayablesBase].[PRCHDATE] AS [PurchaseDate],
       [ScribeOnline_PayablesBase].[CORRCTN] AS [Correction],
       [ScribeOnline_PayablesBase].[SIMPLIFD] AS [Simplified],
       [ScribeOnline_PayablesBase].[APLYWITH] AS [ApplyWithholding],
       [ScribeOnline_PayablesBase].[Electronic] AS [Electronic],
       [ScribeOnline_PayablesBase].[ECTRX] AS [ECTransaction]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
        where (EntityName IN (''PM10000'',''PM20000'',''PM30200'') and Id=RTRIM([ScribeOnline_PayablesBase].[VCHRNMBR])+''|''+RTRIM([ScribeOnline_PayablesBase].[DOCTYPE]))) as [LastModifiedDateTime],
        UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
        where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
        where (EntityName IN (''PM10000'',''PM20000'',''PM30200'') and Id=RTRIM([ScribeOnline_PayablesBase].[VCHRNMBR])+''|''+RTRIM([ScribeOnline_PayablesBase].[DOCTYPE])))),''''))as [LastModifiedBy]
        from [ScribeOnline_PayablesBase] with (NOLOCK) WHERE [ScribeOnline_PayablesBase].[DOCTYPE] = 2')

/****** Object:  View [dbo].[ScribeOnline_PayablesMiscellaneousCharge]    Script Date: 5/23/2016 4:15:24 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_PayablesMiscellaneousCharge]') IS NULL AND OBJECT_ID(N'[dbo].[PM10000]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_PayablesMiscellaneousCharge] AS select        [ScribeOnline_PayablesBase].[VADDCDPR] AS [AddressKey_Id],
       [ScribeOnline_PayablesBase].[PYMTRMID] AS [PaymentTermsKey_Id],
       [ScribeOnline_PayablesBase].[CDOCNMBR] AS [Payment_Cash_DocumentId],
       [ScribeOnline_PayablesBase].[CASHAMNT] AS [Payment_Cash_Amount_Value],
       [ScribeOnline_PayablesBase].[CAMCBKID] AS [Payment_Cash_BankAccountKey_Id],
       [ScribeOnline_PayablesBase].[CAMTDATE] AS [Payment_Cash_Date],
       [ScribeOnline_PayablesBase].[CAMPMTNM] AS [Payment_Cash_Number],
       [ScribeOnline_PayablesBase].[CHEKAMNT] AS [Payment_Check_Amount_Value],
       [ScribeOnline_PayablesBase].[CHAMCBID] AS [Payment_Check_BankAccountKey_Id],
       [ScribeOnline_PayablesBase].[CHEKNMBR] AS [Payment_Check_CheckNumber],
       [ScribeOnline_PayablesBase].[CHEKDATE] AS [Payment_Check_Date],
       [ScribeOnline_PayablesBase].[CAMPYNBR] AS [Payment_Check_Number],
       [ScribeOnline_PayablesBase].[CRCRDAMT] AS [Payment_PaymentCard_Amount_Value],
       [ScribeOnline_PayablesBase].[CRCARDDT] AS [Payment_PaymentCard_Date],
       [ScribeOnline_PayablesBase].[CCAMPYNM] AS [Payment_PaymentCard_Number],
       [ScribeOnline_PayablesBase].[CCRCTNUM] AS [Payment_PaymentCard_ReceiptNumber],
       [ScribeOnline_PayablesBase].[CARDNAME] AS [Payment_PaymentCard_TypeKey_Id],
       [ScribeOnline_PayablesBase].[APDSTKAM] AS [Terms_DiscountAmountAppliedTaken_Value],
       [ScribeOnline_PayablesBase].[DISTKNAM] AS [Terms_DiscountTakenAmount_Value],
       [ScribeOnline_PayablesBase].[DISAMTAV] AS [Terms_DiscountAvailableAmount_Value],
       [ScribeOnline_PayablesBase].[DISCDATE] AS [Terms_DiscountDate],
       [ScribeOnline_PayablesBase].[DUEDATE] AS [Terms_DueDate],
       [ScribeOnline_PayablesBase].[WROFAMNT] AS [WriteoffAmount_Value],
       [ScribeOnline_PayablesBase].[TEN99AMNT] AS [Amount1099_Value],
       [ScribeOnline_PayablesBase].[BACHNUMB] AS [BatchKey_Id],
       [ScribeOnline_PayablesBase].[BCHSOURC] AS [BatchKey_Source],
       [ScribeOnline_PayablesBase].[CHRGAMNT] AS [ChargeAmount_Value],
       [ScribeOnline_PayablesBase].[CURNCYID] AS [CurrencyKey_ISOCode],
       [ScribeOnline_PayablesBase].[DOCDATE] AS [Date],
       [ScribeOnline_PayablesBase].[TRXDSCRN] AS [Description],
       [ScribeOnline_PayablesBase].[DOCAMNT] AS [DocumentAmount_Value],
       [ScribeOnline_PayablesBase].[EXCHDATE] AS [ExchangeDate],
       [ScribeOnline_PayablesBase].[XCHGRATE] AS [ExchangeRate],
       [ScribeOnline_PayablesBase].[FRTAMNT] AS [FreightAmount_Value],
       [ScribeOnline_PayablesBase].[FRTSCHID] AS [FreightTaxScheduleKey_Id],
       [ScribeOnline_PayablesBase].[PSTGDATE] AS [GeneralLedgerPostingDate],
       [ScribeOnline_PayablesBase].[ICDISTS] AS [HasIntercompanyDistributions],
       [ScribeOnline_PayablesBase].[ICTRX] AS [IsIntercompanyTransaction],
       [ScribeOnline_PayablesBase].[VOIDED] AS [IsVoided],
       [ScribeOnline_PayablesBase].[VCHRNMBR] AS [Key_Id],
       [ScribeOnline_PayablesBase].[MSCCHAMT] AS [MiscellaneousAmount_Value],
       [ScribeOnline_PayablesBase].[MSCSCHID] AS [MiscellaneousTaxScheduleKey_Id],
       [ScribeOnline_PayablesBase].[MDFUSRID] AS [ModifiedBy],
       [ScribeOnline_PayablesBase].[MODIFDT] AS [ModifiedDate],
       [ScribeOnline_PayablesBase].[PORDNMBR] AS [PONumber],
       [ScribeOnline_PayablesBase].[PTDUSRID] AS [PostedBy],
       [ScribeOnline_PayablesBase].[POSTEDDT] AS [PostedDate],
       [ScribeOnline_PayablesBase].[PCHSCHID] AS [PurchaseTaxScheduleKey_Id],
       [ScribeOnline_PayablesBase].[PRCHAMNT] AS [PurchasesAmount_Value],
       [ScribeOnline_PayablesBase].[VADCDTRO] AS [RemitToAddressKey_Id],
       [ScribeOnline_PayablesBase].[SHIPMTHD] AS [ShippingMethodKey_Id],
       [ScribeOnline_PayablesBase].[TAXAMNT] AS [TaxAmount_Value],
       [ScribeOnline_PayablesBase].[Tax_Date] AS [TaxDate],
       [ScribeOnline_PayablesBase].[TAXSCHID] AS [TaxScheduleKey_Id],
       [ScribeOnline_PayablesBase].[TRDISAMT] AS [TradeDiscountAmount_Value],
       [ScribeOnline_PayablesBase].[TrxState] AS [TransactionState],
       [ScribeOnline_PayablesBase].[DOCNUMBR] AS [VendorDocumentNumber],
       [ScribeOnline_PayablesBase].[VENDORID] AS [VendorKey_Id],
       [ScribeOnline_PayablesBase].[VENDNAME] AS [VendorName],
       [ScribeOnline_PayablesBase].[CNTRLTYP] AS [ControlType],
       [ScribeOnline_PayablesBase].[BKTFRTAM] AS [BackoutFreightAmount],
       [ScribeOnline_PayablesBase].[BKTMSCAM] AS [BackoutMiscAmount],
       [ScribeOnline_PayablesBase].[BKTPURAM] AS [BackoutPurchasesAmount],
       [ScribeOnline_PayablesBase].[PRCTDISC] AS [PercentDiscount],
       [ScribeOnline_PayablesBase].[DSCDLRAM] AS [ DiscountDollarAmount],
       [ScribeOnline_PayablesBase].[RETNAGAM] AS [RetainageAmount],
       [ScribeOnline_PayablesBase].[PRCHDATE] AS [PurchaseDate],
       [ScribeOnline_PayablesBase].[CORRCTN] AS [Correction],
       [ScribeOnline_PayablesBase].[SIMPLIFD] AS [Simplified],
       [ScribeOnline_PayablesBase].[APLYWITH] AS [ApplyWithholding],
       [ScribeOnline_PayablesBase].[Electronic] AS [Electronic],
       [ScribeOnline_PayablesBase].[ECTRX] AS [ECTransaction]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
        where (EntityName IN (''PM10000'',''PM20000'',''PM30200'') and Id=RTRIM([ScribeOnline_PayablesBase].[VCHRNMBR])+''|''+RTRIM([ScribeOnline_PayablesBase].[DOCTYPE]))) as [LastModifiedDateTime],
        UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
        where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
        where (EntityName IN (''PM10000'',''PM20000'',''PM30200'') and Id=RTRIM([ScribeOnline_PayablesBase].[VCHRNMBR])+''|''+RTRIM([ScribeOnline_PayablesBase].[DOCTYPE])))),''''))as [LastModifiedBy]
        from [ScribeOnline_PayablesBase] with (NOLOCK) WHERE [ScribeOnline_PayablesBase].[DOCTYPE] = 3')

/****** Object:  View [dbo].[ScribeOnline_PayablesReturn]    Script Date: 5/23/2016 4:15:25 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_PayablesReturn]') IS NULL AND OBJECT_ID(N'[dbo].[PM10000]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_PayablesReturn] AS select        [ScribeOnline_PayablesBase].[VADDCDPR] AS [AddressKey_Id],
       [ScribeOnline_PayablesBase].[DISTKNAM] AS [DiscountReturnedAmount_Value],
       [ScribeOnline_PayablesBase].[CDOCNMBR] AS [Payment_Cash_DocumentId],
       [ScribeOnline_PayablesBase].[CASHAMNT] AS [Payment_Cash_Amount_Value],
       [ScribeOnline_PayablesBase].[CAMCBKID] AS [Payment_Cash_BankAccountKey_Id],
       [ScribeOnline_PayablesBase].[CAMTDATE] AS [Payment_Cash_Date],
       [ScribeOnline_PayablesBase].[CAMPMTNM] AS [Payment_Cash_Number],
       [ScribeOnline_PayablesBase].[CHEKAMNT] AS [Payment_Check_Amount_Value],
       [ScribeOnline_PayablesBase].[CHAMCBID] AS [Payment_Check_BankAccountKey_Id],
       [ScribeOnline_PayablesBase].[CHEKNMBR] AS [Payment_Check_CheckNumber],
       [ScribeOnline_PayablesBase].[CHEKDATE] AS [Payment_Check_Date],
       [ScribeOnline_PayablesBase].[CAMPYNBR] AS [Payment_Check_Number],
       [ScribeOnline_PayablesBase].[CRCRDAMT] AS [Payment_PaymentCard_Amount_Value],
       [ScribeOnline_PayablesBase].[CRCARDDT] AS [Payment_PaymentCard_Date],
       [ScribeOnline_PayablesBase].[CCAMPYNM] AS [Payment_PaymentCard_Number],
       [ScribeOnline_PayablesBase].[CCRCTNUM] AS [Payment_PaymentCard_ReceiptNumber],
       [ScribeOnline_PayablesBase].[CARDNAME] AS [Payment_PaymentCard_TypeKey_Id],
       [ScribeOnline_PayablesBase].[WROFAMNT] AS [WriteoffAmount_Value],
       [ScribeOnline_PayablesBase].[TEN99AMNT] AS [Amount1099_Value],
       [ScribeOnline_PayablesBase].[BACHNUMB] AS [BatchKey_Id],
       [ScribeOnline_PayablesBase].[BCHSOURC] AS [BatchKey_Source],
       [ScribeOnline_PayablesBase].[CHRGAMNT] AS [ChargeAmount_Value],
       [ScribeOnline_PayablesBase].[CURNCYID] AS [CurrencyKey_ISOCode],
       [ScribeOnline_PayablesBase].[DOCDATE] AS [Date],
       [ScribeOnline_PayablesBase].[TRXDSCRN] AS [Description],
       [ScribeOnline_PayablesBase].[DOCAMNT] AS [DocumentAmount_Value],
       [ScribeOnline_PayablesBase].[EXCHDATE] AS [ExchangeDate],
       [ScribeOnline_PayablesBase].[XCHGRATE] AS [ExchangeRate],
       [ScribeOnline_PayablesBase].[FRTAMNT] AS [FreightAmount_Value],
       [ScribeOnline_PayablesBase].[FRTSCHID] AS [FreightTaxScheduleKey_Id],
       [ScribeOnline_PayablesBase].[PSTGDATE] AS [GeneralLedgerPostingDate],
       [ScribeOnline_PayablesBase].[ICDISTS] AS [HasIntercompanyDistributions],
       [ScribeOnline_PayablesBase].[ICTRX] AS [IsIntercompanyTransaction],
       [ScribeOnline_PayablesBase].[VOIDED] AS [IsVoided],
       [ScribeOnline_PayablesBase].[VCHRNMBR] AS [Key_Id],
       [ScribeOnline_PayablesBase].[MSCCHAMT] AS [MiscellaneousAmount_Value],
       [ScribeOnline_PayablesBase].[MSCSCHID] AS [MiscellaneousTaxScheduleKey_Id],
       [ScribeOnline_PayablesBase].[MDFUSRID] AS [ModifiedBy],
       [ScribeOnline_PayablesBase].[MODIFDT] AS [ModifiedDate],
       [ScribeOnline_PayablesBase].[PORDNMBR] AS [PONumber],
       [ScribeOnline_PayablesBase].[PTDUSRID] AS [PostedBy],
       [ScribeOnline_PayablesBase].[POSTEDDT] AS [PostedDate],
       [ScribeOnline_PayablesBase].[PCHSCHID] AS [PurchaseTaxScheduleKey_Id],
       [ScribeOnline_PayablesBase].[PRCHAMNT] AS [PurchasesAmount_Value],
       [ScribeOnline_PayablesBase].[VADCDTRO] AS [RemitToAddressKey_Id],
       [ScribeOnline_PayablesBase].[SHIPMTHD] AS [ShippingMethodKey_Id],
       [ScribeOnline_PayablesBase].[TAXAMNT] AS [TaxAmount_Value],
       [ScribeOnline_PayablesBase].[Tax_Date] AS [TaxDate],
       [ScribeOnline_PayablesBase].[TAXSCHID] AS [TaxScheduleKey_Id],
       [ScribeOnline_PayablesBase].[TRDISAMT] AS [TradeDiscountAmount_Value],
       [ScribeOnline_PayablesBase].[TrxState] AS [TransactionState],
       [ScribeOnline_PayablesBase].[DOCNUMBR] AS [VendorDocumentNumber],
       [ScribeOnline_PayablesBase].[VENDORID] AS [VendorKey_Id],
       [ScribeOnline_PayablesBase].[VENDNAME] AS [VendorName],
       [ScribeOnline_PayablesBase].[CNTRLTYP] AS [ControlType],
       [ScribeOnline_PayablesBase].[BKTFRTAM] AS [BackoutFreightAmount],
       [ScribeOnline_PayablesBase].[BKTMSCAM] AS [BackoutMiscAmount],
       [ScribeOnline_PayablesBase].[BKTPURAM] AS [BackoutPurchasesAmount],
       [ScribeOnline_PayablesBase].[PRCTDISC] AS [PercentDiscount],
       [ScribeOnline_PayablesBase].[DSCDLRAM] AS [ DiscountDollarAmount],
       [ScribeOnline_PayablesBase].[RETNAGAM] AS [RetainageAmount],
       [ScribeOnline_PayablesBase].[PRCHDATE] AS [PurchaseDate],
       [ScribeOnline_PayablesBase].[CORRCTN] AS [Correction],
       [ScribeOnline_PayablesBase].[SIMPLIFD] AS [Simplified],
       [ScribeOnline_PayablesBase].[APLYWITH] AS [ApplyWithholding],
       [ScribeOnline_PayablesBase].[Electronic] AS [Electronic],
       [ScribeOnline_PayablesBase].[ECTRX] AS [ECTransaction]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
        where (EntityName IN (''PM10000'',''PM20000'',''PM30200'') and Id=RTRIM([ScribeOnline_PayablesBase].[VCHRNMBR])+''|''+RTRIM([ScribeOnline_PayablesBase].[DOCTYPE]))) as [LastModifiedDateTime],
        UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
        where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
        where (EntityName IN (''PM10000'',''PM20000'',''PM30200'') and Id=RTRIM([ScribeOnline_PayablesBase].[VCHRNMBR])+''|''+RTRIM([ScribeOnline_PayablesBase].[DOCTYPE])))),''''))as [LastModifiedBy]
        from [ScribeOnline_PayablesBase] with (NOLOCK) WHERE [ScribeOnline_PayablesBase].[DOCTYPE] = 4')

/****** Object:  View [dbo].[ScribeOnline_PayablesCreditMemo]    Script Date: 5/23/2016 4:15:25 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_PayablesCreditMemo]') IS NULL AND OBJECT_ID(N'[dbo].[PM10000]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_PayablesCreditMemo] AS select        [ScribeOnline_PayablesBase].[VADDCDPR] AS [AddressKey_Id],
       [ScribeOnline_PayablesBase].[TEN99AMNT] AS [Amount1099_Value],
       [ScribeOnline_PayablesBase].[BACHNUMB] AS [BatchKey_Id],
       [ScribeOnline_PayablesBase].[BCHSOURC] AS [BatchKey_Source],
       [ScribeOnline_PayablesBase].[CHRGAMNT] AS [ChargeAmount_Value],
       [ScribeOnline_PayablesBase].[CURNCYID] AS [CurrencyKey_ISOCode],
       [ScribeOnline_PayablesBase].[DOCDATE] AS [Date],
       [ScribeOnline_PayablesBase].[TRXDSCRN] AS [Description],
       [ScribeOnline_PayablesBase].[DOCAMNT] AS [DocumentAmount_Value],
       [ScribeOnline_PayablesBase].[EXCHDATE] AS [ExchangeDate],
       [ScribeOnline_PayablesBase].[XCHGRATE] AS [ExchangeRate],
       [ScribeOnline_PayablesBase].[FRTAMNT] AS [FreightAmount_Value],
       [ScribeOnline_PayablesBase].[FRTSCHID] AS [FreightTaxScheduleKey_Id],
       [ScribeOnline_PayablesBase].[PSTGDATE] AS [GeneralLedgerPostingDate],
       [ScribeOnline_PayablesBase].[ICDISTS] AS [HasIntercompanyDistributions],
       [ScribeOnline_PayablesBase].[ICTRX] AS [IsIntercompanyTransaction],
       [ScribeOnline_PayablesBase].[VOIDED] AS [IsVoided],
       [ScribeOnline_PayablesBase].[VCHRNMBR] AS [Key_Id],
       [ScribeOnline_PayablesBase].[MSCCHAMT] AS [MiscellaneousAmount_Value],
       [ScribeOnline_PayablesBase].[MSCSCHID] AS [MiscellaneousTaxScheduleKey_Id],
       [ScribeOnline_PayablesBase].[MDFUSRID] AS [ModifiedBy],
       [ScribeOnline_PayablesBase].[MODIFDT] AS [ModifiedDate],
       [ScribeOnline_PayablesBase].[PORDNMBR] AS [PONumber],
       [ScribeOnline_PayablesBase].[PTDUSRID] AS [PostedBy],
       [ScribeOnline_PayablesBase].[POSTEDDT] AS [PostedDate],
       [ScribeOnline_PayablesBase].[PCHSCHID] AS [PurchaseTaxScheduleKey_Id],
       [ScribeOnline_PayablesBase].[PRCHAMNT] AS [PurchasesAmount_Value],
       [ScribeOnline_PayablesBase].[VADCDTRO] AS [RemitToAddressKey_Id],
       [ScribeOnline_PayablesBase].[SHIPMTHD] AS [ShippingMethodKey_Id],
       [ScribeOnline_PayablesBase].[TAXAMNT] AS [TaxAmount_Value],
       [ScribeOnline_PayablesBase].[Tax_Date] AS [TaxDate],
       [ScribeOnline_PayablesBase].[TAXSCHID] AS [TaxScheduleKey_Id],
       [ScribeOnline_PayablesBase].[TRDISAMT] AS [TradeDiscountAmount_Value],
       [ScribeOnline_PayablesBase].[TrxState] AS [TransactionState],
       [ScribeOnline_PayablesBase].[DOCNUMBR] AS [VendorDocumentNumber],
       [ScribeOnline_PayablesBase].[VENDORID] AS [VendorKey_Id],
       [ScribeOnline_PayablesBase].[VENDNAME] AS [VendorName],
       [ScribeOnline_PayablesBase].[CNTRLTYP] AS [ControlType],
       [ScribeOnline_PayablesBase].[BKTFRTAM] AS [BackoutFreightAmount],
       [ScribeOnline_PayablesBase].[BKTMSCAM] AS [BackoutMiscAmount],
       [ScribeOnline_PayablesBase].[BKTPURAM] AS [BackoutPurchasesAmount],
       [ScribeOnline_PayablesBase].[PRCTDISC] AS [PercentDiscount],
       [ScribeOnline_PayablesBase].[DSCDLRAM] AS [ DiscountDollarAmount],
       [ScribeOnline_PayablesBase].[RETNAGAM] AS [RetainageAmount],
       [ScribeOnline_PayablesBase].[PRCHDATE] AS [PurchaseDate],
       [ScribeOnline_PayablesBase].[CORRCTN] AS [Correction],
       [ScribeOnline_PayablesBase].[SIMPLIFD] AS [Simplified],
       [ScribeOnline_PayablesBase].[APLYWITH] AS [ApplyWithholding],
       [ScribeOnline_PayablesBase].[Electronic] AS [Electronic],
       [ScribeOnline_PayablesBase].[ECTRX] AS [ECTransaction]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
        where (EntityName IN (''PM10000'',''PM20000'',''PM30200'') and Id=RTRIM([ScribeOnline_PayablesBase].[VCHRNMBR])+''|''+RTRIM([ScribeOnline_PayablesBase].[DOCTYPE]))) as [LastModifiedDateTime],
        UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
        where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
        where (EntityName IN (''PM10000'',''PM20000'',''PM30200'') and Id=RTRIM([ScribeOnline_PayablesBase].[VCHRNMBR])+''|''+RTRIM([ScribeOnline_PayablesBase].[DOCTYPE])))),''''))as [LastModifiedBy]
        from [ScribeOnline_PayablesBase] with (NOLOCK) WHERE [ScribeOnline_PayablesBase].[DOCTYPE] = 5')

/****** Object:  View [dbo].[ScribeOnline_ReceivablesCreditMemo]    Script Date: 5/23/2016 4:15:25 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_ReceivablesCreditMemo]') IS NULL AND OBJECT_ID(N'[dbo].[RM10301]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_ReceivablesCreditMemo] AS select        [ScribeOnline_ReceivablesBase].[DISCRTND] AS [DiscountReturned_Value],
       [ScribeOnline_ReceivablesBase].[CUSTNMBR] AS [AddressKey_CustomerKey_Id],
       [ScribeOnline_ReceivablesBase].[ADRSCODE] AS [AddressKey_Id],
       [ScribeOnline_ReceivablesBase].[BACHNUMB] AS [BatchKey_Id],
       [ScribeOnline_ReceivablesBase].[BCHSOURC] AS [BatchKey_Source],
       [ScribeOnline_ReceivablesBase].[CPRCSTNM] AS [CorporateAccountKey_Id],
       [ScribeOnline_ReceivablesBase].[COSTAMNT] AS [CostAmount_Value],
       [ScribeOnline_ReceivablesBase].[CURNCYID] AS [CurrencyKey_ISOCode],
       [ScribeOnline_ReceivablesBase].[CURTRXAM] AS [CurrentDocumentAmount_Value],
       [ScribeOnline_ReceivablesBase].[CUSTNMBR] AS [CustomerKey_Id],
       [ScribeOnline_ReceivablesBase].[CUSTNAME] AS [CustomerName],
       [ScribeOnline_ReceivablesBase].[CSTPONBR] AS [CustomerPONumber],
       [ScribeOnline_ReceivablesBase].[DOCDATE] AS [Date],
       [ScribeOnline_ReceivablesBase].[DOCDESCR] AS [Description],
       [ScribeOnline_ReceivablesBase].[ORTRXAMT] AS [DocumentAmount_Value],
       [ScribeOnline_ReceivablesBase].[EXCHDATE] AS [ExchangeDate],
       [ScribeOnline_ReceivablesBase].[XCHGRATE] AS [ExchangeRate],
       [ScribeOnline_ReceivablesBase].[FRTAMNT] AS [FreightAmount_Value],
       [ScribeOnline_ReceivablesBase].[FRTSCHID] AS [FreightTaxScheduleKey_Id],
       [ScribeOnline_ReceivablesBase].[GLPOSTDT] AS [GeneralLedgerPostingDate],
       [ScribeOnline_ReceivablesBase].[DINVPDOF] AS [InvoicePaidOffDate],
       [ScribeOnline_ReceivablesBase].[DELETE1] AS [IsDeleted],
       [ScribeOnline_ReceivablesBase].[DIRECTDEBIT] AS [IsDirectDebitDocument],
       [ScribeOnline_ReceivablesBase].[Electronic] AS [IsElectronic],
       [ScribeOnline_ReceivablesBase].[VOIDSTTS] AS [IsVoided],
       [ScribeOnline_ReceivablesBase].[DOCNUMBR] AS [Key_Id],
       [ScribeOnline_ReceivablesBase].[MISCAMNT] AS [MiscellaneousAmount_Value],
       [ScribeOnline_ReceivablesBase].[MSCSCHID] AS [MiscellaneousTaxScheduleKey_Id],
       [ScribeOnline_ReceivablesBase].[LSTUSRED] AS [ModifiedBy],
       [ScribeOnline_ReceivablesBase].[LSTEDTDT] AS [ModifiedDate],
       [ScribeOnline_ReceivablesBase].[PTDUSRID] AS [PostedBy],
       [ScribeOnline_ReceivablesBase].[POSTEDDT] AS [PostedDate],
       [ScribeOnline_ReceivablesBase].[SLSAMNT] AS [SalesAmount_Value],
       [ScribeOnline_ReceivablesBase].[SLSCHDID] AS [SalesTaxScheduleKey_Id],
       [ScribeOnline_ReceivablesBase].[SALSTERR] AS [SalesTerritoryKey_Id],
       [ScribeOnline_ReceivablesBase].[SLPRSNID] AS [SalespersonKey_Id],
       [ScribeOnline_ReceivablesBase].[SHIPMTHD] AS [ShippingMethodKey_Id],
       [ScribeOnline_ReceivablesBase].[TAXAMNT] AS [TaxAmount_Value],
       [ScribeOnline_ReceivablesBase].[TAXSCHID] AS [TaxScheduleKey_Id],
       [ScribeOnline_ReceivablesBase].[TRDISAMT] AS [TradeDiscountAmount_Value],
       [ScribeOnline_ReceivablesBase].[TrxState] AS [TransactionState],
       [ScribeOnline_ReceivablesBase].[VOIDDATE] AS [VoidDate],
       [ScribeOnline_ReceivablesBase].[RMDTYPAL] AS [RMDocumentTypeAll],
       [ScribeOnline_ReceivablesBase].[BKTSLSAM] AS [BackoutSalesAmount],
       [ScribeOnline_ReceivablesBase].[BKTFRTAM] AS [BackoutFreightAmount],
       [ScribeOnline_ReceivablesBase].[BKTMSCAM] AS [BackoutMiscAmount],
       [ScribeOnline_ReceivablesBase].[PPSAMDED] AS [PPSAmountDeducted],
       [ScribeOnline_ReceivablesBase].[DSCDLRAM] AS [DiscountDollarAmount],
       [ScribeOnline_ReceivablesBase].[DSCPCTAM] AS [DiscountPercentAmount],
       [ScribeOnline_ReceivablesBase].[Tax_Date] AS [TaxDate],
       [ScribeOnline_ReceivablesBase].[APLYWITH] AS [ApplyWithholding],
       [ScribeOnline_ReceivablesBase].[SALEDATE] AS [SaleDate],
       [ScribeOnline_ReceivablesBase].[CORRCTN] AS [Correction],
       [ScribeOnline_ReceivablesBase].[SIMPLIFD] AS [Simplified],
       [ScribeOnline_ReceivablesBase].[ECTRX] AS [ECTransaction],
       [ScribeOnline_ReceivablesBase].[BackoutTradeDisc] AS [BackoutTradeDiscountAmount],
       [ScribeOnline_ReceivablesBase].[EFTFLAG] AS [EFTFlag],
       [ScribeOnline_ReceivablesBase].[TRXSORCE] AS [TransactionSource]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
        where (EntityName IN (''RM10301'',''RM20101'',''RM30101'') and Id=RTRIM([ScribeOnline_ReceivablesBase].[RMDTYPAL])+''|''+RTRIM([ScribeOnline_ReceivablesBase].[DOCNUMBR])+''|''+RTRIM([ScribeOnline_ReceivablesBase].[CUSTNMBR]))) as [LastModifiedDateTime],
        UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
        where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
        where (EntityName IN (''RM10301'',''RM20101'',''RM30101'') and Id=RTRIM([ScribeOnline_ReceivablesBase].[RMDTYPAL])+''|''+RTRIM([ScribeOnline_ReceivablesBase].[DOCNUMBR])+''|''+RTRIM([ScribeOnline_ReceivablesBase].[CUSTNMBR])))),''''))as [LastModifiedBy]
        from [ScribeOnline_ReceivablesBase] with (NOLOCK) WHERE [ScribeOnline_ReceivablesBase].[RMDTYPAL] = 7')

/****** Object:  View [dbo].[ScribeOnline_ReceivablesDebitMemo]    Script Date: 5/23/2016 4:15:25 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_ReceivablesDebitMemo]') IS NULL AND OBJECT_ID(N'[dbo].[RM10301]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_ReceivablesDebitMemo] AS select        [ScribeOnline_ReceivablesBase].[COMDLRAM] AS [CommissionAmount_Value],
       [ScribeOnline_ReceivablesBase].[COMAPPTO] AS [CommissionBasedOn],
       [ScribeOnline_ReceivablesBase].[GSTDSAMT] AS [GSTDiscountAmount_Value],
       [ScribeOnline_ReceivablesBase].[CASHAMNT] AS [Payment_Cash_Amount_Value],
       [ScribeOnline_ReceivablesBase].[CBKIDCSH] AS [Payment_Cash_BankAccountKey_Id],
       [ScribeOnline_ReceivablesBase].[CASHDATE] AS [Payment_Cash_Date],
       [ScribeOnline_ReceivablesBase].[DCNUMCSH] AS [Payment_Cash_Number],
       [ScribeOnline_ReceivablesBase].[CHEKAMNT] AS [Payment_Check_Amount_Value],
       [ScribeOnline_ReceivablesBase].[CBKIDCHK] AS [Payment_Check_BankAccountKey_Id],
       [ScribeOnline_ReceivablesBase].[CHEKNMBR] AS [Payment_Check_CheckNumber],
       [ScribeOnline_ReceivablesBase].[CHEKDATE] AS [Payment_Check_Date],
       [ScribeOnline_ReceivablesBase].[DCNUMCHK] AS [Payment_Check_Number],
       [ScribeOnline_ReceivablesBase].[CBKIDCRD] AS [Payment_PaymentCard_BankAccountKey_Id],
       [ScribeOnline_ReceivablesBase].[CRCRDAMT] AS [Payment_PaymentCard_Amount_Value],
       [ScribeOnline_ReceivablesBase].[CRCARDDT] AS [Payment_PaymentCard_Date],
       [ScribeOnline_ReceivablesBase].[DCNUMCRD] AS [Payment_PaymentCard_Number],
       [ScribeOnline_ReceivablesBase].[RCTNCCRD] AS [Payment_PaymentCard_ReceiptNumber],
       [ScribeOnline_ReceivablesBase].[CRCRDNAM] AS [Payment_PaymentCard_TypeKey_Id],
       [ScribeOnline_ReceivablesBase].[PYMTRMID] AS [PaymentTermsKey_Id],
       [ScribeOnline_ReceivablesBase].[DISAVTKN] AS [Terms_DiscountAvailableTakenAmount_Value],
       [ScribeOnline_ReceivablesBase].[DISTKNAM] AS [Terms_DiscountTakenAmount_Value],
       [ScribeOnline_ReceivablesBase].[DISAVAMT] AS [Terms_DiscountAvailableAmount_Value],
       [ScribeOnline_ReceivablesBase].[DISCDATE] AS [Terms_DiscountDate],
       [ScribeOnline_ReceivablesBase].[DUEDATE] AS [Terms_DueDate],
       [ScribeOnline_ReceivablesBase].[WROFAMNT] AS [WriteoffAmount_Value],
       [ScribeOnline_ReceivablesBase].[CUSTNMBR] AS [AddressKey_CustomerKey_Id],
       [ScribeOnline_ReceivablesBase].[ADRSCODE] AS [AddressKey_Id],
       [ScribeOnline_ReceivablesBase].[BACHNUMB] AS [BatchKey_Id],
       [ScribeOnline_ReceivablesBase].[BCHSOURC] AS [BatchKey_Source],
       [ScribeOnline_ReceivablesBase].[CPRCSTNM] AS [CorporateAccountKey_Id],
       [ScribeOnline_ReceivablesBase].[COSTAMNT] AS [CostAmount_Value],
       [ScribeOnline_ReceivablesBase].[CURNCYID] AS [CurrencyKey_ISOCode],
       [ScribeOnline_ReceivablesBase].[CURTRXAM] AS [CurrentDocumentAmount_Value],
       [ScribeOnline_ReceivablesBase].[CUSTNMBR] AS [CustomerKey_Id],
       [ScribeOnline_ReceivablesBase].[CUSTNAME] AS [CustomerName],
       [ScribeOnline_ReceivablesBase].[CSTPONBR] AS [CustomerPONumber],
       [ScribeOnline_ReceivablesBase].[DOCDATE] AS [Date],
       [ScribeOnline_ReceivablesBase].[DOCDESCR] AS [Description],
       [ScribeOnline_ReceivablesBase].[ORTRXAMT] AS [DocumentAmount_Value],
       [ScribeOnline_ReceivablesBase].[EXCHDATE] AS [ExchangeDate],
       [ScribeOnline_ReceivablesBase].[XCHGRATE] AS [ExchangeRate],
       [ScribeOnline_ReceivablesBase].[FRTAMNT] AS [FreightAmount_Value],
       [ScribeOnline_ReceivablesBase].[FRTSCHID] AS [FreightTaxScheduleKey_Id],
       [ScribeOnline_ReceivablesBase].[GLPOSTDT] AS [GeneralLedgerPostingDate],
       [ScribeOnline_ReceivablesBase].[DINVPDOF] AS [InvoicePaidOffDate],
       [ScribeOnline_ReceivablesBase].[DELETE1] AS [IsDeleted],
       [ScribeOnline_ReceivablesBase].[DIRECTDEBIT] AS [IsDirectDebitDocument],
       [ScribeOnline_ReceivablesBase].[Electronic] AS [IsElectronic],
       [ScribeOnline_ReceivablesBase].[VOIDSTTS] AS [IsVoided],
       [ScribeOnline_ReceivablesBase].[DOCNUMBR] AS [Key_Id],
       [ScribeOnline_ReceivablesBase].[MISCAMNT] AS [MiscellaneousAmount_Value],
       [ScribeOnline_ReceivablesBase].[MSCSCHID] AS [MiscellaneousTaxScheduleKey_Id],
       [ScribeOnline_ReceivablesBase].[LSTUSRED] AS [ModifiedBy],
       [ScribeOnline_ReceivablesBase].[LSTEDTDT] AS [ModifiedDate],
       [ScribeOnline_ReceivablesBase].[PTDUSRID] AS [PostedBy],
       [ScribeOnline_ReceivablesBase].[POSTEDDT] AS [PostedDate],
       [ScribeOnline_ReceivablesBase].[SLSAMNT] AS [SalesAmount_Value],
       [ScribeOnline_ReceivablesBase].[SLSCHDID] AS [SalesTaxScheduleKey_Id],
       [ScribeOnline_ReceivablesBase].[SALSTERR] AS [SalesTerritoryKey_Id],
       [ScribeOnline_ReceivablesBase].[SLPRSNID] AS [SalespersonKey_Id],
       [ScribeOnline_ReceivablesBase].[SHIPMTHD] AS [ShippingMethodKey_Id],
       [ScribeOnline_ReceivablesBase].[TAXAMNT] AS [TaxAmount_Value],
       [ScribeOnline_ReceivablesBase].[TAXSCHID] AS [TaxScheduleKey_Id],
       [ScribeOnline_ReceivablesBase].[TRDISAMT] AS [TradeDiscountAmount_Value],
       [ScribeOnline_ReceivablesBase].[TrxState] AS [TransactionState],
       [ScribeOnline_ReceivablesBase].[VOIDDATE] AS [VoidDate],
       [ScribeOnline_ReceivablesBase].[RMDTYPAL] AS [RMDocumentTypeAll],
       [ScribeOnline_ReceivablesBase].[BKTSLSAM] AS [BackoutSalesAmount],
       [ScribeOnline_ReceivablesBase].[BKTFRTAM] AS [BackoutFreightAmount],
       [ScribeOnline_ReceivablesBase].[BKTMSCAM] AS [BackoutMiscAmount],
       [ScribeOnline_ReceivablesBase].[DISCRTND] AS [DiscountReturned],
       [ScribeOnline_ReceivablesBase].[PPSAMDED] AS [PPSAmountDeducted],
       [ScribeOnline_ReceivablesBase].[DSCDLRAM] AS [DiscountDollarAmount],
       [ScribeOnline_ReceivablesBase].[DSCPCTAM] AS [DiscountPercentAmount],
       [ScribeOnline_ReceivablesBase].[Tax_Date] AS [TaxDate],
       [ScribeOnline_ReceivablesBase].[APLYWITH] AS [ApplyWithholding],
       [ScribeOnline_ReceivablesBase].[SALEDATE] AS [SaleDate],
       [ScribeOnline_ReceivablesBase].[CORRCTN] AS [Correction],
       [ScribeOnline_ReceivablesBase].[SIMPLIFD] AS [Simplified],
       [ScribeOnline_ReceivablesBase].[ECTRX] AS [ECTransaction],
       [ScribeOnline_ReceivablesBase].[BackoutTradeDisc] AS [BackoutTradeDiscountAmount],
       [ScribeOnline_ReceivablesBase].[EFTFLAG] AS [EFTFlag],
       [ScribeOnline_ReceivablesBase].[TRXSORCE] AS [TransactionSource]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
        where (EntityName IN (''RM10301'',''RM20101'',''RM30101'') and Id=RTRIM([ScribeOnline_ReceivablesBase].[RMDTYPAL])+''|''+RTRIM([ScribeOnline_ReceivablesBase].[DOCNUMBR])+''|''+RTRIM([ScribeOnline_ReceivablesBase].[CUSTNMBR]))) as [LastModifiedDateTime],
        UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
        where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
        where (EntityName IN (''RM10301'',''RM20101'',''RM30101'') and Id=RTRIM([ScribeOnline_ReceivablesBase].[RMDTYPAL])+''|''+RTRIM([ScribeOnline_ReceivablesBase].[DOCNUMBR])+''|''+RTRIM([ScribeOnline_ReceivablesBase].[CUSTNMBR])))),''''))as [LastModifiedBy]
        from [ScribeOnline_ReceivablesBase] with (NOLOCK) WHERE [ScribeOnline_ReceivablesBase].[RMDTYPAL] = 3')

/****** Object:  View [dbo].[ScribeOnline_ReceivablesInvoice]    Script Date: 5/23/2016 4:15:26 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_ReceivablesInvoice]') IS NULL AND OBJECT_ID(N'[dbo].[RM10301]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_ReceivablesInvoice] AS select        [ScribeOnline_ReceivablesBase].[COMDLRAM] AS [CommissionAmount_Value],
       [ScribeOnline_ReceivablesBase].[COMAPPTO] AS [CommissionBasedOn],
       [ScribeOnline_ReceivablesBase].[GSTDSAMT] AS [GSTDiscountAmount_Value],
       [ScribeOnline_ReceivablesBase].[CASHAMNT] AS [Payment_Cash_Amount_Value],
       [ScribeOnline_ReceivablesBase].[CBKIDCSH] AS [Payment_Cash_BankAccountKey_Id],
       [ScribeOnline_ReceivablesBase].[CASHDATE] AS [Payment_Cash_Date],
       [ScribeOnline_ReceivablesBase].[DCNUMCSH] AS [Payment_Cash_Number],
       [ScribeOnline_ReceivablesBase].[CHEKAMNT] AS [Payment_Check_Amount_Value],
       [ScribeOnline_ReceivablesBase].[CBKIDCHK] AS [Payment_Check_BankAccountKey_Id],
       [ScribeOnline_ReceivablesBase].[CHEKNMBR] AS [Payment_Check_CheckNumber],
       [ScribeOnline_ReceivablesBase].[CHEKDATE] AS [Payment_Check_Date],
       [ScribeOnline_ReceivablesBase].[DCNUMCHK] AS [Payment_Check_Number],
       [ScribeOnline_ReceivablesBase].[CBKIDCRD] AS [Payment_PaymentCard_BankAccountKey_Id],
       [ScribeOnline_ReceivablesBase].[CRCRDAMT] AS [Payment_PaymentCard_Amount_Value],
       [ScribeOnline_ReceivablesBase].[CRCARDDT] AS [Payment_PaymentCard_Date],
       [ScribeOnline_ReceivablesBase].[DCNUMCRD] AS [Payment_PaymentCard_Number],
       [ScribeOnline_ReceivablesBase].[RCTNCCRD] AS [Payment_PaymentCard_ReceiptNumber],
       [ScribeOnline_ReceivablesBase].[CRCRDNAM] AS [Payment_PaymentCard_TypeKey_Id],
       [ScribeOnline_ReceivablesBase].[PYMTRMID] AS [PaymentTermsKey_Id],
       [ScribeOnline_ReceivablesBase].[DISAVTKN] AS [Terms_DiscountAvailableTakenAmount_Value],
       [ScribeOnline_ReceivablesBase].[DISTKNAM] AS [Terms_DiscountTakenAmount_Value],
       [ScribeOnline_ReceivablesBase].[DISAVAMT] AS [Terms_DiscountAvailableAmount_Value],
       [ScribeOnline_ReceivablesBase].[DISCDATE] AS [Terms_DiscountDate],
       [ScribeOnline_ReceivablesBase].[DUEDATE] AS [Terms_DueDate],
       [ScribeOnline_ReceivablesBase].[WROFAMNT] AS [WriteoffAmount_Value],
       [ScribeOnline_ReceivablesBase].[CUSTNMBR] AS [AddressKey_CustomerKey_Id],
       [ScribeOnline_ReceivablesBase].[ADRSCODE] AS [AddressKey_Id],
       [ScribeOnline_ReceivablesBase].[BACHNUMB] AS [BatchKey_Id],
       [ScribeOnline_ReceivablesBase].[BCHSOURC] AS [BatchKey_Source],
       [ScribeOnline_ReceivablesBase].[CPRCSTNM] AS [CorporateAccountKey_Id],
       [ScribeOnline_ReceivablesBase].[COSTAMNT] AS [CostAmount_Value],
       [ScribeOnline_ReceivablesBase].[CURNCYID] AS [CurrencyKey_ISOCode],
       [ScribeOnline_ReceivablesBase].[CURTRXAM] AS [CurrentDocumentAmount_Value],
       [ScribeOnline_ReceivablesBase].[CUSTNMBR] AS [CustomerKey_Id],
       [ScribeOnline_ReceivablesBase].[CUSTNAME] AS [CustomerName],
       [ScribeOnline_ReceivablesBase].[CSTPONBR] AS [CustomerPONumber],
       [ScribeOnline_ReceivablesBase].[DOCDATE] AS [Date],
       [ScribeOnline_ReceivablesBase].[DOCDESCR] AS [Description],
       [ScribeOnline_ReceivablesBase].[ORTRXAMT] AS [DocumentAmount_Value],
       [ScribeOnline_ReceivablesBase].[EXCHDATE] AS [ExchangeDate],
       [ScribeOnline_ReceivablesBase].[XCHGRATE] AS [ExchangeRate],
       [ScribeOnline_ReceivablesBase].[FRTAMNT] AS [FreightAmount_Value],
       [ScribeOnline_ReceivablesBase].[FRTSCHID] AS [FreightTaxScheduleKey_Id],
       [ScribeOnline_ReceivablesBase].[GLPOSTDT] AS [GeneralLedgerPostingDate],
       [ScribeOnline_ReceivablesBase].[DINVPDOF] AS [InvoicePaidOffDate],
       [ScribeOnline_ReceivablesBase].[DELETE1] AS [IsDeleted],
       [ScribeOnline_ReceivablesBase].[DIRECTDEBIT] AS [IsDirectDebitDocument],
       [ScribeOnline_ReceivablesBase].[Electronic] AS [IsElectronic],
       [ScribeOnline_ReceivablesBase].[VOIDSTTS] AS [IsVoided],
       [ScribeOnline_ReceivablesBase].[DOCNUMBR] AS [Key_Id],
       [ScribeOnline_ReceivablesBase].[MISCAMNT] AS [MiscellaneousAmount_Value],
       [ScribeOnline_ReceivablesBase].[MSCSCHID] AS [MiscellaneousTaxScheduleKey_Id],
       [ScribeOnline_ReceivablesBase].[LSTUSRED] AS [ModifiedBy],
       [ScribeOnline_ReceivablesBase].[LSTEDTDT] AS [ModifiedDate],
       [ScribeOnline_ReceivablesBase].[PTDUSRID] AS [PostedBy],
       [ScribeOnline_ReceivablesBase].[POSTEDDT] AS [PostedDate],
       [ScribeOnline_ReceivablesBase].[SLSAMNT] AS [SalesAmount_Value],
       [ScribeOnline_ReceivablesBase].[SLSCHDID] AS [SalesTaxScheduleKey_Id],
       [ScribeOnline_ReceivablesBase].[SALSTERR] AS [SalesTerritoryKey_Id],
       [ScribeOnline_ReceivablesBase].[SLPRSNID] AS [SalespersonKey_Id],
       [ScribeOnline_ReceivablesBase].[SHIPMTHD] AS [ShippingMethodKey_Id],
       [ScribeOnline_ReceivablesBase].[TAXAMNT] AS [TaxAmount_Value],
       [ScribeOnline_ReceivablesBase].[TAXSCHID] AS [TaxScheduleKey_Id],
       [ScribeOnline_ReceivablesBase].[TrxState] AS [TransactionState],
       [ScribeOnline_ReceivablesBase].[TRDISAMT] AS [TradeDiscountAmount_Value],
       [ScribeOnline_ReceivablesBase].[VOIDDATE] AS [VoidDate],
       [ScribeOnline_ReceivablesBase].[RMDTYPAL] AS [RMDocumentTypeAll],
       [ScribeOnline_ReceivablesBase].[BKTSLSAM] AS [BackoutSalesAmount],
       [ScribeOnline_ReceivablesBase].[BKTFRTAM] AS [BackoutFreightAmount],
       [ScribeOnline_ReceivablesBase].[BKTMSCAM] AS [BackoutMiscAmount],
       [ScribeOnline_ReceivablesBase].[DISCRTND] AS [DiscountReturned],
       [ScribeOnline_ReceivablesBase].[PPSAMDED] AS [PPSAmountDeducted],
       [ScribeOnline_ReceivablesBase].[DSCDLRAM] AS [DiscountDollarAmount],
       [ScribeOnline_ReceivablesBase].[DSCPCTAM] AS [DiscountPercentAmount],
       [ScribeOnline_ReceivablesBase].[Tax_Date] AS [TaxDate],
       [ScribeOnline_ReceivablesBase].[APLYWITH] AS [ApplyWithholding],
       [ScribeOnline_ReceivablesBase].[SALEDATE] AS [SaleDate],
       [ScribeOnline_ReceivablesBase].[CORRCTN] AS [Correction],
       [ScribeOnline_ReceivablesBase].[SIMPLIFD] AS [Simplified],
       [ScribeOnline_ReceivablesBase].[ECTRX] AS [ECTransaction],
       [ScribeOnline_ReceivablesBase].[BackoutTradeDisc] AS [BackoutTradeDiscountAmount],
       [ScribeOnline_ReceivablesBase].[EFTFLAG] AS [EFTFlag],
       [ScribeOnline_ReceivablesBase].[TRXSORCE] AS [TransactionSource]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
        where (EntityName IN (''RM10301'',''RM20101'',''RM30101'') and Id=RTRIM([ScribeOnline_ReceivablesBase].[RMDTYPAL])+''|''+RTRIM([ScribeOnline_ReceivablesBase].[DOCNUMBR])+''|''+RTRIM([ScribeOnline_ReceivablesBase].[CUSTNMBR]))) as [LastModifiedDateTime],
        UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
        where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
        where (EntityName IN (''RM10301'',''RM20101'',''RM30101'') and Id=RTRIM([ScribeOnline_ReceivablesBase].[RMDTYPAL])+''|''+RTRIM([ScribeOnline_ReceivablesBase].[DOCNUMBR])+''|''+RTRIM([ScribeOnline_ReceivablesBase].[CUSTNMBR])))),''''))as [LastModifiedBy]
        from [ScribeOnline_ReceivablesBase] with (NOLOCK) WHERE [ScribeOnline_ReceivablesBase].[RMDTYPAL] = 1')

/****** Object:  View [dbo].[ScribeOnline_ReceivablesFinanceCharge]    Script Date: 5/23/2016 4:15:26 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_ReceivablesFinanceCharge]') IS NULL AND OBJECT_ID(N'[dbo].[RM10301]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_ReceivablesFinanceCharge] AS select        [ScribeOnline_ReceivablesBase].[GSTDSAMT] AS [GSTDiscountAmount_Value],
       [ScribeOnline_ReceivablesBase].[CASHAMNT] AS [Payment_Cash_Amount_Value],
       [ScribeOnline_ReceivablesBase].[CBKIDCSH] AS [Payment_Cash_BankAccountKey_Id],
       [ScribeOnline_ReceivablesBase].[CASHDATE] AS [Payment_Cash_Date],
       [ScribeOnline_ReceivablesBase].[DCNUMCSH] AS [Payment_Cash_Number],
       [ScribeOnline_ReceivablesBase].[CHEKAMNT] AS [Payment_Check_Amount_Value],
       [ScribeOnline_ReceivablesBase].[CBKIDCHK] AS [Payment_Check_BankAccountKey_Id],
       [ScribeOnline_ReceivablesBase].[CHEKNMBR] AS [Payment_Check_CheckNumber],
       [ScribeOnline_ReceivablesBase].[CHEKDATE] AS [Payment_Check_Date],
       [ScribeOnline_ReceivablesBase].[DCNUMCHK] AS [Payment_Check_Number],
       [ScribeOnline_ReceivablesBase].[CBKIDCRD] AS [Payment_PaymentCard_BankAccountKey_Id],
       [ScribeOnline_ReceivablesBase].[CRCRDAMT] AS [Payment_PaymentCard_Amount_Value],
       [ScribeOnline_ReceivablesBase].[CRCARDDT] AS [Payment_PaymentCard_Date],
       [ScribeOnline_ReceivablesBase].[DCNUMCRD] AS [Payment_PaymentCard_Number],
       [ScribeOnline_ReceivablesBase].[RCTNCCRD] AS [Payment_PaymentCard_ReceiptNumber],
       [ScribeOnline_ReceivablesBase].[CRCRDNAM] AS [Payment_PaymentCard_TypeKey_Id],
       [ScribeOnline_ReceivablesBase].[PYMTRMID] AS [PaymentTermsKey_Id],
       [ScribeOnline_ReceivablesBase].[DISAVTKN] AS [Terms_DiscountAvailableTakenAmount_Value],
       [ScribeOnline_ReceivablesBase].[DISTKNAM] AS [Terms_DiscountTakenAmount_Value],
       [ScribeOnline_ReceivablesBase].[DISAVAMT] AS [Terms_DiscountAvailableAmount_Value],
       [ScribeOnline_ReceivablesBase].[DISCDATE] AS [Terms_DiscountDate],
       [ScribeOnline_ReceivablesBase].[DUEDATE] AS [Terms_DueDate],
       [ScribeOnline_ReceivablesBase].[WROFAMNT] AS [WriteoffAmount_Value],
       [ScribeOnline_ReceivablesBase].[CUSTNMBR] AS [AddressKey_CustomerKey_Id],
       [ScribeOnline_ReceivablesBase].[ADRSCODE] AS [AddressKey_Id],
       [ScribeOnline_ReceivablesBase].[BACHNUMB] AS [BatchKey_Id],
       [ScribeOnline_ReceivablesBase].[BCHSOURC] AS [BatchKey_Source],
       [ScribeOnline_ReceivablesBase].[CPRCSTNM] AS [CorporateAccountKey_Id],
       [ScribeOnline_ReceivablesBase].[COSTAMNT] AS [CostAmount_Value],
       [ScribeOnline_ReceivablesBase].[CURNCYID] AS [CurrencyKey_ISOCode],
       [ScribeOnline_ReceivablesBase].[CURTRXAM] AS [CurrentDocumentAmount_Value],
       [ScribeOnline_ReceivablesBase].[CUSTNMBR] AS [CustomerKey_Id],
       [ScribeOnline_ReceivablesBase].[CUSTNAME] AS [CustomerName],
       [ScribeOnline_ReceivablesBase].[CSTPONBR] AS [CustomerPONumber],
       [ScribeOnline_ReceivablesBase].[DOCDATE] AS [Date],
       [ScribeOnline_ReceivablesBase].[DOCDESCR] AS [Description],
       [ScribeOnline_ReceivablesBase].[ORTRXAMT] AS [DocumentAmount_Value],
       [ScribeOnline_ReceivablesBase].[EXCHDATE] AS [ExchangeDate],
       [ScribeOnline_ReceivablesBase].[XCHGRATE] AS [ExchangeRate],
       [ScribeOnline_ReceivablesBase].[FRTAMNT] AS [FreightAmount_Value],
       [ScribeOnline_ReceivablesBase].[FRTSCHID] AS [FreightTaxScheduleKey_Id],
       [ScribeOnline_ReceivablesBase].[GLPOSTDT] AS [GeneralLedgerPostingDate],
       [ScribeOnline_ReceivablesBase].[DINVPDOF] AS [InvoicePaidOffDate],
       [ScribeOnline_ReceivablesBase].[DELETE1] AS [IsDeleted],
       [ScribeOnline_ReceivablesBase].[DIRECTDEBIT] AS [IsDirectDebitDocument],
       [ScribeOnline_ReceivablesBase].[Electronic] AS [IsElectronic],
       [ScribeOnline_ReceivablesBase].[VOIDSTTS] AS [IsVoided],
       [ScribeOnline_ReceivablesBase].[DOCNUMBR] AS [Key_Id],
       [ScribeOnline_ReceivablesBase].[MISCAMNT] AS [MiscellaneousAmount_Value],
       [ScribeOnline_ReceivablesBase].[MSCSCHID] AS [MiscellaneousTaxScheduleKey_Id],
       [ScribeOnline_ReceivablesBase].[LSTUSRED] AS [ModifiedBy],
       [ScribeOnline_ReceivablesBase].[LSTEDTDT] AS [ModifiedDate],
       [ScribeOnline_ReceivablesBase].[PTDUSRID] AS [PostedBy],
       [ScribeOnline_ReceivablesBase].[POSTEDDT] AS [PostedDate],
       [ScribeOnline_ReceivablesBase].[SLSAMNT] AS [SalesAmount_Value],
       [ScribeOnline_ReceivablesBase].[SLSCHDID] AS [SalesTaxScheduleKey_Id],
       [ScribeOnline_ReceivablesBase].[SALSTERR] AS [SalesTerritoryKey_Id],
       [ScribeOnline_ReceivablesBase].[SLPRSNID] AS [SalespersonKey_Id],
       [ScribeOnline_ReceivablesBase].[SHIPMTHD] AS [ShippingMethodKey_Id],
       [ScribeOnline_ReceivablesBase].[TAXAMNT] AS [TaxAmount_Value],
       [ScribeOnline_ReceivablesBase].[TAXSCHID] AS [TaxScheduleKey_Id],
       [ScribeOnline_ReceivablesBase].[TRDISAMT] AS [TradeDiscountAmount_Value],
       [ScribeOnline_ReceivablesBase].[TrxState] AS [TransactionState],
       [ScribeOnline_ReceivablesBase].[VOIDDATE] AS [VoidDate],
       [ScribeOnline_ReceivablesBase].[RMDTYPAL] AS [RMDocumentTypeAll],
       [ScribeOnline_ReceivablesBase].[BKTSLSAM] AS [BackoutSalesAmount],
       [ScribeOnline_ReceivablesBase].[BKTFRTAM] AS [BackoutFreightAmount],
       [ScribeOnline_ReceivablesBase].[BKTMSCAM] AS [BackoutMiscAmount],
       [ScribeOnline_ReceivablesBase].[DISCRTND] AS [DiscountReturned],
       [ScribeOnline_ReceivablesBase].[PPSAMDED] AS [PPSAmountDeducted],
       [ScribeOnline_ReceivablesBase].[DSCDLRAM] AS [DiscountDollarAmount],
       [ScribeOnline_ReceivablesBase].[DSCPCTAM] AS [DiscountPercentAmount],
       [ScribeOnline_ReceivablesBase].[Tax_Date] AS [TaxDate],
       [ScribeOnline_ReceivablesBase].[APLYWITH] AS [ApplyWithholding],
       [ScribeOnline_ReceivablesBase].[SALEDATE] AS [SaleDate],
       [ScribeOnline_ReceivablesBase].[CORRCTN] AS [Correction],
       [ScribeOnline_ReceivablesBase].[SIMPLIFD] AS [Simplified],
       [ScribeOnline_ReceivablesBase].[ECTRX] AS [ECTransaction],
       [ScribeOnline_ReceivablesBase].[BackoutTradeDisc] AS [BackoutTradeDiscountAmount],
       [ScribeOnline_ReceivablesBase].[EFTFLAG] AS [EFTFlag],
       [ScribeOnline_ReceivablesBase].[TRXSORCE] AS [TransactionSource]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
        where (EntityName IN (''RM10301'',''RM20101'',''RM30101'') and Id=RTRIM([ScribeOnline_ReceivablesBase].[RMDTYPAL])+''|''+RTRIM([ScribeOnline_ReceivablesBase].[DOCNUMBR])+''|''+RTRIM([ScribeOnline_ReceivablesBase].[CUSTNMBR]))) as [LastModifiedDateTime],
        UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
        where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
        where (EntityName IN (''RM10301'',''RM20101'',''RM30101'') and Id=RTRIM([ScribeOnline_ReceivablesBase].[RMDTYPAL])+''|''+RTRIM([ScribeOnline_ReceivablesBase].[DOCNUMBR])+''|''+RTRIM([ScribeOnline_ReceivablesBase].[CUSTNMBR])))),''''))as [LastModifiedBy]
        from [ScribeOnline_ReceivablesBase] with (NOLOCK) WHERE [ScribeOnline_ReceivablesBase].[RMDTYPAL] = 4')

/****** Object:  View [dbo].[ScribeOnline_ReceivablesServiceRepair]    Script Date: 5/23/2016 4:15:26 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_ReceivablesServiceRepair]') IS NULL AND OBJECT_ID(N'[dbo].[RM10301]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_ReceivablesServiceRepair] AS select        [ScribeOnline_ReceivablesBase].[COMDLRAM] AS [CommissionAmount_Value],
       [ScribeOnline_ReceivablesBase].[COMAPPTO] AS [CommissionBasedOn],
       [ScribeOnline_ReceivablesBase].[GSTDSAMT] AS [GSTDiscountAmount_Value],
       [ScribeOnline_ReceivablesBase].[CASHAMNT] AS [Payment_Cash_Amount_Value],
       [ScribeOnline_ReceivablesBase].[CBKIDCSH] AS [Payment_Cash_BankAccountKey_Id],
       [ScribeOnline_ReceivablesBase].[CASHDATE] AS [Payment_Cash_Date],
       [ScribeOnline_ReceivablesBase].[DCNUMCSH] AS [Payment_Cash_Number],
       [ScribeOnline_ReceivablesBase].[CHEKAMNT] AS [Payment_Check_Amount_Value],
       [ScribeOnline_ReceivablesBase].[CBKIDCHK] AS [Payment_Check_BankAccountKey_Id],
       [ScribeOnline_ReceivablesBase].[CHEKNMBR] AS [Payment_Check_CheckNumber],
       [ScribeOnline_ReceivablesBase].[CHEKDATE] AS [Payment_Check_Date],
       [ScribeOnline_ReceivablesBase].[DCNUMCHK] AS [Payment_Check_Number],
       [ScribeOnline_ReceivablesBase].[CBKIDCRD] AS [Payment_PaymentCard_BankAccountKey_Id],
       [ScribeOnline_ReceivablesBase].[CRCRDAMT] AS [Payment_PaymentCard_Amount_Value],
       [ScribeOnline_ReceivablesBase].[CRCARDDT] AS [Payment_PaymentCard_Date],
       [ScribeOnline_ReceivablesBase].[DCNUMCRD] AS [Payment_PaymentCard_Number],
       [ScribeOnline_ReceivablesBase].[RCTNCCRD] AS [Payment_PaymentCard_ReceiptNumber],
       [ScribeOnline_ReceivablesBase].[CRCRDNAM] AS [Payment_PaymentCard_TypeKey_Id],
       [ScribeOnline_ReceivablesBase].[PYMTRMID] AS [PaymentTermsKey_Id],
       [ScribeOnline_ReceivablesBase].[DISAVTKN] AS [Terms_DiscountAvailableTakenAmount_Value],
       [ScribeOnline_ReceivablesBase].[DISTKNAM] AS [Terms_DiscountTakenAmount_Value],
       [ScribeOnline_ReceivablesBase].[DISAVAMT] AS [Terms_DiscountAvailableAmount_Value],
       [ScribeOnline_ReceivablesBase].[DISCDATE] AS [Terms_DiscountDate],
       [ScribeOnline_ReceivablesBase].[DUEDATE] AS [Terms_DueDate],
       [ScribeOnline_ReceivablesBase].[WROFAMNT] AS [WriteoffAmount_Value],
       [ScribeOnline_ReceivablesBase].[CUSTNMBR] AS [AddressKey_CustomerKey_Id],
       [ScribeOnline_ReceivablesBase].[ADRSCODE] AS [AddressKey_Id],
       [ScribeOnline_ReceivablesBase].[BACHNUMB] AS [BatchKey_Id],
       [ScribeOnline_ReceivablesBase].[BCHSOURC] AS [BatchKey_Source],
       [ScribeOnline_ReceivablesBase].[CPRCSTNM] AS [CorporateAccountKey_Id],
       [ScribeOnline_ReceivablesBase].[COSTAMNT] AS [CostAmount_Value],
       [ScribeOnline_ReceivablesBase].[CURNCYID] AS [CurrencyKey_ISOCode],
       [ScribeOnline_ReceivablesBase].[CURTRXAM] AS [CurrentDocumentAmount_Value],
       [ScribeOnline_ReceivablesBase].[CUSTNMBR] AS [CustomerKey_Id],
       [ScribeOnline_ReceivablesBase].[CUSTNAME] AS [CustomerName],
       [ScribeOnline_ReceivablesBase].[CSTPONBR] AS [CustomerPONumber],
       [ScribeOnline_ReceivablesBase].[DOCDATE] AS [Date],
       [ScribeOnline_ReceivablesBase].[DOCDESCR] AS [Description],
       [ScribeOnline_ReceivablesBase].[ORTRXAMT] AS [DocumentAmount_Value],
       [ScribeOnline_ReceivablesBase].[EXCHDATE] AS [ExchangeDate],
       [ScribeOnline_ReceivablesBase].[XCHGRATE] AS [ExchangeRate],
       [ScribeOnline_ReceivablesBase].[FRTAMNT] AS [FreightAmount_Value],
       [ScribeOnline_ReceivablesBase].[FRTSCHID] AS [FreightTaxScheduleKey_Id],
       [ScribeOnline_ReceivablesBase].[GLPOSTDT] AS [GeneralLedgerPostingDate],
       [ScribeOnline_ReceivablesBase].[DINVPDOF] AS [InvoicePaidOffDate],
       [ScribeOnline_ReceivablesBase].[DELETE1] AS [IsDeleted],
       [ScribeOnline_ReceivablesBase].[DIRECTDEBIT] AS [IsDirectDebitDocument],
       [ScribeOnline_ReceivablesBase].[Electronic] AS [IsElectronic],
       [ScribeOnline_ReceivablesBase].[VOIDSTTS] AS [IsVoided],
       [ScribeOnline_ReceivablesBase].[DOCNUMBR] AS [Key_Id],
       [ScribeOnline_ReceivablesBase].[MISCAMNT] AS [MiscellaneousAmount_Value],
       [ScribeOnline_ReceivablesBase].[MSCSCHID] AS [MiscellaneousTaxScheduleKey_Id],
       [ScribeOnline_ReceivablesBase].[LSTUSRED] AS [ModifiedBy],
       [ScribeOnline_ReceivablesBase].[LSTEDTDT] AS [ModifiedDate],
       [ScribeOnline_ReceivablesBase].[PTDUSRID] AS [PostedBy],
       [ScribeOnline_ReceivablesBase].[POSTEDDT] AS [PostedDate],
       [ScribeOnline_ReceivablesBase].[SLSAMNT] AS [SalesAmount_Value],
       [ScribeOnline_ReceivablesBase].[SLSCHDID] AS [SalesTaxScheduleKey_Id],
       [ScribeOnline_ReceivablesBase].[SALSTERR] AS [SalesTerritoryKey_Id],
       [ScribeOnline_ReceivablesBase].[SLPRSNID] AS [SalespersonKey_Id],
       [ScribeOnline_ReceivablesBase].[SHIPMTHD] AS [ShippingMethodKey_Id],
       [ScribeOnline_ReceivablesBase].[TAXAMNT] AS [TaxAmount_Value],
       [ScribeOnline_ReceivablesBase].[TAXSCHID] AS [TaxScheduleKey_Id],
       [ScribeOnline_ReceivablesBase].[TRDISAMT] AS [TradeDiscountAmount_Value],
       [ScribeOnline_ReceivablesBase].[TrxState] AS [TransactionState],
       [ScribeOnline_ReceivablesBase].[VOIDDATE] AS [VoidDate],
       [ScribeOnline_ReceivablesBase].[RMDTYPAL] AS [RMDocumentTypeAll],
       [ScribeOnline_ReceivablesBase].[BKTSLSAM] AS [BackoutSalesAmount],
       [ScribeOnline_ReceivablesBase].[BKTFRTAM] AS [BackoutFreightAmount],
       [ScribeOnline_ReceivablesBase].[BKTMSCAM] AS [BackoutMiscAmount],
       [ScribeOnline_ReceivablesBase].[DISCRTND] AS [DiscountReturned],
       [ScribeOnline_ReceivablesBase].[PPSAMDED] AS [PPSAmountDeducted],
       [ScribeOnline_ReceivablesBase].[DSCDLRAM] AS [DiscountDollarAmount],
       [ScribeOnline_ReceivablesBase].[DSCPCTAM] AS [DiscountPercentAmount],
       [ScribeOnline_ReceivablesBase].[Tax_Date] AS [TaxDate],
       [ScribeOnline_ReceivablesBase].[APLYWITH] AS [ApplyWithholding],
       [ScribeOnline_ReceivablesBase].[SALEDATE] AS [SaleDate],
       [ScribeOnline_ReceivablesBase].[CORRCTN] AS [Correction],
       [ScribeOnline_ReceivablesBase].[SIMPLIFD] AS [Simplified],
       [ScribeOnline_ReceivablesBase].[ECTRX] AS [ECTransaction],
       [ScribeOnline_ReceivablesBase].[BackoutTradeDisc] AS [BackoutTradeDiscountAmount],
       [ScribeOnline_ReceivablesBase].[EFTFLAG] AS [EFTFlag],
       [ScribeOnline_ReceivablesBase].[TRXSORCE] AS [TransactionSource]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
        where (EntityName IN (''RM10301'',''RM20101'',''RM30101'') and Id=RTRIM([ScribeOnline_ReceivablesBase].[RMDTYPAL])+''|''+RTRIM([ScribeOnline_ReceivablesBase].[DOCNUMBR])+''|''+RTRIM([ScribeOnline_ReceivablesBase].[CUSTNMBR]))) as [LastModifiedDateTime],
        UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
        where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
        where (EntityName IN (''RM10301'',''RM20101'',''RM30101'') and Id=RTRIM([ScribeOnline_ReceivablesBase].[RMDTYPAL])+''|''+RTRIM([ScribeOnline_ReceivablesBase].[DOCNUMBR])+''|''+RTRIM([ScribeOnline_ReceivablesBase].[CUSTNMBR])))),''''))as [LastModifiedBy]
        from [ScribeOnline_ReceivablesBase] with (NOLOCK) WHERE [ScribeOnline_ReceivablesBase].[RMDTYPAL] = 5')

/****** Object:  View [dbo].[ScribeOnline_ReceivablesReturn]    Script Date: 5/23/2016 4:15:27 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_ReceivablesReturn]') IS NULL AND OBJECT_ID(N'[dbo].[RM10301]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_ReceivablesReturn] AS select        [ScribeOnline_ReceivablesBase].[COMDLRAM] AS [CommissionAmount_Value],
       [ScribeOnline_ReceivablesBase].[COMAPPTO] AS [CommissionBasedOn],
       [ScribeOnline_ReceivablesBase].[CASHAMNT] AS [Payment_Cash_Amount_Value],
       [ScribeOnline_ReceivablesBase].[CBKIDCSH] AS [Payment_Cash_BankAccountKey_Id],
       [ScribeOnline_ReceivablesBase].[CASHDATE] AS [Payment_Cash_Date],
       [ScribeOnline_ReceivablesBase].[DCNUMCSH] AS [Payment_Cash_Number],
       [ScribeOnline_ReceivablesBase].[CHEKAMNT] AS [Payment_Check_Amount_Value],
       [ScribeOnline_ReceivablesBase].[CBKIDCHK] AS [Payment_Check_BankAccountKey_Id],
       [ScribeOnline_ReceivablesBase].[CHEKNMBR] AS [Payment_Check_CheckNumber],
       [ScribeOnline_ReceivablesBase].[CHEKDATE] AS [Payment_Check_Date],
       [ScribeOnline_ReceivablesBase].[DCNUMCHK] AS [Payment_Check_Number],
       [ScribeOnline_ReceivablesBase].[CBKIDCRD] AS [Payment_PaymentCard_BankAccountKey_Id],
       [ScribeOnline_ReceivablesBase].[CRCRDAMT] AS [Payment_PaymentCard_Amount_Value],
       [ScribeOnline_ReceivablesBase].[CRCARDDT] AS [Payment_PaymentCard_Date],
       [ScribeOnline_ReceivablesBase].[DCNUMCRD] AS [Payment_PaymentCard_Number],
       [ScribeOnline_ReceivablesBase].[RCTNCCRD] AS [Payment_PaymentCard_ReceiptNumber],
       [ScribeOnline_ReceivablesBase].[CRCRDNAM] AS [Payment_PaymentCard_TypeKey_Id],
       [ScribeOnline_ReceivablesBase].[DISCRTND] AS [DiscountReturned_Value],
       [ScribeOnline_ReceivablesBase].[CUSTNMBR] AS [AddressKey_CustomerKey_Id],
       [ScribeOnline_ReceivablesBase].[ADRSCODE] AS [AddressKey_Id],
       [ScribeOnline_ReceivablesBase].[BACHNUMB] AS [BatchKey_Id],
       [ScribeOnline_ReceivablesBase].[BCHSOURC] AS [BatchKey_Source],
       [ScribeOnline_ReceivablesBase].[CPRCSTNM] AS [CorporateAccountKey_Id],
       [ScribeOnline_ReceivablesBase].[COSTAMNT] AS [CostAmount_Value],
       [ScribeOnline_ReceivablesBase].[CURNCYID] AS [CurrencyKey_ISOCode],
       [ScribeOnline_ReceivablesBase].[CURTRXAM] AS [CurrentDocumentAmount_Value],
       [ScribeOnline_ReceivablesBase].[CUSTNMBR] AS [CustomerKey_Id],
       [ScribeOnline_ReceivablesBase].[CUSTNAME] AS [CustomerName],
       [ScribeOnline_ReceivablesBase].[CSTPONBR] AS [CustomerPONumber],
       [ScribeOnline_ReceivablesBase].[DOCDATE] AS [Date],
       [ScribeOnline_ReceivablesBase].[DOCDESCR] AS [Description],
       [ScribeOnline_ReceivablesBase].[ORTRXAMT] AS [DocumentAmount_Value],
       [ScribeOnline_ReceivablesBase].[EXCHDATE] AS [ExchangeDate],
       [ScribeOnline_ReceivablesBase].[XCHGRATE] AS [ExchangeRate],
       [ScribeOnline_ReceivablesBase].[FRTAMNT] AS [FreightAmount_Value],
       [ScribeOnline_ReceivablesBase].[FRTSCHID] AS [FreightTaxScheduleKey_Id],
       [ScribeOnline_ReceivablesBase].[GLPOSTDT] AS [GeneralLedgerPostingDate],
       [ScribeOnline_ReceivablesBase].[DINVPDOF] AS [InvoicePaidOffDate],
       [ScribeOnline_ReceivablesBase].[DELETE1] AS [IsDeleted],
       [ScribeOnline_ReceivablesBase].[DIRECTDEBIT] AS [IsDirectDebitDocument],
       [ScribeOnline_ReceivablesBase].[Electronic] AS [IsElectronic],
       [ScribeOnline_ReceivablesBase].[VOIDSTTS] AS [IsVoided],
       [ScribeOnline_ReceivablesBase].[DOCNUMBR] AS [Key_Id],
       [ScribeOnline_ReceivablesBase].[MISCAMNT] AS [MiscellaneousAmount_Value],
       [ScribeOnline_ReceivablesBase].[MSCSCHID] AS [MiscellaneousTaxScheduleKey_Id],
       [ScribeOnline_ReceivablesBase].[LSTUSRED] AS [ModifiedBy],
       [ScribeOnline_ReceivablesBase].[LSTEDTDT] AS [ModifiedDate],
       [ScribeOnline_ReceivablesBase].[PTDUSRID] AS [PostedBy],
       [ScribeOnline_ReceivablesBase].[POSTEDDT] AS [PostedDate],
       [ScribeOnline_ReceivablesBase].[SLSAMNT] AS [SalesAmount_Value],
       [ScribeOnline_ReceivablesBase].[SLSCHDID] AS [SalesTaxScheduleKey_Id],
       [ScribeOnline_ReceivablesBase].[SALSTERR] AS [SalesTerritoryKey_Id],
       [ScribeOnline_ReceivablesBase].[SLPRSNID] AS [SalespersonKey_Id],
       [ScribeOnline_ReceivablesBase].[SHIPMTHD] AS [ShippingMethodKey_Id],
       [ScribeOnline_ReceivablesBase].[TAXAMNT] AS [TaxAmount_Value],
       [ScribeOnline_ReceivablesBase].[TAXSCHID] AS [TaxScheduleKey_Id],
       [ScribeOnline_ReceivablesBase].[TRDISAMT] AS [TradeDiscountAmount_Value],
       [ScribeOnline_ReceivablesBase].[TrxState] AS [TransactionState],
       [ScribeOnline_ReceivablesBase].[VOIDDATE] AS [VoidDate],
       [ScribeOnline_ReceivablesBase].[RMDTYPAL] AS [RMDocumentTypeAll],
       [ScribeOnline_ReceivablesBase].[BKTSLSAM] AS [BackoutSalesAmount],
       [ScribeOnline_ReceivablesBase].[BKTFRTAM] AS [BackoutFreightAmount],
       [ScribeOnline_ReceivablesBase].[BKTMSCAM] AS [BackoutMiscAmount],
       [ScribeOnline_ReceivablesBase].[PPSAMDED] AS [PPSAmountDeducted],
       [ScribeOnline_ReceivablesBase].[DSCDLRAM] AS [DiscountDollarAmount],
       [ScribeOnline_ReceivablesBase].[DSCPCTAM] AS [DiscountPercentAmount],
       [ScribeOnline_ReceivablesBase].[Tax_Date] AS [TaxDate],
       [ScribeOnline_ReceivablesBase].[APLYWITH] AS [ApplyWithholding],
       [ScribeOnline_ReceivablesBase].[SALEDATE] AS [SaleDate],
       [ScribeOnline_ReceivablesBase].[CORRCTN] AS [Correction],
       [ScribeOnline_ReceivablesBase].[SIMPLIFD] AS [Simplified],
       [ScribeOnline_ReceivablesBase].[ECTRX] AS [ECTransaction],
       [ScribeOnline_ReceivablesBase].[BackoutTradeDisc] AS [BackoutTradeDiscountAmount],
       [ScribeOnline_ReceivablesBase].[EFTFLAG] AS [EFTFlag],
       [ScribeOnline_ReceivablesBase].[TRXSORCE] AS [TransactionSource]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
        where (EntityName IN (''RM10301'',''RM20101'',''RM30101'') and Id=RTRIM([ScribeOnline_ReceivablesBase].[RMDTYPAL])+''|''+RTRIM([ScribeOnline_ReceivablesBase].[DOCNUMBR])+''|''+RTRIM([ScribeOnline_ReceivablesBase].[CUSTNMBR]))) as [LastModifiedDateTime],
        UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
        where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
        where (EntityName IN (''RM10301'',''RM20101'',''RM30101'') and Id=RTRIM([ScribeOnline_ReceivablesBase].[RMDTYPAL])+''|''+RTRIM([ScribeOnline_ReceivablesBase].[DOCNUMBR])+''|''+RTRIM([ScribeOnline_ReceivablesBase].[CUSTNMBR])))),''''))as [LastModifiedBy]
        from [ScribeOnline_ReceivablesBase] with (NOLOCK) WHERE [ScribeOnline_ReceivablesBase].[RMDTYPAL] = 8')

/****** Object:  View [dbo].[ScribeOnline_ReceivablesWarranty]    Script Date: 5/23/2016 4:15:27 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_ReceivablesWarranty]') IS NULL AND OBJECT_ID(N'[dbo].[RM10301]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_ReceivablesWarranty] AS select        [ScribeOnline_ReceivablesBase].[CUSTNMBR] AS [AddressKey_CustomerKey_Id],
       [ScribeOnline_ReceivablesBase].[ADRSCODE] AS [AddressKey_Id],
       [ScribeOnline_ReceivablesBase].[BACHNUMB] AS [BatchKey_Id],
       [ScribeOnline_ReceivablesBase].[BCHSOURC] AS [BatchKey_Source],
       [ScribeOnline_ReceivablesBase].[CPRCSTNM] AS [CorporateAccountKey_Id],
       [ScribeOnline_ReceivablesBase].[COSTAMNT] AS [CostAmount_Value],
       [ScribeOnline_ReceivablesBase].[CURNCYID] AS [CurrencyKey_ISOCode],
       [ScribeOnline_ReceivablesBase].[CURTRXAM] AS [CurrentDocumentAmount_Value],
       [ScribeOnline_ReceivablesBase].[CUSTNMBR] AS [CustomerKey_Id],
       [ScribeOnline_ReceivablesBase].[CUSTNAME] AS [CustomerName],
       [ScribeOnline_ReceivablesBase].[CSTPONBR] AS [CustomerPONumber],
       [ScribeOnline_ReceivablesBase].[DOCDATE] AS [Date],
       [ScribeOnline_ReceivablesBase].[DOCDESCR] AS [Description],
       [ScribeOnline_ReceivablesBase].[ORTRXAMT] AS [DocumentAmount_Value],
       [ScribeOnline_ReceivablesBase].[EXCHDATE] AS [ExchangeDate],
       [ScribeOnline_ReceivablesBase].[XCHGRATE] AS [ExchangeRate],
       [ScribeOnline_ReceivablesBase].[FRTAMNT] AS [FreightAmount_Value],
       [ScribeOnline_ReceivablesBase].[FRTSCHID] AS [FreightTaxScheduleKey_Id],
       [ScribeOnline_ReceivablesBase].[GLPOSTDT] AS [GeneralLedgerPostingDate],
       [ScribeOnline_ReceivablesBase].[DINVPDOF] AS [InvoicePaidOffDate],
       [ScribeOnline_ReceivablesBase].[DELETE1] AS [IsDeleted],
       [ScribeOnline_ReceivablesBase].[DIRECTDEBIT] AS [IsDirectDebitDocument],
       [ScribeOnline_ReceivablesBase].[Electronic] AS [IsElectronic],
       [ScribeOnline_ReceivablesBase].[VOIDSTTS] AS [IsVoided],
       [ScribeOnline_ReceivablesBase].[DOCNUMBR] AS [Key_Id],
       [ScribeOnline_ReceivablesBase].[MISCAMNT] AS [MiscellaneousAmount_Value],
       [ScribeOnline_ReceivablesBase].[MSCSCHID] AS [MiscellaneousTaxScheduleKey_Id],
       [ScribeOnline_ReceivablesBase].[LSTUSRED] AS [ModifiedBy],
       [ScribeOnline_ReceivablesBase].[LSTEDTDT] AS [ModifiedDate],
       [ScribeOnline_ReceivablesBase].[PTDUSRID] AS [PostedBy],
       [ScribeOnline_ReceivablesBase].[POSTEDDT] AS [PostedDate],
       [ScribeOnline_ReceivablesBase].[SLSAMNT] AS [SalesAmount_Value],
       [ScribeOnline_ReceivablesBase].[SLSCHDID] AS [SalesTaxScheduleKey_Id],
       [ScribeOnline_ReceivablesBase].[SALSTERR] AS [SalesTerritoryKey_Id],
       [ScribeOnline_ReceivablesBase].[SLPRSNID] AS [SalespersonKey_Id],
       [ScribeOnline_ReceivablesBase].[SHIPMTHD] AS [ShippingMethodKey_Id],
       [ScribeOnline_ReceivablesBase].[TAXAMNT] AS [TaxAmount_Value],
       [ScribeOnline_ReceivablesBase].[TAXSCHID] AS [TaxScheduleKey_Id],
       [ScribeOnline_ReceivablesBase].[TRDISAMT] AS [TradeDiscountAmount_Value],
       [ScribeOnline_ReceivablesBase].[TrxState] AS [TransactionState],
       [ScribeOnline_ReceivablesBase].[VOIDDATE] AS [VoidDate],
       [ScribeOnline_ReceivablesBase].[RMDTYPAL] AS [RMDocumentTypeAll],
       [ScribeOnline_ReceivablesBase].[BKTSLSAM] AS [BackoutSalesAmount],
       [ScribeOnline_ReceivablesBase].[BKTFRTAM] AS [BackoutFreightAmount],
       [ScribeOnline_ReceivablesBase].[BKTMSCAM] AS [BackoutMiscAmount],
       [ScribeOnline_ReceivablesBase].[DISCRTND] AS [DiscountReturned],
       [ScribeOnline_ReceivablesBase].[PPSAMDED] AS [PPSAmountDeducted],
       [ScribeOnline_ReceivablesBase].[DSCDLRAM] AS [DiscountDollarAmount],
       [ScribeOnline_ReceivablesBase].[DSCPCTAM] AS [DiscountPercentAmount],
       [ScribeOnline_ReceivablesBase].[Tax_Date] AS [TaxDate],
       [ScribeOnline_ReceivablesBase].[APLYWITH] AS [ApplyWithholding],
       [ScribeOnline_ReceivablesBase].[SALEDATE] AS [SaleDate],
       [ScribeOnline_ReceivablesBase].[CORRCTN] AS [Correction],
       [ScribeOnline_ReceivablesBase].[SIMPLIFD] AS [Simplified],
       [ScribeOnline_ReceivablesBase].[ECTRX] AS [ECTransaction],
       [ScribeOnline_ReceivablesBase].[BackoutTradeDisc] AS [BackoutTradeDiscountAmount],
       [ScribeOnline_ReceivablesBase].[EFTFLAG] AS [EFTFlag],
       [ScribeOnline_ReceivablesBase].[TRXSORCE] AS [TransactionSource]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
        where (EntityName IN (''RM10301'',''RM20101'',''RM30101'') and Id=RTRIM([ScribeOnline_ReceivablesBase].[RMDTYPAL])+''|''+RTRIM([ScribeOnline_ReceivablesBase].[DOCNUMBR])+''|''+RTRIM([ScribeOnline_ReceivablesBase].[CUSTNMBR]))) as [LastModifiedDateTime],
        UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
        where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
        where (EntityName IN (''RM10301'',''RM20101'',''RM30101'') and Id=RTRIM([ScribeOnline_ReceivablesBase].[RMDTYPAL])+''|''+RTRIM([ScribeOnline_ReceivablesBase].[DOCNUMBR])+''|''+RTRIM([ScribeOnline_ReceivablesBase].[CUSTNMBR])))),''''))as [LastModifiedBy]
        from [ScribeOnline_ReceivablesBase] with (NOLOCK) WHERE [ScribeOnline_ReceivablesBase].[RMDTYPAL] = 6')

/****** Object:  View [dbo].[ScribeOnline_ReceivablesDistribution]    Script Date: 5/23/2016 4:15:27 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_ReceivablesDistribution]') IS NULL AND OBJECT_ID(N'[dbo].[RM10101]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_ReceivablesDistribution] AS select        [ScribeOnline_ReceivablesDistributionBase].[TrxState] AS [TransactionState],
       [ScribeOnline_ReceivablesDistributionBase].[RMDTYPAL] AS [RMDocumentTypeAll],
       [ScribeOnline_ReceivablesDistributionBase].[CUSTNMBR] AS [CustomerNumber],
       [ScribeOnline_ReceivablesDistributionBase].[DOCNUMBR] AS [Key_ReceivablesDocumentKey_Id],
       [ScribeOnline_ReceivablesDistributionBase].[SEQNUMBR] AS [Key_SequenceNumber],
       [ScribeOnline_ReceivablesDistributionBase].[POSTED] AS [IsPosted],
       [ScribeOnline_ReceivablesDistributionBase].[DISTTYPE] AS [DistributionTypeKey_Id],
       [ScribeOnline_ReceivablesDistributionBase].[DistRef] AS [Reference],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = DSTINDX) [GLAccountKey_Id],
       [ScribeOnline_ReceivablesDistributionBase].[DEBITAMT] AS [DebitAmount_Value],
       [ScribeOnline_ReceivablesDistributionBase].[CRDTAMNT] AS [CreditAmount_Value],
       [ScribeOnline_ReceivablesDistributionBase].[DSTINDX] AS [DistributionAccountIndex],
       [ScribeOnline_ReceivablesDistributionBase].[TRXSORCE] AS [TRXSource],
       [ScribeOnline_ReceivablesDistributionBase].[POSTEDDT] AS [PostedDate],
       [ScribeOnline_ReceivablesDistributionBase].[PSTGSTUS] AS [PostingStatus],
       [ScribeOnline_ReceivablesDistributionBase].[CHANGED] AS [Changed],
       [ScribeOnline_ReceivablesDistributionBase].[DCSTATUS] AS [Document Status],
       [ScribeOnline_ReceivablesDistributionBase].[PROJCTID] AS [ProjectID],
       [ScribeOnline_ReceivablesDistributionBase].[USERID] AS [UserID],
       [ScribeOnline_ReceivablesDistributionBase].[CATEGUSD] AS [CategoryUsed],
       [ScribeOnline_ReceivablesDistributionBase].[CURNCYID] AS [CurrencyID],
       [ScribeOnline_ReceivablesDistributionBase].[CURRNIDX] AS [CurrencyIndex],
       [ScribeOnline_ReceivablesDistributionBase].[ORCRDAMT] AS [OriginatingCreditAmount],
       [ScribeOnline_ReceivablesDistributionBase].[ORDBTAMT] AS [OriginatingDebitAmount]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
        where ((EntityName=''RM10101'' and Id=RTRIM([PSTGSTUS])+''|''+RTRIM([DOCNUMBR])+''|''+RTRIM([RMDTYPAL])+''|''+RTRIM([SEQNUMBR])+''|''+RTRIM([USERID])) 
        or(EntityName=''RM30301''and Id=RTRIM([DOCNUMBR])+''|''+RTRIM([RMDTYPAL])+''|''+RTRIM([SEQNUMBR])))) as [LastModifiedDateTime],
        UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
        where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
        where ((EntityName=''RM10101'' and Id=RTRIM([PSTGSTUS])+''|''+RTRIM([DOCNUMBR])+''|''+RTRIM([RMDTYPAL])+''|''+RTRIM([SEQNUMBR])+''|''+RTRIM([USERID])) 
        or(EntityName=''RM30301''and Id=RTRIM([DOCNUMBR])+''|''+RTRIM([RMDTYPAL])+''|''+RTRIM([SEQNUMBR]))))),''''))as [LastModifiedBy]
        from [ScribeOnline_ReceivablesDistributionBase] with (NOLOCK)')

/****** Object:  View [dbo].[ScribeOnline_PayablesDistribution]    Script Date: 5/23/2016 4:15:27 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_PayablesDistribution]') IS NULL AND OBJECT_ID(N'[dbo].[PM10100]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_PayablesDistribution] AS select        [ScribeOnline_PayablesDistributionBase].[TrxState] AS [TransactionState],
       [ScribeOnline_PayablesDistributionBase].[VENDORID] AS [VendorId],
       [ScribeOnline_PayablesDistributionBase].[DOCTYPE] AS [DocType],
       [ScribeOnline_PayablesDistributionBase].[VCHRNMBR] AS [Key_PayablesDocumentKey_Id],
       [ScribeOnline_PayablesDistributionBase].[DSTSQNUM] AS [Key_SequenceNumber],
       [ScribeOnline_PayablesDistributionBase].[PSTGDATE] AS [PostingDate],
       [ScribeOnline_PayablesDistributionBase].[PSTGSTUS] AS [IsPosted],
       [ScribeOnline_PayablesDistributionBase].[DISTTYPE] AS [DistributionTypeKey_Id],
       [ScribeOnline_PayablesDistributionBase].[DistRef] AS [Reference],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = DSTINDX) [GLAccountKey_Id],
       [ScribeOnline_PayablesDistributionBase].[DEBITAMT] AS [DebitAmount_Value],
       [ScribeOnline_PayablesDistributionBase].[CRDTAMNT] AS [CreditAmount_Value],
       [ScribeOnline_PayablesDistributionBase].[DSTINDX] AS [DistributionAccountIndex],
       [ScribeOnline_PayablesDistributionBase].[CNTRLTYP] AS [ControlType],
       [ScribeOnline_PayablesDistributionBase].[CHANGED] AS [Changed],
       [ScribeOnline_PayablesDistributionBase].[USERID] AS [UserID],
       [ScribeOnline_PayablesDistributionBase].[TRXSORCE] AS [TRXSource],
       [ScribeOnline_PayablesDistributionBase].[INTERID] AS [IntercompanyID],
       [ScribeOnline_PayablesDistributionBase].[CURNCYID] AS [CurrencyID],
       [ScribeOnline_PayablesDistributionBase].[CURRNIDX] AS [CurrencyIndex],
       [ScribeOnline_PayablesDistributionBase].[ORCRDAMT] AS [OriginatingCreditAmount],
       [ScribeOnline_PayablesDistributionBase].[ORDBTAMT] AS [OriginatingDebitAmount],
       [ScribeOnline_PayablesDistributionBase].[APTVCHNM] AS [ApplyToVoucherNumber],
       [ScribeOnline_PayablesDistributionBase].[APTODCTY] AS [ApplyToDocumentType],
       [ScribeOnline_PayablesDistributionBase].[SPCLDIST] AS [SpecializedDistribution],
       [ScribeOnline_PayablesDistributionBase].[RATETPID] AS [RateTypeID],
       [ScribeOnline_PayablesDistributionBase].[EXGTBLID] AS [ExchangeTableID],
       [ScribeOnline_PayablesDistributionBase].[XCHGRATE] AS [ExchangeRate],
       [ScribeOnline_PayablesDistributionBase].[EXCHDATE] AS [ExchangeDate],
       [ScribeOnline_PayablesDistributionBase].[TIME1] AS [Time],
       [ScribeOnline_PayablesDistributionBase].[RTCLCMTD] AS [RateCalculationMethod],
       [ScribeOnline_PayablesDistributionBase].[DECPLACS] AS [DecimalPlaces],
       [ScribeOnline_PayablesDistributionBase].[EXPNDATE] AS [ExpirationDate],
       [ScribeOnline_PayablesDistributionBase].[ICCURRID] AS [ICCurrencyID],
       [ScribeOnline_PayablesDistributionBase].[ICCURRIX] AS [ICCurrencyIndex],
       [ScribeOnline_PayablesDistributionBase].[DENXRATE] AS [DenominationExchangeRate],
       [ScribeOnline_PayablesDistributionBase].[MCTRXSTT] AS [MCTransactionState],
       [ScribeOnline_PayablesDistributionBase].[CorrespondingUnit] AS [CorrespondingUnit]
, (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
        where ((EntityName=''PM10100'' or EntityName=''PM30600'') and Id=RTRIM([VCHRNMBR])+''|''+RTRIM([DSTSQNUM])+''|''+RTRIM([CNTRLTYP])+''|''+RTRIM([APTVCHNM])+''|''+RTRIM([SPCLDIST]))) as [LastModifiedDateTime],
        UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
        where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
        where ((EntityName=''PM10100'' or EntityName=''PM30600'')  and Id=RTRIM([VCHRNMBR])+''|''+RTRIM([DSTSQNUM])+''|''+RTRIM([CNTRLTYP])+''|''+RTRIM([APTVCHNM])+''|''+RTRIM([SPCLDIST])))),''''))as [LastModifiedBy]
		from [ScribeOnline_PayablesDistributionBase] with (NOLOCK)')

/****** Object:  View [dbo].[ScribeOnline_ReceivablesTax]    Script Date: 5/23/2016 4:15:28 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_ReceivablesTax]') IS NULL AND OBJECT_ID(N'[dbo].[RM10601]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_ReceivablesTax] AS select        [ScribeOnline_ReceivablesTaxBase].[TrxState] AS [TransactionState],
       [ScribeOnline_ReceivablesTaxBase].[BACHNUMB] AS [BatchNumber],
       [ScribeOnline_ReceivablesTaxBase].[RMDTYPAL] AS [ReceivablesDocumentType],
       [ScribeOnline_ReceivablesTaxBase].[CUSTNMBR] AS [Customer Number],
       [ScribeOnline_ReceivablesTaxBase].[FRTTXAMT] AS [FreightTaxAmount_Value],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = [ScribeOnline_ReceivablesTaxBase].ACTINDX) "GLAccountKey_Id",
       [ScribeOnline_ReceivablesTaxBase].[DOCNUMBR] AS [Key_ReceivablesDocumentKey_Id],
       [ScribeOnline_ReceivablesTaxBase].[TAXDTLID] AS [Key_TaxDetailKey_Id],
       [ScribeOnline_ReceivablesTaxBase].[MSCTXAMT] AS [MiscellaneousTaxAmount_Value],
       [ScribeOnline_ReceivablesTaxBase].[STAXAMNT] AS [SalesTaxAmount_Value],
       [ScribeOnline_ReceivablesTaxBase].[BKOUTTAX] AS [IsBackoutTax],
       [ScribeOnline_ReceivablesTaxBase].[TAXAMNT] AS [TaxAmount_Value],
       [ScribeOnline_ReceivablesTaxBase].[TDTTXSLS] AS [TaxableAmount_Value],
       [ScribeOnline_ReceivablesTaxBase].[TAXDTSLS] AS [TotalAmount_Value],
       [ScribeOnline_ReceivablesTaxBase].[ACTINDX] AS [AccountIndex],
       [ScribeOnline_ReceivablesTaxBase].[ORTAXAMT] AS [OriginatingTaxAmount],
       [ScribeOnline_ReceivablesTaxBase].[ORSLSTAX] AS [OriginatingSalesTaxAmount],
       [ScribeOnline_ReceivablesTaxBase].[ORFRTTAX] AS [OriginatingFreightTaxAmount],
       [ScribeOnline_ReceivablesTaxBase].[ORMSCTAX] AS [OriginatingMiscTaxAmount],
       [ScribeOnline_ReceivablesTaxBase].[ORTOTSLS] AS [OriginatingTotalSales],
       [ScribeOnline_ReceivablesTaxBase].[ORTXSLS] AS [OriginatingTotalTaxableSales],
       [ScribeOnline_ReceivablesTaxBase].[TRXSORCE] AS [TRX Source]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
        where (EntityName IN (''RM10601'',''RM30601'') and Id=RTRIM([RMDTYPAL])+''|''+RTRIM([TAXDTLID])+''|''+RTRIM([DOCNUMBR])+''|''+RTRIM([TRXSORCE]))) as [LastModifiedDateTime],
        UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
        where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
        where (EntityName IN (''RM10601'',''RM30601'') and Id=RTRIM([DOCNUMBR])+''|''+RTRIM([TAXDTLID])+''|''+RTRIM([ACTINDX])+''|''+RTRIM([TRXSORCE])))),''''))as [LastModifiedBy]
        from [ScribeOnline_ReceivablesTaxBase] with (NOLOCK)')

/****** Object:  View [dbo].[ScribeOnline_PayablesTax]    Script Date: 5/23/2016 4:15:28 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_PayablesTax]') IS NULL AND OBJECT_ID(N'[dbo].[PM10500]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_PayablesTax] AS select        [ScribeOnline_PayablesTaxBase].[TrxState] AS [TransactionState],
       [ScribeOnline_PayablesTaxBase].[FRTTXAMT] AS [FreightTaxAmount_Value],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = [ScribeOnline_PayablesTaxBase].ACTINDX) "GLAccountKey_Id",
       [ScribeOnline_PayablesTaxBase].[POSTED] AS [IsPosted],
       [ScribeOnline_PayablesTaxBase].[VCHRNMBR] AS [Key_PayablesDocumentKey_Id],
       [ScribeOnline_PayablesTaxBase].[TAXDTLID] AS [Key_TaxDetailKey_Id],
       [ScribeOnline_PayablesTaxBase].[MSCTXAMT] AS [MiscellaneousTaxAmount_Value],
       [ScribeOnline_PayablesTaxBase].[PCTAXAMT] AS [PurchasesTaxAmount_Value],
       [ScribeOnline_PayablesTaxBase].[BKOUTTAX] AS [IsBackoutTax],
       [ScribeOnline_PayablesTaxBase].[TAXAMNT] AS [TaxAmount_Value],
       [ScribeOnline_PayablesTaxBase].[TDTTXPUR] AS [TaxableAmount_Value],
       [ScribeOnline_PayablesTaxBase].[TXDTTPUR] AS [TotalAmount_Value],
       [ScribeOnline_PayablesTaxBase].[ACTINDX] AS [AccountIndex],
       [ScribeOnline_PayablesTaxBase].[ORTAXAMT] AS [OriginatingTaxAmount],
       [ScribeOnline_PayablesTaxBase].[ORFRTTAX] AS [OriginatingFreightTaxAmount],
       [ScribeOnline_PayablesTaxBase].[ORMSCTAX] AS [OriginatingMiscTaxAmount],
       [ScribeOnline_PayablesTaxBase].[TRXSORCE] AS [TRX Source]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
        where (EntityName IN (''PM10500'',''PM30700'') and Id=RTRIM([VCHRNMBR])+''|''+RTRIM([TAXDTLID])+''|''+RTRIM([ACTINDX])+''|''+RTRIM([TRXSORCE]))) as [LastModifiedDateTime],
        UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
        where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
        where (EntityName IN (''PM10500'',''PM30700'') and Id=RTRIM([VCHRNMBR])+''|''+RTRIM([TAXDTLID])+''|''+RTRIM([ACTINDX])+''|''+RTRIM([TRXSORCE])))),''''))as [LastModifiedBy]
        from [ScribeOnline_PayablesTaxBase] with (NOLOCK)')

/****** Object:  View [dbo].[ScribeOnline_Vendor]    Script Date: 5/23/2016 4:15:28 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_Vendor]') IS NULL AND OBJECT_ID(N'[dbo].[PM00200]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_Vendor] AS select        [PM00200].[VENDORID] AS [Key_Id],
       [PM00200].[VENDNAME] AS [Name],
       [PM00200].[VENDSHNM] AS [ShortName],
       [PM00200].[VNDCHKNM] AS [CheckName],
       [PM00200].[HOLD] AS [IsOnHold],
      CASE VENDSTTS WHEN 1 THEN 1 ELSE 0 END AS [IsActive],
      CASE VENDSTTS WHEN 3 THEN 1 ELSE 0 END AS [IsOneTime],
       [PM00200].[VNDCLSID] AS [ClassKey_Id],
       [PM00200].[VADDCDPR] AS [DefaultAddressKey_Id],
       [PM00200].[VADCDPAD] AS [PurchaseAddressKey_Id],
       [PM00200].[VADCDTRO] AS [RemitToAddressKey_Id],
       [PM00200].[VADCDSFR] AS [ShipFromAddressKey_Id],
       [PM00200].[ACNMVNDR] AS [VendorAccountNumber],
       [PM00200].[COMMENT1] AS [Comment1],
       [PM00200].[COMMENT2] AS [Comment2],
       [SY03900].[TXTFIELD] AS [Notes],
       [PM00200].[CURNCYID] AS [CurrencyKey_ISOCode],
       [PM00200].[RATETPID] AS [RateTypeKey_Id],
       [PM00200].[PYMTRMID] AS [PaymentTermsKey_Id],
       [PM00200].[DISGRPER] AS [DiscountGracePeriod],
       [PM00200].[DUEGRPER] AS [DueDateGracePeriod],
       [PM00200].[PYMNTPRI] AS [PaymentPriority],
       [PM00200].[MINORDER] AS [MinimumOrderAmount_Value],
       [PM00200].[TRDDISCT] AS [TradeDiscountPercent_Value],
       [PM00200].[TAXSCHID] AS [TaxSchedule],
       [PM00200].[TXIDNMBR] AS [TaxIdentificationNumber],
       [PM00200].[TXRGNNUM] AS [TaxRegistrationNumber],
       [PM00200].[CHEKBKID] AS [BankAccountKey_Id],
       [PM00200].[USERDEF1] AS [UserDefined1],
       [PM00200].[USERDEF2] AS [UserDefined2],
       [PM00200].[TEN99TYPE] AS [Tax1099Type],
       [PM00200].[TEN99BOXNUMBER] AS [Tax1099BoxNumber],
       [PM00200].[FREEONBOARD] AS [FreeOnBoard],
       [PM00200].[USERLANG] AS [UserLanguageKey_Id],
       [PM00200].[Revalue_Vendor] AS [AllowRevaluation],
       [PM00200].[Post_Results_To] AS [PostResultsTo],
       [PM00200].[KPCALHST] AS [HistoryOptions_KeepCalendarHistory],
       [PM00200].[KPERHIST] AS [HistoryOptions_KeepFiscalHistory],
       [PM00200].[KPTRXHST] AS [HistoryOptions_KeepTransactionHistory],
       [PM00200].[KGLDSTHS] AS [HistoryOptions_KeepDistributionHistory],
       [PM00200].[PTCSHACF] AS [DefaultCashAccountType],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = ACPURIDX) [AccruedPurchasesGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMFINIDX) [FinanceChargesGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMFRTIDX) [FreightGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMPRCHIX) [PurchasesGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMAPINDX) [AccountsPayableGLAccountKey_Id],
      (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMCSHIDX) [CashGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PURPVIDX) [PurchasePriceVarianceGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMTAXIDX) [TaxGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMDAVIDX) [TermsDiscountAvailableGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMDTKIDX) [TermsDiscountTakenGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMTDSCIX) [TradeDiscountGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMWRTIDX) [WriteoffGLAccountKey_Id],
       (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PMMSCHIX) [MiscellaneousGLAccountKey_Id],
       [PA00901].[PAddlDefpoformatouse] AS [ProjectAccountingOptions_DefaultPurchaseOrderFormat],
       [PA00901].[PAUnit_of_Measure] AS [ProjectAccountingOptions_UnitOfMeasure],
       [PA00901].[PAUNITCOST] AS [ProjectAccountingOptions_UnitCost_Value],
       [PA00901].[PAUD1] AS [ProjectAccountingOptions_UserDefined1],
       [PA00901].[PAUD2] AS [ProjectAccountingOptions_UserDefined2],
       [PM00200].[Workflow_Priority] AS [WorkflowPriority],
       [SY05400].[LANGNAME] AS [Language],
       [PM00200].[VNDCNTCT] AS [VendorContact],
       [PM00200].[ADDRESS1] AS [Address1],
       [PM00200].[ADDRESS2] AS [Address2],
       [PM00200].[ADDRESS3] AS [Address3],
       [PM00200].[CITY] AS [City],
       [PM00200].[STATE] AS [State],
       [PM00200].[ZIPCODE] AS [ZipCode],
       [PM00200].[COUNTRY] AS [Country],
       [PM00200].[PHNUMBR1] AS [PhoneNumber1],
       [PM00200].[PHNUMBR2] AS [PhoneNumber2],
       [PM00200].[PHONE3] AS [Phone3],
       [PM00200].[FAXNUMBR] AS [FaxNumber],
       [PM00200].[UPSZONE] AS [UPSZone],
       [PM00200].[SHIPMTHD] AS [ShippingMethod],
       [PM00200].[PARVENID] AS [ParentVendorID],
       [PM00200].[WRITEOFF] AS [Writeoff],
       [PM00200].[CREDTLMT] AS [CreditLimit],
       [PM00200].[CRLMTDLR] AS [CreditLimitDollar],
       [PM00200].[MODIFDT] AS [ModifiedDate],
       [PM00200].[CREATDDT] AS [CreatedDate],
       [PM00200].[MINPYPCT] AS [MinimumPaymentPercent],
       [PM00200].[MINPYDLR] AS [MinimumPaymentDollar],
       [PM00200].[MXIAFVND] AS [MaximumInvoiceAmountForVendors],
       [PM00200].[MAXINDLR] AS [MaximumInvoiceDollar],
       [PM00200].[MXWOFAMT] AS [MaximumWriteOffAmount],
       [PM00200].[SBPPSDED] AS [SubjectToPPSDeductions],
       [PM00200].[PPSTAXRT] AS [PPSTaxRate],
       [PM00200].[DXVARNUM] AS [DeductionExemptionVariationNumber],
       [PM00200].[CRTCOMDT] AS [CertificateCommencingDate],
       [PM00200].[CRTEXPDT] AS [CertificateExpirationDate],
       [PM00200].[RTOBUTKN] AS [ReportingObligationUndertaken],
       [PM00200].[XPDTOBLG] AS [ExpirationDateObligation],
       [PM00200].[PRSPAYEE] AS [PrescribedPayee],
       [PM00200].[PMRTNGIX] AS [PMRetainageIndex],
       [PM00200].[GOVCRPID] AS [GovernmentalCorporateID],
       [PM00200].[GOVINDID] AS [GovernmentalIndividualID],
       [PM00200].[TaxInvRecvd] AS [TaxInvoiceReceived],
       [PM00200].[WithholdingType] AS [WithholdingType],
       [PM00200].[WithholdingFormType] AS [WithholdingFormType],
       [PM00200].[WithholdingEntityType] AS [WithholdingEntityType],
       [PM00200].[TaxFileNumMode] AS [TaxFileNumberMode],
       [PM00200].[BRTHDATE] AS [BirthDate],
       [PM00200].[LaborPmtType] AS [LaborPaymentType],
       [PM00200].[CCode] AS [CountryCode],
       [PM00200].[DECLID] AS [DeclarantID],
       [PM00200].[CBVAT] AS [CashBasedVAT],
       [PM00200].[Workflow_Approval_Status] AS [WorkflowApprovalStatus],
       [PM00200].[MINPYTYP] AS [MinimumPaymentType],
       [PA00901].[PATMProfitType] AS [PATimeAndMaterialsProfitType],
       [PA00901].[PATMProfitAmount] AS [PATimeAndMaterialDollarAmount],
       [PA00901].[PATMProfitPercent] AS [PATimeAndMaterialPercentAmount],
       [PA00901].[PAFFProfitType] AS [PAFixedPriceProfitType],
       [PA00901].[PAFFProfitAmount] AS [PAFixedPriceDollarAmount],
       [PA00901].[PAFFProfitPercent] AS [PAFixedPricePercentAmount],
       [PA00901].[PAProfit_Type__CP] AS [PACostPlusProfitType],
       [PA00901].[PAProfitAmountCP] AS [PACostPlusDollarAmount],
       [PA00901].[PAProfitPercentCP] AS [PACostPlusPercentAmount],
       [PA00901].[PAfromemployee] AS [PAFromEmployee],
       [PA00901].[PA_Allow_Vendor_For_PO] AS [PAAllowVendorForPO],
       [PM00200].[DOCFMTID] AS [DocumentFormatID],
       [PM00200].[VADCD1099] AS [VendorAddressCode1099]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
         where ((EntityName=''PM00200'' and Id=RTRIM(PM00200.VENDORID)) 
		 or (EntityName=''GL00105'' and Id IN (CAST(PMAPINDX as nvarchar(250)), CAST(PMDAVIDX as nvarchar(250)), CAST(PMDTKIDX as nvarchar(250)), CAST(PMFINIDX as nvarchar(250)), CAST(PMPRCHIX as nvarchar(250)), CAST(PMTDSCIX as nvarchar(250)), CAST(PMMSCHIX as nvarchar(250)), CAST(PMFRTIDX as nvarchar(250)), CAST(PMTAXIDX as nvarchar(250)), CAST(PMWRTIDX as nvarchar(250)), CAST(ACPURIDX as nvarchar(250)), CAST(PURPVIDX as nvarchar(250)))) 
		 or (EntityName = ''SY03900'' and Id=CAST(PM00200.NOTEINDX as varchar)))) as [LastModifiedDateTime],
         UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
         where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
         where ((EntityName=''PM00200'' and Id=RTRIM(PM00200.VENDORID))
		 or (EntityName=''GL00105'' and Id IN (CAST(PMAPINDX as nvarchar(250)), CAST(PMDAVIDX as nvarchar(250)), CAST(PMDTKIDX as nvarchar(250)), CAST(PMFINIDX as nvarchar(250)), CAST(PMPRCHIX as nvarchar(250)), CAST(PMTDSCIX as nvarchar(250)), CAST(PMMSCHIX as nvarchar(250)), CAST(PMFRTIDX as nvarchar(250)), CAST(PMTAXIDX as nvarchar(250)), CAST(PMWRTIDX as nvarchar(250)), CAST(ACPURIDX as nvarchar(250)), CAST(PURPVIDX as nvarchar(250)))) 
		 or (EntityName = ''SY03900'' and Id=CAST(PM00200.NOTEINDX as varchar))))),'''')) as [LastModifiedBy]
         FROM PM00200 (NOLOCK)        
         left outer join PA00901 with (NOLOCK) on (PM00200.VENDORID = PA00901.VENDORID)   
         left outer join [DYNAMICS].dbo.SY05400 with (NOLOCK) on (PM00200.USERLANG = [DYNAMICS].dbo.SY05400.USERLANG) 
         left outer join SY03900 with (NOLOCK) on (PM00200.NOTEINDX = SY03900.NOTEINDX)      
         ')

/****** Object:  View [dbo].[ScribeOnline_VendorAddress]    Script Date: 5/23/2016 4:15:28 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_VendorAddress]') IS NULL AND OBJECT_ID(N'[dbo].[PM00300]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_VendorAddress] AS select        [PM00300].[ADRSCODE] AS [Key_Id],
       [PM00300].[VENDORID] AS [Key_VendorKey_Id],
       [SY01200].[INETINFO] AS [InternetAddresses_AdditionalInformation],
       [SY01200].[EmailBccAddress] AS [InternetAddresses_EmailBccAddress],
       [SY01200].[EmailCcAddress] AS [InternetAddresses_EmailCcAddress],
       [SY01200].[EmailToAddress] AS [InternetAddresses_EmailToAddress],
       [SY01200].[INET1] AS [InternetAddresses_InternetField1],
       [SY01200].[INET2] AS [InternetAddresses_InternetField2],
       [SY01200].[INET3] AS [InternetAddresses_InternetField3],
       [SY01200].[INET4] AS [InternetAddresses_InternetField4],
       [SY01200].[INET5] AS [InternetAddresses_InternetField5],
       [SY01200].[INET6] AS [InternetAddresses_InternetField6],
       [SY01200].[INET7] AS [InternetAddresses_InternetField7],
       [SY01200].[INET8] AS [InternetAddresses_InternetField8],
       [SY01200].[Messenger_Address] AS [InternetAddresses_MessengerAddress],
       [PM00300].[SHIPMTHD] AS [ShippingMethodKey_Id],
       [PM00300].[TAXSCHID] AS [TaxScheduleKey_Id],
       [PM00300].[UPSZONE] AS [UPSZone],
       [PM00300].[VNDCNTCT] AS [ContactPerson],
       [PM00300].[CCode] AS [CountryRegionCodeKey_Id],
       [PM00300].[COUNTRY] AS [CountryRegion],
       [PM00300].[FAXNUMBR] AS [Fax],
       [PM00300].[PHNUMBR1] AS [Phone1],
       [PM00300].[PHNUMBR2] AS [Phone2],
       [PM00300].[PHONE3] AS [Phone3],
       [PM00300].[CITY] AS [City],
       [PM00300].[ADDRESS1] AS [Line1],
       [PM00300].[ADDRESS2] AS [Line2],
       [PM00300].[ADDRESS3] AS [Line3],
       [PM00300].[ZIPCODE] AS [PostalCode],
       [PM00300].[STATE] AS [State],
       [PM00300].[EmailPOs] AS [EmailPurchaseOrders],
       [PM00300].[POEmailRecipient] AS [PurchaseOrderEmailRecipient],
       [PM00300].[EmailPOFormat] AS [EmailPOFormat],
       [PM00300].[FaxPOs] AS [FaxPurchaseOrders],
       [PM00300].[FaxPOFormat] AS [FaxPOFormat],
       [PM00300].[POFaxNumber] AS [FaxPO],
       [PM00300].[DECLID] AS [DeclarentID]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
        where ((EntityName=''PM00300'' and Id=RTRIM(PM00300.VENDORID)+''|''+RTRIM(PM00300.ADRSCODE)) or (EntityName=''SY01200'' and Id=RTRIM(SY01200.Master_ID)+''|''+RTRIM(SY01200.ADRSCODE)+''|''+RTRIM(SY01200.Master_Type)))) as [LastModifiedDateTime],
        UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
        where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
        where ((EntityName=''PM00300'' and Id=RTRIM(PM00300.VENDORID)+''|''+RTRIM(PM00300.ADRSCODE)) or (EntityName=''SY01200'' and Id=RTRIM(SY01200.Master_ID)+''|''+RTRIM(SY01200.ADRSCODE)+''|''+RTRIM(SY01200.Master_Type))))),'''')) as [LastModifiedBy]
        FROM PM00300 with (NOLOCK) left outer join SY01200 with (NOLOCK) on ( 
		PM00300.VENDORID = SY01200.Master_ID AND  
		PM00300.ADRSCODE = SY01200.ADRSCODE AND  
		SY01200.Master_Type = ''VEN'')')

/****** Object:  View [dbo].[ScribeOnline_GLTransactionLine]    Script Date: 5/23/2016 4:15:29 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_GLTransactionLine]') IS NULL AND OBJECT_ID(N'[dbo].[GL10001]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_GLTransactionLine] AS select        [ScribeOnline_GLTransactionLineBase].[TrxState] AS [TransactionState],
       [ScribeOnline_GLTransactionLineBase].[SQNCLINE] AS [Key_SequenceNumber],
       [ScribeOnline_GLTransactionLineBase].[TRXDATE] AS [Key_TransactionKey_Date],
       [ScribeOnline_GLTransactionLineBase].[JRNENTRY] AS [Key_TransactionKey_JournalId],
       [ScribeOnline_GLTransactionLineBase].[DSCRIPTN] AS [Description],
       [ScribeOnline_GLTransactionLineBase].[EXCHDATE] AS [ExchangeDate],
       [ScribeOnline_GLTransactionLineBase].[XCHGRATE] AS [ExchangeRate],
       [ScribeOnline_GLTransactionLineBase].[ACTNUMST] AS [GLAccountKey_Id],
       [ScribeOnline_GLTransactionLineBase].[CMPANYID] AS [IntercompanyKey_Id],
       [ScribeOnline_GLTransactionLineBase].[ORDOCNUM] AS [OriginatingDocument_ControlId],
       [ScribeOnline_GLTransactionLineBase].[ORTRXDESC] AS [OriginatingDocument_Description],
       [ScribeOnline_GLTransactionLineBase].[ORCTRNUM] AS [OriginatingDocument_Id],
       [ScribeOnline_GLTransactionLineBase].[ORMSTRID] AS [OriginatingDocument_MasterId],
       [ScribeOnline_GLTransactionLineBase].[ORMSTRNM] AS [OriginatingDocument_MasterName],
       [ScribeOnline_GLTransactionLineBase].[OrigSeqNum] AS [OriginatingDocument_SequenceNumber],
       [ScribeOnline_GLTransactionLineBase].[ORTRXTYP] AS [OriginatingDocument_Type],
       [ScribeOnline_GLTransactionLineBase].[CRDTAMNT] AS [CreditAmount_Value],
       [ScribeOnline_GLTransactionLineBase].[DEBITAMT] AS [DebitAmount_Value],
       [ScribeOnline_GLTransactionLineBase].[RCTRXSEQ] AS [RecurringTRXSequence],
       [ScribeOnline_GLTransactionLineBase].[ORCRDAMT] AS [OriginatingCreditAmount],
       [ScribeOnline_GLTransactionLineBase].[ORDBTAMT] AS [OriginatingDebitAmount],
       [ScribeOnline_GLTransactionLineBase].[YEAR] AS [Year],
       [ScribeOnline_GLTransactionLineBase].[DEX_ROW_ID] AS [DexRowId]
,
                (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
        where ((EntityName=''GL10001'' and Id=RTRIM([JRNENTRY])+''|''+RTRIM([SQNCLINE]))
		or (EntityName IN (''GL20000'', ''GL30000'') and Id=RTRIM([DEX_ROW_ID])))) as [LastModifiedDateTime],
		UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
        where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
        where ((EntityName=''GL10001'' and Id=RTRIM([JRNENTRY])+''|''+RTRIM([SQNCLINE]))
		or (EntityName IN (''GL20000'', ''GL30000'') and Id=RTRIM([DEX_ROW_ID])))
				)),''''))as [LastModifiedBy]
        from [ScribeOnline_GLTransactionLineBase] with (NOLOCK)')

/****** Object:  View [dbo].[ScribeOnline_SalesItem]    Script Date: 5/23/2016 4:15:29 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_SalesItem]') IS NULL AND OBJECT_ID(N'[dbo].[IV00101]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_SalesItem] AS select        [IV00101].[LOTTYPE] AS [LotCategoryKey_Id],
       [IV00101].[MINSHELF1] AS [MinimumShelfLifeDays1],
       [IV00101].[MINSHELF2] AS [MinimumShelfLifeDays2],
       [IV00101].[Revalue_Inventory] AS [RevalueInventory],
      Cast([IV00101].[Tolerance_Percentage] as Decimal)/100000  AS [TolerancePercentage_Value],
       [IV00101].[ITMTRKOP] AS [TrackingOption],
       [IV00101].[VCTNMTHD] AS [ValuationMethod],
       [IV00101].[ABCCODE] AS [ABCCode],
       [IV00101].[ALWBKORD] AS [AllowBackOrder],
      (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = ASMVRIDX) [AssemblyVarianceGLAccountKey_Id],
       [IV00101].[ITMCLSCD] AS [ClassKey_Id],
      (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = IVCOGSIX) [CostofGoodsSoldGLAccountKey_Id],
       [IV00101].[CREATDDT] AS [CreatedDate],
       [IV00101].[DECPLCUR] AS [CurrencyDecimalPlaces],
       [IV00101].[CURRCOST] AS [CurrentCost_Value],
      (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = IVDMGIDX) [DamagedGLAccountKey_Id],
       [IV00101].[PRCLEVEL] AS [DefaultPriceLevelKey_Id],
       [IV00101].[SELNGUOM] AS [DefaultSellingUofM],
       [IV00101].[LOCNCODE] AS [DefaultWarehouseKey_Id],
       [IV00101].[ITEMDESC] AS [Description],
      (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = DPSHPIDX) [DropShipGLAccountKey_Id],
       [IV00101].[ITMGEDSC] AS [GenericDescription],
      (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = IVINSVIX) [InServiceGLAccountKey_Id],
      (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = IVINUSIX) [InUseGLAccountKey_Id],
       [IV00101].[INCLUDEINDP] AS [IncludeInDemandPlanning],
       [SY01200].[INETINFO] AS [InternetAddresses_AdditionalInformation],
       [SY01200].[EmailBccAddress] AS [InternetAddresses_EmailBccAddress],
       [SY01200].[EmailCcAddress] AS [InternetAddresses_EmailCcAddress],
       [SY01200].[EmailToAddress] AS [InternetAddresses_EmailToAddress],
       [SY01200].[INET1] AS [InternetAddresses_InternetField1],
       [SY01200].[INET2] AS [InternetAddresses_InternetField2],
       [SY01200].[INET3] AS [InternetAddresses_InternetField3],
       [SY01200].[INET4] AS [InternetAddresses_InternetField4],
       [SY01200].[INET5] AS [InternetAddresses_InternetField5],
       [SY01200].[INET6] AS [InternetAddresses_InternetField6],
       [SY01200].[INET7] AS [InternetAddresses_InternetField7],
       [SY01200].[INET8] AS [InternetAddresses_InternetField8],
       [SY01200].[Messenger_Address] AS [InternetAddresses_MessengerAddress],
      (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = IVIVINDX) [InventoryGLAccountKey_Id],
      (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = IVIVOFIX) [InventoryOffsetGLAccountKey_Id],
      (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = IVRETIDX) [InventoryReturnGLAccountKey_Id],
      CASE INACTIVE WHEN 1 THEN 1 ELSE 0 END AS [IsDiscontinued],
       [IV00101].[KPCALHST] AS [KeepCalendarYearHistory],
       [IV00101].[KPDSTHST] AS [KeepDistributionHistory],
       [IV00101].[KPERHIST] AS [KeepFiscalYearHistory],
       [IV00101].[KPTRXHST] AS [KeepTransactionHistory],
       [IV00101].[ITEMNMBR] AS [Key_Id],
      (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = IVSLDSIX) [MarkdownGLAccountKey_Id],
       [IV00101].[MODIFDT] AS [ModifiedDate],
       [IV00101].[PRICMTHD] AS [PriceMethod],
      (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = PURPVIDX) [PurchasePriceVarianceGLAccountKey_Id],
       [IV00101].[Purchase_Tax_Options] AS [PurchaseTaxBasis],
       [IV00101].[Purchase_Item_Tax_Schedu] AS [PurchaseTaxScheduleKey_Id],
       [IV00101].[PRCHSUOM] AS [PurchaseUofM],
       [IV00101].[DECPLQTY] AS [QuantityDecimalPlaces],
      (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = IVSLSIDX) [SalesGLAccountKey_Id],
      (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = IVSLRNIX) [SalesReturnGLAccountKey_Id],
       [IV00101].[TAXOPTNS] AS [SalesTaxBasis],
       [IV00101].[ITMTSHID] AS [SalesTaxScheduleKey_Id],
      CAST([IV00101].[ITEMSHWT] AS Decimal)/100 AS [ShippingWeight],
       [IV00101].[ITMSHNAM] AS [ShortDescription],
       [IV00101].[STNDCOST] AS [StandardCost_Value],
       [IV00101].[ALTITEM1] AS [SubstituteItem1Key_Id],
       [IV00101].[ALTITEM2] AS [SubstituteItem2Key_Id],
       [IV00101].[ITEMTYPE] AS [Type],
      (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = UPPVIDX) [UnrealizedPurchasePriceVarianceGLAccountKey_Id],
       [IV00101].[UOMSCHDL] AS [UofMScheduleKey_Id],
       [IV00101].[USCATVLS_1] AS [UserCategoryList1],
       [IV00101].[USCATVLS_2] AS [UserCategoryList2],
       [IV00101].[USCATVLS_3] AS [UserCategoryList3],
       [IV00101].[USCATVLS_4] AS [UserCategoryList4],
       [IV00101].[USCATVLS_5] AS [UserCategoryList5],
       [IV00101].[USCATVLS_6] AS [UserCategoryList6],
      (select ACTNUMST from GL00105 with (NOLOCK) where GL00105.ACTINDX = IVVARIDX) [VarianceGLAccountKey_Id],
       [IV00101].[WRNTYDYS] AS [WarrantyDays],
       [SY03900].[TXTFIELD] AS [Notes],
       [IV00101].[MSTRCDTY] AS [MasterRecordType],
       [IV00101].[PINFLIDX] AS [PurchInflationIndex],
       [IV00101].[PURMCIDX] AS [PurchMonetaryCorrectionIndex],
       [IV00101].[IVINFIDX] AS [InventoryInflationIndex],
       [IV00101].[INVMCIDX] AS [InventoryMonetaryCorrectionIndex],
       [IV00101].[CGSINFLX] AS [COGSInflationIndex],
       [IV00101].[CGSMCIDX] AS [COGSMonetaryCorrection],
       [IV00101].[ITEMCODE] AS [ItemCode],
       [IV00101].[TCC] AS [TaxCommodityCode],
       [IV00101].[PriceGroup] AS [PriceGroup],
       [IV00101].[KTACCTSR] AS [KitCOGSAccountSource],
       [IV00101].[LASTGENSN] AS [LastGeneratedSerialNumber],
       [IV00101].[ITMPLNNNGTYP] AS [ItemPlanningType],
       [IV00101].[STTSTCLVLPRCNTG] AS [StatisticalValuePercentage],
       [IV00101].[CNTRYORGN] AS [CountryOrigin],
       [IV00101].[LOTEXPWARN] AS [LotExpireWarning],
       [IV00101].[LOTEXPWARNDAYS] AS [LotExpireWarningDays],
       [IV00101].[LASTGENLOT] AS [LastGeneratedLotNumber],
       [IV00101].[Lot_Split_Quantity] AS [LotSplitQuantity],
       [IV00101].[UseQtyOverageTolerance] AS [UseQtyOverageTolerance],
       [IV00101].[UseQtyShortageTolerance] AS [UseQtyShortageTolerance],
       [IV00101].[QtyOverTolerancePercent] AS [QtyOverTolerancePercent],
       [IV00101].[QtyShortTolerancePercent] AS [QtyShortTolerancePercent],
       [IV00101].[IVSCRVIX] AS [StandardCostRevaluationIndex]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
        where (EntityName=''IV00101'' and Id=IV00101.ITEMNMBR) or (EntityName = ''SY01200'' and Id=SY01200.Master_ID) or (EntityName = ''SY03900'' and Id=CAST(IV00101.NOTEINDX as varchar))) as [LastModifiedDateTime],
        UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
        where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
        where (EntityName=''IV00101'' and Id=IV00101.ITEMNMBR) or (EntityName = ''SY01200'' and Id=SY01200.Master_ID) or (EntityName = ''SY03900'' and Id=CAST(IV00101.NOTEINDX as varchar)))),''''))as [LastModifiedBy]
        from IV00101 with (NOLOCK) left outer join SY03900 with (NOLOCK) on (IV00101.NOTEINDX = SY03900.NOTEINDX)
        left outer join SY01200 with (NOLOCK) on (IV00101.ITEMNMBR=SY01200.Master_ID and SY01200.Master_Type = ''ITM'')  WHERE ITEMTYPE = 1 OR ITEMTYPE = 2 ')

/****** Object:  View [dbo].[ScribeOnline_SalesItemWarehouse]    Script Date: 5/23/2016 4:15:29 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_SalesItemWarehouse]') IS NULL AND OBJECT_ID(N'[dbo].[IV00102]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_SalesItemWarehouse] AS select        [IV00102].[ATYALLOC] AS [AllocatedQuantity_Value],
       [IV00102].[QTYBKORD] AS [BackOrderedQuantity_Value],
       [IV00102].[QTYDMGED] AS [DamagedQuantity_Value],
       [IV00102].[QTYINSVC] AS [InServiceQuantity_Value],
       [IV00102].[QTYINUSE] AS [InUseQuantity_Value],
       [IV00102].[ITEMNMBR] AS [Key_ItemKey_Id],
       [IV00102].[LOCNCODE] AS [Key_WarehouseKey_Id],
       [IV00102].[QTYONHND] AS [OnHandQuantity_Value],
       [IV00102].[QTYONORD] AS [OnOrderQuantity_Value],
       [IV00102].[QTYRTRND] AS [ReturnedQuantity_Value],
       [IV00102].[BINNMBR] AS [Bin],
       [IV00102].[PRIMVNDR] AS [PrimaryVendorKey_Id],
       [IV00102].[Landed_Cost_Group_ID] AS [LandedCostGroupKey_Id],
       [IV00102].[QTYRQSTN] AS [RequisitionedQuantity_Value],
       [IV00102].[BUYERID] AS [BuyerKey_Id],
       [IV00102].[PLANNERID] AS [PlannerKey_Id],
       [IV00102].[ORDERPOLICY] AS [Planning_OrderPolicy],
       [IV00102].[FXDORDRQTY] AS [Planning_FixedOrderQuantity_Value],
       [IV00102].[ORDRPNTQTY] AS [Planning_OrderPointQuantity_Value],
       [IV00102].[ORDRUPTOLVL] AS [Planning_OrderUpToLevelQuantity_Value],
       [IV00102].[REPLENISHMENTMETHOD] AS [Planning_ReplenishmentMethod],
      SHRINKAGEFACTOR * 100 [Planning_ShrinkageFactor_Value],
       [IV00102].[PRCHSNGLDTM] AS [Planning_PurchasingLeadTime],
       [IV00102].[MNFCTRNGFXDLDTM] AS [Planning_ManufacturingLeadTime],
       [IV00102].[PLNNNGTMFNCDYS] AS [Planning_TimeFence],
       [IV00102].[MNMMORDRQTY] AS [Planning_MinimumOrderQuantity_Value],
       [IV00102].[MXMMORDRQTY] AS [Planning_MaximumOrderQuantity_Value],
       [IV00102].[ORDERMULTIPLE] AS [Planning_OrderMultipleQuantity_Value],
       [IV00102].[REORDERVARIANCE] AS [Planning_ReorderVarianceQuantity_Value],
       [IV00102].[SFTYSTCKQTY] AS [Planning_SafetyStockQuantity_Value],
       [IV00102].[NMBROFDYS] AS [NumberofDays],
       [IV00102].[RCRDTYPE] AS [RecordType],
       [IV00102].[ITMFRFLG] AS [ItemFreezeFlag],
       [IV00102].[BGNGQTY] AS [BeginningQTY],
       [IV00102].[LSORDQTY] AS [LastORDQTY],
       [IV00102].[LRCPTQTY] AS [LastRCPTQTY],
       [IV00102].[LSTORDDT] AS [LastORDDate],
       [IV00102].[LSORDVND] AS [LastORDVendor],
       [IV00102].[LSRCPTDT] AS [LastRCPTDate],
       [IV00102].[QTY_Drop_Shipped] AS [QTYDropShipped],
       [IV00102].[QTYCOMTD] AS [QTYCommitted],
       [IV00102].[QTYSOLD] AS [QTYSold],
       [IV00102].[NXTCNTDT] AS [NextCountDate],
       [IV00102].[NXTCNTTM] AS [NextCountTime],
       [IV00102].[LSTCNTDT] AS [LastCountDate],
       [IV00102].[LSTCNTTM] AS [LastCountTime],
       [IV00102].[STCKCNTINTRVL] AS [StockCountInterval],
       [IV00102].[MNFCTRNGVRBLLDTM] AS [ManufacturingVariableLeadTime],
       [IV00102].[STAGINGLDTME] AS [StagingLeadTime],
       [IV00102].[DMNDTMFNCPRDS] AS [DemandTimeFencePeriods],
       [IV00102].[INCLDDINPLNNNG] AS [IncludedinPlanning],
       [IV00102].[CALCULATEATP] AS [CalculateATP],
       [IV00102].[AUTOCHKATP] AS [AutoCheckATP],
       [IV00102].[PLNFNLPAB] AS [PlanFinalPAB],
       [IV00102].[FRCSTCNSMPTNPRD] AS [ForecastConsumptionPeriod],
       [IV00102].[PORECEIPTBIN] AS [PurchaseReceiptBin],
       [IV00102].[PORETRNBIN] AS [PurchaseReturnsBin],
       [IV00102].[SOFULFILLMENTBIN] AS [SOFullfillmentBin],
       [IV00102].[SORETURNBIN] AS [SOReturnBin],
       [IV00102].[BOMRCPTBIN] AS [BOMReceiptBin],
       [IV00102].[MATERIALISSUEBIN] AS [MaterialIssuesBin],
       [IV00102].[MORECEIPTBIN] AS [MOReceiptBin],
       [IV00102].[REPAIRISSUESBIN] AS [RepairIssuesBin],
       [IV00102].[ReplenishmentLevel] AS [ReplenishmentLevel],
       [IV00102].[POPOrderMethod] AS [POPOrderMethod],
       [IV00102].[MasterLocationCode] AS [MasterLocationCode],
       [IV00102].[POPVendorSelection] AS [POPVendorSelection],
       [IV00102].[POPPricingSelection] AS [POPPricingSelection],
       [IV00102].[PurchasePrice] AS [PurchasePrice],
       [IV00102].[IncludeAllocations] AS [IncludeAllocations],
       [IV00102].[IncludeBackorders] AS [IncludeBackOrders],
       [IV00102].[IncludeRequisitions] AS [IncludeRequisitions],
       [IV00102].[PICKTICKETITEMOPT] AS [PickingTicketItemOption],
       [IV00102].[INCLDMRPMOVEIN] AS [IncludeMRPMoveIn],
       [IV00102].[INCLDMRPMOVEOUT] AS [IncludeMRPMoveOut],
       [IV00102].[INCLDMRPCANCEL] AS [IncludeMRPCancel],
       [IV00102].[Move_Out_Fence] AS [MoveOutFence],
       [IV00102].[INACTIVE] AS [Inactive]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
        where ((EntityName=''IV00102'')  and Id=RTRIM([ITEMNMBR])+''|''+RTRIM([LOCNCODE])+''|''+RTRIM([RCRDTYPE]))) as [LastModifiedDateTime],
        UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
        where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
        where ((EntityName=''IV00102'')  and Id=RTRIM([ITEMNMBR])+''|''+RTRIM([LOCNCODE])+''|''+RTRIM([RCRDTYPE])))),''''))as [LastModifiedBy]
		from [IV00102] with (NOLOCK) WHERE LOCNCODE <> ''''       
        ')

/******
	Object:  View [dbo].[ScribeOnline_SalesPayment]    Script Date: 3/14/2018 4:15:30 PM 
		This view does not support Online Payment Processing package which was discontinued on 1/1/2018.
		The original view is still maintained below for version prior to GP 2018 that still contain the 'DO10103' table.
		Both ScribeOnline_SalesPayment views need to be maintaned so that new and existing GP installations are supported.
 ******/
IF OBJECT_ID(N'[dbo].[ScribeOnline_SalesPayment]') IS NULL AND OBJECT_ID(N'[dbo].[SOP10103]') IS NOT NULL
	IF OBJECT_ID(N'[dbo].[DO10103]') IS NULL
		exec('CREATE VIEW [dbo].[ScribeOnline_SalesPayment] AS select        [SOP10103].[AMNTPAID] AS [PaymentAmount_Value],
		   [SOP10103].[AUTHCODE] AS [AuthorizationCode],
		   [SOP10103].[CARDNAME] AS [PaymentCardTypeKey_Id],
		   [SOP10103].[CHEKNMBR] AS [CheckNumber],
		   [SOP10103].[CURNCYID] AS [PaymentAmount_Currency],
		   [SOP10103].[DELETE1] AS [DeleteOnUpdate],
		   [SOP10103].[DOCDATE] AS [Date],
		   [SOP10103].[SOPNUMBE] AS [Key_SalesDocumentKey_Id],
		   [SOP10103].[DOCNUMBR] AS [Number],
		   [SOP10103].[EXPNDATE] AS [ExpirationDate],
		   0 AS [IsProcessElectronically],
		  (CASE WHEN PYMTTYPE=1 THEN ''Cash Deposit'' WHEN PYMTTYPE=2 THEN ''Check Deposit'' WHEN PYMTTYPE=3 THEN ''Payment Card Deposit'' WHEN PYMTTYPE=4 THEN ''Cash Payment'' WHEN PYMTTYPE=5 THEN ''Check Payment'' WHEN PYMTTYPE=6 THEN ''Payment Card Payment'' ELSE '''' END ) AS [Type],
		   [SOP10103].[RCTNCCRD] AS [PaymentCardNumber],
		   [SOP10103].[SEQNUMBR] AS [Key_SequenceNumber],
		   [SOP10103].[TRXSORCE] AS [AuditTrailCode],
		   [SOP10103].[AMNTREMA] AS [AmountRemaining],
		   [SOP10103].[CASHINDEX] AS [CashIndex],
		   [SOP10103].[CHEKBKID] AS [CheckbookID],
		   [SOP10103].[CURRNIDX] AS [CurrencyIndex],
		   [SOP10103].[DEPINDEX] AS [DepositsIndex],
		   [SOP10103].[DEPSTATS] AS [DepositStatus],
		   [SOP10103].[EFTFLAG] AS [EFTFlag],
		   [SOP10103].[GLPOSTDT] AS [GLPostingDate],
		   [SOP10103].[OAMNTREM] AS [OriginatingAmountRemaining],
		   [SOP10103].[OAMTPAID] AS [OriginatingAmountPaid],
		   [SOP10103].[RMDTYPAL] AS [RMDocumentTypeAll],
		   [SOP10103].[SOPTYPE] AS [SOPType]
	,
			(select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK)
			where (EntityName=''SOP10103'' and Id=RTRIM([SOP10103].[SOPTYPE])+''|''+RTRIM([SOP10103].[SOPNUMBE])+''|''+CAST([SOP10103].[SEQNUMBR] as varchar))) as [LastModifiedDateTime],
			UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK)
			where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK)
			where EntityName=''SOP10103'' and Id=RTRIM([SOP10103].[SOPTYPE])+''|''+RTRIM([SOP10103].[SOPNUMBE])+''|''+CAST([SOP10103].[SEQNUMBR] as varchar))),''''))as [LastModifiedBy]
			from  SOP10103 with (NOLOCK)')
	ELSE
/******
Object:  View [dbo].[ScribeOnline_SalesPayment]    Script Date: 5/23/2016 4:15:30 PM 
		This view supports Online Payment Processing package which was discontinued on 1/1/2018.
		It uses table DO10103 from that package.
		The new view is above for version GP 2018 that no longer contains the 'DO10103' table.
		Both ScribeOnline_SalesPayment views need to be maintaned so that new and existing GP installations are supported.
 ******/
 	exec('CREATE VIEW [dbo].[ScribeOnline_SalesPayment] AS select        [SOP10103].[AMNTPAID] AS [PaymentAmount_Value],
       [SOP10103].[AUTHCODE] AS [AuthorizationCode],
       [SOP10103].[CARDNAME] AS [PaymentCardTypeKey_Id],
       [SOP10103].[CHEKNMBR] AS [CheckNumber],
       [SOP10103].[CURNCYID] AS [PaymentAmount_Currency],
       [SOP10103].[DELETE1] AS [DeleteOnUpdate],
       [SOP10103].[DOCDATE] AS [Date],
       [SOP10103].[SOPNUMBE] AS [Key_SalesDocumentKey_Id],
       [SOP10103].[DOCNUMBR] AS [Number],
       [SOP10103].[EXPNDATE] AS [ExpirationDate],
      ISNull([DO10103].PROCESSELECTRONICALLY, 0) AS [IsProcessElectronically],
      (CASE WHEN PYMTTYPE=1 THEN ''Cash Deposit'' WHEN PYMTTYPE=2 THEN ''Check Deposit'' WHEN PYMTTYPE=3 THEN ''Payment Card Deposit'' WHEN PYMTTYPE=4 THEN ''Cash Payment'' WHEN PYMTTYPE=5 THEN ''Check Payment'' WHEN PYMTTYPE=6 THEN ''Payment Card Payment'' ELSE '''' END ) AS [Type],
       [SOP10103].[RCTNCCRD] AS [PaymentCardNumber],
       [SOP10103].[SEQNUMBR] AS [Key_SequenceNumber],
       [SOP10103].[TRXSORCE] AS [AuditTrailCode],
       [SOP10103].[AMNTREMA] AS [AmountRemaining],
       [SOP10103].[CASHINDEX] AS [CashIndex],
       [SOP10103].[CHEKBKID] AS [CheckbookID],
       [SOP10103].[CURRNIDX] AS [CurrencyIndex],
       [SOP10103].[DEPINDEX] AS [DepositsIndex],
       [SOP10103].[DEPSTATS] AS [DepositStatus],
       [SOP10103].[EFTFLAG] AS [EFTFlag],
       [SOP10103].[GLPOSTDT] AS [GLPostingDate],
       [SOP10103].[OAMNTREM] AS [OriginatingAmountRemaining],
       [SOP10103].[OAMTPAID] AS [OriginatingAmountPaid],
       [SOP10103].[RMDTYPAL] AS [RMDocumentTypeAll],
       [SOP10103].[SOPTYPE] AS [SOPType]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
        where (EntityName=''SOP10103'' and Id=RTRIM([SOP10103].[SOPTYPE])+''|''+RTRIM([SOP10103].[SOPNUMBE])+''|''+CAST([SOP10103].[SEQNUMBR] as varchar))) as [LastModifiedDateTime],
        UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
        where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
        where EntityName=''SOP10103'' and Id=RTRIM([SOP10103].[SOPTYPE])+''|''+RTRIM([SOP10103].[SOPNUMBE])+''|''+CAST([SOP10103].[SEQNUMBR] as varchar))),''''))as [LastModifiedBy]
        from  SOP10103 with (NOLOCK) left outer join DO10103 with (NOLOCK) on (DO10103.SOPTYPE = SOP10103.SOPTYPE and DO10103.SOPNUMBE = SOP10103.SOPNUMBE AND DO10103.SEQNUMBR = SOP10103.SEQNUMBR)')

/****** Object:  View [dbo].[ScribeOnline_SalesItemWarehouseBin]    Script Date: 5/23/2016 4:15:31 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_SalesItemWarehouseBin]') IS NULL AND OBJECT_ID(N'[dbo].[IV00112]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_SalesItemWarehouseBin] AS select       ISNULL(AllocatedQuantity_Value,0) [AllocatedQuantity_Value],
      ISNULL(DamagedQuantity_Value,0) [DamagedQuantity_Value],
      ISNULL(InServiceQuantity_Value,0) [InServiceQuantity_Value],
      ISNULL(InUseQuantity_Value,0) [InUseQuantity_Value],
       [ScribeOnline_SalesItemWarehouseBinBase].[BIN] AS [Key_Bin],
       [ScribeOnline_SalesItemWarehouseBinBase].[ITEMNMBR] AS [Key_ItemWarehouseKey_ItemKey_Id],
       [ScribeOnline_SalesItemWarehouseBinBase].[LOCNCODE] AS [Key_ItemWarehouseKey_WarehouseKey_Id],
      ISNULL(OnHandQuantity_Value,0) [OnHandQuantity_Value],
      ISNULL(ReturnedQuantity_Value,0) [ReturnedQuantity_Value]
,
       (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
        where ((EntityName=''IV00112'')  and Id=RTRIM([ITEMNMBR])+''|''+RTRIM([LOCNCODE])+''|''+RTRIM([BIN]))) as [LastModifiedDateTime],
        UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
        where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
        where ((EntityName=''IV00112'')  and Id=RTRIM([ITEMNMBR])+''|''+RTRIM([LOCNCODE])+''|''+RTRIM([BIN])))),''''))as [LastModifiedBy]
        from [ScribeOnline_SalesItemWarehouseBinBase] with (NOLOCK)')

/****** Object:  View [dbo].[ScribeOnline_ItemVendor]    Script Date: 5/23/2016 4:15:31 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_ItemVendor]') IS NULL AND OBJECT_ID(N'[dbo].[IV00103]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_ItemVendor] AS select        [IV00103].[AVRGLDTM] AS [AverageLeadTime],
       [IV00103].[ECORDQTY] AS [EconomicOrderQuantity_Value],
       [IV00103].[FREEONBOARD] AS [FreeOnBoard],
       [IV00103].[ITEMNMBR] AS [Key_ItemKey_Id],
       [IV00103].[VENDORID] AS [Key_VendorKey_Id],
       [IV00103].[Last_Currency_ID] AS [LastCurrencyKey_ISOCode],
       [IV00103].[Last_Originating_Cost] AS [LastOriginatingCost_Value],
       [IV00103].[MAXORDQTY] AS [MaximumOrderQuantity_Value],
       [IV00103].[MINORQTY] AS [MinimumOrderQuantity_Value],
       [IV00103].[NORCTITM] AS [NumberOfReceipts],
       [IV00103].[ORDERMULTIPLE] AS [OrderMultipleQuantity_Value],
       [IV00103].[PLANNINGLEADTIME] AS [PlanningLeadTime],
       [IV00103].[PRCHSUOM] AS [PurchasingUofM],
       [IV00103].[QTYRQSTN] AS [RequisitionedQuantity_Value],
       [IV00103].[VNDITDSC] AS [VendorItemDescription],
       [IV00103].[VNDITNUM] AS [VendorItemNumber],
       [IV00103].[ITMVNDTY] AS [ItemVendorType],
       [IV00103].[QTYONORD] AS [QTYOnOrder],
       [IV00103].[QTY_Drop_Shipped] AS [QTYDropShipped],
       [IV00103].[LSTORDDT] AS [LastORDDate],
       [IV00103].[LSORDQTY] AS [LastORDQTY],
       [IV00103].[LRCPTQTY] AS [LastRCPTQTY],
       [IV00103].[LSRCPTDT] AS [LastRCPTDate],
       [IV00103].[LRCPTCST] AS [LastRCPTCost],
       [IV00103].[CURRNIDX] AS [CurrencyIndex],
       [IV00103].[MNFCTRITMNMBR] AS [ManufactureItemNumber]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
        where EntityName=''IV00103'' and Id=RTRIM(ITEMNMBR)+''|''+RTRIM(VENDORID)+''|''+RTRIM(ITMVNDTY)) as [LastModifiedDateTime],
        UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
        where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
        where EntityName=''IV00103'' and Id=RTRIM(ITEMNMBR)+''|''+RTRIM(VENDORID)+''|''+RTRIM(ITMVNDTY))),''''))as [LastModifiedBy]
        from IV00103 with (NOLOCK)')

/****** Object:  View [dbo].[ScribeOnline_ItemClass]    Script Date: 5/23/2016 4:15:31 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_ItemClass]') IS NULL AND OBJECT_ID(N'[dbo].[IV40400]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_ItemClass] AS select        [IV40400].[ITMCLSDC] AS [Description],
       [IV40400].[ITMCLSCD] AS [Key_Id],
       [IV40400].[ITEMTYPE] AS [Type],
       [IV40400].[DEFLTCLS] AS [DefaultClass],
       [SY03900].[TXTFIELD] AS [Notes],
       [IV40400].[ITMTRKOP] AS [ItemTrackingOption],
       [IV40400].[LOTTYPE] AS [LotType],
       [IV40400].[KPERHIST] AS [KeepPeriodHistory],
       [IV40400].[KPTRXHST] AS [KeepTrxHistory],
       [IV40400].[KPCALHST] AS [KeepCalendarHistory],
       [IV40400].[KPDSTHST] AS [KeepDistributionHistory],
       [IV40400].[ALWBKORD] AS [AllowBackOrders],
       [IV40400].[ITMGEDSC] AS [ItemGenericDescription],
       [IV40400].[TAXOPTNS] AS [TaxOptions],
       [IV40400].[ITMTSHID] AS [ItemTaxScheduleID],
       [IV40400].[Purchase_Tax_Options] AS [PurchaseTaxOptions],
       [IV40400].[Purchase_Item_Tax_Schedu] AS [PurchaseItemTaxScheduleID],
       [IV40400].[UOMSCHDL] AS [UOfMSchedule],
       [IV40400].[VCTNMTHD] AS [ValuationMethod],
       [IV40400].[USCATVLS_1] AS [UserCategoryValues1],
       [IV40400].[USCATVLS_2] AS [UserCategoryValues2],
       [IV40400].[USCATVLS_3] AS [UserCategoryValues3],
       [IV40400].[USCATVLS_4] AS [UserCategoryValues4],
       [IV40400].[USCATVLS_5] AS [UserCategoryValues5],
       [IV40400].[USCATVLS_6] AS [UserCategoryValues6],
       [IV40400].[DECPLQTY] AS [DecimalPlacesQTYS],
       [IV40400].[IVIVINDX] AS [IVIVIndex],
       [IV40400].[IVIVOFIX] AS [IVIVOffsetIndex],
       [IV40400].[IVCOGSIX] AS [IVCOGSIndex],
       [IV40400].[IVSLSIDX] AS [IVSalesIndex],
       [IV40400].[IVSLDSIX] AS [IVSalesDiscountsIndex],
       [IV40400].[IVSLRNIX] AS [IVSalesReturnsIndex],
       [IV40400].[IVINUSIX] AS [IVInUseIndex],
       [IV40400].[IVINSVIX] AS [IVInServiceIndex],
       [IV40400].[IVDMGIDX] AS [IVDamagedIndex],
       [IV40400].[IVVARIDX] AS [IVVariancesIndex],
       [IV40400].[DPSHPIDX] AS [DropShipIndex],
       [IV40400].[PURPVIDX] AS [PurchasePriceVarianceIndex],
       [IV40400].[UPPVIDX] AS [UnrealizedPurchasePriceVarianceIndex],
       [IV40400].[IVRETIDX] AS [InventoryReturnsIndex],
       [IV40400].[ASMVRIDX] AS [AssemblyVarianceIndex],
       [IV40400].[PRCLEVEL] AS [PriceLevel],
       [IV40400].[PriceGroup] AS [PriceGroup],
       [IV40400].[PRICMTHD] AS [PriceMethod],
       [IV40400].[TCC] AS [TaxCommodityCode],
       [IV40400].[Revalue_Inventory] AS [RevalueInventory],
       [IV40400].[Tolerance_Percentage] AS [TolerancePercentage],
       [IV40400].[CNTRYORGN] AS [CountryOrigin],
       [IV40400].[STTSTCLVLPRCNTG] AS [StatisticalValuePercentage],
       [IV40400].[INCLUDEINDP] AS [IncludeinDemandPlanning],
       [IV40400].[LOTEXPWARN] AS [LotExpireWarning],
       [IV40400].[LOTEXPWARNDAYS] AS [LotExpireWarningDays],
       [IV40400].[UseQtyOverageTolerance] AS [UseQtyOverageTolerance],
       [IV40400].[UseQtyShortageTolerance] AS [UseQtyShortageTolerance],
       [IV40400].[QtyOverTolerancePercent] AS [QtyOverTolerancePercent],
       [IV40400].[QtyShortTolerancePercent] AS [QtyShortTolerancePercent],
       [IV40400].[IVSCRVIX] AS [StandardCostRevaluationIndex]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
        where (EntityName=''IV40400'' and Id=RTRIM(ITMCLSCD)) or (EntityName = ''SY03900'' and Id=CAST(IV40400.NOTEINDX as varchar))) as [LastModifiedDateTime],
        UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
        where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
        where (EntityName=''IV40400'' and Id=RTRIM(ITMCLSCD)) or (EntityName = ''SY03900'' and Id=CAST(IV40400.NOTEINDX as varchar)))),''''))as [LastModifiedBy]
        from IV40400 with (NOLOCK) left outer join SY03900 with (NOLOCK) on (IV40400.NOTEINDX = SY03900.NOTEINDX)')

/****** Object:  View [dbo].[ScribeOnline_ItemCurrencyMaster]    Script Date: 5/23/2016 4:15:31 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_ItemCurrencyMaster]') IS NULL AND OBJECT_ID(N'[dbo].[IV00105]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_ItemCurrencyMaster] AS select        [IV00105].[DECPLCUR] AS [CurrencyDecimalPlaces],
      isnull((select ISOCURRC from DYNAMICS..MC40200 with (NOLOCK) where CURNCYID = IV00105.CURNCYID),(select ISOCURRC from DYNAMICS..MC40200 where CURNCYID in (select FUNLCURR from MC40000)))  [Key_CurrencyKey_ISOCode],
       [IV00105].[ITEMNMBR] AS [Key_ItemKey_Id],
       [IV00105].[LISTPRCE] AS [ListPrice_Value],
       [IV00105].[CURNCYID] AS [CurrencyID],
       [IV00105].[CURRNIDX] AS [CurrencyIndex]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
        where EntityName=''IV00105'' and Id=RTRIM(ITEMNMBR)+''|''+RTRIM(CURNCYID)) as [LastModifiedDateTime],
        UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
        where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
        where EntityName=''IV00105'' and Id=RTRIM(ITEMNMBR)+''|''+RTRIM(CURNCYID))),''''))as [LastModifiedBy]
        from IV00105 with (NOLOCK)')





/****** Object:  View [dbo].[ScribeOnline_GetNextSalesInvoiceNumber]    Script Date: 5/23/2016 4:15:32 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_GetNextSalesInvoiceNumber]') IS NULL AND OBJECT_ID(N'[dbo].[]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_GetNextSalesInvoiceNumber] AS select 	 
	from  
		')

/****** Object:  View [dbo].[ScribeOnline_GetNextSalesOrderNumber]    Script Date: 5/23/2016 4:15:32 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_GetNextSalesOrderNumber]') IS NULL AND OBJECT_ID(N'[dbo].[]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_GetNextSalesOrderNumber] AS select 	 
	from  
		')

/****** Object:  View [dbo].[ScribeOnline_SalesInvoice]    Script Date: 5/23/2016 4:15:32 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_SalesInvoice]') IS NULL AND OBJECT_ID(N'[dbo].[SOP10100]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_SalesInvoice] AS select        [SOP10100].[DEPRECVD] AS [DepositAmount_Value],
       [SOP10100].[GLPOSTDT] AS [GeneralLedgerPostingDate],
       [SOP10100].[DIRECTDEBIT] AS [IsDirectDebit],
       [SOP10100].[PYMTRCVD] AS [PaymentAmount_Value],
       [SOP10100].[PTDUSRID] AS [PostedBy],
       [SOP10100].[POSTEDDT] AS [PostedDate],
       [SOP10100].[DISTKNAM] AS [Terms_DiscountTakenAmount_Value],
       [SOP10100].[DISAVAMT] AS [Terms_DiscountAvailableAmount_Value],
       [SOP10100].[DISCDATE] AS [Terms_DiscountDate],
       [SOP10100].[DUEDATE] AS [Terms_DueDate],
       [SOP10100].[WorkflowPriorityCreditLm] AS [WorkflowPriority],
       [SOP10100].[ACTLSHIP] AS [ActualShipDate],
       [SOP10100].[BACKDATE] AS [BackorderDate],
      (CAST(DATEADD(dd, 0, DATEDIFF(dd, 0, SY00500.CREATDDT)) + '''' + DATEADD(Day, -DATEDIFF(Day, 0, SY00500.TIME1), SY00500.TIME1) as datetime))  [BatchKey_CreatedDateTime],
       [SOP10100].[BACHNUMB] AS [BatchKey_Id],
       [SOP10100].[BCHSOURC] AS [BatchKey_Source],
       [SOP10100].[PRBTADCD] AS [BillToAddressKey_Id],
       [SOP10106].[CMMTTEXT] AS [Comment],
       [SOP10100].[COMMNTID] AS [CommentKey_Id],
       [SOP10100].[COMMAMNT] AS [CommissionAmount_Value],
       [SOP10100].[COMAPPTO] AS [CommissionBasedOn],
       [SOP10100].[CMMSLAMT] AS [CommissionSaleAmount_Value],
       [SOP10100].[USER2ENT] AS [CreatedBy],
       [SOP10100].[CREATDDT] AS [CreatedDate],
       [SOP10100].[CUSTNMBR] AS [CustomerKey_Id],
       [SOP10100].[CUSTNAME] AS [CustomerName],
       [SOP10100].[CSTPONBR] AS [CustomerPONumber],
       [SOP10100].[DOCDATE] AS [Date],
       [SOP10100].[MRKDNAMT] AS [DiscountAmount_Value],
       [SOP10100].[DOCID] AS [DocumentTypeKey_Id],
       [SOP10100].[SOPTYPE] AS [DocumentTypeKey_Type],
       [SOP10100].[EXCHDATE] AS [ExchangeDate],
       [SOP10100].[XCHGRATE] AS [ExchangeRate],
       [SOP10100].[FRTAMNT] AS [FreightAmount_Value],
       [SOP10100].[FRTTXAMT] AS [FreightTaxAmount_Value],
       [SOP10100].[FRGTTXBL] AS [FreightTaxBasis],
       [SOP10100].[FRTSCHID] AS [FreightTaxScheduleKey_Id],
       [SOP10100].[FUFILDAT] AS [FulfillDate],
       [SOP10100].[INTEGRATIONID] AS [IntegrationId],
       [SOP10100].[INTEGRATIONSOURCE] AS [IntegrationSource],
       [SOP10100].[INVODATE] AS [InvoiceDate],
       [SOP10100].[VOIDSTTS] AS [IsVoided],
       [SOP10100].[SOPNUMBE] AS [Key_Id],
       [SOP10100].[SUBTOTAL] AS [LineTotalAmount_Value],
       [SOP10100].[MSTRNUMB] AS [MasterNumber],
       [SOP10100].[MISCAMNT] AS [MiscellaneousAmount_Value],
       [SOP10100].[MSCTXAMT] AS [MiscellaneousTaxAmount_Value],
       [SOP10100].[MISCTXBL] AS [MiscellaneousTaxBasis],
       [SOP10100].[MSCSCHID] AS [MiscellaneousTaxScheduleKey_Id],
       [SOP10100].[MODIFDT] AS [ModifiedDate],
       [SY03900].[TXTFIELD] AS [Note],
       [SOP10100].[ORIGNUMB] AS [OriginalSalesDocumentKey_Id],
       [SOP10100].[ORIGTYPE] AS [OriginalSalesDocumentType],
       [SOP10100].[PYMTRMID] AS [PaymentTermsKey_Id],
       [SOP10100].[PRCLEVEL] AS [PriceLevelKey_Id],
       [SOP10100].[QUOTEDAT] AS [QuoteDate],
       [SOP10100].[REFRENCE] AS [Reference],
       [SOP10100].[ReqShipDate] AS [RequestedShipDate],
       [SOP10100].[RETUDATE] AS [ReturnDate],
       [SOP10100].[SALSTERR] AS [SalesTerritoryKey_Id],
       [SOP10100].[SLPRSNID] AS [SalespersonKey_Id],
       [SOP10100].[SHIPCOMPLETE] AS [ShipCompleteOnly],
       [SOP10100].[CNTCPRSN] AS [ShipToAddress_ContactPerson],
       [SOP10100].[ShipToName] AS [ShipToAddress_Name],
       [SOP10100].[CCode] AS [ShipToAddress_CountryRegionCodeKey_Id],
       [SOP10100].[COUNTRY] AS [ShipToAddress_CountryRegion],
       [SOP10100].[CITY] AS [ShipToAddress_City],
       [SOP10100].[ADDRESS1] AS [ShipToAddress_Line1],
       [SOP10100].[ADDRESS2] AS [ShipToAddress_Line2],
       [SOP10100].[ADDRESS3] AS [ShipToAddress_Line3],
       [SOP10100].[ZIPCODE] AS [ShipToAddress_PostalCode],
       [SOP10100].[STATE] AS [ShipToAddress_State],
       [SOP10100].[PRSTADCD] AS [ShipToAddressKey_Id],
       [SOP10100].[SHIPMTHD] AS [ShippingMethodKey_Id],
       [SOP10100].[TAXAMNT] AS [TaxAmount_Value],
       [SOP10100].[TAXEXMT1] AS [TaxExemptNumber1],
       [SOP10100].[TAXEXMT2] AS [TaxExemptNumber2],
       [SOP10100].[TXRGNNUM] AS [TaxRegistrationNumber],
       [SOP10100].[TAXSCHID] AS [TaxScheduleKey_Id],
       [SOP10100].[DOCAMNT] AS [TotalAmount_Value],
       [SOP10100].[UPSZONE] AS [UPSZone],
       [SOP10106].[USRDAT01] AS [UserDefined_Date01],
       [SOP10106].[USRDAT02] AS [UserDefined_Date02],
       [SOP10106].[USRTAB01] AS [UserDefined_List01],
       [SOP10106].[USRTAB09] AS [UserDefined_List02],
       [SOP10106].[USRTAB03] AS [UserDefined_List03],
       [SOP10106].[USERDEF1] AS [UserDefined_Text01],
       [SOP10106].[USERDEF2] AS [UserDefined_Text02],
       [SOP10106].[USRDEF03] AS [UserDefined_Text03],
       [SOP10106].[USRDEF04] AS [UserDefined_Text04],
       [SOP10106].[USRDEF05] AS [UserDefined_Text05],
       [SOP10100].[LOCNCODE] AS [WarehouseKey_Id],
       [SOP10100].[QUOEXPDA] AS [QuoteExpirationDate],
       [SOP10100].[ORDRDATE] AS [OrderDate],
       [SOP10100].[REPTING] AS [Repeating],
       [SOP10100].[TRXFREQU] AS [TRXFrequency],
       [SOP10100].[TIMEREPD] AS [TimesRepeated],
       [SOP10100].[TIMETREP] AS [TimesToRepeat],
       [SOP10100].[DYSTINCR] AS [DaystoIncrement],
       [SOP10100].[DTLSTREP] AS [DateLastRepeated],
       [SOP10100].[DSTBTCH1] AS [DestBatch1],
       [SOP10100].[DSTBTCH2] AS [DestBatch2],
       [SOP10100].[USDOCID1] AS [UseDocumentID1],
       [SOP10100].[USDOCID2] AS [UseDocumentID2],
       [SOP10100].[DISCFRGT] AS [DiscountAvailableFreight],
       [SOP10100].[ORDAVFRT] AS [OriginatingDiscountAvailableFreight],
       [SOP10100].[DISCMISC] AS [DiscountAvailableMisc],
       [SOP10100].[ORDAVMSC] AS [OriginatingDiscountAvailableMisc],
       [SOP10100].[ORDAVAMT] AS [OriginatingDiscountAvailableAmount],
       [SOP10100].[DISCRTND] AS [DiscountReturned],
       [SOP10100].[ORDISRTD] AS [OriginatingDiscountReturned],
       [SOP10100].[ORDISTKN] AS [OriginatingDiscountTakenAmount],
       [SOP10100].[DSCPCTAM] AS [DiscountPercentAmount],
       [SOP10100].[DSCDLRAM] AS [DiscountDollarAmount],
       [SOP10100].[ORDDLRAT] AS [OriginatingDiscountDollarAmount],
       [SOP10100].[DISAVTKN] AS [DiscountAvailableTaken],
       [SOP10100].[ORDATKN] AS [OriginatingDiscountAvailableTaken],
       [SOP10100].[PROSPECT] AS [Prospect],
       [SOP10100].[PCKSLPNO] AS [PackingSlipNumber],
       [SOP10100].[PICTICNU] AS [PickingTicketNumber],
       [SOP10100].[ORMRKDAM] AS [OriginatingMarkdownAmount],
       [SOP10100].[PHNUMBR1] AS [PhoneNumber1],
       [SOP10100].[PHNUMBR2] AS [PhoneNumber2],
       [SOP10100].[PHONE3] AS [Phone3],
       [SOP10100].[FAXNUMBR] AS [FaxNumber],
       [SOP10100].[OCOMMAMT] AS [OriginatingCommissionAmount],
       [SOP10100].[ORCOSAMT] AS [OriginatingCommissionSalesAmount],
       [SOP10100].[NCOMAMNT] AS [Non-CommissionedAmount],
       [SOP10100].[ORNCMAMT] AS [OriginatingNon-CommissionedAmount],
       [SOP10100].[TRDISAMT] AS [TradeDiscountAmount],
       [SOP10100].[ORTDISAM] AS [OriginatingTradeDiscountAmount],
       [SOP10100].[TRDISPCT] AS [TradeDiscountPercent],
       [SOP10100].[ORSUBTOT] AS [OriginatingSubtotal],
       [SOP10100].[REMSUBTO] AS [RemainingSubtotal],
       [SOP10100].[OREMSUBT] AS [OriginatingRemainingSubtotal],
       [SOP10100].[EXTDCOST] AS [ExtendedCost],
       [SOP10100].[OREXTCST] AS [OriginatingExtendedCost],
       [SOP10100].[ORFRTAMT] AS [OriginatingFreightAmount],
       [SOP10100].[ORMISCAMT] AS [OriginatingMiscAmount],
       [SOP10100].[TXENGCLD] AS [TaxEngineCalled],
       [SOP10100].[TXSCHSRC] AS [TaxScheduleSource],
       [SOP10100].[BSIVCTTL] AS [BasedOnInvoiceTotal],
       [SOP10100].[ORFRTTAX] AS [OriginatingFreightTaxAmount],
       [SOP10100].[ORMSCTAX] AS [OriginatingMiscTaxAmount],
       [SOP10100].[BKTFRTAM] AS [BackoutFreightAmount],
       [SOP10100].[ORBKTFRT] AS [OriginatingBackoutFreightAmount],
       [SOP10100].[BKTMSCAM] AS [BackoutMiscAmount],
       [SOP10100].[ORBKTMSC] AS [OriginatingBackoutMiscAmount],
       [SOP10100].[BCKTXAMT] AS [BackoutTaxAmount],
       [SOP10100].[OBTAXAMT] AS [OriginatingBackoutTaxAmount],
       [SOP10100].[TXBTXAMT] AS [TaxableTaxAmount],
       [SOP10100].[OTAXTAMT] AS [OriginatingTaxableTaxAmount],
       [SOP10100].[ORTAXAMT] AS [OriginatingTaxAmount],
       [SOP10100].[ECTRX] AS [ECTransaction],
       [SOP10100].[ORDOCAMT] AS [OriginatingDocumentAmount],
       [SOP10100].[ORPMTRVD] AS [OriginatingPaymentReceived],
       [SOP10100].[ORDEPRVD] AS [OriginatingDepositReceived],
       [SOP10100].[CODAMNT] AS [CODAmount],
       [SOP10100].[ORCODAMT] AS [OriginatingCODAmount],
       [SOP10100].[ACCTAMNT] AS [AccountAmount],
       [SOP10100].[ORACTAMT] AS [OriginatingAccountAmount],
       [SOP10100].[TIMESPRT] AS [TimesPrinted],
       [SOP10100].[PSTGSTUS] AS [PostingStatus],
       [SOP10100].[ALLOCABY] AS [AllocateBy],
       [SOP10100].[NOTEINDX] AS [NoteIndex],
       [SOP10100].[CURRNIDX] AS [CurrencyIndex],
       [SOP10100].[RATETPID] AS [RateTypeID],
       [SOP10100].[EXGTBLID] AS [ExchangeTableID],
       [SOP10100].[DENXRATE] AS [DenominationExchangeRate],
       [SOP10100].[TIME1] AS [Time],
       [SOP10100].[RTCLCMTD] AS [RateCalculationMethod],
       [SOP10100].[MCTRXSTT] AS [MCTransactionState],
       [SOP10100].[TRXSORCE] AS [TRXSource],
       [SOP10100].[SOPHDRE1] AS [SOPHDRErrors1],
       [SOP10100].[SOPHDRE2] AS [SOPHDRErrors2],
       [SOP10100].[SOPLNERR] AS [SOPLINEErrors],
       [SOP10100].[SOPHDRFL] AS [SOPHDRFlags],
       [SOP10100].[SOPMCERR] AS [SOPMCPostingErrorMessages],
       [SOP10100].[Tax_Date] AS [TaxDate],
       [SOP10100].[APLYWITH] AS [ApplyWithholding],
       [SOP10100].[WITHHAMT] AS [WithholdingAmount],
       [SOP10100].[SHPPGDOC] AS [ShippingDocument],
       [SOP10100].[CORRCTN] AS [Correction],
       [SOP10100].[SIMPLIFD] AS [Simplified],
       [SOP10100].[CORRNXST] AS [CorrectiontoNonexistingTransaction],
       [SOP10100].[DOCNCORR] AS [DocumentNumberCorrected],
       [SOP10100].[SEQNCORR] AS [SequenceNumberCorrected],
       [SOP10100].[SALEDATE] AS [SaleDate],
       [SOP10100].[SOPHDRE3] AS [SOPHDRErrors3],
       [SOP10100].[EXCEPTIONALDEMAND] AS [ExceptionalDemand],
       [SOP10100].[Flags] AS [Flags],
       [SOP10100].[BackoutTradeDisc] AS [BackoutTradeDiscountAmount],
       [SOP10100].[OrigBackoutTradeDisc] AS [OriginatingBackoutTradeDiscountAmount],
       [SOP10100].[GPSFOINTEGRATIONID] AS [GPSFOIntegrationID],
       [SOP10100].[SOPSTATUS] AS [SOPStatus],
       [SOP10100].[WorkflowApprStatCreditLm] AS [WorkflowApprovalStatusCreditLimit],
       [SOP10100].[WorkflowApprStatusQuote] AS [WorkflowApprovalStatusQuote],
       [SOP10100].[WorkflowPriorityQuote] AS [WorkflowPriorityQuote],
       [SOP10100].[ContractExchangeRateStat] AS [ContractExchangeRateStatus]
,
            (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
            where ((EntityName=''SOP10100'' and Id=RTRIM(SOP10100.SOPNUMBE)+''|''+RTRIM(SOP10100.SOPTYPE)) or (EntityName=''SOP10106'' and Id=RTRIM(SOP10100.SOPNUMBE)+''|''+RTRIM(SOP10100.SOPTYPE))
             or (EntityName = ''SY03900'' and Id=CAST(SOP10100.NOTEINDX as varchar)))) as [LastModifiedDateTime],			 
			UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
            where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
            where ((EntityName=''SOP10100'' and Id=RTRIM(SOP10100.SOPNUMBE)+''|''+RTRIM(SOP10100.SOPTYPE)) or (EntityName=''SOP10106'' and Id=RTRIM(SOP10100.SOPNUMBE)+''|''+RTRIM(SOP10100.SOPTYPE))
			or (EntityName = ''SY03900'' and Id=CAST(SOP10100.NOTEINDX as varchar))))),'''')) as [LastModifiedBy]
            FROM SOP10100 (nolock) left outer join SOP10106 with (NOLOCK) on (SOP10100.SOPNUMBE = SOP10106.SOPNUMBE and SOP10100.SOPTYPE = SOP10106.SOPTYPE)
            left outer join SY03900 with (NOLOCK) on (SOP10100.NOTEINDX = SY03900.NOTEINDX)  
            left outer join SY00500 with (NOLOCK) on SOP10100.BACHNUMB = SY00500.BACHNUMB AND SOP10100.BCHSOURC = SY00500.BCHSOURC
            WHERE SOP10100.SOPTYPE = 3  ')

/****** Object:  View [dbo].[ScribeOnline_SalesInvoiceLine]    Script Date: 5/23/2016 4:15:33 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_SalesInvoiceLine]') IS NULL AND OBJECT_ID(N'[dbo].[SOP10200]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_SalesInvoiceLine] AS select        [SOP10200].[ACTLSHIP] AS [ActualShipDate],
       [SOP10200].[FUFILDAT] AS [FulfillDate],
       [SOP10200].[ATYALLOC] AS [QuantityAllocated_Value],
       [SOP10200].[QTYCANCE] AS [QuantityCanceled_Value],
       [SOP10200].[QTYFULFI] AS [QuantityFulfilled_Value],
       [SOP10200].[QTYTBAOR] AS [QuantityToBackorder_Value],
       [SOP10202].[CMMTTEXT] AS [Comment],
       [SOP10200].[COMMNTID] AS [CommentKey_Id],
      (SELECT [ACTNUMST] FROM [GL00105] with (NOLOCK) WHERE [GL00105].[ACTINDX] = [SOP10200].[CSLSINDX]) AS [CostOfSalesGLAccountKey_Id],
      (SELECT [ACTNUMST] FROM [GL00105] with (NOLOCK) WHERE [GL00105].[ACTINDX] = [SOP10200].[DMGDINDX]) AS [DamagedGLAccountKey_Id],
      (SELECT [ACTNUMST] FROM [GL00105] with (NOLOCK) WHERE [GL00105].[ACTINDX] = [SOP10200].[MKDNINDX]) AS [DiscountGLAccountKey_Id],
       [SOP10200].[EXTDCOST] AS [ExtendedCost_Value],
      (SELECT [ACTNUMST] FROM [GL00105] with (NOLOCK) WHERE [GL00105].[ACTINDX] = [SOP10200].[INSRINDX]) AS [InServiceGLAccountKey_Id],
      (SELECT [ACTNUMST] FROM [GL00105] with (NOLOCK) WHERE [GL00105].[ACTINDX] = [SOP10200].[INUSINDX]) AS [InUseGLAccountKey_Id],
       [SOP10200].[INTEGRATIONID] AS [IntegrationId],
       [SOP10200].[INTEGRATIONSOURCE] AS [IntegrationSource],
      (SELECT [ACTNUMST] FROM [GL00105] with (NOLOCK) WHERE [GL00105].[ACTINDX] = [SOP10200].[INVINDX]) AS [InventoryGLAccountKey_Id],
       [SOP10200].[DROPSHIP] AS [IsDropShip],
       [SOP10200].[NONINVEN] AS [IsNonInventory],
       [SOP10200].[ITEMDESC] AS [ItemDescription],
       [SOP10200].[ITEMNMBR] AS [ItemKey_Id],
       [SOP10200].[ITMTSHID] AS [ItemTaxScheduleKey_Id],
       [SOP10200].[LNITMSEQ] AS [Key_LineSequenceNumber],
       [SOP10200].[SOPNUMBE] AS [Key_SalesDocumentKey_Id],
       [SOP10200].[PRCLEVEL] AS [PriceLevelKey_Id],
       [SOP10200].[QUANTITY] AS [Quantity_Value],
       [SOP10200].[ReqShipDate] AS [RequestedShipDate],
      (SELECT [ACTNUMST] FROM [GL00105] with (NOLOCK) WHERE [GL00105].[ACTINDX] = [SOP10200].[RTNSINDX]) AS [ReturnsGLAccountKey_Id],
      (SELECT [ACTNUMST] FROM [GL00105] with (NOLOCK) WHERE [GL00105].[ACTINDX] = [SOP10200].[SLSINDX]) AS [SalesGLAccountKey_Id],
       [SOP10200].[GPSFOINTEGRATIONID] AS [FrontOfficeIntegrationId],
       [SOP10200].[SALSTERR] AS [SalesTerritoryKey_Id],
       [SOP10200].[SLPRSNID] AS [SalespersonKey_Id],
       [SOP10200].[CNTCPRSN] AS [ShipToAddress_ContactPerson],
       [SOP10200].[ShipToName] AS [ShipToAddress_Name],
       [SOP10200].[CCode] AS [ShipToAddress_CountryRegionCodeKey_Id],
       [SOP10200].[COUNTRY] AS [ShipToAddress_CountryRegion],
       [SOP10200].[CITY] AS [ShipToAddress_City],
       [SOP10200].[ADDRESS1] AS [ShipToAddress_Line1],
       [SOP10200].[ADDRESS2] AS [ShipToAddress_Line2],
       [SOP10200].[ADDRESS3] AS [ShipToAddress_Line3],
       [SOP10200].[ZIPCODE] AS [ShipToAddress_PostalCode],
       [SOP10200].[STATE] AS [ShipToAddress_State],
       [SOP10200].[PRSTADCD] AS [ShipToAddressKey_Id],
       [SOP10200].[SHIPMTHD] AS [ShippingMethodKey_Id],
       [SOP10200].[TAXAMNT] AS [TaxAmount_Value],
       [SOP10200].[IVITMTXB] AS [TaxBasis],
       [SOP10200].[TAXSCHID] AS [TaxScheduleKey_Id],
       [SOP10200].[XTNDPRCE] AS [TotalAmount_Value],
       [SOP10200].[UNITCOST] AS [UnitCost_Value],
       [SOP10200].[UNITPRCE] AS [UnitPrice_Value],
       [SOP10200].[UOFM] AS [UofM],
       [SOP10200].[LOCNCODE] AS [WarehouseKey_Id],
       [SOP10200].[BackoutTradeDisc] AS [BackoutTradeDiscountAmount],
       [SOP10200].[BKTSLSAM] AS [BackoutSalesAmount],
       [SOP10200].[BRKFLD1] AS [BreakField1],
       [SOP10200].[BRKFLD2] AS [BreakField2],
       [SOP10200].[BRKFLD3] AS [BreakField3],
       [SOP10200].[BSIVCTTL] AS [BasedOnInvoiceTotal],
       [SOP10200].[BULKPICKPRNT] AS [BulkPickPrinted],
       [SOP10200].[CMPNTSEQ] AS [ComponentSequence],
       [SOP10200].[CONTENDDTE] AS [ContractEndDate],
       [SOP10200].[CONTITEMNBR] AS [ContractItemNumber],
       [SOP10200].[CONTLNSEQNBR] AS [ContractLineSEQNumber],
       [SOP10200].[CONTNBR] AS [ContractNumber],
       [SOP10200].[CONTSERIALNBR] AS [ContractSerialNumber],
       [SOP10200].[CONTSTARTDTE] AS [ContractStartDate],
       [SOP10200].[CURRNIDX] AS [CurrencyIndex],
       [SOP10200].[DECPLCUR] AS [DecimalPlacesCurrency],
       [SOP10200].[DECPLQTY] AS [DecimalPlacesQuantities],
       [SOP10200].[DISCSALE] AS [DiscountAvailableSales],
       [SOP10200].[EXCEPTIONALDEMAND] AS [ExceptionalDemand],
       [SOP10200].[EXTQTYAL] AS [ExistingQuantityAvailable],
       [SOP10200].[EXTQTYSEL] AS [ExistingQuantitySelected],
       [SOP10200].[FAXNUMBR] AS [FaxNumber],
       [SOP10200].[Flags] AS [Flags],
       [SOP10200].[INDPICKPRNT] AS [IndividualPickPrinted],
       [SOP10200].[ISLINEINTRA] AS [IsLineIntrastat],
       [SOP10200].[ITEMCODE] AS [ItemCode],
       [SOP10200].[MRKDNAMT] AS [MarkdownAmount],
       [SOP10200].[MRKDNPCT] AS [MarkdownPercent],
       [SOP10200].[MRKDNTYP] AS [MarkdownType],
       [SOP10200].[MULTIPLEBINS] AS [MultipleBins],
       [SOP10200].[ODECPLCU] AS [OriginatingDecimalPlacesCurrency],
       [SOP10200].[ORBKTSLS] AS [OriginatingBackoutSalesAmount],
       [SOP10200].[ORDAVSLS] AS [OriginatingDiscountAvailableSales],
       [SOP10200].[OREPRICE] AS [OriginatingRemainingPrice],
       [SOP10200].[OREXTCST] AS [OriginatingExtendedCost],
       [SOP10200].[ORGSEQNM] AS [OriginalSequenceNumberCorrected],
       [SOP10200].[OrigBackoutTradeDisc] AS [OriginatingBackoutTradeDiscountAmount],
       [SOP10200].[ORMRKDAM] AS [OriginatingMarkdownAmount],
       [SOP10200].[ORTAXAMT] AS [OriginatingTaxAmount],
       [SOP10200].[ORTDISAM] AS [OriginatingTradeDiscountAmount],
       [SOP10200].[ORUNTCST] AS [OriginatingUnitCost],
       [SOP10200].[ORUNTPRC] AS [OriginatingUnitPrice],
       [SOP10200].[OTAXTAMT] AS [OriginatingTaxableTaxAmount],
       [SOP10200].[OXTNDPRC] AS [OriginatingExtendedPrice],
       [SOP10200].[PHONE1] AS [Phone1],
       [SOP10200].[PHONE2] AS [Phone2],
       [SOP10200].[PHONE3] AS [Phone3],
       [SOP10200].[PURCHSTAT] AS [PurchasingStatus],
       [SOP10200].[QTYBSUOM] AS [QuantityInBaseUOfM],
       [SOP10200].[QTYCANOT] AS [QuantityCanceledOther],
       [SOP10200].[QTYDMGED] AS [QuantityDamaged],
       [SOP10200].[QTYINSVC] AS [QuantityInService],
       [SOP10200].[QTYINUSE] AS [QuantityInUse],
       [SOP10200].[QTYONHND] AS [QuantityOnHand],
       [SOP10200].[QTYONPO] AS [QuantityOnPO],
       [SOP10200].[QTYORDER] AS [QuantityOrdered],
       [SOP10200].[QTYPRBAC] AS [QuantityPrevBackOrdered],
       [SOP10200].[QTYPRBOO] AS [QuantityPrevBOOnOrder],
       [SOP10200].[QTYPRINV] AS [QuantityPrevInvoiced],
       [SOP10200].[QTYPRORD] AS [QuantityPrevOrdered],
       [SOP10200].[QTYPRVRECVD] AS [QuantityPrevReceived],
       [SOP10200].[QTYRECVD] AS [QuantityReceived],
       [SOP10200].[QTYREMAI] AS [QuantityRemaining],
       [SOP10200].[QTYREMBO] AS [QuantityRemainingOnBO],
       [SOP10200].[QTYRTRND] AS [QuantityReturned],
       [SOP10200].[QTYSLCTD] AS [QuantitySelected],
       [SOP10200].[QTYTORDR] AS [QuantityToOrder],
       [SOP10200].[QTYTOSHP] AS [QuantityToShip],
       [SOP10200].[REMPRICE] AS [RemainingPrice],
       [SOP10200].[SOFULFILLMENTBIN] AS [SOFulfillmentBin],
       [SOP10200].[SOPLNERR] AS [SOPLINEErrors],
       [SOP10200].[TRDISAMT] AS [TradeDiscountAmount],
       [SOP10200].[TRXSORCE] AS [TRXSource],
       [SOP10200].[TXBTXAMT] AS [TaxableTaxAmount],
       [SOP10200].[TXSCHSRC] AS [TaxScheduleSource],
       [SOP10200].[XFRSHDOC] AS [TransferredToShippingDocument],
       [SOP10200].[Print_Phone_NumberGB] AS [PrintPhoneNumberGB]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
         where ((EntityName=''SOP10200'' and Id=RTRIM(SOP10200.SOPNUMBE)+''|''+RTRIM(SOP10200.SOPTYPE)+''|''+RTRIM(SOP10200.CMPNTSEQ)+''|''+RTRIM(SOP10200.LNITMSEQ)) or (EntityName=''SOP10202'' and Id=RTRIM(SOP10202.SOPNUMBE)+''|''+RTRIM(SOP10202.SOPTYPE)+''|''+RTRIM(SOP10202.CMPNTSEQ)+''|''+RTRIM(SOP10202.LNITMSEQ)))) as [LastModifiedDateTime],
         UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
         where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
         where ((EntityName=''SOP10200'' and Id=RTRIM(SOP10200.SOPNUMBE)+''|''+RTRIM(SOP10200.SOPTYPE)+''|''+RTRIM(SOP10200.CMPNTSEQ)+''|''+RTRIM(SOP10200.LNITMSEQ)) or (EntityName=''SOP10202'' and Id=RTRIM(SOP10202.SOPNUMBE)+''|''+RTRIM(SOP10202.SOPTYPE)+''|''+RTRIM(SOP10202.CMPNTSEQ)+''|''+RTRIM(SOP10202.LNITMSEQ))))),'''')) as [LastModifiedBy]
         FROM SOP10200 with (NOLOCK) left outer join SOP10202 with (NOLOCK) on (SOP10200.SOPTYPE = SOP10202.SOPTYPE and SOP10200.SOPNUMBE = SOP10202.SOPNUMBE and SOP10200.LNITMSEQ = SOP10202.LNITMSEQ and SOP10200.CMPNTSEQ = SOP10202.CMPNTSEQ)
         WHERE SOP10200.SOPTYPE = 3 ')

/****** Object:  View [dbo].[ScribeOnline_GLPostingAccount]    Script Date: 5/23/2016 4:15:34 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_GLPostingAccount]') IS NULL AND OBJECT_ID(N'[dbo].[GL00100]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_GLPostingAccount] AS select        [GL00100].[ACTINDX] AS [AccountIndex],
       [GL00105].[ACTNUMST] AS [Key_Id],
       [GL00102].[ACCATDSC] AS [GLAccountCategoryKey_Id],
       [GL00100].[ACCTENTR] AS [AllowAccountEntry],
       [GL00100].[PSTNGTYP] AS [PostingType],
       [GL00100].[TPCLBLNC] AS [TypicalBalance],
       [GL00100].[USERDEF1] AS [UserDefined1],
       [GL00100].[USERDEF2] AS [UserDefined2],
       [GL00100].[USRDEFS1] AS [UserDefined3],
       [GL00100].[USRDEFS2] AS [UserDefined4],
       [GL00100].[PostIvIn] AS [PostInventoryIn],
       [GL00100].[PostPRIn] AS [PostPayrollIn],
       [GL00100].[PostPurchIn] AS [PostPurchasingIn],
       [GL00100].[PostSlsIn] AS [PostSalesIn],
       [GL00100].[ACTALIAS] AS [Alias],
       [GL00100].[CREATDDT] AS [CreatedDate],
       [GL00100].[ACTDESCR] AS [Description],
       [GL00100].[ACTIVE] AS [IsActive],
       [GL00100].[MODIFDT] AS [ModifiedDate],
       [GL00100].[ACTNUMBR_1] AS [AccountNumberAccountSegmentPool1],
       [GL00100].[ACTNUMBR_2] AS [AccountNumberAccountSegmentPool2],
       [GL00100].[ACTNUMBR_3] AS [AccountNumberAccountSegmentPool3],
      [AccountNumberAccountSegmentPool4] = ( SELECT ( SELECT ACTNUMBR_4 
                  FROM GL00100 AS g2 with (NOLOCK) 
                  WHERE g2.ACTINDX = GL00100.ACTINDX
                ) AS ACTNUMBR_4 
         FROM (SELECT '''' AS ACTNUMBR_4 ) AS dummy
       ),
      [AccountNumberAccountSegmentPool5] = ( SELECT ( SELECT ACTNUMBR_5 
                  FROM GL00100 AS g2 with (NOLOCK) 
                  WHERE g2.ACTINDX = GL00100.ACTINDX
                ) AS ACTNUMBR_5 
         FROM (SELECT '''' AS ACTNUMBR_5 ) AS dummy
       ),
       [GL00100].[MNACSGMT] AS [MainAccountSegment],
       [GL00100].[DECPLACS] AS [DecimalPlaces],
       [GL00100].[FXDORVAR] AS [FixedOrVariable],
       [GL00100].[BALFRCLC] AS [BalanceForCalculation],
       [GL00100].[CNVRMTHD] AS [ConversionMethod],
       [GL00100].[HSTRCLRT] AS [HistoricalRate],
       [SY03900].[TXTFIELD] AS [Notes],
       [GL00100].[ADJINFL] AS [AdjustforInflation],
       [GL00100].[INFLAREV] AS [InflationRevenueAccountIndex],
       [GL00100].[INFLAEQU] AS [InflationEquityAccountIndex],
       [GL00100].[ACCATNUM] AS [AccountCategoryNumber]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
         where ((EntityName=''GL00100'' and Id=RTRIM(GL00100.ACTINDX)) or (EntityName=''GL00105'' and Id=RTRIM(GL00105.ACTINDX)) or (EntityName=''GL00102'' and Id=RTRIM(GL00102.ACCATNUM))or (EntityName = ''SY03900'' and Id=CAST(GL00100.NOTEINDX as varchar)))) as [LastModifiedDateTime],
         UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
         where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
         where ((EntityName=''GL00100'' and Id=RTRIM(GL00100.ACTINDX)) or (EntityName=''GL00105'' and Id=RTRIM(GL00105.ACTINDX)) or (EntityName=''GL00102'' and Id=RTRIM(GL00102.ACCATNUM))or (EntityName = ''SY03900'' and Id=CAST(GL00100.NOTEINDX as varchar))))),'''')) as [LastModifiedBy]
         FROM GL00100 (NOLOCK)
         INNER JOIN GL00105 (NOLOCK) ON GL00105.ACTINDX=GL00100.ACTINDX
         LEFT JOIN GL00102 (NOLOCK) ON GL00102.ACCATNUM=GL00100.ACCATNUM
         left outer join SY03900 with (NOLOCK) on (GL00100.NOTEINDX = SY03900.NOTEINDX)
         WHERE GL00100.ACCTTYPE = 1
         ')

/****** Object:  View [dbo].[ScribeOnline_GLUnitAccount]    Script Date: 5/23/2016 4:15:34 PM ******/

IF OBJECT_ID(N'[dbo].[ScribeOnline_GLUnitAccount]') IS NULL AND OBJECT_ID(N'[dbo].[GL00100]') IS NOT NULL
	exec('CREATE VIEW [dbo].[ScribeOnline_GLUnitAccount] AS select        [GL00100].[ACTALIAS] AS [Alias],
       [GL00100].[CREATDDT] AS [CreatedDate],
       [GL00100].[ACTDESCR] AS [Description],
       [GL00100].[ACTIVE] AS [IsActive],
       [GL00105].[ACTNUMST] AS [Key_Id],
       [GL00100].[MODIFDT] AS [ModifiedDate],
       [GL00100].[ACTINDX] AS [AccountIndex],
       [GL00100].[ACTNUMBR_1] AS [AccountNumberAccountSegmentPool1],
       [GL00100].[ACTNUMBR_2] AS [AccountNumberAccountSegmentPool2],
       [GL00100].[ACTNUMBR_3] AS [AccountNumberAccountSegmentPool3],
      [AccountNumberAccountSegmentPool4] = ( SELECT ( SELECT ACTNUMBR_4 
                  FROM GL00100 AS g2 with (NOLOCK) 
                  WHERE g2.ACTINDX = GL00100.ACTINDX
                ) AS ACTNUMBR_4 
         FROM (SELECT '''' AS ACTNUMBR_4 ) AS dummy
       ),
      [AccountNumberAccountSegmentPool5] = ( SELECT ( SELECT ACTNUMBR_5 
                  FROM GL00100 AS g2 with (NOLOCK) 
                  WHERE g2.ACTINDX = GL00100.ACTINDX
                ) AS ACTNUMBR_5 
         FROM (SELECT '''' AS ACTNUMBR_5 ) AS dummy
       ),
       [GL00100].[MNACSGMT] AS [MainAccountSegment],
       [GL00100].[DECPLACS] AS [DecimalPlaces],
       [GL00100].[FXDORVAR] AS [FixedOrVariable],
       [GL00100].[BALFRCLC] AS [BalanceForCalculation],
       [GL00100].[CNVRMTHD] AS [ConversionMethod],
       [GL00100].[HSTRCLRT] AS [HistoricalRate],
       [SY03900].[TXTFIELD] AS [Notes],
       [GL00100].[ADJINFL] AS [AdjustforInflation],
       [GL00100].[INFLAREV] AS [InflationRevenueAccountIndex],
       [GL00100].[INFLAEQU] AS [InflationEquityAccountIndex],
       [GL00100].[Clear_Balance] AS [ClearBalanceAtYearEndClose]
,
        (select Top 1 ISNULL(Max(LastModifiedDateTime),''1/1/1900'') from ScribeNetChange with (NOLOCK) 
         where ((EntityName=''GL00100'' and Id=RTRIM(GL00100.ACTINDX)) or (EntityName=''GL00105'' and Id=RTRIM(GL00105.ACTINDX)) or (EntityName=''GL00102'' and Id=RTRIM(GL00102.ACCATNUM))or (EntityName = ''SY03900'' and Id=CAST(GL00100.NOTEINDX as varchar)))) as [LastModifiedDateTime],
         UPPER(ISNULL((select Top 1 LastModifiedBy from ScribeNetChange with (NOLOCK) 
         where LastModifiedDateTime = (select Max(LastModifiedDateTime) from ScribeNetChange with (NOLOCK) 
         where ((EntityName=''GL00100'' and Id=RTRIM(GL00100.ACTINDX)) or (EntityName=''GL00105'' and Id=RTRIM(GL00105.ACTINDX)) or (EntityName=''GL00102'' and Id=RTRIM(GL00102.ACCATNUM))or (EntityName = ''SY03900'' and Id=CAST(GL00100.NOTEINDX as varchar))))),'''')) as [LastModifiedBy]
         FROM GL00100 (NOLOCK)
         INNER JOIN GL00105 (NOLOCK) ON GL00105.ACTINDX=GL00100.ACTINDX
         LEFT JOIN GL00102 (NOLOCK) ON GL00102.ACCATNUM=GL00100.ACCATNUM
         left outer join SY03900 with (NOLOCK) on (GL00100.NOTEINDX = SY03900.NOTEINDX)
         WHERE GL00100.ACCTTYPE = 2
         ')
    /****** Object:  Trigger [Scribe_createupdateRM00101]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateRM00101]') IS NULL AND OBJECT_ID(N'[dbo].[RM00101]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateRM00101 ON RM00101 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT CUSTNMBR FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''RM00101'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''RM00101'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''RM00101'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateSY03900]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateSY03900]') IS NULL AND OBJECT_ID(N'[dbo].[SY03900]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateSY03900 ON SY03900 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT NOTEINDX FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''SY03900'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''SY03900'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''SY03900'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateRM00102]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateRM00102]') IS NULL AND OBJECT_ID(N'[dbo].[RM00102]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateRM00102 ON RM00102 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(CUSTNMBR)+''|''+RTRIM(ADRSCODE) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''RM00102'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''RM00102'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''RM00102'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateSY01200]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateSY01200]') IS NULL AND OBJECT_ID(N'[dbo].[SY01200]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateSY01200 ON SY01200 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(Master_ID)+''|''+RTRIM(ADRSCODE)+''|''+RTRIM(Master_Type) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''SY01200'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''SY01200'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''SY01200'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateSOP10100]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateSOP10100]') IS NULL AND OBJECT_ID(N'[dbo].[SOP10100]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateSOP10100 ON SOP10100 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(SOPNUMBE)+''|''+RTRIM(SOPTYPE) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''SOP10100'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''SOP10100'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''SOP10100'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateSOP10106]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateSOP10106]') IS NULL AND OBJECT_ID(N'[dbo].[SOP10106]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateSOP10106 ON SOP10106 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(SOPNUMBE)+''|''+RTRIM(SOPTYPE) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''SOP10106'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''SOP10106'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''SOP10106'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateSOP10103]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateSOP10103]') IS NULL AND OBJECT_ID(N'[dbo].[SOP10103]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateSOP10103 ON SOP10103 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(SOPTYPE)+''|''+RTRIM(SOPNUMBE)+''|''+CAST(SEQNUMBR as varchar) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''SOP10103'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''SOP10103'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''SOP10103'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateSOP10200]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateSOP10200]') IS NULL AND OBJECT_ID(N'[dbo].[SOP10200]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateSOP10200 ON SOP10200 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(SOPNUMBE)+''|''+RTRIM(SOPTYPE)+''|''+RTRIM([CMPNTSEQ])+''|''+RTRIM([LNITMSEQ]) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''SOP10200'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''SOP10200'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''SOP10200'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateSOP10202]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateSOP10202]') IS NULL AND OBJECT_ID(N'[dbo].[SOP10202]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateSOP10202 ON SOP10202 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(SOPNUMBE)+''|''+RTRIM(SOPTYPE)+''|''+RTRIM([CMPNTSEQ])+''|''+RTRIM([LNITMSEQ]) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''SOP10202'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''SOP10202'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''SOP10202'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateIV40800]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateIV40800]') IS NULL AND OBJECT_ID(N'[dbo].[IV40800]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateIV40800 ON IV40800 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(PRCLEVEL) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''IV40800'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''IV40800'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''IV40800'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateIV00105]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateIV00105]') IS NULL AND OBJECT_ID(N'[dbo].[IV00105]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateIV00105 ON IV00105 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(ITEMNMBR)+''|''+RTRIM(CURNCYID) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''IV00105'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''IV00105'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''IV00105'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateIV00108]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateIV00108]') IS NULL AND OBJECT_ID(N'[dbo].[IV00108]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateIV00108 ON IV00108 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(ITEMNMBR)+''|''+RTRIM(CURNCYID)+''|''+RTRIM(PRCLEVEL)+''|''+RTRIM(UOFM)+''|''+RTRIM(TOQTY) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''IV00108'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''IV00108'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''IV00108'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateIV00107]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateIV00107]') IS NULL AND OBJECT_ID(N'[dbo].[IV00107]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateIV00107 ON IV00107 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(ITEMNMBR)+''|''+RTRIM(CURNCYID)+''|''+RTRIM(PRCLEVEL)+''|''+RTRIM(UOFM) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''IV00107'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''IV00107'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''IV00107'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateIV00101]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateIV00101]') IS NULL AND OBJECT_ID(N'[dbo].[IV00101]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateIV00101 ON IV00101 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(ITEMNMBR) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''IV00101'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''IV00101'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''IV00101'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateIV40201]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateIV40201]') IS NULL AND OBJECT_ID(N'[dbo].[IV40201]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateIV40201 ON IV40201 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(UOMSCHDL) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''IV40201'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''IV40201'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''IV40201'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateIV40202]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateIV40202]') IS NULL AND OBJECT_ID(N'[dbo].[IV40202]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateIV40202 ON IV40202 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM([UOMSCHDL])+''|''+RTRIM([SEQNUMBR]) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''IV40202'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''IV40202'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''IV40202'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateSOP30300]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateSOP30300]') IS NULL AND OBJECT_ID(N'[dbo].[SOP30300]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateSOP30300 ON SOP30300 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM([SOPNUMBE])+''|''+RTRIM([SOPTYPE])+''|''+RTRIM([CMPNTSEQ])+''|''+RTRIM([LNITMSEQ]) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''SOP30300'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''SOP30300'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''SOP30300'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateSOP30200]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateSOP30200]') IS NULL AND OBJECT_ID(N'[dbo].[SOP30200]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateSOP30200 ON SOP30200 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(SOPNUMBE)+''|''+RTRIM(SOPTYPE) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''SOP30200'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''SOP30200'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''SOP30200'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateGL00100]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateGL00100]') IS NULL AND OBJECT_ID(N'[dbo].[GL00100]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateGL00100 ON GL00100 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(ACTINDX) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''GL00100'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''GL00100'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''GL00100'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateGL00102]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateGL00102]') IS NULL AND OBJECT_ID(N'[dbo].[GL00102]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateGL00102 ON GL00102 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(ACCATNUM) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''GL00102'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''GL00102'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''GL00102'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateGL00105]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateGL00105]') IS NULL AND OBJECT_ID(N'[dbo].[GL00105]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateGL00105 ON GL00105 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(ACTINDX) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''GL00105'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''GL00105'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''GL00105'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdatePM10000]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdatePM10000]') IS NULL AND OBJECT_ID(N'[dbo].[PM10000]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdatePM10000 ON PM10000 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(VCHNUMWK)+''|''+RTRIM(DOCTYPE) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''PM10000'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''PM10000'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''PM10000'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdatePM20000]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdatePM20000]') IS NULL AND OBJECT_ID(N'[dbo].[PM20000]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdatePM20000 ON PM20000 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(VCHRNMBR)+''|''+RTRIM(DOCTYPE) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''PM20000'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''PM20000'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''PM20000'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdatePM30200]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdatePM30200]') IS NULL AND OBJECT_ID(N'[dbo].[PM30200]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdatePM30200 ON PM30200 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(VCHRNMBR)+''|''+RTRIM(DOCTYPE) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''PM30200'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''PM30200'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''PM30200'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateGL10000]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateGL10000]') IS NULL AND OBJECT_ID(N'[dbo].[GL10000]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateGL10000 ON GL10000 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(BACHNUMB)+''|''+RTRIM(BCHSOURC)+''|''+RTRIM(JRNENTRY) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''GL10000'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''GL10000'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''GL10000'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateGL10001]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateGL10001]') IS NULL AND OBJECT_ID(N'[dbo].[GL10001]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateGL10001 ON GL10001 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(JRNENTRY)+''|''+RTRIM(CAST(SQNCLINE as int)) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''GL10001'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''GL10001'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''GL10001'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateGL20000]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateGL20000]') IS NULL AND OBJECT_ID(N'[dbo].[GL20000]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateGL20000 ON GL20000 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(DEX_ROW_ID) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''GL20000'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''GL20000'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''GL20000'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateGL30000]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateGL30000]') IS NULL AND OBJECT_ID(N'[dbo].[GL30000]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateGL30000 ON GL30000 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(DEX_ROW_ID) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''GL30000'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''GL30000'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''GL30000'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateRM10301]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateRM10301]') IS NULL AND OBJECT_ID(N'[dbo].[RM10301]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateRM10301 ON RM10301 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(RMDTYPAL)+''|''+RTRIM(RMDNUMWK)+''|''+RTRIM(CUSTNMBR) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''RM10301'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''RM10301'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''RM10301'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateRM20101]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateRM20101]') IS NULL AND OBJECT_ID(N'[dbo].[RM20101]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateRM20101 ON RM20101 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(RMDTYPAL)+''|''+RTRIM(DOCNUMBR)+''|''+RTRIM(CUSTNMBR) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''RM20101'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''RM20101'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''RM20101'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateRM30101]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateRM30101]') IS NULL AND OBJECT_ID(N'[dbo].[RM30101]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateRM30101 ON RM30101 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(RMDTYPAL)+''|''+RTRIM(DOCNUMBR)+''|''+RTRIM(CUSTNMBR) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''RM30101'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''RM30101'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''RM30101'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdatePM00200]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdatePM00200]') IS NULL AND OBJECT_ID(N'[dbo].[PM00200]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdatePM00200 ON PM00200 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(VENDORID) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''PM00200'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''PM00200'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''PM00200'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdatePA00901]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdatePA00901]') IS NULL AND OBJECT_ID(N'[dbo].[PA00901]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdatePA00901 ON PA00901 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(VENDORID) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''PA00901'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''PA00901'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''PA00901'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdatePM00300]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdatePM00300]') IS NULL AND OBJECT_ID(N'[dbo].[PM00300]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdatePM00300 ON PM00300 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(VENDORID)+''|''+RTRIM(ADRSCODE) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''PM00300'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''PM00300'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''PM00300'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateRM10101]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateRM10101]') IS NULL AND OBJECT_ID(N'[dbo].[RM10101]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateRM10101 ON RM10101 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(PSTGSTUS)+''|''+RTRIM(DOCNUMBR)+''|''+RTRIM(RMDTYPAL)+''|''+RTRIM(SEQNUMBR)+''|''+RTRIM(USERID) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''RM10101'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''RM10101'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''RM10101'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateRM30301]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateRM30301]') IS NULL AND OBJECT_ID(N'[dbo].[RM30301]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateRM30301 ON RM30301 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(DOCNUMBR)+''|''+RTRIM(RMDTYPAL)+''|''+RTRIM(SEQNUMBR) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''RM30301'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''RM30301'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''RM30301'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdatePM10100]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdatePM10100]') IS NULL AND OBJECT_ID(N'[dbo].[PM10100]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdatePM10100 ON PM10100 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(VCHRNMBR)+''|''+RTRIM(DSTSQNUM)+''|''+RTRIM(CNTRLTYP)+''|''+RTRIM(APTVCHNM)+''|''+RTRIM(SPCLDIST) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''PM10100'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''PM10100'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''PM10100'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdatePM30600]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdatePM30600]') IS NULL AND OBJECT_ID(N'[dbo].[PM30600]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdatePM30600 ON PM30600 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(VCHRNMBR)+''|''+RTRIM(DSTSQNUM)+''|''+RTRIM(CNTRLTYP)+''|''+RTRIM(APTVCHNM)+''|''+RTRIM(SPCLDIST) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''PM30600'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''PM30600'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''PM30600'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateRM10601]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateRM10601]') IS NULL AND OBJECT_ID(N'[dbo].[RM10601]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateRM10601 ON RM10601 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM([RMDTYPAL])+''|''+RTRIM([TAXDTLID])+''|''+RTRIM([DOCNUMBR])+''|''+RTRIM([TRXSORCE]) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''RM10601'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''RM10601'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''RM10601'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateRM30601]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateRM30601]') IS NULL AND OBJECT_ID(N'[dbo].[RM30601]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateRM30601 ON RM30601 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM([RMDTYPAL])+''|''+RTRIM([TAXDTLID])+''|''+RTRIM([DOCNUMBR])+''|''+RTRIM([TRXSORCE]) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''RM30601'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''RM30601'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''RM30601'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdatePM10500]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdatePM10500]') IS NULL AND OBJECT_ID(N'[dbo].[PM10500]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdatePM10500 ON PM10500 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM([VCHRNMBR])+''|''+RTRIM([TAXDTLID])+''|''+RTRIM([ACTINDX])+''|''+RTRIM([TRXSORCE]) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''PM10500'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''PM10500'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''PM10500'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdatePM30700]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdatePM30700]') IS NULL AND OBJECT_ID(N'[dbo].[PM30700]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdatePM30700 ON PM30700 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM([DEX_ROW_ID])+''|''+RTRIM([TAXDTLID])+''|''+RTRIM([ACTINDX])+''|''+RTRIM([TRXSORCE]) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''PM30700'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''PM30700'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''PM30700'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateIV00102]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateIV00102]') IS NULL AND OBJECT_ID(N'[dbo].[IV00102]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateIV00102 ON IV00102 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM([ITEMNMBR])+''|''+RTRIM([LOCNCODE])+''|''+RTRIM([RCRDTYPE]) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''IV00102'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''IV00102'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''IV00102'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateIV00112]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateIV00112]') IS NULL AND OBJECT_ID(N'[dbo].[IV00112]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateIV00112 ON IV00112 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM([ITEMNMBR])+''|''+RTRIM([LOCNCODE])+''|''+RTRIM([BIN]) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''IV00112'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''IV00112'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''IV00112'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateIV00103]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateIV00103]') IS NULL AND OBJECT_ID(N'[dbo].[IV00103]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateIV00103 ON IV00103 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(ITEMNMBR)+''|''+RTRIM(VENDORID)+''|''+RTRIM(ITMVNDTY) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''IV00103'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''IV00103'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''IV00103'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')

    /****** Object:  Trigger [Scribe_createupdateIV40400]    Script Date: 8/5/2013 2:46:34 PM ******/

    IF OBJECT_ID(N'[dbo].[Scribe_createupdateIV40400]') IS NULL AND OBJECT_ID(N'[dbo].[IV40400]') IS NOT NULL
	exec(' CREATE TRIGGER dbo.Scribe_createupdateIV40400 ON IV40400 AFTER INSERT, UPDATE AS

 Declare @ModifiedDateTime datetime;
 Declare @Id varchar(100);
 Declare @lastModifiedDateTime datetime;
 Declare @createdby varchar(100)

IF TRIGGER_NESTLEVEL() > 1 
RETURN

SET NOCOUNT ON;

DECLARE netchange_cursor CURSOR FOR 
SELECT RTRIM(ITMCLSCD) FROM inserted

OPEN netchange_cursor

FETCH NEXT FROM netchange_cursor INTO @Id

WHILE @@Fetch_Status = 0
BEGIN
   

    set @ModifiedDateTime = GETUTCDATE();
    set @createdby = (select SYSTEM_USER)

    if @Id IS NOT NULL
    BEGIN

        set @lastModifiedDateTime = (select LastModifiedDateTime from dbo.ScribeNetChange where Id = @Id and EntityName=''IV40400'')

        if @lastModifiedDateTime IS null  
	    Insert into dbo.ScribeNetChange values(''IV40400'',@Id,@ModifiedDateTime,@createdby,@ModifiedDateTime)	  
        else	
	    Update dbo.ScribeNetChange set LastModifiedDateTime = @ModifiedDateTime, LastModifiedBy=@createdby where EntityName=''IV40400'' and Id = @Id
    END

    FETCH NEXT FROM netchange_cursor INTO @Id
    
END
CLOSE netchange_cursor
DEALLOCATE netchange_cursor

')
