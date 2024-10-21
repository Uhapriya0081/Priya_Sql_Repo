-- Drop the table if it already exists
DROP TABLE IF EXISTS [BI_UMA].[uma].[Course_Enrollment_Fact];

-- Create fact table from scratch
CREATE TABLE [BI_UMA].[uma].[Course_Enrollment_Fact] (
    PK_ID BIGINT IDENTITY(1,1),
	FK_Individual_ID BIGINT not null,  -- Foreign key reference to Individual_Fact
    Individual_Key INT not null,
    Student_Key INT not null,
    Year INT not null,
    School_Name INT,  -- Change to INT if this column contains integer values
    Campus_City INT,  -- Change to INT if this column contains integer values
    Campus_State INT,  -- Change to INT if this column contains integer values
    Campus_Zip_Code nvarchar(50),  -- Change to INT if this column contains integer values
    Major_1_CIP_Code float,  -- Change to INT if this column contains integer values
    Major_1_Description INT,
    Major_2_CIP_Code float,  -- Change to INT if this column contains integer values
    Major_2_Description INT,
    Minor_CIP_Code float,  -- Change to INT if this column contains integer values
    Minor_Description INT,
    Program_Start_Date DATE,
    Program_End_Date DATE,
    Tuition_Fees DECIMAL(18, 2),
    Student_s_Personal_Funds DECIMAL(18, 2),
    Funds_From_This_School DECIMAL(18, 2),
    Funds_from_Other_Sources DECIMAL(18, 2),
    Status_Code INT,  -- Change to INT if this column contains integer values
    Student_Edu_Level_Desc INT,
    MIN_record_ID INT not null,
    MAX_record_ID INT not null,  
);

-- Create indexes on the fact table
CREATE INDEX idx_individual_key ON [BI_UMA].[uma].[Course_Enrollment_Fact](Individual_Key);
CREATE INDEX idx_student_key ON [BI_UMA].[uma].[Course_Enrollment_Fact](Student_Key);
CREATE INDEX idx_year ON [BI_UMA].[uma].[Course_Enrollment_Fact](Year);
CREATE INDEX idx_school_name ON [BI_UMA].[uma].[Course_Enrollment_Fact](School_Name);
CREATE INDEX idx_campus_city ON [BI_UMA].[uma].[Course_Enrollment_Fact](Campus_City);
CREATE INDEX idx_campus_state ON [BI_UMA].[uma].[Course_Enrollment_Fact](Campus_State);
CREATE INDEX idx_campus_zip_code ON [BI_UMA].[uma].[Course_Enrollment_Fact](Campus_Zip_Code);
CREATE INDEX idx_major_1_cip_code ON [BI_UMA].[uma].[Course_Enrollment_Fact](Major_1_CIP_Code);
CREATE INDEX idx_major_2_cip_code ON [BI_UMA].[uma].[Course_Enrollment_Fact](Major_2_CIP_Code);
CREATE INDEX idx_minor_cip_code ON [BI_UMA].[uma].[Course_Enrollment_Fact](Minor_CIP_Code);
CREATE INDEX idx_status_code ON [BI_UMA].[uma].[Course_Enrollment_Fact](Status_Code);



