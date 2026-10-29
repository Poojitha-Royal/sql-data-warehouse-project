
/*
================================================================================
Project     : Data Warehouse
Script      : 01_create_database_and_schemas.sql
Description : Creates the DataWarehouse database and initializes the
              Bronze, Silver, and Gold schemas using the Medallion Architecture.
================================================================================

Medallion Architecture:
    Bronze - Stores raw data ingested from source systems.
    Silver - Stores cleaned, validated, and transformed data.
    Gold   - Stores business-ready data for reporting and analytics.

Note:
    Run this script in SQL Server Management Studio (SSMS).
    Database creation requires appropriate permissions.
*/

-- Step 1: Switch to the master database.
-- The master database stores SQL Server instance-level metadata.
-- We use it before creating a new database to avoid depending on
-- an existing user database as the current execution context.

USE master;
GO

-- Step 2: Drop the database if it already exists.
-- This ensures that the script starts with a clean database.

IF EXISTS (SELECT 1 FROM sys.databases where name='DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse
        SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE DataWarehouse;
END;  

-- Step 3: Create the DataWarehouse database.
-- This database will contain all objects used in the data warehouse project.

CREATE DATABASE DataWarehouse;
GO

-- Step 4: Switch to the newly created DataWarehouse database.
-- All subsequent schema creation statements will run in this database.

USE DataWarehouse;
GO

-- Step 5: Create the Bronze schema.
-- Purpose: Store raw data as received from source systems,
-- preserving the original structure as much as possible.

CREATE SCHEMA bronze;
GO

-- Step 6: Create the Silver schema.
-- Purpose: Store cleaned and standardized data after applying
-- data quality checks, deduplication, and transformations.

CREATE SCHEMA silver;
GO

-- Step 7: Create the Gold schema.
-- Purpose: Store business-ready data models, such as fact tables
-- and dimension tables, for reporting, dashboards, and analytics.

CREATE SCHEMA gold;
GO

/*
================================================================================
Expected Result:
    Database:
        DataWarehouse

    Schemas:
        DataWarehouse.bronze
        DataWarehouse.silver
        DataWarehouse.gold

Next Step:
    Create source tables and ingestion scripts in the Bronze layer.
================================================================================
*/
