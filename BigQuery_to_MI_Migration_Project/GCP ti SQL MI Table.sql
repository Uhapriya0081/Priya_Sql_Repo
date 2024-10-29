USE [DW]
GO

-- Drop the table if it already exists
IF OBJECT_ID('[dbo].[BigQ]', 'U') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[BigQ];
END
GO

-- Create the table with NVARCHAR(MAX) 
CREATE TABLE [dbo].[BigQ] (
    [PK_Id] INT IDENTITY(1,1) NOT NULL,  
    [event_date] NVARCHAR(MAX) NULL,
    [event_timestamp] BIGINT NULL,
    [event_name] NVARCHAR(MAX) NULL,
    [event_params] NVARCHAR(MAX) NULL,
    [event_previous_timestamp] BIGINT NULL,
    [event_value_in_usd] FLOAT NULL,
    [event_bundle_sequence_id] BIGINT NULL,
    [event_server_timestamp_offset] BIGINT NULL,
    [user_id] NVARCHAR(MAX) NULL,
    [user_pseudo_id] NVARCHAR(MAX) NULL,
    [privacy_info] NVARCHAR(MAX) NULL,
    [user_properties] NVARCHAR(MAX) NULL,
    [user_first_touch_timestamp] BIGINT NULL,
    [user_ltv] NVARCHAR(MAX) NULL,
    [device] NVARCHAR(MAX) NULL,
    [geo] NVARCHAR(MAX) NULL,
    [app_info] NVARCHAR(MAX) NULL,
    [traffic_source] NVARCHAR(MAX) NULL,
    [stream_id] NVARCHAR(MAX) NULL,
    [platform] NVARCHAR(MAX) NULL,
    [event_dimensions] NVARCHAR(MAX) NULL,
    [ecommerce] NVARCHAR(MAX) NULL,
    [items] NVARCHAR(MAX) NULL,
    [collected_traffic_source] NVARCHAR(MAX) NULL,
    [is_active_user] BIT NULL,
	[batch_event_index] NVARCHAR(MAX),
	[batch_page_id] NVARCHAR(MAX),
	[batch_ordering_id] NVARCHAR(MAX),
    PRIMARY KEY ([PK_Id]) 
);
GO

-- Create indexes on columns that can be indexed
CREATE INDEX IDX_event_timestamp ON [dbo].[BigQ]([event_timestamp]);
CREATE INDEX IDX_event_previous_timestamp ON [dbo].[BigQ]([event_previous_timestamp]);
CREATE INDEX IDX_event_value_in_usd ON [dbo].[BigQ]([event_value_in_usd]);
CREATE INDEX IDX_event_bundle_sequence_id ON [dbo].[BigQ]([event_bundle_sequence_id]);
CREATE INDEX IDX_event_server_timestamp_offset ON [dbo].[BigQ]([event_server_timestamp_offset]);
CREATE INDEX IDX_user_first_touch_timestamp ON [dbo].[BigQ]([user_first_touch_timestamp]);
CREATE INDEX IDX_is_active_user ON [dbo].[BigQ]([is_active_user]);
GO

select Top 10 * from [dbo].[BigQ] with (NoLock)

select count(*) from [dbo].[BigQ]