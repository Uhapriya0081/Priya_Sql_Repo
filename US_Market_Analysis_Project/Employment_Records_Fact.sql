-- Drop the table if it already exists
DROP TABLE IF EXISTS [BI_UMA].[uma].[Employment_Records_Fact];

-- Create fact table from scratch
CREATE TABLE [BI_UMA].[uma].[Employment_Records_Fact] (
    PK_ID BIGINT IDENTITY(1,1) PRIMARY KEY,
    FK_Individual_ID BIGINT NOT NULL,  -- Foreign key reference to Individual_Fact
    Individual_Key INT NOT NULL,
    Student_Key INT NOT NULL,
    Year INT NOT NULL,
    School_Name INT NULL,  -- Changed to INT
    Campus_City INT NULL,  -- Changed to INT
    Campus_State INT NULL,  -- Changed to INT
    Major_1_CIP_Code float NULL,  -- Changed to INT
    Employer_Name INT,  -- Changed to INT
    Employer_City INT,  -- Changed to INT
    Employer_State INT,  -- Changed to INT
    Employer_Zip_Code nvarchar(50),  -- Changed to INT
    Job_Title INT,  -- Changed to INT
    Employment_Description INT,  -- Changed to INT
    Authorization_Start_Date DATE,
    Authorization_End_Date DATE,
    OPT_Authorization_Start_Date DATE,  -- Populated only when Employment Description = 165657
    OPT_Authorization_End_Date DATE,    -- Populated only when Employment Description = 165657
    OPT_Employer_Start_Date DATE,       -- Populated only when Employment Description = 165657
    OPT_Employer_End_Date DATE,         -- Populated only when Employment Description = 165657
    Employment_OPT_Type INT,   -- Changed to INT
    Employment_Time INT,       -- Changed to INT
    Unemployment_Days INT,
    On_Campus_Employment decimal(18,5),
    Requested_Status INT,   -- Changed to INT
    MIN_record_ID INT NOT NULL,
    MAX_record_ID INT NOT NULL
);

-- Create indexes for specific columns based on importance
CREATE NONCLUSTERED INDEX IDX_EmploymentRecordsFact_Authorization_Start_Date ON [BI_UMA].[uma].[Employment_Records_Fact](Authorization_Start_Date);
CREATE NONCLUSTERED INDEX IDX_EmploymentRecordsFact_Authorization_End_Date ON [BI_UMA].[uma].[Employment_Records_Fact](Authorization_End_Date);
CREATE NONCLUSTERED INDEX IDX_EmploymentRecordsFact_OPT_Authorization_Start_Date ON [BI_UMA].[uma].[Employment_Records_Fact](OPT_Authorization_Start_Date);
CREATE NONCLUSTERED INDEX IDX_EmploymentRecordsFact_OPT_Authorization_End_Date ON [BI_UMA].[uma].[Employment_Records_Fact](OPT_Authorization_End_Date);
CREATE NONCLUSTERED INDEX IDX_EmploymentRecordsFact_OPT_Employer_Start_Date ON [BI_UMA].[uma].[Employment_Records_Fact](OPT_Employer_Start_Date);
CREATE NONCLUSTERED INDEX IDX_EmploymentRecordsFact_OPT_Employer_End_Date ON [BI_UMA].[uma].[Employment_Records_Fact](OPT_Employer_End_Date);



-- Combine data from multiple years

