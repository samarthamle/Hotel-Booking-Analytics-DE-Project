CREATE OR REFRESH MATERIALIZED VIEW silver_bookings_clean
COMMENT 'Silver layer - Clean and standardized hotel booking records'
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

    booking_id,

    NULLIF(TRIM(guest_id), '') AS guest_id,

    booking_date,
    check_in_date,
    check_out_date,

    COALESCE(
        nights,
        DATEDIFF(check_out_date, check_in_date)
    ) AS nights,

    INITCAP(TRIM(hotel_name)) AS hotel_name,

    COALESCE(
        NULLIF(INITCAP(TRIM(city)), ''),
        'Unknown'
    ) AS city,

    INITCAP(TRIM(region)) AS region,

    INITCAP(TRIM(room_type)) AS room_type,

    COALESCE(
        NULLIF(INITCAP(TRIM(booking_channel)), ''),
        'Unknown'
    ) AS booking_channel,

    guests,
    room_rate,

    COALESCE(
        total_amount,
        DATEDIFF(check_out_date, check_in_date) * room_rate
    ) AS total_amount,

    COALESCE(discount_amount, 0) AS discount_amount,

    INITCAP(TRIM(meal_plan)) AS meal_plan,

    INITCAP(TRIM(payment_method)) AS payment_method,

    INITCAP(TRIM(payment_status)) AS payment_status,

    INITCAP(TRIM(booking_status)) AS booking_status,

    guest_rating,

    source_file,
    loaded_at

FROM deduplicated_bookings

WHERE
    check_out_date > check_in_date
    AND room_rate >= 0;