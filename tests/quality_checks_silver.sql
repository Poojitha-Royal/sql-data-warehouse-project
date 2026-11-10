
/*
================================================================================
Quality Checks: Silver Layer
================================================================================

Script Purpose:
    This script performs data quality checks on the Silver layer tables
    to validate data consistency, completeness, and accuracy.

Quality Checks Performed:
    - NULL values and duplicate records validation
    - Extra spaces validation
    - Data standardization and consistency
    - Invalid and negative values validation
    - Date range validation
    - Business rule validation

Tables:
    - silver.crm_cust_info
    - silver.crm_prd_info
    - silver.crm_sales_details
    - silver.erp_cust_az12
    - silver.erp_loc_a101
    - silver.erp_px_cat_g1v2

Usage Notes:
    - Execute this script after successfully loading the Silver layer.
    - These queries are intended for validation purposes only.
    - They do not modify or delete any existing data.
    - Queries returning records may indicate data quality issues.

================================================================================
*/


/*
================================================================================
1. Checking CRM Customer Information
================================================================================
*/

-- Check for NULL values or duplicates in Primary Key
-- Expectation: No Result

SELECT
    cst_id,
    COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;


-- Check for Extra Spaces
-- Expectation: No Result

SELECT
    cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);


-- Data Standardisation and Consistency

SELECT DISTINCT
    cst_gndr
FROM silver.crm_cust_info;

SELECT DISTINCT
    cst_marital_status
FROM silver.crm_cust_info;


/*
================================================================================
2. Checking CRM Product Information
================================================================================
*/

-- Check for NULL values or duplicates in Primary Key
-- Expectation: No Result

SELECT
    prd_id,
    COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;


-- Check for Extra Spaces
-- Expectation: No Result

SELECT
    prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);


-- Checking for NULL or Negative Values
-- Expectation: No Result

SELECT
    prd_cost
FROM silver.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0;


-- Data Standardisation and Consistency

SELECT DISTINCT
    prd_line
FROM silver.crm_prd_info;


-- Check for Invalid Product Date Ranges
-- Expectation: No Result

SELECT *
FROM silver.crm_prd_info
WHERE prd_start_dt > prd_end_dt;


/*
================================================================================
3. Checking CRM Sales Details
================================================================================
*/

-- Check for NULL values in Order Number
-- Expectation: No Result

SELECT *
FROM silver.crm_sales_details
WHERE sls_ord_num IS NULL;


-- Check for NULL Product and Customer Keys
-- Expectation: No Result

SELECT *
FROM silver.crm_sales_details
WHERE sls_prd_key IS NULL
   OR sls_cust_id IS NULL;


-- Check for Invalid Order, Shipping and Due Dates
-- Expectation: No Result

SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt IS NULL
   OR sls_ship_dt IS NULL
   OR sls_due_dt IS NULL;


-- Check for Invalid Date Ranges
-- Expectation: No Result

SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;


-- Check for NULL or Negative Sales Values
-- Expectation: No Result

SELECT *
FROM silver.crm_sales_details
WHERE sls_sales IS NULL
   OR sls_sales <= 0;


-- Check for NULL or Invalid Quantity Values
-- Expectation: No Result

SELECT *
FROM silver.crm_sales_details
WHERE sls_quantity IS NULL
   OR sls_quantity <= 0;


-- Check for NULL or Invalid Price Values
-- Expectation: No Result

SELECT *
FROM silver.crm_sales_details
WHERE sls_price IS NULL
   OR sls_price <= 0;


-- Check Sales Calculation Consistency
-- Expectation: No Result

SELECT *
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * ABS(sls_price);


/*
================================================================================
4. Checking ERP Customer Information
================================================================================
*/

-- Check for NULL values or duplicates in Customer ID
-- Expectation: No Result

SELECT
    CID,
    COUNT(*)
FROM silver.erp_cust_az12
GROUP BY CID
HAVING COUNT(*) > 1 OR CID IS NULL;


-- Check for Invalid Birth Dates
-- Expectation: No Result

SELECT *
FROM silver.erp_cust_az12
WHERE BDATE > GETDATE();


-- Check for NULL Birth Dates
-- Expectation: Review Required

SELECT *
FROM silver.erp_cust_az12
WHERE BDATE IS NULL;


-- Data Standardisation and Consistency

SELECT DISTINCT
    GEN
FROM silver.erp_cust_az12;


-- Check for Invalid Gender Values
-- Expectation: No Result

SELECT *
FROM silver.erp_cust_az12
WHERE GEN NOT IN ('Male', 'Female', 'n/a');


/*
================================================================================
5. Checking ERP Location Information
================================================================================
*/

-- Check for NULL values or duplicates in Customer ID
-- Expectation: No Result

SELECT
    cid,
    COUNT(*)
FROM silver.erp_loc_a101
GROUP BY cid
HAVING COUNT(*) > 1 OR cid IS NULL;


-- Check for Extra Spaces in Country Names
-- Expectation: No Result

SELECT *
FROM silver.erp_loc_a101
WHERE cntry != TRIM(cntry);


-- Check for NULL or Missing Country Values
-- Expectation: No Result

SELECT *
FROM silver.erp_loc_a101
WHERE cntry IS NULL
   OR TRIM(cntry) = '';


-- Data Standardisation and Consistency

SELECT DISTINCT
    cntry
FROM silver.erp_loc_a101;


/*
================================================================================
6. Checking ERP Product Category Information
================================================================================
*/

-- Check for NULL values or duplicates in Category ID
-- Expectation: No Result

SELECT
    ID,
    COUNT(*)
FROM silver.erp_px_cat_g1v2
GROUP BY ID
HAVING COUNT(*) > 1 OR ID IS NULL;


-- Check for NULL Category Names
-- Expectation: No Result

SELECT *
FROM silver.erp_px_cat_g1v2
WHERE CAT IS NULL;


-- Check for NULL Subcategory Names
-- Expectation: No Result

SELECT *
FROM silver.erp_px_cat_g1v2
WHERE SUBCAT IS NULL;


-- Check for NULL Maintenance Values
-- Expectation: Review Required

SELECT *
FROM silver.erp_px_cat_g1v2
WHERE MAINTENANCE IS NULL;


-- Data Standardisation and Consistency

SELECT DISTINCT
    CAT
FROM silver.erp_px_cat_g1v2;

SELECT DISTINCT
    SUBCAT
FROM silver.erp_px_cat_g1v2;

SELECT DISTINCT
    MAINTENANCE
FROM silver.erp_px_cat_g1v2;


/*
================================================================================
END OF SILVER LAYER QUALITY CHECKS
================================================================================
*/
