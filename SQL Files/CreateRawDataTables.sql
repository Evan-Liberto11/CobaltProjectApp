-- Creates a new Schema for th USGS Cobalt US Project
CREATE SCHEMA usgs_cobalt_us_project;

-- This file contains the code to create the tables
-- for the raw data from the .csv files that was downloaded
-- from https://www.sciencebase.gov/catalog/item/5ad623f2e4b0e2c2dd23f09e

# -------------------- CREATE TABLES FROM CSV --------------------

-- Table to hold the data from Dep_Model.csv
CREATE TABLE usgs_cobalt_us_project.original_dep_model (
	objectid INT,
    site_id VARCHAR(50),
    ftr_id VARCHAR(50),
    ftr_name VARCHAR(200),
    last_updt VARCHAR(200),
    dpmd_nonm VARCHAR(200),
    ref_detail VARCHAR(200),
    dpmd_refid VARCHAR(200),
    gem_name VARCHAR(200),
    gem_refid VARCHAR(200),
    remarks VARCHAR(200)
);

-- Table to hold the data from Descr_Sum.csv
CREATE TABLE usgs_cobalt_us_project.original_descr_sum (
	objectid INT,
    site_id VARCHAR(50),
    ft_id VARCHAR(50),
    last_updt VARCHAR(200),
    descr_type VARCHAR(200),
    descr TEXT,
    ref_id VARCHAR(200),
    remarks VARCHAR(400)
);

-- Table to hold the data from GeolMinOcc.csv
CREATE TABLE usgs_cobalt_us_project.original_geol_min_occ (
	oid INT,
    site_id VARCHAR(50),
    ftr_id VARCHAR(50),
    ftr_name VARCHAR(150),
    last_updt VARCHAR(20),
    ftr_type VARCHAR(50),
    commodity VARCHAR(150),
    value_mat VARCHAR(150),
    assoc_mat VARCHAR(150),
    min_style VARCHAR(50),
    min_age VARCHAR(50),
    host_age VARCHAR(50),
    host_name VARCHAR(150),
    host_litho VARCHAR(150),
    alteration VARCHAR(150),
    ref_id VARCHAR(50),
    remarks VARCHAR(200)
);

-- Table to hold the data from History.csv
CREATE TABLE usgs_cobalt_us_project.original_history (
	oid INT,
    site_id VARCHAR(50),
    ftr_id VARCHAR(50),
    ftr_name VARCHAR(150),
    last_updt VARCHAR(20),
    status VARCHAR(20),
    stat_detail VARCHAR(150),
    year_from VARCHAR(20),
    year_to VARCHAR(20),
    ref_detail VARCHAR(50),
    ref_id VARCHAR(50),
    remarks VARCHAR(200)
);

-- Table to hold the data from Loc_Poly.csv
CREATE TABLE usgs_cobalt_us_project.original_loc_poly (
	object_id INT,
    shape VARCHAR(50),
    site_id VARCHAR(50),
    ftr_id VARCHAR(50),
    ftr_name VARCHAR(150),
    last_updt VARCHAR(20),
    remarks VARCHAR(200),
    area_sq_km VARCHAR(50),
    area_acres VARCHAR(50)
);

-- Table to hold the data from Loc_Poly_Sw.csv
CREATE TABLE usgs_cobalt_us_project.original_loc_poly_sw (
	object_id INT,
    shape VARCHAR(50),
    ftr_id VARCHAR(50),
    ftr_name VARCHAR(150),
    last_updt VARCHAR(20),
    state VARCHAR(10),
    county VARCHAR(50),
    loc_date INT,
    ref_detail VARCHAR(50),
    ref_id VARCHAR(50),
    remarks VARCHAR(200),
    area_sq_km VARCHAR(50),
    area_acres VARCHAR(50)
);

-- Table to hold the data from Loc_Pt.csv
CREATE TABLE usgs_cobalt_us_project.original_loc_pt (
	object_id INT,
    shape VARCHAR(50),
    site_id VARCHAR(50),
    ftr_id VARCHAR(50),
    ftr_name VARCHAR(150),
    other_name VARCHAR(150),
    last_updt VARCHAR(20),
    ftr_group VARCHAR(50),
    ftr_type VARCHAR(50),
    commodity VARCHAR(100),
    lat_wgs84 DECIMAL(10,6),
    long_wgs84 DECIMAL(10,6),
    pt_def VARCHAR(100),
    poly_def VARCHAR(100),
    state VARCHAR(10),
    county VARCHAR(50),
    loc_scale VARCHAR(50),
    loc_date INT,
    ref_detail VARCHAR(50),
    ref_id VARCHAR(50),
    remarks VARCHAR(200),
    loc_poly VARCHAR(10)
);

