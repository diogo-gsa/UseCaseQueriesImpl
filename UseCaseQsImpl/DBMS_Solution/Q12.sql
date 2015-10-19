CREATE MATERIALIZED VIEW " Q12_Period " AS
SELECT 	r1.device_pk 		 	AS device_pk,
		r1.measure_timestamp 	AS measure_timestamp,
		( r1.measure_timestamp
		-r2.measure_timestamp ) AS measure,
		' Time Seconds ' 	 	AS measure_unit,
		' Last measurement period ' AS measure_description,
		r1.device_location 	 	AS device_location,
		r1.location_area_m2  	AS location_area_m2,
		r1.index AS index
FROM 	" Q10_3PhAgg_DBIntegr " r1
		JOIN
		" Q10_3PhAgg_DBIntegr " r2
		ON r1.device_pk = r2.device_pk
		AND r1.index + 1 = r2.index