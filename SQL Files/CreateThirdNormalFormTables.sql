/*
This SQL Script creates a brand new set of normalized tables for the USGS Cobalt US
Project Database. These tables are designed to be in Third Normal Form (3NF).

Key Features:
	- Each table has a single, clear purpose (entity-based design).
	- Redundant data has been seperated into related tables with foreign key links
	- All non-key attributes are fully dependent on the primary key
    - No transitive dependencies exist among non-prime attributes
*/

# -------------------- START OF TABLE CREATION --------------------

-- Create Reference Table
CREATE TABLE usgs_cobalt_us_project.reference (
	reference_id INT AUTO_INCREMENT,
    ref_id VARCHAR(100),
    reference TEXT,
    last_updt VARCHAR(20),
    PRIMARY KEY(reference_id)
);

-- Create Site Table
CREATE TABLE usgs_cobalt_us_project.site (
	site_auto_id INT AUTO_INCREMENT,
    site_id VARCHAR(50) UNIQUE,
    site_name VARCHAR(200),
    last_updt VARCHAR(20),
    min_reg_id VARCHAR(50),
	approx_lon DECIMAL(10,6),
	approx_lat DECIMAL(10,6),
    remarks VARCHAR(200),
    PRIMARY KEY(site_auto_id)
);

-- Create Site_Othername Table
CREATE TABLE usgs_cobalt_us_project.site_othername (
	site_othername_auto_id INT AUTO_INCREMENT,
    site_id VARCHAR(50),
    other_name VARCHAR(200),
    PRIMARY KEY (site_othername_auto_id),
    FOREIGN KEY (site_id) REFERENCES site(site_id)
);

-- Create Mineral_Region Table
CREATE TABLE usgs_cobalt_us_project.mineral_region (
    mineral_region_id INT AUTO_INCREMENT,
    min_reg_id VARCHAR(50),
    min_reg_name VARCHAR(200),
    PRIMARY KEY(mineral_region_id)
);

-- Create Site_Commodity Table
CREATE TABLE usgs_cobalt_us_project.site_commodity (
	site_commodity_auto_id INT AUTO_INCREMENT,
    site_id VARCHAR(50),
    commodity VARCHAR(150),
    PRIMARY KEY(site_commodity_auto_id),
    FOREIGN KEY (site_id) REFERENCES site(site_id)
);

-- Create Site_Data-Availability Table
CREATE TABLE usgs_cobalt_us_project.site_data_availability (
	site_dataavail_auto_id INT AUTO_INCREMENT,
    site_id VARCHAR(50),
    loc_pt BOOLEAN,
    loc_poly BOOLEAN,
    geol_min_occ BOOLEAN,
    resources BOOLEAN,
    production BOOLEAN,
    history BOOLEAN,
    dep_model BOOLEAN,
    descr_sum BOOLEAN,
    PRIMARY KEY(site_dataavail_auto_id),
    FOREIGN KEY (site_id) REFERENCES site(site_id)
);

-- Create Deposition_Model Table
CREATE TABLE usgs_cobalt_us_project.deposition_model (
    dep_model_id INT AUTO_INCREMENT,
    dpmd_nonm VARCHAR(200),
    ref_detail VARCHAR(200),
    dpmd_refid VARCHAR(200),
    remarks VARCHAR(200),
    PRIMARY KEY(dep_model_id)
);

-- Create Geological_Environment_Model Table
CREATE TABLE usgs_cobalt_us_project.geological_environment_model (
    geo_env_id INT AUTO_INCREMENT,
    gem_name VARCHAR(200),
    gem_refid VARCHAR(200),
    remarks VARCHAR(200),
    PRIMARY KEY(geo_env_id)
);

