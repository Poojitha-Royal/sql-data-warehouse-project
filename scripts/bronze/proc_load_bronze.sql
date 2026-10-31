/*
================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
================================================================================

Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.

    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from CSV files into bronze tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;

================================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME,@end_time DATETIME,@batch_start_time DATETIME,@batch_end_time DATETIME;
	BEGIN TRY
	set @batch_start_time=GETDATE();
	PRINT '==========================================================================================================================';
	PRINT 'LOADING BRONZE LAYER';
	PRINT '==========================================================================================================================';

	PRINT '---------------------------------------------------------------------------------------------------------------------------';
	PRINT 'Loading CRM Tables';
    PRINT '---------------------------------------------------------------------------------------------------------------------------';

	set @start_time=GETDATE();
	PRINT '>> Truncating Table: bronze.crm_cust_info';
	TRUNCATE TABLE bronze.crm_cust_info;
	
	PRINT 'Inserting the data into: bronze.crm_cust_info';
	BULK INSERT bronze.crm_cust_info
	FROM 'C:\Users\sreeram poojitha\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	WITH
	(
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		TABLOCK
	);
	set @end_time=GETDATE();

	PRINT '>> Load Duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar)+' seconds.';
	PRINT '---------------------';
	set @start_time=GETDATE();
	PRINT '>> Truncating Table: bronze.crm_prd_info';
	TRUNCATE TABLE bronze.crm_prd_info;

	PRINT 'Inserting the data into: bronze.crm_prd_info';
	BULK INSERT bronze.crm_prd_info
	FROM 'C:\Users\sreeram poojitha\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	WITH
	(
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		TABLOCK
	);

	set @end_time=GETDATE();
	PRINT '>> Load Duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar)+' seconds.';
	PRINT '---------------------';
	set @start_time=GETDATE();
	PRINT '>> Truncating Table: bronze.crm_sales_details';
	TRUNCATE TABLE bronze.crm_sales_details;

	PRINT 'Inserting the data into: bronze.crm_sales_details';
	BULK INSERT bronze.crm_sales_details
	FROM 'C:\Users\sreeram poojitha\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	WITH
	(
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		TABLOCK
	);
	set @end_time=GETDATE();
	PRINT '>> Load Duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar)+' seconds.';
	PRINT '---------------------';
	PRINT '---------------------------------------------------------------------------------------------------------------------------';
	PRINT 'Loading ERP Tables';
    PRINT '---------------------------------------------------------------------------------------------------------------------------';

	set @start_time=GETDATE();
	PRINT '>> Truncating Table: bronze.erp_cust_az12';
	TRUNCATE TABLE bronze.erp_cust_az12;

	PRINT 'Inserting the data into: bronze.erp_cust_az12';
	BULK INSERT bronze.erp_cust_az12
	FROM 'C:\Users\sreeram poojitha\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
	WITH
	(
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		TABLOCK
	);
	set @end_time=GETDATE();
	PRINT '>> Load Duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar)+' seconds.';
	PRINT '---------------------';
	set @start_time=GETDATE();
	PRINT '>> Truncating Table: bronze.erp_loc_a101';
	TRUNCATE TABLE bronze.erp_loc_a101;

	PRINT 'Inserting the data into: bronze.erp_loc_a101';
	BULK INSERT bronze.erp_loc_a101
	FROM 'C:\Users\sreeram poojitha\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
	WITH
	(
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		TABLOCK
	);
	set @end_time=GETDATE();
	PRINT '>> Load Duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar)+' seconds.';
	set @start_time=GETDATE()
	PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
	TRUNCATE TABLE bronze.erp_px_cat_g1v2;

	PRINT 'Inserting the data into: bronze.erp_px_cat_g1v2';
	BULK INSERT bronze.erp_px_cat_g1v2
	FROM 'C:\Users\sreeram poojitha\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
	WITH
	(
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		TABLOCK
	);
	set @end_time=GETDATE();
	PRINT '>> Load Duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar)+' seconds.';
	PRINT '---------------------';
	set @batch_end_time=GETDATE();
	PRINT '============================================================================';
	PRINT 'Loading the Bronze layer is completed';
	PRINT 'Total Load Duration :'+ cast(datediff(second,@batch_start_time,@batch_end_time) as NVARCHAR)+' seconds.';
	PRINT '============================================================================';
	END TRY
	BEGIN CATCH
	PRINT '==============================================';
	PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
	PRINT 'Error_Message'+ ERROR_MESSAGE();
	PRINT 'Error_Number' + CAST(ERROR_NUMBER() AS NVARCHAR);
	PRINT 'Error_Number' + CAST(ERROR_STATE() AS NVARCHAR);
	PRINT '===============================================';
	END CATCH
END
