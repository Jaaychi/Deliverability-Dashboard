WITH CTE_1 AS (SELECT
  s.id AS id,
  s.address_id AS address_id,
  a.country AS address_country,
  t.carrier AS tracking_carrier,
  d.tracker_id AS tracking_id,
  t.datetime AS tracking_datetime,
  s.datetime AS shipping_datetime,
  d.status AS details_status,
  d.datetime AS details_date_time
FROM
  shipments s
  LEFT JOIN trackers t ON s.id = t.shipment_id
  LEFT JOIN details d ON t.id = d.tracker_id
  LEFT JOIN address a ON s.address_id = a.id
)

, CTE2 AS (SELECT 
  address_country AS country,
  COUNT(*) AS successful_orders
FROM CTE_1
WHERE tracking_carrier = 'carrier 1'
AND details_status = 'delivery_exception'
OR details_status = 'arrived_destination'
OR details_status = 'arrived_at_pickup_location'
OR details_status = 'delayed'
GROUP BY country)

, CTE3 AS (SELECT 
  address_country AS country,
  COUNT(*) AS not_successful_orders
FROM CTE_1
WHERE tracking_carrier = 'carrier 1'
AND details_status = 'failure'
OR details_status = 'return'
OR details_status = 'missorted'
OR details_status = 'expired'
GROUP BY country)

SELECT
  CTE2.country,
  successful_orders,
  not_successful_orders,
  ROUND(((not_successful_orders * 100) / (successful_orders + not_successful_orders)), 2) AS percentage_not_successful_orders,
  ROUND(((successful_orders * 100) / (successful_orders + not_successful_orders)), 2) AS percentage_successful_orders
FROM CTE2
LEFT JOIN CTE3 ON CTE2.country = CTE3.country;


-- SELECT 
--   DISTINCT details_status
-- FROM CTE_1
-- WHERE tracking_carrier = 'carrier 1'

-- SELECT *
-- FROM CTE_1
-- WHERE tracking_carrier = 'carrier 1';


-- This determines the details_status so that I know which one is considered successful 
-- ex. delivery_exception
-- out_for_delivery
-- arrived_at_destination
-- in_transit
-- failure
-- return
-- held
-- arrived_at_pickup_location
-- missorted
-- delayed
-- expired
