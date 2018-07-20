USE [AtlasIntegrations]
GO

/****** Object:  StoredProcedure [Staging].[TruncateCarrier]    Script Date: 7/20/2018 9:10:07 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Staging].[TruncateCarrier]

AS

BEGIN

TRUNCATE TABLE Staging.Carrier

END

GO


