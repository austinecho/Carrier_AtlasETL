USE [AtlasIntegrations]
GO

/****** Object:  StoredProcedure [Integration].[CreateACSCarrierAccountMap]    Script Date: 7/20/2018 9:08:31 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Integration].[CreateACSCarrierAccountMap]
AS
BEGIN
	
	DECLARE @Date DATETIME2 = GETUTCDATE()

	MERGE AntiCorruptionStore.DomainMap.CarrierAccountMap AS Target
	USING (
		SELECT CarrierGuid
		FROM Staging.Carrier
		WHERE VendorTypeId IN (1,2) -- TL and LTL Carriers
	) AS Source (CarrierGuid)
	ON (Target.SourceKey = Source.CarrierGuid)
	WHEN NOT MATCHED THEN
		INSERT (SourceKey, CorrelationId, AtlasKey, SourceSystemId, SystemCreatedDate, SystemModifiedDate)
		VALUES (Source.CarrierGuid, NEWID(), NEWID(), 1, @Date, @Date);
END
GO


