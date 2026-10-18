# Marketing Funnel & Campaign Intelligence — PROJECT LOG

> **CONSOLIDATED MASTER DOCUMENT — updated 18 October 2026**  
> This is the authoritative consolidated master, not a new numbered version. Historical sections are retained for traceability; where an older status conflicts with a later dated entry, the latest documented evidence and the current-status summary below take precedence.

> **Sharing/privacy note:** Personal email addresses, local Windows paths, and the gateway host/name in historical examples have been replaced with generic placeholders for safer review and possible portfolio publication. Any `@example.com` address is a documentation alias only—not a real account and not a value to paste into the PBIX. Use the actual authorized UPNs only inside your private Power BI environment. No password or gateway recovery key is recorded.

## Current status at a glance (18 October 2026)

### Completed / verified
- All nine project data tables were imported into the MySQL database `marketing_funnel_mysql`; the individual row counts are documented in the source-data section and import log.
- A separate MySQL-based PBIX was published to Power BI Service. The original CSV-based report and semantic model remain separate and must not be overwritten.
- The on-premises gateway was installed, registered, reported Online/Enabled, and mapped to the MySQL semantic model through the gateway connection.
- Manual Power BI Service refresh succeeded, and a scheduled-refresh test on 18 October completed with **Completed** status and no reported error.
- The intended daily schedule is **10:00 AM and 8:00 PM IST**. Subsequent runs at those configured slots still need monitoring; the successful test run itself occurred at approximately 6 PM IST.
- Service report values and filter behavior were compared with Desktop for documented scenarios, including the 30,000-lead all-data view and filtered Google/date views.
- RLS behavior was tested in Power BI Desktop and Power BI Service using role testing: no role showed all cities; `RLS_Bangalore` showed Bangalore only; `RLS_Dynamic` showed Bangalore for the tested Bangalore mapping.
- Temporary diagnostic visuals were removed and the report layout was restored after validation.

### Pending validation / follow-up
- Monitor future scheduled refresh history at 10:00 AM and 8:00 PM IST, and verify gateway/MySQL availability after a laptop restart. A local gateway refresh depends on the laptop, MySQL service, and gateway being available.
- Test `RLS_Dynamic` for Mumbai, Delhi, and `ALL` using suitable authorized test identities. These scenarios are **not yet validated** in Service.
- Complete a documented table-by-table and KPI parity check between the original CSV model and MySQL model. The post-migration display of approximately 48M Revenue and 10.17 ROAS was observed, but those values alone do not prove parity with the original baseline.
- **Row-count reconciliation is unresolved:** the nine historical per-table counts sum arithmetically to **120,134**, while an older aggregate statement says **83,754**. Neither aggregate should be described as the live database total until the query below is rerun against the current database. The 120,134 figure is only the sum of the recorded counts, not a fresh database measurement.
- Prepare GitHub-safe documentation and assets only after review. Do not upload to GitHub as part of this consolidation. Exclude passwords, gateway recovery keys, credentials, private account details, machine-specific paths, and sensitive data from any later public repository.
- **Credential hardening before any public/demo reuse:** the historical gateway connection setup recorded the MySQL username `root` (no password is documented). Prefer a dedicated least-privilege MySQL account for the Power BI connection, verify it has only the permissions required for refresh, and never commit credentials or recovery keys.



### Current row-count reconciliation query (MySQL 8.0+)

Run this in MySQL Workbench after selecting `marketing_funnel_mysql`. It returns each table count and a total calculated from those live counts. Save the result/date with the project notes.

```sql
USE marketing_funnel_mysql;

WITH table_counts AS (
    SELECT 'FactLeads' AS table_name, COUNT(*) AS row_count FROM FactLeads
    UNION ALL SELECT 'DimCampaign', COUNT(*) FROM DimCampaign
    UNION ALL SELECT 'DimCustomer', COUNT(*) FROM DimCustomer
    UNION ALL SELECT 'DimDate', COUNT(*) FROM DimDate
    UNION ALL SELECT 'DimMonth', COUNT(*) FROM DimMonth
    UNION ALL SELECT 'FactAdSpend', COUNT(*) FROM FactAdSpend
    UNION ALL SELECT 'CampaignBudget', COUNT(*) FROM CampaignBudget
    UNION ALL SELECT 'CRMActivity', COUNT(*) FROM CRMActivity
    UNION ALL SELECT 'LeadStageHistory', COUNT(*) FROM LeadStageHistory
)
SELECT table_name, row_count
FROM table_counts
UNION ALL
SELECT 'TOTAL' AS table_name, SUM(row_count) AS row_count
FROM table_counts;
```

**Interpretation:** compare each live table count to the recorded value, then compare the live `TOTAL` with both historical aggregate claims. If individual counts differ, investigate whether rows were appended, truncated, reloaded, or changed after the recorded snapshot. Do not infer that data was updated solely from the conflicting documentation.

### Future learning / optional enhancements
- Build a full acquisition cohort month-0/month-1/month-2 matrix; the acquisition-cohort funnel is implemented, but the full elapsed-month matrix is not.
- Continue learning Power BI Service Apps, deployment pipelines, performance analysis, and related deployment practices.
- Add only useful drill-through/detail enhancements and further business storytelling; do not treat every concept as already implemented.

### Source-file coverage
- Consolidated from the uploaded **v15, v16, v17, and v18** Project Log and Interview Q&A files available in this conversation.
- **v14 files were not present in the uploaded set**, so no content is claimed to have been incorporated from v14.

## Consolidation change history
- **18 Oct 2026 — Consolidated master created:** combined the detailed v17 history with the v15-only migration/M-code reference material, incorporated the v18 MySQL deployment, gateway, scheduled-refresh, and Desktop/Service RLS evidence, retained historical decisions and troubleshooting, and marked outdated status snapshots as historical/superseded.
- **16 Oct 2026 — v17 source baseline:** included the detailed project build, MySQL imports, gateway installation and registration, on-premises connection mapping, and successful manual Service refresh.
- **14 Oct 2026 — v15/v16 source history:** included dashboard/page build notes, data-quality and DAX history, MySQL import troubleshooting, and the original CSV-to-MySQL M-code inventory. The v15 migration appendix contains implementation details not present in v17 and is retained as a dated historical reference.

---

## 1. Project Purpose

Build an end-to-end Power BI Marketing Analytics solution as a practical interview project for Data & MarTech Analyst, Business Intelligence Analyst, and Business Analyst / Power BI roles.

The project is designed to demonstrate the complete BI workflow:

**Business requirement → source-data understanding → Power Query / ETL → data quality → data modeling → calculated columns → DAX → KPI development → funnel analysis → cohort/segment concepts → dashboard design → Drill Down / Drill Through concepts → UAT / validation → performance → Power BI Service → business insights → interview explanation.**

The project is also used to generate interview questions and strong, project-specific answers.

---

## 2. Interview Role Alignment

### Art of Living — Data & MarTech Analyst

Relevant project areas:
- Lead-to-enrollment funnel
- Acquisition/channel analysis
- Campaign analysis
- Geography/segment analysis
- Power BI dashboards
- Data modeling and DAX
- Power Query / ETL
- Data quality
- Reporting automation concepts
- CRM / activity data
- Marketing KPIs such as conversion, CPL, CAC and ROAS

### Element14 — Business Intelligence Analyst

Relevant project areas:
- SQL and relational data concepts
- Data models and star schema
- Logical grain and keys
- Power BI development
- Reporting and visualization
- KPI calculations
- Data validation / UAT
- Performance concepts
- Business-to-technical translation

### Landmark / Quess — Business Analyst / Power BI

Relevant project areas:
- Power BI Desktop
- Power Query ETL
- Advanced DAX
- Star schema
- SQL joins, aggregations and CTEs
- Dashboard design
- Stakeholder requirements
- Power BI Service concepts
- RLS / Gateway / refresh concepts

---

## 3. Source Data and Final Dataset

### Main tables

- `FactLeads.csv` — lead/funnel-level data
- `FactAdSpend.csv` — advertising performance
- `DimCampaign.csv` — campaign/channel master
- `DimDate.csv` — calendar/date dimension
- `DimCustomer.csv` — customer reference data
- `CRMActivity.csv` — CRM activity/event data
- `CampaignBudget.csv` — campaign-month budget data
- `LeadStageHistory.csv` — historical lead-stage events added for true stage-history analysis
- `DimMonth.csv` — monthly data source/reference; the project model also created `DimMonth` as a Power Query Reference from `DimDate`

### Final data period

**01-Jan-2025 to 15-Sep-2026**

No future December 2026 data is included.

### Final dataset validation

- `FactLeads`: 30,000 rows
- `DimDate`: 623 rows
- `FactAdSpend`: 6,230 rows
- `CampaignBudget`: 210 rows
- `CRMActivity`: 36,057 rows
- `LeadStageHistory`: **46,883 rows after the controlled repair**
  - 30,000 `Lead Created` events, one for every `FactLeads[LeadID]`
  - 16,883 existing non-`Lead Created` history rows preserved
- Key / foreign-key validation was performed on the final dataset.

### Important schema corrections

`FactAdSpend` was kept with:
- `Date`
- `CampaignID`
- `AdSpend`
- `Impressions`
- `Clicks`
- `PlatformConversions`

`DimCustomer` was kept with:
- `CustomerID`
- `CustomerType`
- `AgeBand`
- `CustomerCity`
- `CustomerStatus`

`LeadStageHistory` was added with:
- `StageHistoryID`
- `LeadID`
- `Stage`
- `StageDate`
- `StageOrder`

The table was subsequently repaired so that every lead in `FactLeads` has a `Lead Created` history event. The existing `FactLeads` table was treated as read-only during this repair.

The existing table names, keys and grains were preserved while making the dataset compatible with the Power BI model.

---

# 4. Step-by-Step Project Log

## Step 1 — Define the Business Requirement

### What we did

Defined the project as a marketing funnel and campaign intelligence dashboard.

The business questions include:
- How many leads are generated?
- How many become qualified?
- How many reach demo?
- How many enroll?
- What is the conversion rate?
- Which acquisition channels generate leads?
- How much advertising spend is being used?
- What is CPL?
- What is CAC?
- What is ROAS?
- How does revenue change over time?
- Which campaigns/channels/geographies require investigation?

### Why

A BI project should start from business questions rather than from visuals or DAX formulas.

### Interview takeaway

> I start by understanding the business objective and KPIs, then identify the source data and model required to answer those questions.

---

## Step 2 — Understand the Source Tables

### What we did

Inspected the available tables and identified their likely business roles and grains before creating relationships.

### Grain decisions

| Table | Grain / Row Meaning |
|---|---|
| `FactLeads` | One row per Lead |
| `FactAdSpend` | One row per Campaign + Date |
| `DimCampaign` | One row per Campaign |
| `DimDate` | One row per Calendar Date |
| `CRMActivity` | One row per CRM Activity |
| `CampaignBudget` | One row per Campaign + Month |
| `DimCustomer` | Customer reference data |
| `LeadStageHistory` | One row per Lead + Stage event |

### Important distinction

**Grain** tells us what one row represents.

**Key** identifies a row uniquely.

They are related but not the same concept.

---

## Step 3 — Load Data into Power BI

### What we did

Imported the source files into Power BI and used Power Query Editor for data preparation.

### Why

Power Query is the appropriate place for repeatable data extraction, cleaning, transformation and preparation before the model consumes the data.

### Interview question

**Q: Why use Power Query instead of doing every transformation in DAX?**

**A:** Power Query is designed for data ingestion and transformation before data is loaded into the model. DAX is primarily used for analytical calculations and measures inside the model. I prefer to perform data-cleaning and structural transformations in Power Query where practical, then use DAX for business calculations.

---

## Step 4 — Data Quality / Profiling

### What we checked

The project included inspection of:
- Nulls
- `N/A` values
- Duplicate values
- Inconsistent casing
- Inconsistent campaign names
- City-name inconsistencies
- Data types
- Key uniqueness
- Grain consistency

### Examples observed

- `meta` vs `Meta`
- `BANGALORE` vs `Bangalore`
- Null values
- `N/A` values
- Campaign naming variations

### Why

Poor source quality can produce incorrect relationships, filters and KPIs even when the DAX formula itself is correct.

### Interview takeaway

> I profile the source before transforming it. I transform only when there is a demonstrated data-quality, modeling or business requirement.

---

## Step 5 — Power Query Transformations

### Transformation: Month Name

Created a Month Name column using Power Query's Date transformation.

### Transformation: RevenueStatus

Created a Power Query Custom Column:

```M
if [Revenue] > 0 then "Revenue Generated" else "No Revenue"
```

### Why

This is a row-level classification, so Power Query is a suitable place to create it.

### Interview question

**Q: When would you create a calculated column in Power Query?**

**A:** When the value is a row-level transformation that can be prepared before loading the model, such as standardization, categorization or derived attributes.

---

## Step 6 — Understand Fact vs Dimension Tables

### Fact tables identified

- `FactLeads`
- `FactAdSpend`
- `CampaignBudget`
- `CRMActivity`

### Dimension/reference tables identified

- `DimCampaign`
- `DimDate`
- `DimMonth`
- `DimCustomer` (currently disconnected)

### Why

The model should separate measurable business events from descriptive/filtering attributes where possible.

### Interview takeaway

> I identify table grain first, then decide whether a table behaves as a fact, dimension or reference table. I do not classify tables only from their names.

---

## Step 7 — Create Relationships

### Relationships created

1. `DimCampaign[CampaignID]` 1 → * `FactLeads[CampaignID]` — Active / Single
2. `DimCampaign[CampaignID]` 1 → * `FactAdSpend[CampaignID]` — Active / Single
3. `DimCampaign[CampaignID]` 1 → * `CampaignBudget[CampaignID]` — Active / Single
4. `DimDate[Date]` 1 → * `FactLeads[LeadDate]` — Active / Single
5. `DimDate[Date]` 1 → * `FactAdSpend[Date]` — Active / Single
6. `FactLeads[LeadID]` 1 → * `CRMActivity[LeadID]` — Active / Single
7. `DimMonth[Start of Month]` 1 → * `DimDate[Start of Month]` — Active / Single
8. `DimMonth[Start of Month]` 1 → * `CampaignBudget[MonthStart]` — Active / Single
9. `FactLeads[LeadID]` 1 → * `LeadStageHistory[LeadID]` — Active / Single
10. `DimDate[Date]` 1 → * `LeadStageHistory[StageDate]` — **Inactive / Single**

The inactive StageDate relationship is intentional because `DimDate[Date]` already has the active acquisition-date relationship to `FactLeads[LeadDate]`. Historical-stage measures activate StageDate with `USERELATIONSHIP()`.

### Why not directly join fact tables?

`FactLeads` and `FactAdSpend` have different grains. A direct fact-to-fact join can cause duplication or incorrect aggregations.

Shared dimensions such as `DimCampaign` and `DimDate` provide controlled filter paths.

### Important modeling rule

Do not create a relationship simply because two column names or values look similar.

Check:
1. Business meaning
2. Grain
3. Key uniqueness
4. Cardinality
5. Data type compatibility
6. Filter direction
7. Intended filter path
8. Potential ambiguity/double counting

---

## Step 8 — Monthly Grain and DimMonth

### Problem

`DimDate` is daily while `CampaignBudget` is monthly.

### What we did

Created `DimMonth` as a Power Query Reference from `DimDate`.

Kept the month-start field, removed duplicates and created one row per month.

Created:
- `DimMonth[Start of Month]` → `DimDate[Start of Month]`
- `DimMonth[Start of Month]` → `CampaignBudget[MonthStart]`

### Why

This makes monthly-grain budget analysis explicit instead of forcing a daily dimension directly onto monthly data.

### Interview question

**Q: Why create a separate month dimension?**

**A:** Because the budget table is stored at Campaign + Month grain while the date dimension is daily. A monthly dimension makes the analytical grain explicit and makes monthly filtering easier to reason about.

---

## Step 9 — Calculated Columns vs Measures

### Calculated column: LeadValue

```DAX
LeadValue =
IF(
    FactLeads[Revenue] > 0,
    "Revenue Generated",
    "No Revenue"
)
```

### Calculated column: StageOrder

```DAX
StageOrder =
SWITCH(
    FactLeads[LeadStatus],
    "New", 1,
    "Qualified", 2,
    "Demo", 3,
    "Enrolled", 4,
    BLANK()
)
```

### Important issue encountered

Attempting to sort `LeadStatus` by `StageOrder` caused a circular-dependency issue.

### Learning

The business funnel axis should not necessarily be forced into the current-status column.

A cleaner design is to use a dedicated funnel-stage table for presentation logic.

### FunnelStages table

```DAX
FunnelStages =
DATATABLE(
    "Stage", STRING,
    "StageOrder", INTEGER,
    {
        {"Leads", 1},
        {"Qualified", 2},
        {"Demo", 3},
        {"Enrolled", 4}
    }
)
```

This table is intentionally disconnected and can drive a controlled funnel visual through a `SWITCH` measure.

---

## Step 10 — Core DAX Measures

### Total Leads

```DAX
Total Leads =
COUNTROWS(FactLeads)
```

### Qualified Leads

```DAX
Qualified Leads =
CALCULATE(
    [Total Leads],
    FactLeads[LeadStatus] = "Qualified"
)
```

### Demo Leads

```DAX
Demo Leads =
CALCULATE(
    [Total Leads],
    FactLeads[LeadStatus] = "Demo"
)
```

### Enrolled Leads

```DAX
Enrolled Leads =
CALCULATE(
    [Total Leads],
    FactLeads[LeadStatus] = "Enrolled"
)
```

### Conversion %

```DAX
Conversion % =
DIVIDE(
    [Enrolled Leads],
    [Total Leads],
    0
)
```

### Revenue

```DAX
Revenue =
SUM(FactLeads[Revenue])
```

### Ad Spend

```DAX
Ad Spend =
SUM(FactAdSpend[AdSpend])
```

### CPL

```DAX
CPL =
DIVIDE(
    [Ad Spend],
    [Total Leads],
    0
)
```

### CAC

```DAX
CAC =
DIVIDE(
    [Ad Spend],
    [Enrolled Leads],
    0
)
```

### ROAS

```DAX
ROAS =
DIVIDE(
    [Revenue],
    [Ad Spend],
    0
)
```

---

## Step 11 — Time Intelligence

### YTD Revenue

```DAX
YTD Revenue =
CALCULATE(
    [Revenue],
    DATESYTD(DimDate[Date])
)
```

### MTD Revenue

```DAX
MTD Revenue =
CALCULATE(
    [Revenue],
    DATESMTD(DimDate[Date])
)
```

### QTD Revenue

```DAX
QTD Revenue =
CALCULATE(
    [Revenue],
    DATESQTD(DimDate[Date])
)
```

### Previous Year Revenue

```DAX
Previous Year Revenue =
CALCULATE(
    [Revenue],
    SAMEPERIODLASTYEAR(DimDate[Date])
)
```

### YoY Revenue %

Recommended final version:

```DAX
YoY Revenue % =
DIVIDE(
    [Revenue] - [Previous Year Revenue],
    [Previous Year Revenue]
)
```

The version without an alternate result allows Power BI to return blank when there is no prior-year comparison rather than displaying a misleading zero.

### Date table

`DimDate[Date]` was set as the date column and the table was marked as the model's Date Table.

### Interview takeaway

> Time-intelligence calculations depend on a proper date table and valid date relationships. I do not treat a text Month column as the primary time-intelligence date field.

---

## Step 12 — Funnel Analysis

### Initial funnel measures

The current-status funnel uses:
- Total Leads
- Qualified Leads
- Demo Leads
- Enrolled Leads
- Conversion %

### Important business interpretation

`FactLeads[LeadStatus]` represents the current status of a lead, not necessarily the complete historical sequence that the lead followed.

### Diagnostic investigation

Created:

```DAX
Demo Activity Leads =
CALCULATE(
    DISTINCTCOUNT(CRMActivity[LeadID]),
    CRMActivity[ActivityType] = "Demo"
)
```

The diagnostic returned approximately 400 leads with Demo activity.

A breakdown by current status showed:
- New: 178
- Qualified: 98
- Demo: 81
- Enrolled: 43

### Learning

`CRMActivity` is activity/history data, but it is not a reliable replacement for stage history. A lead can have a Demo activity while its current status is something else.

### Correct solution added to the dataset

`LeadStageHistory.csv` was introduced to provide actual stage-event history.

### Status

**Completed in the current PBIX.** `LeadStageHistory` was added to the model and used to implement the historical stage funnel. The historical funnel now responds correctly to both the Date slicer and Channel slicer.

---

## Step 13 — FunnelStages Presentation Table

### What we did

Created a disconnected `FunnelStages` table:

```DAX
FunnelStages =
DATATABLE(
    "Stage", STRING,
    "StageOrder", INTEGER,
    {
        {"Leads", 1},
        {"Qualified", 2},
        {"Demo", 3},
        {"Enrolled", 4}
    }
)
```

### Why disconnected?

The stage list is a presentation/analysis axis rather than a physical source key. A measure can map each selected stage to the relevant KPI.

### Important distinction

- `FactLeads[StageOrder]` = row-level current-status order.
- `FunnelStages[StageOrder]` = business-defined funnel-axis order.

## Step 13A — Historical Funnel Integration and Filter Troubleshooting

### LeadStageHistory model integration

`LeadStageHistory` was added to the current PBIX with these relationships:

- `FactLeads[LeadID]` → `LeadStageHistory[LeadID]`: **1:* / Single / Active**
- `DimDate[Date]` → `LeadStageHistory[StageDate]`: **1:* / Single / Inactive**

The inactive StageDate relationship is intentional because `DimDate` already has an active relationship to `FactLeads[LeadDate]`. `USERELATIONSHIP()` is used when the historical calculation needs StageDate.

### Initial historical-stage measure

The historical calculation was developed around a common measure rather than maintaining separate calculation logic for every funnel stage:

```DAX
Historical Stage Leads =
VAR SelectedLeadIDs =
    CALCULATETABLE(
        VALUES(FactLeads[LeadID]),
        REMOVEFILTERS(DimDate)
    )
RETURN
    CALCULATE(
        DISTINCTCOUNT(LeadStageHistory[LeadID]),
        USERELATIONSHIP(
            DimDate[Date],
            LeadStageHistory[StageDate]
        ),
        CROSSFILTER(
            FactLeads[LeadID],
            LeadStageHistory[LeadID],
            None
        ),
        TREATAS(
            SelectedLeadIDs,
            LeadStageHistory[LeadID]
        )
    )
```

### Why this measure was needed

The historical funnel has two different filter requirements:

1. Channel filtering must continue to identify the relevant LeadIDs through `DimCampaign` → `FactLeads`.
2. Historical date filtering must use `LeadStageHistory[StageDate]`, not only the lead's original `FactLeads[LeadDate]`.

