CREATE OR REFRESH MATERIALIZED VIEW silver_bookings_rejected
COMMENT 'Silver layer - Invalid hotel booking records with rejection reasons'
AS

WITH ranked_bookings AS (

    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY booking_id
            ORDER BY loaded_at
        ) AS row_num

    FROM bronze_hotel_bookings
),

deduplicated_bookings AS (

    SELECT * EXCEPT (row_num)
    FROM ranked_bookings
    WHERE row_num = 1

)

SELECT
    *,
    CASE
        WHEN check_out_date <= check_in_date
            THEN 'Invalid check-in/check-out dates'

        WHEN room_rate < 0
            THEN 'Negative room rate'

    END AS reject_reason

FROM deduplicated_bookings

WHERE
    check_out_date <= check_in_date
    OR room_rate < 0;