-- Create Site_Feature Table
CREATE TABLE usgs_cobalt_us_project.site_feature (
    site_feature_auto_id INT AUTO_INCREMENT,
    site_id VARCHAR(50),
    ftr_id VARCHAR(50),
    ftr_name VARCHAR(200),
    last_updt VARCHAR(20),
    dep_model_id INT,
    geo_env_id INT,
    remarks VARCHAR(200),
    PRIMARY KEY(site_feature_auto_id),
    FOREIGN KEY (site_id) REFERENCES site(site_id),
    FOREIGN KEY (dep_model_id) REFERENCES deposition_model(dep_model_id),
    FOREIGN KEY (geo_env_id) REFERENCES geological_environment_model(geo_env_id)
);

-- Create Geol_Min_Occ Table
CREATE TABLE usgs_cobalt_us_project.geol_min_occ (
    geol_min_occ_id INT AUTO_INCREMENT,
    site_id VARCHAR(50),
    ftr_id VARCHAR(50),
    last_updt VARCHAR(20),
    ftr_type VARCHAR(100),
    reference_id INT,
    remarks VARCHAR(200),
    PRIMARY KEY(geol_min_occ_id),
    FOREIGN KEY (site_id) REFERENCES site(site_id),
    FOREIGN KEY (reference_id) REFERENCES usgs_cobalt_us_project.reference(reference_id)
);

-- Create Geol_Min_Occ_Value_Material Table
CREATE TABLE usgs_cobalt_us_project.geol_min_occ_value_material (
    value_material_auto_id INT AUTO_INCREMENT,
    geol_min_occ_id INT,
    value_material VARCHAR(100),
    PRIMARY KEY(value_material_auto_id),
    FOREIGN KEY (geol_min_occ_id) REFERENCES geol_min_occ(geol_min_occ_id)
);

-- Create Geol_Min_Occ_Associated_Material Table
CREATE TABLE usgs_cobalt_us_project.geol_min_occ_associated_material (
    assoc_material_auto_id INT AUTO_INCREMENT,
    geol_min_occ_id INT,
    assoc_material VARCHAR(100),
    PRIMARY KEY(assoc_material_auto_id),
    FOREIGN KEY (geol_min_occ_id) REFERENCES geol_min_occ(geol_min_occ_id)
);

-- Create Geol_Min_Occ_Min_Style Table
CREATE TABLE usgs_cobalt_us_project.geol_min_occ_min_style (
    min_style_auto_id INT AUTO_INCREMENT,
    geol_min_occ_id INT,
    min_style VARCHAR(100),
    PRIMARY KEY (min_style_auto_id),
    FOREIGN KEY (geol_min_occ_id) REFERENCES usgs_cobalt_us_project.geol_min_occ(geol_min_occ_id)
);

-- Create Geol_Min_Occ_Min_Age Table
CREATE TABLE usgs_cobalt_us_project.geol_min_occ_min_age (
    min_age_auto_id INT AUTO_INCREMENT,
    geol_min_occ_id INT,
    min_age VARCHAR(100),
    PRIMARY KEY (min_age_auto_id),
    FOREIGN KEY (geol_min_occ_id) REFERENCES usgs_cobalt_us_project.geol_min_occ(geol_min_occ_id)
);

-- Create Geol_Min_Occ_Host_Age Table
CREATE TABLE usgs_cobalt_us_project.geol_min_occ_host_age (
    host_age_auto_id INT AUTO_INCREMENT,
    geol_min_occ_id INT,
    host_age VARCHAR(100),
    PRIMARY KEY (host_age_auto_id),
    FOREIGN KEY (geol_min_occ_id) REFERENCES usgs_cobalt_us_project.geol_min_occ(geol_min_occ_id)
);

-- Create Geol_Min_Occ_Host_Name Table
CREATE TABLE usgs_cobalt_us_project.geol_min_occ_host_name (
    host_name_auto_id INT AUTO_INCREMENT,
    geol_min_occ_id INT,
    host_name VARCHAR(200),
    PRIMARY KEY (host_name_auto_id),
    FOREIGN KEY (geol_min_occ_id) REFERENCES usgs_cobalt_us_project.geol_min_occ(geol_min_occ_id)
);