`SelectedLeadIDs` captures the lead population while preserving Channel filtering but removes the Date filter from the FactLeads side. `TREATAS()` then applies those LeadIDs to `LeadStageHistory`. `USERELATIONSHIP()` activates the StageDate relationship for the calculation, while `CROSSFILTER(..., None)` prevents the normal LeadID relationship from independently restricting the historical calculation.

### Controlled debugging tests

The issue was diagnosed with temporary measures instead of changing relationships blindly.

**Test 1 — Channel filters FactLeads:**

```DAX
Test Channel Leads =
DISTINCTCOUNT(FactLeads[LeadID])
```

Observed counts:
- All = 30,000
- YouTube = 5,751
- Meta = 10,015
- LinkedIn = 4,410
- Google = 9,824

This proved that Channel filtering into `FactLeads` was working.

**Test 2 — Channel reaches LeadStageHistory:**

```DAX
Test Historical Leads =
DISTINCTCOUNT(LeadStageHistory[LeadID])
```

Observed counts in the tested context:
- All = 18,000
- YouTube = 3,456
- Meta = 6,035
- LinkedIn = 2,628
- Google = 5,881

This proved that the existing LeadID filter path could reach `LeadStageHistory`.

**Test 3 — StageDate behavior:**

A temporary measure using `USERELATIONSHIP(DimDate[Date], LeadStageHistory[StageDate])` was tested. It responded to Channel and Date, but its totals differed from the simple historical count because it was using a different date meaning. This confirmed the need to distinguish LeadDate from StageDate.

### Root cause of the funnel visual issue

The funnel visual was initially using separate measures such as `Historical Lead Created`, `Historical Qualified`, `Historical Demo`, and `Historical Enrolled` through a `SWITCH()`. The corrected common historical-stage measure was not being used by the funnel itself.

The final funnel measure is:

```DAX
Historical Funnel Leads =
VAR SelectedStage =
    SELECTEDVALUE(FunnelStages[Stage])
RETURN
    SWITCH(
        SelectedStage,

        "Leads",
            CALCULATE(
                [Historical Stage Leads],
                LeadStageHistory[Stage] = "Lead Created"
            ),

        "Qualified",
            CALCULATE(
                [Historical Stage Leads],
                LeadStageHistory[Stage] = "Qualified"
            ),

        "Demo",
            CALCULATE(
                [Historical Stage Leads],
                LeadStageHistory[Stage] = "Demo"
            ),

        "Enrolled",
            CALCULATE(
                [Historical Stage Leads],
                LeadStageHistory[Stage] = "Enrolled"
            )
    )
```

This centralizes the common filtering logic in `Historical Stage Leads` and uses the funnel measure only to apply the selected stage.

### Validation result

The final funnel was tested with different Channel selections and changed accordingly. Examples from the validated report state:

**Meta:** Lead Created 5,351; Qualified 3,083; Demo 1,764; Enrolled 697.

**YouTube:** Lead Created 3,055; Qualified 1,407; Demo 724; Enrolled 267.

**All Channels:** Lead Created 15,997; Qualified 8,531; Demo 4,724; Enrolled 1,849.

The funnel display rounds values (for example 5K, 3K, 2K, 1K), while the supporting table shows the exact values.

### Important distinction — stage values and Total

The supporting table's Total is **not the arithmetic sum of the four stage counts**. Each stage is a distinct count of LeadID within that stage. The same lead can appear in multiple historical stages, so adding stage counts would count that lead multiple times. The Total evaluates the measure in the total filter context and therefore represents the distinct LeadIDs in that context rather than the sum of the displayed stage rows.

Example:

- One lead can have Lead Created, Qualified, Demo and Enrolled history records.
- That lead contributes 1 to each applicable stage count.
- It still contributes only 1 to an overall `DISTINCTCOUNT(LeadID)`.

### Old vs new stage measures

Previously, a stage-specific measure looked like:

```DAX
Historical Enrolled =
CALCULATE(
    DISTINCTCOUNT(LeadStageHistory[LeadID]),
    LeadStageHistory[Stage] = "Enrolled",
    USERELATIONSHIP(
        DimDate[Date],
        LeadStageHistory[StageDate]
    ),
    CROSSFILTER(
        FactLeads[LeadID],
        LeadStageHistory[LeadID],
        NONE
    )
)
```

That measure is conceptually equivalent to the Enrolled branch of the final funnel because both count distinct LeadIDs where Stage = Enrolled. The final design is different structurally: the common filter logic is centralized in `Historical Stage Leads`, and `Historical Funnel Leads` applies the stage filter dynamically. This avoids maintaining four copies of the same historical filtering logic.

### Status

**Completed and validated.** Historical funnel filtering by Date and Channel is working in the current PBIX.

---

## Step 14 — Dashboard / Visual Validation

### Visuals used during the project

- KPI cards
- Funnel/current-stage visuals
- Channel/source breakdown
- Channel slicer
- Revenue time-intelligence table
- Diagnostic tables during troubleshooting

### KPI values after the final dataset refresh

The refreshed report showed approximately:
- Total Leads: **30,000**
- Qualified Leads: **7,189**
- Demo Leads: **5,373**
- Enrolled Leads: approximately **3K**
- Conversion: **11.38%**
- Revenue: approximately **₹48M**
- Ad Spend: approximately **₹5M**
- CPL: **₹157.12**
- CAC: approximately **₹1.38K**
- ROAS: **10.17**

These are project-refresh observations and should be rechecked against the PBIX if exact values are needed in an interview.

### Diagnostic visual cleanup

After investigating the CRMActivity issue, the following diagnostic items were removed from the presentation dashboard:
- Demo Activity Leads card
- Large CRMActivity diagnostic table

The dashboard was kept focused on business KPIs rather than temporary troubleshooting visuals.

---

## Step 15 — Month Sorting / YearMonth

### Problem

The Revenue table initially displayed months in a non-chronological order because Month was a text field.

### Intended solution

Create a calculated column in `DimDate`:

```DAX
YearMonth =
FORMAT(
    'DimDate'[Date],
    "YYYY-MM"
)
```

Then create a numeric sort column:

```DAX
YearMonthSort =
YEAR('DimDate'[Date]) * 100 + MONTH('DimDate'[Date])
```

Then:

**Select `YearMonth` → Column tools → Sort by column → `YearMonthSort`.**

### Why YearMonthSort works

For September 2025:
- `YEAR(Date)` = 2025
- `2025 * 100` = 202500
- `MONTH(Date)` = 9
- Sort key = 202509

For October 2025 it becomes 202510, so numeric ordering produces chronological ordering.

### Important implementation note

`YearMonth` and `YearMonthSort` are **calculated columns**, not measures, because each date row receives its own value.

### Status

**Completed.** `YearMonth` was created as a calculated column, `YearMonthSort` was created as the numeric sort key, and `YearMonth` was sorted chronologically using `Sort by column`.

---

## Step 16 — Cohort Funnel Analysis

### Business definition

The cohort funnel answers:

> **Of the leads acquired during the selected acquisition period, how many eventually reached each stage?**

The Date slicer defines the acquisition cohort through `FactLeads[LeadDate]`. Channel/campaign filters also define the cohort through the normal `DimCampaign → FactLeads` path. Once the cohort LeadIDs are selected, later stage events are not restricted by the acquisition-date slicer.

Example:

- Lead created in March
- Qualified in April
- Demo in June
- Enrolled in July

If March is selected as the acquisition cohort, that lead can contribute to Leads, Qualified, Demo and Enrolled.

### Important caveat

Recent acquisition cohorts naturally have less time to progress to later stages. Therefore, a lower Demo or Enrolled count for a recent cohort does not automatically mean poor performance.

### Type 1 — Acquisition-cohort progression

This is the current **Cohort Funnel** implementation.

### Type 2 — Current-status funnel

Uses `FactLeads[LeadStatus]` and answers:

> How many leads are currently in each status?

### Type 3 — Latest-status funnel from history

For each lead, identify the latest recorded stage in `LeadStageHistory`, then count leads by that latest stage. This is a separate analysis pattern and is not the same as counting every historical stage event.

### Current Type 1 DAX

```DAX
Cohort Leads =
DISTINCTCOUNT(FactLeads[LeadID])
```

The generic cohort funnel measure is:

```DAX
Cohort Funnel Leads =
VAR SelectedStage =
    SELECTEDVALUE(FunnelStages[Stage])

VAR CohortLeadIDs =
    CALCULATETABLE(
        VALUES(FactLeads[LeadID])
    )

RETURN
    SWITCH(
        SelectedStage,

        "Leads",
            COUNTROWS(CohortLeadIDs),

        "Qualified",
            CALCULATE(
                DISTINCTCOUNT(LeadStageHistory[LeadID]),
                REMOVEFILTERS(DimDate),
                CROSSFILTER(
                    FactLeads[LeadID],
                    LeadStageHistory[LeadID],
                    NONE
                ),
                TREATAS(
                    CohortLeadIDs,
                    LeadStageHistory[LeadID]
                ),
                LeadStageHistory[Stage] = "Qualified"
            ),

        "Demo",
            CALCULATE(
                DISTINCTCOUNT(LeadStageHistory[LeadID]),
                REMOVEFILTERS(DimDate),
                CROSSFILTER(
                    FactLeads[LeadID],
                    LeadStageHistory[LeadID],
                    NONE
                ),
                TREATAS(
                    CohortLeadIDs,
                    LeadStageHistory[LeadID]
                ),
                LeadStageHistory[Stage] = "Demo"
            ),

        "Enrolled",
            CALCULATE(
                DISTINCTCOUNT(LeadStageHistory[LeadID]),
                REMOVEFILTERS(DimDate),
                CROSSFILTER(
                    FactLeads[LeadID],
                    LeadStageHistory[LeadID],
                    NONE
                ),
                TREATAS(
                    CohortLeadIDs,
                    LeadStageHistory[LeadID]
                ),
                LeadStageHistory[Stage] = "Enrolled"
            )
    )
```

### Why `REMOVEFILTERS(DimDate)` is required

The acquisition-date slicer should define which LeadIDs belong to the cohort. It should not prevent a selected cohort lead from being counted when its later stage event occurred after the selected acquisition period.

### Why `CROSSFILTER(..., NONE)` and `TREATAS()` are used

The normal LeadID relationship can otherwise introduce an unwanted date/filter path. `CROSSFILTER(..., NONE)` disables that relationship for the stage calculation, while `TREATAS()` explicitly applies the selected cohort LeadIDs to `LeadStageHistory`.

### Validation performed after implementation

The corrected funnel was tested with Google selected and multiple date ranges. Examples from the current report screenshots:

**01-Jan-2025 → 14-Aug-2025, Google:**
- Historical Lead Created = **3,548**
- Cohort Leads = **3,548**
- Historical Qualified = 1,150
- Cohort Qualified = 1,164
- Historical Demo = 596
- Cohort Demo = 610
- Historical Enrolled = 230
- Cohort Enrolled = 237

**01-Jan-2025 → 10-Nov-2025, Google:**
- Historical Lead Created = **4,934**
- Cohort Leads = **4,934**
- Historical Qualified = 1,590
- Cohort Qualified = 1,598
- Historical Demo = 841
- Cohort Demo = 849
- Historical Enrolled = 318
- Cohort Enrolled = 325

The later-stage differences are expected because Historical Funnel counts events whose `StageDate` falls inside the selected date range, while Cohort Funnel follows the selected acquisition cohort and allows later stage events to occur after the cohort date range.

### Status

**Implemented and validated.** The next enhancement is not to change the cohort logic, but to add stage-to-stage conversion measures and a clear explanation/visual treatment of the three funnel types.

---

## Step 17 — Segment Analysis

### Planned dimensions

Potential segments include:
- Acquisition channel
- Campaign
- Geography/city
- Customer type
- Age band
- Lead status
- Acquisition cohort

### Current status

Channel analysis already exists through the Channel slicer and funnel testing. Campaign, geography and customer-level segmentation remain to be developed as dedicated analytical views.

### Next implementation

Create a campaign/channel performance view using Leads, Qualified, Demo, Enrolled, Conversion %, Ad Spend, CPL, CAC, Revenue and ROAS.

---

## Step 18 — Funnel Conversion Analysis

### Next dashboard enhancement

The current funnel displays stage counts. The next analytical layer is stage-to-stage conversion:

- Lead → Qualified %
- Qualified → Demo %
- Demo → Enrolled %
- Lead → Enrolled %

These should be implemented as measures so they respond to the selected cohort, channel and other report filters.

The business definition must be kept explicit: the current overall `Conversion %` measure is Enrolled ÷ Total Leads. Stage-to-stage rates are separate measures.

---

## Step 19 — Drill Down / Drill Through

### Planned concept

**Drill Down:** navigate through a hierarchy inside the same visual, for example Year → Quarter → Month → Day or Region → City.

**Drill Through:** move to a separate detail page filtered by the selected entity, for example Campaign Overview → Campaign Detail.

### Current status

Not fully implemented. This remains a dashboard enhancement after the core funnel and campaign analysis are finalized.

---

## Step 20 — Data Validation / UAT

### Completed validations

The project has already validated:
- FactLeads row count and distinct LeadID count
- LeadStageHistory reconciliation for `Lead Created`
- Date filtering
- Channel filtering
- Historical StageDate behavior
- Cohort acquisition-date behavior
- KPI calculations
- YearMonth chronological sorting
- Relationship/filter-path behavior

### LeadStageHistory repair

The original history table contained only **18,000 Lead Created records** for 30,000 leads. Because the historical table is intended to represent the lead journey, the data was repaired rather than changing `FactLeads`.

Repair rules:
1. Treat `FactLeads` as the source of truth for LeadID and LeadDate.
2. Ensure every FactLeads LeadID has exactly one `Lead Created` history event.
3. Set that event's StageDate equal to the lead's actual LeadDate.
4. Preserve existing non-Lead-Created history records.
5. Do not invent missing Qualified/Demo/Enrolled dates without source evidence.

Result:
- Final Lead Created events = **30,000**
- Corrected LeadStageHistory rows = **46,883**
- FactLeads itself was **not modified**.

### Important validation principle

For a selected acquisition period:

**Historical Lead Created should reconcile to Cohort Leads**, because both represent the same acquisition population after the LeadStageHistory repair.

Later stages do not need to match because Historical Funnel uses StageDate while Cohort Funnel uses acquisition cohort membership and allows later progression.

---

## Step 21 — Performance Optimization

### Interview-level topics to know

- Prefer a clean star schema.
- Remove unnecessary columns from the model.
- Avoid unnecessary high-cardinality columns.
- Prefer measures over excessive calculated columns when appropriate.
- Avoid unnecessary bidirectional relationships.
- Reduce unnecessary visuals.
- Use Performance Analyzer to identify slow visuals.
- Optimize expensive DAX.
- Push suitable transformations upstream into Power Query/source systems.

### Current status

A dedicated performance optimization pass remains. It should be done after the final visual set is stable so performance measurements reflect the actual report.

---

## Step 22 — Power BI Service

### Remaining concepts

1. Publish a PBIX to a workspace.
2. Semantic model and report management.
3. Scheduled refresh.
4. On-premises Data Gateway.
5. Row-Level Security (RLS).
6. Workspace roles and permissions.
7. Power BI Apps.
8. Deployment pipelines / development-test-production flow.

### Current status

These remain primarily conceptual for this project. A hands-on Service deployment can be added later if required.

---

## Step 23 — Business Insights

The dashboard is intended to translate KPIs into business questions rather than simply display numbers.

Examples:
- High lead volume but low downstream conversion → investigate lead quality and funnel drop-off.
- High ad spend with weak conversion → investigate channel/campaign efficiency.
- Strong revenue with high spend → evaluate ROAS, CAC and incremental business impact together.
- City-level conversion differences → investigate geography, campaign mix and operational capacity.

Do not make a budget-allocation recommendation from a single metric such as conversion rate. Consider spend, CPL, CAC, revenue, ROAS, attribution quality and sample size.

---

# 5. Historical Project Status Snapshot (early October 2026; superseded by the consolidated status at the top)

## Completed

- Source-data understanding and grain identification
- Power Query preparation and data-quality checks
- Star-style relationship model
- DimDate and DimMonth setup
- Core DAX KPIs
- Time intelligence
- Current-status funnel
- Historical stage-event funnel
- LeadStageHistory repair and reconciliation
- Acquisition cohort funnel
- Channel and date filter validation
- YearMonth chronological sorting
- Initial dashboard and KPI visuals

## Historical next-build plan (recorded before later page builds and Service deployment)

> Historical plan retained for traceability. Later dated entries document that several items below were completed; use the consolidated status at the top for the current position.


### 1. Funnel conversion measures
Build Lead→Qualified, Qualified→Demo, Demo→Enrolled and overall Lead→Enrolled conversion measures.

### 2. Campaign and channel performance
Create a table/chart comparing Leads, Conversion %, Spend, CPL, CAC, Revenue and ROAS by Channel and Campaign.

### 3. Trend analysis
Add monthly lead, enrollment, revenue and spend trends and clearly distinguish acquisition date from stage-event date.

### 4. Segment analysis
Add geography/city and other supported dimensions only where the source keys and business definitions are valid.

### 5. Cohort matrix
The acquisition cohort funnel is implemented. A full cohort matrix by acquisition month and elapsed month remains a separate enhancement.

### 6. Drill-through/detail page
Create a Campaign Detail or Channel Detail page if deeper investigation is useful.

### 7. Final dashboard UX
Remove diagnostic visuals, standardize titles and number formats, align slicers, improve visual hierarchy and add concise business insight callouts.

### 8. UAT / performance pass
Reconcile final KPIs, test slicers, inspect Performance Analyzer and confirm refresh behavior.

### 9. Power BI Service concepts
Study publishing, workspaces, refresh, gateway, RLS, Apps and deployment pipelines.

### 10. Business storytelling
Convert the final dashboard into 3–5 evidence-based findings with context and limitations.

**Current project position:** the data-model and funnel foundation is stable. The next hands-on work should focus on **conversion analysis → campaign/channel analysis → trend/segment analysis → final dashboard refinement**, not on changing `FactLeads`.

---

# 6. Key Problems / Difficulties Encountered

## Problem 1 — Current Status vs Historical Stage

**Issue:** CRM activity could show Demo while current LeadStatus was New/Qualified/etc.

**Learning:** Current-state data is not equivalent to stage-history data.

**Resolution:** Added `LeadStageHistory`, repaired its missing `Lead Created` events from the trusted `FactLeads` acquisition data, and implemented both Historical Funnel and Cohort Funnel logic.

## Problem 2 — Circular Dependency While Sorting LeadStatus

**Issue:** Sorting `LeadStatus` by a calculated `StageOrder` column produced a circular-dependency problem.

**Learning:** A separate disconnected funnel-stage axis can be cleaner than forcing business presentation order into a transactional status column.

## Problem 3 — Non-Chronological Month Display

**Issue:** Text Month values were not displayed chronologically.

**Resolution:** Use `YearMonth` plus `YearMonthSort` and Sort by Column.

## Problem 4 — Disconnected DimCustomer

**Issue:** `FactLeads` does not contain `CustomerID`.

**Decision:** Do not create an artificial relationship.

**Learning:** A disconnected table can be intentional when a valid business key/path does not exist.

## Problem 5 — Different Table Grains

**Issue:** Lead, ad-spend and budget data operate at different grains.

**Learning:** Relationships must respect grain and business meaning. Do not force fact-to-fact joins.

## Problem 6 — Missing Lead Created History

**Issue:** The original `LeadStageHistory` contained 18,000 `Lead Created` events for 30,000 leads.

**Resolution:** `FactLeads` was kept unchanged. The history table was repaired so every FactLeads LeadID has one `Lead Created` event with StageDate equal to the actual FactLeads LeadDate. Existing non-Lead-Created history was preserved.

**Result:** 30,000 Lead Created events and 46,883 total history rows.

## Problem 7 — Historical Funnel vs Cohort Funnel Date Meaning

**Issue:** Historical stage counts and cohort stage counts can differ for the same selected date range.

**Learning:** Historical Funnel filters by StageDate; Cohort Funnel first selects an acquisition cohort by LeadDate and then allows later stage events. They are different analytical questions and should not be forced to match at later stages.

---

# 7. Current Model Snapshot

### Current relationships

**Active — 9 relationships:**

1. `DimCampaign[CampaignID]` → `FactLeads[CampaignID]`
2. `DimCampaign[CampaignID]` → `FactAdSpend[CampaignID]`
3. `DimCampaign[CampaignID]` → `CampaignBudget[CampaignID]`
4. `DimDate[Date]` → `FactLeads[LeadDate]`
5. `DimDate[Date]` → `FactAdSpend[Date]`
6. `FactLeads[LeadID]` → `CRMActivity[LeadID]`
7. `DimMonth[Start of Month]` → `DimDate[Start of Month]`
8. `DimMonth[Start of Month]` → `CampaignBudget[MonthStart]`
9. `FactLeads[LeadID]` → `LeadStageHistory[LeadID]`

**Inactive — 1 relationship:**

10. `DimDate[Date]` → `LeadStageHistory[StageDate]`

All listed relationships are **1:* / Single**. The StageDate relationship is intentionally inactive and is activated by `USERELATIONSHIP()` in historical-stage calculations.

`DimCustomer` remains disconnected because no valid CustomerID path exists in the current FactLeads model.

### Current history data status

- FactLeads: **30,000 rows** — unchanged
- Original LeadStageHistory: **34,883 rows**
- Corrected LeadStageHistory: **46,883 rows**
- Corrected Lead Created events: **30,000**
- Existing non-Lead-Created history rows preserved: **16,883**

### Current funnel measures

- `Historical Stage Leads`
- `Historical Funnel Leads`
- `Cohort Leads`
- `Cohort Funnel Leads`
- Current-status measures: Total Leads, Qualified Leads, Demo Leads, Enrolled Leads

---

# 8. Final Interview Story — 60 Seconds

> "I built a Marketing Funnel and Campaign Intelligence solution in Power BI. I started by understanding the business KPIs and the grain of each source table, then used Power Query for data preparation and quality checks. I designed a star-style model using dimensions such as Campaign, Date and Month to filter fact tables at their appropriate grain. I created DAX measures for leads, qualification, demo, enrollment, conversion, revenue, ad spend, CPL, CAC, ROAS and time intelligence. During validation I identified that CRM activity represented activities rather than official stage history, so I introduced a LeadStageHistory table and repaired its missing Lead Created events using the trusted lead acquisition data without modifying FactLeads. I then implemented both a historical stage-event funnel and an acquisition-cohort funnel. The project taught me that correct BI results depend on business definitions, grain, relationships, filter context and data validation—not only on the DAX formula."

