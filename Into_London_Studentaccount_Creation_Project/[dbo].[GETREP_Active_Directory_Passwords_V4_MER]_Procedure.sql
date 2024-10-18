USE [SF_STG]
GO

/****** Object:  StoredProcedure [dbo].[GETREP_Active_Directory_Passwords_V4_MER]    Script Date: 08-08-2024 10:57:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[GETREP_Active_Directory_Passwords_V4_MER] (
    @pCentre VARCHAR(5) = NULL,  -- Default to NULL, can be 'MER' or 'LON'
    @pStartDate DATETIME = NULL,
    @pEndDate DATETIME = NULL,
    @pRegStatus VARCHAR(10) = 'P,C,CR' -- Default to 'P,C,CR'
)
AS
BEGIN
    -- Declare local variables with default parameters if not provided
    DECLARE
        @pStartDateL DATETIME = ISNULL(@pStartDate, DATEADD(DAY, -14, GETDATE())),
        @pEndDateL DATETIME = ISNULL(@pEndDate, DATEADD(DAY, 30, GETDATE())),
        @pRegStatusL VARCHAR(10) = ISNULL(@pRegStatus, 'P,C,CR'),
        @ValidCentre VARCHAR(5);

    -- Validate @pCentre
    IF @pCentre IS NOT NULL AND @pCentre NOT IN ('MER', 'LON','WEC')
    BEGIN
        SET @ValidCentre = NULL;
    END
    ELSE
    BEGIN
        SET @ValidCentre = @pCentre;
    END

    -- Main query
    SELECT
        [Sits_Number],
        [sAMAccountName],
        [UserPrincipalName],
        [GivenName],
        [Sn],
        [DisplayName],
        [Description],
        CONVERT(VARCHAR, [Start_Date], 103) AS [Start_Date],
        CONVERT(VARCHAR, [End_Date], 103) AS [End_Date],
        CONVERT(VARCHAR, [AccountExpires], 103) AS [AccountExpires],
        [Department],
        [Mail],
        [SuggestedEmail],
        [Password],
        [MailNickname]
    FROM 
        [SF_STG].[dbo].[v_IDX_Account_ActiveDir_V4_MER]
    WHERE 
        [Start_Date] BETWEEN @pStartDateL AND @pEndDateL
        AND (@pRegStatusL IS NULL OR Registration_Status_Code__c IN (SELECT * FROM [dbo].[fn_MVParam_Split](@pRegStatusL, ',')))
        AND (@ValidCentre IS NULL OR [Centre] = @ValidCentre) -- Filter by the provided centre only if it's valid
END
GO
