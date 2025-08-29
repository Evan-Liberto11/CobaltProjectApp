/*
This SQL Script inserts and transforms raw data from the "original" tables into the
new, normalized tables following Third Normal Form (3NF) principles.

This Loading Process ensures that all entity relationships are maintained using
correct foreign key mappings and that the database is properly structured for
efficient quierying and easy scalability.
*/

# -------------------- BEGIN DATA LOADING --------------------

CREATE TABLE numbers_table (
    num INT
);

INSERT INTO numbers_table (num)
VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);

INSERT INTO usgs_cobalt_us_project.reference (ref_id, reference, last_updt)
SELECT ref_id, reference, last_updt
FROM usgs_cobalt_us_project.original_references;

INSERT INTO usgs_cobalt_us_project.site (site_id, site_name, last_updt, min_reg_id, approx_lon, approx_lat, remarks)
SELECT site_id, site_name, last_updt, min_reg_id, approx_lon, approx_lat, remarks
FROM usgs_cobalt_us_project.original_site;

INSERT INTO usgs_cobalt_us_project.loc_pt_othername (loc_pt_id, other_name)
(
    WITH split_cte AS (
        SELECT 
            l.loc_pt_id,
            TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(o.other_name, ';', num), ';', -1)) AS split_other_name
        FROM 
            usgs_cobalt_us_project.original_loc_pt o
        JOIN 
            usgs_cobalt_us_project.loc_pt l
              ON o.site_id = l.site_id
              AND o.ftr_id = l.ftr_id
        JOIN 
            numbers_table
              ON num <= 1 + LENGTH(o.other_name) - LENGTH(REPLACE(o.other_name, ';', ''))
        WHERE 
            o.other_name IS NOT NULL
    )
    SELECT 
        loc_pt_id,
        split_other_name
    FROM split_cte
    WHERE split_other_name IS NOT NULL AND split_other_name != ''
);

INSERT INTO usgs_cobalt_us_project.loc_pt_commodity (loc_pt_id, commodity)
(
    WITH split_cte AS (
        SELECT 
            l.loc_pt_id,
            TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(o.commodity, ';', num), ';', -1)) AS split_commodity
        FROM 
            usgs_cobalt_us_project.original_loc_pt o
        JOIN 
            usgs_cobalt_us_project.loc_pt l
              ON o.site_id = l.site_id
              AND o.ftr_id = l.ftr_id
        JOIN 
            numbers_table
              ON num <= 1 + LENGTH(o.commodity) - LENGTH(REPLACE(o.commodity, ';', ''))
        WHERE 
            o.commodity IS NOT NULL
    )
    SELECT 
        loc_pt_id,
        split_commodity
    FROM split_cte
    WHERE split_commodity IS NOT NULL AND split_commodity != ''
);


INSERT INTO usgs_cobalt_us_project.mineral_region (min_reg_id)
SELECT DISTINCT min_reg_id
FROM usgs_cobalt_us_project.original_site
WHERE min_reg_id IS NOT NULL AND TRIM(min_reg_id) != '';

INSERT INTO usgs_cobalt_us_project.site_commodity (site_id, commodity)
(
    WITH split_cte AS (
        SELECT 
            site_id,
            TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(commodity, ';', num), ';', -1)) AS split_commodity
        FROM 
            usgs_cobalt_us_project.original_site
        JOIN 
            numbers_table
        ON 
            num <= 1 + LENGTH(commodity) - LENGTH(REPLACE(commodity, ';', ''))
        WHERE 
            commodity IS NOT NULL
    )
    SELECT DISTINCT 
        site_id,
        split_commodity
    FROM split_cte
    WHERE split_commodity IS NOT NULL AND split_commodity != ''
);

INSERT INTO usgs_cobalt_us_project.site_data_availability (site_id, loc_pt, loc_poly, geol_min_occ, resources, production, history, dep_model, descr_sum)
SELECT 
    site_id,
    CASE WHEN loc_pt = 'Yes' THEN TRUE ELSE FALSE END,
    CASE WHEN loc_poly = 'Yes' THEN TRUE ELSE FALSE END,
    CASE WHEN geol_min_occ = 'Yes' THEN TRUE ELSE FALSE END,
    CASE WHEN resources = 'Yes' THEN TRUE ELSE FALSE END,
    CASE WHEN production = 'Yes' THEN TRUE ELSE FALSE END,
    CASE WHEN history = 'Yes' THEN TRUE ELSE FALSE END,
    CASE WHEN dep_model = 'Yes' THEN TRUE ELSE FALSE END,
    CASE WHEN descr_sum = 'Yes' THEN TRUE ELSE FALSE END
