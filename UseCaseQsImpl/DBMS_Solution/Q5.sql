SELECT 	device_pk 					AS device_pk ,
		measure_timestamp 			AS measure_timestamp ,
		rank () OVER sortedwindow 	AS measrure ,
		measure 					AS current_power_consumption ,
		' Ranking List Position ' 	AS measure_unit ,
		' Ranked list of energy consumption
		per device ' 				AS measure_description ,
		device_location 			AS measure_location
FROM 	" Q14_Normalization "
WHERE index = 1
WINDOW sortedwindow AS ( PARTITION BY NULL
						ORDER BY measure DESC )