---

# 9. Historical Completion Snapshot (early October 2026; superseded by later dated entries)

## Completed / Practiced

- Business requirement definition
- Source understanding
- Power Query usage
- Data-quality profiling
- Basic ETL transformations
- Fact/dimension thinking
- Grain and key validation
- Star-style relationships
- Monthly grain modeling
- Calculated columns
- DAX measures
- Time intelligence
- Current-status funnel
- Historical stage-event funnel
- LeadStageHistory repair and reconciliation
- Acquisition cohort funnel
- Channel/date filter troubleshooting
- Dashboard KPI validation
- YearMonth sorting

## Remaining / Next Hands-On Work

- Stage-to-stage conversion measures
- Campaign/channel performance page
- Monthly trend analysis
- Geography/segment analysis where valid
- Full acquisition cohort matrix by elapsed month
- Drill Down / Drill Through implementation
- Final dashboard UX refinement
- Final UAT checklist and performance pass
- Power BI Service hands-on deployment if required
- Final business insight/storytelling layer

These items should be added only when they serve the business requirement. The project should not add features merely to make the model larger.

---

# 10. Project Rule Going Forward

The data foundation is now stable. `FactLeads` remains the source of truth for lead acquisition and current lead-level attributes and should not be modified for the remaining dashboard work. `LeadStageHistory` is the historical event source. Any future data change must be justified by source evidence, validated, and checked against the existing Power BI model before replacement.


# 2026-10-01 — Latest Project Continuation: Executive Overview, Historical Funnel and Page 2

## 24. Executive Overview — Page 1 Completed

### Page created
- `01 - Executive Overview`

### Stakeholder purpose
The page answers:
- How are we performing overall?
- How is the acquisition funnel progressing?
- How is performance changing over time?
- Which channels require investigation?

### Final Page 1 KPI logic
Page 1 was deliberately standardized on acquisition-cohort measures so the KPI cards, cohort funnel, channel matrix and KBI panel use the same business definition.

KPI cards use:
- `Cohort Total Leads` → display label `Leads Acquired`
- `Cohort Qualified Leads` → `Leads Qualified`
- `Cohort Demo Leads` → `Leads at Demo`
- `Cohort Enrolled Leads` → `Leads Enrolled`
- `Cohort Conversion %` → `Acquisition-to-Enrolled %`
- `Ad Spend`
- `Revenue`
- `ROAS`

### Page 1 supporting visuals
- Cohort Funnel
- Monthly Lead & Revenue Trend
- Channel Performance matrix
- Key Business Insights
- Date Range slicer
- Channel slicer

### KBI design
Four dynamic insight areas were implemented:
1. Overall Performance
2. Channel Performance
3. Funnel Performance
4. Marketing Efficiency

The Page 1 KBI uses cohort logic. `KBI Funnel Performance` was intentionally preserved as the cohort version and was **not** changed when Page 2 required historical logic.

### UX decisions
- White canvas background
- Clean stakeholder-oriented layout
- Filters placed near the header
- Visual-only renaming used where labels were too long; model measure names were preserved
- Conditional formatting used where it supported interpretation
- Empty space was retained where it improved readability rather than adding unnecessary visuals

---

## 25. Historical Funnel — Filter Context and Date Semantics

### Three funnel definitions now explicitly understood

1. **Current-status funnel** — counts leads by their current `FactLeads[LeadStatus]`.
2. **Historical stage-event funnel** — counts unique leads whose stage event occurred during the selected `LeadStageHistory[StageDate]` period.
3. **Acquisition-cohort funnel** — selects leads by `FactLeads[LeadDate]` and follows those cohort LeadIDs into later stage events, even when later events occur after the acquisition-date range.

### Important validation lesson
The Historical Funnel and Cohort Funnel can show the same values for a broad/full reporting period and still be using different logic. A shorter date range demonstrated the difference.

Example tested for Google, 01-Jan-2025 to 26-Nov-2025:
- Cohort: 5,171 → 1,669 → 883 → 339
- Historical: 5,171 → 1,665 → 872 → 333

The Lead Created counts matched because `LeadStageHistory[StageDate]` for Lead Created was repaired to equal the trusted `FactLeads[LeadDate]`. Later stages differed because the historical funnel requires the stage event itself to occur inside the selected StageDate window, while the cohort funnel follows the acquisition cohort beyond that window.

### Business interpretation
- Cohort question: **What happened to the leads we acquired during this period?**
- Historical question: **What funnel-stage activity happened during this period?**

These definitions should not be forced to match.

---

## 26. Historical Funnel — Channel Filter Repair

### Problem found
The historical measures responded to Date but did not consistently respond to Channel because the historical calculation intentionally disabled the normal `FactLeads[LeadID]` → `LeadStageHistory[LeadID]` filter path with `CROSSFILTER(..., NONE)`.

### Corrected pattern
The historical stage measures now use the same controlled filter pattern:

```DAX
VAR SelectedLeadIDs =
    CALCULATETABLE(
        VALUES(FactLeads[LeadID]),
        REMOVEFILTERS(DimDate)
    )

RETURN
    CALCULATE(
        DISTINCTCOUNT(LeadStageHistory[LeadID]),
        LeadStageHistory[Stage] = "<Stage>",
        USERELATIONSHIP(
            DimDate[Date],
            LeadStageHistory[StageDate]
        ),
        CROSSFILTER(
            FactLeads[LeadID],
            LeadStageHistory[LeadID],
            NONE
        ),
        TREATAS(
            SelectedLeadIDs,
            LeadStageHistory[LeadID]
        )
    )
```

Applied to:
- `Historical Lead Created`
- `Historical Qualified`
- `Historical Demo`
- `Historical Enrolled`

### Concepts practiced
- `VAR`
- `CALCULATETABLE`
- `VALUES`
- `REMOVEFILTERS`
- `CALCULATE`
- `DISTINCTCOUNT`
- `USERELATIONSHIP`
- `CROSSFILTER`
- `TREATAS`
- Filter context and filter-path troubleshooting

### Why the pattern works
- Channel filters `DimCampaign` → `FactLeads`.
- `SelectedLeadIDs` captures the channel-selected lead population while temporarily removing the acquisition Date filter from that list.
- `USERELATIONSHIP` makes the selected Date filter operate on `LeadStageHistory[StageDate]`.
- `CROSSFILTER(..., NONE)` prevents the normal LeadID relationship from independently altering the historical calculation.
- `TREATAS` explicitly transfers the selected LeadIDs to `LeadStageHistory[LeadID]`.

### Validation
Tested with All Channels, Google and LinkedIn, and with different date ranges. Historical stage counts and conversion cards changed appropriately with Channel and Date filters.

---

## 27. Historical Stage-to-Stage Conversion Measures

Existing measures were verified and reused rather than creating duplicate measures:

```DAX
Historical Qualified Conversion % =
DIVIDE(
    [Historical Qualified],
    [Historical Lead Created]
)

Historical Demo Conversion % =
DIVIDE(
    [Historical Demo],
    [Historical Qualified]
)

Historical Enrolled Conversion % =
DIVIDE(
    [Historical Enrolled],
    [Historical Demo]
)

Historical Overall Conversion % =
DIVIDE(
    [Historical Enrolled],
    [Historical Lead Created]
)
```

### Important distinction
The older measures `Lead to Qualified %`, `Qualified to Demo %` and `Demo to Enrolled %` were preserved because they are based on current-status measures and may be useful elsewhere. Page 2 was changed at the **visual field level** to use the historical conversion measures rather than modifying the original measures.

### Page 2 card display labels
The three cards were renamed for the visual only:
- `Lead → Qualified`
- `Qualified → Demo`
- `Demo → Enrolled`

This keeps model measure names stable while giving stakeholders concise labels.

---

## 28. Page 2 — Funnel & Conversion Analysis

### Page created
`02 - Funnel & Conversion`

### Final business purpose
Understand stage progression, conversion efficiency and historical funnel movement over time.

### Final visuals
- Three historical stage-conversion cards
- Historical Funnel
- Historical Stage Breakdown
- Lead-to-Enrolled Conversion Trend
- Stage Conversion Trend
- Key Business Insights
- Date Range slicer
- Channel slicer

### Final Page 2 logic
All major funnel visuals use the historical-stage definition. This avoids presenting a current-status metric beside a historical-event funnel without explanation.

### KBI separation
The original `KBI Funnel Performance` remains the **cohort/Page 1** version. A new measure was created for Page 2:

```DAX
KBI Historical Funnel Performance =
VAR LeadToQualified =
    [Historical Qualified Conversion %]
VAR QualifiedToDemo =
    [Historical Demo Conversion %]
VAR DemoToEnrolled =
    [Historical Enrolled Conversion %]
VAR LowestStage =
    SWITCH(
        TRUE(),
        LeadToQualified <= QualifiedToDemo
            && LeadToQualified <= DemoToEnrolled,
            "Lead → Qualified",
        QualifiedToDemo <= DemoToEnrolled,
            "Qualified → Demo",
        "Demo → Enrolled"
    )
VAR LowestRate =
    MIN(
        LeadToQualified,
        MIN(
            QualifiedToDemo,
            DemoToEnrolled
        )
    )
RETURN
    LowestStage
        & " has the lowest conversion rate at "
        & FORMAT(LowestRate, "0.00%")
        & "."
```

### Why a separate KBI measure was used
Changing `KBI Funnel Performance` would have affected Page 1 because that measure is used by the cohort-based Executive Overview. A separate historical measure keeps the two page definitions independent and prevents unintended cross-page changes.

### Page 2 visual formatting completed
- White background
- Consistent light-grey 1 px borders
- No unnecessary shadows
- Aligned conversion cards
- Concise visual-only card labels
- Funnel and trend visuals aligned into a two-column structure
- Historical Stage Breakdown aligned with the main analytical row
- Key Business Insights panel standardized
- Trend charts aligned side-by-side

### Page 2 final status
**Logic validated and visual formatting completed.**

---

## 29. DAX Concepts Covered in This Build

The recent work provided hands-on practice with:

### Filter/context concepts
- Filter context
- Row context vs filter context at a conceptual level
- Filter propagation through relationships
- Why a correct measure can still return an unexpected business result when the filter path is wrong
- Explicit filter transfer with `TREATAS`
- Temporarily activating an inactive relationship with `USERELATIONSHIP`
- Temporarily disabling a relationship path with `CROSSFILTER`
- Removing a specific filter context with `REMOVEFILTERS`

### Table/scalar functions
- `VALUES`
- `CALCULATETABLE`
- `CALCULATE`
- `DISTINCTCOUNT`
- `DIVIDE`
- `MIN`
- `SWITCH`
- `SELECTEDVALUE`
- `FORMAT`
- `UNICHAR`
- `VAR` / `RETURN`

### Modeling concepts
- Disconnected presentation tables
- Current-status vs historical-event vs acquisition-cohort analysis
- Active vs inactive relationships
- Date grain vs month grain
- Why relationship direction and filter path matter
- Keeping model measures reusable and using visual-only renaming when appropriate

### Dashboard engineering concepts
- KPI hierarchy
- Stakeholder-first page design
- Consistent metric definitions within a page
- Separating cohort and historical business definitions
- Validation through controlled slicer tests
- Avoiding unnecessary visuals

---

## 30. Historical Page Roadmap (recorded before later page completion)

### Completed
1. `01 - Executive Overview`
2. `02 - Funnel & Conversion`
3. `03 - Channel & Campaign Performance`
4. `04 - Marketing Efficiency & Revenue`
5. `05 - Cohort & Segment Analysis`

### Next
6. `06 - Data Quality & Validation`

### Next hands-on business question
**How do acquisition cohorts and key segments progress through the funnel, and how does performance vary across meaningful business segments?**

The next page should use existing model measures where possible and introduce new DAX only when the business requirement needs it.

---

# 27. Page 4 — Marketing Efficiency & Revenue

## Page objective

Created and completed the fourth report page: **04 - Marketing Efficiency & Revenue**.

Business question:
> How efficiently is marketing spend generating revenue, and which channels/campaigns contribute the strongest returns?

The page focuses on investment, revenue, return, acquisition cost and efficiency rather than repeating the lead/enrollment summary from Page 3.

## Page structure

### Header
- Title: `Marketing Efficiency & Revenue`
- Subtitle: `Analyze spend, revenue, return and acquisition efficiency`
- Date Range slicer
- Channel slicer
- Slicer sync was intentionally not enabled; the page uses its own contextual filters.

### KPI summary
Six KPI cards were added in this order:
- Ad Spend → `Ad Spend`
- Revenue → `Revenue`
- ROAS → `ROAS`
- CPL → `CPL`
- CAC → `CAC`
- Conversion % → `Cohort Conversion %` (display label: `Conversion %`)

For the full dataset period (01-Jan-2025 to 15-Sep-2026) with All Channels, the page showed approximately:
- Ad Spend: 4,713.73K before final display formatting; displayed as **₹4.71M**
- Revenue: **₹47.96M**
- ROAS: **10.17**
- CPL: **₹157.12**
- CAC: **₹1.38K**
- Conversion: **6.85%**

The underlying measures were reused rather than duplicated. Existing `CPL`, `CAC` and `ROAS` definitions were retained, while the page's conversion KPI uses the cohort definition for consistency with the acquisition/enrollment story used elsewhere.

## Main analytical visuals

### Monthly Spend vs Revenue

Created a Line and clustered column chart with:
- X-axis: `DimDate[YearMonth]`
- Columns: `[Ad Spend]`
- Line: `[Revenue]`

Title: `Monthly Spend vs Revenue`

The visual uses the daily Date dimension through the monthly `YearMonth` field, sorted chronologically by `YearMonthSort`. September 2026 is a partial month because the final dataset ends on 15-Sep-2026.

### Monthly ROAS Trend

Created a line chart with:
- X-axis: `DimDate[YearMonth]`
- Y-axis: `[ROAS]`

Title: `Monthly ROAS Trend`

This was kept as a separate visual instead of adding ROAS to the Spend vs Revenue chart so that investment/revenue movement and return efficiency remain distinct questions.

### Channel ROAS Comparison

Created a clustered bar chart with:
- Y-axis: `DimCampaign[Channel]`
- X-axis: `[ROAS]`
- Sorted by ROAS descending

Title: `Channel ROAS Comparison`

### Campaign ROAS Comparison

Created a clustered bar chart with:
- Y-axis: `DimCampaign[CampaignName]`
- X-axis: `[ROAS]`
- Sorted by ROAS descending

Title: `Campaign ROAS Comparison`

### Revenue by Channel

Created a clustered column chart with:
- X-axis: `DimCampaign[Channel]`
- Y-axis: `[Revenue]`
- Sorted by Revenue descending

Title: `Revenue by Channel`

Revenue is displayed in Millions for readability.

### Revenue vs Ad Spend by Channel

Created a scatter chart with:
- X-axis: `[Ad Spend]`
- Y-axis: `[Revenue]`
- Values/Details: `DimCampaign[Channel]` so each channel is represented as a point

Title: `Revenue vs Ad Spend by Channel`

The visual is intentionally retained as a relationship view rather than adding extra measures solely to make the chart denser.

## Key Business Insights panel

Added a full-width `Key Business Insights` panel at the bottom of the page. The two insights are placed side-by-side.

### Existing KBI reused — Top campaign by ROAS

The existing `KBI Top Campaign by ROAS` measure from Page 3 was reused rather than duplicated.

```DAX
KBI Top Campaign by ROAS =
VAR CampaignStats =
    ADDCOLUMNS(
        VALUES(DimCampaign[CampaignName]),
        "CampaignROAS", [ROAS]
    )
VAR TopCampaign =
    TOPN(
        1,
        CampaignStats,
        [CampaignROAS],
        DESC
    )
VAR CampaignName =
    MAXX(
        TopCampaign,
        DimCampaign[CampaignName]
    )
VAR CampaignROAS =
    MAXX(
        TopCampaign,
        [CampaignROAS]
    )
RETURN
    CampaignName
        & " generates the highest ROAS ("
        & FORMAT(CampaignROAS, "0.00")
        & ")."
```

### New KBI — Top revenue channel

Created `KBI Top Revenue Channel` to provide an insight that is distinct from the ROAS insight:

```DAX
KBI Top Revenue Channel =
VAR ChannelStats =
    ADDCOLUMNS(
        VALUES(DimCampaign[Channel]),
        "ChannelRevenue", [Revenue]
    )
VAR TopChannel =
    TOPN(
        1,
        ChannelStats,
        [ChannelRevenue],
        DESC
    )
VAR ChannelName =
    MAXX(
        TopChannel,
        DimCampaign[Channel]
    )
VAR ChannelRevenue =
    MAXX(
        TopChannel,
        [Revenue]
    )
RETURN
    ChannelName
        & " generates the highest revenue (₹"
        & FORMAT(
            DIVIDE(ChannelRevenue, 1000000),
            "#,##0.00"
        )
        & "M)."
```

The formatting was corrected after an initial test displayed the raw revenue value with an incorrect `M` suffix. The final version explicitly divides by 1,000,000 before adding the `M` display suffix.

Example full-range outputs observed during validation included:
- `Meta Conversion generates the highest ROAS (16.02).`
- `Meta generates the highest revenue (₹18.22M).`

The exact values change with the current Date Range and Channel slicers.

## Page 4 design decisions

- Reused existing measures wherever the business definition was already established.
- Kept ROAS as a primary KPI because it directly connects ad investment to revenue return.
- Kept the six analytical visuals in a balanced 2 × 3 grid.
- Added a KBI panel below the analytical visuals rather than interrupting the visual flow.
- Used the KBI panel for interpretation rather than repeating the KPI row.
- Did not add visuals merely to consume whitespace.
- Standardized chart and KPI containers with white backgrounds, light-grey borders and no shadows.
- Standardized KPI typography and chart titles.
- Kept the page background white for consistency with the other report pages.
- Final title corrected to `Marketing Efficiency & Revenue`; the earlier copied Page 3 title was removed.

## Page 4 validation

The final page was reviewed with the full Date Range and All Channels context. The KPI values reconciled with the established project measures. The Date Range slicer and Channel slicer remained functional, and the KBI measures responded dynamically to the current filter context.

### Page 4 completion status

**Completed.**

Page 4 now contains the intended efficiency KPI hierarchy, time-based spend/revenue analysis, ROAS trend, channel/campaign efficiency comparisons, revenue contribution, spend-vs-revenue relationship analysis and dynamic business insights.

---

# 28. Documentation / Interview Learning — Page 4

Important concepts added from the Page 4 build:
- ROAS is a core marketing-efficiency KPI and belongs alongside spend and revenue rather than being treated as an optional secondary metric.
- A page should have a distinct analytical purpose even when it reuses measures from earlier pages.
- Existing DAX measures should be reused when the business definition is unchanged; create a new measure only when the page requires a genuinely different definition.
- A separate ROAS trend can be clearer than combining spend, revenue and return into one overloaded visual.
- `TOPN` + `ADDCOLUMNS` + `MAXX` can be reused for dynamic channel/campaign insights at different grains.
- Dynamic text KBIs should be validated under slicer changes and should not be hard-coded.
- Monetary display units are presentation choices; they must not alter the underlying measure.
- A scatter chart is useful when the business question is the relationship between two numeric measures such as Ad Spend and Revenue.
- Intentional whitespace is preferable to adding a visual without a distinct business question.
- Page titles must match the page's analytical purpose; copied visuals should always be re-checked for titles and labels.


## 31. Project Rule Going Forward

Do not modify `FactLeads` for dashboard work. Keep the established separation:
- `FactLeads` = acquisition/current lead-level source
- `LeadStageHistory` = historical stage-event source
- Cohort measures = acquisition-cohort analysis
- Historical measures = stage-event analysis

Any future DAX change should first be checked for cross-page dependencies. If a page requires a different business definition, prefer a separate measure rather than silently changing a shared measure used by another page.


# 25. Page 3 — Channel & Campaign Performance

## Page objective

Created the third report page: **03 - Channel & Campaign Performance**.

Business question:
> Which channels and campaigns are driving the most leads, enrollments, revenue, and marketing efficiency?

The page is intentionally focused on channel/campaign comparison rather than repeating the broader executive story from Page 1.

## Page structure

### Header
- Title: `Channel & Campaign Performance`
- Subtitle: `Compare channel and campaign performance, efficiency and revenue contribution`
- Date Range slicer
- Channel slicer
- Page slicers are independent from Page 2; slicer sync was deliberately not enabled.

### KPI summary
Six contextual KPI cards were added:
- Leads → `Cohort Total Leads`
- Enrolled → `Cohort Enrolled Leads`
- Conversion % → `Cohort Conversion %`
- Ad Spend → `Ad Spend`
- Revenue → `Revenue`
- ROAS → `ROAS`

The existing Revenue and Ad Spend definitions were retained consistently across pages:

```DAX
Revenue = SUM(FactLeads[Revenue])
Ad Spend = SUM(FactAdSpend[AdSpend])
ROAS = DIVIDE([Revenue], [Ad Spend], 0)
```

This consistency is important so the same business metric does not change definition from page to page.

For the full date range (01-Jan-2025 to 15-Sep-2026), the page showed approximately:
- Leads: 30,000
- Enrolled: 2,054
- Conversion: 6.85%
- Ad Spend: 4,713.73K
- Revenue: 47.96M
- ROAS: 10.17

## Channel Performance matrix

Created a matrix with:
- Rows: `DimCampaign[Channel]`
- Values: Leads, Enrolled, Conversion %, Ad Spend, Revenue, ROAS

Visual-only display labels were shortened to:
- Leads
- Enrolled
- Conversion %
- Ad Spend
- Revenue
- ROAS

Formatting decisions:
- Revenue displayed in Millions
- Ad Spend displayed in Thousands
- Conversion % displayed as percentage with 2 decimals
- ROAS displayed as a number with 2 decimals
- Conditional background formatting applied to Conversion % and ROAS
- Channels sorted by Leads descending
- Matrix container width was reduced to avoid excessive blank space

## Campaign Performance matrix

Copied the formatted Channel Performance matrix to preserve visual consistency, then replaced the row field with a campaign hierarchy:

`DimCampaign[Channel]` → `DimCampaign[CampaignName]`

The hierarchy was expanded one level so users can see campaign detail under each channel.

Example structure:
- Meta
  - Meta Lead Gen
  - Meta Retargeting
  - Meta Conversion
- Google
  - Google Search
  - Google Performance Max
  - Google Display
- YouTube
  - YouTube Awareness
  - YouTube Video
- LinkedIn
  - LinkedIn B2B
  - LinkedIn Retargeting

The Campaign Performance matrix was widened to give campaign names more breathing room. The page intentionally does not add extra metrics simply to fill unused canvas space.

