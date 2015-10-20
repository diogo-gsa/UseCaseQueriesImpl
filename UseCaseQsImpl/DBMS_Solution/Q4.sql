SELECT	device_pk 		AS device_pk
	measure_timestamp 	AS measure_timestamp
	measure / sum ( measure ) 
	OVER wintotal *100 	AS measure,
	' Percentage % ' 	AS measure_unit,
	' Pie chart of energy consumptions
	per device ' 		AS measure_description,
	device_location 	AS device_location
FROM 	" Q14_Normalization "
WHERE 	device_pk <> 0
	AND index =1
WINDOW wintotal AS ( PARTITION BY NULL )
