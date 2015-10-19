CREATE MATERIALIZED VIEW " Q16_ExpectedLastMonthPivotHourAVG " AS
SELECT 	rel.device_pk AS device_pk,
		rel.measure_timestamp_pivot AS measure_timestamp,
		rel.measure AS current_measure,
		rel.expecetd_measure AS expecetd_measure,
		' WATT / m ^2 ' AS measure_unit,
		' Current and Expected Power consumption given by the
		AVG of the current hour computed along last month ' AS measure_description,
		rel.device_location AS device_location,
		rank () OVER w2 AS index
FROM ( SELECT 	pivot_measures.device_pk AS device_pk,
				pivot_measures.measure_timestamp AS measure_timestamp_pivot,
				cluster_measures.measure_timestamp AS measure_timestamp_cluster,
				pivot_measures.measure AS measure,
				AVG ( cluster_measures.measure ) OVER w1 AS expecetd_measure,
				pivot_measures.measure_description AS measure_description,
				pivot_measures.measure_unit AS measure_unit,
				pivot_measures.device_location AS device_location,
				rank () OVER w1 AS rank
		FROM 	" Q14_Normalization " cluster_measures
				JOIN
				" Q14_Normalization " pivot_measures
				ON cluster_measures.device_pk = pivot_measures.device_pk
				AND cluster_measures.measure_timestamp <= pivot_measures.measure_timestamp
				AND cluster_measures.measure_timestamp > ( pivot_measures.measure_timestamp - ' 1 month ' )
		WINDOW w1 AS 	( PARTITION BY 	cluster_measures.device_pk,
										date_part ( ' hour ', cluster_measures.measure_timestamp ),
										pivot_measures.index
						ORDER BY cluster_measures.measure_timestamp
						DESC RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING )
						) rel
WHERE rel.rank = 1
AND date_part ( ' hour ', rel.measure_timestamp_pivot ) = date_part ( ' hour ', rel.measure_timestamp_cluster )
WINDOW w2 AS ( PARTITION BY rel.device_pk
ORDER BY rel.measure_timestamp_pivot DESC )