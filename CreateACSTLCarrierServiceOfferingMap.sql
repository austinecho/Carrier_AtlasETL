USE [AtlasIntegrations]
GO

/****** Object:  StoredProcedure [Integration].[CreateACSTLCarrierServiceOfferingMap]    Script Date: 7/20/2018 9:09:09 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Integration].[CreateACSTLCarrierServiceOfferingMap]
AS
BEGIN

	DECLARE @Date DATETIME2 = GETUTCDATE()

	MERGE AntiCorruptionStore.DomainMap.TLCarrierServiceOfferingMap AS Target
	USING (
		SELECT SourceKey, AtlasKey
		FROM AntiCorruptionStore.DomainMap.CarrierAccountMap AS CSO
		INNER JOIN AtlasIntegrations.Staging.Carrier AS C
		ON CSO.SourceKey = C.CarrierGuid
		WHERE C.VendorTypeID = 1 -- Only TL Carriers 
	) AS Source (SourceKey, AtlasKey)
	ON (Target.SourceKey = Source.SourceKey)
	WHEN NOT MATCHED THEN
		INSERT (SourceKey, CorrelationId, AtlasKey, SourceSystemId, SystemCreatedDate, SystemModifiedDate)
		VALUES (Source.SourceKey, NEWID(), Source.AtlasKey, 1, @Date, @Date);
END

GO


