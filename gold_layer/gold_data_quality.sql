CREATE OR REFRESH MATERIALIZED VIEW gold_data_quality
COMMENT 'Data quality metrics and Bronze to Silver reconciliation'
AS

WITH bronze_metrics AS (

    SELECT
        COUNT(*) AS bronze_rows,

        COUNT(*) - COUNT(DISTINCT booking_id)
            AS duplicate_rows_removed,

        SUM(CASE
            WHEN check_out_date <= check_in_date THEN 1
            ELSE 0
        END) AS invalid_date_rows,

        SUM(CASE
            WHEN room_rate < 0 THEN 1
            ELSE 0
        END) AS negative_rate_rows,

        SUM(CASE
            WHEN city IS NULL OR TRIM(city) = '' THEN 1
            ELSE 0
        END) AS missing_city_rows,

        SUM(CASE
            WHEN booking_channel IS NULL OR TRIM(booking_channel) = '' THEN 1
            ELSE 0
        END) AS missing_channel_rows,

        SUM(CASE
            WHEN nights IS NULL THEN 1
            ELSE 0
        END) AS missing_nights_rows,

        SUM(CASE
            WHEN total_amount IS NULL THEN 1
            ELSE 0
        END) AS missing_amount_rows

    FROM bronze_hotel_bookings
),

silver_metrics AS (

    SELECT COUNT(*) AS clean_rows
    FROM silver_bookings_clean

),

rejected_metrics AS (

    SELECT COUNT(*) AS rejected_rows
    FROM silver_bookings_rejected

)

SELECT
    b.bronze_rows,
    s.clean_rows,
    r.rejected_rows,
    b.duplicate_rows_removed,

    b.invalid_date_rows,
    b.negative_rate_rows,
    b.missing_city_rows,
    b.missing_channel_rows,
    b.missing_nights_rows,
    b.missing_amount_rows,

    (
        s.clean_rows
        + r.rejected_rows
        + b.duplicate_rows_removed
    ) AS reconciled_rows,

    CASE
        WHEN b.bronze_rows =
            s.clean_rows
            + r.rejected_rows
            + b.duplicate_rows_removed
        THEN 'PASS'
        ELSE 'FAIL'
    END AS reconciliation_status

FROM bronze_metrics b
CROSS JOIN silver_metrics s
CROSS JOIN rejected_metrics r;