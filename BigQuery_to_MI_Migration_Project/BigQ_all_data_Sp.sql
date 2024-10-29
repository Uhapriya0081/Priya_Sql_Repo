CREATE PROCEDURE [dbo].[BigQ_all_data_Sp]
AS
BEGIN
    -- Declare a variable to store the maximum event_date in the destination table
    DECLARE @MaxEventDate INT;

    -- Get the maximum event_date from the destination table
    SELECT @MaxEventDate = MAX(event_date)
    FROM [DW].[dbo].[BigQ_all_data];

    -- If no data exists in the destination table, set the date to a very small value
    IF @MaxEventDate IS NULL
    BEGIN
        SET @MaxEventDate = 19000101; -- Corresponds to '1900-01-01'
    END

    -- Insert new records from the view where event_date is greater than the maximum event_date in the destination table
    INSERT INTO [DW].[dbo].[BigQ_all_data] 
        (event_date, event_name, session_id, page_referrer, page_location, agent_id, 
         user_pseudo_id, category, greater_category, search_term, university_name)
    SELECT 
        event_date, event_name, session_id, page_referrer, page_location, agent_id, 
        user_pseudo_id, category, greater_category, search_term, university_name
    FROM [DW].[dbo].[BigQ_raw_data]
    WHERE event_date > @MaxEventDate;

END;