-- Table to hold the data from Production.csv
CREATE TABLE usgs_cobalt_us_project.original_production (
	object_id INT,
    site_id VARCHAR(50),
    ftr_id VARCHAR(50),
    ftr_name VARCHAR(150),
    last_updt VARCHAR(20),
    assoc_dep VARCHAR(20),
    material VARCHAR(50),
    year_from INT,
    year_to INT,
    mat_type VARCHAR(50),
    mat_amnt BIGINT,
    mat_units VARCHAR(50),
    grade DECIMAL(6,3),
    grade_unit VARCHAR(50),
    cut_off_grad DECIMAL(6,3),
    cut_off_unit VARCHAR(50),
    contained DECIMAL(15,3),
    cont_units VARCHAR(50),
    rcvry_amt DECIMAL(15,3),
    rcvry_unit VARCHAR(50),
    prod_usd DECIMAL(15,3),
    mat_amnt_si DECIMAL(15,3),
    mat_units_si VARCHAR(50),
    grade_si DECIMAL(6,3),
    grad_unit_si VARCHAR(50),
    cog_si DECIMAL(6,3),
    cou_si DECIMAL(6,3),
    cnt_si_com_am DECIMAL(15,3),
    cnt_si_com_ut VARCHAR(50),
    cnt_si_com VARCHAR(20),
    rcvry_amt_si DECIMAL(15,3),
    rcvry_unt_si VARCHAR(50),
    ref_detail VARCHAR(50),
    ref_id VARCHAR(50),
    remarks VARCHAR(200)
);

-- Table to hold the data from References.csv
CREATE TABLE usgs_cobalt_us_project.original_references (
	object_id INT,
    ref_id VARCHAR(50),
    reference TEXT,
    last_updt VARCHAR(20)
);

-- Table to hold the data from Resources.csv
CREATE TABLE usgs_cobalt_us_project.original_resources (
	object_id INT,
    site_id VARCHAR(50),
    ftr_id VARCHAR(50),
    ftr_name VARCHAR(150),
    last_updt VARCHAR(20),
    material VARCHAR(50),
    rsrc_date INT,
    mat_type VARCHAR(50),
    mat_amnt BIGINT,
    mat_units VARCHAR(50),
    grade DECIMAL(6,3),
    grade_unit VARCHAR(50),
    cut_off_grad DECIMAL(6,3),
    cut_off_unit VARCHAR(50),
    contained DECIMAL(15,3),
    cont_units VARCHAR(50),
    mat_amnt_si DECIMAL(15,3),
    mat_units_si VARCHAR(50),
    grade_si DECIMAL(6,3),
    grad_unit_si VARCHAR(50),
    cog_si DECIMAL(6,3),
    cou_si VARCHAR(50),
    cnt_si_com_am DECIMAL(15,3),
    cnt_si_com_ut VARCHAR(50),
    cnt_si_com VARCHAR(20),
    rsrc_class VARCHAR(50),
    rsrc_descr VARCHAR(50),
    rsrc_code VARCHAR(20),
    ref_detail VARCHAR(50),
    ref_id VARCHAR(50),
    remarks VARCHAR(200)
);

-- Table to hold the data from Site.csv
CREATE TABLE usgs_cobalt_us_project.original_site (
	object_id INT,
    site_id VARCHAR(50),
    site_name VARCHAR(150),
    other_name VARCHAR(150),
    last_updt VARCHAR(20),
    commodity VARCHAR(100),
    min_reg_id VARCHAR(50),
    remarks VARCHAR(200),
    approx_lon DECIMAL(10,6),
	approx_lat DECIMAL(10,6),
    loc_pt VARCHAR(10),
    loc_poly VARCHAR(10),
    geol_min_occ VARCHAR(10),
    resources VARCHAR(10),
    production VARCHAR(10),
    history VARCHAR(10),
    dep_model VARCHAR(10),
    descr_sum VARCHAR(10)
);