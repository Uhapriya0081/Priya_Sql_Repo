USE [SF_STG]
GO

-- Drop the existing view if it exists
IF OBJECT_ID('dbo.v_IDX_Account_ActiveDir_V4_MER', 'V') IS NOT NULL
BEGIN
    DROP VIEW dbo.v_IDX_Account_ActiveDir_V4_MER;
END
GO

-- Create or recreate the view
CREATE VIEW [dbo].[v_IDX_Account_ActiveDir_V4_MER] AS 
SELECT DISTINCT
    o.SITS_Number__c AS Sits_Number,
    'INTO' + REPLACE(LTRIM(REPLACE(o.sits_number__c, '0', ' ')), ' ', '0') AS sAMAccountName,
    
    -- Determine userPrincipalName
    CASE 
        WHEN o.Term_Time_University_Email__c IS NOT NULL 
        THEN o.Term_Time_University_Email__c
        ELSE CASE 
                WHEN LEN(ISNULL(a.FirstName, '')) > 0 AND a.FirstName NOT LIKE '[.-]%' AND LEN(ISNULL(a.LastName, '')) > 0 AND a.LastName NOT LIKE '[.-]%'
                THEN LOWER(LEFT(REPLACE(REPLACE(a.FirstName, ' ', ''), '''', ''), 1) + '.' + REPLACE(REPLACE(REPLACE(REPLACE(a.LastName, ' ', ''), '-', ''), '''', ''), ' ', '') + RIGHT(o.sits_number__c, 4)) + '@my-into.com'
                WHEN LEN(ISNULL(a.FirstName, '')) > 0 AND a.FirstName NOT LIKE '[.-]%'
                THEN LOWER(REPLACE(REPLACE(REPLACE(a.FirstName, '-', ''), ' ', ''), '''', '') + RIGHT(o.sits_number__c, 4)) + '@my-into.com'
                WHEN LEN(ISNULL(a.LastName, '')) > 0 AND a.LastName NOT LIKE '[.-]%'
                THEN LOWER(REPLACE(REPLACE(REPLACE(a.LastName, '-', ''), ' ', ''), '''', '') + RIGHT(o.sits_number__c, 4)) + '@my-into.com'
                ELSE LOWER(RIGHT(o.sits_number__c, 4)) + '@my-into.com'
             END
    END AS UserPrincipalName,
    
    -- Determine mail
    CASE 
        WHEN o.Term_Time_University_Email__c IS NOT NULL 
        THEN o.Term_Time_University_Email__c
        ELSE CASE 
                WHEN LEN(ISNULL(a.FirstName, '')) > 0 AND a.FirstName NOT LIKE '[.-]%' AND LEN(ISNULL(a.LastName, '')) > 0 AND a.LastName NOT LIKE '[.-]%'
                THEN LOWER(LEFT(REPLACE(REPLACE(a.FirstName, ' ', ''), '''', ''), 1) + '.' + REPLACE(REPLACE(REPLACE(REPLACE(a.LastName, ' ', ''), '-', ''), '''', ''), ' ', '') + RIGHT(o.sits_number__c, 4)) + '@my-into.com'
                WHEN LEN(ISNULL(a.FirstName, '')) > 0 AND a.FirstName NOT LIKE '[.-]%'
                THEN LOWER(REPLACE(REPLACE(REPLACE(a.FirstName, '-', ''), ' ', ''), '''', '') + RIGHT(o.sits_number__c, 4)) + '@my-into.com'
                WHEN LEN(ISNULL(a.LastName, '')) > 0 AND a.LastName NOT LIKE '[.-]%'
                THEN LOWER(REPLACE(REPLACE(REPLACE(a.LastName, '-', ''), ' ', ''), '''', '') + RIGHT(o.sits_number__c, 4)) + '@my-into.com'
                ELSE LOWER(RIGHT(o.sits_number__c, 4)) + '@my-into.com'
             END
    END AS Mail,

    -- Determine SuggestedEmail based on conditions
    CASE 
        WHEN o.Term_Time_University_Email__c IS NOT NULL 
        THEN ''
        WHEN LEN(ISNULL(a.FirstName, '')) > 0 AND a.FirstName NOT LIKE '[.-]%' AND LEN(ISNULL(a.LastName, '')) > 0 AND a.LastName NOT LIKE '[.-]%'
        THEN LOWER(LEFT(REPLACE(REPLACE(a.FirstName, ' ', ''), '''', ''), 1) + '.' + REPLACE(REPLACE(REPLACE(REPLACE(a.LastName, ' ', ''), '-', ''), '''', ''), ' ', '') + RIGHT(o.sits_number__c, 4)) + '@my-into.com'
        WHEN LEN(ISNULL(a.FirstName, '')) > 0 AND a.FirstName NOT LIKE '[.-]%'
        THEN LOWER(REPLACE(REPLACE(REPLACE(a.FirstName, '-', ''), ' ', ''), '''', '') + RIGHT(o.sits_number__c, 4)) + '@my-into.com'
        WHEN LEN(ISNULL(a.LastName, '')) > 0 AND a.LastName NOT LIKE '[.-]%'
        THEN LOWER(REPLACE(REPLACE(REPLACE(a.LastName, '-', ''), ' ', ''), '''', '') + RIGHT(o.sits_number__c, 4)) + '@my-into.com'
        ELSE LOWER(RIGHT(o.sits_number__c, 4)) + '@my-into.com'
    END AS SuggestedEmail,

    -- Other columns
    CASE 
        WHEN a.FirstName IS NOT NULL AND a.FirstName NOT LIKE '[.-]%' 
        THEN REPLACE(REPLACE(ISNULL(a.FirstName, ''), '-', ''), '.', '')
        ELSE ''
    END AS GivenName,

    CASE 
        WHEN a.LastName IS NOT NULL AND a.LastName NOT LIKE '[.-]%' 
        THEN REPLACE(REPLACE(ISNULL(a.LastName, ''), '-', ''), '.', '')
        ELSE ''
    END AS Sn,

    LTRIM(REPLACE(REPLACE(REPLACE(ISNULL(a.FirstName, '') + ' ' + ISNULL(a.LastName, ''), '-', ''), '.', ''), '*', '')) AS DisplayName,
    
    p.Course_Title__c AS [Description], -- Use Product2.Course_Title__c directly
    p.start_date__c AS Start_Date,      -- Use Product2.start_date__c directly
    p.End_Date__c AS End_Date,          -- Use Product2.End_Date__c directly
    DATEADD(DAY, 90, p.End_Date__c) AS AccountExpires, -- Use Product2.End_Date__c directly
    'Account Expires: ' + CONVERT(VARCHAR, DATEADD(DAY, 90, p.End_Date__c), 103) AS Department, -- Use Product2.End_Date__c directly
    'INTOpass!' + REPLACE(CONVERT(VARCHAR(20), ISNULL(a.Date_of_Birth__c, '1900-01-01'), 103), '/', '') AS [Password],
    'INTO' + REPLACE(LTRIM(REPLACE(o.sits_number__c, '0', ' ')), ' ', '0') AS MailNickname,
    ISNULL(c.Registration_Status_Code__c, '') AS Registration_Status_Code__c,
    o.Centre_MIS_Code__c AS Centre
    
FROM SFUK.dbo.Opportunity AS o 
JOIN SFUK.dbo.Account AS a ON o.accountid = a.id
JOIN SFUK.dbo.Courses__c AS c ON o.id = c.Study_Plan__c
JOIN SFUK.dbo.Caf_Plus__c AS cp ON c.id = cp.Course_Applied_For__c
JOIN SFUK.dbo.Product2 p ON c.course_name__c = p.id 
FULL OUTER JOIN SF_STG.dbo.STG_IDX_Account_In AS ia ON ia.university_student_code = o.University_Student_Code__c
FULL OUTER JOIN SF_STG.dbo.STG_IDX_Ebook_In AS eb ON eb.Sits_Number = o.SITS_Number__c
LEFT JOIN IDX_Account_In_Audit aud ON o.AccountId = aud.sf_Account_Id
WHERE o.INTO_Centre_Country__c = 'UK' 
  AND o.Centre_MIS_Code__c IN ('LON', 'MER', 'WEC')
  AND o.recordtypeid != '01230000001aE33AAE';
GO
