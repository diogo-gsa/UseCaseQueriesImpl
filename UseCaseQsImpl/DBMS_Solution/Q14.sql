CREATE MATERIALIZED VIEW " Q14_Normalization " AS
SELECT 	device_pk AS device_pk,
		measure_timestamp AS measure_timestamp,
		measure / location_area_m2 AS measure,
		' WATT / m ^2 ' AS measure_unit,
		' Each device square
		meter normalization ' AS measure_description,
		device_location AS device_location,
		index AS index,
FROM " Q13_Smoothing "
UNION
SELECT rel.device_pk AS device_pk,
		rel.measure_timestamp AS measure_timestamp,
		rel.measure AS measure,
		' WATT / m ^2 ' AS measure_unit,
		measure_description AS measure_description,
		rel.device_location AS device_location,
		rank () OVER w AS rank
FROM ( SELECT 0 AS device_pk,
	to_timestamp ((((((((
	date_part ( ' year ', measure_timestamp ) || ' - ' ) ||
	date_part ( ' month ', measure_timestamp )) || ' - ' ) ||
	date_part ( ' day ', measure_timestamp )) || ' ' ) ||
	date_part ( ' hour ', measure_timestamp ) ) || ' : ' ) ||
	date_part ( ' minute ', measure_timestamp ),
	' YYYY - MM - DD HH24 : MI : SS ' ) AS measure_timestamp,
	SUM ( measure )/ SUM ( location_area_m2 ) AS measure,
	' WATT / m ^2 ' AS measure_unit,
	' All Building square meter
	normalized consumption ' AS measure_description,
	' ALL_BUILDING ' AS device_location
	FROM " Q13_Smoothing "
	GROUP BY 	date_part ( ' year ', measure_timestamp ),
				date_part ( ' month ', measure_timestamp ),
				date_part ( ' day ', measure_timestamp ),
				date_part ( ' hour ', measure_timestamp ),
				date_part ( ' minute ', measure_timestamp )
	HAVING count ( device_pk ) = 8) rel
WINDOW w AS ( ORDER BY rel.measure_timestamp DESC )