SELECT 	r2.device_pk,
		MAX ( r2.measure_timestamp ) AS measure_timestamp,
		COUNT ( r2.current_measure ) AS measure,
		' Positive Integer ' 		 AS measure_unit
		' Number of times that current consumption
		was greater than expected '  AS measure_description,
		r2.device_location
FROM 	" Q15_ExpectedUDF " r1
		JOIN
		" Q15_ExpectedUDF " r2
		ON r1.device_pk = r2.device_pk
		AND r1.index = 1
		AND r2.measure_timestamp
		> ( r1.measure_timestamp - ' 01:00:00 ' )
WHERE r2.current_measure > r2.expected_measure
GROUP BY r2.device_pk,
		 r2.expected_measure,
		 r2.device_location
HAVING 5 <= COUNT ( r2.current_measure )
		AND COUNT ( r2.current_measure ) <= 10