SELECT 	r1.device_pk 		 	  AS device_pk,
	r1.measure_timestamp 		  AS measure_timestamp,
	(MIN(r2.measure)/MAX(r2.measure)) AS measure,
	' Ratio = [0,1] ' 	 	  AS measure_unit,
	' Min / Max Power Consumption Ratio
	during last hour ' 	 	  AS measure_description,
	r1.device_location 	 	  AS device_location,
	MIN ( r2.measure ) 	 	  AS min_hourly,
	MAX ( r2.measure ) 	 	  AS max_hourly
FROM 	" Q14_Normalization " AS r1
	JOIN
	" Q14_Normalization " AS r2
	ON  r1.index = 1
	AND r2.device_pk = r1.device_pk
	AND r2.measure_timestamp
	  > r1.measure_timestamp -( interval ' 60 minutes ' )
GROUP BY r1.device_pk,
	 r1.measure_timestamp,
	 r1.measure_unit,
	 r1.measure_description,
	 r1.device_location