-- Create Geol_Min_Occ_Host_Litho Table
CREATE TABLE usgs_cobalt_us_project.geol_min_occ_host_litho (
    host_litho_auto_id INT AUTO_INCREMENT,
    geol_min_occ_id INT,
    host_litho VARCHAR(150),
    PRIMARY KEY (host_litho_auto_id),
    FOREIGN KEY (geol_min_occ_id) REFERENCES usgs_cobalt_us_project.geol_min_occ(geol_min_occ_id)
);

-- Create Geol_Min_Occ_Alteration Table
CREATE TABLE usgs_cobalt_us_project.geol_min_occ_alteration (
    alteration_auto_id INT AUTO_INCREMENT,
    geol_min_occ_id INT,
    alteration VARCHAR(150),
    PRIMARY KEY (alteration_auto_id),
    FOREIGN KEY (geol_min_occ_id) REFERENCES usgs_cobalt_us_project.geol_min_occ(geol_min_occ_id)
);

-- Create Descr_Sum Table
CREATE TABLE usgs_cobalt_us_project.descr_sum (
    descr_id INT AUTO_INCREMENT,
    site_id VARCHAR(50),
    ftr_id VARCHAR(50),
    last_updt VARCHAR(20),
    descr_type VARCHAR(100),
    descr TEXT,
    reference_id INT,
    remarks VARCHAR(200),
    PRIMARY KEY(descr_id),
    FOREIGN KEY (site_id) REFERENCES site(site_id),
    FOREIGN KEY (reference_id) REFERENCES usgs_cobalt_us_project.reference(reference_id)
);

-- Create History Table
CREATE TABLE usgs_cobalt_us_project.history (
    history_id INT AUTO_INCREMENT,
    site_id VARCHAR(50),
    ftr_id VARCHAR(50),
    last_updt VARCHAR(20),
    status VARCHAR(100),
    stat_detail VARCHAR(200),
    year_from INT,
    year_to INT,
    ref_detail VARCHAR(200),
    reference_id INT,
    remarks VARCHAR(200),
    PRIMARY KEY(history_id),
    FOREIGN KEY (site_id) REFERENCES site(site_id),
    FOREIGN KEY (reference_id) REFERENCES usgs_cobalt_us_project.reference(reference_id)
);

-- Create Loc_Pt Table
CREATE TABLE usgs_cobalt_us_project.loc_pt (
    loc_pt_id INT AUTO_INCREMENT,
    site_id VARCHAR(50),
    ftr_id VARCHAR(50),
    last_updt VARCHAR(20),
    ftr_group VARCHAR(100),
    ftr_type VARCHAR(100),
    pt_def VARCHAR(100),
    poly_def VARCHAR(100),
    state VARCHAR(10),
    county VARCHAR(100),
    loc_scale VARCHAR(50),
    loc_date INT,
    reference_id INT,
    loc_poly BOOLEAN,
    remarks VARCHAR(200),
    PRIMARY KEY(loc_pt_id),
    FOREIGN KEY (site_id) REFERENCES site(site_id),
    FOREIGN KEY (reference_id) REFERENCES usgs_cobalt_us_project.reference(reference_id)
);

-- Create Commodity Table
CREATE TABLE usgs_cobalt_us_project.loc_pt_commodity (
    loc_pt_commodity_auto_id INT AUTO_INCREMENT,
    loc_pt_id INT,
    commodity VARCHAR(100),
    PRIMARY KEY(loc_pt_commodity_auto_id),
    FOREIGN KEY (loc_pt_id) REFERENCES loc_pt(loc_pt_id)
);

