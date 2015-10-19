CREATE MATERIALIZED VIEW " Q15_ExpectedUDF " AS
SELECT	device_pk 			AS device_pk,
		measure_timestamp 	AS measure_timestamp,
		measure 			AS current_measure,
		getExpectedMeasureUDF ( device_pk,
		measure_timestamp ) AS expected_measure,
		' WATT / m ^2 ' 	AS measure_unit,
		' Current and Expected Power
		consumption given by UDF ' AS measure_description,
		device_location 	AS device_location,
		index 				AS index
FROM " Q14_Normalization "