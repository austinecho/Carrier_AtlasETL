USE [AtlasIntegrations]
GO

/****** Object:  StoredProcedure [Integration].[CreateAtlasCarrierAccount]    Script Date: 7/20/2018 9:09:22 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Integration].[CreateAtlasCarrierAccount]
AS
BEGIN
	DECLARE @currentDate DATETIME2
	SET @currentDate = GETUTCDATE()

	MERGE Carrier.CarrierAccount.Account AS TARGET
	USING (
		SELECT cam.SourceKey, cam.AtlasKey, c.CarrierName, c.SCAC, c.MCNumber, c.USDOT, c.IntraState
		FROM Staging.Carrier c
		INNER JOIN AntiCorruptionStore.DomainMap.CarrierAccountMap cam ON c.CarrierGuid = cam.SourceKey
		WHERE C.VendorTypeID IN (1,2)
	) AS Source (SourceKey, AtlasKey, CarrierName, SCAC, MCNumber, USDOT, IntraState)
	ON (Target.CarrierKey = Source.SourceKey)
	WHEN NOT MATCHED THEN
		INSERT (CarrierKey, Name, SCAC, MCNumber, USDOTNumber, IntraStateNumber, Version, SystemIsDeleted, SystemCreatedDate, SystemCreatedBy, SystemModifiedDate, SystemModifiedBy )
		VALUES (source.AtlasKey, Source.CarrierName, Source.SCAC, Source.MCNumber, Source.USDOT, Source.IntraState, 1, 0, @currentDate, 'System', @currentDate, 'System'); 

	SELECT @@ROWCOUNT AS AtlasCarrierAccountRowCount;
END


GO