## Key Business Insights panel

Added a compact `Key Business Insights` panel below the performance matrices.

Two dynamic DAX measures were created.

### Top campaign by leads

```DAX
KBI Top Campaign by Leads =
VAR CampaignStats =
    ADDCOLUMNS(
        VALUES(DimCampaign[CampaignName]),
        "CampaignLeads", [Cohort Total Leads]
    )
VAR TopCampaign =
    TOPN(
        1,
        CampaignStats,
        [CampaignLeads],
        DESC
    )
VAR CampaignName =
    MAXX(
        TopCampaign,
        DimCampaign[CampaignName]
    )
VAR CampaignLeads =
    MAXX(
        TopCampaign,
        [CampaignLeads]
    )
RETURN
    CampaignName
        & " generates the most leads ("
        & FORMAT(CampaignLeads, "#,##0")
        & ")."
```

### Top campaign by ROAS

```DAX
KBI Top Campaign by ROAS =
VAR CampaignStats =
    ADDCOLUMNS(
        VALUES(DimCampaign[CampaignName]),
        "CampaignROAS", [ROAS]
    )
VAR TopCampaign =
    TOPN(
        1,
        CampaignStats,
        [CampaignROAS],
        DESC
    )
VAR CampaignName =
    MAXX(
        TopCampaign,
        DimCampaign[CampaignName]
    )
VAR CampaignROAS =
    MAXX(
        TopCampaign,
        [CampaignROAS]
    )
RETURN
    CampaignName
        & " generates the highest ROAS ("
        & FORMAT(CampaignROAS, "0.00")
        & ")."
```

These measures were tested in temporary Card visuals before being placed in the final KBI panel. Under the full date range and All Channels context, the tested outputs were:
- `Google Search generates the most leads (4,150).`
- `Meta Conversion generates the highest ROAS (16.02).`

The temporary test cards were removed after validation.

## Page 3 design decisions

- Kept the page focused on channel and campaign performance rather than adding redundant charts.
- Did not add a visual solely to fill right-side whitespace; intentional whitespace is preferable to unnecessary visuals.
- Kept the KBI panel below the two matrices because the Campaign Performance hierarchy is taller than the Channel matrix.
- KPI cards were aligned and distributed horizontally.
- Campaign matrix was widened for readability.
- Final page background was changed to white for consistency with the other report pages.

## Page 3 validation

The Date Range was temporarily changed during layout testing and then restored to the full dataset period, 01-Jan-2025 to 15-Sep-2026. The restored full-range values reconciled across the KPI cards, Channel Performance matrix, Campaign Performance matrix and KBI measures.

### Page 3 completion status

**Completed.**

Page 3 now contains the intended KPI summary, channel comparison, channel-to-campaign hierarchy, contextual slicers and dynamic campaign insights.

---

# 26. Documentation / Interview Learning — Page 3

Important concepts added from the Page 3 build:
- Reusing a formatted visual is efficient, but row grain must be reconsidered when changing Channel to Campaign.
- A hierarchy such as Channel → Campaign can provide both summary and detail without creating a separate chart for every level.
- `TOPN` + `ADDCOLUMNS` + `MAXX` can produce dynamic text-based business insights.
- KPI definitions should remain consistent across report pages.
- Display units are a presentation choice and should not alter the underlying measure.
- Whitespace is acceptable when it improves readability; every empty area does not need a visual.


# 2026-10-02 — Page 5 Completed: Cohort & Segment Analysis

## Page objective

Created and completed **05 - Cohort & Segment Analysis**.

Business question:
> How do acquisition cohorts progress through the funnel, and how does conversion/enrollment performance vary across channels?

The page is intentionally analytical rather than KPI-heavy. Pages 1–4 already establish the headline business metrics, so Page 5 focuses on cohort trends, channel segmentation and funnel comparison without repeating a KPI row.

## Page structure

### Header
- Title: `Cohort & Segment Analysis`
- Subtitle: `Analyze acquisition cohorts and segment-level conversion performance`
- Date Range slicer
- Channel slicer
- Slicer sync was intentionally not enabled; the page uses its own contextual filters.

### Analytical visuals
1. `Acquisition Cohort Conversion Trend`
   - X-axis: `DimDate[YearMonth]`
   - Y-axis: `[Cohort Conversion %]`
   - Shows acquisition-cohort conversion by month.

2. `Acquisition Cohort Size`
   - X-axis: `DimDate[YearMonth]`
   - Y-axis: `[Cohort Total Leads]`

3. `Enrolled Leads by Acquisition Cohort`
   - X-axis: `DimDate[YearMonth]`
   - Y-axis: `[Cohort Enrolled Leads]`

4. `Conversion Rate by Channel`
   - X-axis: `DimCampaign[Channel]`
   - Y-axis: `[Cohort Conversion %]`
   - Sorted descending.
   - Full-range values observed: Meta 7.74%, Google 6.99%, LinkedIn 6.69%, YouTube 5.16%.

5. `Enrolled Leads by Channel`
   - X-axis: `DimCampaign[Channel]`
   - Y-axis: `[Cohort Enrolled Leads]`
   - Sorted descending with data labels.

6. `Leads by Channel`
   - X-axis: `DimCampaign[Channel]`
   - Y-axis: `[Cohort Total Leads]`
   - Sorted descending with data labels.

7. `Channel Funnel Comparison` matrix
   - Rows: `DimCampaign[Channel]`
   - Values: `[Cohort Total Leads]`, `[Cohort Qualified Leads]`, `[Cohort Demo Leads]`, `[Cohort Enrolled Leads]`, `[Cohort Conversion %]`
   - Display headers: Leads, Qualified, Demo, Enrolled, Conversion %.
   - Sorted by Leads descending.

## Segment Insight KBI

Created a dynamic measure for the `Segment Insight` panel:

```DAX
KBI Top Channel Conversion =
VAR SelectedChannels =
    VALUES(DimCampaign[Channel])
VAR ChannelCount =
    COUNTROWS(SelectedChannels)
VAR TotalChannels =
    CALCULATE(
        DISTINCTCOUNT(DimCampaign[Channel]),
        REMOVEFILTERS(DimCampaign[Channel])
    )
VAR ChannelStats =
    ADDCOLUMNS(
        SelectedChannels,
        "ChannelConversion", [Cohort Conversion %]
    )
VAR TopChannel =
    TOPN(
        1,
        ChannelStats,
        [ChannelConversion],
        DESC
    )
VAR ChannelName =
    MAXX(TopChannel, DimCampaign[Channel])
VAR ChannelConversion =
    MAXX(TopChannel, [ChannelConversion])
RETURN
    IF(
        ChannelCount = 1,
        ChannelName
            & " has an acquisition-to-enrolled conversion of "
            & FORMAT(ChannelConversion, "0.00%")
            & ".",
        ChannelName
            & " has the highest acquisition-to-enrolled conversion at "
            & FORMAT(ChannelConversion, "0.00%")
            & "."
    )
```

### KBI filter-context issue and fix

During final validation, the Segment Insight initially appeared to respond to Date but not behave as expected for Channel selection. The measure itself was valid, but its behavior needed to explicitly distinguish the one-channel case from a multi/all-channel comparison. The final measure now:
- Shows the selected channel's conversion when exactly one channel is selected.
- Identifies the highest-converting channel when multiple/all channels are in context.
- Responds to the Date Range through the existing cohort measure.

The Channel slicer interaction with the Segment Insight was also verified as **Filter**.

Example full-range values:
- All channels → Meta has the highest acquisition-to-enrolled conversion at 7.74%.
- Google selected → Google has an acquisition-to-enrolled conversion of 6.99%.

## Why Page 5 has no KPI row

No additional KPI row was added because the page's purpose is cohort and segment analysis, while the main headline KPIs are already established on Pages 1–4. Repeating those cards would add redundancy without introducing a new business question.

## Visual formatting completed

- White page background, 0% transparency.
- Consistent light-grey 1 px borders across analytical visuals.
- No unnecessary shadows.
- Standardized chart title typography.
- Date Range and Channel slicers formatted consistently.
- Channel Funnel Comparison matrix formatted for readability.
- Key Business Insights / Segment Insight panel standardized.
- Top, middle and bottom visual rows aligned and distributed.
- Intentional whitespace retained rather than adding visuals solely to fill the canvas.

## Page 5 validation

- Cohort measures respond to Date Range and Channel context.
- Channel conversion values were validated.
- Channel Funnel Comparison uses the cohort definitions consistently.
- Segment Insight was tested with channel filtering after the final KBI update.
- September 2026 remains a partial month because the dataset ends on 15-Sep-2026.

### Page 5 completion status

**Completed.**

The report now has five completed analytical pages: Executive Overview, Funnel & Conversion, Channel & Campaign Performance, Marketing Efficiency & Revenue, and Cohort & Segment Analysis.

## Page 5 learning points

- A page does not need KPI cards if the business question is already well represented by analytical visuals.
- Cohort measures must be interpreted as acquisition-cohort metrics, not as stage-event-period metrics.
- A dynamic text KBI should account for filter context; a single selected category is different from ranking across multiple categories.
- `VALUES` + `ADDCOLUMNS` + `TOPN` + `MAXX` is a useful pattern for dynamic segment insights.
- Visual interaction settings can be as important as DAX when troubleshooting slicer behavior.
- Final dashboard formatting should standardize borders, titles, slicers, alignment and whitespace without adding unnecessary content.

# 2026-10-05 — Page 6 Completed: Data Quality & Validation

## Page objective

Page 6 was created as a dedicated validation page to demonstrate that the report's source data, relationships, dates, stage history and core business logic are internally consistent.

The page is intentionally validation-focused rather than another performance-analysis page. No new dashboard page was added merely to fill space, and no changes were made to `FactLeads` during this validation work.

## Page structure

Page name:
`06 - Data Quality & Validation`

Header:
- Title: `Data Quality & Validation`
- Subtitle: `Validate source integrity, funnel consistency and report reliability`
- Date Range slicer
- Channel slicer

Validation sections:
1. Lead Integrity
2. Date & History Integrity
3. Business Validation
   - Funnel & Stage Checks
   - Financial & Ad Spend Checks
4. Overall Status
5. Stage Reconciliation Table

## Lead Integrity validations

The following checks were created and validated:

- `Unique Lead IDs` → 30,000
- `Duplicate Lead IDs` → 0
- `Blank Lead IDs` → 0
- `Orphan Lead IDs` → 0
- `Orphan Lead Campaign IDs` → 0
- `Orphan Ad Spend Campaign IDs` → 0

The campaign orphan checks validate the two important campaign relationships:
- `DimCampaign[CampaignID]` → `FactLeads[CampaignID]`
- `DimCampaign[CampaignID]` → `FactAdSpend[CampaignID]`

### Orphan Campaign ID pattern

```DAX
Orphan Lead Campaign IDs =
COUNTROWS(
    EXCEPT(
        VALUES(FactLeads[CampaignID]),
        VALUES(DimCampaign[CampaignID])
    )
) + 0
```

The same `EXCEPT` pattern was used for Ad Spend.

## Date & History Integrity validations

Validated results:

- `Lead Created Row Count` → 30,000
- `Blank Lead Dates` → 0
- `Lead Dates Outside Calendar` → 0
- `Blank Stage Dates` → 0
- `Stage Dates Outside Calendar` → 0
- `Lead Created Date Mismatches` → 0
- `Total Stage History Records` → 46,883
- `Lead Created Reconciliation` → 0

### Blank date pattern

```DAX
Blank Lead Dates =
COUNTROWS(
    FILTER(
        FactLeads,
        ISBLANK(FactLeads[LeadDate])
    )
) + 0
```

The same pattern was used for `LeadStageHistory[StageDate]` and `FactAdSpend[Date]`.

### Dates outside the calendar

The validation uses the full `DimDate` range rather than the current slicer range:

```DAX
VAR MinCalendarDate =
    CALCULATE(
        MIN(DimDate[Date]),
        ALL(DimDate)
    )
VAR MaxCalendarDate =
    CALCULATE(
        MAX(DimDate[Date]),
        ALL(DimDate)
    )
```

The measure then checks whether a fact date is before `MinCalendarDate` OR after `MaxCalendarDate`.

Important DAX concept reinforced:
- `ALL(DimDate)` removes the current `DimDate` filter context so validation uses the entire calendar range.
- `VAR` stores an intermediate calculated value for reuse later in the measure.
- `||` means OR.
- `RETURN` produces the final measure result.

### Lead Created date reconciliation

A dedicated measure compared each `Lead Created` event in `LeadStageHistory` with the corresponding `FactLeads[LeadDate]`.

Result:
`Lead Created Date Mismatches` → 0

This confirms that the repaired historical `Lead Created` event dates align with the acquisition dates used by the cohort model.

### Lead Created reconciliation

```DAX
Lead Created Reconciliation =
[Unique Lead IDs] - [Lead Created Events]
```

Result:
`0`

This confirms that the 30,000 unique leads are represented by 30,000 Lead Created events.

## Stage validation

Validated results:

- `Unexpected Stage Records` → 0
- `Blank Stage Records` → 0
- `Invalid Stage Order Records` → 0
- `Stage Count Reconciliation` → 0
- `Funnel Consistency Check` → PASS

The stage counts are:

| Stage | Records |
|---|---:|
| Lead Created | 30,000 |
| Qualified | 9,561 |
| Demo | 5,268 |
| Enrolled | 2,054 |
| Total | 46,883 |

### Stage Count Reconciliation

The validation confirms that the four expected stages account for all 46,883 history records.

Result:
`Stage Count Reconciliation` → 0

### Funnel Consistency Check

The measure validates the expected decreasing funnel relationship:

`Lead Created >= Qualified >= Demo >= Enrolled`

Observed:
`30,000 → 9,561 → 5,268 → 2,054`

Result:
`Funnel Consistency Check` → `PASS`

This is a business-rule validation rather than only a technical null/duplicate check.

## Revenue and Ad Spend validations

Revenue checks:
- `Negative Revenue Records` → 0
- `Blank Revenue Records` → 0

Ad Spend checks:
- `Negative Ad Spend Records` → 0
- `Blank Ad Spend Records` → 0
- `Blank Ad Spend Dates` → 0
- `Ad Spend Dates Outside Calendar` → 0

### Negative Revenue

```DAX
Negative Revenue Records =
COUNTROWS(
    FILTER(
        FactLeads,
        FactLeads[Revenue] < 0
    )
) + 0
```

### Negative Ad Spend

```DAX
Negative Ad Spend Records =
COUNTROWS(
    FILTER(
        FactAdSpend,
        FactAdSpend[AdSpend] < 0
    )
) + 0
```

These checks do not assume that every negative value would automatically be an error; they first identify whether such records exist. In the current dataset the result is zero.

## Overall Data Quality Status

A dynamic summary measure was created so the page can return `PASS` or `CHECK` based on the validation rules instead of hardcoding a status.

The final measure includes:
- Duplicate Lead IDs
- Blank Lead IDs
- Orphan Lead IDs
- Unexpected Stage Records
- Blank Stage Records
- Invalid Stage Order Records
- Blank Lead Dates
- Lead Dates Outside Calendar
- Blank Stage Dates
- Stage Dates Outside Calendar
- Lead Created Date Mismatches
- Stage Count Reconciliation
- Lead Created Reconciliation
- Funnel Consistency Check
- Negative Revenue Records
- Blank Revenue Records
- Negative Ad Spend Records
- Blank Ad Spend Records
- Blank Ad Spend Dates
- Ad Spend Dates Outside Calendar
- Orphan Lead Campaign IDs
- Orphan Ad Spend Campaign IDs

Final result:
`Overall Data Quality Status` → `PASS`

Important design principle: the status does not hardcode `30,000` as a required lead count. It checks integrity conditions rather than assuming the dataset will never grow.

## Stage Reconciliation Table

The existing table was retained and titled:
`Lead Stage Record Count`

It provides a simple stakeholder-facing reconciliation of the four stage categories against the total history records.

## Page 6 formatting and UX decisions

- Page background finalized as white.
- KPI cards standardized to approximately 168 px wide × 112 px high.
- White KPI backgrounds with subtle light-grey borders.
- No heavy shadows or unnecessary colored containers.
- Validation cards grouped into clear sections.
- `PASS` values are visually emphasized while zero-value checks remain neutral.
- Intentional whitespace retained rather than adding decorative visuals.
- Date Range and Channel slicers retained for contextual inspection.
- Stage Reconciliation Table positioned beside Overall Status near the bottom of the page.

## Page 6 completion status

**Completed.**

The report now has six completed pages:
1. Executive Overview
2. Funnel & Conversion
3. Channel & Campaign Performance
4. Marketing Efficiency & Revenue
5. Cohort & Segment Analysis
6. Data Quality & Validation

## Page 6 learning points

- A validation page should answer whether the report can be trusted, not repeat performance analysis.
- `ALL()` is used to remove filter context from the specified table/column; it is especially useful when validation must ignore slicers.
- DAX variables (`VAR`) make complex calculations easier to read and reuse.
- `EXCEPT` is useful for finding orphan dimension keys.
- Data-quality checks should cover values, dates, relationships and business rules.
- A dynamic overall status is more robust than hardcoding a PASS message.
- Reconciliation checks provide evidence that repaired or transformed data remains consistent.
- Dashboard design should avoid adding cards or visuals solely to occupy empty canvas space.

## Current project position after Page 6

The analytical dashboard and dedicated validation page are complete. The next phase is **final UAT / report quality review**, followed by any required drill-through/drill-down, Power BI Service deployment and final business-story refinement. No further dashboard page should be created unless a distinct business question requires it.

## Bookmarks, Selection Pane, and Button Actions — Practical UX Exercise

**Status: Completed and functionally tested**

### Goal
Create a compact filter-panel interaction on `03 - Channel & Campaign Performance` so report users can open and close the Date Range and Channel slicers without using the developer's Bookmarks pane.

### Selection pane learning
- The Selection pane lists page objects (visuals, slicers, buttons, shapes, text boxes, and other objects).
- Its eye icon controls whether an object is visible on the report canvas; hiding an object does not delete it.
- The pane also helps select objects that are difficult to click on the canvas and manage layer order. Tab order is a separate accessibility-related control.
- Changing visibility in the Selection pane changes the current canvas state. A bookmark must be updated to capture that new state.

### Bookmarks created
Two bookmarks are used:
- `Filters Open`
- `Filters Closed`

For both filter-panel bookmarks, the intended settings are **Display ON** and **Data OFF**.
- **Display ON** lets the bookmark restore the saved visual display/visibility state.
- **Data OFF** prevents the bookmark from restoring saved slicer/filter selections. The goal is to open/close the panel without unexpectedly changing the user's chosen date or channel.
- `Data` can be useful in other scenarios when a bookmark is intentionally designed to return users to a saved analytical/filter state; it is not universally supposed to be OFF.

### Button actions
Two blank buttons were added from Insert → Buttons and configured through Format button → Action:
- `Filters` → Action ON → Type Bookmark → `Filters Open`
- `Close Filters` → Action ON → Type Bookmark → `Filters Closed`

In Power BI Desktop edit mode, use **Ctrl + Click** to execute a button action; a normal click selects the button for editing.

### Final visibility states
| Object | `Filters Open` | `Filters Closed` |
|---|---|---|
| `Slicer - Date Range` | Visible | Hidden |
| `Slicer - Channel` | Visible | Hidden |
| `Filters` button | Hidden | Visible |
| `Close Filters` button | Visible | Hidden |

The visibility state was prepared with the Selection pane and saved by updating the corresponding existing bookmark.

### Validation performed
- `Filters Closed` showed only the `Filters` button; both slicers and `Close Filters` were hidden.
- Activating `Filters` showed both slicers and `Close Filters`, while hiding `Filters`.
- Activating `Close Filters` hid both slicers and that button, while showing `Filters` again.
- The user tested the two-way interaction and confirmed it works. Earlier testing also confirmed that selected channel filters were preserved when switching the filter panel open/closed with Data OFF.

### Key learning
- **Selection pane = control individual objects' visibility and layering.**
- **Bookmark = save/restore a configured report state.**
- **Button Action = let the report user activate a bookmark without opening the developer Bookmarks pane.**
- Bookmarks can control visibility of slicers, buttons, charts, cards, text, and other page objects—not only filter selections.
- A bookmark only captures the options and visuals included in its saved configuration; after changing visibility, update the intended bookmark.

### UX decision
Keep the buttons in their current top-right area near the slicers. Their position and functionality were tested; avoid further cosmetic tweaking unless later UAT identifies a concrete usability issue.

### Next learning phase
Move on to Power BI Service and publishing, then workspace/report/semantic model concepts, credentials, refresh history and scheduled refresh. Continue with database connectivity (MySQL/SQL Server), Import vs DirectQuery, gateway, incremental refresh, RLS, APIs/JSON, and DEV → UAT → PROD workflow.

---

## Dynamic Row-Level Security (RLS) — City-Based Practice

**Status: Created and tested in Power BI Desktop; Power BI Service assignment/publishing still pending.**

### Goal
Practise user-based security on the existing Marketing Funnel & Campaign Intelligence report. City managers should see only their assigned city's lead records, while the Marketing Head can see all cities.

### Static RLS completed first
- Created role `RLS_Bangalore`.
- Applied a fixed filter to `FactLeads`: `City` equals the exact Bangalore city value used in the dataset.
- Used the person icon beside **Manage roles** (View as) to activate the role and inspect the report.
- The role was confirmed active by the orange “Now viewing as” banner. The lead count changed, then the city restriction was identified as something that should be validated by checking the actual City values—not inferred from a lower count alone.

### Dynamic RLS mapping table
Created `UserCityAccess` with two columns:
- `UserEmail`
- `City`

Practice mappings used:
| UserEmail | City |
|---|---|
| `bangalore.manager@example.com` | `Bangalore` |
| `mumbai.manager@example.com` | `Mumbai` |
| `delhi.manager@example.com` | `Delhi` |
| `marketing.head@example.com` | `ALL` |

`ALL` is a user-created text label, not a special DAX function. It represents the Marketing Head's all-city permission and must be explicitly handled by the RLS expression.

### Dynamic role and final lead-table rule
- Created role `RLS_Dynamic`.
- Initially tested a rule on `UserCityAccess` (Formula 1), which filtered the mapping table but did not itself secure `FactLeads`.
- Removed the rule from `UserCityAccess`; the mapping table is used as the lookup source.
- Applied the following rule to `FactLeads`:

```dax
VAR CurrentUser = USERPRINCIPALNAME()
VAR AllowedCity =
    LOOKUPVALUE(
        UserCityAccess[City],
        UserCityAccess[UserEmail], CurrentUser
    )
RETURN
    NOT ISBLANK(AllowedCity)
        && (
            AllowedCity = "ALL"
                || FactLeads[City] = AllowedCity
        )
```

