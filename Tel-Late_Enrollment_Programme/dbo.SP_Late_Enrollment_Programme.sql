-- Drop the stored procedure if it exists
IF OBJECT_ID('dbo.SP_Late_Enrollment_Programme', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_Late_Enrollment_Programme;
GO

CREATE PROCEDURE dbo.SP_Late_Enrollment_Programme
AS
BEGIN
    -- Use ROW_NUMBER() to select distinct rows based on grouped columns
    WITH RankedData AS (
        SELECT 
            [First_name],
            [Surname],
            FORMAT(Start_Date__c, 'yyyy-MM-dd') AS [Start_Date__c],  -- Convert to yyyy-mm-dd
            [Email_Address],
            [Centre_Applied_To],
            [Country_Region],  -- Added missing comma here
            REPLACE([Course_Applied_For], ',', '&') AS [Course_Applied_For],  
            REPLACE([Progression_Choice], ',', '') AS [Progression_Choice],  -- Remove commas from Progression_Choice
            [Username],
            [Password],
            [Stage],
            ROW_NUMBER() OVER (
                PARTITION BY [First_name], [Surname], Start_Date__c, [Email_Address], 
                             [Centre_Applied_To], [Country_Region], [Course_Applied_For], 
                             [Progression_Choice]
                ORDER BY [First_name] -- Minimal ordering to ensure deterministic results
            ) AS RowNum
        FROM 
            dbo.V_Late_Enrollment_Programme
        WHERE 
            ISNULL(Stage, '') LIKE 'Student Confirmed'
            AND [Start_Date__c] >= '2025-01-06'
    )
    -- Select only the first row for each partition
    SELECT 
        [First_name],
        [Surname],
        [Start_Date__c],  -- Now this is returned as a date without time
        [Email_Address],
        [Centre_Applied_To],
        [Country_Region],
        [Course_Applied_For],
        [Progression_Choice],
        [Username],
        [Password],
        [Stage]
    FROM 
        RankedData
    WHERE 
        RowNum = 1;
END
GO

-- Execute the stored procedure
EXEC dbo.SP_Late_Enrollment_Programme;
