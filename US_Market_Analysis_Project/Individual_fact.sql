-- Drop the table if it already exists
DROP TABLE IF EXISTS [BI_UMA].[uma].[Individual_Fact];

-- Create fact table from scratch
CREATE TABLE [BI_UMA].[uma].[Individual_Fact] (
    PK_ID BIGINT IDENTITY(1,1),
    Individual_Key INT NOT NULL,
    Student_Key INT NOT NULL,
    Year INT NOT NULL,
    Country_of_Birth INT,
    Country_of_Citizenship INT,
    First_Entry_Date DATE,
    Last_Entry_Date DATE,
    Last_Departure_Date DATE,
    Class_of_Admission INT,
    Visa_Issue_Date DATE,
    Visa_Expiration_Date DATE,
    DistinctEnrolmentsCount INT NOT NULL,
    DistinctEmploymentCount INT NOT NULL,
    MIN_record_ID INT NOT NULL,
    MAX_record_ID INT NOT NULL,
    PRIMARY KEY (PK_ID)  -- Primary key on ID
);

-- Index on Individual_Key
CREATE INDEX IDX_Individual_Fact_IndividualKey
ON [BI_UMA].[uma].[Individual_Fact](Individual_Key);

-- Index on Year
CREATE INDEX IDX_Individual_Fact_Year
ON [BI_UMA].[uma].[Individual_Fact](Year);

-- Index on Country_of_Birth
CREATE INDEX IDX_Individual_Fact_CountryOfBirth
ON [BI_UMA].[uma].[Individual_Fact](Country_of_Birth);

-- Index on Country_of_Citizenship
CREATE INDEX IDX_Individual_Fact_CountryOfCitizenship
ON [BI_UMA].[uma].[Individual_Fact](Country_of_Citizenship);

-- Index on First_Entry_Date
CREATE INDEX IDX_Individual_Fact_FirstEntryDate
ON [BI_UMA].[uma].[Individual_Fact](First_Entry_Date);

-- Index on Last_Entry_Date
CREATE INDEX IDX_Individual_Fact_LastEntryDate
ON [BI_UMA].[uma].[Individual_Fact](Last_Entry_Date);

-- Index on Visa_Issue_Date
CREATE INDEX IDX_Individual_Fact_VisaIssueDate
ON [BI_UMA].[uma].[Individual_Fact](Visa_Issue_Date);

