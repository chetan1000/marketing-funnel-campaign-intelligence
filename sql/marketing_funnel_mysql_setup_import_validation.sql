
/*
===============================================================================
PROJECT : Marketing Funnel & Campaign Intelligence
DATABASE: marketing_funnel_mysql
FILE    : marketing_funnel_mysql_setup_import_validation.sql

PURPOSE
  Document the MySQL database setup, table structures, CSV import approach,
  and data validation queries used in this Power BI project.

HOW TO USE THIS FILE
  1. Section 1: Verify the MySQL connection and database.
  2. Section 2: Review the nine table definitions.
  3. Section 3: Inspect table columns and data types.
  4. Section 4: Refer to the CSV import examples when needed.
  5. Section 5: Check row counts across all tables.
  6. Section 6: Validate data and preview sample records.
  7. Section 7: Troubleshoot connection and import issues.

IMPORTANT SAFETY NOTES
  - CREATE TABLE and LOAD DATA statements are commented out by default.
  - Check existing row counts before importing data again.
  - FactLeads.csv was previously imported using MySQL Workbench's Import Wizard.
  - The original CSV folder was:
    C:/Users/Chetan/Downloads/MarTech_PowerBI_Project_Tables/
  - The destructive DELETE FROM DimDate command is intentionally omitted.
  - Review the CSV column order, date format, and line endings before importing.

===============================================================================
*/


-- =============================================================================
-- SECTION 1: MYSQL CONNECTION AND DATABASE CHECKS
-- Purpose: Confirm the MySQL server and database being used.
-- =============================================================================

-- Check MySQL version and server details.
SELECT
    VERSION() AS MySQL_Version,
    @@hostname AS server_host,
    @@port AS server_port;

-- Check the current connection and authenticated account.
SELECT
    USER() AS connected_user,
    CURRENT_USER() AS authenticated_user;

-- List available databases.
SHOW DATABASES;

-- Create the database only if it does not already exist.
-- Uncomment only if database creation is required.
-- CREATE DATABASE IF NOT EXISTS marketing_funnel_mysql;

-- Select the project database.
USE marketing_funnel_mysql;

-- Verify the selected database and list its tables.
SELECT DATABASE() AS selected_database;

SHOW TABLES;

-- Check whether LOCAL INFILE is enabled.
SHOW GLOBAL VARIABLES LIKE 'local_infile';

SHOW SESSION VARIABLES LIKE 'local_infile';

-- Administrative command: run only if required and permitted.
-- This may require elevated privileges.
-- SET GLOBAL local_infile = ON;


-- =============================================================================
-- SECTION 2: DATABASE TABLE DEFINITIONS
-- Purpose: Document the nine tables used in the project.
-- These CREATE TABLE statements are examples, not active commands.
-- Uncomment a definition only if the table does not already exist.
-- =============================================================================


-- 2.1 DimCampaign
-- Stores campaign names, marketing channels, and objectives.

-- CREATE TABLE DimCampaign (
--     CampaignID   VARCHAR(10) NOT NULL,
--     CampaignName VARCHAR(100),
--     Channel      VARCHAR(50),
--     Objective    VARCHAR(50),
--     PRIMARY KEY (CampaignID)
-- );


-- 2.2 DimDate
-- Stores one record per calendar date.

-- CREATE TABLE DimDate (
--     `Date`    DATE NOT NULL,
--     `Year`    SMALLINT,
--     MonthNo   TINYINT,
--     `Month`   VARCHAR(15),
--     Quarter   VARCHAR(2),
--     YearMonth CHAR(7),
--     DayName   VARCHAR(10),
--     PRIMARY KEY (`Date`)
-- );


-- 2.3 DimMonth
-- Stores monthly date information for data recorded at monthly grain.

-- CREATE TABLE DimMonth (
--     `Start of Month` DATE NOT NULL,
--     `Year`           SMALLINT,
--     MonthNo          TINYINT,
--     `Month`          VARCHAR(15),
--     YearMonth        CHAR(7),
--     PRIMARY KEY (`Start of Month`)
-- );


-- 2.4 DimCustomer
-- Stores customer attributes.

