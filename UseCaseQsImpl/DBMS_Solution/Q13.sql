CREATE MATERIALIZED VIEW " Q13_Smoothing " AS
SELECT 	r1.device_pk 		 AS device_pk,
	r1.measure_timestamp 	 AS measure_timestamp,
	AVG ( r2.measure )	 AS measure,
	' WATT ' 		 AS measure_unit,
	' Smoothing measurements with
	10 minAVG slide window ' AS measure_description,
	r1.device_location 	 AS device_location,
	r1.location_area_m2 	 AS location_area_m2,
	rank () OVER w 		 AS index
FROM 	" Q10_3PhAgg_DBIntegr " r1
	JOIN
	" Q10_3PhAgg_DBIntegr " r2
	ON r1.device_pk = r2.device_pk
	AND r2.measure_timestamp
	    >= ( r1.measure_timestamp - ' 00:05:00 ' )
	AND r2.measure_timestamp
	    <= r1.measure_timestamp
GROUP BY r1.device_pk,
	 r1.measure_timestamp,
	 r1.device_location,
	 r1.location_area_m2
WINDOW w AS ( PARTITION BY r1.device_pk
		ORDER BY r1.measure_timestamp DESC )
