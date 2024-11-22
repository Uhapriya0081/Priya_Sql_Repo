-- Drop the view if it exists
IF OBJECT_ID('dbo.V_Late_Enrollment_Programme', 'V') IS NOT NULL
    DROP VIEW dbo.V_Late_Enrollment_Programme;
GO

CREATE VIEW [dbo].[V_Late_Enrollment_Programme] AS
SELECT 
    a.FirstName AS [First_name],
    a.LastName AS [Surname],
    p.Start_Date__c,
    a.PersonEmail AS [Email_Address],
    o.[Centre_MIS_Code__c] AS [Centre_Applied_To], -- INTO_Center_Long_Name__c
    country.Name AS [Country_Region],  -- Updated to get country name
    p.Course_Title__c AS [Course_Applied_For],
    c.Progression_Title__c AS [Progression_Choice],
    a.Unique_Institution_ID__c AS [Username],
    a.Account_ID_18__c AS [Password],
    o.StageName AS [Stage],
    c.latest_decision__c as latest_decision__c,
    c.latest_response__c as latest_response__c
FROM 
    SFUK.[dbo].[Opportunity] AS o
INNER JOIN 
    SFUK.[dbo].[Account] AS a ON o.AccountId = a.Id
LEFT JOIN 
    SFUK.[dbo].[Courses__c] AS c ON o.Id = c.Study_Plan__c
LEFT JOIN 
    SFUK.[dbo].[Product2] AS p ON c.Course_Name__c = p.Id
LEFT JOIN 
    SFUK.[dbo].[Country__c] AS country ON a.Country_of_Residence__c = country.ID -- Join to get country name
WHERE 
    o.RecordTypeId = '01230000000Zw3aAAC'
    AND o.Centre_MIS_Code__c IN ('CIT', 'EXE', 'LAN', 'MAN', 'MER', 'NAL', 'NCL', 'QUB', 'STS', 'UEA', 'LON')
    AND (c.latest_decision__c = 'Conditional' OR c.latest_decision__c = 'Unconditional')  -- New condition
    AND c.latest_response__c IN ('Deposit Paid', 'Full Fees', '1st Instalment Paid', 'Sponsor Letter', 'Letter of Guarantee') -- New condition
    AND ISNULL(o.StageName , '') LIKE 'Student Confirmed';
