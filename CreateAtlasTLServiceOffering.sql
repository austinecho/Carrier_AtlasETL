USE [AtlasIntegrations]
GO

/****** Object:  StoredProcedure [Integration].[CreateAtlasTLServiceOffering]    Script Date: 7/20/2018 9:09:51 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Integration].[CreateAtlasTLServiceOffering]
AS
    BEGIN
        DECLARE @currentDate DATETIME2;
        SET @currentDate = GETUTCDATE();

        MERGE Carrier.TLCarrierServiceOffering.TLServiceOffering AS TARGET
        USING
            ( SELECT    CSOM.SourceKey ,
                        CSOM.AtlasKey ,
                        --CASE WHEN c.TrackingTypeID = 4 THEN 'ELD'
                        --     WHEN c.TrackingTypeID = 5 THEN 'Appless'
                        --     WHEN c.TrackingTypeID = 6 THEN 'Trailer'
                        --     WHEN c.TrackingTypeID = 7 THEN 'TMS'
                        --     ELSE 'None'
                        --END AS PreferredTrackingMethod,
						c.TrackingTypeID AS PreferredTrackingMethod,
						CASE WHEN c.TrackingTypeID IN (1,2,3,8) THEN 0
							 WHEN c.TrackingTypeID IN (4, 5, 6, 7) THEN 1
						END AS IsAutomatedTrackingEnabled
              FROM      Staging.Carrier AS c
                        INNER JOIN AntiCorruptionStore.DomainMap.TLCarrierServiceOfferingMap AS CSOM ON c.CarrierGuid = CSOM.SourceKey
              WHERE     c.VendorTypeID = 1
            ) AS Source ( SourceKey, AtlasKey, PreferredTrackingMethod, IsAutomatedTrackingEnabled )
        ON ( TARGET.CarrierKey = Source.SourceKey )
        WHEN NOT MATCHED THEN
            INSERT ( CarrierKey ,
                     PreferredTrackingMethodID,
					 IsAutomatedTrackingEnabled,
                     Version ,
                     SystemIsDeleted ,
                     SystemCreatedDate ,
                     SystemCreatedBy ,
                     SystemModifiedDate ,
                     SystemModifiedBy
                   )
            VALUES ( Source.AtlasKey ,
                     Source.PreferredTrackingMethod ,
                     Source.IsAutomatedTrackingEnabled ,
                     1 ,
                     0 ,
                     @currentDate ,
                     'System' ,
                     @currentDate ,
                     'System'
                   ); 

        SELECT  @@ROWCOUNT AS AtlasCarrierTLServiceOffering;
    END;


GO


