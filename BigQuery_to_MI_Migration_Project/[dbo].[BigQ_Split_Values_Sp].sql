USE [DW]
GO

/****** Object:  StoredProcedure [dbo].[BigQ_Split_Values_Sp]    Script Date: 21-10-2024 09:42:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER   PROCEDURE [dbo].[BigQ_Split_Values_Sp]
AS
BEGIN
    SET NOCOUNT ON;

    -- Split the data and insert into the target table
    WITH SplitStringValues AS (
        SELECT
            e.PK_ID AS BigQ_PK_ID,
            ROW_NUMBER() OVER (PARTITION BY e.PK_ID ORDER BY (SELECT NULL)) AS rn,
            TRIM(value) AS string_value
        FROM dbo.event_params_split e
        CROSS APPLY STRING_SPLIT(REPLACE(REPLACE(e.string_value, '[', ''), ']', ''), ',')
    ),
    SplitIntValues AS (
        SELECT
            e.PK_ID AS BigQ_PK_ID,
            ROW_NUMBER() OVER (PARTITION BY e.PK_ID ORDER BY (SELECT NULL)) AS rn,
            TRIM(value) AS int_value
        FROM dbo.event_params_split e
        CROSS APPLY STRING_SPLIT(REPLACE(REPLACE(e.int_value, '[', ''), ']', ''), ',')
    ),
    SplitFloatValues AS (
        SELECT
            e.PK_ID AS BigQ_PK_ID,
            ROW_NUMBER() OVER (PARTITION BY e.PK_ID ORDER BY (SELECT NULL)) AS rn,
            TRIM(value) AS float_value
        FROM dbo.event_params_split e
        CROSS APPLY STRING_SPLIT(REPLACE(REPLACE(e.float_value, '[', ''), ']', ''), ',')
    ),
    SplitDoubleValues AS (
        SELECT
            e.PK_ID AS BigQ_PK_ID,
            ROW_NUMBER() OVER (PARTITION BY e.PK_ID ORDER BY (SELECT NULL)) AS rn,
            TRIM(value) AS double_value
        FROM dbo.event_params_split e
        CROSS APPLY STRING_SPLIT(REPLACE(REPLACE(e.double_value, '[', ''), ']', ''), ',')
    ),
    SplitKeyValues AS (
        SELECT
            e.PK_ID AS BigQ_PK_ID,
            ROW_NUMBER() OVER (PARTITION BY e.PK_ID ORDER BY (SELECT NULL)) AS rn,
            TRIM(REPLACE(REPLACE(REPLACE(value, '[', ''), ']', ''), '"', '')) AS key_value
        FROM dbo.event_params_split e
        CROSS APPLY STRING_SPLIT(REPLACE(REPLACE(e.key_values, '[', ''), ']', ''), ',')
    ),
    AggregatedValues AS (
        SELECT
            PK_ID,
            MIN(PK_ID) AS Min_PK_ID,
            MAX(PK_ID) AS Max_PK_ID
        FROM dbo.event_params_split
        GROUP BY PK_ID
    )

    INSERT INTO dbo.BigQ_Split_Values (BigQ_PK_ID, key_value, string_value, int_value, float_value, double_value, event_date, Min_PK_ID, Max_PK_ID)
    SELECT 
        k.BigQ_PK_ID,
        CONVERT(VARCHAR(255), k.key_value) AS key_value,
        s.string_value,
        i.int_value,
        f.float_value,
        d.double_value,
        e.event_date,
        a.Min_PK_ID,  -- Updated to reflect aggregated minimum ID
        a.Max_PK_ID   -- Updated to reflect aggregated maximum ID
    FROM SplitKeyValues k
    LEFT JOIN SplitStringValues s ON k.BigQ_PK_ID = s.BigQ_PK_ID AND k.rn = s.rn
    LEFT JOIN SplitIntValues i ON k.BigQ_PK_ID = i.BigQ_PK_ID AND k.rn = i.rn
    LEFT JOIN SplitFloatValues f ON k.BigQ_PK_ID = f.BigQ_PK_ID AND k.rn = f.rn
    LEFT JOIN SplitDoubleValues d ON k.BigQ_PK_ID = d.BigQ_PK_ID AND k.rn = d.rn
    LEFT JOIN AggregatedValues a ON k.BigQ_PK_ID = a.PK_ID
    LEFT JOIN dbo.event_params_split e ON k.BigQ_PK_ID = e.PK_ID;

END;
GO


