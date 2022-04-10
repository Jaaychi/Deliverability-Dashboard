SELECT
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

