CREATE MATERIALIZED VIEW " Q11_Variation " AS
SELECT 	r1.device_pk 			AS device_pk ,
		r1.measure_timestamp 	AS measure_timestamp ,
		( r1.measure / AVG ( r2.measure ) -1) *100 AS measure ,
		r1.measure 				AS current_power_consumption ,
		' Percentage % ' 		AS measure_unit ,
		' Power Consumption variation
		over 5 minutes ' 		AS measure_description ,
		r1.device_location 		AS device_location ,
		r1.location_area_m2 	AS location_area_m2 ,
		rank () OVER w 			AS index
FROM 	" Q10_3PhAgg_DBIntegr " r1
		JOIN
		" Q10_3PhAgg_DBIntegr " r2
		ON r1.device_pk = r2.device_pk
		AND r2.measure_timestamp
		> ( r1.measure_timestamp - ' 00:05:00 ' )
		AND r2.measure_timestamp
		<= r1.measure_timestamp
GROUP BY r1.device_pk ,
		 r1.measure_timestamp ,
		 r1.measure ,
		 r1.measure_unit ,
		 r1.measure_description ,
		 r1.device_location ,
		 r1.location_area_m2
WINDOW w AS (PARTITION BY r1.device_pk
			ORDER BY r1.measure_timestamp DESC
			RANGE BETWEEN CURRENT ROW
			AND UNBOUNDED FOLLOWING )