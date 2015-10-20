SELECT 	device_pk,
	measure_timestamp,
	( current_measure
	/ expecetd_measure -1) *100 	AS measure,
	' Percentage % ' 		AS measure_unit,
	' Delta between current and expecetd consumption
	exceeded a given threshold ' 	AS measure_description,
	device_location,
	current_measure,
	expecetd_measure
FROM 	" Q16_ExpectedLastMonthPivotHourAVG "
WHERE index = 1 /* Threshold */
	AND ( current_measure / expecetd_measure -1) *100 > 10
