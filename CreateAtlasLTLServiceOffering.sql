USE [AtlasIntegrations]
GO

/****** Object:  StoredProcedure [Integration].[CreateAtlasLTLServiceOffering]    Script Date: 7/20/2018 9:09:37 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Integration].[CreateAtlasLTLServiceOffering]
AS
    BEGIN
        DECLARE @currentDate DATETIME2;
        SET @currentDate = GETUTCDATE();

        MERGE Carrier.LTLCarrierServiceOffering.LTLServiceOffering AS TARGET
        USING
            ( SELECT    CSOM.SourceKey ,
                        CSOM.AtlasKey
              FROM      Staging.Carrier AS c
                        INNER JOIN AntiCorruptionStore.DomainMap.LTLCarrierServiceOfferingMap AS CSOM ON c.CarrierGuid = CSOM.SourceKey
              WHERE     c.VendorTypeID = 2
            ) AS Source ( SourceKey, AtlasKey )
        ON ( TARGET.CarrierKey = Source.SourceKey )
        WHEN NOT MATCHED THEN
            INSERT ( CarrierKey ,
                     APITenderSupported ,
                     EDITenderSupported ,
                     APITrackingSupported ,
                     Version ,
                     SystemIsDeleted ,
                     SystemCreatedDate ,
                     SystemCreatedBy ,
                     SystemModifiedDate ,
                     SystemModifiedBy
                   )
            VALUES ( Source.AtlasKey ,
                     0 ,
                     0 ,
                     0 ,
                     1 ,
                     0 ,
                     @currentDate ,
                     'System' ,
                     @currentDate ,
                     'System'
                   ); 

        SELECT  @@ROWCOUNT AS AtlasCarrierLTLServiceOffering;
    END;


GO


