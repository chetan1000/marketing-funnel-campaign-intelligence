# Marketing Funnel & Campaign Intelligence Dashboard

An end-to-end Business Intelligence project built with **Power BI, MySQL, SQL, Power Query and DAX** to analyze marketing funnel performance, lead conversion, campaign effectiveness and revenue.

## Project Overview

This project began with CSV-based data preparation and Power BI dashboard development. It was subsequently extended to use a MySQL database and published to Power BI Service.

The project demonstrates an end-to-end BI workflow covering data preparation, relational data modeling, analytical calculations, interactive reporting, service deployment and validation.

## Business Objectives

- Analyze lead generation and funnel conversion.
- Compare marketing channel and campaign performance.
- Monitor revenue, advertising spend and return on ad spend (ROAS).
- Identify differences in performance across marketing channels.
- Build interactive reports using Power BI and DAX.
- Integrate Power BI with MySQL.
- Configure scheduled refresh and implement row-level security (RLS).

## Technology Stack

| Technology | Purpose |
|---|---|
| Power BI Desktop | Data modeling, DAX measures and dashboard development |
| Power Query | Data cleaning, transformation and preparation |
| MySQL | Relational data storage |
| SQL | Data querying and validation |
| DAX | Business metrics and analytical calculations |
| Power BI Service | Report publishing, gateway configuration and scheduled refresh |

## Data Pipeline

**CSV source files → MySQL database → Power BI data model → Interactive dashboard → Power BI Service**

The original CSV workflow is retained as part of the development history, while the MySQL-connected implementation is the main portfolio version.

## Key Features

- Marketing funnel and conversion analysis
- Campaign and channel performance reporting
- Revenue, advertising spend and ROAS metrics
- Interactive filters and drill-down analysis
- MySQL database integration
- Gateway configuration and scheduled refresh
- Row-level security testing in Power BI Desktop and Service

## Deployment and Validation

The MySQL-connected report was published to Power BI Service. Gateway connectivity and scheduled refresh were configured, and a scheduled refresh test completed successfully on 18 October 2026.

RLS was tested in Power BI Desktop and Service. The project documentation records the tested access scenarios and implementation details.

## Repository Structure

- `README.md` — project overview and instructions
- `PROJECT_LOG.md` — technical history, implementation decisions, troubleshooting and validation
- `INTERVIEW_QA.md` — project-based interview questions and answers
- `sql/` — SQL scripts and validation queries
- `powerbi/` — Power BI report file
- `screenshots/` — dashboard and data model screenshots
- `docs/` — supporting technical documentation

## How to Explore the Project

1. Start with this README to understand the business objectives and architecture.
2. Review `PROJECT_LOG.md` for the development journey and technical decisions.
3. Explore the SQL scripts and database validation queries.
4. Review the Power BI report and screenshots.
5. Use `INTERVIEW_QA.md` to prepare for technical discussions about the project.

## Requirements and Notes

Opening the Power BI report locally may require Power BI Desktop and a compatible MySQL connection. Power BI Service refresh also depends on the configured data source and gateway.

Database credentials, private connection details and confidential data must not be committed to the repository. Only publish data and files you have permission to share.