
-- Ensure you are in the correct database context
USE [BI_UMA];
GO

-- Drop the view if it exists
IF OBJECT_ID('uma.Individual_V', 'V') IS NOT NULL
BEGIN
    DROP VIEW [uma].[Individual_Fact_View];
END
GO

-- Create the view within the schema
CREATE VIEW [uma].[Individual_V] AS
SELECT 
    f.[PK_ID],
    f.[Individual_Key],
    f.[Year], 
    Country_of_Birth = Kv1.KeyValue,--
    Country_of_Citizenship = Kv2.KeyValue,--
    f.[First_Entry_Date],
    f.[Last_Entry_Date],
    f.[Last_Departure_Date],
    Class_of_Admission = Kv3.KeyValue,--
    f.[Visa_Issue_Date],
    f.[Visa_Expiration_Date],
    f.[DistinctEnrolmentsCount],
    f.[DistinctEmploymentCount],
    f.[MIN_record_ID],
    f.[MAX_record_ID]
FROM 
    [uma].[Individual_Fact] f
    LEFT JOIN uma.KeyValues kv1 ON kv1.DataId = f.[Country_of_Birth]
    LEFT JOIN uma.KeyValues kv2 ON kv2.DataId = f.[Country_of_Citizenship]
    LEFT JOIN uma.KeyValues kv3 ON kv3.DataId = f.[Class_of_Admission];


