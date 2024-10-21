CREATE VIEW [dbo].[BigQ_View] AS
WITH KeyValueExtraction AS (
    SELECT
        kv.BigQ_PK_ID,
        kv.Key_value,
        CASE 
            WHEN kv.string_value = 'null' THEN CAST(kv.int_value AS VARCHAR) 
            ELSE kv.string_value 
        END AS new_value
    FROM
        [dbo].[BigQ_Split_Values] kv
)
SELECT
    bq.event_date,
    bq.event_timestamp,
    bq.event_name,
    bq.event_previous_timestamp,
    bq.event_value_in_usd,
    bq.event_bundle_sequence_id,
    bq.event_server_timestamp_offset,
    bq.user_id,
    bq.user_pseudo_id,
    bq.privacy_info,
    bq.user_properties,
    bq.user_first_touch_timestamp,
    bq.user_ltv,
    bq.device,
    bq.geo,
    bq.app_info,
    bq.traffic_source,
    bq.stream_id,
    bq.platform,
    bq.event_dimensions,
    bq.ecommerce,
    bq.items,
    bq.collected_traffic_source,
    bq.is_active_user,
    bq.batch_event_index,
    bq.batch_page_id,
    bq.batch_ordering_id,
    bq.session_traffic_source_last_click,

    kv.new_value
FROM
    [dbo].[BigQ] bq
LEFT JOIN
    KeyValueExtraction kv
    ON bq.PK_ID = kv.BigQ_PK_ID;
