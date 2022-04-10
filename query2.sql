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
WHERE tracking_carrier = 'carrier 2'
AND details_status = 'SUCCESS'
OR details_status = 'ORDER_PICKED_UP'
GROUP BY country)

, CTE3 AS (SELECT 
  address_country AS country,
  COUNT(*) AS not_successful_orders
FROM CTE_1
WHERE tracking_carrier = 'carrier 2'
AND details_status = 'DELIVERY_FAILED'
OR details_status = 'CANCELLED_BY_CUSTOMER'
OR details_status = 'PENDING_CUSTOMS_CLEARANCE'
OR details_status = 'RETURNED_TO_DESTINATION_WAREHOUSE'
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
-- WHERE tracking_carrier = 'carrier 2'

-- -- ORDER_RECEIVED_AT_DESTINATION_WAREHOUSE
-- INTRA_DESTINATION_TRANSFER
-- ORDER_INFO_RECEIVED
-- DELIVERY_IN_PROGRESS
-- SUCCESS
-- ORDER_RECEIVED_AT_LOCAL_SORTING_CENTER
-- ORDER_PICKED_UP
-- DELIVERY_FAILED
-- ORDER_RECEIVED_BY_AIRLINE
-- CANCELLED_BY_CUSTOMER
-- PENDING_CUSTOMS_CLEARANCE
-- RETURNED_TO_DESTINATION_WAREHOUSE
-- INTRA_ORIGIN_TRANSFER
