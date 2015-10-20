SELECT 	device_pk,
	measure_timestamp,
	measure,
	measure_unit,
	' Power consumption
	above threshold ' AS measure_description,
	device_location,
FROM  " Q14_Normalization "
WHERE index = 1 /* Threshold Limit Values */
	AND (( device_pk = 0 AND measure >= ThrVal0 )
	  OR ( device_pk = 1 AND measure >= ThrVal1 )
	  OR ( device_pk = 2 AND measure >= ThrVal2 )
	  OR ( device_pk = 3 AND measure >= ThrVal3 )
	  OR ( device_pk = 4 AND measure >= ThrVal4 )
	  OR ( device_pk = 5 AND measure >= ThrVal5 )
	  OR ( device_pk = 6 AND measure >= ThrVal6 )
	  OR ( device_pk = 7 AND measure >= ThrVal7 )
	  OR ( device_pk = 8 AND measure >= ThrVal8 ))
