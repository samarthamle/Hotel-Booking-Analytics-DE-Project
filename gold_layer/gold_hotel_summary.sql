CREATE OR REFRESH MATERIALIZED VIEW gold_hotel_summary
COMMENT 'Hotel-wise booking and revenue performance'
AS

SELECT
    region,
    city,
    hotel_name,

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

    ROUND(
        SUM(
            CASE
                WHEN booking_status = 'Completed'
                THEN total_amount - COALESCE(discount_amount, 0)
                ELSE 0
            END
        )
        /
        NULLIF(
            SUM(
                CASE
                    WHEN booking_status = 'Completed' THEN nights
                    ELSE 0
                END
            ), 0
        ),
        2
    ) AS adr

FROM silver_bookings_clean

GROUP BY region, city, hotel_name;