### How the expression works
- `USERPRINCIPALNAME()` returns the identity being evaluated (typically the user's sign-in email in the Service; Desktop's **Other user** option can simulate an identity).
- `LOOKUPVALUE` finds the `City` mapped to that email in `UserCityAccess`.
- `NOT ISBLANK(AllowedCity)` denies rows through this rule when no mapping is found.
- `AllowedCity = "ALL"` allows every row of `FactLeads` under this rule for the Marketing Head.
- Otherwise, `FactLeads[City] = AllowedCity` allows only lead rows matching the assigned city.
- `&&` means AND; `||` means OR.

### Testing and observed result
- Opened **Modeling → View as** using the person icon beside **Manage roles**.
- Selected `RLS_Dynamic` and **Other user** together, then entered a matching practice email. Selecting only the role uses the current identity, which may not match the practice mapping and can cause blank results.
- Tested the city-manager identity/identities and confirmed that the lead metrics and other visuals changed as expected.
- Tested `marketing.head@example.com`; the user reported that the Marketing Head could see the unrestricted total of **30,000 leads**.
- Returned to normal viewing with **Stop viewing** when finishing a test.

### Important cautions / remaining work
- A lower lead count alone does not prove the correct city is being shown; verify the actual city restriction as well.
- RLS must be reviewed across the model, especially visuals backed by `FactAdSpend`, `CampaignBudget`, and other tables. Desktop tests showed the report visuals changing, but a production review should verify that no table exposes data beyond the intended access scope.
- The Desktop simulation does not assign real users in Power BI Service. After publishing, assign actual users/groups to `RLS_Dynamic` under the semantic model's Security settings and test with appropriate accounts.
- Workspace roles matter: workspace Admins, Members, and Contributors are not restricted by RLS in the same way as Viewers. Grant workspace permissions carefully.
- Do not consider RLS production-ready until Service role assignment, access-path review, and end-to-end testing are complete.

### Next step
Proceed to Power BI Service publishing only after saving the PBIX in its normal unrestricted state. Then configure semantic model credentials/refresh as applicable, assign users to the role, and test published access.

---

## Project File Maintenance Rule — Confirmed 10 October 2026

Going forward, maintain these two project records together after each meaningful Power BI learning or build session:

- **`PROJECT_LOG.md`** — record what was done, the reason for each decision, data/model/DAX/report changes, issues and troubleshooting, concepts learned, validation results, remaining work, and the next step. Preserve existing decisions and history; do not replace earlier content with a summary.
- **`INTERVIEW_QA.md`** — add important concepts and interview-ready questions/answers arising from the work, using the project's actual table names, measures, formulas, decisions, and observed results. Explain the reasoning, not just definitions.

### Save-and-update workflow
1. Append to both files whenever a meaningful concept, modeling decision, DAX pattern, troubleshooting lesson, or project milestone occurs.
2. Keep the two files consistent; the project log records the full work and rationale, while the QA file captures the reusable interview explanation.
3. Preserve previous content and append or carefully amend only where necessary. Do not claim a file was updated until the saved copy has been written and checked.
4. Track open items explicitly. Current RLS next step remains Power BI Service publishing, role assignment, and published-access testing.


## 2026-10-10 — Report Tooltip, UAT Completion, and Restart Checkpoint

### Report-page tooltip — implemented and validated
- Implemented a report-page tooltip for campaign-level context on the Campaign Performance matrix.
- The tooltip presents contextual campaign metrics such as Leads, Conversion %, and ROAS when a user hovers over a campaign row.
- Validated examples: Meta Lead Gen — 557 leads, 6.10% conversion, ROAS 12.05; Google Search — 2,402 leads, 6.37% conversion, ROAS 13.00; Google Performance Max — 1,761 leads, 9.09% conversion, ROAS 13.43. These are observed tooltip values from the tested report context, not universal totals for every filter selection.
- Tooltip behaviour was confirmed in the report; do not list tooltip implementation as pending.
- Purpose: provide useful detail without overcrowding the main report page, while keeping the campaign context that triggered the tooltip.

### UAT status checkpoint
- UAT-01 Data Quality Baseline: PASS.
- UAT-02 Channel slicer and reset: PASS.
- UAT-03 Date slicer behaviour: PASS for responsiveness; September 2026 is partial through 15 September.
- UAT-04 Page navigation: PASS.
- UAT-05 KPI consistency: PASS as recorded; note that not every variant of every KPI was independently re-audited.
- UAT-06 Bookmark/filter-panel interaction: PASS.
- UAT-07 Campaign tooltip: PASS.
- UAT-08 Cross-filtering: PASS; clearing a selection was less intuitive than expected, so a reset-button enhancement can be considered later.
- UAT-09 Date and channel slicer interaction: PASS.
- UAT-10 Lead Created Row Count definition: PASS with documented decision to keep the existing global integrity-count measure unchanged; the temporary responsive test measure was only for diagnosis and its card was removed.
- UAT-11 Refresh: PASS, no errors.
- UAT-12 Slicer reset/default state: PASS.
- UAT-13 Page/report filter validation: PASS.
- UAT-14 Report consistency across pages: PASS as reported.
- UAT-15 Dynamic RLS: PASS in Power BI Desktop simulation; Power BI Service role assignment and published-access testing remain pending.
- UAT-16 Visual layout/usability: PASS.
- UAT-17 Deployment readiness: IN PROGRESS; verify saved PBIX/source paths and complete Service deployment checks.

### Current project state
- Six report pages are built: Executive Overview; Funnel & Conversion; Channel & Campaign Performance; Marketing Efficiency & Revenue; Cohort & Segment Analysis; Data Quality & Validation.
- Bookmark-based filter panel, campaign tooltip, and Desktop Dynamic RLS simulation are implemented/tested.
- Desktop refresh succeeded. This is distinct from business validation and from Service refresh configuration.
- Dynamic RLS mapping uses `UserCityAccess`; Desktop simulations were successful, but Service role assignment is not yet complete.
- Keep `FactLeads` unchanged unless a clear data-quality/business reason is established and the user explicitly approves. Do not invent missing later-stage dates.
- Dataset coverage is 01-Jan-2025 to 15-Sep-2026; September 2026 is partial.

### Restart point / next actions
1. Re-open the existing PBIX and confirm the saved report/model is the expected latest version; do not rebuild completed pages.
2. Verify source-file paths and refresh once from the saved PBIX; avoid connecting to `LeadStageHistory_Old.csv`.
3. Confirm the report is saved in its normal unrestricted state (not in View as/RLS simulation and without accidental test filters).
4. Finish deployment-readiness checks and only then publish to Power BI Service if account/workspace access allows.
5. In Service, assign users/groups to `RLS_Dynamic`, test published access, and review table/filter paths. Use free services only; do not activate paid upgrades or Azure pay-as-you-go.
6. Keep Fabric learning in a separate section/project until this Power BI project is finished.

## 2026-10-10 — Pre-Publish Verification and Dynamic RLS Desktop Test

### Saved PBIX and source inventory
- Current PBIX identified by the user: `C:\Users\USER\Desktop\PBI Learn\Marketing_Funnel_Campaign_Intelligence.pbix`.
- Report tab screenshots showed eight pages: `01 - Executive Overview`, `02 - Funnel & Conversion`, `03 - Channel & Campaign Performance`, `04 - Marketing Efficiency & Revenue`, `05 - Cohort & Segment Analysis`, `06 - Data Quality & Validation`, `07 - Campaign Detail`, and `08 - Campaign Tooltip`.
- Preserve the additional Campaign Detail and Campaign Tooltip pages; do not remove them during cleanup.
- Data Source Settings showed eight CSV sources: `CampaignBudget.csv`, `CRMActivity.csv`, `DimCampaign.csv`, `DimCustomer.csv`, `DimDate.csv`, `FactAdSpend.csv`, `FactLeads.csv`, and `LeadStageHistory.csv`. Paths appear to be under the expected `C:\Users\USER\Downloads\MarTech_PowerBI_Project_Tables` folder; screenshot truncation means exact full path for every individual source was not independently read.
- User refreshed the currently open PBIX successfully with no reported error.
- In View as roles, `None`, `RLS_Bangalore`, and `RLS_Dynamic` were present. User selected `None`, returned to `01 - Executive Overview`, and saved the report before the security check.

### Dynamic RLS rule reviewed
The user confirmed that the `FactLeads` rule for `RLS_Dynamic` is:

```dax
VAR CurrentUser = USERPRINCIPALNAME()
VAR AllowedCity = LOOKUPVALUE(UserCityAccess[City], UserCityAccess[UserEmail], CurrentUser)

RETURN
    NOT ISBLANK(AllowedCity)
        && (AllowedCity = "ALL" || FactLeads[City] = AllowedCity)
```

- The rule structure matches the intended design: resolve the current user's mapped city, deny when no mapping is found, allow all cities for the explicit `ALL` mapping, otherwise restrict `FactLeads` to the mapped city.
- Important deployment dependency: `UserCityAccess[UserEmail]` must match the identity returned by `USERPRINCIPALNAME()` in the Service environment, and the mapping must be unambiguous for `LOOKUPVALUE`.

### Desktop RLS test result
- Screenshots showed both `mumbai.manager@example.com` and `marketing.head@example.com` simulated under `RLS_Bangalore`, with the same visible KPIs: 3,751 acquired, 1,182 qualified, 653 demo, 253 enrolled, 6.74% conversion, ROAS 1.20. This only confirms their view under the same static role; it does not establish distinct dynamic access.
- User then switched to `RLS_Dynamic`, tested the mapped identities, and explicitly confirmed: “done, its working.”
- Mark Desktop Dynamic RLS simulation as **PASS (user-confirmed)**. Exact per-user city names and separate numeric screenshots for this final Dynamic role test were not provided in the current exchange; Service-side validation remains necessary.

### Updated deployment checkpoint
- PBIX path identified; eight report pages visible; eight CSV sources listed; Desktop refresh successful.
- Report was returned to `None` role simulation and saved before Dynamic RLS testing.
- Dynamic RLS DAX reviewed and Desktop simulation reported working.
- **Still pending:** open Power BI Service using the user's existing free account; confirm workspace access; publish only if available without paid upgrade; assign appropriate users/groups to `RLS_Dynamic`; test the published report under real account identities; confirm Service-side permissions and refresh behavior.
- Free-services-only constraint remains in effect. Do not activate paid capacity, Azure pay-as-you-go, or paid upgrades. Keep Fabric learning separate until this project is complete.


---

## 2026-10-12 — MySQL Staging Database and First CSV Import

### Goal
Create a separate MySQL staging database for the Marketing Funnel & Campaign Intelligence dataset so Power BI can later be practised against a relational database source without modifying the original PBIX or source CSV files.

### Environment and database
- MySQL Workbench and MySQL Server are installed; the server version previously verified with `SELECT VERSION()` is **8.0.25**.
- Created a separate database: `marketing_funnel_mysql`.
- `SHOW TABLES` confirmed nine tables: `campaignbudget`, `crmactivity`, `dimcampaign`, `dimcustomer`, `dimdate`, `dimmonth`, `factadspend`, `factleads`, and `leadstagehistory`.
- Workbench displays the table names in lowercase in the schema browser. This display alone does not imply that the column definitions were changed.

### Schema validation
- Ran `DESCRIBE FactLeads`. The result showed the expected eight columns: `LeadID`, `LeadDate`, `CampaignID`, `Source`, `City`, `Program`, `LeadStatus`, and `Revenue`.
- `LeadID` is `VARCHAR(10)`, `NOT NULL`, and the primary key; `LeadDate` is `DATE`; `Revenue` is `DECIMAL(12,2)`. The other columns matched the planned schema and names.
- Keeping source column and table names aligned reduces migration changes, but it does not guarantee that a Power BI source switch will be zero-touch. Data types, Power Query steps, relationships, measures, refresh, and RLS must still be checked in a separate PBIX copy.

### First import: `FactLeads.csv`
- Used MySQL Workbench's **Table Data Import Wizard** and selected the existing destination `marketing_funnel_mysql.factleads`.
- Left **Truncate table before import** unchecked.
- Verified all eight source columns were mapped to matching destination columns. The preview showed `LeadDate` values in `YYYY-MM-DD` form and decimal Revenue values.
- The wizard log finished with `Import finished` / `Import data file finished`.
- Validation query `SELECT COUNT(*) FROM FactLeads;` returned **30,000**, matching the expected row count. **Status: PASS.**

### Bulk loading investigation: `LOAD DATA LOCAL INFILE`
- Checked the server setting with `SHOW VARIABLES LIKE 'local_infile';`.
- Observed `local_infile = OFF`. This means the server's `LOCAL INFILE` capability is currently disabled; it does not mean that CSV imports in general are disabled. The Workbench Import Wizard successfully loaded `FactLeads` despite this setting.
- Discussed `LOAD DATA LOCAL INFILE` as an SQL-based bulk-loading option that can be more efficient for large CSV files, depending on client/server configuration, file format, indexes, and environment. No change to `local_infile` has been made and no `LOAD DATA` command has been run.
- Security note: do not enable local-file loading casually. First understand the client/server setting and trusted local-file implications; use the Import Wizard as the safe working fallback if bulk loading is not configured.

### Decisions and safeguards
- Preserve the table schemas and original CSVs. Do not drop the tables merely to retry an import. If an import partially fails, inspect row counts and logs before clearing data; avoid rerunning an append import into a populated primary-key table because duplicate-key errors may occur.
- Do not import `LeadStageHistory_Old.csv`; it is an old backup.
- `DimMonth` needs special care: the existing Power BI model's `DimMonth` was created as a Power Query Reference from `DimDate`, while a `DimMonth.csv` also exists in the folder. Before connecting/migrating, decide whether to retain the existing derived table or use the CSV; do not load both versions into the Power BI model unintentionally.
- Keep the original PBIX unchanged. Test the MySQL connection/source replacement in a separate PBIX copy and validate all tables, row counts, data types, relationships, measures, report pages, refresh, and RLS.

### Next steps
1. Finish/close the successful import wizard.
2. Validate a small sample from `FactLeads` with `SELECT * FROM FactLeads LIMIT 5;`.
3. Decide whether to continue with the Workbench Import Wizard or carefully configure `LOAD DATA LOCAL INFILE`; do not change server settings until needed.
4. Import the remaining CSVs into their matching existing tables and validate counts against the project baseline: `DimDate` 623; `FactAdSpend` 6,230; `CampaignBudget` 210; `CRMActivity` 36,057; `LeadStageHistory` 46,883; `DimCampaign` 10. `DimCustomer` row count still needs to be checked.
5. After the MySQL staging tables are validated, connect a copy of the PBIX to MySQL and test refresh/model parity.

### Detailed command log and `local_infile` configuration procedure (clarification)

This subsection records the exact commands discussed and separates completed actions from a possible future configuration change.

**Commands actually run and observed results**

```sql
CREATE DATABASE marketing_funnel_mysql;
USE marketing_funnel_mysql;
SHOW TABLES;
DESCRIBE FactLeads;
SHOW VARIABLES LIKE 'local_infile';
SELECT COUNT(*) AS total_rows FROM FactLeads;
```

- `SHOW TABLES` displayed the nine created tables: `campaignbudget`, `crmactivity`, `dimcampaign`, `dimcustomer`, `dimdate`, `dimmonth`, `factadspend`, `factleads`, and `leadstagehistory`.
- `DESCRIBE FactLeads` confirmed eight columns and `LeadID` as the non-null primary key.
- The Table Data Import Wizard was run against the existing `marketing_funnel_mysql.factleads` table. The “Truncate table before import” option was left unchecked; the source-to-destination mapping was checked; the wizard log showed completion; `SELECT COUNT(*)` returned **30000**.
- `SHOW VARIABLES LIKE 'local_infile';` returned `OFF`.

**Historical note (superseded by the 2026-10-12 continuation below):** At the time this earlier section was first written, `local_infile` had not yet been enabled. Later in the same project session, the user executed `SET GLOBAL local_infile = ON`, verified global and session values as ON, attempted a client connection option, and successfully imported `DimCampaign` with `LOAD DATA LOCAL INFILE` after correcting the line terminator. See the dated continuation for the complete sequence and final results.

**Possible future configuration path — not yet executed**

1. First inspect the setting in the current connection:

   ```sql
   SHOW VARIABLES LIKE 'local_infile';
   ```

2. If we explicitly decide to use `LOAD DATA LOCAL INFILE`, check whether the MySQL account has permission to change global variables and whether the client/Workbench connection also allows local-file loading. Server-side and client-side support may both be required.
3. A temporary server-side change, if supported and permitted by the installation, is typically:

   ```sql
   SET GLOBAL local_infile = ON;
   SHOW VARIABLES LIKE 'local_infile';
   ```

   This changes a server setting and may require administrative privileges. It may not persist after a server restart. Do not run it yet; first assess the security implications and client setting.
4. A persistent configuration can be made in the MySQL server configuration file under the `[mysqld]` section with `local_infile=ON`, followed by a controlled server restart and verification. The exact file path and restart method depend on the Windows installation. This is **not** done in this session.
5. Once client/server configuration is confirmed, test `LOAD DATA LOCAL INFILE` on a controlled table/file and validate row counts and values before bulk-loading remaining tables. Use exact Windows paths with forward slashes or escaped backslashes; verify CSV headers, delimiters, line endings, and date parsing first.
6. If we do not need the bulk-loading feature, leave `local_infile` disabled and continue with the Workbench Import Wizard. The current project has not required a setting change.

**Why we checked it:** to determine whether the SQL-based local bulk-loading option is available before deciding how to import the remaining CSVs. The value `OFF` means that particular capability is disabled; it does not mean ordinary CSV imports are disabled.

## 2026-10-12 — MySQL CSV import continuation: `DimCampaign` and connection choice

### Connection decision: `Local instance MySQL80` vs `Sales_Insights`
- Workbench showed two saved connection profiles: `Local instance MySQL80` (`localhost:3306`) and `Sales_Insights` (`127.0.0.1:3306`). The current import troubleshooting was performed in **Local instance MySQL80** because that was the selected connection where we inspected and changed the `local_infile` setting, reconnected, selected `marketing_funnel_mysql`, and tested the import.
- These are saved Workbench connection profiles, not necessarily two different MySQL servers. `localhost` and `127.0.0.1` commonly resolve to the same computer, but the profiles may have different stored options or settings. Do not assume they are identical without comparing their connection details and testing the database/server identity.
- We did **not** use `Sales_Insights` because it was not the active profile used in the current troubleshooting. We did not establish that `Sales_Insights` is wrong or unusable. Before later Power BI connection work, verify the host, port, server identity, schema, and relevant client options for the intended connection. Avoid changing settings in a profile that is not being used for this import.

### Confirmed actions and observations
1. The schema script created nine tables in database `marketing_funnel_mysql`: `DimCampaign`, `DimDate`, `DimMonth`, `DimCustomer`, `FactLeads`, `FactAdSpend`, `CampaignBudget`, `CRMActivity`, and `LeadStageHistory`. Table/column names were aligned with the source CSVs.
2. `FactLeads.csv` was imported with MySQL Workbench's Table Data Import Wizard into the existing table. Validation returned **30,000 rows**. Do not import it again.
3. On `Local instance MySQL80`, `SHOW GLOBAL VARIABLES LIKE 'local_infile';` initially returned `OFF`. The user then executed `SET GLOBAL local_infile = ON;` and verified that global and session values were `ON` in the selected connection. This was a user-executed change; record it accurately. The server setting alone did not initially resolve the client-side `LOCAL INFILE` restriction.
4. In the `Local instance MySQL80` connection profile, the user added `OPT_LOCAL_INFILE=1` in Advanced → Others, then saved/reconnected. Record this as an attempted connection-option configuration; it has not been independently verified as the correct/accepted Workbench connector option.
5. An initial `LOAD DATA LOCAL INFILE` attempt for `DimCampaign.csv` produced error 2068 (local file request rejected due to restrictions on access). A subsequent attempt using `LINES TERMINATED BY '\r\n'` returned zero rows affected and no warnings; `DimCampaign` still had zero rows at that point.
6. In Notepad++, the status bar for `DimCampaign.csv` showed **Unix (LF)**. The source file was not edited or saved.
7. The user then executed the corrected import statement below, changing the line terminator to `\n`:

   ```sql
   USE marketing_funnel_mysql;

   LOAD DATA LOCAL INFILE
   'C:/Users/Chetan/Downloads/MarTech_PowerBI_Project_Tables/DimCampaign.csv'
   INTO TABLE DimCampaign
   FIELDS TERMINATED BY ','
   OPTIONALLY ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 LINES
   (CampaignID, CampaignName, Channel, Objective);
   ```

8. Validation with `SELECT COUNT(*) AS TotalRows FROM DimCampaign;` returned **10**. `SELECT * FROM DimCampaign LIMIT 5;` showed campaign IDs `C001`–`C005`, including Meta Lead Gen, Google Search, Google Display, CookedIn B2B, and YouTube Awareness. This confirms that the line-ending correction resolved the zero-row import in this case. The CSV was reported by Notepad++ as 12 lines including its header, but the verified database count is 10; trust the query result and do not infer 11 rows from the editor's line count.
9. Next validation query to run:

   ```sql
   SELECT
       COUNT(*) AS TotalRows,
       COUNT(DISTINCT CampaignID) AS UniqueCampaigns,
       COUNT(*) - COUNT(DISTINCT CampaignID) AS DuplicateIDs
   FROM DimCampaign;
   ```

   Expected for a clean 10-row dimension: `10`, `10`, `0`. This uniqueness check has been requested but its result is not yet confirmed.

### Current status / next step
- Confirmed imports: `FactLeads` = 30,000 rows; `DimCampaign` = 10 rows.
- Do not re-import either table unless validation reveals a problem.
- Run the uniqueness check above. Then import the remaining CSVs one at a time into their existing tables, preferably using the successful approach where appropriate, and record the actual count for each table before moving on.
- Keep original CSVs and the original PBIX unchanged. Do not claim all CSVs are imported; only the two tables above are confirmed so far.
- If `LOAD DATA LOCAL INFILE` fails for another file, inspect that file's line ending, header, delimiter, column order, and data types. Use Workbench Import Wizard as a safe fallback instead of making unnecessary security/configuration changes.


## 2026-10-12 — Full chronological troubleshooting record and lessons learned

This section records the exact sequence discussed and observed today. It supplements earlier notes; where older preliminary notes say no setting had been changed, the later actions below supersede them.

