SELECT 	device_pk,
	measure_timestamp,
	measure,
	' Time Seconds ' AS measure_unit,
	' Last measurement period is out
	of range [55, 65] secs . ' AS meausre_description,
	device_location,
	location_area_m2
FROM 	" Q12_Period "
WHERE 	index = 1 
	AND NOT ( ' 00:00:55 ' <= measure AND measure <= ' 00:01:05 ' )
