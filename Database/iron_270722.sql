USE [KUN_QLBH]
GO
/****** Object:  UserDefinedTableType [dbo].[TBL_INVOICE_DETAIL]    Script Date: 7/27/2022 11:07:34 AM ******/
CREATE TYPE [dbo].[TBL_INVOICE_DETAIL] AS TABLE(
	[ProductId] [uniqueidentifier] NULL,
	[ProductQuantity] [int] NULL,
	[SalePrice] [money] NULL
)
GO
/****** Object:  UserDefinedFunction [dbo].[fn_Clear_VN]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_Clear_VN]
(
	@InputStr NVARCHAR(max)
)
RETURNS NVARCHAR(max)
BEGIN
	DECLARE @NewStr NVARCHAR(MAX)
	SELECT @NewStr = LOWER(@InputStr)
	--SELECT @NewStr = REPLACE(@NewStr, N'[à]á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ]', 'a')
	SELECT @NewStr = REPLACE(@NewStr, N'[à][á]', 'a')
	RETURN @NewStr
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_Create_WareCode]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_Create_WareCode](
	@WareName NVARCHAR(250)
)
RETURNS NCHAR(4)
AS
BEGIN
	DECLARE @Code NCHAR(3)
	DECLARE @NewCode NCHAR(4)

	SELECT @Code = (SELECT CONCAT((SELECT UPPER(LEFT(Name, 1)) FROM fn_String_Split(@WareName) WHERE [Index] = 1),
										 (SELECT UPPER(LEFT(Name, 1)) FROM fn_String_Split(@WareName) WHERE [Index] = 2),
										  (SELECT UPPER(LEFT(Name, 1)) FROM fn_String_Split(@WareName) WHERE [Index] = 3)))
	SELECT @NewCode = @Code
	DECLARE @Index TINYINT
	IF EXISTS (SELECT 1 FROM dbo.tblWare WHERE WareCode = @Code)
	BEGIN
		SELECT @Index = (SELECT COUNT(1) FROM tblWare WHERE WareCode LIKE @Code + '%')
		SELECT @NewCode = (SELECT CONCAT(@Code, CAST(@Index AS NCHAR(1))))
	END	 
	
	RETURN @NewCode
END	


--SELECT dbo.fn_Create_WareCode('Ly yhựa mn nhãn Iron size M không nắp')



GO
/****** Object:  UserDefinedFunction [dbo].[fn_String_Split]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_String_Split] ( @stringToSplit VARCHAR(MAX) )
RETURNS
 @returnList TABLE (
 [Name] [varchar] (500),
 [Index] INT
 )
AS
BEGIN

 DECLARE @name VARCHAR(255)
 DECLARE @pos INT
 DECLARE @idx INT = 0

 WHILE CHARINDEX(' ', @stringToSplit) > 0
 BEGIN
  SELECT @pos  = CHARINDEX(' ', @stringToSplit)  
  SELECT @name = (SELECT CAST(SUBSTRING(@stringToSplit, 1, @pos-1) AS VARCHAR(MAX)) collate Latin1_General_CS_AS)
  SET @idx = @idx + 1

  INSERT INTO @returnList 
  SELECT @name, @idx

  SELECT @stringToSplit = SUBSTRING(@stringToSplit, @pos+1, LEN(@stringToSplit)-@pos)
 END

 INSERT INTO @returnList
 SELECT @stringToSplit, @idx +1

 RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_Time_Left]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_Time_Left]
(
	@InputDate DATETIME
)
RETURNS NVARCHAR(100)
AS
BEGIN
	DECLARE @TimeLeft NVARCHAR(100)
	
	DECLARE @Minute INT
	SELECT @Minute = DATEDIFF(MINUTE, @InputDate, GETDATE())
	
	SELECT @TimeLeft = 
	CASE
		WHEN @Minute <= 0 THEN N'vừa xong'
		WHEN @Minute < 60 THEN CAST(@Minute AS NVARCHAR(10)) + N' phút trước' 
		WHEN @Minute > 60 AND @Minute < 1440 THEN CAST((@Minute / 60 ) AS NVARCHAR(10)) + N' giờ ' + CAST((@Minute % 60 ) AS NVARCHAR(10)) + N' phút trước'
		WHEN @Minute > 1440 THEN CAST((@Minute / 1440 ) AS NVARCHAR(10)) + N' ngày ' + CAST(((@Minute % 1440) /60) AS NVARCHAR(10)) + N' giờ trước'
	END

	RETURN @TimeLeft
END





GO
/****** Object:  Table [dbo].[tblActLog]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblActLog](
	[ActLogId] [uniqueidentifier] NOT NULL CONSTRAINT [DF_tblActLog_ActLogId]  DEFAULT (newsequentialid()),
	[ActLogName] [nvarchar](500) NULL,
	[ActLogCode] [tinyint] NULL,
	[RelateId] [uniqueidentifier] NULL,
	[RelateCode] [tinyint] NULL,
	[CreateUser] [uniqueidentifier] NULL,
	[CreateDate] [datetime] NULL CONSTRAINT [DF_tblActLog_CreateDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_tblActLog] PRIMARY KEY CLUSTERED 
(
	[ActLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblConfig]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblConfig](
	[LogoPath] [nvarchar](500) NULL,
	[StoreName] [nvarchar](500) NULL,
	[StoreAddress] [nvarchar](500) NULL,
	[StorePhone] [nvarchar](250) NULL,
	[WifiInfo] [nvarchar](500) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblCustomer]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCustomer](
	[CustomerId] [uniqueidentifier] NOT NULL,
	[CustomerName] [nvarchar](250) NULL,
	[Phone] [nvarchar](50) NULL,
	[Email] [nvarchar](50) NULL,
	[Address] [nvarchar](250) NULL,
	[CustomerStatus] [tinyint] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [uniqueidentifier] NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUser] [uniqueidentifier] NULL,
 CONSTRAINT [PK_tblCustomer] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblInvoice]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblInvoice](
	[InvoiceId] [uniqueidentifier] NOT NULL CONSTRAINT [DF_tblInvoice_InvoiceId]  DEFAULT (newsequentialid()),
	[CustomerId] [uniqueidentifier] NULL,
	[InvoiceCode] [nvarchar](10) NULL,
	[TotalPrice] [money] NULL,
	[SaleValue] [money] NULL,
	[SaleType] [tinyint] NULL,
	[OtherFeeValue] [money] NULL,
	[OtherFeeDescription] [nvarchar](500) NULL,
	[InvoiceValue] [money] NULL,
	[InvoiceNote] [nvarchar](500) NULL,
	[InvoiceStatus] [tinyint] NULL CONSTRAINT [DF_tblInvoice_InvoiceStatus]  DEFAULT ((1)),
	[CreateDate] [datetime] NULL CONSTRAINT [DF_tblInvoice_CreateDate]  DEFAULT (getdate()),
	[CreateUser] [uniqueidentifier] NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUser] [uniqueidentifier] NULL,
 CONSTRAINT [PK_tblInvoice] PRIMARY KEY CLUSTERED 
(
	[InvoiceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblInvoiceDetail]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblInvoiceDetail](
	[InvoiceDetailId] [uniqueidentifier] NOT NULL CONSTRAINT [DF_tblInvoiceDetail_InvoiceDetailId]  DEFAULT (newsequentialid()),
	[InvoiceId] [uniqueidentifier] NULL,
	[ProductId] [uniqueidentifier] NULL,
	[ProductQuantity] [int] NULL,
	[ProductPrice] [money] NULL,
	[SalePrice] [money] NULL,
	[CreateDate] [datetime] NULL CONSTRAINT [DF_tblInvoiceDetail_CreateDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_tblInvoiceDetail] PRIMARY KEY CLUSTERED 
(
	[InvoiceDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblProduct]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblProduct](
	[ProductId] [uniqueidentifier] NOT NULL CONSTRAINT [DF_tblProduct_ProductId]  DEFAULT (newsequentialid()),
	[ProductCategoryId] [uniqueidentifier] NULL,
	[ProductImage] [nvarchar](500) NULL,
	[ProductCode] [nvarchar](10) NULL,
	[ProductName] [nvarchar](250) NULL,
	[ProductPrice] [money] NULL,
	[ProductStatus] [tinyint] NULL CONSTRAINT [DF_tblProduct_ProductStatus]  DEFAULT ((1)),
	[CreateDate] [datetime] NULL CONSTRAINT [DF_tblProduct_CreateDate]  DEFAULT (getdate()),
	[CreateUser] [uniqueidentifier] NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUser] [uniqueidentifier] NULL,
	[ForSale] [bit] NULL CONSTRAINT [DF_tblProduct_ForSale]  DEFAULT ((0)),
 CONSTRAINT [PK_tblProduct] PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblProductCategory]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblProductCategory](
	[ProductCategoryId] [uniqueidentifier] NOT NULL CONSTRAINT [DF_tblProductCategory_ProductCategoryId]  DEFAULT (newsequentialid()),
	[ProductCategoryName] [nvarchar](250) NULL,
	[ProductCategoryNote] [nvarchar](500) NULL,
	[ProductCategoryStatus] [tinyint] NULL CONSTRAINT [DF_tblProductCategory_ProductCategoryStatus]  DEFAULT ((1)),
	[OrderNumber] [tinyint] NULL,
	[CreateDate] [datetime] NULL CONSTRAINT [DF_tblProductCategory_CreateDate]  DEFAULT (getdate()),
	[CreateUser] [uniqueidentifier] NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUser] [uniqueidentifier] NULL,
 CONSTRAINT [PK_tblProductCategory] PRIMARY KEY CLUSTERED 
(
	[ProductCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblSupplier]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblSupplier](
	[SupplierId] [uniqueidentifier] NOT NULL CONSTRAINT [DF_tblSupplier_SupplierId]  DEFAULT (newsequentialid()),
	[SupplierName] [nvarchar](250) NULL,
	[Phone] [nchar](10) NULL,
	[Address] [nvarchar](250) NULL,
	[OrderNumber] [tinyint] NULL,
 CONSTRAINT [PK_tblSupplier] PRIMARY KEY CLUSTERED 
(
	[SupplierId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblUnit]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUnit](
	[UnitId] [uniqueidentifier] NOT NULL CONSTRAINT [DF_tblUnit_UnitId]  DEFAULT (newsequentialid()),
	[UnitName] [nvarchar](50) NULL,
	[OrderNumber] [tinyint] NULL,
 CONSTRAINT [PK_tblUnit] PRIMARY KEY CLUSTERED 
(
	[UnitId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblUser]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblUser](
	[UserId] [uniqueidentifier] NOT NULL CONSTRAINT [DF_tblUser_UserId]  DEFAULT (newsequentialid()),
	[UserFullName] [nvarchar](100) NULL,
	[Avatar] [nvarchar](250) NULL,
	[Account] [nvarchar](100) NULL,
	[Stamp] [nvarchar](100) NULL,
	[Password] [varbinary](500) NULL,
	[UserNote] [nvarchar](250) NULL,
	[UserStatus] [int] NULL CONSTRAINT [DF_tblUser_UserStatus]  DEFAULT ((1)),
	[DateCreate] [datetime] NULL,
	[IsAdmin] [int] NULL,
 CONSTRAINT [PK_tblUser] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblWare]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblWare](
	[WareId] [uniqueidentifier] NOT NULL CONSTRAINT [DF_tblWare_WareId]  DEFAULT (newsequentialid()),
	[WareCode] [nchar](5) NULL,
	[WareName] [nvarchar](250) NULL,
	[UnitId] [uniqueidentifier] NULL,
	[SupplierId] [uniqueidentifier] NULL,
	[WarePriceIn] [money] NULL,
	[WarePriceSale] [money] NULL,
	[Quantity] [int] NULL,
	[QuantityRecommend] [int] NULL,
	[DateUpdate] [datetime] NULL,
	[WareStatus] [tinyint] NULL CONSTRAINT [DF_tblWare_WareStatus]  DEFAULT ((1)),
	[DateCreate] [datetime] NULL CONSTRAINT [DF_tblWare_DateCreate]  DEFAULT (getdate()),
	[WareNote] [nvarchar](250) NULL,
 CONSTRAINT [PK_tblWare] PRIMARY KEY CLUSTERED 
(
	[WareId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[tblCustomer] ADD  CONSTRAINT [DF_tblCustomer_CustomerId]  DEFAULT (newsequentialid()) FOR [CustomerId]
GO
ALTER TABLE [dbo].[tblCustomer] ADD  CONSTRAINT [DF_tblCustomer_CustomerStatus]  DEFAULT ((1)) FOR [CustomerStatus]
GO
ALTER TABLE [dbo].[tblCustomer] ADD  CONSTRAINT [DF_tblCustomer_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
/****** Object:  StoredProcedure [dbo].[sp_Config_Select]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Config_Select]
AS
BEGIN
	SELECT LogoPath, StoreName, StoreAddress, StorePhone, WifiInfo
	FROM tblConfig
END	





GO
/****** Object:  StoredProcedure [dbo].[sp_Config_Update]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Config_Update]
(
	@StoreName NVARCHAR(500),
	@StoreAddress NVARCHAR(500),
	@StorePhone NVARCHAR(250),
	@WifiInfo NVARCHAR(500) 
)
AS
BEGIN
	UPDATE tblConfig
	SET StoreName = @StoreName,
	StoreAddress = @StoreAddress,
	StorePhone = @StorePhone,
	WifiInfo = @WifiInfo
END	





GO
/****** Object:  StoredProcedure [dbo].[sp_Dashboard_Select_Chart_Money]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	KUN
-- Create date: 1/15/2020
-- Description:	
-- =============================================
CREATE PROC [dbo].[sp_Dashboard_Select_Chart_Money]
AS
BEGIN
	SELECT CONVERT(NVARCHAR(10), ii.CreateDate, 103) AS Ngay, SUM(ii.InvoiceValue) AS Money
	FROM dbo.tblInvoice ii
	WHERE DATEPART(month, ii.CreateDate) = DATEPART(month, GETDATE())
		AND	DATEPART(year, ii.CreateDate) = DATEPART(year, GETDATE())
		 AND ii.InvoiceStatus <> 2

	GROUP BY CONVERT(NVARCHAR(10), ii.CreateDate, 103)
	ORDER BY Ngay 		
END






GO
/****** Object:  StoredProcedure [dbo].[sp_Dashboard_Select_Chart_Quantity]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	KUN
-- Create date: 1/15/2020
-- Description:	
-- =============================================
CREATE PROC [dbo].[sp_Dashboard_Select_Chart_Quantity]
AS
BEGIN
	SELECT TOP 7 id.ProductId, pp.ProductName AS ProductName, SUM(id.ProductQuantity) AS Quantity
	FROM dbo.tblInvoice ii
		LEFT JOIN dbo.tblInvoiceDetail id ON ii.InvoiceId = id.InvoiceId
		LEFT JOIN dbo.tblProduct pp ON pp.ProductId = id.ProductId
	WHERE CAST(ii.CreateDate AS DATE) = CAST(GETDATE() AS DATE) AND ii.InvoiceStatus <> 2

	GROUP BY id.ProductId, pp.ProductName
	ORDER BY Quantity DESC	
END






GO
/****** Object:  StoredProcedure [dbo].[sp_Dashboard_Select_Count_Top]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	KUN
-- Create date: 1/15/2020
-- Description:	
-- =============================================
CREATE PROC [dbo].[sp_Dashboard_Select_Count_Top]
AS
BEGIN
	SELECT A.SoHoaDon, B.DoanhThu, C.SanPham, (b.DoanhThu - d.DoanhThuHomQua) AS SoVoiHomQua
	FROM 
		(SELECT COUNT(1) AS SoHoaDon FROM dbo.tblInvoice WHERE CAST(CreateDate AS DATE) = CAST(GETDATE() AS DATE) AND InvoiceStatus <> 2) AS A,
		(SELECT ISNULL(SUM(InvoiceValue),0) AS DoanhThu FROM dbo.tblInvoice WHERE CAST(CreateDate AS DATE) = CAST(GETDATE() AS DATE) AND InvoiceStatus <> 2) AS B,
		(SELECT COUNT(1) AS SanPham FROM dbo.tblProduct WHERE ProductStatus = 1) AS C,
		(SELECT ISNULL(SUM(InvoiceValue),0) AS DoanhThuHomQua FROM dbo.tblInvoice WHERE CAST(CreateDate AS DATE) = CAST((GETDATE() - 1) AS DATE) AND InvoiceStatus <> 2) AS D
END






GO
/****** Object:  StoredProcedure [dbo].[sp_Dashboard_Select_Timeline]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	KUN
-- Create date: 1/15/2020
-- Description:	
-- =============================================
CREATE PROC [dbo].[sp_Dashboard_Select_Timeline]
	@Day NVARCHAR(10) 
AS
BEGIN
	SELECT xx.ActLogName, 
			xx.ActLogCode,
			xx.RelateId, 
			ii.InvoiceCode, 
			CONVERT(NVARCHAR(10), xx.CreateDate, 103) AS NgayTao,
			dbo.fn_Time_Left(xx.CreateDate) AS TimeAgo,
			N'admin' AS TenNhanVien
	FROM dbo.tblActLog xx
		LEFT JOIN dbo.tblInvoice ii ON xx.RelateId = ii.InvoiceId
		

	WHERE xx.RelateCode = 1
		AND Cast(@Day AS DATE) = Cast(xx.CreateDate AS DATE)
	ORDER BY xx.CreateDate desc
END






GO
/****** Object:  StoredProcedure [dbo].[sp_Invoice_Delete]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Invoice_Delete]
(
	@InvoiceId UNIQUEIDENTIFIER,
	@UserId UNIQUEIDENTIFIER
)
AS
BEGIN
	SET XACT_ABORT ON
	BEGIN TRAN
	BEGIN TRY
		
		--xóa hóa đơn
		UPDATE dbo.tblInvoice 
		SET InvoiceStatus=2,
			UpdateDate = GETDATE(),
			UpdateUser = @UserId
		WHERE InvoiceId = @InvoiceId

		--thêm Log
		INSERT INTO dbo.tblActLog(ActLogName, ActLogCode, RelateId, RelateCode, CreateUser)
		VALUES(N'đã hủy hóa đơn', 5,  @InvoiceId, 1, @UserId)
		        
	COMMIT
	END TRY
	BEGIN CATCH
	ROLLBACK
		DECLARE @ErrorMessage VARCHAR(2000)
		SELECT @ErrorMessage = 'Lỗi: ' + ERROR_MESSAGE()
		RAISERROR(@ErrorMessage, 16, 1)	
	END CATCH
END	





GO
/****** Object:  StoredProcedure [dbo].[sp_Invoice_Insert_Payment]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=============================================
-- Author:	KUN
-- Modified date: 1/15/2020
-- Description:	Sự kiện ấn nút thanh toán hóa đơn
-- =============================================
CREATE PROCEDURE [dbo].[sp_Invoice_Insert_Payment] 
(
	@CustomerId NVARCHAR(36), 
	@TotalPrice MONEY, 
	@SaleValue MONEY, 
	@SaleType TINYINT, 
	@OtherFeeValue MONEY, 
	@OtherFeeDescription NVARCHAR(500), 
	@InvoiceValue MONEY, 
	@InvoiceNote NVARCHAR(500), 
	@CreateUser UNIQUEIDENTIFIER,
	@DT TBL_INVOICE_DETAIL READONLY
)
AS
BEGIN
	SET XACT_ABORT ON
	BEGIN TRAN
	BEGIN TRY
		--set ISNULL nếu ko nhập khách hàng
		IF (@CustomerId = '') BEGIN SET @CustomerId = NULL END

		--tạo mã hóa đơn tự động tăng theo ngày
		DECLARE @InvoiceCode NVARCHAR(10)
		DECLARE @MaxRow BIGINT
		SET @MaxRow = (SELECT COUNT(1) FROM dbo.tblInvoice WHERE CAST(CreateDate AS DATE) = CAST(GETDATE() AS DATE))
		SELECT @InvoiceCode = (SELECT CONCAT('HD', RIGHT(CONCAT('000000',ISNULL(RIGHT(MAX(@MaxRow),6),0) + 1),6)))
	
		--tạo biến chứa IdHoaDon
		DECLARE @TBL_TEMPT AS TABLE(IdInvoice UNIQUEIDENTIFIER)
		DECLARE @IdInvoice UNIQUEIDENTIFIER

		--thêm thông tin hóa đơn
		INSERT INTO tblInvoice
		(
			CustomerId, InvoiceCode, TotalPrice, SaleValue, SaleType, OtherFeeValue, OtherFeeDescription, InvoiceValue, InvoiceNote, InvoiceStatus, CreateUser
		)
		OUTPUT Inserted.InvoiceId INTO @TBL_TEMPT
		VALUES
		(
			@CustomerId, @InvoiceCode, @TotalPrice, @SaleValue, @SaleType, @OtherFeeValue, @OtherFeeDescription, @InvoiceValue, @InvoiceNote, 1, @CreateUser
		)

		--lấy giá trị IdHoaDon
		SELECT @IdInvoice = (SELECT TOP 1 IdInvoice FROM @TBL_TEMPT)

		--thêm thông tin chi tiết hóa đơn
		INSERT INTO tblInvoiceDetail(InvoiceId, ProductId, ProductQuantity, ProductPrice, SalePrice)
		SELECT @IdInvoice, dt.ProductId, dt.ProductQuantity, p.ProductPrice, dt.SalePrice
		FROM dbo.tblProduct p 
			INNER JOIN @DT dt ON p.ProductId = dt.ProductId
	
		--thêm Log
		INSERT INTO dbo.tblActLog(ActLogName, ActLogCode, RelateId, RelateCode, CreateUser)
		VALUES(N'đã thanh toán hóa đơn', 1,  @IdInvoice, 1, @CreateUser)
		        
		------------------------------------LẤY RA IDHOADON để in
		SELECT @IdInvoice AS IdInvoice

	COMMIT
	END TRY
	BEGIN CATCH
	ROLLBACK
		DECLARE @ErrorMessage VARCHAR(2000)
		SELECT @ErrorMessage = 'Lỗi: ' + ERROR_MESSAGE()
		RAISERROR(@ErrorMessage, 16, 1)	
	END CATCH
	
	
			

END	







GO
/****** Object:  StoredProcedure [dbo].[sp_Invoice_Insert_Payment_Re]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=============================================
-- Author:	KUN
-- Modified date: 1/15/2020
-- Description:	sự kiện ấn nút thanh toán sau khi chọn lại hóa đơn đó từ hàng đợi
-- =============================================
CREATE PROCEDURE [dbo].[sp_Invoice_Insert_Payment_Re] 
(
	@InvoiceId UNIQUEIDENTIFIER,
	@CustomerId NVARCHAR(36), 
	@TotalPrice MONEY, 
	@SaleValue MONEY, 
	@SaleType TINYINT, 
	@OtherFeeValue MONEY, 
	@OtherFeeDescription NVARCHAR(500), 
	@InvoiceValue MONEY, 
	@InvoiceNote NVARCHAR(500), 
	@UdpateUser UNIQUEIDENTIFIER,
	@DT TBL_INVOICE_DETAIL READONLY
)
AS
BEGIN
	SET XACT_ABORT ON
	BEGIN TRAN
	BEGIN TRY
		--set ISNULL nếu ko nhập khách hàng
		IF (@CustomerId = '') BEGIN SET @CustomerId = NULL END

		--update thông tin hóa đơn
		UPDATE dbo.tblInvoice
		SET CustomerId = @CustomerId,
			InvoiceStatus = 1,
			TotalPrice = @TotalPrice,
			SaleValue = @SaleValue,
			SaleType = @SaleType,
			OtherFeeValue = @OtherFeeValue,
			OtherFeeDescription = @OtherFeeDescription,
			InvoiceValue = @InvoiceValue,
			InvoiceNote = @InvoiceNote,
			UpdateDate = GETDATE(),
			UpdateUser = @UdpateUser

		WHERE InvoiceId = @InvoiceId

		--update thông tin chi tiết hóa đơn --xóa cũ và thêm mới
		DELETE FROM dbo.tblInvoiceDetail WHERE InvoiceId = @InvoiceId 
		
		INSERT INTO tblInvoiceDetail(InvoiceId, ProductId, ProductQuantity, ProductPrice, SalePrice)
		SELECT @InvoiceId, dt.ProductId, dt.ProductQuantity, p.ProductPrice, dt.SalePrice
		FROM dbo.tblProduct p 
			INNER JOIN @DT dt ON p.ProductId = dt.ProductId	
		
		--thêm Log
		INSERT INTO dbo.tblActLog(ActLogName, ActLogCode, RelateId, RelateCode, CreateUser)
		VALUES(N'đã thanh toán lại hóa đơn', 2, @InvoiceId, 1, @UdpateUser)
	
		------------------------------------LẤY RA IDHOADON để in
		SELECT @InvoiceId AS IdInvoice
	COMMIT
	END TRY
	BEGIN CATCH
	ROLLBACK
		DECLARE @ErrorMessage VARCHAR(2000)
		SELECT @ErrorMessage = 'Lỗi: ' + ERROR_MESSAGE()
		RAISERROR(@ErrorMessage, 16, 1)	
	END CATCH
	
	
			

END	







GO
/****** Object:  StoredProcedure [dbo].[sp_Invoice_Insert_Waiting_To_Pay]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=============================================
-- Author:	KUN
-- Modified date: 1/15/2020
-- Description:	Lưu tạm hóa đơn vào hàng chờ chứ chưa thanh toán
-- =============================================
CREATE PROCEDURE [dbo].[sp_Invoice_Insert_Waiting_To_Pay] 
(
	@CustomerId NVARCHAR(36), 
	@TotalPrice MONEY, 
	@SaleValue MONEY, 
	@SaleType TINYINT, 
	@OtherFeeValue MONEY, 
	@OtherFeeDescription NVARCHAR(500), 
	@InvoiceValue MONEY, 
	@InvoiceNote NVARCHAR(500), 
	@CreateUser UNIQUEIDENTIFIER,
	@DT TBL_INVOICE_DETAIL READONLY
)
AS
BEGIN
	SET XACT_ABORT ON
	BEGIN TRAN
	BEGIN TRY
		--set ISNULL nếu ko nhập khách hàng
		IF (@CustomerId = '') BEGIN SET @CustomerId = NULL END

		--tạo mã hóa đơn tự động tăng theo ngày
		DECLARE @InvoiceCode NVARCHAR(10)
		DECLARE @MaxRow BIGINT
		SET @MaxRow = (SELECT COUNT(1) FROM dbo.tblInvoice WHERE CAST(CreateDate AS DATE) = CAST(GETDATE() AS DATE))
		SELECT @InvoiceCode = (SELECT CONCAT('HD', RIGHT(CONCAT('000000',ISNULL(RIGHT(MAX(@MaxRow),6),0) + 1),6)))
	
		--tạo biến chứa IdHoaDon
		DECLARE @TBL_TEMPT AS TABLE(IdInvoice UNIQUEIDENTIFIER)
		DECLARE @IdInvoice UNIQUEIDENTIFIER

		--thêm thông tin hóa đơn
		INSERT INTO tblInvoice
		(
			CustomerId, InvoiceCode, TotalPrice, SaleValue, SaleType, OtherFeeValue, OtherFeeDescription, InvoiceValue, InvoiceNote, InvoiceStatus, CreateUser
		)
		OUTPUT Inserted.InvoiceId INTO @TBL_TEMPT
		VALUES
		(
			@CustomerId, @InvoiceCode, @TotalPrice, @SaleValue, @SaleType, @OtherFeeValue, @OtherFeeDescription, @InvoiceValue, @InvoiceNote, 0, @CreateUser
		)

		--lấy giá trị IdHoaDon
		SELECT @IdInvoice = (SELECT TOP 1 IdInvoice FROM @TBL_TEMPT)

		--thêm thông tin chi tiết hóa đơn
		INSERT INTO tblInvoiceDetail(InvoiceId, ProductId, ProductQuantity, ProductPrice, SalePrice)
		SELECT @IdInvoice, dt.ProductId, dt.ProductQuantity, p.ProductPrice, dt.SalePrice
		FROM dbo.tblProduct p 
			INNER JOIN @DT dt ON p.ProductId = dt.ProductId
	
		--thêm Log
		INSERT INTO dbo.tblActLog(ActLogName, ActLogCode, RelateId, RelateCode, CreateUser)
		VALUES(N'đã lưu tạm hóa đơn', 3, @IdInvoice, 1, @CreateUser)

		------------------------------------LẤY RA IDHOADON để in
		SELECT @IdInvoice AS IdInvoice


	COMMIT
	END TRY
	BEGIN CATCH
	ROLLBACK
		DECLARE @ErrorMessage VARCHAR(2000)
		SELECT @ErrorMessage = 'Lỗi: ' + ERROR_MESSAGE()
		RAISERROR(@ErrorMessage, 16, 1)	
	END CATCH
	
	
			

END	







GO
/****** Object:  StoredProcedure [dbo].[sp_Invoice_Insert_Waiting_To_Pay_Re]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=============================================
-- Author:	KUN
-- Modified date: 1/15/2020
-- Description:	Lưu tạm lại hóa đơn (Cập nhật thông tin hóa đơn chưa thanh toán/ gọi thêm, xóa bớt món)
-- =============================================
CREATE PROCEDURE [dbo].[sp_Invoice_Insert_Waiting_To_Pay_Re]
(
	@InvoiceId UNIQUEIDENTIFIER,
	@CustomerId NVARCHAR(36), 
	@TotalPrice MONEY, 
	@SaleValue MONEY, 
	@SaleType TINYINT, 
	@OtherFeeValue MONEY, 
	@OtherFeeDescription NVARCHAR(500), 
	@InvoiceValue MONEY, 
	@InvoiceNote NVARCHAR(500), 
	@UdpateUser UNIQUEIDENTIFIER,
	@DT TBL_INVOICE_DETAIL READONLY
)
AS
BEGIN
	SET XACT_ABORT ON
	BEGIN TRAN
	BEGIN TRY
		--set ISNULL nếu ko nhập khách hàng
		IF (@CustomerId = '') BEGIN SET @CustomerId = NULL END

		--update thông tin hóa đơn
		UPDATE dbo.tblInvoice
		SET CustomerId = @CustomerId,
			InvoiceStatus = 0,
			TotalPrice = @TotalPrice,
			SaleValue = @SaleValue,
			SaleType = @SaleType,
			OtherFeeValue = @OtherFeeValue,
			OtherFeeDescription = @OtherFeeDescription,
			InvoiceValue = @InvoiceValue,
			InvoiceNote = @InvoiceNote,
			UpdateDate = GETDATE(),
			UpdateUser = @UdpateUser

		WHERE InvoiceId = @InvoiceId

		--update thông tin chi tiết hóa đơn --xóa cũ và thêm mới
		DELETE FROM dbo.tblInvoiceDetail WHERE InvoiceId = @InvoiceId 
		
		INSERT INTO tblInvoiceDetail(InvoiceId, ProductId, ProductQuantity, ProductPrice, SalePrice)
		SELECT @InvoiceId, dt.ProductId, dt.ProductQuantity, p.ProductPrice, dt.SalePrice
		FROM dbo.tblProduct p 
			INNER JOIN @DT dt ON p.ProductId = dt.ProductId	

		--thêm Log
		INSERT INTO dbo.tblActLog(ActLogName, ActLogCode, RelateId, RelateCode, CreateUser)
		VALUES(N'đã cập nhật hóa đơn', 4, @InvoiceId, 1, @UdpateUser)

		------------------------------------LẤY RA IDHOADON để in
		SELECT @InvoiceId AS IdInvoice
	
	COMMIT
	END TRY
	BEGIN CATCH
	ROLLBACK
		DECLARE @ErrorMessage VARCHAR(2000)
		SELECT @ErrorMessage = 'Lỗi: ' + ERROR_MESSAGE()
		RAISERROR(@ErrorMessage, 16, 1)	
	END CATCH
	
	
			

END	







GO
/****** Object:  StoredProcedure [dbo].[sp_Invoice_Select_Id]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE	[dbo].[sp_Invoice_Select_Id]
(
	@InvoiceId UNIQUEIDENTIFIER
)
AS
BEGIN
	--select table invoice
	SELECT InvoiceId, CustomerId, InvoiceCode, TotalPrice, SaleValue, SaleType, OtherFeeValue, OtherFeeDescription, InvoiceValue, InvoiceNote,
			CONVERT(NVARCHAR(5), CreateDate, 108) + ' ' + CONVERT(NVARCHAR(10), CreateDate, 103) AS CreateDate,
			CASE(SaleType) WHEN 0 THEN - SaleValue 
				WHEN 1 THEN - TotalPrice * (SaleValue/100) END AS TotalSale
	FROM dbo.tblInvoice
	WHERE InvoiceId = @InvoiceId

	--select table invoice detail
	SELECT xx.ProductId,
			xx.ProductQuantity,
			xx.ProductPrice,
			xx.SalePrice,
			p.ProductName, 
			p.ProductImage,
			p.ProductCode,
			xx.SalePrice * xx.ProductQuantity AS TotalProductPrice
	FROM dbo.tblInvoiceDetail xx
		LEFT JOIN dbo.tblProduct p ON p.ProductId = xx.ProductId
	WHERE xx.InvoiceId = @InvoiceId

END	







GO
/****** Object:  StoredProcedure [dbo].[sp_Invoice_Select_Page]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Invoice_Select_Page]
(
	@DAY NVARCHAR(10),
	@Item INT
)
AS
BEGIN
	SELECT  CONVERT(INT, CEILING(CONVERT(MONEY, COUNT(xx.InvoiceId)) / @Item)) AS TotalPage, 
			COUNT(xx.InvoiceId) AS TotalRow
	FROM dbo.tblInvoice xx

	WHERE xx.InvoiceStatus = 1
			AND CAST(@DAY AS DATE) = CAST(xx.CreateDate AS DATE)
END	







GO
/****** Object:  StoredProcedure [dbo].[sp_Invoice_Select_Report]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Invoice_Select_Report]
AS
BEGIN
	SELECT  xx.InvoiceId,
			xx.InvoiceCode,
			xx.TotalPrice,
			CASE(xx.SaleType) WHEN 0 THEN xx.SaleValue 
				WHEN 1 THEN xx.TotalPrice * (xx.SaleValue/100) END AS SaleValue,
			ISNULL(xx.OtherFeeValue, 0) AS OtherFeeValue,
			xx.OtherFeeDescription,
			xx.InvoiceStatus, 
			xx.InvoiceValue,
			CONVERT(NVARCHAR(5), xx.CreateDate, 108) AS DateCreate
	FROM dbo.tblInvoice xx

	WHERE xx.InvoiceStatus = 1
			AND CAST(GETDATE() AS DATE) = CAST(xx.CreateDate AS DATE)
	ORDER BY xx.CreateDate
END	







GO
/****** Object:  StoredProcedure [dbo].[sp_Invoice_Select_Table]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Invoice_Select_Table]
(
	@DAY NVARCHAR(10),
	@Order INT,
	@PageIndex INT,
	@Item INT
)
AS
BEGIN
	SELECT  @Item AS DefaultRows,
			xx.InvoiceId,
			xx.InvoiceCode,
			xx.TotalPrice,
			xx.SaleValue,
			xx.SaleType,
			xx.OtherFeeValue,
			xx.OtherFeeDescription,
			xx.InvoiceStatus, 
			xx.InvoiceValue,
			xx.InvoiceNote,
			CONVERT(NVARCHAR(5), xx.CreateDate, 108) AS DateCreate,
			CONVERT(NVARCHAR(5), xx.UpdateDate, 108) AS UpdateDate
	FROM dbo.tblInvoice xx

	WHERE xx.InvoiceStatus =1
			AND CAST(@DAY AS DATE) = CAST(xx.CreateDate AS DATE)
	ORDER BY CASE @Order WHEN 1 THEN xx.UpdateDate END,
			CASE @Order WHEN 2 THEN xx.UpdateDate END DESC,
			CASE @Order WHEN 3 THEN xx.InvoiceValue END,
			CASE @Order WHEN 4 THEN xx.InvoiceValue END DESC
	OFFSET ( @PageIndex - 1 ) * @Item ROWS
	FETCH NEXT @Item ROWS ONLY;
END	







GO
/****** Object:  StoredProcedure [dbo].[sp_Invoice_Select_Waiting_To_Pay]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Invoice_Select_Waiting_To_Pay]
AS
BEGIN
	
	--select Invoice
	SELECT InvoiceId,
			InvoiceCode,
			InvoiceValue,
			dbo.fn_Time_Left(xx.CreateDate) AS CreateDate,
			InvoiceNote
	FROM dbo.tblInvoice xx
	WHERE InvoiceStatus = 0
		AND CAST(GETDATE() AS DATE) = CAST(CreateDate AS DATE)
	ORDER BY xx.CreateDate 

	--select Invoice Detail
	SELECT ii.InvoiceId,
			pp.ProductName,	
			ProductQuantity,
			id.SalePrice * id.ProductQuantity AS ProductValue
	FROM dbo.tblInvoiceDetail id
		LEFT JOIN dbo.tblInvoice ii ON ii.InvoiceId = id.InvoiceId
		LEFT JOIN dbo.tblProduct pp ON pp.ProductId = id.ProductId

	WHERE ii.InvoiceStatus = 0
		AND CAST(GETDATE() AS DATE) = CAST(ii.CreateDate AS DATE)
	ORDER BY ii.CreateDate 

END	







GO
/****** Object:  StoredProcedure [dbo].[sp_Logo_Update]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Logo_Update]
(
	@LogoPath NVARCHAR(500)
)
AS
BEGIN
	UPDATE tblConfig SET LogoPath = @LogoPath
END	





GO
/****** Object:  StoredProcedure [dbo].[sp_Product_Delete]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_Product_Delete]
(
	@ProductId UNIQUEIDENTIFIER,
	@UpdateUser UNIQUEIDENTIFIER
)
AS
BEGIN
	UPDATE dbo.tblProduct
	SET ProductStatus = 2,
		UpdateDate = GETDATE(),
		UpdateUser = @UpdateUser
	WHERE ProductId = @ProductId
END	







GO
/****** Object:  StoredProcedure [dbo].[sp_Product_Insert]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Product_Insert]
(
	@ProductCategoryId UNIQUEIDENTIFIER, 
	@ProductImage NVARCHAR(500), 
	@ProductCode NVARCHAR(10), 
	@ProductName NVARCHAR(250), 
	@ProductPrice MONEY, 
	@CreateUser UNIQUEIDENTIFIER
)
AS
BEGIN
	DECLARE @ExistProductCode BIT = 0
	IF EXISTS (SELECT 1 FROM dbo.tblProduct WHERE ProductCode = @ProductCode AND ProductStatus = 1)
	BEGIN SET @ExistProductCode = 1 END	

	IF(@ExistProductCode = 1)
	BEGIN
		SELECT 2 AS MsgCode
	END
    ELSE
    BEGIN
		INSERT INTO tblProduct(ProductCategoryId, ProductImage, ProductCode, ProductName, ProductPrice, CreateUser)
		VALUES(@ProductCategoryId, @ProductImage, @ProductCode, @ProductName, @ProductPrice, @CreateUser)

		IF @@ROWCOUNT > 0
		BEGIN
			SELECT 1 AS MsgCode
		END
		ELSE
		BEGIN
			SELECT 0 AS MsgCode
		END
	END	
END	







GO
/****** Object:  StoredProcedure [dbo].[sp_Product_Select_Dropdown_Sale]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Product_Select_Dropdown_Sale]
(
	@Search NVARCHAR(50)
)
AS
BEGIN
	SELECT TOP 5 p.ProductId AS id,
			p.ProductName AS text,
			p.ProductPrice,
			p.ProductImage,
            ProductCode
	FROM dbo.tblProduct p 
			LEFT JOIN (SELECT A.ProductId, COUNT(B.ProductId) AS SumProduct
								FROM dbo.tblProduct A LEFT JOIN dbo.tblInvoiceDetail B ON a.ProductId = B.ProductId
													LEFT JOIN dbo.tblInvoice C ON B.InvoiceId = C.InvoiceId
								WHERE C.InvoiceStatus <> 0
								GROUP BY A.ProductId) X ON p.ProductId = x.ProductId
	WHERE p.ProductStatus = 1 AND ForSale = 0
		AND ISNULL(p.ProductCode, '') + ISNULL(p.ProductName, '') COLLATE SQL_Latin1_General_CP1_CI_AI LIKE '%' + @Search + '%' 
	ORDER BY X.SumProduct DESC
END	









GO
/****** Object:  StoredProcedure [dbo].[sp_Product_Select_Id]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_Product_Select_Id]
(
	@ProductId UNIQUEIDENTIFIER
)
AS
BEGIN
	SELECT ProductId, ProductCategoryId, ProductImage, ProductCode, ProductName, ProductPrice, ProductStatus
	FROM dbo.tblProduct
	WHERE ProductId = @ProductId
END	







GO
/****** Object:  StoredProcedure [dbo].[sp_Product_Select_Page]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Product_Select_Page] 
(
	@CategoryId NVARCHAR(36),
	@Search NVARCHAR(100),
	@Item INT
)
AS
BEGIN
	IF @CategoryId = '' SET @CategoryId = NULL	
	SELECT  CONVERT(INT, CEILING(CONVERT(MONEY, COUNT(p.ProductId)) / @Item)) AS TotalPage, 
			COUNT(p.ProductId) AS TotalRow
	FROM dbo.tblProduct p
	WHERE p.ProductStatus <> 2 AND ForSale = 0
		AND (@CategoryId IS NULL OR p.ProductCategoryId = CAST(@CategoryId AS UNIQUEIDENTIFIER))
		AND ISNULL(p.ProductCode, '') + ISNULL(p.ProductName, '') + ISNULL(CAST(p.ProductPrice AS NVARCHAR(20)), '') COLLATE SQL_Latin1_General_CP1_CI_AI LIKE '%' + @Search + '%' 
END	







GO
/****** Object:  StoredProcedure [dbo].[sp_Product_Select_Table]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Product_Select_Table]
(
	@CategoryId NVARCHAR(36),
	@Search NVARCHAR(100),
	@Order INT,
	@PageIndex INT,
	@Item INT
)
AS
BEGIN
	IF @CategoryId = '' SET @CategoryId = NULL
	SELECT  @Item AS DefaultRows,
			p.ProductId, 
			ProductCategoryName, 
			ProductImage, 
			ProductCode, 
			ProductName, 
			p.ProductPrice, 
			ProductStatus, 
			CONVERT(NVARCHAR(10), p.CreateDate, 103) AS DateCreate,
			COUNT(id.ProductId) AS SeltByMonth
	FROM dbo.tblProduct p
		LEFT JOIN dbo.tblProductCategory cat ON cat.ProductCategoryId = p.ProductCategoryId
		LEFT JOIN dbo.tblInvoiceDetail id ON p.ProductId = id.ProductId
		LEFT JOIN dbo.tblInvoice i ON i.InvoiceId = id.InvoiceId 

	WHERE p.ProductStatus <> 2 AND ForSale = 0
		AND (@CategoryId IS NULL OR p.ProductCategoryId = CAST(@CategoryId AS UNIQUEIDENTIFIER))
		AND ISNULL(p.ProductCode, '') + ISNULL(p.ProductName, '') + ISNULL(CAST(p.ProductPrice AS NVARCHAR(20)), '') COLLATE SQL_Latin1_General_CP1_CI_AI LIKE '%' + @Search + '%' 
		AND i.InvoiceStatus <> 0
	GROUP BY p.ProductId, cat.ProductCategoryName, p.ProductImage, p.ProductCode, p.ProductName, p.ProductPrice, p.ProductStatus,CONVERT(NVARCHAR(10), p.CreateDate, 103)
	ORDER BY CASE @Order WHEN 1 THEN p.ProductName END,
			CASE @Order WHEN 2 THEN p.ProductName END DESC,
			CASE @Order WHEN 3 THEN p.ProductPrice END,
			CASE @Order WHEN 4 THEN p.ProductPrice END DESC,
			CASE @Order WHEN 0 THEN COUNT(id.ProductId) END DESC
			--,
			--CASE @Order WHEN 3 THEN p.CreateDate END,
			--CASE @Order WHEN 4 THEN p.CreateDate END DESC
	
			 
	OFFSET ( @PageIndex - 1 ) * @Item ROWS
	FETCH NEXT @Item ROWS ONLY;
END	








GO
/****** Object:  StoredProcedure [dbo].[sp_Product_Update]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_Product_Update]
(
	@ProductId UNIQUEIDENTIFIER,
	@ProductCategoryId UNIQUEIDENTIFIER, 
	@ProductImage NVARCHAR(500), 
	@ProductName NVARCHAR(250), 
	@ProductPrice MONEY, 
	@UpdateUser UNIQUEIDENTIFIER
)
AS
BEGIN
	UPDATE dbo.tblProduct
	SET ProductCategoryId = @ProductCategoryId,
		ProductImage = @ProductImage,
		ProductName = @ProductName,
		ProductPrice = @ProductPrice,
		UpdateDate = GETDATE(),
		UpdateUser = @UpdateUser
	WHERE ProductId = @ProductId
END	







GO
/****** Object:  StoredProcedure [dbo].[sp_ProductCategory_Delete]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ProductCategory_Delete]
(
	@ProductCategoryId UNIQUEIDENTIFIER,
	@UpdateUser UNIQUEIDENTIFIER
)
AS
BEGIN
	UPDATE dbo.tblProductCategory
	SET ProductCategoryStatus = 2,
		UpdateDate = GETDATE(),
		UpdateUser = @UpdateUser
	WHERE ProductCategoryId = @ProductCategoryId
END	







GO
/****** Object:  StoredProcedure [dbo].[sp_ProductCategory_Insert]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ProductCategory_Insert]
(
	@ProductCategoryName NVARCHAR(250),
	@ProductCategoryNote NVARCHAR(500), 
	@CreateUser UNIQUEIDENTIFIER
)
AS
BEGIN
	DECLARE @ExistsName BIT = 0
	IF EXISTS (SELECT 1 FROM dbo.tblProductCategory WHERE ProductCategoryName = @ProductCategoryName AND ProductCategoryStatus = 1)
	BEGIN SET @ExistsName = 1 END	

	IF(@ExistsName = 1)
	BEGIN
		SELECT 2 AS MsgCode
	END
    ELSE
    BEGIN
		
		INSERT INTO tblProductCategory(ProductCategoryName, ProductCategoryNote, CreateUser)
		VALUES(@ProductCategoryName, @ProductCategoryNote, @CreateUser)

		IF @@ROWCOUNT > 0
		BEGIN
			SELECT 1 AS MsgCode
		END
		ELSE
		BEGIN
			SELECT 0 AS MsgCode
		END
	END	
	
END	







GO
/****** Object:  StoredProcedure [dbo].[sp_ProductCategory_Select]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ProductCategory_Select]
AS
BEGIN
	SELECT pc.ProductCategoryId, pc.ProductCategoryName, pc.ProductCategoryNote, COUNT(xx.ProductId) AS SumProduct, pc.OrderNumber
	FROM dbo.tblProductCategory pc
		LEFT JOIN 
		(
			SELECT ProductId, ProductCategoryId FROM dbo.tblProduct WHERE ProductStatus = 1
		) AS xx ON pc.ProductCategoryId = xx.ProductCategoryId
    WHERE pc.ProductCategoryStatus = 1
	GROUP BY pc.ProductCategoryId, pc.ProductCategoryName, pc.ProductCategoryNote, pc.OrderNumber
	--ORDER BY SumProduct DESC	
	ORDER BY pc.OrderNumber
END	







GO
/****** Object:  StoredProcedure [dbo].[sp_ProductCategory_SelectId]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ProductCategory_SelectId]
(
	@ProductCategoryId UNIQUEIDENTIFIER
)
AS
BEGIN
	SELECT pc.ProductCategoryId, pc.ProductCategoryName, pc.ProductCategoryNote
	FROM dbo.tblProductCategory pc
    WHERE pc.ProductCategoryId = @ProductCategoryId
END	







GO
/****** Object:  StoredProcedure [dbo].[sp_ProductCategory_Update]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ProductCategory_Update]
(
	@ProductCategoryId UNIQUEIDENTIFIER,
	@ProductCategoryName NVARCHAR(250),
	@ProductCategoryNote NVARCHAR(500), 
	@UpdateUser UNIQUEIDENTIFIER
)
AS
BEGIN
	DECLARE @ExistsName BIT = 0
	IF EXISTS (SELECT 1 FROM dbo.tblProductCategory WHERE ProductCategoryName = @ProductCategoryName AND ProductCategoryStatus = 1 AND ProductCategoryId <> @ProductCategoryId)
	BEGIN SET @ExistsName = 1 END	

	IF(@ExistsName = 1)
	BEGIN
		SELECT 2 AS MsgCode
	END
    ELSE
    BEGIN
		
		UPDATE dbo.tblProductCategory
		SET ProductCategoryName = @ProductCategoryName,
			ProductCategoryNote = @ProductCategoryNote,
			UpdateDate = GETDATE(),
			UpdateUser = @UpdateUser
		WHERE ProductCategoryId = @ProductCategoryId

		IF @@ROWCOUNT > 0
		BEGIN
			SELECT 1 AS MsgCode
		END
		ELSE
		BEGIN
			SELECT 0 AS MsgCode
		END
	END	
END	







GO
/****** Object:  StoredProcedure [dbo].[sp_Report_01]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Report_01]
(
	@From NVARCHAR(10),
	@To NVARCHAR(10)
)
AS
BEGIN
	SELECT xx.InvoiceCode
		
	FROM dbo.tblInvoice AS xx
	WHERE InvoiceStatus = 1
	AND CAST(CreateDate AS DATE) >= CAST(@From AS DATE)
	AND CAST(CreateDate AS DATE) <= CAST(@To AS DATE)
END	


	



GO
/****** Object:  StoredProcedure [dbo].[sp_Supplier_Select]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Supplier_Select]
AS
BEGIN
	SELECT SupplierId, SupplierName, Phone, Address, OrderNumber FROM dbo.tblSupplier ORDER BY OrderNumber
END	

GO
/****** Object:  StoredProcedure [dbo].[sp_Unit_Select]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Unit_Select]
AS
BEGIN
	SELECT UnitId, UnitName, OrderNumber FROM dbo.tblUnit ORDER BY OrderNumber 
END	
GO
/****** Object:  StoredProcedure [dbo].[sp_User_ChangePassword]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[sp_User_ChangePassword]--'admin', ''
(
	@userId UNIQUEIDENTIFIER,
	@oldPass NVARCHAR(500),
	@newPass NVARCHAR(500)
)
AS
BEGIN
	if exists
	(
		SELECT 1
		FROM tblUser AS u
		WHERE u.UserId = @userId
			AND PWDCOMPARE(@oldPass, u.[Password]) = 1
			AND u.UserStatus <> 2
	)
	begin
		update tblUser
		set [Password] = PWDENCRYPT(@newPass)
		where UserId = @userId

		select 1 as result
	end

	else
	select 0 as result
END

GO
/****** Object:  StoredProcedure [dbo].[sp_User_Delete]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_User_Delete]
(
	@userId UNIQUEIDENTIFIER, 
	@deleter UNIQUEIDENTIFIER
)
as
begin
	update tblUser
	set UserStatus = 2
	
	where userId = @userId
end

GO
/****** Object:  StoredProcedure [dbo].[sp_User_Insert]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_User_Insert]
(
	@UserName NVARCHAR(100),
	@Account NVARCHAR(100),
	@Avartar NVARCHAR(250),
	@Stamp NVARCHAR(100),
	@Password NVARCHAR(500),
	@Note NVARCHAR(250),
	@isAdmin int
)
AS
BEGIN
	IF  NOT EXISTS (SELECT 1 FROM tblUser WHERE Account = @Account and UserStatus = 1)
	BEGIN
		INSERT INTO tblUser (UserFullName, Account, Avatar, Stamp, [Password], UserNote, IsAdmin, DateCreate)
		VALUES  ( @UserName,
				  @Account , -- Account - nvarchar(100)
				  @Avartar,
				  @Stamp , -- Stamp - nvarchar(100)
				  PWDENCRYPT(@Password) , -- Password - nvarchar(200)
				  @Note , -- Note - nvarchar(250)
					@isAdmin,
				  GETDATE()  -- Date_Create - datetime
				)
		IF @@ROWCOUNT > 0 BEGIN SELECT '1' AS MsgCode END 
		ELSE SELECT '0' AS MsgCode
	END
	ELSE SELECT '2' AS MsgCode
END

GO
/****** Object:  StoredProcedure [dbo].[sp_User_Reset_Password]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_User_Reset_Password]
(
	@userId UNIQUEIDENTIFIER,
	@newStamp NVARCHAR(100),
	@newPass NVARCHAR(500)
)
AS
BEGIN
	UPDATE tblUser
	SET Stamp = @newStamp,
		[Password] = PWDENCRYPT(@newPass)
		
	WHERE UserId = @userId
END

GO
/****** Object:  StoredProcedure [dbo].[sp_User_Role_Insert]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_User_Role_Insert]
(
	@userId int,
	@listRole nvarchar(4000)
)
as
begin
	--delete all old role of employee
	delete from tblUserRole
	where UserId = @userId

	--add new role for employee
	insert into tblUserRole(UserId, RoleCode)
	select @userId, Data from fn_String_Split(@listRole, '|')
end

GO
/****** Object:  StoredProcedure [dbo].[sp_User_Select_Export]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_User_Select_Export]
as
begin
	select u.UserFullName, u.UserId
	from tblUser u
	where u.UserStatus <> 2 and IsAdmin <> 1
end	

GO
/****** Object:  StoredProcedure [dbo].[sp_User_Select_Page]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[sp_User_Select_Page] 
(
	@Search NVARCHAR(100),
	@Item INT
)
AS
BEGIN
	SELECT  CONVERT(INT, CEILING(CONVERT(MONEY, COUNT(s.UserId)) / @Item)) AS TotalPage, 
			COUNT(s.UserId) AS TotalRow
	FROM dbo.tblUser s
	WHERE s.UserStatus <> 2
		AND ISNULL(s.UserFullName, '') + ISNULL(s.Account, '') + ISNULL(CAST(s.UserNote AS NVARCHAR(20)), '') COLLATE SQL_Latin1_General_CP1_CI_AI LIKE '%' + @Search + '%' 
END	







GO
/****** Object:  StoredProcedure [dbo].[sp_User_Select_Stamp]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_User_Select_Stamp]
(
	@account NVARCHAR(100)
)
AS
BEGIN
	select Stamp
	from tblUser
	where Account = @account
		and UserStatus = 1
END

GO
/****** Object:  StoredProcedure [dbo].[sp_User_Select_Table]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_User_Select_Table]
(
	@Search NVARCHAR(100),
	@Order INT,
	@PageIndex INT,
	@Item INT
)
AS
BEGIN
	SELECT  @Item AS DefaultRows,
			s.UserId ,
            s.UserFullName ,
            s.Avatar ,
            s.Account ,
            s.UserNote ,
            s.UserStatus ,
            CONVERT(NVARCHAR(10), s.DateCreate, 103) AS DateCreate,
            s.IsAdmin
	FROM dbo.tblUser s

	WHERE s.UserStatus <> 2
		AND ISNULL(s.UserFullName, '') + ISNULL(s.Account, '') + ISNULL(CAST(s.UserNote AS NVARCHAR(20)), '') COLLATE SQL_Latin1_General_CP1_CI_AI LIKE '%' + @Search + '%' 
	ORDER BY CASE @Order WHEN 1 THEN s.UserFullName END,
			CASE @Order WHEN 2 THEN s.UserFullName END DESC,
			CASE @Order WHEN 3 THEN s.DateCreate END
			 
	OFFSET ( @PageIndex - 1 ) * @Item ROWS
	FETCH NEXT @Item ROWS ONLY;
END	








GO
/****** Object:  StoredProcedure [dbo].[sp_User_SelectId]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_User_SelectId]
(
	@userId UNIQUEIDENTIFIER
)
as
begin
	select u.UserId, u.UserFullName,
		u.Account, 
		u.Avatar,
		u.UserNote,
		u.IsAdmin
	from tblUser u 
	where u.UserStatus <> 2 and u.UserId = @userId
	order by DateCreate desc
end

GO
/****** Object:  StoredProcedure [dbo].[sp_User_Update]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_User_Update]
(
	@userId UNIQUEIDENTIFIER,
	@avatar nvarchar(250),
	@userFullName nvarchar(100),
	@userNote nvarchar(250),
	@isAdmin int
)
as
begin
	update tblUser
	set UserFullName = @userFullName,
		Avatar = @avatar,
		UserNote = @userNote,
		IsAdmin = @isAdmin
	where UserId = @userId
	
end

GO
/****** Object:  StoredProcedure [dbo].[sp_UserLogin]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_UserLogin] --'admin', '1'
(
	@account NVARCHAR(100),
	@PasswordHash NVARCHAR(500)
)
AS
BEGIN
	IF NOT EXISTS (
                      SELECT 1
                      FROM tblUser AS us
                      WHERE us.Account = @account
                            AND PWDCOMPARE(@PasswordHash, us.[Password]) = 1
                            AND us.UserStatus <> 2
                  )
        RAISERROR(N'Tài khoản hoặc mật khẩu không đúng', 16, 1)
    ELSE IF EXISTS (
					SELECT 1
                      FROM tblUser AS u
                      WHERE u.Account = @account
                            AND PWDCOMPARE(@PasswordHash, u.[Password]) = 1
                            AND u.UserStatus = 0
                   )
		RAISERROR(N'Tài khoản đang tạm khóa, vui lòng liên hệ quản trị viên', 16, 1)
    ELSE
    BEGIN
	--login success
		--select information
		SELECT u.UserId, u.UserFullName, u.UserNote, u.IsAdmin
				 
		FROM dbo.tblUser u
		WHERE u.Account = @account
				AND PWDCOMPARE(@PasswordHash, u.Password) = 1
				AND u.UserStatus = 1
		
    END
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Warehouse_Delete]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_Warehouse_Delete]
(
	@WareId UNIQUEIDENTIFIER,
	@CreateUser UNIQUEIDENTIFIER
)
AS
BEGIN
	UPDATE dbo.tblWare 
	SET WareStatus = 2

	WHERE WareId = @WareId 
END	








GO
/****** Object:  StoredProcedure [dbo].[sp_Warehouse_Insert]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_Warehouse_Insert",
-- WareCode, WareName, Unit, PriceIn, PriceSale, InStock, InStockRcm, Supplier, Note, clsGlobal.EmployeeId
CREATE PROCEDURE [dbo].[sp_Warehouse_Insert]
(
	@WareCode NCHAR(5), 
	@WareName NVARCHAR(250), 
	@UnitId UNIQUEIDENTIFIER,
	@PriceIn MONEY, 
	@PriceSale MONEY, 
	@InStock MONEY, 
	@InStockRcm MONEY, 
	@SupplierId UNIQUEIDENTIFIER, 
	@Note NVARCHAR(500), 
	@CreateUser UNIQUEIDENTIFIER
)
AS
BEGIN
	DECLARE @ExistCode BIT = 0
	IF EXISTS (SELECT 1 FROM dbo.tblWare WHERE WareCode = @WareCode AND WareStatus = 1)
	BEGIN SET @ExistCode = 1 END
	
	DECLARE @NewCode NCHAR(4)
	SELECT @NewCode = (SELECT dbo.fn_Create_WareCode(@WareName))

	IF @WareCode != '' SET @NewCode = @WareCode
	

	IF(@ExistCode = 1)
	BEGIN
		SELECT 2 AS MsgCode
	END
    ELSE
    BEGIN
		INSERT INTO tblWare(WareCode, WareName, UnitId, SupplierId, WarePriceIn, WarePriceSale, Quantity, QuantityRecommend, WareNote, DateUpdate)
		VALUES(@NewCode, @WareName, @UnitId, @SupplierId, @PriceIn, @PriceSale, @InStock, @InStockRcm, @Note, GETDATE())

		IF @@ROWCOUNT > 0
		BEGIN
			SELECT 1 AS MsgCode
		END
		ELSE
		BEGIN
			SELECT 0 AS MsgCode
		END
	END	
END
GO
/****** Object:  StoredProcedure [dbo].[sp_Warehouse_Select_Id]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Warehouse_Select_Id]
(
	@WareId UNIQUEIDENTIFIER
)
AS
BEGIN
	SELECT  x.WareId,
			x.WareCode,
			x.WareName,
			x.UnitId,
			x.SupplierId,
			x.WarePriceIn,
			x.WarePriceSale,
			x.Quantity,
			x.QuantityRecommend,
			x.WareNote
			
	FROM dbo.tblWare x

	WHERE x.WareId = @WareId 
END	








GO
/****** Object:  StoredProcedure [dbo].[sp_Warehouse_Select_Page]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[sp_Warehouse_Select_Page] 
(
	@Search NVARCHAR(100),
	@Item INT
)
AS
BEGIN
	SELECT  CONVERT(INT, CEILING(CONVERT(MONEY, COUNT(x.WareId)) / @Item)) AS TotalPage, 
			COUNT(x.WareId) AS TotalRow
	FROM dbo.tblWare x
	WHERE x.WareStatus = 1
		--AND ISNULL(p.ProductCode, '') + ISNULL(p.ProductName, '') + ISNULL(CAST(p.ProductPrice AS NVARCHAR(20)), '') COLLATE SQL_Latin1_General_CP1_CI_AI LIKE '%' + @Search + '%' 
END	







GO
/****** Object:  StoredProcedure [dbo].[sp_Warehouse_Select_Table]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Warehouse_Select_Table]
(
	@Search NVARCHAR(100),
	@Order NCHAR(2),
	@PageIndex INT,
	@Item INT
)
AS
BEGIN
	SELECT  @Item AS DefaultRows,
			x.WareId,
			x.WareCode,
			x.WareName,
			u.UnitName,
			x.WarePriceIn,
			x.Quantity,
			x.WareStatus,
			CONVERT(NVARCHAR(5), x.DateUpdate, 108) + ' : ' +  CONVERT(NVARCHAR(10), x.DateUpdate, 103) AS DateUpdate,
			CASE WHEN x.Quantity > x.QuantityRecommend THEN 'success'
				WHEN x.Quantity = x.QuantityRecommend THEN 'warning'
				WHEN x.Quantity < x.QuantityRecommend THEN 'danger' END AS xStatus
	FROM dbo.tblWare x
		LEFT JOIN dbo.tblSupplier s ON s.SupplierId = x.SupplierId
		LEFT JOIN dbo.tblUnit u ON u.UnitId = x.UnitId

	WHERE x.WareStatus = 1 
		--AND ISNULL(p.ProductCode, '') + ISNULL(p.ProductName, '') + ISNULL(CAST(p.ProductPrice AS NVARCHAR(20)), '') COLLATE SQL_Latin1_General_CP1_CI_AI LIKE '%' + @Search + '%' 
	ORDER BY CASE @Order WHEN '0a' THEN x.WareName END ASC,
				CASE @Order WHEN '0d' THEN x.WareName END DESC,
				CASE @Order WHEN '1a' THEN x.WarePriceIn END ASC,
				CASE @Order WHEN '1d' THEN x.WarePriceIn END DESC,
				CASE @Order WHEN '2a' THEN x.Quantity END ASC,
				CASE @Order WHEN '2d' THEN x.Quantity END DESC,
				CASE @Order WHEN '3a' THEN x.DateUpdate END ASC,
				CASE @Order WHEN '3d' THEN x.DateUpdate END DESC

			 
	OFFSET ( @PageIndex - 1 ) * @Item ROWS
	FETCH NEXT @Item ROWS ONLY;
END	








GO
/****** Object:  StoredProcedure [dbo].[sp_Warehouse_Update]    Script Date: 7/27/2022 11:07:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_Warehouse_Update]
(
	@WareId UNIQUEIDENTIFIER,
	@WareName NVARCHAR(250),
	@UnitId UNIQUEIDENTIFIER,
	@PriceIn MONEY, 
	@PriceSale MONEY, 
	@InStock MONEY, 
	@InStockRcm MONEY, 
	@SupplierId UNIQUEIDENTIFIER, 
	@Note NVARCHAR(500), 
	@CreateUser UNIQUEIDENTIFIER
)
AS
BEGIN
	UPDATE dbo.tblWare 
	SET WareName = @WareName,
		UnitId = @UnitId,
        SupplierId = @SupplierId,
        WarePriceIn = @PriceIn,
		WarePriceSale = @PriceSale,
		Quantity = @InStock,
		QuantityRecommend = @InStockRcm,
		WareNote = @Note

	WHERE WareId = @WareId 
END	








GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1. Thanh toán hóa đơn
2. Thanh toán lại hóa đơn
3. Lưu tạm hóa đơn
4. Lưu tạm lại hóa đơn
5. Hủy hóa đơn' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblActLog', @level2type=N'COLUMN',@level2name=N'ActLogCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'GUID của bảng có liên quan. (vd: bảng Hóa đơn, Nhập hàng ...)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblActLog', @level2type=N'COLUMN',@level2name=N'RelateId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 là Hóa đơn, 2 là Nhập hàng' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblActLog', @level2type=N'COLUMN',@level2name=N'RelateCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'giá trị thực của sản phẩm' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblInvoice', @level2type=N'COLUMN',@level2name=N'TotalPrice'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'giá trị  giảm giá' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblInvoice', @level2type=N'COLUMN',@level2name=N'SaleValue'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Loại giảm giá: 0: vnd, 1 %' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblInvoice', @level2type=N'COLUMN',@level2name=N'SaleType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'giá trị của hóa đơn(đã trừ giảm giá hoặc cộng thêm thu khác)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblInvoice', @level2type=N'COLUMN',@level2name=N'InvoiceValue'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0: chưa thanh toán, 1 đã thanh toán, 2: xóa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblInvoice', @level2type=N'COLUMN',@level2name=N'InvoiceStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'giá của hàng hóa tại thời điểm đó' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblInvoiceDetail', @level2type=N'COLUMN',@level2name=N'ProductPrice'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'giá bán thực tế của hàng hóa đó trong hóa đơn này' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblInvoiceDetail', @level2type=N'COLUMN',@level2name=N'SalePrice'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 hoat dong, 2 xoa, 0 khoa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblProduct', @level2type=N'COLUMN',@level2name=N'ProductStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 la hang hoa bt de ban, 1 la hang hoa trong kho' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblProduct', @level2type=N'COLUMN',@level2name=N'ForSale'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 hoat dong, 2 xoa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblProductCategory', @level2type=N'COLUMN',@level2name=N'ProductCategoryStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'newsequentialid()' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblWare', @level2type=N'COLUMN',@level2name=N'WareId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 hoat dong, 2 xoa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblWare', @level2type=N'COLUMN',@level2name=N'WareStatus'
GO