-- Create Loc_Pt_Othername Table
CREATE TABLE usgs_cobalt_us_project.loc_pt_othername (
    loc_pt_othername_auto_id INT AUTO_INCREMENT,
    loc_pt_id INT,
    other_name VARCHAR(200),
    PRIMARY KEY(loc_pt_othername_auto_id),
    FOREIGN KEY (loc_pt_id) REFERENCES loc_pt(loc_pt_id)
);

-- Create Loc_Pt_Ref_Detail Table
CREATE TABLE usgs_cobalt_us_project.loc_pt_ref_detail (
    loc_pt_ref_detail_id INT AUTO_INCREMENT,
    loc_pt_id INT,
    ref_detail VARCHAR(200),
    PRIMARY KEY (loc_pt_ref_detail_id),
    FOREIGN KEY (loc_pt_id) REFERENCES usgs_cobalt_us_project.loc_pt(loc_pt_id)
);

-- Create Loc_Poly Table
CREATE TABLE usgs_cobalt_us_project.loc_poly (
    loc_poly_id INT AUTO_INCREMENT,
    site_id VARCHAR(50),
    ftr_id VARCHAR(50),
    last_updt VARCHAR(20),
    area_sqkm VARCHAR(50),
    area_acres VARCHAR(50),
    remarks VARCHAR(200),
    PRIMARY KEY(loc_poly_id),
    FOREIGN KEY (site_id) REFERENCES site(site_id)
);

-- Create Loc_Poly_Sw Table
CREATE TABLE usgs_cobalt_us_project.loc_poly_sw (
    loc_poly_sw_auto_id INT AUTO_INCREMENT,
    ftr_id VARCHAR(50),
    last_updt VARCHAR(20),
    state VARCHAR(10),
    county VARCHAR(100),
    loc_date INT,
    ref_detail VARCHAR(200),
    reference_id INT,
    area_sqkm VARCHAR(50),
    area_acres VARCHAR(50),
    remarks VARCHAR(200),
    PRIMARY KEY(loc_poly_sw_auto_id),
    FOREIGN KEY (reference_id) REFERENCES usgs_cobalt_us_project.reference(reference_id)
);

-- Create Production Table
CREATE TABLE usgs_cobalt_us_project.production (
    production_id INT AUTO_INCREMENT,
    site_id VARCHAR(50),
    ftr_id VARCHAR(50),
    material VARCHAR(100),
    year_from INT,
    year_to INT,
    mat_type VARCHAR(100),
    mat_amnt DECIMAL(20,6),
    mat_units VARCHAR(50),
    grade DECIMAL(10,6),
    grade_unit VARCHAR(50),
    contained DECIMAL(20,6),
    cont_units VARCHAR(50),
    ref_detail VARCHAR(200),
    reference_id INT,
    remarks VARCHAR(200),
    PRIMARY KEY(production_id),
    FOREIGN KEY (site_id) REFERENCES site(site_id),
    FOREIGN KEY (reference_id) REFERENCES usgs_cobalt_us_project.reference(reference_id)
);

-- Create Resources Table
CREATE TABLE usgs_cobalt_us_project.resources (
    resource_id INT AUTO_INCREMENT,
    site_id VARCHAR(50),
    ftr_id VARCHAR(50),
    material VARCHAR(100),
    rsrc_date INT,
    mat_type VARCHAR(100),
    mat_amnt DECIMAL(20,6),
    mat_units VARCHAR(50),
    grade DECIMAL(10,6),
    grade_unit VARCHAR(50),
    contained DECIMAL(20,6),
    cont_units VARCHAR(50),
    rsrc_class VARCHAR(100),
    rsrc_descr TEXT,
    rsrc_code VARCHAR(50),
    ref_detail VARCHAR(200),
    reference_id INT,
    remarks VARCHAR(200),
    PRIMARY KEY(resource_id),
    FOREIGN KEY (site_id) REFERENCES site(site_id),
    FOREIGN KEY (reference_id) REFERENCES usgs_cobalt_us_project.reference(reference_id)
);


