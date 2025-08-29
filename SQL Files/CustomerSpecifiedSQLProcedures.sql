/*
This SQL script defines two procedures to support data lookup and
data cleaning for the normalized database

Functionality: 
	- CommodityAndFeatureLookout: Retrieves site features based on a user inputed
	  commodity and feature type, joining relayed geological and material data.
	- CleanIndicatorValue: Cleans indicator values (.111) from resource data for
      more accurate contained resource reporting.
*/

# -------------------- CommodityAndFeatureLookout --------------------

DELIMITER //
CREATE PROCEDURE usgs_cobalt_us_project.CommodityAndFeatureLookout (
	IN input_commodity VARCHAR(100),
    IN input_ftr_type VARCHAR(100)
)
BEGIN
	SELECT
		gmo.site_id,
        sf.ftr_name,
        sc.commodity,
        gmo.ftr_type,
        gmo.last_updt,
        vm.value_material
	FROM usgs_cobalt_us_project.geol_min_occ gmo
    JOIN
		usgs_cobalt_us_project.site_commodity sc ON
        gmo.site_id = sc.site_id
	JOIN
		usgs_cobalt_us_project.site_feature sf ON
        gmo.site_id = sf.site_id AND gmo.ftr_id = sf.ftr_id
	LEFT JOIN
		usgs_cobalt_us_project.geol_min_occ_value_material vm ON
        gmo.geol_min_occ_id = vm.geol_min_occ_id
	WHERE sc.commodity = input_commodity AND gmo.ftr_type = input_ftr_type;
END //

DELIMITER ;

# -------------------- CleanIndicatorValue --------------------

DELIMITER //

CREATE PROCEDURE usgs_cobalt_us_project.CleanIndicatorValue()
BEGIN
	SELECT
		site_id,
        ftr_id,
        rsrc_date,
        IF (
			ROUND(contained - FLOOR(contained), 6) = 0.111000,
            ROUND(FLOOR(contained), 5),
            ROUND(contained)
        ) AS contained_clean,
        cont_units
	FROM usgs_cobalt_us_project.resources;
END //

DELIMITER ;