FROM usgs_cobalt_us_project.original_site;

INSERT INTO usgs_cobalt_us_project.deposition_model (dpmd_nonm, ref_detail, dpmd_refid, remarks)
SELECT dpmd_nonm, ref_detail, dpmd_refid, remarks
FROM usgs_cobalt_us_project.original_dep_model;

INSERT INTO usgs_cobalt_us_project.geological_environment_model (gem_name, gem_refid, remarks)
SELECT gem_name, gem_refid, remarks
FROM usgs_cobalt_us_project.original_dep_model;

INSERT INTO usgs_cobalt_us_project.site_feature (site_id, ftr_id, ftr_name, last_updt, remarks)
SELECT site_id, ftr_id, ftr_name, last_updt, remarks
FROM usgs_cobalt_us_project.original_dep_model;

INSERT INTO usgs_cobalt_us_project.geol_min_occ (site_id, ftr_id, last_updt, ftr_type, reference_id, remarks)
SELECT 
    site_id,
    ftr_id,
    last_updt,
    ftr_type,
    (SELECT reference_id FROM usgs_cobalt_us_project.reference r WHERE r.ref_id = o.ref_id LIMIT 1),
    remarks
FROM usgs_cobalt_us_project.original_geol_min_occ o;

INSERT INTO usgs_cobalt_us_project.geol_min_occ_value_material (geol_min_occ_id, value_material)
(
    WITH split_cte AS (
        SELECT 
            o.ftr_id,
            TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(value_mat, ';', num), ';', -1)) AS split_value_mat
        FROM 
            usgs_cobalt_us_project.original_geol_min_occ o
        JOIN 
            numbers_table
        ON 
            num <= 1 + LENGTH(value_mat) - LENGTH(REPLACE(value_mat, ';', ''))
        WHERE 
            value_mat IS NOT NULL
    )
    SELECT 
        g.geol_min_occ_id,
        split_value_mat
    FROM split_cte
    JOIN usgs_cobalt_us_project.geol_min_occ g ON g.ftr_id = split_cte.ftr_id
    WHERE split_value_mat IS NOT NULL AND split_value_mat != ''
);

INSERT INTO usgs_cobalt_us_project.geol_min_occ_associated_material (geol_min_occ_id, assoc_material)
(
    WITH split_cte AS (
        SELECT 
            o.ftr_id,
            TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(assoc_mat, ';', num), ';', -1)) AS split_assoc_mat
        FROM 
            usgs_cobalt_us_project.original_geol_min_occ o
        JOIN 
            numbers_table
        ON 
            num <= 1 + LENGTH(assoc_mat) - LENGTH(REPLACE(assoc_mat, ';', ''))
        WHERE 
            assoc_mat IS NOT NULL
    )
    SELECT 
        g.geol_min_occ_id,
        split_assoc_mat
    FROM split_cte
    JOIN usgs_cobalt_us_project.geol_min_occ g ON g.ftr_id = split_cte.ftr_id
    WHERE split_assoc_mat IS NOT NULL AND split_assoc_mat != ''
);

INSERT INTO usgs_cobalt_us_project.geol_min_occ_min_style (geol_min_occ_id, min_style)
(
    WITH split_cte AS (
        SELECT 
            o.ftr_id,
            TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(min_style, ';', num), ';', -1)) AS split_min_style
        FROM 
            usgs_cobalt_us_project.original_geol_min_occ o
        JOIN 
            numbers_table
        ON 
            num <= 1 + LENGTH(min_style) - LENGTH(REPLACE(min_style, ';', ''))
        WHERE 
            min_style IS NOT NULL
    )
    SELECT 
        g.geol_min_occ_id,
        split_min_style
    FROM split_cte
    JOIN usgs_cobalt_us_project.geol_min_occ g ON g.ftr_id = split_cte.ftr_id
    WHERE split_min_style IS NOT NULL AND split_min_style != ''
);

INSERT INTO usgs_cobalt_us_project.geol_min_occ_min_age (geol_min_occ_id, min_age)
(
    WITH split_cte AS (
        SELECT 
            o.ftr_id,
            TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(min_age, ';', num), ';', -1)) AS split_min_age
        FROM 
            usgs_cobalt_us_project.original_geol_min_occ o
        JOIN 
            numbers_table
        ON 
            num <= 1 + LENGTH(min_age) - LENGTH(REPLACE(min_age, ';', ''))
        WHERE 
            min_age IS NOT NULL
    )
    SELECT 
        g.geol_min_occ_id,
        split_min_age
    FROM split_cte
    JOIN usgs_cobalt_us_project.geol_min_occ g ON g.ftr_id = split_cte.ftr_id
    WHERE split_min_age IS NOT NULL AND split_min_age != ''
);

