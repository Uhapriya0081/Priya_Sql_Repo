-- Step 1: Drop the stored procedure if it exists
IF OBJECT_ID('dbo.event_params_split_Sp', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.event_params_split_Sp;
END
GO

-- Step 2: Create the stored procedure
CREATE PROCEDURE dbo.event_params_split_Sp
AS
BEGIN
    -- Step 1: Insert new records into event_params_split (if not already present)
    INSERT INTO dbo.event_params_split (PK_ID, event_param, event_date)
    SELECT 
        b.PK_ID, 
        b.event_params AS event_param, 
        b.event_date
    FROM dbo.BigQ AS b
    WHERE NOT EXISTS (
        SELECT 1 
        FROM dbo.event_params_split AS e
        WHERE e.PK_ID = b.PK_ID -- Check if the record already exists in event_params_split
    );

    -- Step 2: Update value_values from event_param using the given logic
    UPDATE event_params_split
    SET value_values = SUBSTRING(
                          event_param,
                          CHARINDEX('"value":"', event_param) + LEN('"value":"'),
                          CHARINDEX('"}', event_param, CHARINDEX('"value":"', event_param)) - (CHARINDEX('"value":"', event_param) + LEN('"value":"'))
                      )
    WHERE value_values IS NULL AND event_param IS NOT NULL;

    -- Step 3: Update key_values based on event_param
    UPDATE event_params_split
    SET key_values = JSON_VALUE(event_param, '$.key')
    WHERE key_values IS NULL AND event_param IS NOT NULL;

    -- Step 4: Remove unwanted characters (\\\") from value_values
    UPDATE event_params_split
    SET value_values = REPLACE(value_values, '\\\"', '')
    WHERE value_values IS NOT NULL;
--step 5:
UPDATE event_params_split
SET
    -- Parse int_value (extract the first valid integer from the array)
    int_value = CASE 
                   WHEN CHARINDEX('\"int_value\":\"[', value_values) > 0 
                   THEN
                       -- Replace 'null' values with empty strings and split the array by commas
                       SUBSTRING(
                           value_values,
                           CHARINDEX('\"int_value\":\"[', value_values) + LEN('\"int_value\":\"['),
                           CHARINDEX(']', value_values, CHARINDEX('\"int_value\":\"[', value_values)) - (CHARINDEX('\"int_value\":\"[', value_values) + LEN('\"int_value\":\"['))
                       )
                   ELSE NULL 
                END,

    -- Parse float_value (extract the first valid float from the array)
    float_value = CASE 
                     WHEN CHARINDEX('\"float_value\":\"[', value_values) > 0 
                     THEN
                         SUBSTRING(
                             value_values,
                             CHARINDEX('\"float_value\":\"[', value_values) + LEN('\"float_value\":\"['),
                             CHARINDEX(']', value_values, CHARINDEX('\"float_value\":\"[', value_values)) - (CHARINDEX('\"float_value\":\"[', value_values) + LEN('\"float_value\":\"['))
                         )
                     ELSE NULL 
                   END,

    -- Parse double_value (extract the first valid double from the array)
    double_value = CASE 
                     WHEN CHARINDEX('\"double_value\":\"[', value_values) > 0 
                     THEN
                         SUBSTRING(
                             value_values,
                             CHARINDEX('\"double_value\":\"[', value_values) + LEN('\"double_value\":\"['),
                             CHARINDEX(']', value_values, CHARINDEX('\"double_value\":\"[', value_values)) - (CHARINDEX('\"double_value\":\"[', value_values) + LEN('\"double_value\":\"['))
                         )
                     ELSE NULL 
                   END,

    -- Parse string_value (this logic already works correctly)
    string_value = CASE 
                     WHEN CHARINDEX('\"string_value\":\"', value_values) > 0 
                     THEN 
                         SUBSTRING(
                             value_values, 
                             CHARINDEX('\"string_value\":\"', value_values) + LEN('\"string_value\":\"'), 
                             CHARINDEX(']', value_values, CHARINDEX('\"string_value\":\"', value_values)) - 
                             (CHARINDEX('\"string_value\":\"', value_values) + LEN('\"string_value\":\"'))
                         )
                     ELSE NULL 
                   END
WHERE 
    value_values IS NOT NULL
    AND (int_value IS NULL OR float_value IS NULL OR double_value IS NULL OR string_value IS NULL);


End;
Go


EXEC dbo.event_params_split_Sp;
