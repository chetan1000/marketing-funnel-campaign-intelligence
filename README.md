# Marketing Funnel & Campaign Intelligence Dashboard

An end-to-end Business Intelligence project built using **Power BI, MySQL, SQL, Power Query and DAX** to analyze marketing funnel performance, lead conversion, campaign effectiveness and revenue.

## Project Overview

This project demonstrates an end-to-end Business Intelligence workflow centered on **MySQL database integration with Power BI**.

The final portfolio implementation uses a MySQL relational database as the primary data source for Power BI. The project covers database connectivity, SQL-based data validation, data transformation, relational data modeling, DAX measures, interactive dashboards and deployment to Power BI Service.

The project also demonstrates database-driven reporting with gateway configuration, scheduled refresh and row-level security (RLS) testing.

## Business Objectives

- Analyze lead generation and funnel conversion.
- Compare marketing channel and campaign performance.
- Monitor revenue, advertising spend and return on ad spend (ROAS).
- Identify differences in performance across marketing channels.
- Build interactive reports using Power BI and DAX.
- Integrate Power BI with a MySQL relational database.
- Validate source data using SQL queries.
- Configure scheduled refresh and implement row-level security (RLS).

## Technology Stack

| Technology | Purpose |
|---|---|
| MySQL | Primary relational database and data source for the final Power BI implementation |
| SQL | Database inspection, data validation, row counts, date checks and sample record verification |
| Power BI Desktop | Data modeling, DAX measures and interactive dashboard development |
| Power Query | Data transformation, cleaning and preparation |
| DAX | Business metrics and analytical calculations |
| Power BI Service | Report publishing, gateway configuration, scheduled refresh and RLS testing |
| GitHub | Version control, project documentation and portfolio presentation |

## Data Architecture

**MySQL Database → Power BI (Power Query, Data Model and DAX) → Power BI Service**

MySQL serves as the primary data source for the final Power BI implementation. The database contains the relational tables used for reporting and analysis. Power BI connects to MySQL for data transformation, modeling, DAX calculations and dashboard development.

The project includes SQL scripts for database inspection, table validation, row counts, date-range checks and sample record verification.

The original CSV files are retained in the `data/` folder and can be used to populate the MySQL tables when reproducing the project setup.

## Key Features

- MySQL database integration with Power BI
- Relational data modeling and table relationships
- SQL-based data validation and quality checks
- Marketing funnel and conversion analysis
- Campaign and channel performance reporting
- Revenue, advertising spend and ROAS metrics
- DAX measures and interactive report filters
- Power BI Service deployment
- Gateway configuration and scheduled refresh
- Row-level security testing in Power BI Desktop and Service

## Deployment and Validation

The MySQL-connected Power BI report was published to Power BI Service.

The deployment workflow includes:

- MySQL data source connectivity
- Gateway configuration
- Scheduled refresh configuration
- Refresh history verification
- Row-level security testing in Power BI Desktop and Service

A scheduled refresh test completed successfully on 18 October 2026. The project documentation records the validation scenarios and implementation details.

## Repository Structure

- [`README.md`](README.md) — project overview, architecture and navigation
- [`PROJECT_LOG.md`](PROJECT_LOG.md) — technical history, implementation decisions, troubleshooting and validation
- [`INTERVIEW_QA.md`](INTERVIEW_QA.md) — project-based interview questions and answers
- [`data/`](data/) — nine CSV source datasets used to populate the MySQL tables and reproduce the project setup
- [`sql/`](sql/) — MySQL setup, import examples and validation queries
  - [`marketing_funnel_mysql_setup_import_validation.sql`](sql/marketing_funnel_mysql_setup_import_validation.sql) — database setup instructions, CSV import examples, row-count checks and validation queries
- [`powerbi/`](powerbi/) — Power BI report file
- [`screenshots/`](screenshots/) — dashboard pages, data model and Power BI Service screenshots

## How to Explore the Project

1. Start with this README to understand the business objectives, database architecture and reporting workflow.
2. Review [PROJECT_LOG.md](PROJECT_LOG.md) for the development journey, technical decisions, troubleshooting and validation.
3. Explore the [MySQL setup and validation SQL script](sql/marketing_funnel_mysql_setup_import_validation.sql) to review database setup instructions and SQL validation queries.
4. Browse the [CSV source datasets](data/) to understand the tables used to populate the MySQL database.
5. Review the Power BI report in the [`powerbi/`](powerbi/) folder and explore the dashboard and deployment screenshots in [`screenshots/`](screenshots/).
6. Use [INTERVIEW_QA.md](INTERVIEW_QA.md) to prepare for technical discussions about the project.

## Requirements and Notes

Opening the Power BI report locally may require Power BI Desktop, access to a compatible MySQL database and appropriate connection settings. Power BI Service refresh depends on the configured data source, gateway and credentials.

The SQL script documents database setup, CSV import examples and validation queries. Review the connection settings and local CSV file paths before running any import commands.

The CSV datasets are included to support database setup and reproducibility. Verify that all datasets are safe for public sharing before distributing them.

Database credentials, private connection details and confidential company or customer data must not be committed to the repository. Only publish data and files you have permission to share.