-- CREATE TABLE DimCustomer (
--     CustomerID     VARCHAR(10) NOT NULL,
--     CustomerType   VARCHAR(30),
--     AgeBand        VARCHAR(10),
--     CustomerCity   VARCHAR(50),
--     CustomerStatus VARCHAR(30),
--     PRIMARY KEY (CustomerID)
-- );


-- 2.5 FactLeads
-- Stores lead-level information, including status, city, and revenue.

-- CREATE TABLE FactLeads (
--     LeadID     VARCHAR(10) NOT NULL,
--     LeadDate   DATE,
--     CampaignID VARCHAR(10),
--     Source     VARCHAR(50),
--     City       VARCHAR(50),
--     Program    VARCHAR(100),
--     LeadStatus VARCHAR(30),
--     Revenue    DECIMAL(12,2),
--     PRIMARY KEY (LeadID)
-- );


-- 2.6 FactAdSpend
-- Stores advertising performance by date and campaign.

-- CREATE TABLE FactAdSpend (
--     `Date`              DATE NOT NULL,
--     CampaignID          VARCHAR(10) NOT NULL,
--     AdSpend             DECIMAL(12,2),
--     Impressions         INT,
--     Clicks              INT,
--     PlatformConversions INT,
--     PRIMARY KEY (`Date`, CampaignID)
-- );


-- 2.7 CampaignBudget
-- Stores monthly budget information for campaigns.

-- CREATE TABLE CampaignBudget (
--     BudgetID     VARCHAR(15) NOT NULL,
--     CampaignID   VARCHAR(10),
--     MonthStart   DATE,
--     BudgetAmount DECIMAL(12,2),
--     PRIMARY KEY (BudgetID)
-- );


-- 2.8 CRMActivity
-- Stores CRM activities associated with leads.

-- CREATE TABLE CRMActivity (
--     ActivityID   VARCHAR(10) NOT NULL,
--     LeadID       VARCHAR(10),
--     ActivityDate DATE,
--     ActivityType VARCHAR(30),
--     Outcome      VARCHAR(30),
--     PRIMARY KEY (ActivityID)
-- );


-- 2.9 LeadStageHistory
-- Stores historical lead-stage events.

-- CREATE TABLE LeadStageHistory (
--     StageHistoryID VARCHAR(12) NOT NULL,
--     LeadID         VARCHAR(10),
--     Stage          VARCHAR(30),
--     StageDate      DATE,
--     StageOrder     TINYINT,
--     PRIMARY KEY (StageHistoryID)
-- );


-- =============================================================================
-- SECTION 3: INSPECT TABLE STRUCTURES
-- Purpose: Review column names, data types, and key definitions.
-- These are read-only inspection queries.
-- =============================================================================

DESCRIBE DimCampaign;

DESCRIBE DimCustomer;

DESCRIBE DimDate;

DESCRIBE DimMonth;

DESCRIBE FactLeads;

DESCRIBE FactAdSpend;

DESCRIBE CampaignBudget;

DESCRIBE CRMActivity;

DESCRIBE LeadStageHistory;


-- =============================================================================
-- SECTION 4: CSV IMPORT EXAMPLES
-- Purpose: Document how the source CSV files can be loaded into MySQL.
--
-- IMPORTANT:
-- All imports are commented out to prevent accidental re-imports.
-- Before importing, verify the target table, file path, column order,
-- date format, and line endings.
-- =============================================================================


-- 4.1 Import DimCampaign.csv

-- LOAD DATA LOCAL INFILE
-- 'C:/Users/Chetan/Downloads/MarTech_PowerBI_Project_Tables/DimCampaign.csv'
-- INTO TABLE DimCampaign
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 LINES
-- (CampaignID, CampaignName, Channel, Objective);


-- 4.2 Import DimCustomer.csv

-- LOAD DATA LOCAL INFILE
-- 'C:/Users/Chetan/Downloads/MarTech_PowerBI_Project_Tables/DimCustomer.csv'
-- INTO TABLE DimCustomer
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 LINES;


-- 4.3 Import DimDate.csv
-- Choose ONE option after checking the date format in the source CSV.

-- Option A: source dates are DD-MM-YYYY.