-- Combine data from multiple years
WITH Combined AS (
    SELECT 
        Individual_Key, 
        Student_Key,
        Year,
        School_Name,
        Campus_City,
        Campus_State,
        Major_1_CIP_Code,
        Employer_Name,
        Employer_City,
        Employer_State,
        Employer_Zip_Code,
        Job_Title,
        Employment_Description,
        Authorization_Start_Date,
        Authorization_End_Date,
        OPT_Authorization_Start_Date,
        OPT_Authorization_End_Date,
        OPT_Employer_Start_Date,
        OPT_Employer_End_Date,
        Employment_OPT_Type,
        Employment_Time,
        Unemployment_Days,
        On_Campus_Employment,
        Requested_Status,
        PK_ID
    FROM (
        SELECT Individual_Key, Student_Key, School_Name, Campus_City, Campus_State, Major_1_CIP_Code,
               Employer_Name, Employer_City, Employer_State, Employer_Zip_Code, Job_Title,
               Employment_Description, Authorization_Start_Date, Authorization_End_Date,
               OPT_Authorization_Start_Date, OPT_Authorization_End_Date, OPT_Employer_Start_Date,
               OPT_Employer_End_Date, Employment_OPT_Type, Employment_Time, Unemployment_Days,
               On_Campus_Employment, Requested_Status, 2017 AS Year, PK_ID
        FROM [BI_UMA].[uma].[US_Market_Analysis_2017]
        UNION ALL
        SELECT Individual_Key, Student_Key, School_Name, Campus_City, Campus_State, Major_1_CIP_Code,
               Employer_Name, Employer_City, Employer_State, Employer_Zip_Code, Job_Title,
               Employment_Description, Authorization_Start_Date, Authorization_End_Date,
               OPT_Authorization_Start_Date, OPT_Authorization_End_Date, OPT_Employer_Start_Date,
               OPT_Employer_End_Date, Employment_OPT_Type, Employment_Time, Unemployment_Days,
               On_Campus_Employment, Requested_Status, 2018 AS Year, PK_ID
        FROM [BI_UMA].[uma].[US_Market_Analysis_2018]
        -- Add similar SELECT statements for other years as needed
		UNION ALL
        SELECT Individual_Key, Student_Key, School_Name, Campus_City, Campus_State, Major_1_CIP_Code,
               Employer_Name, Employer_City, Employer_State, Employer_Zip_Code, Job_Title,
               Employment_Description, Authorization_Start_Date, Authorization_End_Date,
               OPT_Authorization_Start_Date, OPT_Authorization_End_Date, OPT_Employer_Start_Date,
               OPT_Employer_End_Date, Employment_OPT_Type, Employment_Time, Unemployment_Days,
               On_Campus_Employment, Requested_Status, 2019 AS Year, PK_ID
        FROM [BI_UMA].[uma].[US_Market_Analysis_2019]
		UNION ALL
        SELECT Individual_Key, Student_Key, School_Name, Campus_City, Campus_State, Major_1_CIP_Code,
               Employer_Name, Employer_City, Employer_State, Employer_Zip_Code, Job_Title,
               Employment_Description, Authorization_Start_Date, Authorization_End_Date,
               OPT_Authorization_Start_Date, OPT_Authorization_End_Date, OPT_Employer_Start_Date,
               OPT_Employer_End_Date, Employment_OPT_Type, Employment_Time, Unemployment_Days,
               On_Campus_Employment, Requested_Status, 2020 AS Year, PK_ID
        FROM [BI_UMA].[uma].[US_Market_Analysis_2020]
		UNION ALL
        SELECT Individual_Key, Student_Key, School_Name, Campus_City, Campus_State, Major_1_CIP_Code,
               Employer_Name, Employer_City, Employer_State, Employer_Zip_Code, Job_Title,
               Employment_Description, Authorization_Start_Date, Authorization_End_Date,
               OPT_Authorization_Start_Date, OPT_Authorization_End_Date, OPT_Employer_Start_Date,
               OPT_Employer_End_Date, Employment_OPT_Type, Employment_Time, Unemployment_Days,
               On_Campus_Employment, Requested_Status, 2021 AS Year, PK_ID
        FROM [BI_UMA].[uma].[US_Market_Analysis_2021]
		UNION ALL
        SELECT Individual_Key, Student_Key, School_Name, Campus_City, Campus_State, Major_1_CIP_Code,
               Employer_Name, Employer_City, Employer_State, Employer_Zip_Code, Job_Title,
               Employment_Description, Authorization_Start_Date, Authorization_End_Date,
               OPT_Authorization_Start_Date, OPT_Authorization_End_Date, OPT_Employer_Start_Date,
               OPT_Employer_End_Date, Employment_OPT_Type, Employment_Time, Unemployment_Days,
               On_Campus_Employment, Requested_Status, 2022 AS Year, PK_ID
        FROM [BI_UMA].[uma].[US_Market_Analysis_2022]
		UNION ALL
        SELECT Individual_Key, Student_Key, School_Name, Campus_City, Campus_State, Major_1_CIP_Code,
               Employer_Name, Employer_City, Employer_State, Employer_Zip_Code, Job_Title,
               Employment_Description, Authorization_Start_Date, Authorization_End_Date,
               OPT_Authorization_Start_Date, OPT_Authorization_End_Date, OPT_Employer_Start_Date,
               OPT_Employer_End_Date, Employment_OPT_Type, Employment_Time, Unemployment_Days,
               On_Campus_Employment, Requested_Status, 2023 AS Year, PK_ID
        FROM [BI_UMA].[uma].[US_Market_Analysis_2023]
    ) AS CombinedData
),
AggregatedData AS (
    SELECT 
        Individual_Key, 
        Student_Key,
        Year,
        School_Name, 
        Campus_City, 
        Campus_State, 
        Major_1_CIP_Code,
        Employer_Name,
        Employer_City,
        Employer_State,
        Employer_Zip_Code,
        Job_Title,
        Employment_Description,
        Authorization_Start_Date,
        Authorization_End_Date,
        OPT_Authorization_Start_Date,
        OPT_Authorization_End_Date,
        OPT_Employer_Start_Date,
        OPT_Employer_End_Date,
        Employment_OPT_Type,
        Employment_Time,
        Unemployment_Days,
        On_Campus_Employment,
        Requested_Status,
        MIN(PK_ID) AS MIN_record_ID, 
        MAX(PK_ID) AS MAX_record_ID,
        -- Reference FK from Individual_Fact table
        (SELECT TOP 1 PK_ID FROM [BI_UMA].[uma].[Individual_Fact] WHERE Individual_Key = Combined.Individual_Key AND Year = Combined.Year) AS FK_Individual_ID 
    FROM Combined
    GROUP BY 
        Individual_Key, 
        Student_Key, 
        Year, 
        School_Name, 
        Campus_City, 
        Campus_State, 
        Major_1_CIP_Code,
        Employer_Name,
        Employer_City,
        Employer_State,
        Employer_Zip_Code,
        Job_Title,
        Employment_Description,
        Authorization_Start_Date,
        Authorization_End_Date,
        OPT_Authorization_Start_Date,
        OPT_Authorization_End_Date,
        OPT_Employer_Start_Date,
        OPT_Employer_End_Date,
        Employment_OPT_Type,
        Employment_Time,
        Unemployment_Days,
        On_Campus_Employment,
        Requested_Status
)
-- Insert the results into the fact table
INSERT INTO [BI_UMA].[uma].[Employment_Records_Fact] (
    Individual_Key, 
    Student_Key,
    Year,
    School_Name, 
    Campus_City, 
    Campus_State, 
    Major_1_CIP_Code,
    Employer_Name,
    Employer_City,
    Employer_State,
    Employer_Zip_Code,
    Job_Title,
    Employment_Description,
    Authorization_Start_Date,
    Authorization_End_Date,
    OPT_Authorization_Start_Date,
    OPT_Authorization_End_Date,
    OPT_Employer_Start_Date,
    OPT_Employer_End_Date,
    Employment_OPT_Type,
    Employment_Time,
    Unemployment_Days,
    On_Campus_Employment,
    Requested_Status,
    MIN_record_ID, 
    MAX_record_ID,
    FK_Individual_ID
)
SELECT 
    Individual_Key, 
    Student_Key,
    Year,
    School_Name, 
    Campus_City, 
    Campus_State, 
    Major_1_CIP_Code,
    Employer_Name,
    Employer_City,
    Employer_State,
    Employer_Zip_Code,
    Job_Title,
    Employment_Description,
    Authorization_Start_Date,
    Authorization_End_Date,
    OPT_Authorization_Start_Date,
    OPT_Authorization_End_Date,
    OPT_Employer_Start_Date,
    OPT_Employer_End_Date,
    Employment_OPT_Type,
    Employment_Time,
    Unemployment_Days,
    On_Campus_Employment,
    Requested_Status,
    MIN_record_ID, 
    MAX_record_ID,
    FK_Individual_ID
FROM AggregatedData;