### A. Connection selection and why we did not use `Sales_Insights`
1. Workbench had two saved profiles: `Local instance MySQL80` (`localhost`, port `3306`) and `Sales_Insights` (`127.0.0.1`, port `3306`).
2. We continued in `Local instance MySQL80` because it was the active profile for this import troubleshooting, where the `marketing_funnel_mysql` schema and `local_infile` values were being checked. This was not evidence that `Sales_Insights` was wrong. `localhost` and `127.0.0.1` commonly point to the same computer, but saved profiles can have different credentials and client options. Their identity should be compared before assuming they are identical.
3. The user reported trying to turn on the local instance / encountering an error in the Sales Insights context. The exact text of that earlier error is not available in the current record, so do not invent an error message or claim a root cause.
4. To compare profiles later, connect to each and run:

   ```sql
   SELECT @@hostname AS ServerName, @@port AS Port, VERSION() AS MySQLVersion, DATABASE() AS CurrentDatabase;
   ```

   This identifies the server endpoint and selected schema, but does not by itself compare all saved client options.

### B. Checking and changing local-file loading settings
1. In `Local instance MySQL80`, we ran:

   ```sql
   SHOW GLOBAL VARIABLES LIKE 'local_infile';
   ```

   It initially returned `OFF`.
2. The user then ran:

   ```sql
   SET GLOBAL local_infile = ON;
   SHOW GLOBAL VARIABLES LIKE 'local_infile';
   SHOW SESSION VARIABLES LIKE 'local_infile';
   ```

   Both global and session values were subsequently confirmed as `ON` in the selected session. This is a server-side configuration change and may require sufficient privileges; it is not the same as enabling the client.
3. In Workbench, the user went to the Home screen, opened **Manage Connections**, selected the `Local instance MySQL80` profile, and opened **Advanced → Others**. The user added `OPT_LOCAL_INFILE=1`, saved the profile, and reconnected. Record this exactly as an attempted client-option setting; we did not independently verify that this is the correct option syntax for this Workbench/connector version. Do not assume this option alone resolved the restriction.
4. The first `LOAD DATA LOCAL INFILE` attempt returned error **2068**, with a message indicating the local-file request was rejected due to restrictions on access. This demonstrated that turning on the server variable did not initially eliminate the client-side restriction.

### C. First SQL attempt and why it did not load data
The first attempt used the Windows-style CRLF row terminator:

```sql
LOAD DATA LOCAL INFILE
'C:/Users/Chetan/Downloads/MarTech_PowerBI_Project_Tables/DimCampaign.csv'
INTO TABLE marketing_funnel_mysql.DimCampaign
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(CampaignID, CampaignName, Channel, Objective);
```

Workbench then reported zero rows affected, zero deleted, zero skipped, and zero warnings. `SELECT COUNT(*) FROM DimCampaign;` returned `0`; `SHOW WARNINGS;` returned no warnings. Therefore, the import had not loaded records even though Workbench did not report warnings. We did not treat this as success.

### D. How we checked line endings in Notepad++
1. Opened the original `DimCampaign.csv` in Notepad++ from `C:\Users\USER\Downloads\MarTech_PowerBI_Project_Tables\DimCampaign.csv`.
2. Opened **Edit → EOL Conversion** while investigating. This menu shows available conversion actions; the highlighted `Windows (CR LF)` menu item alone did not prove the file's actual line ending. We closed the menu without choosing a conversion.
3. Checked the **status bar at the bottom-right** of Notepad++. It explicitly displayed **`Unix (LF)`** (also showing UTF-8). This was the evidence used to choose the row terminator.
4. The source CSV was not edited, converted, or saved. We changed only the SQL statement.

### E. Corrected import and validation
The user reran the import using LF:

```sql
USE marketing_funnel_mysql;

LOAD DATA LOCAL INFILE
'C:/Users/Chetan/Downloads/MarTech_PowerBI_Project_Tables/DimCampaign.csv'
INTO TABLE DimCampaign
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(CampaignID, CampaignName, Channel, Objective);
```

Validation then showed:

```sql
SELECT COUNT(*) AS TotalRows FROM DimCampaign;
-- Result: 10

SELECT * FROM DimCampaign LIMIT 5;
```

The screenshot showed campaign IDs `C001` through `C005`, with columns `CampaignID`, `CampaignName`, `Channel`, and `Objective`. This verifies that the corrected statement loaded 10 rows. Although the editor status showed 12 lines, the validated database count is 10; do not infer a different expected count from the line count alone.

Next, run the uniqueness check (not yet confirmed at the time of this note):

```sql
SELECT
    COUNT(*) AS TotalRows,
    COUNT(DISTINCT CampaignID) AS UniqueCampaigns,
    COUNT(*) - COUNT(DISTINCT CampaignID) AS DuplicateIDs
FROM DimCampaign;
```

### F. What this troubleshooting taught us
- Server-side `local_infile` and client-side permission to load local files are separate concerns.
- A zero-row / zero-warning result is not proof of a successful import; validate the destination table with a count and sample rows.
- Inspect actual line endings using the Notepad++ status bar rather than choosing an EOL conversion or assuming Windows line endings.
- Change the SQL row terminator to match the file, not the original CSV file.
- Workbench connection profiles and database schemas are different concepts. Use the intended profile and explicitly select `marketing_funnel_mysql`.
- Do not reload `FactLeads` (30,000 verified rows) or `DimCampaign` (10 verified rows) without a reason. Import the remaining tables one at a time and validate each.
- The next action is to run the `DimCampaign` uniqueness check, then proceed to the next CSV and record the actual count.

## 2026-10-12 — Importing DimCustomer with LOAD DATA LOCAL INFILE

### Goal
Continue loading the CSV tables into the existing `marketing_funnel_mysql` schema. Because bulk loading is useful for larger files and we are deliberately practising SQL-based imports, use `LOAD DATA LOCAL INFILE` rather than the graphical Table Data Import Wizard for this table.

### Pre-import check
- Connection used: **Local instance MySQL80** in MySQL Workbench.
- Selected database explicitly with `USE marketing_funnel_mysql;`.
- Checked `DimCustomer` before importing; `SELECT COUNT(*) AS ExistingRows FROM DimCustomer;` returned **0**.
- The source file is `C:/Users/Chetan/Downloads/MarTech_PowerBI_Project_Tables/DimCustomer.csv`.

### Import statement executed successfully
```sql
USE marketing_funnel_mysql;

LOAD DATA LOCAL INFILE
'C:/Users/Chetan/Downloads/MarTech_PowerBI_Project_Tables/DimCustomer.csv'
INTO TABLE DimCustomer
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
```

### Result
- User confirmed the import worked and **100 customer rows** were imported.
- This reused the LF line-ending setting that had worked for `DimCampaign`. Do not assume every CSV has the same line endings without checking if a future import fails.
- This statement relies on the CSV column order matching the table's column order. Before using the same pattern on another table, inspect the header and target schema; specify a target-column list when necessary.

### Validation still recommended
Run:
```sql
SELECT COUNT(*) AS TotalRows FROM DimCustomer;
SELECT * FROM DimCustomer LIMIT 5;
```
Confirm the count is 100 and inspect sample values. Then consider checking the relevant customer key for duplicates/nulls based on the actual schema.

### Learning / decision
- `LOAD DATA LOCAL INFILE` is our chosen practice method for this import because it efficiently loads rows from a local CSV.
- The Table Data Import Wizard remains a useful GUI alternative, especially for initial mapping or when troubleshooting.
- A successful command should still be followed by row-count and sample-row validation. Do not claim the data is fully validated until those queries have been run.


---

## 2026-10-12 — DimDate bulk import and date-format troubleshooting

### Starting state and schema inspection
- Checked `DimDate` in `marketing_funnel_mysql`; it initially contained 0 rows.
- Inspected `DimDate.csv` in Notepad++ and identified seven fields in this order: `Date`, `Year`, `MonthNo`, `Month`, `Quarter`, `YearMonth`, `DayName`.
- Ran `DESCRIBE DimDate`. The target table has `Date` as `DATE` and primary key; remaining columns are `Year SMALLINT`, `MonthNo TINYINT`, `Month VARCHAR(15)`, `Quarter VARCHAR(2)`, `YearMonth CHAR(7)`, and `DayName VARCHAR(10)`.
- The visible CSV sample showed comma-separated fields and date values in `YYYY-MM-DD` form (for example, `2025-02-08`).

### Failed first attempt and diagnosis
- First attempted to import using `STR_TO_DATE(@DateValue, '%d-%m-%Y')`, based on an incorrect assumption that source dates were `DD-MM-YYYY`.
- The query did not load the intended date correctly: inspection showed a row with `Date = '0000-00-00'` while the other fields contained values from the CSV.
- This was a data-format mismatch, not evidence that the delimiter was wrong. The visible CSV line confirmed comma-separated fields and ISO-style `YYYY-MM-DD` dates.
- The incorrect row was to be cleared before retrying; ensure the table is empty before rerunning the corrected import to avoid duplicates.

### Corrected import
With `marketing_funnel_mysql` selected, the corrected query loads the date directly because the CSV date is already in MySQL-compatible `YYYY-MM-DD` format:

```sql
USE marketing_funnel_mysql;

LOAD DATA LOCAL INFILE
'C:/Users/Chetan/Downloads/MarTech_PowerBI_Project_Tables/DimDate.csv'
INTO TABLE DimDate
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\\n'
IGNORE 1 LINES
(Date, Year, MonthNo, Month, Quarter, YearMonth, DayName);
```

- User subsequently confirmed: **“now its worked.”**
- This successful approach no longer uses `STR_TO_DATE()` because conversion is unnecessary for the source format.
- The source file was inspected only; it was not intentionally edited or saved.

### Post-import validation to record
Run and record the actual results of:

```sql
SELECT COUNT(*) AS TotalRows, MIN(Date) AS FirstDate, MAX(Date) AS LastDate
FROM DimDate;

SELECT * FROM DimDate ORDER BY Date LIMIT 5;
```

- If the CSV has every calendar day from `2025-01-01` through `2026-09-15`, the expected count is 623. Treat this as an expectation, not a confirmed count until the query output is checked.
- Confirm the first and last dates and check that no `0000-00-00` dates remain.
- Avoid claiming the exact row count or date range was validated until the user shares the query output.

### Learning and root cause
1. Inspect the actual source values before choosing a date mask. `%d-%m-%Y` is for day-month-year text; it does not match `YYYY-MM-DD`.
2. `STR_TO_DATE()` is useful when text needs conversion; if the CSV date already matches MySQL's `DATE` input format, direct loading is simpler.
3. A command completing is not enough. Check row count, minimum/maximum dates, and sample records after every bulk import.
4. A `0000-00-00` result is a warning sign that date conversion or SQL mode needs investigation; do not proceed to later tables until it is corrected.


## 2026-10-12 — DimDate validation confirmed

The user shared the actual validation output:

```text
TotalRows  FirstDate   LastDate
623        2025-01-01  2026-09-15
```

Confirmed:
- `DimDate` contains 623 rows.
- Earliest date is `2025-01-01`.
- Latest date is `2026-09-15`.
- This matches the expected continuous calendar range for the source period.
- The corrected import loads the source date directly because the CSV date values are already in `YYYY-MM-DD` format. The earlier `%d-%m-%Y` parsing assumption caused the incorrect `0000-00-00` value and was abandoned.
- Validation status: row count and date range confirmed from user-provided query output.

Current confirmed imported table counts:
- `FactLeads`: 30,000 rows (previously confirmed).
- `DimCampaign`: 10 rows.
- `DimCustomer`: 100 rows (user reported import success; user confirmed validation was done).
- `DimDate`: 623 rows; date range confirmed above.

Next table proposed: `DimMonth`. Before importing, check its existing row count, inspect its CSV header and data format, compare the target table schema, then import with `LOAD DATA LOCAL INFILE` if appropriate. Validate row count and sample rows, and preserve original CSVs and the original PBIX.

## 2026-10-14 — DimMonth bulk import troubleshooting and validation

### Pre-import check and source/table inspection
- Continued in MySQL Workbench using the `Local instance MySQL80` connection and database `marketing_funnel_mysql`.
- Confirmed `DimMonth` initially contained 0 rows.
- Inspected `DimMonth.csv` in Excel. It showed five fields: `Start of Month`, `Year`, `MonthNo`, `Month`, and `YearMonth`, with monthly records from January 2025 through September 2026 (21 expected rows). The displayed date looked like `01-01-2025`, but display formatting alone did not prove the literal text stored in the CSV.
- Ran `DESCRIBE DimMonth`. The existing table has `Start of Month` as `DATE NOT NULL PRIMARY KEY`, `Year` as `SMALLINT`, `MonthNo` as `TINYINT`, `Month` as `VARCHAR(15)`, and `YearMonth` as `CHAR(7)`.

### Failed attempts and root-cause learning
- First `LOAD DATA LOCAL INFILE` attempt used `STR_TO_DATE(@StartMonth, '%d-%m-%Y')`. Workbench reported 63 warnings, including an incorrect datetime value such as `2025-01-01`, and a row appeared with `Start of Month = '0000-00-00'`.
- A format-string change did not resolve the issue; the error showed that the incoming value was `2025-01-01`, which is already in MySQL-compatible `YYYY-MM-DD` format. The Excel display was not sufficient evidence to infer the underlying CSV text format.
- We stopped guessing at date masks. The incorrect data was cleared before the successful reload (the table had been empty before this exercise).

### Successful import
Used direct date loading without `STR_TO_DATE()`:

```sql
USE marketing_funnel_mysql;

LOAD DATA LOCAL INFILE
'C:/Users/Chetan/Downloads/MarTech_PowerBI_Project_Tables/DimMonth.csv'
INTO TABLE DimMonth
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(`Start of Month`, Year, MonthNo, Month, YearMonth);
```

### Validation result (confirmed by user)
Ran:

```sql
SELECT
    COUNT(*) AS TotalRows,
    MIN(`Start of Month`) AS FirstMonth,
    MAX(`Start of Month`) AS LastMonth
FROM DimMonth;
```

Output:

```text
TotalRows  FirstMonth  LastMonth
21         2025-01-01  2026-09-01
```

Status: `DimMonth` import validated for row count and date range. The import used `LOAD DATA LOCAL INFILE`, skipped the header, matched the five target columns in order, and loaded the date directly. Original CSV and PBIX were not intentionally modified.

### Updated confirmed table counts
- `FactLeads`: 30,000 rows.
- `DimCampaign`: 10 rows.
- `DimCustomer`: 100 rows.
- `DimDate`: 623 rows, `2025-01-01` through `2026-09-15`.
- `DimMonth`: 21 rows, `2025-01-01` through `2026-09-01`.

### Next step
Proceed to the next unconfirmed table, likely `FactAdSpend`: check its existing row count, inspect its CSV header and target schema, import using `LOAD DATA LOCAL INFILE` if field mapping and formats are clear, then validate row count and sample records. Keep documenting the exact command, errors, fixes, and observed results.


## New Section — 14 October 2026: FactAdSpend bulk import and validation

### Pre-import checks
- Continued in MySQL Workbench using the `Local instance MySQL80` connection and database `marketing_funnel_mysql`.
- Confirmed `FactAdSpend` was empty before import (`COUNT(*) = 0`).
- Inspected the CSV and the existing table schema before loading.
- CSV path: `C:/Users/Chetan/Downloads/MarTech_PowerBI_Project_Tables/FactAdSpend.csv`.
- CSV header: `Date,CampaignID,AdSpend,Impressions,Clicks,PlatformConversions`.
- Actual date text in Notepad++ is ISO-style `YYYY-MM-DD` (example `2025-01-01`); delimiter is comma.
- Existing schema: `Date DATE`, `CampaignID VARCHAR(10)`, `AdSpend DECIMAL(12,2)`, `Impressions INT`, `Clicks INT`, `PlatformConversions INT`. The primary key is the composite of `Date` and `CampaignID`.

### Import SQL used
```sql
USE marketing_funnel_mysql;

LOAD DATA LOCAL INFILE
'C:/Users/Chetan/Downloads/MarTech_PowerBI_Project_Tables/FactAdSpend.csv'
INTO TABLE FactAdSpend
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\\n'
IGNORE 1 LINES
(Date, CampaignID, AdSpend, Impressions, Clicks, PlatformConversions);
```
- Loaded `Date` directly because the CSV text already uses `YYYY-MM-DD`; no `STR_TO_DATE()` conversion was needed.
- `IGNORE 1 LINES` skips the header. `LINES TERMINATED BY '\\n'` matches the previously used Unix LF line endings.

### Validation result reported by user
```text
TotalRows: 6230
FirstDate: 2025-01-01
LastDate: 2026-09-15
```
- The row count and date range were returned by the aggregate validation query and match the expected reporting period.
- Recommended additional quality check: verify no duplicate `(Date, CampaignID)` keys and inspect a small sample of imported rows.

### Learning / interview takeaway
- Inspect both the CSV text and the database schema before bulk loading.
- Match the SQL field delimiter and line terminator to the file.
- Avoid date conversion when the CSV date text is already compatible with MySQL `DATE`.
- Validate imported data using `COUNT(*)`, `MIN(Date)`, and `MAX(Date)`; also verify the composite key for duplicates.

## 2026-10-14 — CampaignBudget bulk import and validation

### Pre-import checks
- Target connection: MySQL Workbench `Local instance MySQL80`.
- Database: `marketing_funnel_mysql`.
- Checked that `CampaignBudget` was the next table to load.
- Inspected `CampaignBudget.csv` in Notepad++ and confirmed comma-separated values and the header `BudgetID,CampaignID,MonthStart,BudgetAmount`.
- Actual CSV date text is ISO-style `YYYY-MM-DD` (example `2025-01-01`), even though Excel displayed the date as `01-01-2025`.
- `DESCRIBE CampaignBudget` showed `BudgetID VARCHAR(15)` as the primary key, `CampaignID VARCHAR(10)`, `MonthStart DATE`, and `BudgetAmount DECIMAL(12,2)`.

### Import SQL executed
```sql
USE marketing_funnel_mysql;

LOAD DATA LOCAL INFILE
'C:/Users/Chetan/Downloads/MarTech_PowerBI_Project_Tables/CampaignBudget.csv'
INTO TABLE CampaignBudget
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(BudgetID, CampaignID, MonthStart, BudgetAmount);
```

### Validation query and observed result
```sql
SELECT
    COUNT(*) AS TotalRows,
    MIN(MonthStart) AS FirstMonth,
    MAX(MonthStart) AS LastMonth,
    COUNT(DISTINCT BudgetID) AS UniqueBudgetIDs
FROM CampaignBudget;
```
Observed output: `TotalRows = 210`, `FirstMonth = 2025-01-01`, `LastMonth = 2026-09-01`, `UniqueBudgetIDs = 210`.

### Learning and status
- Import succeeded with 210 rows and all 210 `BudgetID` values unique.
- The CSV's stored date format must be checked in a text editor rather than inferred from Excel's display formatting.
- Because the CSV date text was already `YYYY-MM-DD`, the date column was loaded directly; no `STR_TO_DATE()` conversion was required.
- `CampaignBudget` is now imported and validated by row count, date range, and unique budget IDs. Sample-row inspection was requested separately and is not yet confirmed in this entry.

## 2026-10-14 — CRMActivity bulk import and validation

### Pre-import checks
- Confirmed `CRMActivity` had 0 rows before importing.
- Reviewed the existing table schema with `DESCRIBE CRMActivity`:
  - `ActivityID` `VARCHAR(10)`, NOT NULL, primary key
  - `LeadID` `VARCHAR(10)`
  - `ActivityDate` `DATE`
  - `ActivityType` `VARCHAR(30)`
  - `Outcome` `VARCHAR(30)`
- Inspected `CRMActivity.csv`. Header: `ActivityID,LeadID,ActivityDate,ActivityType,Outcome`. Example rows showed dates in ISO `YYYY-MM-DD` format, e.g. `2025-07-16`; comma-delimited.

### Import query used
```sql
USE marketing_funnel_mysql;

LOAD DATA LOCAL INFILE
'C:/Users/Chetan/Downloads/MarTech_PowerBI_Project_Tables/CRMActivity.csv'
INTO TABLE CRMActivity
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(ActivityID, LeadID, ActivityDate, ActivityType, Outcome);
```
- Used `Local instance MySQL80` and the existing table.
- Loaded `ActivityDate` directly because CSV values were already `YYYY-MM-DD`; no `STR_TO_DATE()` was needed.

### Validation result
```sql
SELECT
    COUNT(*) AS TotalRows,
    COUNT(DISTINCT ActivityID) AS UniqueActivityIDs,
    MIN(ActivityDate) AS FirstDate,
    MAX(ActivityDate) AS LastDate
FROM CRMActivity;
```
Observed output:
- `TotalRows`: 36,057
- `UniqueActivityIDs`: 36,057
- `FirstDate`: `2025-01-01`
- `LastDate`: `2026-09-15`
- Difference between total rows and unique ActivityIDs: 0, so no duplicate ActivityID values were detected.

### Learning / interview takeaway
Inspect the actual CSV text and compare it with the database schema before bulk loading. Displayed date formatting in spreadsheet software can differ from the CSV's stored text. When the CSV contains ISO `YYYY-MM-DD` values and the destination is a MySQL `DATE`, direct loading avoids unnecessary date parsing. Validate imports using row counts, distinct primary-key counts, and date ranges.

### Next step
Check `LeadStageHistory` row count before importing. Inspect its CSV header/sample rows and table schema; then load and validate it. Preserve the original CSV files and PBIX.

## 2026-10-14 — LeadStageHistory import and nine-table database validation

### Import completed
Used MySQL Workbench connection `Local instance MySQL80` and database `marketing_funnel_mysql`. The existing `LeadStageHistory` table schema was confirmed as:
- `StageHistoryID` — `VARCHAR(12)`, primary key
- `LeadID` — `VARCHAR(10)`
- `Stage` — `VARCHAR(30)`
- `StageDate` — `DATE`
- `StageOrder` — `TINYINT`

Inspected `LeadStageHistory.csv` in Notepad++ and confirmed comma-separated data with date values already in ISO `YYYY-MM-DD` format. Imported using `LOAD DATA LOCAL INFILE`, `FIELDS TERMINATED BY ','`, `OPTIONALLY ENCLOSED BY '"'`, `LINES TERMINATED BY '\\n'`, `IGNORE 1 LINES`, and explicit column mapping `(StageHistoryID, LeadID, Stage, StageDate, StageOrder)`. No date conversion was required.

### Validation query and result
Ran a validation query with `COUNT(*)`, `COUNT(DISTINCT StageHistoryID)`, `MIN(StageDate)`, and `MAX(StageDate)`.
- Total rows: 46,883
- Unique `StageHistoryID` values: 46,883
- First date: `2025-01-01`
- Last date: `2026-09-15`
- Duplicate IDs detected by count comparison: 0

