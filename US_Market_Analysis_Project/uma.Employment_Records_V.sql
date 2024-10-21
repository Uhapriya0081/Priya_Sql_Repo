-- Ensure you are in the correct database context
USE [BI_UMA];
GO

-- Drop the view if it exists
IF OBJECT_ID('uma.Employment_Records_V', 'V') IS NOT NULL
BEGIN
    DROP VIEW [uma].[Employment_Records_V];
END
GO

-- Create the view within the schema
CREATE VIEW [uma].[Employment_Records_V] AS
SELECT 
f.PK_ID,
f.FK_Individual_ID,
f.Individual_Key,
f.Student_Key,  
f.Year,
School_Name = kv1.KeyValue,
Campus_City = kv2.KeyValue,
Campus_State = kv3.KeyValue,
f.Major_1_CIP_Code,
Employer_Name = kv4.KeyValue,
Employer_City= kv5.KeyValue,
Employer_State = kv6.KeyValue,
f.Employer_Zip_Code,
Job_Title = kv7.KeyValue,
Employment_Description = kv8.KeyValue,
f.Authorization_Start_Date,
f.Authorization_End_Date,
f.OPT_Authorization_Start_Date, 
f.OPT_Authorization_End_Date, 
f.OPT_Employer_Start_Date, 
f.OPT_Employer_End_Date, 
Employment_OPT_Type = kv9.KeyValue,
f.Employment_Time,
f.Unemployment_Days,
f.On_Campus_Employment,
Requested_Status = kv10.KeyValue
FROM 
[uma].[Employment_Records_Fact] f
    LEFT JOIN uma.KeyValues kv1 ON kv1.DataId = f.School_Name
    LEFT JOIN uma.KeyValues kv2 ON kv2.DataId = f.Campus_City
    LEFT JOIN uma.KeyValues kv3 ON kv3.DataId = f.Campus_State
    LEFT JOIN uma.KeyValues kv4 ON kv4.DataId = f.Employer_Name
    LEFT JOIN uma.KeyValues kv5 ON kv5.DataId = f.Employer_City
	LEFT JOIN uma.KeyValues kv6 ON kv6.DataId = f.Employer_State
    LEFT JOIN uma.KeyValues kv7 ON kv7.DataId = f.Job_Title
    LEFT JOIN uma.KeyValues kv8 ON kv8.DataId = f.Employment_Description
    LEFT JOIN uma.KeyValues kv9 ON kv9.DataId = f.Employment_OPT_Type
    LEFT JOIN uma.KeyValues kv10 ON kv10.DataId = f.Requested_Status
;


	