WITH Combined AS (
    SELECT 
        Individual_Key, 
        PK_ID, 
        Student_Key,  -- Ensure Student_Key is included
        Country_of_Birth, 
        Country_of_Citizenship, 
        First_Entry_Date, 
        Last_Entry_Date, 
        Last_Departure_Date, 
        Class_of_Admission, 
        Visa_Issue_Date, 
        Visa_Expiration_Date, 
        Year 
    FROM (
        SELECT Individual_Key, PK_ID, Student_Key, Country_of_Birth, Country_of_Citizenship, First_Entry_Date, 
               Last_Entry_Date, Last_Departure_Date, Class_of_Admission, Visa_Issue_Date, 
               Visa_Expiration_Date, 2017 AS Year FROM [BI_UMA].[uma].[US_Market_Analysis_2017]
        UNION ALL
        SELECT Individual_Key, PK_ID, Student_Key, Country_of_Birth, Country_of_Citizenship, First_Entry_Date, 
               Last_Entry_Date, Last_Departure_Date, Class_of_Admission, Visa_Issue_Date, 
               Visa_Expiration_Date, 2018 AS Year FROM [BI_UMA].[uma].[US_Market_Analysis_2018]
        UNION ALL
        SELECT Individual_Key, PK_ID, Student_Key, Country_of_Birth, Country_of_Citizenship, First_Entry_Date, 
               Last_Entry_Date, Last_Departure_Date, Class_of_Admission, Visa_Issue_Date, 
               Visa_Expiration_Date, 2019 AS Year FROM [BI_UMA].[uma].[US_Market_Analysis_2019]
        UNION ALL
        SELECT Individual_Key, PK_ID, Student_Key, Country_of_Birth, Country_of_Citizenship, First_Entry_Date, 
               Last_Entry_Date, Last_Departure_Date, Class_of_Admission, Visa_Issue_Date, 
               Visa_Expiration_Date, 2020 AS Year FROM [BI_UMA].[uma].[US_Market_Analysis_2020]
        UNION ALL
        SELECT Individual_Key, PK_ID, Student_Key, Country_of_Birth, Country_of_Citizenship, First_Entry_Date, 
               Last_Entry_Date, Last_Departure_Date, Class_of_Admission, Visa_Issue_Date, 
               Visa_Expiration_Date, 2021 AS Year FROM [BI_UMA].[uma].[US_Market_Analysis_2021]
        UNION ALL
        SELECT Individual_Key, PK_ID, Student_Key, Country_of_Birth, Country_of_Citizenship, First_Entry_Date, 
               Last_Entry_Date, Last_Departure_Date, Class_of_Admission, Visa_Issue_Date, 
               Visa_Expiration_Date, 2022 AS Year FROM [BI_UMA].[uma].[US_Market_Analysis_2022]
        UNION ALL
        SELECT Individual_Key, PK_ID, Student_Key, Country_of_Birth, Country_of_Citizenship, First_Entry_Date, 
               Last_Entry_Date, Last_Departure_Date, Class_of_Admission, Visa_Issue_Date, 
               Visa_Expiration_Date, 2023 AS Year FROM [BI_UMA].[uma].[US_Market_Analysis_2023]
    ) AS CombinedData
),
AggregatedData AS (
    SELECT 
        Individual_Key,
        Student_Key,  -- Include Student_Key in the aggregation
        Year, 
        Country_of_Birth, 
        Country_of_Citizenship, 
        First_Entry_Date, 
        Last_Entry_Date, 
        Last_Departure_Date, 
        Class_of_Admission, 
        Visa_Issue_Date, 
        Visa_Expiration_Date,
        COUNT(DISTINCT Student_Key) AS DistinctEnrolmentsCount,  -- Count distinct enrollments
        COUNT(DISTINCT Individual_Key) AS DistinctEmploymentCount,  -- Count distinct employment records
        MIN(PK_ID) AS MIN_record_ID, 
        MAX(PK_ID) AS MAX_record_ID
    FROM Combined
    GROUP BY 
        Individual_Key,
        Student_Key,  -- Include Student_Key in GROUP BY
        Year, 
        Country_of_Birth, 
        Country_of_Citizenship, 
        First_Entry_Date, 
        Last_Entry_Date, 
        Last_Departure_Date, 
        Class_of_Admission, 
        Visa_Issue_Date, 
        Visa_Expiration_Date
)
-- Insert the results into the fact table
INSERT INTO [BI_UMA].[uma].[Individual_Fact] (
    Individual_Key, 
    Student_Key,  -- Ensure Student_Key is included in the INSERT
    Year,
    Country_of_Birth, 
    Country_of_Citizenship, 
    First_Entry_Date, 
    Last_Entry_Date, 
    Last_Departure_Date, 
    Class_of_Admission, 
    Visa_Issue_Date, 
    Visa_Expiration_Date, 
    DistinctEnrolmentsCount, 
    DistinctEmploymentCount, 
    MIN_record_ID, 
    MAX_record_ID
)
SELECT 
    Individual_Key, 
    Student_Key,  -- Include Student_Key in the SELECT statement
    Year, 
    Country_of_Birth, 
    Country_of_Citizenship, 
    First_Entry_Date, 
    Last_Entry_Date, 
    Last_Departure_Date, 
    Class_of_Admission, 
    Visa_Issue_Date, 
    Visa_Expiration_Date, 
    DistinctEnrolmentsCount, 
    DistinctEmploymentCount, 
    MIN_record_ID, 
    MAX_record_ID
FROM AggregatedData;