### Final nine-table count check
Ran a `UNION ALL` query to check all nine tables. The screenshot/result confirmed:
| Table | Rows |
|---|---:|
| `FactLeads` | 30,000 |
| `DimCampaign` | 10 |
| `DimCustomer` | 100 |
| `DimDate` | 623 |
| `DimMonth` | 21 |
| `FactAdSpend` | 6,230 |
| `CampaignBudget` | 210 |
| `CRMActivity` | 36,057 |
| `LeadStageHistory` | 46,883 |

**Historical source claim (not accepted as a verified aggregate):** the source note stated 83,754 rows total. However, the nine individual counts listed immediately above add up to 120,134, so that stated total is arithmetically inconsistent with its own table. The source note does not provide enough evidence to determine whether the aggregate was miscalculated, copied from another snapshot, or otherwise recorded incorrectly. Rerun the current row-count reconciliation query before reporting a live total.

### Learning / next step
The database import phase is complete. Before Power BI migration, verify table relationships and key quality as needed, then connect a copy of the existing PBIX to this MySQL database. Keep the original PBIX and CSV source files unchanged. Continue to document connection settings, data refresh behavior, and any model adjustments before considering the migration complete.


## 2026-10-14 — Power Query M-code inventory and existing RLS review (before MySQL connection)

### Scope and safety decision
The user opened the **copied PBIX** for a planned CSV-to-MySQL migration. The original PBIX and source CSV files must remain untouched. At this stage, Power BI has **not yet been connected to MySQL** and no M code, Applied Steps, query load settings, model relationships, or RLS roles have been modified. Work performed in this session was inspection only.

The intended sequence is to finish the M-code/dependency/security review first, then connect to `localhost:3306`, database `marketing_funnel_mysql`, and migrate one query at a time while preserving existing transformations. The user prefers careful, step-by-step instructions and parallel updates to this log and the interview Q&A.

### Queries reviewed (10 shown in the Power Query Queries pane)

1. **`FactLeads`** — CSV source `C:\Users\USER\Downloads\MarTech_PowerBI_Project_Tables\FactLeads.csv`; `Csv.Document` specifies comma delimiter, 8 columns, and `QuoteStyle.None`. Promotes headers; assigns `LeadID`, `CampaignID`, `Source`, `City`, `Program`, `LeadStatus` as text, `LeadDate` as date, and `Revenue` as `Int64.Type` with `en-US` culture. Adds `RevenueStatus` (`Revenue > 0` => `Revenue Generated`, otherwise `No Revenue`), sets it to text, adds `Month Name` using `Date.MonthName([LeadDate])`, left-outer merges to `DimCampaign` on `CampaignID`, then expands `CampaignName`, `Channel`, and `Objective` with output names `DimCampaign.CampaignName`, `DimCampaign.Channel`, `DimCampaign.Objective`. The merge and derived columns must be preserved during migration. The query's final output has the original 8 columns plus `RevenueStatus`, `Month Name`, and 3 expanded campaign columns (13 columns total).

2. **`DimCampaign`** — CSV source `DimCampaign.csv`, comma delimiter, 4 columns, `QuoteStyle.None`. Promotes headers and types `CampaignID`, `CampaignName`, `Channel`, `Objective` as text. Adds `Extra` using `if [CampaignID] = 0 then "yes" else "no"`. Potential issue to validate, not change during source migration: `CampaignID` is text at the time of comparison, while `0` is numeric; confirm intended logic and actual output before changing it. This table is a dependency of the `FactLeads` merge.

3. **`DimCustomer`** — CSV source `DimCustomer.csv`, 5 columns; promotes headers and sets `CustomerID`, `CustomerType`, `AgeBand`, `CustomerCity`, `CustomerStatus` as text. No additional transformations.

4. **`DimDate`** — CSV source `DimDate.csv`, 7 columns; promotes headers and assigns `Date` as date, `Year` and `MonthNo` as `Int64.Type`, `Month`/`Quarter`/`DayName` as text, and `YearMonth` as date using `en-US` culture. Adds `Start of Month` with `Date.StartOfMonth([Date])`; renames original `YearMonth` to `Start of the Month`. This means the output has two differently named month-start columns: `Start of Month` and `Start of the Month`. Preserve exact names until relationships, measures, and dependencies are verified.

5. **`DimMonth`** — not an independent CSV source; starts with `Source = DimDate`. Removes `MonthNo`, `Year`, and `Month`; selects only `Start of Month`; removes duplicates with `Table.Distinct`. It is a dependent/reference query and should continue referencing the migrated `DimDate` output unless later evidence requires a different design. Expected result from previous MySQL checks: 21 distinct month-start rows (January 2025 through September 2026).

6. **`FactAdSpend`** — CSV source `FactAdSpend.csv`, 6 columns; promotes headers and sets `Date` as date, `CampaignID` as text, and `AdSpend`, `Impressions`, `Clicks`, `PlatformConversions` as `Int64.Type`. Previous MySQL validation recorded 6,230 rows and date range `2025-01-01` through `2026-09-15`.

7. **`CampaignBudget`** — CSV source `CampaignBudget.csv`, 4 columns; promotes headers and sets `BudgetID`, `CampaignID` as text, `MonthStart` as date, and `BudgetAmount` as `Int64.Type`. Previous MySQL validation recorded 210 rows, 210 distinct `BudgetID` values, and `MonthStart` range `2025-01-01` through `2026-09-01`.

8. **`CRMActivity`** — CSV source `CRMActivity.csv`, 5 columns; promotes headers and sets `ActivityID`, `LeadID`, `ActivityType`, `Outcome` as text and `ActivityDate` as date. Previous MySQL validation recorded 36,057 rows, 36,057 distinct `ActivityID` values, and dates `2025-01-01` through `2026-09-15`.

9. **`LeadStageHistory`** — CSV source `LeadStageHistory.csv`, 5 columns with UTF-8 encoding (`65001`); promotes headers and sets `StageHistoryID`, `LeadID`, `Stage` as text, `StageDate` as date, and `StageOrder` as `Int64.Type`. Previous MySQL validation recorded 46,883 rows, 46,883 distinct `StageHistoryID` values, and dates `2025-01-01` through `2026-09-15`.

10. **`UserCityAccess`** — embedded table built by `Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText(...), Compression.Deflate)), ...)`; not a CSV or database source. Promotes headers, then replaces `marketing.head@example.com` with `all-cities.test.user@example.com` and `bangalore.manager@example.com` with `bangalore.test.user@example.com` in `UserEmail`. The visible output has columns `UserEmail` and `City` and four rows; visible values include `bangalore.test.user@example.com` / `Bangalore` and `all-cities.test.user@example.com` / `ALL`, while Mumbai and Delhi manager email values were truncated in the screenshot. Right-click menu confirmed both **Enable load** and **Include in report refresh** are checked. Keep this embedded table and replacements intact unless security review establishes a reason to change them.

### RLS inspection
Power BI's **View as roles** window showed two existing roles: `RLS_Bangalore` and `RLS_Dynamic` (the `None` option is the default view, not a role). In **Manage security roles**:

- `RLS_Bangalore`: a basic filter on `FactLeads[City]` where `City` equals `Bangalore`.
- `RLS_Dynamic`: the DAX expression shown in the role editor was:

```dax
VAR CurrentUser = USERPRINCIPALNAME()
VAR AllowedCity = LOOKUPVALUE(UserCityAccess[City], UserCityAccess[UserEmail], CurrentUser)
RETURN
    NOT ISBLANK(AllowedCity) && (AllowedCity = "ALL" || FactLeads[City] = AllowedCity)
```

Interpretation: get the current principal name; look up the matching city in `UserCityAccess`; allow the row only when a city was found and either that city is `ALL` or the current `FactLeads[City]` matches it. The email stored in `UserCityAccess[UserEmail]` must match the identity returned by `USERPRINCIPALNAME()` for the lookup to work. Do not alter either role during migration; test after switching sources.

### Additional discrepancy to investigate later
The Power Query pane screenshot showed **10 queries**, listed above. The Manage security roles Tables list also showed a `FunnelStages` model table, which was not among those 10 visible query names. This is not yet explained; later inspect the model/table origin (for example, a calculated table or hidden/other model artifact) rather than assuming it is a CSV-backed Power Query query. The visible security editor selected `FactLeads` for both role expressions.

### Migration plan recorded (not yet executed)
1. Close role editor without saving changes.
2. Connect Power BI to the existing MySQL database `marketing_funnel_mysql` at `localhost:3306` from the copied PBIX only.
3. Start with `DimCampaign`, then migrate `FactLeads` so the merge dependency can be validated; preserve the existing transformations.
4. Migrate the remaining CSV-backed queries, validating schema, data types, row counts, key uniqueness, and date ranges. `DimMonth` should remain a reference to `DimDate`; `UserCityAccess` should remain embedded.
5. Validate relationships, report visuals/measures, refresh behavior, and both RLS roles. Do not consider migration complete until RLS is tested and the `FunnelStages` discrepancy is understood.

No MySQL connection was established in this session, and no query source was changed.


---

# 2026-10-15 to 2026-10-16 — MySQL source migration, gateway registration, connection troubleshooting, and successful Service refresh

## 1. Scope, safety boundaries, and current objective

The task continued from the previously documented M-code and RLS review. The objective was to get the copied MySQL-based report refreshing in Power BI Service while preserving the original CSV-based report, original PBIX, and source CSV files. The project database is `marketing_funnel_mysql`; the MySQL server is local to the user's laptop.

**Safety decisions maintained:**
- Original PBIX and CSV files were not overwritten or deleted.
- The MySQL-migration PBIX/report was published under a distinct name: `Marketing_Funnel_Campaign_Intelligence_using_MySQL_database`.
- The existing CSV report and its Personal-mode file connections were left untouched.
- No MySQL password or gateway recovery key is recorded in this log.
- The prior Cloud connection was not deleted; troubleshooting was performed by creating a separate on-premises connection and mapping the MySQL semantic model to it.

## 2. MySQL database readiness confirmed

> **Historical-count qualification:** the per-table values below were recorded in the source log, but the stated aggregate of 83,754 is inconsistent with their sum. This table preserves the historical notes; it is not a verified current database snapshot.

The MySQL environment was confirmed as MySQL 8.0.25 on host `<LOCAL_GATEWAY_HOST>`, port `3306`, with database `marketing_funnel_mysql`. The MySQL Workbench connection label used was `Local instance MySQL80`. Other saved Workbench connection labels (`Sales_Insights` and `SQL interview Quest`) were observed, but connection labels alone do not prove separate server instances. The project connection continued to target `marketing_funnel_mysql`, not a database named Sales Insights.

The nine project tables and historically recorded per-table counts were (the aggregate is unresolved; see the row-count reconciliation note above):

| Table | Rows |
|---|---:|
| `FactLeads` | 30,000 |
| `DimCampaign` | 10 |
| `DimCustomer` | 100 |
| `DimDate` | 623 |
| `DimMonth` | 21 |
| `FactAdSpend` | 6,230 |
| `CampaignBudget` | 210 |
| `CRMActivity` | 36,057 |
| `LeadStageHistory` | 46,883 |
| **Historical stated total (inconsistent)** | **83,754 — not verified** |

A later local test in Workbench successfully ran `USE marketing_funnel_mysql` and counted rows from `factleads`, returning **30,000**. The Windows service `MySQL80` was also checked in `services.msc` and was running. These checks show that the database was accessible locally; they do not, by themselves, prove Power BI Service could reach it.

## 3. Power BI Desktop migration state and data/model preservation

A copied PBIX was used for the migration. The original PBIX and CSV files remained preserved. In the copied PBIX, the CSV-backed Power Query queries were redirected to MySQL navigation while keeping the existing transformation logic. `UserCityAccess` remained an embedded table; `DimMonth` continued to reference `DimDate`. The reviewed query set included `FactLeads`, `DimCampaign`, `DimCustomer`, `DimDate`, `DimMonth`, `FactAdSpend`, `CampaignBudget`, `CRMActivity`, `LeadStageHistory`, and `UserCityAccess`. `FunnelStages` was visible as a model artifact in role/model context but not as a query in the Power Query pane; its origin was not silently assumed.

Preserved transformations included the `FactLeads` type conversions, `RevenueStatus`, `Month Name`, left outer merge to `DimCampaign` on `CampaignID`, and expanded campaign fields. The potential `DimCampaign[CampaignID]` text-versus-number comparison in the `Extra` custom column was not changed as part of migration. `DimDate`'s two similarly named month-start columns were preserved pending dependency review. No deliberate relationship or RLS redesign was performed as part of source switching.

After refresh in Desktop, the report continued to show the migrated model's main metrics: 30,000 leads, 9,561 qualified, 5,268 demos, 2,054 enrolled, 6.85% conversion, approximately ₹5M ad spend, ₹48M revenue, and ROAS 10.17. These values were observed in Desktop and were not independently recalculated during the Service gateway troubleshooting.

### Existing RLS checks retained as prior validation
- `RLS_Dynamic` was tested for `bangalore.test.user@example.com`; the report showed Bangalore-restricted data, and a temporary city table visual showed Bangalore only. The observed cards were 3,751 leads, 1,182 qualified, 653 demos, 253 enrolled, 6.74% conversion, approximately ₹5M spend, ₹6M revenue, and ROAS 1.20.
- `all-cities.test.user@example.com` mapped to `ALL`; the temporary table showed eight city values: Bangalore, Chennai, Delhi, Gurgaon, Hyderabad, Kolkata, Mumbai, and Pune.
- The temporary table was removed/undone and View as was stopped. Mumbai and Delhi test identities were not yet tested.
- City slicer choices included extra cities under a role test, but the table visual showed the underlying FactLeads rows were restricted. The slicer options alone were not treated as proof of RLS failure.

## 4. Initial Power BI Service issue: refresh and missing credentials

The MySQL-based semantic model was published separately as `Marketing_Funnel_Campaign_Intelligence_using_MySQL_database`. The report opened and filters responded, but this was not accepted as proof of a successful source refresh. In semantic-model settings, Service initially showed no configured gateway/cloud connection suitable for the local MySQL source, and the refresh page showed a failed refresh at `10/15/2026, 8:52:34 AM`. The details stated that scheduled refresh was disabled because at least one data source was missing credentials.

The initial data source configuration showed server `localhost:3306`, database `marketing_funnel_mysql`, Basic authentication selected, but the username, password, and privacy level were blank. This was an incomplete credential configuration.

## 5. Gateway installer failure and safe resolution

The standard on-premises data gateway installer initially failed even though the user chose `D:\\Software installed` as the installation folder. The installer log contained:

```text
Error 0x80070070: Failed to set end of file.
Failed to extract all files from container.
Failed while caching, aborting execution.
```

At the time, Windows showed only **30.3 MB free of 231 GB on C:**, while D: had **111 GB free of 244 GB**. The log showed installer temporary and cache writes under paths on C:, including `%localappdata%\\Temp` and `C:\\ProgramData\\Package Cache`. Thus, choosing D: did not remove the C: temporary/cache-space requirement. The system restore point warning `0x8004231f` appeared too, but the explicit terminal install failure was `0x80070070` (insufficient disk space).

The user cleaned contents of `%temp%` using Windows + R, skipping files that were in use. After cleanup, the gateway installation and registration proceeded successfully. No project data, PBIX, CSV, or MySQL data folder was intentionally deleted.

## 6. Gateway registration

The gateway was installed successfully and registered as:
- **Gateway name:** `MySQL_OnPrem_Gateway`
- **Gateway mode:** standard on-premises data gateway
- **Region displayed:** Central India
- **Machine:** `<LOCAL_GATEWAY_HOST>`
- **Gateway version shown:** `3000.334.9` (September 2026)
- **Desktop status:** “The gateway MySQL_OnPrem_Gateway is online and ready to be used.”

Registration used a non-primary account represented here as `bangalore.test.user@example.com`, which had access to the Power BI Service workspace at the time. Before relying on this setup long term, confirm the account owner/organization explicitly authorizes continued workspace access and gateway administration, and preferably move administration to an account controlled by the project owner or organization. The recovery key was created during registration and must remain private and stored safely; it is not included in the documentation.

## 7. Why the original Cloud connection failed (what is known and what is not)

The initial MySQL connection appeared under **Cloud** with connection name `localhost:3306;marketing_funnel_mysql`. Its settings had no authentication method, username, password, or privacy level filled in. After Basic authentication was selected and a MySQL username/password were entered, Service displayed: “Unable to update connection credentials. Unable to connect to the data source. Either the data source is inaccessible, a connection timeout occurred, or the data source credentials are invalid.” The same generic failure remained after changing the encrypted connection option from `Encrypted` to `Not encrypted`.

**Evidence-based interpretation:** the Cloud connection's use of `localhost:3306` is not an appropriate route for Power BI Service to reach a MySQL server on the user's laptop. In a cloud-side connection, `localhost` does not mean the user's laptop. In addition, credentials/settings had initially been missing. However, the generic error did not isolate a single definitive root cause, and we did not conclusively prove whether the old connection also had a password, TLS, driver, or other validation issue. We therefore kept it and tested the correct on-premises route separately rather than claiming a precise root cause for the original Cloud failure.

## 8. New on-premises MySQL connection created

In **Manage Connections and Gateways → Connections → New**, the user selected **On-premises**, chose gateway cluster `MySQL_OnPrem_Gateway`, and selected connection type `MySQL`. The new connection was named `Marketing_Funnel_MySQL_Connection`. The entered connection details were:
- Server: `localhost:3306`
- Database: `marketing_funnel_mysql`
- Authentication: Basic
- Username: `root` (the password is intentionally not recorded)
- Encrypted connection: `Encrypted`
- Privacy level: `Organizational`
- Skip test connection: left unchecked (the user did not select it)

The UI showed **“Created Marketing_Funnel_MySQL_Connection.”** In Manage Connections and Gateways, the row showed connection type `MySQL`, the gateway cluster `MySQL_OnPrem_Gateway`, and a green check indicator. This confirmed that the connection object was created under the intended gateway. A created connection object alone is not proof of a semantic-model refresh; the refresh test below provided that evidence.

## 9. Semantic-model gateway mapping and successful refresh

The semantic-model settings initially showed the gateway toggle Off and a blank **Maps to** field under Gateway connections. The same MySQL source was also displayed under Cloud connections. The user turned **Use an On-premises or VNet data gateway** On, selected the gateway row showing **Running on <LOCAL_GATEWAY_HOST>**, and mapped the source `MySql{\"server\":\"localhost:3306\",\"database\":\"marketing_funnel_mysql\"}` to `Marketing_Funnel_MySQL_Connection`. The user clicked **Apply** and Service confirmed: “gateway connection updated.”

The user then ran **Refresh now** for `Marketing_Funnel_Campaign_Intelligence_using_MySQL_database`. Refresh history showed:
- Type: `On demand`
- Start: `10/16/2026, 9:20:03 AM`
- End: `10/16/2026, 9:20:35 AM`
- Status: **Completed**
- Duration: 32 seconds

**Verified outcome:** the MySQL-based semantic model successfully completed a manual refresh through the mapped on-premises gateway route. This is the strongest end-to-end validation achieved so far. It proves that the refresh path worked at that time; it does not automatically prove scheduled refresh has been enabled, that all visual measures are semantically correct, or that the gateway will remain available while the laptop is off.

## 10. Cloud vs. on-premises: project-specific explanation

- **Cloud connection:** a connection object configured as a cloud source route. It is suitable when Power BI Service can reach the data source through the cloud connection mechanism. The user's `localhost:3306` MySQL instance is local to the laptop, so the cloud route was the wrong fit for this source.
- **On-premises connection:** a connection object attached to a registered gateway cluster. Power BI Service sends the refresh operation through the gateway, which runs on the laptop and can reach the local MySQL server.
- Both connections can display the same server/database identifiers but use different connection routes and connection objects. Creating an on-premises connection does not itself map the semantic model; the model's **Gateway connections → Maps to** field must explicitly select the connection and be applied.
- In this project, the new on-premises mapping plus a completed on-demand refresh confirms the intended route is functional. The original Cloud connection was not deleted.

## 11. Status snapshot as of 16 October 2026 (superseded by the 18 October consolidated status)

### Completed
- Historical note: all nine MySQL project tables were reported imported. The v17 aggregate of 83,754 rows is now flagged as inconsistent with its recorded per-table counts (120,134); a live per-table recount is required before confirming the aggregate.
- Copied PBIX migrated to MySQL while preserving reviewed M transformations and the embedded RLS mapping table.
- Desktop report refreshed and key cards remained visible.
- Gateway installed, registered, and shown online.
- On-premises MySQL connection created under the gateway.
- Semantic model explicitly mapped to the on-premises connection.
- Manual Service refresh completed successfully in 32 seconds.

### Pending as of 16 October 2026 (later updates resolve or refine some items)
1. Open the Service report after refresh and compare key KPI values to Desktop/expected data.
2. Re-open Refresh history and verify the completed refresh details if required; capture the detailed refresh record for documentation.
3. Configure and test a scheduled refresh, after confirming data source credentials and schedule settings. The laptop and MySQL service must be running and reachable at scheduled times.
4. Confirm gateway connectivity after a laptop restart and test another manual refresh if needed.
5. If continuing RLS validation, test Mumbai and Delhi mappings and confirm the published semantic model's security assignments/identity behavior.
6. Investigate the original Cloud connection only if needed for learning/documentation; do not delete it without a deliberate cleanup decision. Its exact failure cause remains unproven.
7. Keep `INTERVIEW_QA` synchronized with future project work; the gateway installation root cause, connection-type distinction, mapping steps, and successful refresh have now been added to the v17 Q&A file.

### Overall project conclusion
The migration's source database and Desktop model work were already complete enough for Service publishing, but refresh initially failed because the Service did not have a working local-source route and complete connection setup. The gateway installer also initially failed due to insufficient C: drive space. After safely freeing temporary space, registering the gateway, creating a MySQL on-premises connection, mapping the semantic model to it, and applying the mapping, an on-demand Service refresh completed successfully. The next validation boundary is report-level data comparison and scheduled refresh—not further changes to the already successful gateway mapping.



---

> **Historical appendix note:** This appendix preserves the 14 October implementation inventory and the partial migration status known at that time. Its statements that migration or validation remained pending are historical, not the current status. Refer to the 15–18 October entries and the consolidated status at the top for later evidence.

# Appendix A — Detailed CSV-to-MySQL M-Code Inventory and Privacy Troubleshooting (historical record, 14 October 2026)

