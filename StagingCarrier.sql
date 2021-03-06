USE [AtlasIntegrations]
GO

/****** Object:  Table [Staging].[Carrier]    Script Date: 7/20/2018 9:08:06 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Staging].[Carrier](
	[ID] [INT] IDENTITY(1,1) NOT NULL,
	[CarrierGuid] [UNIQUEIDENTIFIER] NULL,
	[CarrierName] [VARCHAR](100) NULL,
	[SCAC] [VARCHAR](6) NULL,
	[MCNumber] [VARCHAR](20) NULL,
	[USDOT] [VARCHAR](15) NULL,
	[IntraState] [VARCHAR](20) NULL,
	[TrackingTypeID] [INT] NULL,
	[VendorTypeID] [INT] NULL,
 CONSTRAINT [PK_Staging_Carrier] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