-- LOAD DATA LOCAL INFILE
-- 'C:/Users/Chetan/Downloads/MarTech_PowerBI_Project_Tables/DimDate.csv'
-- INTO TABLE DimDate
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 LINES
-- (@DateValue, `Year`, MonthNo, `Month`, Quarter, YearMonth, DayName)
-- SET `Date` = STR_TO_DATE(@DateValue, '%d-%m-%Y');


-- Option B: source dates are already in YYYY-MM-DD format.
-- Do not run Option A and Option B together.

-- LOAD DATA LOCAL INFILE
-- 'C:/Users/Chetan/Downloads/MarTech_PowerBI_Project_Tables/DimDate.csv'
-- INTO TABLE DimDate
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 LINES
-- (`Date`, `Year`, MonthNo, `Month`, Quarter, YearMonth, DayName);


-- 4.4 Import DimMonth.csv

-- LOAD DATA LOCAL INFILE
-- 'C:/Users/Chetan/Downloads/MarTech_PowerBI_Project_Tables/DimMonth.csv'
-- INTO TABLE DimMonth
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 LINES
-- (`Start of Month`, `Year`, MonthNo, `Month`, YearMonth);


-- 4.5 Import FactAdSpend.csv

-- LOAD DATA LOCAL INFILE
-- 'C:/Users/Chetan/Downloads/MarTech_PowerBI_Project_Tables/FactAdSpend.csv'
-- INTO TABLE FactAdSpend
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 LINES
-- (`Date`, CampaignID, AdSpend, Impressions, Clicks, PlatformConversions);


-- 4.6 Import CampaignBudget.csv

-- LOAD DATA LOCAL INFILE
-- 'C:/Users/Chetan/Downloads/MarTech_PowerBI_Project_Tables/CampaignBudget.csv'
-- INTO TABLE CampaignBudget
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 LINES
-- (BudgetID, CampaignID, MonthStart, BudgetAmount);


-- 4.7 Import CRMActivity.csv

-- LOAD DATA LOCAL INFILE
-- 'C:/Users/Chetan/Downloads/MarTech_PowerBI_Project_Tables/CRMActivity.csv'
-- INTO TABLE CRMActivity
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 LINES
-- (ActivityID, LeadID, ActivityDate, ActivityType, Outcome);


-- 4.8 Import LeadStageHistory.csv

-- LOAD DATA LOCAL INFILE
-- 'C:/Users/Chetan/Downloads/MarTech_PowerBI_Project_Tables/LeadStageHistory.csv'
-- INTO TABLE LeadStageHistory
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 LINES
-- (StageHistoryID, LeadID, Stage, StageDate, StageOrder);


-- FactLeads.csv was previously imported using MySQL Workbench's Import Wizard.
-- Check the existing row count before considering another import.


-- =============================================================================
-- SECTION 5: ROW COUNTS ACROSS ALL NINE TABLES
-- Purpose: Quickly check how many records are currently loaded in each table.
-- Compare these results with the expected source data.
-- =============================================================================

SELECT
    'FactLeads' AS TableName,
    COUNT(*) AS TotalRows
FROM FactLeads

UNION ALL

SELECT 'DimCampaign', COUNT(*)
FROM DimCampaign

UNION ALL

SELECT 'DimCustomer', COUNT(*)
FROM DimCustomer

UNION ALL

SELECT 'DimDate', COUNT(*)
FROM DimDate

UNION ALL

SELECT 'DimMonth', COUNT(*)
FROM DimMonth

UNION ALL

SELECT 'FactAdSpend', COUNT(*)
FROM FactAdSpend

UNION ALL

SELECT 'CampaignBudget', COUNT(*)
FROM CampaignBudget

UNION ALL

SELECT 'CRMActivity', COUNT(*)
FROM CRMActivity

UNION ALL

SELECT 'LeadStageHistory', COUNT(*)
FROM LeadStageHistory;


-- =============================================================================
-- SECTION 6: DATA VALIDATION AND SAMPLE RECORDS
-- Purpose: Check key uniqueness, date coverage, row counts, and sample data.
-- =============================================================================


-- 6.1 DimCampaign: compare total rows with distinct campaign IDs.
-- A positive DuplicateIDs value can indicate repeated or missing campaign IDs.