### Objective and safety boundaries
The work is being performed in `Marketing_Funnel_Campaign_Intelligence_COPIED.pbix`, not the original PBIX. The source CSV folder remains `C:\Users\USER\Downloads\MarTech_PowerBI_Project_Tables`. The target MySQL database is `marketing_funnel_mysql` on `localhost:3306` (MySQL Server 8.0.25). The original PBIX and CSV files must remain unchanged.

The goal is to change the source layer from CSV files to MySQL while retaining the existing Power Query transformations, table names, model relationships, measures, report pages, and RLS. A source migration should not silently change business logic. The model/relationships and RLS validation are still pending; a successful visual refresh is not by itself proof that every query now uses MySQL or that all metrics are equivalent.

### MySQL database source M code observed
The `FactLeads` query's first step was changed to the MySQL connector. The formula bar showed:

```powerquery
MySQL.Database("localhost:3306", "marketing_funnel_mysql", [ReturnSingleDatabase=true])
```

The next navigation step showed:

```powerquery
Source{[Schema="marketing_funnel_mysql", Item="factleads"]}[Data]
```

This is Power Query M (not SQL). It tells Power Query to connect to the database and navigate to the `factleads` table. A SQL equivalent for reading the table is:

```sql
USE marketing_funnel_mysql;
SELECT *
FROM factleads;
```

A query can also use the MySQL connector's native SQL option, but doing so changes how the query is authored. In this migration, the safer initial approach is table navigation followed by preserving the existing M transformation steps.

### Source M code and SQL table-read equivalent by query
The SQL examples below are source-table reads; they do not mean the M transformations have automatically been translated into SQL. Keep the existing transformation steps after the source/navigation step unless a separately tested redesign is intended.

#### 1. FactLeads — M source and table read

Original CSV source M:

```powerquery
Source = Csv.Document(
    File.Contents("C:\Users\USER\Downloads\MarTech_PowerBI_Project_Tables\FactLeads.csv"),
    [Delimiter=",", Columns=8, QuoteStyle=QuoteStyle.None]
)
```

MySQL source/navigation M:

```powerquery
Source = MySQL.Database("localhost:3306", "marketing_funnel_mysql", [ReturnSingleDatabase=true]),
FactLeadsTable = Source{[Schema="marketing_funnel_mysql", Item="factleads"]}[Data]
```

Equivalent SQL table read:

```sql
SELECT LeadID, LeadDate, CampaignID, Source, City, Program, LeadStatus, Revenue
FROM marketing_funnel_mysql.factleads;
```

Preserve the existing following M transformations: type conversion; `RevenueStatus` (`Revenue > 0` => `Revenue Generated`, else `No Revenue`); `Month Name` from `LeadDate`; left-outer merge with `DimCampaign` on `CampaignID`; expand `CampaignName`, `Channel`, and `Objective`. The merge is a dependency on `DimCampaign`, so the dimension source must be checked as well.

Equivalent SQL expression of the *merge/expand idea* (illustrative only; not executed as the current Power Query implementation):

```sql
SELECT
    f.LeadID, f.LeadDate, f.CampaignID, f.Source, f.City,
    f.Program, f.LeadStatus, f.Revenue,
    CASE WHEN f.Revenue > 0 THEN 'Revenue Generated' ELSE 'No Revenue' END AS RevenueStatus,
    MONTHNAME(f.LeadDate) AS `Month Name`,
    d.CampaignName AS `DimCampaign.CampaignName`,
    d.Channel AS `DimCampaign.Channel`,
    d.Objective AS `DimCampaign.Objective`
FROM marketing_funnel_mysql.factleads AS f
LEFT JOIN marketing_funnel_mysql.dimcampaign AS d
    ON f.CampaignID = d.CampaignID;
```

Do not replace the M merge with this SQL unless that design change is intentional and tested. `Month Name` locale/formatting can differ by engine/session, and column names with dots/spaces require quoting.

#### 2. DimCampaign

Original CSV M source:

```powerquery
Source = Csv.Document(
    File.Contents("C:\Users\USER\Downloads\MarTech_PowerBI_Project_Tables\DimCampaign.csv"),
    [Delimiter=",", Columns=4, QuoteStyle=QuoteStyle.None]
)
```

MySQL source/navigation M:

```powerquery
Source = MySQL.Database("localhost:3306", "marketing_funnel_mysql", [ReturnSingleDatabase=true]),
DimCampaignTable = Source{[Schema="marketing_funnel_mysql", Item="dimcampaign"]}[Data]
```

Equivalent SQL table read:

```sql
SELECT CampaignID, CampaignName, Channel, Objective
FROM marketing_funnel_mysql.dimcampaign;
```

Existing M transformation to preserve and separately review:

```powerquery
Table.AddColumn(#"Changed Type", "Extra", each if [CampaignID] = 0 then "yes" else "no")
```

`CampaignID` is already text, with values such as `C001`, while the condition compares it to numeric `0`. The current preview showed `Extra = "no"` for all 10 campaigns. This was not changed during source migration because it is a pre-existing logic question, not a source switch. Confirm the business purpose before correcting it.

#### 3. DimCustomer

Original CSV M source reads `DimCustomer.csv` with 5 columns, promotes headers, and sets `CustomerID`, `CustomerType`, `AgeBand`, `CustomerCity`, `CustomerStatus` to text.

MySQL source/navigation M:

```powerquery
Source = MySQL.Database("localhost:3306", "marketing_funnel_mysql", [ReturnSingleDatabase=true]),
DimCustomerTable = Source{[Schema="marketing_funnel_mysql", Item="dimcustomer"]}[Data]
```

Equivalent SQL table read:

```sql
SELECT CustomerID, CustomerType, AgeBand, CustomerCity, CustomerStatus
FROM marketing_funnel_mysql.dimcustomer;
```

Preserve text types unless a validated model requirement calls for something else.

#### 4. DimDate

Original CSV M source reads `DimDate.csv` with 7 columns, promotes headers, and types `Date` as date; `Year` and `MonthNo` as 64-bit integers; `Month`, `Quarter`, and `DayName` as text; `YearMonth` as date. It then adds `Start of Month = Date.StartOfMonth([Date])` and renames `YearMonth` to `Start of the Month`.

MySQL source/navigation M:

```powerquery
Source = MySQL.Database("localhost:3306", "marketing_funnel_mysql", [ReturnSingleDatabase=true]),
DimDateTable = Source{[Schema="marketing_funnel_mysql", Item="dimdate"]}[Data]
```

Equivalent SQL table read:

```sql
SELECT `Date`, `Year`, MonthNo, Month, YearMonth, Quarter, DayName
FROM marketing_funnel_mysql.dimdate;
```

Keep both output columns, `Start of Month` and `Start of the Month`, until dependencies are inspected. They are distinct names in the current model and should not be consolidated casually.

#### 5. DimMonth

This query is a **reference of DimDate**, not an independent CSV import. Its M steps remove `MonthNo`, `Year`, and `Month`; keep `Start of Month`; then remove duplicate month-start dates. Preserve the dependency and the distinct-month grain (expected 21 rows).

Existing M pattern:

```powerquery
Source = DimDate,
#"Removed Columns" = Table.RemoveColumns(Source,{"MonthNo", "Year", "Month"}),
#"Removed Other Columns(Keep only start of month)" = Table.SelectColumns(#"Removed Columns",{"Start of Month"}),
#"Removed Duplicates in start of Month" = Table.Distinct(#"Removed Other Columns(Keep only start of month)")
```

Equivalent SQL idea, if it were implemented as a separate SQL query (not necessary when keeping the existing M reference):

```sql
SELECT DISTINCT DATE_FORMAT(`Date`, '%Y-%m-01') AS `Start of Month`
FROM marketing_funnel_mysql.dimdate;
```

Note: `DATE_FORMAT` returns text in MySQL. To return a true date, a more explicit expression is:

```sql
SELECT DISTINCT CAST(DATE_FORMAT(`Date`, '%Y-%m-01') AS DATE) AS `Start of Month`
FROM marketing_funnel_mysql.dimdate;
```

Prefer the existing M reference unless a SQL view is deliberately being introduced.

#### 6. FactAdSpend

Original CSV M source reads `FactAdSpend.csv` with six columns; types `Date` as date, `CampaignID` as text, and `AdSpend`, `Impressions`, `Clicks`, `PlatformConversions` as whole numbers.

MySQL source/navigation M:

```powerquery
Source = MySQL.Database("localhost:3306", "marketing_funnel_mysql", [ReturnSingleDatabase=true]),
FactAdSpendTable = Source{[Schema="marketing_funnel_mysql", Item="factadspend"]}[Data]
```

Equivalent SQL table read:

```sql
SELECT `Date`, CampaignID, AdSpend, Impressions, Clicks, PlatformConversions
FROM marketing_funnel_mysql.factadspend;
```

#### 7. CampaignBudget

Original CSV M source reads four columns and types `BudgetID` and `CampaignID` as text, `MonthStart` as date, and `BudgetAmount` as whole number.

MySQL source/navigation M:

```powerquery
Source = MySQL.Database("localhost:3306", "marketing_funnel_mysql", [ReturnSingleDatabase=true]),
CampaignBudgetTable = Source{[Schema="marketing_funnel_mysql", Item="campaignbudget"]}[Data]
```

Equivalent SQL table read:

```sql
SELECT BudgetID, CampaignID, MonthStart, BudgetAmount
FROM marketing_funnel_mysql.campaignbudget;
```

Validate `BudgetAmount` carefully because the MySQL schema may use `DECIMAL` while the existing M step casts it to `Int64.Type`; confirm whether fractional amounts exist before changing the model type.

#### 8. CRMActivity

Original CSV M source reads five columns and types `ActivityID`, `LeadID`, `ActivityType`, and `Outcome` as text, `ActivityDate` as date.

MySQL source/navigation M:

```powerquery
Source = MySQL.Database("localhost:3306", "marketing_funnel_mysql", [ReturnSingleDatabase=true]),
CRMActivityTable = Source{[Schema="marketing_funnel_mysql", Item="crmactivity"]}[Data]
```

Equivalent SQL table read:

```sql
SELECT ActivityID, LeadID, ActivityDate, ActivityType, Outcome
FROM marketing_funnel_mysql.crmactivity;
```

#### 9. LeadStageHistory

Original CSV M source reads five columns using UTF-8 (`Encoding=65001`), promotes headers, and types `StageHistoryID`, `LeadID`, and `Stage` as text, `StageDate` as date, and `StageOrder` as whole number.

MySQL source/navigation M:

```powerquery
Source = MySQL.Database("localhost:3306", "marketing_funnel_mysql", [ReturnSingleDatabase=true]),
LeadStageHistoryTable = Source{[Schema="marketing_funnel_mysql", Item="leadstagehistory"]}[Data]
```

Equivalent SQL table read:

```sql
SELECT StageHistoryID, LeadID, Stage, StageDate, StageOrder
FROM marketing_funnel_mysql.leadstagehistory;
```

#### 10. UserCityAccess

`UserCityAccess` is an embedded M table created from compressed Base64 data, followed by replacements of email values. It is not one of the nine imported CSV-backed MySQL tables and should not be replaced with a database navigation step unless there is an explicit security-table redesign. Existing replacement values shown during review included `marketing.head@example.com` → `all-cities.test.user@example.com` and `bangalore.manager@example.com` → `bangalore.test.user@example.com` in the query version inspected. The exact current mapping must be checked in the query before Service RLS validation; email values must match the identity returned by `USERPRINCIPALNAME()`.

### Migration and privacy-level troubleshooting — observed sequence

1. Power Query showed a yellow message: **“Information is required about data privacy.”** This appeared around `FactLeads`' merge step because the query combines a MySQL source with `DimCampaign`, which was still listed as a CSV source in Data source settings.
2. The Privacy Levels dialog listed `localhost:3306;marketing_funnel_mysql` (MySQL) and `...\DimCampaign.csv` (File), both showing privacy level `None`.
3. Trying to save/assign privacy settings caused this Power BI error:

```text
Exception while invoking Service 'IConnectionsService', Method 'SetPrivacyGroup', Args:
'connection,privacyGroup,mashupId'. dataSource was not passed as a method argument
```

4. The same `SetPrivacyGroup` exception appeared again; the dialog was cancelled rather than repeatedly forcing the setting. The message appears to be a Power BI Desktop/service UI/API exception while setting the privacy group; it does **not** by itself establish that MySQL credentials are invalid or that table data is corrupt.
5. The user returned to Power Query and then the main report. The report was saved/refreshed without a refresh error. Visible KPIs included 30,000 leads, 9,561 qualified, 5,268 demos, 2,054 enrolled, 6.85% acquisition-to-enrolled, 5M ad spend, 48M revenue, and 10.17 ROAS. These are recorded as observed screenshot values, not yet a proof of parity with the pre-migration report.
6. Data source settings still listed several CSV sources (including `CampaignBudget.csv`, `CRMActivity.csv`, `DimCampaign.csv`, `DimCustomer.csv`, `DimDate.csv`, `FactAdSpend.csv`, and `LeadStageHistory.csv`) alongside MySQL. Therefore, at that point the migration should be treated as **partially migrated / mixed-source**, not complete. The next work must inspect each query's Source step and complete the source switch consistently before calling the project fully migrated.
7. The user verified row counts from the Power BI Data/model view: `FactLeads` 30,000; `FactAdSpend` 6,230; `LeadStageHistory` 46,883. The user explicitly confirmed all three counts were correct. These checks are **PASS for the observed row counts**. Other tables, relationships, metric parity, and RLS remain to be checked.

### Why the privacy issue matters and safe next actions
- Power Query privacy levels protect against unintended data movement when queries combine sources. `None` is not a privacy classification that should be selected blindly; use the organization's actual policy. For a local practice project, the intended privacy classification should be chosen consistently and deliberately for the MySQL and local CSV sources.
- Since the privacy dialog itself throws `SetPrivacyGroup`, do not keep repeating the same failing save action. First determine whether the error persists after restarting Desktop and whether the source permissions/privacy setting can be set under **File > Options and settings > Data source settings > Global permissions**. Record the exact result. If necessary, clear only the relevant stored permission entry and reconnect, but do not clear unrelated sources or delete project data.
- A durable way to reduce cross-source privacy prompts is to finish migrating dependent queries such as `DimCampaign` to MySQL, so a merge no longer combines MySQL and CSV. However, changing a source is a data-model change and must be validated. `UserCityAccess` is embedded and can remain a separate local table.
- Do not tick “Ignore Privacy Levels checks for this document” as a blind workaround. Use it only if the privacy implications are understood and the project policy permits it.
- Do not reset MySQL passwords or change the server configuration as a response to the `SetPrivacyGroup` exception; that error is about privacy-group handling, not the database authentication handshake.

### Validation completed and pending

**Completed (user-confirmed):**
- Main report saved and refreshed without an error after the source-step work so far.
- `FactLeads`: 30,000 rows.
- `FactAdSpend`: 6,230 rows.
- `LeadStageHistory`: 46,883 rows.
- Existing report pages/visuals remained visible in the copied PBIX.

**Still pending:**
- Review the Model view and confirm existing relationships, cardinalities, and filter directions; do not recreate relationships before inspection.
- Inventory the Source step for all 10 Power Query queries and confirm which still use CSV versus MySQL.
- Finish migrating the nine database-backed queries while keeping `DimMonth` as a reference to `DimDate` and `UserCityAccess` as embedded data.
- Resolve or document the privacy-level dialog error without weakening privacy controls blindly.
- Validate all nine table row counts in Power BI against MySQL, key uniqueness, data types, nulls, and date ranges.
- Compare important KPI values and all eight report pages with the pre-migration baseline; investigate the observed change to 48M revenue / 10.17 ROAS if that differs from the intended baseline.
- Test Desktop RLS and then Power BI Service RLS after the source migration. Existing role logic must remain intact unless a separate security change is approved.
- Save the migrated copy under a distinct name and confirm the original PBIX/CSV files remain untouched.

### Interview takeaways from this stage
- A successful refresh confirms that the refresh operation completed; it does not prove that every query now uses the intended source or that all measures match the baseline.
- When a query merges two sources, source dependencies and privacy levels must be considered together.
- Separate source migration from business-logic correction: preserve transformations first, then fix suspicious logic as a documented change.
- Compare row counts, date ranges, keys, data types, relationships, KPI outputs, and security behavior. No single validation check is sufficient.

---

# Consolidated Current Status — 18 October 2026

## Status summary
The core end-to-end Marketing Funnel & Campaign Intelligence project is substantially complete. The separate MySQL PBIX was published to Power BI Service without replacing the original CSV-based report/semantic model. Remaining work is portfolio preparation, broader Service learning, final configuration checks, and resume integration.

## Power BI Service deployment
- Published semantic model: `Marketing_Funnel_Campaign_Intelligence_using MySQL database`.
- MySQL source: server `localhost:3306`; database `marketing_funnel_mysql`.
- On-premises gateway: `MySQL_OnPrem_Gateway`, registered on the user's laptop, reported Online and Enabled.
- Gateway connection: `Marketing_Funnel_MySQL_Connection`; the MySQL source was mapped to this connection.
- A successful manual refresh was recorded on 18 October 2026 at approximately 5:20 PM IST; the data refresh itself took about 32 seconds in the history entry. Earlier successful manual refreshes were also recorded on 16 and 18 October.
- Scheduled refresh settings were enabled for India Standard Time. The user configured two daily slots: 10:00 AM and 8:00 PM IST, to review updated data at the start and end of the workday.
- Scheduled refresh test on 18 October 2026 started at 6:01 PM IST and completed at 6:12:03 PM. Overall elapsed duration shown was 11 minutes 3 seconds; the data refresh stage ran from 6:11:40 PM to 6:12:03 PM (22 seconds), and QueryCache completed in less than one second. No error was reported. The gap before the data stage is unexplained; do not claim a root cause.
- Refresh execution details were temporarily unavailable and the UI stated they may take up to 15 minutes to appear. The refresh status itself was Completed.
- Gateway and scheduled refresh are validated for the successful runs observed. Continue monitoring subsequent 10 AM/8 PM runs to ensure consistency. Laptop, MySQL service and gateway need to be running/reachable for the local-source schedule to work.

## Row-Level Security validation
- Roles present in the model: `RLS_Bangalore` and `RLS_Dynamic`.
- `RLS_Dynamic` uses `USERPRINCIPALNAME()` and looks up the user's city in `UserCityAccess`; `ALL` is intended to allow all cities.
- In Power BI Desktop, a temporary table using `FactLeads[City]` showed all cities with no role applied, only Bangalore with `RLS_Bangalore`, and only Bangalore for `RLS_Dynamic` when tested with `bangalore.test.user@example.com`.
- The same temporary City table test was performed in Power BI Service using the role-testing option. The same behavior was observed: all cities without a role, only Bangalore under `RLS_Bangalore`, and only Bangalore under `RLS_Dynamic` for the Chetan/Bangalore mapping.
- Temporary City tables were removed and the report layout restored afterward.
- Service RLS role membership page showed one member for `RLS_Dynamic` (Chetan Patil); `RLS_Bangalore` showed zero members. Role-based testing was performed using the Service `Test as role` function.
- Workspace access screenshot showed `bangalore.test.user@example.com` as Workspace Admin. Normal report viewing as this admin is not a valid RLS test; use the role-testing function or an appropriate Viewer account for further validation.
- Mumbai, Delhi and `ALL` user scenarios have not yet been validated in Power BI Service. The `all-cities.test.user@example.com` address was rejected when adding it as a role member, so do not claim that identity has been validated in Service.

## Report validation and preservation
- Service report KPIs and filter interactions were checked against Desktop, including 30,000 total leads in the all-data view and filtered Google/date views.
- Original CSV-based report and semantic model must remain untouched. Treat the MySQL report and semantic model as a separate deployment.
- The original CSV model had a separate historical refresh warning/missing-credentials message. This must not be conflated with the MySQL model, whose observed refreshes succeeded.

## Current status and next actions
1. Keep the intended daily schedule at 10:00 AM and 8:00 PM IST; verify future scheduled history entries.
2. Complete RLS tests for additional authorized mappings (Mumbai, Delhi, and `ALL`) if suitable identities are available, while avoiding sharing credentials.
3. Update and preserve `PROJECT_LOG.md` and `INTERVIEW_QA.md` as project history.
4. Prepare a GitHub-safe repository: README, architecture/data flow, data dictionary, model/relationship notes, selected DAX examples, screenshots, refresh/RLS test evidence, and limitations. Do not publish passwords, private account details, gateway secrets, local file paths, or any sensitive real data. Use synthetic/sample data or a sanitized schema/sample. Do not commit credentials or a live PBIX containing sensitive connection details.
5. Explore Power BI Service capabilities systematically during the remaining trial period, then add the project to the resume with accurate claims.

## Interview takeaways from this milestone
- Explain the distinction between publishing a report and making its data source refreshable in Service.
- An on-premises gateway bridges Power BI Service to a data source running on a local computer; gateway online status alone does not prove a semantic model mapping is correct.
- Distinguish manual refresh success from scheduled refresh success; validate the latter using Refresh History.
- Refresh request elapsed time can differ from the actual data-stage duration; report what the history proves and avoid inventing a root cause.
- RLS validation should test row-level results under the role. A workspace Admin's normal view does not prove RLS behavior.
- Remove temporary diagnostic visuals and restore the production report layout after testing.


## Consolidation reconciliation notes

- The v17 Service deployment section recorded 83,754 total rows across nine MySQL tables, but its own listed per-table counts sum to 120,134. These cannot both describe the same snapshot. The sum is arithmetic over historical notes, not a live database measurement. Use the current row-count reconciliation query above and document the run date/results before claiming a verified aggregate.
- A successful refresh verifies that the refresh operation completed; it does not by itself establish complete CSV-to-MySQL KPI parity. The October 18 evidence supports Desktop/Service comparisons for the stated scenarios and successful scheduled-refresh execution, while a full source-to-source parity audit remains a follow-up.
- The 18 October RLS evidence verifies Bangalore behavior for the tested role/mapping in Desktop and Service. It does not verify Mumbai, Delhi, or `ALL`.


## Consolidation audit update — 18 October 2026

- Corrected the wording around the historical aggregate row count; preserved the old claim only as a superseded source statement and added a live MySQL query to reconcile the current counts.
- Sanitized personal email identities, local Windows user paths, and the local gateway host/name in examples for safer sharing. `@example.com` identities are placeholders only and are not actual RLS test accounts.
- Preserved older event logs and their dates; current-state claims at the top take precedence over dated historical next-step lists.
- Remaining substantive validations are live table counts, full CSV-to-MySQL KPI parity, future scheduled-refresh reliability, and Mumbai/Delhi/`ALL` RLS testing. No database query was run by this documentation edit, and no GitHub upload was performed.

- **Security review:** flagged the historically used MySQL `root` login as something to replace with a dedicated least-privilege account before any public/demo reuse.