INSERT INTO usgs_cobalt_us_project.geol_min_occ_host_age (geol_min_occ_id, host_age)
(
    WITH split_cte AS (
        SELECT 
            o.ftr_id,
            TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(host_age, ';', num), ';', -1)) AS split_host_age
        FROM 
            usgs_cobalt_us_project.original_geol_min_occ o
        JOIN 
            numbers_table
        ON 
            num <= 1 + LENGTH(host_age) - LENGTH(REPLACE(host_age, ';', ''))
        WHERE 
            host_age IS NOT NULL
    )
    SELECT 
        g.geol_min_occ_id,
        split_host_age
    FROM split_cte
    JOIN usgs_cobalt_us_project.geol_min_occ g ON g.ftr_id = split_cte.ftr_id
    WHERE split_host_age IS NOT NULL AND split_host_age != ''
);

INSERT INTO usgs_cobalt_us_project.geol_min_occ_host_name (geol_min_occ_id, host_name)
(
    WITH split_cte AS (
        SELECT 
            o.ftr_id,
            TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(host_name, ';', num), ';', -1)) AS split_host_name
        FROM 
            usgs_cobalt_us_project.original_geol_min_occ o
        JOIN 
            numbers_table
        ON 
            num <= 1 + LENGTH(host_name) - LENGTH(REPLACE(host_name, ';', ''))
        WHERE 
            host_name IS NOT NULL
    )
    SELECT 
        g.geol_min_occ_id,
        split_host_name
    FROM split_cte
    JOIN usgs_cobalt_us_project.geol_min_occ g ON g.ftr_id = split_cte.ftr_id
    WHERE split_host_name IS NOT NULL AND split_host_name != ''
);

INSERT INTO usgs_cobalt_us_project.geol_min_occ_host_litho (geol_min_occ_id, host_litho)
(
    WITH split_cte AS (
        SELECT 
            o.ftr_id,
            TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(host_litho, ';', num), ';', -1)) AS split_host_litho
        FROM 
            usgs_cobalt_us_project.original_geol_min_occ o
        JOIN 
            numbers_table
        ON 
            num <= 1 + LENGTH(host_litho) - LENGTH(REPLACE(host_litho, ';', ''))
        WHERE 
            host_litho IS NOT NULL
    )
    SELECT 
        g.geol_min_occ_id,
        split_host_litho
    FROM split_cte
    JOIN usgs_cobalt_us_project.geol_min_occ g ON g.ftr_id = split_cte.ftr_id
    WHERE split_host_litho IS NOT NULL AND split_host_litho != ''
);

INSERT INTO usgs_cobalt_us_project.geol_min_occ_alteration (geol_min_occ_id, alteration)
(
    WITH split_cte AS (
        SELECT 
            o.ftr_id,
            TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(alteration, ';', num), ';', -1)) AS split_alteration
        FROM 
            usgs_cobalt_us_project.original_geol_min_occ o
        JOIN 
            numbers_table
        ON 
            num <= 1 + LENGTH(alteration) - LENGTH(REPLACE(alteration, ';', ''))
        WHERE 
            alteration IS NOT NULL
    )
    SELECT 
        g.geol_min_occ_id,
        split_alteration
    FROM split_cte
    JOIN usgs_cobalt_us_project.geol_min_occ g ON g.ftr_id = split_cte.ftr_id
    WHERE split_alteration IS NOT NULL AND split_alteration != ''
);

INSERT INTO usgs_cobalt_us_project.descr_sum (site_id, ftr_id, last_updt, descr_type, descr, reference_id, remarks)
SELECT 
    site_id,
    ft_id,
    last_updt,
    descr_type,
    descr,
    (SELECT reference_id FROM usgs_cobalt_us_project.reference r WHERE r.ref_id = o.ref_id LIMIT 1),
    remarks
FROM usgs_cobalt_us_project.original_descr_sum o;

INSERT INTO usgs_cobalt_us_project.history (site_id, ftr_id, last_updt, status, stat_detail, year_from, year_to, ref_detail, reference_id, remarks)
SELECT 
    site_id,
    ftr_id,
    last_updt,
    status,
    stat_detail,
    year_from,
    year_to,
    ref_detail,
    (SELECT reference_id FROM usgs_cobalt_us_project.reference r WHERE r.ref_id = o.ref_id LIMIT 1),
    remarks
