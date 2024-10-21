-- Ensure you are in the correct database context
USE [BI_UMA];
GO

-- Drop the view if it exists
IF OBJECT_ID('uma.Course_Enrollment_V', 'V') IS NOT NULL
BEGIN
    DROP VIEW [uma].[Course_Enrollment_V];
END
GO

-- Create the view within the schema
CREATE VIEW [uma].[Course_Enrollment_V] AS
SELECT 
    f.PK_ID,
    f.FK_Individual_ID,
    f.Individual_Key,
    f.Student_Key,
    f.Year,
    School_Name = kv1.KeyValue,
    Campus_City = kv2.KeyValue ,
    Campus_State = kv3.KeyValue ,
    f.Campus_Zip_Code,
    f.Major_1_CIP_Code,  
    Major_1_Description = kv5.KeyValue,
    f.Major_2_CIP_Code,
    Major_2_Description = kv6.KeyValue,
    f.Minor_CIP_Code,
    Minor_Description = kv7.KeyValue,
    f.Program_Start_Date,
    f.Program_End_Date,
    f.Tuition_Fees,
    f.Student_s_Personal_Funds,
    f.Funds_From_This_School,
    f.Funds_from_Other_Sources,
    Status_Code = kv8.KeyValue,
    Student_Edu_Level_Desc = kv9.KeyValue,
	f.[MIN_record_ID],
	f.[MAX_record_ID]
FROM 
    [uma].[Course_Enrollment_Fact] f 
    LEFT JOIN uma.KeyValues kv1 ON kv1.DataId = f.School_Name 
    LEFT JOIN uma.KeyValues kv2 ON kv2.DataId = f.Campus_City 
    LEFT JOIN uma.KeyValues kv3 ON kv3.DataId = f.Campus_State  
    LEFT JOIN uma.KeyValues kv5 ON kv5.DataId = f.Major_1_Description 
    LEFT JOIN uma.KeyValues kv6 ON kv6.DataId = f.Major_2_Description 
    LEFT JOIN uma.KeyValues kv7 ON kv7.DataId = f.Minor_Description
    LEFT JOIN uma.KeyValues kv8 ON kv8.DataId = f.Status_Code
    LEFT JOIN uma.KeyValues kv9 ON kv9.DataId = f.Student_Edu_Level_Desc; 
GO

