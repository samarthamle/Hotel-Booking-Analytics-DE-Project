CREATE OR REFRESH MATERIALIZED VIEW gold_room_type_summary
COMMENT 'Room type wise booking and revenue analysis'
AS

SELECT
    room_type,

    COUNT(*) AS total_bookings,

    SUM(
        CASE
            WHEN booking_status = 'Completed' THEN nights
            ELSE 0
        END
    ) AS room_nights,

    SUM(
        CASE
            WHEN booking_status = 'Completed'
            THEN total_amount - COALESCE(discount_amount, 0)
            ELSE 0
        END
    ) AS net_revenue,

    ROUND(AVG(guest_rating), 2) AS avg_guest_rating

FROM silver_bookings_clean

GROUP BY room_type;