FROM usgs_cobalt_us_project.original_history o;

INSERT INTO usgs_cobalt_us_project.loc_pt (site_id, ftr_id, last_updt, ftr_group, ftr_type, pt_def, poly_def, state, county, loc_scale, loc_date, ref_detail, reference_id, loc_poly, remarks)
SELECT 
    site_id,
    ftr_id,
    last_updt,
    ftr_group,
    ftr_type,
    pt_def,
    poly_def,
    state,
    county,
    loc_scale,
    loc_date,
    (SELECT reference_id FROM usgs_cobalt_us_project.reference r WHERE r.ref_id = o.ref_id LIMIT 1),
    CASE WHEN loc_poly = 'Yes' THEN TRUE ELSE FALSE END,
    remarks
FROM usgs_cobalt_us_project.original_loc_pt o;

INSERT INTO usgs_cobalt_us_project.loc_pt_ref_detail (loc_pt_id, ref_detail)
(
    WITH split_cte AS (
        SELECT 
            o.object_id,
            TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(ref_detail, ';', num), ';', -1)) AS split_ref_detail
        FROM 
            usgs_cobalt_us_project.original_loc_pt o
        JOIN 
            numbers_table
        ON 
            num <= 1 + LENGTH(ref_detail) - LENGTH(REPLACE(ref_detail, ';', ''))
        WHERE 
            ref_detail IS NOT NULL
    )
    SELECT 
        l.loc_pt_id,
        split_ref_detail
    FROM split_cte
    JOIN usgs_cobalt_us_project.loc_pt l ON l.site_id = (SELECT site_id FROM usgs_cobalt_us_project.original_loc_pt o WHERE o.object_id = split_cte.object_id)
        AND l.ftr_id = (SELECT ftr_id FROM usgs_cobalt_us_project.original_loc_pt o WHERE o.object_id = split_cte.object_id)
    WHERE split_ref_detail IS NOT NULL AND split_ref_detail != ''
);

INSERT INTO usgs_cobalt_us_project.loc_poly (site_id, ftr_id, last_updt, area_sqkm, area_acres, remarks)
SELECT 
    site_id,
    ftr_id,
    last_updt,
    area_sq_km,
    area_acres,
    remarks
FROM usgs_cobalt_us_project.original_loc_poly;

INSERT INTO usgs_cobalt_us_project.loc_poly_sw (ftr_id, last_updt, state, county, loc_date, ref_detail, reference_id, area_sqkm, area_acres, remarks)
SELECT 
    ftr_id,
    last_updt,
    state,
    county,
    loc_date,
    ref_detail,
    (SELECT reference_id FROM usgs_cobalt_us_project.reference r WHERE r.ref_id = o.ref_id LIMIT 1),
    area_sq_km,
    area_acres,
    remarks
FROM usgs_cobalt_us_project.original_loc_poly_sw o;

INSERT INTO usgs_cobalt_us_project.production (site_id, ftr_id, material, year_from, year_to, mat_type, mat_amnt, mat_units, grade, grade_unit, contained, cont_units, ref_detail, reference_id, remarks)
SELECT 
    site_id,
    ftr_id,
    material,
    year_from,
    year_to,
    mat_type,
    mat_amnt,
    mat_units,
    grade,
    grade_unit,
    contained,
    cont_units,
    ref_detail,
    (SELECT reference_id FROM usgs_cobalt_us_project.reference r WHERE r.ref_id = o.ref_id LIMIT 1),
    remarks
FROM usgs_cobalt_us_project.original_production o;

INSERT INTO usgs_cobalt_us_project.resources (site_id, ftr_id, material, rsrc_date, mat_type, mat_amnt, mat_units, grade, grade_unit, contained, cont_units, rsrc_class, rsrc_descr, rsrc_code, ref_detail, reference_id, remarks)
SELECT 
    site_id,
    ftr_id,
    material,
    rsrc_date,
    mat_type,
    mat_amnt,
    mat_units,
    grade,
    grade_unit,
    contained,
    cont_units,
    rsrc_class,
    rsrc_descr,
    rsrc_code,
    ref_detail,
    (SELECT reference_id FROM usgs_cobalt_us_project.reference r WHERE r.ref_id = o.ref_id LIMIT 1),
    remarks
FROM usgs_cobalt_us_project.original_resources o;

-- Cleanup: Drop the temporary numbers_table now that it is no longer needed
DROP TABLE IF EXISTS numbers_table;