WITH Combined AS (
    SELECT 
        Individual_Key, 
        Student_Key, 
        School_Name, 
        Campus_City, 
        Campus_State, 
        Campus_Zip_Code, 
        Major_1_CIP_Code, 
        Major_1_Description, 
        Major_2_CIP_Code, 
        Major_2_Description, 
        Minor_CIP_Code, 
        Minor_Description, 
        Program_Start_Date, 
        Program_End_Date, 
        Tuition_Fees, 
        Student_s_Personal_Funds, 
        Funds_From_This_School, 
        Funds_from_Other_Sources, 
        Status_Code, 
        Student_Edu_Level_Desc,
        Year, 
        PK_ID
    FROM (
        SELECT Individual_Key, Student_Key, School_Name, Campus_City, Campus_State, Campus_Zip_Code, 
               Major_1_CIP_Code, Major_1_Description, Major_2_CIP_Code, Major_2_Description, 
               Minor_CIP_Code, Minor_Description, Program_Start_Date, Program_End_Date, 
               Tuition_Fees, Student_s_Personal_Funds, Funds_From_This_School, Funds_from_Other_Sources, 
               Status_Code, Student_Edu_Level_Desc, 2017 AS Year, PK_ID
        FROM [BI_UMA].[uma].[US_Market_Analysis_2017]
        UNION ALL
        SELECT Individual_Key, Student_Key, School_Name, Campus_City, Campus_State, Campus_Zip_Code, 
               Major_1_CIP_Code, Major_1_Description, Major_2_CIP_Code, Major_2_Description, 
               Minor_CIP_Code, Minor_Description, Program_Start_Date, Program_End_Date, 
               Tuition_Fees, Student_s_Personal_Funds, Funds_From_This_School, Funds_from_Other_Sources, 
               Status_Code, Student_Edu_Level_Desc, 2018 AS Year, PK_ID
        FROM [BI_UMA].[uma].[US_Market_Analysis_2018]
        UNION ALL
        SELECT Individual_Key, Student_Key, School_Name, Campus_City, Campus_State, Campus_Zip_Code, 
               Major_1_CIP_Code, Major_1_Description, Major_2_CIP_Code, Major_2_Description, 
               Minor_CIP_Code, Minor_Description, Program_Start_Date, Program_End_Date, 
               Tuition_Fees, Student_s_Personal_Funds, Funds_From_This_School, Funds_from_Other_Sources, 
               Status_Code, Student_Edu_Level_Desc, 2019 AS Year, PK_ID
        FROM [BI_UMA].[uma].[US_Market_Analysis_2019]
        UNION ALL
        SELECT Individual_Key, Student_Key, School_Name, Campus_City, Campus_State, Campus_Zip_Code, 
               Major_1_CIP_Code, Major_1_Description, Major_2_CIP_Code, Major_2_Description, 
               Minor_CIP_Code, Minor_Description, Program_Start_Date, Program_End_Date, 
               Tuition_Fees, Student_s_Personal_Funds, Funds_From_This_School, Funds_from_Other_Sources, 
               Status_Code, Student_Edu_Level_Desc, 2020 AS Year, PK_ID
        FROM [BI_UMA].[uma].[US_Market_Analysis_2020]
        UNION ALL
        SELECT Individual_Key, Student_Key, School_Name, Campus_City, Campus_State, Campus_Zip_Code, 
               Major_1_CIP_Code, Major_1_Description, Major_2_CIP_Code, Major_2_Description, 
               Minor_CIP_Code, Minor_Description, Program_Start_Date, Program_End_Date, 
               Tuition_Fees, Student_s_Personal_Funds, Funds_From_This_School, Funds_from_Other_Sources, 
               Status_Code, Student_Edu_Level_Desc, 2021 AS Year, PK_ID
        FROM [BI_UMA].[uma].[US_Market_Analysis_2021]
        UNION ALL
        SELECT Individual_Key, Student_Key, School_Name, Campus_City, Campus_State, Campus_Zip_Code, 
               Major_1_CIP_Code, Major_1_Description, Major_2_CIP_Code, Major_2_Description, 
               Minor_CIP_Code, Minor_Description, Program_Start_Date, Program_End_Date, 
               Tuition_Fees, Student_s_Personal_Funds, Funds_From_This_School, Funds_from_Other_Sources, 
               Status_Code, Student_Edu_Level_Desc, 2022 AS Year, PK_ID
        FROM [BI_UMA].[uma].[US_Market_Analysis_2022]
        UNION ALL
        SELECT Individual_Key, Student_Key, School_Name, Campus_City, Campus_State, Campus_Zip_Code, 
               Major_1_CIP_Code, Major_1_Description, Major_2_CIP_Code, Major_2_Description, 
               Minor_CIP_Code, Minor_Description, Program_Start_Date, Program_End_Date, 
               Tuition_Fees, Student_s_Personal_Funds, Funds_From_This_School, Funds_from_Other_Sources, 
               Status_Code, Student_Edu_Level_Desc, 2023 AS Year, PK_ID
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
        Campus_Zip_Code, 
        Major_1_CIP_Code, 
        Major_1_Description, 
        Major_2_CIP_Code, 
        Major_2_Description, 
        Minor_CIP_Code, 
        Minor_Description, 
        Program_Start_Date, 
        Program_End_Date, 
        Tuition_Fees, 
        Student_s_Personal_Funds, 
        Funds_From_This_School, 
        Funds_from_Other_Sources, 
        Status_Code, 
        Student_Edu_Level_Desc, 
        MIN(PK_ID) AS MIN_record_ID, 
        MAX(PK_ID) AS MAX_record_ID,
        -- Reference FK from Individual_Fact table, ensure only one value is returned
        (SELECT TOP 1 PK_ID FROM [BI_UMA].[uma].[Individual_Fact] 
         WHERE Individual_Key = Combined.Individual_Key AND Year = Combined.Year
         ORDER BY PK_ID) AS FK_Individual_ID 
    FROM Combined
    GROUP BY 
        Individual_Key, 
        Student_Key, 
        Year, 
        School_Name, 
        Campus_City, 
        Campus_State, 
        Campus_Zip_Code, 
        Major_1_CIP_Code, 
        Major_1_Description, 
        Major_2_CIP_Code, 
        Major_2_Description, 
        Minor_CIP_Code, 
        Minor_Description, 
        Program_Start_Date, 
        Program_End_Date, 
        Tuition_Fees, 
        Student_s_Personal_Funds, 
        Funds_From_This_School, 
        Funds_from_Other_Sources, 
        Status_Code, 
        Student_Edu_Level_Desc
)
-- Insert the results into the fact table
INSERT INTO [BI_UMA].[uma].[Course_Enrollment_Fact] (
    Individual_Key, 
    Student_Key,
    Year,
    School_Name, 
    Campus_City, 
    Campus_State, 
    Campus_Zip_Code, 
    Major_1_CIP_Code, 
    Major_1_Description, 
    Major_2_CIP_Code, 
    Major_2_Description, 
    Minor_CIP_Code, 
    Minor_Description, 
    Program_Start_Date, 
    Program_End_Date, 
    Tuition_Fees, 
    Student_s_Personal_Funds, 
    Funds_From_This_School, 
    Funds_from_Other_Sources, 
    Status_Code, 
    Student_Edu_Level_Desc, 
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
    Campus_Zip_Code, 
    Major_1_CIP_Code, 
    Major_1_Description, 
    Major_2_CIP_Code, 
    Major_2_Description, 
    Minor_CIP_Code, 
    Minor_Description, 
    Program_Start_Date, 
    Program_End_Date, 
    Tuition_Fees, 
    Student_s_Personal_Funds, 
    Funds_From_This_School, 
    Funds_from_Other_Sources, 
    Status_Code, 
    Student_Edu_Level_Desc, 
    MIN_record_ID, 
    MAX_record_ID,
    FK_Individual_ID
FROM AggregatedData;