SELECT
    COUNT(*) AS TotalRows,
    COUNT(DISTINCT CampaignID) AS UniqueCampaigns,
    COUNT(*) - COUNT(DISTINCT CampaignID) AS DuplicateIDs
FROM DimCampaign;

-- Preview five campaigns.
SELECT *
FROM DimCampaign
ORDER BY CampaignID
LIMIT 5;


-- 6.2 DimCustomer: count customers and preview sample records.

SELECT COUNT(*) AS TotalRows
FROM DimCustomer;

SELECT *
FROM DimCustomer
LIMIT 5;


-- 6.3 DimDate: check calendar row count and date coverage.

SELECT
    COUNT(*) AS TotalRows,
    MIN(`Date`) AS FirstDate,
    MAX(`Date`) AS LastDate
FROM DimDate;

SELECT *
FROM DimDate
ORDER BY `Date`
LIMIT 5;


-- 6.4 DimMonth: check monthly row count and month coverage.

SELECT
    COUNT(*) AS TotalRows,
    MIN(`Start of Month`) AS FirstMonth,
    MAX(`Start of Month`) AS LastMonth
FROM DimMonth;

SELECT *
FROM DimMonth
ORDER BY `Start of Month`
LIMIT 5;


-- 6.5 FactLeads: count leads and preview sample records.

SELECT COUNT(*) AS TotalLeads
FROM FactLeads;

SELECT *
FROM FactLeads
ORDER BY LeadDate, LeadID
LIMIT 5;


-- 6.6 FactAdSpend: check advertising data coverage.

SELECT
    COUNT(*) AS TotalRows,
    MIN(`Date`) AS FirstDate,
    MAX(`Date`) AS LastDate
FROM FactAdSpend;

SELECT *
FROM FactAdSpend
ORDER BY `Date`, CampaignID
LIMIT 5;


-- 6.7 CampaignBudget: check budget records, date range, and unique budget IDs.

SELECT
    COUNT(*) AS TotalRows,
    MIN(MonthStart) AS FirstMonth,
    MAX(MonthStart) AS LastMonth,
    COUNT(DISTINCT BudgetID) AS UniqueBudgetIDs
FROM CampaignBudget;

SELECT *
FROM CampaignBudget
ORDER BY MonthStart, CampaignID
LIMIT 5;


-- 6.8 CRMActivity: check activity records and date coverage.

SELECT
    COUNT(*) AS TotalRows,
    COUNT(DISTINCT ActivityID) AS UniqueActivityIDs,
    MIN(ActivityDate) AS FirstDate,
    MAX(ActivityDate) AS LastDate
FROM CRMActivity;

SELECT *
FROM CRMActivity
ORDER BY ActivityID
LIMIT 5;


-- 6.9 LeadStageHistory: check history records and stage date coverage.

SELECT
    COUNT(*) AS TotalRows,
    COUNT(DISTINCT StageHistoryID) AS UniqueHistoryIDs,
    MIN(StageDate) AS FirstDate,
    MAX(StageDate) AS LastDate
FROM LeadStageHistory;

SELECT *
FROM LeadStageHistory
ORDER BY StageDate, LeadID
LIMIT 5;


-- =============================================================================
-- SECTION 7: TROUBLESHOOTING HELPERS
-- Purpose: Confirm the active connection and investigate import issues.
-- =============================================================================

-- Confirm the selected database.
SELECT DATABASE() AS selected_database;

-- Confirm which MySQL server this connection is using.
SELECT
    @@hostname AS server_host,
    @@port AS server_port,
    VERSION() AS mysql_version;

-- Check the session-level LOCAL INFILE setting.
SHOW SESSION VARIABLES LIKE 'local_infile';

-- Run immediately after a LOAD DATA statement to inspect warnings.
-- SHOW WARNINGS;

-- Account-inspection queries used during troubleshooting.
-- These may require elevated privileges and are not needed for routine checks.
-- SELECT USER(), CURRENT_USER();
-- SELECT user, host, plugin
-- FROM mysql.user
-- WHERE user = 'root';


-- =============================================================================
-- END OF SCRIPT
-- =============================================================================
