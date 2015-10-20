CREATE MATERIALIZED VIEW " Q10_3PhAgg_DBIntegr " AS
SELECT 	dev.device_pk 		AS device_pk,
	dpr.measure_timestamp 	AS measure_timestamp,
	SUM ( dpr.measure ) 	AS measure,
	' WATT ' 		AS measure_unit,
	' Power Consumption ' 	AS measure_description,
	dl.location		AS device_location,
	dl.area_m2 		AS location_area_m2,
	rank () OVER w		AS index
FROM 	" DataPoint " dp
	JOIN " DataPointReading " dpr
	ON dpr.datapoint_fk = dp.datapoint_pk
	JOIN " Device " dev
	ON dp.device_fk = dev.device_pk
	JOIN " DeviceLoceation " dl
	ON dev.device_location_fk
	= dl.device_location_pk
	JOIN " DataPointDescription " dpd
	ON dp.datapoint_description_fk
	= dpd.datapoint_description_pk
	JOIN " DataPointUnit " dpu
	ON dp.datapoint_unit_fk
	= dpu.datapoint_unit_pk
WHERE 	dpd.description = " Phase1_EnergyConsumption "
     OR dpd.description = " Phase2_EnergyConsumption "
     OR dpd.description = " Phase3_EnergyConsumption "
GROUP BY dev.device_pk,
		dpr.measure_timestamp,
		dl.location,
		dl.area_m2
HAVING COUNT ( dpr.measure ) = 3
WINDOW w AS ( PARTITION BY dev.device_pk
			ORDER BY dpr.measure_timestamp DESC );
