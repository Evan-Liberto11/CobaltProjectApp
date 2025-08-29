-- Raw data loading --
-- These commands load all relevant CSV files into their corresponding MySQL tables.
-- Each file is located in the User's Downloads folder under USGS_Cobalt_US-CSV.
-- These tables are the foundation of our Database so it is very important
-- That these files all loaded after the Creation of the Raw Data Tables has
-- been completed.


-- Load Data from Site.csv --
LOAD DATA LOCAL INFILE 'C:/Users/evanl/Downloads/USGS_Cobalt_US_CSV/Site.csv'
INTO TABLE usgs_cobalt_us_project.original_site
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
SET
  other_name = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(other_name), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  min_reg_id = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(min_reg_id), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  remarks = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(remarks), '\r', ''), '\n', ''), '"', ''), '<Null>');

-- Load Data from Dep_Model.csv --
LOAD DATA LOCAL INFILE 'C:/Users/evanl/Downloads/USGS_Cobalt_US_CSV/Dep_Model.csv'
INTO TABLE usgs_cobalt_us_project.original_dep_model
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
SET
  ref_detail = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(ref_detail), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  gem_name = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(gem_name), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  gem_refid = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(gem_refid), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  remarks = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(remarks), '\r', ''), '\n', ''), '"', ''), '<Null>');

-- Load Data from Descr_Sum.csv --
LOAD DATA LOCAL INFILE 'C:/Users/evanl/Downloads/USGS_Cobalt_US_CSV/Descr_Sum.csv'
INTO TABLE usgs_cobalt_us_project.original_descr_sum
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
SET
  remarks = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(remarks), '\r', ''), '\n', ''), '"', ''), '<Null>');

-- Load Data from GeolMinOcc.csv --
LOAD DATA LOCAL INFILE 'C:/Users/evanl/Downloads/USGS_Cobalt_US_CSV/GeolMinOcc.csv'
INTO TABLE usgs_cobalt_us_project.original_geol_min_occ
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
SET
  value_mat = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(value_mat), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  assoc_mat = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(assoc_mat), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  min_style = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(min_style), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  min_age = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(min_age), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  host_age = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(host_age), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  host_name = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(host_name), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  alteration = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(alteration), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  remarks = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(remarks), '\r', ''), '\n', ''), '"', ''), '<Null>');

-- Load Data from History.csv --
LOAD DATA LOCAL INFILE 'C:/Users/evanl/Downloads/USGS_Cobalt_US_CSV/History.csv'
INTO TABLE usgs_cobalt_us_project.original_history
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
SET
  ref_detail = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(ref_detail), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  ref_id = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(ref_id), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  remarks = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(remarks), '\r', ''), '\n', ''), '"', ''), '<Null>');

-- Load Data from Loc_Poly.csv --
LOAD DATA LOCAL INFILE 'C:/Users/evanl/Downloads/USGS_Cobalt_US_CSV/Loc_Poly.csv'
INTO TABLE usgs_cobalt_us_project.original_loc_poly
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
SET
  remarks = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(remarks), '\r', ''), '\n', ''), '"', ''), '<Null>');

-- Load Data from Loc_Poly_Sw.csv --
LOAD DATA LOCAL INFILE 'C:/Users/evanl/Downloads/USGS_Cobalt_US_CSV/Loc_Poly_Sw.csv'
INTO TABLE usgs_cobalt_us_project.original_loc_poly_sw
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
SET
  remarks = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(remarks), '\r', ''), '\n', ''), '"', ''), '<Null>');

-- Load Data from Loc_Pt.csv --
LOAD DATA LOCAL INFILE 'C:/Users/evanl/Downloads/USGS_Cobalt_US_CSV/Loc_Pt.csv'
INTO TABLE usgs_cobalt_us_project.original_loc_pt
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
SET
  other_name = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(other_name), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  poly_def = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(poly_def), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  loc_scale = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(loc_scale), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  ref_detail = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(ref_detail), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  remarks = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(remarks), '\r', ''), '\n', ''), '"', ''), '<Null>');

-- Load Data from Production.csv --
LOAD DATA LOCAL INFILE 'C:/Users/evanl/Downloads/USGS_Cobalt_US_CSV/Production.csv'
INTO TABLE usgs_cobalt_us_project.original_production
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
SET
  grade = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(grade), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  grade_unit = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(grade_unit), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  cutoffgrad = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(cutoffgrad), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  cutoffunit = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(cutoffunit), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  rcvry_amt = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(rcvry_amt), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  rcvry_unit = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(rcvry_unit), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  prod_usd = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(prod_usd), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  gradesi = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(gradesi), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  gradunitsi = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(gradunitsi), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  cog_si = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(cog_si), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  cou_si = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(cou_si), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  rcvryamtsi = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(rcvryamtsi), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  rcvryuntsi = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(rcvryuntsi), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  ref_detail = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(ref_detail), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  remarks = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(remarks), '\r', ''), '\n', ''), '"', ''), '<Null>');

-- Load Data from References.csv --
LOAD DATA LOCAL INFILE 'C:/Users/evanl/Downloads/USGS_Cobalt_US_CSV/References.csv'
INTO TABLE usgs_cobalt_us_project.original_references
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Load Data from Resources.csv --
LOAD DATA LOCAL INFILE 'C:/Users/evanl/Downloads/USGS_Cobalt_US_CSV/Resources.csv'
INTO TABLE usgs_cobalt_us_project.original_resources
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
SET
  cut_off_grad = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(cut_off_grad), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  cut_off_unit = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(cut_off_unit), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  cog_si = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(cog_si), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  cou_si = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(cou_si), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  rsrc_class = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(rsrc_class), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  rsrc_descr = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(rsrc_descr), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  rsrc_code = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(rsrc_code), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  ref_detail = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(ref_detail), '\r', ''), '\n', ''), '"', ''), '<Null>'),
  remarks = NULLIF(REPLACE(REPLACE(REPLACE(TRIM(remarks), '\r', ''), '\n', ''), '"', ''), '<Null>');
