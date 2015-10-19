SELECT 	device_pk,
		measure_timestamp,
		current_measure AS measure,
		measure_sliding24h_avg *1.20 AS measure_threshold,
		measure_unit,
		' Power consumption 20% above the AVG of last 24 hours ' AS measure_description,
		device_location
FROM (SELECT all_measures.device_pk,
			 all_measures.measure_timestamp,
			 all_measures.measure AS current_measure,
			 all_measures.measure_unit,
			 all_measures.measure_description,
			 all_measures.device_location,
			 all_measures.location_area_m2,
			 AVG (all_measures.measure) over 	w AS measure_sliding24h_avg,
			 rank () over 						w AS index
		FROM " Q13_Smoothing " AS all_measures
			 JOIN
			 " Q13_Smoothing " AS most_recent_measure
			 ON most_recent_measure.index = 1
			 AND most_recent_measure.device_pk = all_measures . device_pk
			 AND all_measures.measure_timestamp >=
			     most_recent_measure.measure_timestamp - ' 24 hours '
		WINDOW w AS (PARTITION BY all_measures.device_pk
					 ORDER BY all_measures.measure_timestamp DESC
					 RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING )
		) AS rel
WHERE index = 1
AND current_measure >= measure_sliding24h_avg *1.2 /* Threshold */