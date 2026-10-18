# Marketing Funnel & Campaign Intelligence — INTERVIEW Q&A

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

## Purpose

This is the living interview-preparation document for the project. Answers are based on the actual project workflow, decisions, problems and current model state. Features not actually implemented are explicitly marked as concepts rather than hands-on experience.

---

# 1. Project / Business Understanding

### Q1. What is the objective of this Power BI project?

**Answer:**
To build an end-to-end marketing analytics solution that helps stakeholders understand lead generation, funnel movement, campaign efficiency, conversion and revenue, and then use those insights for business decisions.

### Q2. What is the end-to-end workflow?

**Answer:**
Requirement gathering → source-data understanding → Power Query/ETL → data-quality validation → data modeling → calculated columns and DAX measures → KPI/dashboard development → funnel/time analysis → UAT/reconciliation → performance → Power BI Service/deployment → business insights.

### Q3. Why did you build this as an end-to-end project?

**Answer:**
Because a BI analyst is not only responsible for creating visuals. I need to understand the source data, clean it, model it correctly, create reliable calculations, validate the numbers, publish the solution and explain the business impact.

### Q4. What business KPIs did you build?

**Answer:**
Total Leads, Qualified Leads, Demo Leads, Enrolled Leads, Conversion %, Revenue, Ad Spend, CPL, CAC, ROAS and time-intelligence metrics such as YTD, MTD, QTD, Previous Year Revenue and YoY Revenue %.

---

# 2. Source Data / Grain / Keys

### Q5. What is grain?

**Answer:**
Grain describes what one row in a table represents. For example, one row in `FactLeads` represents one lead, while one row in `FactAdSpend` represents one Campaign + Date record.

### Q6. What is the difference between a key and grain?

**Answer:**
Grain tells me what the row represents; a key identifies the row uniquely. A table can have a unique technical ID while its business grain is represented by multiple columns.

### Q7. What is the grain of FactLeads?

**Answer:**
One row per Lead.

### Q8. What is the grain of FactAdSpend?

**Answer:**
One row per Campaign + Date. Neither Date nor CampaignID alone is unique.

### Q9. Why is Date + CampaignID important in FactAdSpend?

**Answer:**
A campaign occurs on many dates and each date can contain many campaigns, so the combination represents the record at that table's business grain.

### Q10. What is the grain of CampaignBudget?

**Answer:**
Campaign + Month. `BudgetID` identifies the individual budget record, while CampaignID and MonthStart describe the business grain.

### Q11. Why should you identify grain before creating relationships?

**Answer:**
Because grain determines whether a relationship is logically one-to-many, many-to-many or invalid. If I misunderstand grain, I can create incorrect filter propagation and duplicate aggregations.

---

# 3. Power Query / ETL

### Q12. Why did you use Power Query?

**Answer:**
I used Power Query for data ingestion, profiling, cleaning, standardization and row-level transformations before the data entered the analytical model.

### Q13. What data-quality issues did you find?

**Answer:**
I found inconsistent casing such as `meta` vs `Meta`, city variations such as `BANGALORE` vs `Bangalore`, nulls, `N/A` values and campaign naming inconsistencies.

### Q14. Why is data profiling important before transformation?

**Answer:**
Because I need to understand the actual source problem before deciding how to transform it. Otherwise I may change valid data unnecessarily or solve the wrong problem.

### Q15. Give an example of a Power Query transformation you performed.

**Answer:**
I created a Month Name column using the Date transformation and created a `RevenueStatus` custom column to classify rows as Revenue Generated or No Revenue.

### Q16. What was your RevenueStatus logic?

**Answer:**

```M
if [Revenue] > 0 then "Revenue Generated" else "No Revenue"
```

### Q17. Why create RevenueStatus in Power Query instead of a measure?

**Answer:**
Because it is a row-level classification. A measure is evaluated dynamically in filter context, while this classification is a property of each row.

### Q18. Does cleaning a column in one Power Query query automatically clean the same business attribute in another query?

**Answer:**
No. Transformations are query-specific unless the queries are built from a shared transformation/reference strategy. This is why cross-source standardization should use a controlled reference or mapping approach.

---

# 4. Fact vs Dimension / Star Schema

### Q19. What is a star schema?

**Answer:**
A star schema has fact tables containing measurable business events surrounded by dimension tables containing descriptive attributes used for filtering and grouping.

### Q20. Why use a star schema?

**Answer:**
It provides clearer business semantics, controlled filter paths, simpler DAX reasoning and generally easier report maintenance and performance optimization.

### Q21. Why shouldn't you directly join FactLeads and FactAdSpend?

**Answer:**
Their grains are different. FactLeads is Lead grain while FactAdSpend is Campaign + Date grain. Directly joining them can duplicate rows and produce incorrect aggregations. Shared dimensions such as Campaign and Date provide the appropriate analytical paths.

### Q22. Why didn't you create a relationship between DimCustomer and FactLeads?

**Answer:**
`FactLeads` does not contain `CustomerID`, so there is no valid common key. I would not invent a relationship or force many-to-many just to connect every table. I would first identify the correct business key or bridge if customer analysis becomes a requirement.

### Q23. Should every table in a Power BI model have a relationship?

**Answer:**
No. Relationships should be created only when the business meaning, grain, key uniqueness, cardinality and intended filter path support them. A disconnected table can be intentional.

### Q24. Why use single-direction filtering?

**Answer:**
The model follows a dimension-to-fact filtering pattern. Single direction reduces ambiguity and unexpected filter propagation and makes the model easier to reason about.

### Q25. What do you check before creating a relationship?

**Answer:**
Business meaning, table grain, key uniqueness, cardinality, data types, filter direction, intended analytical path and whether the relationship can cause ambiguity or double counting.

### Q26. What happens if you create an incorrect relationship?

**Answer:**
It may not produce an obvious error, but it can change filter propagation and cause incorrect counts, aggregations, KPIs, unexpected inclusions/exclusions, ambiguous paths or double counting.

### Q27. Can two relationships between the same tables ever be valid?

**Answer:**
Yes. For example, a Sales table can have OrderDate and ShipDate relationships to a Date dimension. Usually one is active and the other inactive, and DAX can use `USERELATIONSHIP` when the inactive relationship is required.

---

# 5. DimMonth / Monthly Grain

### Q28. Why did you create DimMonth?

**Answer:**
CampaignBudget is monthly while DimDate is daily. I created a one-row-per-month DimMonth so the monthly analytical grain is explicit and the budget relationship is clean.

### Q29. Why create DimMonth as a Reference from DimDate?

**Answer:**
Because the month dimension can be derived consistently from the existing date dimension. I kept the month-start field, removed duplicates and created one row per month.

### Q30. Why not directly relate DimDate[Date] to CampaignBudget[MonthStart]?

**Answer:**
It mixes daily and monthly grain. Although a technical relationship may be possible, a dedicated monthly dimension represents the business grain more clearly and makes monthly analysis easier to reason about.

---

# 6. Calculated Columns vs Measures

### Q31. What is the difference between a calculated column and a measure?

**Answer:**
A calculated column is calculated row by row and stored in the model. A measure is calculated dynamically at query time according to the current filter context.

### Q32. When would you use a calculated column?

**Answer:**
For row-level attributes such as categorization, flags, sort keys or derived fields that need to be used for grouping, filtering or relationships.

### Q33. When would you use a measure?

**Answer:**
For dynamic aggregations and KPIs such as revenue, conversion rate, YTD revenue or ROAS that should respond to filters and visual context.

### Q34. Why is YearMonth a calculated column rather than a measure?

**Answer:**
Because each date row needs its own YearMonth value. A measure does not create a stored value for every date row and is not appropriate for a sort/grouping attribute.

### Q35. What YearMonth formula did you use?

```DAX
YearMonth =
FORMAT(
    'DimDate'[Date],
    "YYYY-MM"
)
```

### Q36. What is YearMonthSort?

```DAX
YearMonthSort =
YEAR('DimDate'[Date]) * 100 + MONTH('DimDate'[Date])
```

**Answer:**
It creates a numeric chronological key such as 202509 for September 2025, allowing the text YearMonth value to be sorted correctly.

---

# 7. DAX Fundamentals

### Q37. What is CALCULATE?

**Answer:**
`CALCULATE` evaluates an expression in a modified filter context. It is one of the most important DAX functions for creating filtered KPIs and time-intelligence calculations.

### Q38. What is filter context?

**Answer:**
Filter context is the set of filters currently applied to a calculation by slicers, rows/columns in a visual, relationships and DAX filter expressions.

### Q39. What is row context?

**Answer:**
Row context refers to the current row when DAX evaluates a calculated column or certain iterator expressions.

### Q40. Why can a correct DAX formula still return a wrong result?

**Answer:**
Because the model may have an incorrect relationship or filter path. DAX operates within the model's filter context, so relationship design is just as important as the formula.

---

# 8. Core Project DAX

### Q41. How did you calculate Total Leads?

```DAX
Total Leads =
COUNTROWS(FactLeads)
```

### Q42. How did you calculate Qualified Leads?

```DAX
Qualified Leads =
CALCULATE(
    [Total Leads],
    FactLeads[LeadStatus] = "Qualified"
)
```

### Q43. How did you calculate Demo Leads?

```DAX
Demo Leads =
CALCULATE(
    [Total Leads],
    FactLeads[LeadStatus] = "Demo"
)
```

### Q44. How did you calculate Enrolled Leads?

```DAX
Enrolled Leads =
CALCULATE(
    [Total Leads],
    FactLeads[LeadStatus] = "Enrolled"
)
```

### Q45. How did you calculate conversion rate?

```DAX
Conversion % =
DIVIDE(
    [Enrolled Leads],
    [Total Leads],
    0
)
```

### Q46. Why use DIVIDE instead of `/`?

**Answer:**
`DIVIDE` handles division-by-zero more safely and lets me specify an alternate result.

### Q47. How did you calculate Revenue?

```DAX
Revenue =
SUM(FactLeads[Revenue])
```

### Q48. How did you calculate Ad Spend?

```DAX
Ad Spend =
SUM(FactAdSpend[AdSpend])
```

### Q49. How did you calculate CPL?

```DAX
CPL =
DIVIDE(
    [Ad Spend],
    [Total Leads],
    0
)
```

### Q50. How did you calculate CAC?

```DAX
CAC =
DIVIDE(
    [Ad Spend],
    [Enrolled Leads],
    0
)
```

### Q51. How did you calculate ROAS?

```DAX
ROAS =
DIVIDE(
    [Revenue],
    [Ad Spend],
    0
)
```

### Q52. What is the difference between CPL and CAC?

**Answer:**
CPL is advertising spend divided by leads. CAC is advertising spend divided by enrolled/acquired customers according to the defined business metric. CAC therefore reflects a later conversion stage than CPL.

### Q53. What does ROAS measure?

**Answer:**
ROAS measures revenue generated relative to advertising spend. In this project it is Revenue divided by Ad Spend.

---

# 9. Time Intelligence

### Q54. How did you calculate YTD Revenue?

```DAX
YTD Revenue =
CALCULATE(
    [Revenue],
    DATESYTD(DimDate[Date])
)
```

### Q55. How did you calculate MTD Revenue?

```DAX
MTD Revenue =
CALCULATE(
    [Revenue],
    DATESMTD(DimDate[Date])
)
```

### Q56. How did you calculate QTD Revenue?

```DAX
QTD Revenue =
CALCULATE(
    [Revenue],
    DATESQTD(DimDate[Date])
)
```

### Q57. How did you calculate Previous Year Revenue?

```DAX
Previous Year Revenue =
CALCULATE(
    [Revenue],
    SAMEPERIODLASTYEAR(DimDate[Date])
)
```

### Q58. How did you calculate YoY Revenue %?

```DAX
YoY Revenue % =
DIVIDE(
    [Revenue] - [Previous Year Revenue],
    [Previous Year Revenue]
)
```

### Q59. Why should you use a proper Date table?

**Answer:**
Time-intelligence functions require a reliable calendar structure and appropriate date relationships. A proper Date dimension also provides consistent time filtering across fact tables.

### Q60. Why can Previous Year Revenue be blank?

**Answer:**
If there is no corresponding prior-year data for the selected period, there may be nothing to compare against. Returning blank is often more informative than displaying a misleading zero.

---

# 10. Funnel Analysis

### Q61. What stages did you define for the business funnel?

**Answer:**
Leads → Qualified → Demo → Enrolled.

### Q62. Why did you use a separate FunnelStages table?

**Answer:**
The funnel stages are a controlled presentation/analysis axis rather than a physical source key. A disconnected table lets the report define the desired stage order without creating an artificial relationship to the fact table.

### Q63. Why did you change the first funnel label from New to Leads?

**Answer:**
Because `New` is a current status, whereas the business funnel's first stage represents the total lead population. Using `Leads` avoids implying that every lead is currently in a New status.

### Q64. What was the StageOrder issue?

**Answer:**
I created a row-level StageOrder based on LeadStatus and tried to use it to sort LeadStatus. Power BI produced a circular-dependency issue. I separated the presentation funnel stages into a dedicated FunnelStages table instead of forcing the current-status column to perform both roles.

### Q65. Can CRM activity be used as the historical funnel stage?

**Answer:**
Not reliably in this project. CRMActivity records activities, not necessarily official stage transitions. A lead can have a Demo activity while its current status is New or Qualified.

### Q66. What did you do after discovering that issue?

**Answer:**
I diagnosed the activity data and then added a dedicated `LeadStageHistory` dataset with LeadID, Stage, StageDate and StageOrder so a true stage-history model can be built later.

### Q67. Is LeadStageHistory already integrated into the current PBIX?

**Answer:**
Yes. It was added to the current PBIX and is used for the historical funnel. The `LeadID` relationship to `FactLeads` is active, while the `StageDate` relationship to `DimDate` is inactive and is activated with `USERELATIONSHIP()` for the historical calculation.

---

### Q68. Why is the `DimDate[Date]` → `LeadStageHistory[StageDate]` relationship inactive?

**Answer:**
`DimDate` already has an active relationship to `FactLeads[LeadDate]`, which represents lead creation date. `LeadStageHistory[StageDate]` represents the date on which a historical stage occurred. I keep the StageDate relationship inactive and use `USERELATIONSHIP()` when I specifically need historical-stage date filtering.

### Q69. How did you troubleshoot the historical funnel when Channel was not affecting it?

**Answer:**
I isolated the filter path with simple test measures instead of changing relationships blindly. First I confirmed Channel filtered `FactLeads`; then I confirmed Channel also filtered `LeadStageHistory`; then I tested the effect of `USERELATIONSHIP()` for StageDate. Finally I inspected the measure actually used by the funnel and found that it was using separate historical stage measures rather than the corrected common historical-stage measure. I changed the funnel to use the common measure and apply the selected stage with `SWITCH()` and `CALCULATE()`.

### Q70. Why did you create a common `Historical Stage Leads` measure?

**Answer:**
The common measure centralizes the difficult filter logic: selected LeadIDs, StageDate, the inactive date relationship and controlled filter propagation. The funnel measure then only chooses the requested stage. This avoids duplicating the same filtering logic across Lead Created, Qualified, Demo and Enrolled measures.

### Q71. What does `TREATAS()` do in your historical-stage measure?

**Answer:**
`TREATAS()` takes the LeadIDs selected from `FactLeads` and applies those values as a filter to `LeadStageHistory[LeadID]`. I used it because the historical calculation temporarily disables the normal LeadID filter path with `CROSSFILTER(..., None)`, so the selected LeadIDs need to be transferred explicitly.

### Q72. Why did you use `CROSSFILTER(..., None)`?

**Answer:**
I use it inside the historical calculation to prevent the normal `FactLeads[LeadID]` → `LeadStageHistory[LeadID]` relationship from independently restricting the historical-stage calculation. I then explicitly pass the intended LeadID set using `TREATAS()`. This gives the measure control over the LeadDate versus StageDate filtering paths.

### Q73. Why can the Total in the historical-stage table differ from the sum of the stage rows?

**Answer:**
Each stage row is a distinct count of LeadID within that stage. The same lead can have multiple historical stage records, so a lead can contribute to Lead Created, Qualified, Demo and Enrolled separately. The Total evaluates `DISTINCTCOUNT(LeadID)` in the total filter context; it is not the arithmetic sum of the stage rows.

### Q74. Was the old `Historical Enrolled` measure conceptually wrong?

**Answer:**
Not necessarily. The old measure correctly represented an Enrolled-only calculation using `Stage = "Enrolled"`, StageDate and the controlled LeadID relationship. The change was mainly architectural: the final design centralizes the common historical filtering logic in `Historical Stage Leads` and lets the funnel dynamically apply the stage filter.

---

# 11. Troubleshooting / Model Validation

### Q75. What is your approach when a Power BI number looks wrong?

**Answer:**
First I check the source data and table grain, then the relationship and filter direction, then the visual filters and finally the DAX. I avoid changing the formula blindly because the issue may be in the model.

### Q76. What can an incorrect relationship cause?

**Answer:**
Incorrect counts, duplicated aggregations, filters not behaving as expected, ambiguous paths, unexpected many-to-many behavior and incorrect KPIs.

### Q77. What is the most important practical lesson from this project?

**Answer:**
A correct DAX formula does not guarantee a correct dashboard. The model must provide the correct filter path from the visual to the data being measured.

### Q78. Why should you not force every table to connect?

**Answer:**
Because an artificial relationship can be worse than no relationship. It can create incorrect filter propagation and double counting. I only create relationships supported by business meaning, grain and keys.

---

# 12. Dashboard / Visualization

### Q79. What visuals did you use?

**Answer:**
KPI cards, funnel/current-stage visuals, source/channel breakdowns, slicers and time-based revenue tables. Temporary diagnostic visuals were used during troubleshooting and then removed from the final presentation.

### Q80. What is the purpose of a slicer?

**Answer:**
A slicer provides an interactive filter that allows the user to analyze the report for a selected value such as channel, campaign, geography or time period.

### Q81. What makes a dashboard useful to business stakeholders?

**Answer:**
Clear KPI definitions, reliable data, relevant filters, appropriate visuals, a logical information hierarchy and insights that connect the numbers to business actions.

---

# 13. Cohort Analysis

### Q82. What is cohort analysis?

**Answer:**
Cohort analysis groups entities based on a shared starting event or period, such as acquisition month, and tracks their subsequent behavior over elapsed time.

### Q83. Give a marketing example.

**Answer:**
Group leads by the month they were acquired and compare enrollment or revenue in month 0, month 1, month 2 and so on.

### Q84. Did you implement a cohort funnel in this PBIX?

**Answer:**
Yes. I implemented an acquisition-cohort funnel. The selected Date slicer defines the cohort using `FactLeads[LeadDate]`, and the selected cohort LeadIDs are then matched to later `LeadStageHistory` events. Later stage events are not restricted by the acquisition-date slicer.

I have not yet implemented a full month-0/month-1/month-2 cohort matrix. That is a separate enhancement.

---

# 14. Funnel Types / Historical vs Cohort Logic

### Q85. What are the three funnel concepts in this project?

**Answer:**
There are three distinct analytical patterns:

1. **Current-status funnel:** counts leads by their current `FactLeads[LeadStatus]`.
2. **Historical stage-event funnel:** counts unique leads that had a particular stage event during the selected `LeadStageHistory[StageDate]` period.
3. **Acquisition-cohort funnel:** selects leads by `FactLeads[LeadDate]` and then counts how many of those cohort leads eventually reached each historical stage.

### Q86. Why can the Historical Funnel and Cohort Funnel have different Qualified counts?

**Answer:**
Because they use different date meanings. Historical Funnel asks whether the stage event happened during the selected StageDate period. Cohort Funnel asks whether the lead was acquired during the selected LeadDate period and then allows later stage events outside that acquisition period.

### Q87. Why should you not force the two funnel numbers to match?

**Answer:**
They answer different business questions. Forcing them to match would destroy the meaning of one of the analyses. The important reconciliation is that `Historical Lead Created` and `Cohort Leads` should match for the same acquisition population after the history repair.

### Q88. Why did you need LeadStageHistory?

**Answer:**
`FactLeads[LeadStatus]` represents current state, while CRM activity records represent activities rather than a reliable sequence of official stage transitions. `LeadStageHistory` provides stage events with dates, allowing historical and cohort progression analysis.

### Q89. Why did you repair LeadStageHistory instead of FactLeads?

**Answer:**
`FactLeads` is the trusted acquisition/fact table and was treated as read-only. The problem was that the history table did not contain a Lead Created event for every lead. I repaired the history table by using each lead's existing LeadID and LeadDate from FactLeads to create the missing Lead Created event.

### Q90. Did you invent missing Qualified, Demo or Enrolled dates?

**Answer:**
No. The repair was deliberately conservative. I created/reconciled Lead Created events using the trusted LeadDate and preserved the existing non-Lead-Created history records. I did not invent later-stage dates without source evidence.

### Q91. What DAX techniques were important in the cohort funnel?

**Answer:**
`CALCULATETABLE` was used to capture the cohort LeadIDs, `REMOVEFILTERS(DimDate)` prevented the acquisition-date filter from blocking later stage events, `CROSSFILTER(..., NONE)` prevented an unwanted relationship path during the stage calculation, and `TREATAS()` applied the selected cohort LeadIDs to `LeadStageHistory`.

---

# 15. Segment Analysis

### Q92. What is segment analysis?

**Answer:**
Segment analysis compares business outcomes across meaningful groups such as channel, campaign, city, age band, customer type or lead status.

### Q93. How would you choose segments?

**Answer:**
I start from the business question. I would not create segments just because a column exists. The segment should help explain variation in a KPI or identify an actionable business opportunity.

### Q94. What segments are relevant to this project?

**Answer:**
Channel, campaign, geography, customer type, age band, lead status and acquisition cohort are potential analytical segments.

---

# 16. Drill Down / Drill Through

### Q95. What is Drill Down?

**Answer:**
Drill Down lets a user navigate through a hierarchy within the same visual, such as Year → Quarter → Month → Day.

### Q96. What is Drill Through?

**Answer:**
Drill Through takes the user to a separate report page filtered by the selected entity, such as opening a Campaign Detail page from a campaign-level summary.

### Q97. Did you fully implement these features?

**Answer:**
They were included in the project plan, but I did not fully implement dedicated Drill Down/Drill Through pages before stopping the build.

---

# 17. UAT / Data Validation

### Q98. How would you validate a Power BI dashboard?

**Answer:**
I compare key totals with the source, validate row and distinct-key counts, test filters and relationships, check KPI formulas, validate time-intelligence values and investigate discrepancies by tracing the filter path.

### Q99. What is UAT?

**Answer:**
User Acceptance Testing verifies that the solution meets the agreed business requirements and that users can rely on the results and behavior of the report.

### Q100. What would you validate before delivering this dashboard?

**Answer:**
Lead count, revenue, spend, conversion, CPL, CAC, ROAS, date behavior, channel/campaign filters, source-to-report reconciliation and any business rules used in KPI definitions.

---

# 18. Performance Optimization

### Q101. How would you improve Power BI performance?

**Answer:**
I would first identify the bottleneck using tools such as Performance Analyzer, then reduce unnecessary columns and visuals, maintain a clean star schema, avoid unnecessary bidirectional relationships, optimize expensive DAX and perform suitable transformations upstream.

### Q102. Why can too many calculated columns be a problem?

**Answer:**
Calculated columns are stored in the model and can increase model size. Where a value is a dynamic aggregation, a measure is often more appropriate.

### Q103. Why avoid unnecessary bidirectional relationships?

**Answer:**
They can create ambiguous filter paths and unexpected propagation. Single-direction dimension-to-fact filtering is usually easier to control in a star-style model.

---

# 19. Power BI Service — Interview Essentials

### Q104. What is Power BI Service?

**Answer:**
Power BI Service is the cloud environment used to publish, share, refresh, secure and manage Power BI content after development in Desktop.

### Q105. What is the difference between Power BI Desktop and Power BI Service?

**Answer:**
Desktop is primarily the development environment for data connection, Power Query, modeling, DAX and report creation. Service is used for publishing, collaboration, sharing, refresh, security and deployment/consumption management.

### Q106. What happens when you publish a PBIX to a workspace?

**Answer:**
The report and its semantic model are published to the target workspace, where they can be managed and consumed according to workspace permissions and other sharing controls.

### Q107. What is a workspace?

**Answer:**
A workspace is a collaborative area in Power BI Service where BI content such as reports and semantic models is managed.

### Q108. What is scheduled refresh?

**Answer:**
Scheduled refresh automatically refreshes the semantic model at configured times so report users receive updated data.

### Q109. What is a Gateway?

**Answer:**
A gateway provides a secure connection between Power BI Service and supported on-premises data sources so the Service can refresh or access data that is not directly available in the cloud.

### Q110. What is RLS?

**Answer:**
Row-Level Security restricts the rows of data that a user can access. For example, users could be restricted to seeing only the region or business unit assigned to them.

### Q111. What is the difference between a report and a dashboard?

**Answer:**
A report is a multi-page analytical experience built from a semantic model. A dashboard in the Service is a single-page canvas that can contain pinned tiles from reports and other supported sources.

### Q112. What is a Power BI App?

**Answer:**
An App packages and distributes curated Power BI content to consumers, providing a controlled consumption experience without giving every user direct authoring access to the workspace.

### Q113. What are deployment pipelines?

**Answer:**
Deployment pipelines support controlled promotion of BI content through environments such as development, test and production where the organization's Power BI setup supports them.

### Q114. How would you explain your Power BI Service experience honestly for this project?

**Answer:**
"I have worked through the Desktop development, modeling, DAX and validation side of the project. For Power BI Service, I understand the interview-level concepts around publishing, workspaces, refresh, gateways, RLS and deployment, but I did not make the Service deployment a full hands-on stage of this particular project."

---

# 20. SQL — Project-Based Interview Questions

### Q115. Why is SQL important for this project?

**Answer:**
The Power BI model ultimately depends on structured relational data. SQL can be used to extract, join, aggregate, validate and prepare the data before it reaches Power BI.

### Q116. How would you find the total number of leads in SQL?

```SQL
SELECT COUNT(*) AS total_leads
FROM FactLeads;
```

### Q117. How would you count distinct leads?

```SQL
SELECT COUNT(DISTINCT LeadID) AS total_leads
FROM FactLeads;
```

### Q118. How would you calculate enrolled leads?

```SQL
SELECT COUNT(*) AS enrolled_leads
FROM FactLeads
WHERE LeadStatus = 'Enrolled';
```

### Q119. How would you calculate conversion rate in SQL?

```SQL
SELECT
    100.0 * SUM(CASE WHEN LeadStatus = 'Enrolled' THEN 1 ELSE 0 END)
    / NULLIF(COUNT(*), 0) AS conversion_pct
FROM FactLeads;
```

### Q120. How would you calculate leads by channel?

```SQL
SELECT
    AcquisitionChannel,
    COUNT(*) AS leads
FROM FactLeads
GROUP BY AcquisitionChannel
ORDER BY leads DESC;
```

### Q121. How would you calculate qualified leads by channel?

```SQL
SELECT
    AcquisitionChannel,
    SUM(CASE WHEN LeadStatus = 'Qualified' THEN 1 ELSE 0 END) AS qualified_leads
FROM FactLeads
GROUP BY AcquisitionChannel;
```

### Q122. WHERE vs HAVING?

**Answer:**
`WHERE` filters rows before aggregation. `HAVING` filters grouped results after aggregation.

Example:

```SQL
SELECT AcquisitionChannel, COUNT(*) AS leads
FROM FactLeads
WHERE LeadDate >= '2026-01-01'
GROUP BY AcquisitionChannel
HAVING COUNT(*) > 1000;
```

### Q123. INNER JOIN vs LEFT JOIN?

**Answer:**
`INNER JOIN` returns matching rows from both tables. `LEFT JOIN` keeps all rows from the left table and brings matching rows from the right table when available.

### Q124. Why might a LEFT JOIN be useful in data-quality analysis?

**Answer:**
It can preserve all records from the primary business table while identifying missing matches in a reference or dimension table.

### Q125. What is a CTE?

**Answer:**
A Common Table Expression is a named temporary result set defined with `WITH`. It improves readability and is useful for breaking complex logic into logical steps.

### Q126. What are window functions?

**Answer:**
Window functions calculate values across related rows without collapsing the result set like GROUP BY does. Examples include `ROW_NUMBER`, `RANK`, `DENSE_RANK`, `LAG` and `LEAD`.

### Q127. Difference between ROW_NUMBER, RANK and DENSE_RANK?

**Answer:**
`ROW_NUMBER` gives every row a unique sequence. `RANK` gives tied rows the same rank and leaves gaps after ties. `DENSE_RANK` gives tied rows the same rank without gaps.

### Q128. How would you find the latest record for each LeadID?

```SQL
WITH ranked AS (
    SELECT
        LeadID,
        Stage,
        StageDate,
        ROW_NUMBER() OVER (
            PARTITION BY LeadID
            ORDER BY StageDate DESC
        ) AS rn
    FROM LeadStageHistory
)
SELECT *
FROM ranked
WHERE rn = 1;
```

### Q129. Why is ROW_NUMBER useful for deduplication?

**Answer:**
It allows me to assign an ordered sequence within each business key and then retain the desired record, such as the latest record per LeadID.

### Q130. COUNT(*) vs COUNT(column)?

**Answer:**
`COUNT(*)` counts rows. `COUNT(column)` counts non-null values in that column.

### Q131. How do NULLs affect SQL analysis?

**Answer:**
NULL represents missing/unknown values and does not behave like zero or an empty string. Aggregations and comparisons need to account for NULL explicitly.

### Q132. How would you identify leads with no matching CRM activity?

```SQL
SELECT l.LeadID
FROM FactLeads l
LEFT JOIN CRMActivity c
    ON l.LeadID = c.LeadID
WHERE c.LeadID IS NULL;
```

### Q133. How would you calculate revenue by month?

```SQL
SELECT
    YEAR(LeadDate) AS year_num,
    MONTH(LeadDate) AS month_num,
    SUM(Revenue) AS revenue
FROM FactLeads
GROUP BY YEAR(LeadDate), MONTH(LeadDate)
ORDER BY year_num, month_num;
```

### Q134. How would you investigate duplicate LeadIDs?

```SQL
SELECT
    LeadID,
    COUNT(*) AS row_count
FROM FactLeads
GROUP BY LeadID
HAVING COUNT(*) > 1;
```

### Q135. What would you check if a SQL query is slow?

**Answer:**
I would inspect the execution plan, joins, filters, indexes, row counts, functions applied to indexed columns, unnecessary columns, subqueries/CTEs and whether aggregation can be pushed earlier or data volume reduced.

---

# 21. Business / Scenario Questions

### Q136. Leads increased but enrollments did not. What would you investigate?

**Answer:**
I would examine qualification rate, demo progression, enrollment conversion, channel mix, campaign mix, geography, lead quality, operational capacity and any tracking/data-quality issues.

### Q137. One channel has many leads but poor conversion. What would you check?

**Answer:**
I would compare lead quality, qualified rate, demo rate, enrollment rate, CPL, CAC, spend, revenue, ROAS and sample size. I would not conclude channel effectiveness from lead volume alone.

### Q138. Revenue is high but ROAS is low. How can that happen?

**Answer:**
Revenue may be high in absolute terms while advertising spend is also very high. ROAS evaluates revenue relative to ad spend, so both numbers must be considered together.

### Q139. A stakeholder says the Power BI number is wrong. What do you do?

**Answer:**
I would first understand the exact KPI definition and comparison period, then validate the source number, filters, grain, relationships and DAX. I would reproduce the calculation independently if necessary and explain the discrepancy with evidence.

### Q140. A business user asks for a dashboard with 25 KPIs. What would you do?

**Answer:**
I would clarify the decisions the dashboard needs to support, define the KPI owners and definitions, prioritize the most actionable metrics and separate executive KPIs from detailed diagnostic metrics.

### Q141. How would you explain a technical model to a non-technical stakeholder?

**Answer:**
I would avoid unnecessary technical terminology and explain the model in terms of business entities and events: campaigns describe acquisition, leads represent prospects, activities represent interactions, and revenue represents business outcome. Then I explain how the model supports the requested KPIs.

---

# 22. Project 60-Second Explanation

### Q142. Explain the project in 60 seconds.

**Answer:**
> "I built a Marketing Funnel and Campaign Intelligence solution in Power BI. I started by understanding the business KPIs and the grain of each source table, then used Power Query for data preparation and data-quality checks. I built a star-style model with Campaign, Date and Month dimensions and fact tables for leads, ad spend, CRM activity and budget. I created DAX measures for leads, qualification, demo, enrollment, conversion, revenue, spend, CPL, CAC, ROAS and time intelligence. During validation, I identified that CRM activity could not be treated as official funnel-stage history because it represented activities rather than stage transitions, so I added a separate LeadStageHistory dataset for future historical funnel analysis. I also solved a funnel sorting dependency issue using a dedicated presentation-stage table. The main learning was that correct BI results depend on both correct DAX and correct model/filter design."

---

# 23. Most Important Interview Takeaways

1. **Always start with business requirements.**
2. **Know the grain of every table.**
3. **Validate keys before creating relationships.**
4. **Do not force every table into the model.**
5. **Avoid direct fact-to-fact joins when shared dimensions provide the correct filter path.**
6. **Use Power Query for appropriate data preparation and DAX for analytical calculations.**
7. **Understand filter context before memorizing DAX.**
8. **A correct formula can still return the wrong business result if the model is wrong.**
9. **Current status is not the same as historical stage progression.**
10. **Use a proper Date table for time intelligence.**
11. **Validate dashboard numbers against the source.**
12. **Explain why a technical decision was made, not only what button was clicked.**
13. **Be honest about hands-on vs conceptual experience.**
14. **For interview answers, connect technical work to business impact.**

---

# 24. Historical Study Priority (recorded before the October 18 deployment milestones)

The project foundation is now stable. The next concepts should be learned and implemented in this order:

### Priority 1 — Funnel conversion analysis
- Lead → Qualified %
- Qualified → Demo %
- Demo → Enrolled %
- Lead → Enrolled %
- Understand the difference between current-status, historical-event and acquisition-cohort funnels

### Priority 2 — Campaign / channel performance
- Leads and conversion by channel/campaign
- Ad Spend
- CPL
- CAC
- Revenue
- ROAS
- Identify meaningful performance differences without making unsupported causal claims

### Priority 3 — Time and cohort analysis
- Monthly trends
- Acquisition cohort vs stage-event date
- Full month-0/month-1/month-2 cohort matrix as a separate enhancement

### Priority 4 — Segment analysis
- Geography/city
- Customer type / age band where valid keys and definitions exist
- Channel and campaign segmentation

### Priority 5 — Dashboard engineering
- Drill Down
- Drill Through
- Tooltip/detail views
- Final visual hierarchy and formatting
- UAT checklist

### Priority 6 — Performance and Service
- Performance Analyzer
- DAX/model optimization
- Power BI Service publishing
- Refresh / Gateway
- RLS
- Workspace / App
- Deployment pipelines

### Priority 7 — Business storytelling
Turn the final dashboard into a small set of evidence-based findings: what happened, where it happened, possible drivers, and what additional data would be needed before taking action.

**Important:** For the hands-on build, continue improving the existing model and dashboard rather than changing `FactLeads`.



# 2026-10-01 — New Project-Based Interview Questions from Latest Hands-On Work

> These questions are derived from the latest hands-on project work. They should be presented as project-based interview questions unless the user has separately confirmed that an interviewer asked the exact question.

## 25. Advanced DAX / Filter Context

### Q143. Why did you use `CALCULATETABLE` instead of `CALCULATE` when capturing LeadIDs?

**Answer:**
I needed a table of selected LeadIDs rather than a single scalar value. `CALCULATETABLE` evaluates a table expression under a modified filter context, while `CALCULATE` returns a scalar expression.

### Q144. Why did you use `REMOVEFILTERS(DimDate)` when building `SelectedLeadIDs`?

**Answer:**
The selected Date should control the historical stage-event date separately. When I capture the cohort/selected LeadIDs, I remove the Date filter so that the acquisition population is not accidentally restricted by the later StageDate calculation.

### Q145. What does `TREATAS` do in this project?

**Answer:**
It takes the selected LeadID values from `FactLeads` and applies them as a filter to `LeadStageHistory[LeadID]`. This gives me an explicit filter path when the normal LeadID relationship is temporarily disabled for the historical calculation.

### Q146. Why did you use `USERELATIONSHIP`?

**Answer:**
`DimDate[Date]` has an inactive relationship to `LeadStageHistory[StageDate]`. The model already has an active acquisition-date relationship to `FactLeads[LeadDate]`. For historical stage analysis, I need the report Date filter to operate on StageDate, so I activate the inactive relationship inside the measure with `USERELATIONSHIP`.

### Q147. Why did you use `CROSSFILTER(..., NONE)`?

**Answer:**
I wanted to prevent the normal `FactLeads[LeadID]` → `LeadStageHistory[LeadID]` relationship from independently restricting the historical calculation. I then explicitly controlled the LeadID filter with `TREATAS`.

### Q148. What is the difference between `VALUES` and `DISTINCTCOUNT` in this solution?

**Answer:**
`VALUES(FactLeads[LeadID])` returns the distinct LeadID values as a table, which I can pass to `TREATAS`. `DISTINCTCOUNT(LeadStageHistory[LeadID])` returns a single number representing the number of unique leads that satisfy the historical stage filters.

### Q149. Why use `VAR` in these measures?

**Answer:**
Variables make the DAX easier to read, allow me to calculate a value once and reuse it, and make complex filter-context logic easier to debug.

---

## 26. Funnel Definitions and Business Semantics

### Q150. What is the difference between a current-status funnel and a historical funnel?

**Answer:**
A current-status funnel counts leads according to their current `FactLeads[LeadStatus]`. A historical funnel counts unique leads that had a particular stage event during the selected `LeadStageHistory[StageDate]` period. They answer different business questions.

### Q151. What is the difference between a historical funnel and an acquisition-cohort funnel?

**Answer:**
The historical funnel asks what stage events happened during the selected period. The acquisition-cohort funnel first selects leads acquired during the selected `FactLeads[LeadDate]` period and then follows those leads into later historical stage events, even when the later events happen after the acquisition period.

### Q152. Why can the Cohort Funnel and Historical Funnel have the same numbers?

**Answer:**
For a broad or full reporting period they can converge because most of the relevant acquisition and stage events fall within the same overall window. Equal results do not mean the calculations are identical. A shorter date range demonstrates the different date semantics.

### Q153. Why can they differ for the same date range?

**Answer:**
Later-stage events for an acquisition cohort may happen after the selected acquisition-date range. The cohort funnel can still count those later events, while the historical funnel excludes events whose StageDate falls outside the selected reporting window.

### Q154. Why did you not force the two funnel calculations to match?

**Answer:**
Because they represent different business definitions. Forcing them to match would remove the distinction between acquisition-cohort progression and historical stage activity.

---

## 27. DAX Measure Design and Cross-Page Safety

### Q155. Why did you create `KBI Historical Funnel Performance` instead of modifying `KBI Funnel Performance`?

**Answer:**
`KBI Funnel Performance` was already used by the cohort-based Executive Overview. Page 2 needed the same insight pattern but based on historical conversion measures. I created a separate measure so Page 1 would remain unchanged and each page could keep a clear business definition.

### Q156. Why did you change the Page 2 cards without changing the existing conversion measures?

**Answer:**
The existing conversion measures are based on current-status KPIs and may be useful elsewhere. I reused the already-correct historical conversion measures and changed only the fields used by the Page 2 visuals. This avoided unintended changes to other pages.

### Q157. Why use “Rename for this visual” in Power BI?

**Answer:**
It lets me give a stakeholder-friendly display label without changing the underlying model measure name. For example, `Historical Qualified Conversion %` can display as `Lead → Qualified` on one visual while the model measure remains reusable elsewhere.

---

## 28. Dashboard Design / Stakeholder Thinking

### Q158. How did you decide what belongs on the Executive Overview?

**Answer:**
I started from stakeholder questions rather than trying to fill the page. The Executive Overview focuses on overall acquisition, funnel progression, trend, channel performance and concise business insights. Diagnostic or technical analysis is moved to later pages.

### Q159. Why did you separate the Executive Overview and Funnel & Conversion pages?

**Answer:**
The Executive Overview answers how the business is performing overall using acquisition-cohort metrics. The Funnel & Conversion page goes deeper into historical stage progression and stage-to-stage conversion. Separating them prevents the executive page from becoming crowded and keeps metric definitions clear.

### Q160. Why is consistent metric definition important within a page?

**Answer:**
If a card uses a current-status calculation while the adjacent funnel uses a historical-event calculation, stakeholders may see different numbers and assume the report is wrong. Within a page, visuals should normally use the same business definition unless the difference is explicitly intentional and explained.

### Q161. How did you validate that the historical Channel filter was working?

**Answer:**
I tested the same Date range with All Channels, Google and LinkedIn. The historical stage counts and conversion cards changed appropriately. I also compared the results with the funnel and trend visuals to ensure they followed the same filter context.

### Q162. What was an important lesson from the Channel-filter issue?

**Answer:**
A relationship can exist in the model and still not provide the required filter behavior inside a complex measure. I need to trace the actual filter path and understand how `CALCULATE`, inactive relationships and `CROSSFILTER` change that path.

---

## 29. Page 2 Final Interview Story

### Q163. Explain the Funnel & Conversion page in an interview.

**Answer:**
> "The Funnel & Conversion page focuses on historical stage progression. I use LeadStageHistory because current lead status and CRM activity cannot reliably represent the complete historical journey. The page has historical stage-to-stage conversion cards, a historical funnel, stage breakdown and monthly conversion trends. I had to explicitly control filter context so both Date and Channel filters worked correctly: I captured the selected LeadIDs, activated the StageDate relationship with USERELATIONSHIP, disabled the normal LeadID filter path with CROSSFILTER and applied the selected LeadIDs with TREATAS. I kept the cohort and historical definitions separate so the Executive Overview remains cohort-based while this page answers historical stage-activity questions."

---

# 30. Historical Study Status Update (early October 2026)

### Completed in the latest hands-on work
- Executive Overview page design and validation
- Cohort-based Page 1 KPI hierarchy
- Cohort KBI logic
- Historical Funnel filter-context troubleshooting
- Date + Channel behavior for historical stage measures
- Historical stage-to-stage conversion measures
- Historical conversion cards
- Historical KBI measure
- Page 2 visual formatting and layout
- Current-status vs historical vs cohort funnel distinction
- Cross-page DAX dependency awareness

### Next priority
**Channel & Campaign Performance**

Planned topics:
- Channel vs Campaign analysis
- Leads, Qualified, Demo, Enrolled
- Conversion
- Ad Spend
- CPL / CAC
- Revenue
- ROAS
- Campaign-level investigation
- Conditional formatting and stakeholder storytelling

### Later
- Marketing Efficiency & Revenue
- Cohort / segment analysis
- Drill Down / Drill Through
- Tooltips / detail views
- Data Quality / UAT page
- Performance Analyzer and optimization
- Power BI Service hands-on concepts

**Important:** Continue improving the existing model. Do not modify `FactLeads` unless a future change is supported by source evidence and explicitly required.


# 23. Page 3 — Channel & Campaign Performance: Important Interview Questions

### Q143. Why did you create a separate Channel & Campaign Performance page when Page 1 already has channel metrics?

**Answer:**
Page 1 is the executive overview, so it focuses on the overall acquisition funnel, revenue, spend and high-level channel performance. Page 3 is a diagnostic performance page that goes deeper into channel and campaign comparison, including campaign-level detail and dynamic business insights.

### Q144. Which KPIs did you use on Page 3 and why?

**Answer:**
I used Leads, Enrolled, Conversion %, Ad Spend, Revenue and ROAS. Together they cover volume, funnel outcome, conversion efficiency, investment, financial outcome and marketing efficiency.

### Q145. What are the exact Revenue and Ad Spend definitions in the project?

**Answer:**
Revenue is sourced from `FactLeads[Revenue]` and Ad Spend is sourced from `FactAdSpend[AdSpend]`:

```DAX
Revenue = SUM(FactLeads[Revenue])
Ad Spend = SUM(FactAdSpend[AdSpend])
ROAS = DIVIDE([Revenue], [Ad Spend], 0)
```

I kept these definitions consistent across pages so stakeholders do not see different definitions of the same KPI.

### Q146. Why did you use a Channel → Campaign hierarchy in the Campaign Performance matrix?

**Answer:**
It allows the stakeholder to start at channel level and expand to individual campaigns within the same visual. It provides summary and detail without requiring separate visuals for every level.

### Q147. Why did you not add Channel as a separate value column in the campaign table?

**Answer:**
A Channel → Campaign row hierarchy makes the relationship between the two levels explicit and supports drill/expand behavior. It is easier to scan than repeating the channel name on every campaign row.

### Q148. Why did you copy the Channel Performance matrix to create Campaign Performance?

**Answer:**
The two visuals use the same KPI definitions and formatting. Copying the visual preserved the established formatting, conditional formatting and display-unit conventions. I then changed the row hierarchy to Channel → Campaign.

### Q149. How did you make the Conversion % and ROAS columns easier to compare?

**Answer:**
I used conditional background-color gradients. The formatting is applied to the displayed values only, while the underlying measures remain unchanged. This gives a quick visual signal without adding another chart.

### Q150. Why are Revenue and Ad Spend displayed using Millions and Thousands?

**Answer:**
They are large monetary values, so compact display units improve readability in the matrix. Revenue is shown in Millions and Ad Spend in Thousands. This is only presentation formatting; the underlying measures remain the same.

### Q151. How did you identify the campaign generating the most leads?

**Answer:**
I used `VALUES(DimCampaign[CampaignName])` to get the campaigns in the current filter context, `ADDCOLUMNS` to calculate cohort leads for each campaign, `TOPN(1, ...)` to identify the highest-lead campaign, and `MAXX` to extract the campaign name and value for the final text output.

### Q152. How did you identify the campaign with the highest ROAS?

**Answer:**
The logic is similar. I calculated `[ROAS]` for each campaign in the current filter context, used `TOPN` to identify the highest value and `MAXX` to return the campaign name and ROAS in a stakeholder-friendly sentence.

### Q153. Why use a DAX text measure for the Key Business Insights panel?

**Answer:**
It makes the insight dynamic. If the user changes the Date Range or Channel slicer, the selected campaign and its metric can change automatically. The insight therefore reflects the current analytical context rather than being hard-coded text.

### Q154. Why did you test the KBI measures in temporary Card visuals first?

**Answer:**
It separates logic validation from presentation work. I first verified that the DAX returned the expected campaign and value, then removed the temporary test visual and used the measure in the final KBI panel.

### Q155. Why didn't you add another chart just to use the empty space on the right side?

**Answer:**
I prefer business relevance over filling canvas space. The page already answers the channel and campaign questions through KPIs, matrices and dynamic insights. Adding a chart without a distinct business question could increase visual noise rather than value.

### Q156. How did you validate Page 3 after changing the Date Range during layout work?

**Answer:**
I restored the Date Range to the full dataset period and checked that the KPI cards, Channel Performance matrix, Campaign Performance matrix and KBI outputs reconciled. The full-range context returned 30,000 leads, 2,054 enrollments, 6.85% conversion and 10.17 ROAS.

### Q157. If a stakeholder asks why Page 3 has different values after changing the Date slicer, what would you explain?

**Answer:**
The measures are filter-context dependent. Changing the Date Range changes the cohort population and therefore changes the number of leads, enrollments, revenue and other metrics shown. I would first confirm the selected period and KPI definition before treating the difference as a data issue.

### Q158. What is the difference between a visual-level display unit and changing the underlying measure?

**Answer:**
Display units such as Thousands or Millions only change how a value is presented in the visual. They do not change the DAX calculation or the underlying data.

### Q159. What did you learn from building the campaign page?

**Answer:**
I learned that dashboard design is not just about adding visuals. The page needs a clear analytical hierarchy: summary KPIs, channel comparison, campaign detail and concise insights. I also reinforced the importance of maintaining consistent KPI definitions and validating dynamic DAX measures before presenting them to stakeholders.

---

# 25. Page 4 — Marketing Efficiency & Revenue: Important Interview Questions

### Q160. Why did you create a separate Marketing Efficiency & Revenue page?

**Answer:**
Page 3 focuses on channel and campaign comparison. Page 4 focuses on the economics of marketing investment: spend, revenue, ROAS, CPL, CAC and acquisition-to-enrollment conversion. The separate page keeps the analytical story focused instead of combining too many questions into one page.

### Q161. Why is ROAS one of the primary KPIs on Page 4?

**Answer:**
ROAS connects revenue to advertising investment. In this project it is calculated as Revenue divided by Ad Spend, so it provides a direct efficiency view alongside the absolute spend and revenue KPIs.

### Q162. Which KPIs did you use on Page 4?

**Answer:**
Ad Spend, Revenue, ROAS, CPL, CAC and Conversion %. Together they cover investment, business outcome, return efficiency, lead acquisition cost, enrolled-customer acquisition cost and acquisition-to-enrollment efficiency.

### Q163. Did you create a new ROAS measure for Page 4?

**Answer:**
No. I reused the existing project measure because the business definition did not change:

```DAX
ROAS =
DIVIDE(
    [Revenue],
    [Ad Spend],
    0
)
```

This avoids unnecessary duplicate measures and keeps the KPI definition consistent across pages.

### Q164. Why did you use a separate Monthly ROAS Trend instead of putting ROAS into the Spend vs Revenue visual?

**Answer:**
Spend and revenue answer an investment-versus-output question, while ROAS answers an efficiency question. Keeping ROAS in a separate line chart makes the trend easier to interpret and avoids overloading one visual with three different analytical meanings.

### Q165. What does the Monthly Spend vs Revenue visual show?

**Answer:**
It compares monthly advertising spend and revenue over time. Ad Spend is shown as columns and Revenue as a line, using `DimDate[YearMonth]` on the x-axis.

### Q166. Why does September 2026 appear lower in the monthly charts?

**Answer:**
The final dataset ends on 15-Sep-2026, so September is a partial month. I would not interpret it as a full-month performance result without accounting for the incomplete period.

### Q167. How did you compare channel ROAS?

**Answer:**
I used a clustered bar chart with Channel on the category axis and `[ROAS]` as the measure, sorted descending. This provides a direct comparison of return efficiency across channels.

### Q168. How did you compare campaign ROAS?

**Answer:**
I used the same approach at campaign grain: `DimCampaign[CampaignName]` with `[ROAS]`, sorted descending. This allows the stakeholder to investigate campaign-level efficiency within the broader channel view.

### Q169. Why did you add Revenue by Channel in addition to Channel ROAS?

**Answer:**
ROAS measures efficiency relative to spend, while Revenue shows the absolute financial contribution. A channel can have a strong ROAS without being the largest revenue contributor, so the two views answer different questions.

### Q170. Why did you use a scatter chart for Revenue vs Ad Spend by Channel?

**Answer:**
A scatter chart is appropriate for the relationship between two numeric variables. Here the x-axis is Ad Spend, the y-axis is Revenue and each point represents a channel. It provides a visual way to compare investment and revenue simultaneously.

### Q171. Why didn't you add more fields to the scatter chart just to make it look fuller?

**Answer:**
Because each visual should have a distinct business purpose. Adding unrelated fields can reduce clarity. The four channel points are sufficient for the intended spend-versus-revenue relationship view.

### Q172. Which KBI measures are used on Page 4?

**Answer:**
I reused the existing `KBI Top Campaign by ROAS` measure from Page 3 and created a new `KBI Top Revenue Channel` measure. The two insights are deliberately different: one highlights efficiency at campaign level and the other highlights absolute revenue contribution at channel level.

### Q173. Why did you reuse KBI Top Campaign by ROAS instead of creating another copy?

**Answer:**
The existing measure already answered the same business question and responded correctly to filter context. Reusing it avoids duplicate DAX logic and reduces maintenance risk.

### Q174. How did you build KBI Top Revenue Channel?

**Answer:**
I used `VALUES(DimCampaign[Channel])` to get the visible channels, `ADDCOLUMNS` to calculate Revenue for each channel, `TOPN(1, ...)` to select the highest-revenue channel and `MAXX` to extract the channel name and value for the final dynamic sentence.

### Q175. How did you make the revenue KBI display millions correctly?

**Answer:**
The underlying Revenue measure remains unchanged. In the text KBI I divide the selected revenue value by 1,000,000 and then append the `M` suffix. This is presentation formatting only.

### Q176. Why are the KBI results not universal conclusions?

**Answer:**
They are calculated in the current filter context. Changing the Date Range or Channel slicer can change the selected campaign or channel and its metric. The KBI should therefore be interpreted as an insight about the current filtered view.

### Q177. What design principle did you apply to the Page 4 layout?

**Answer:**
I structured the page as Investment → Revenue → Return → Acquisition Cost → Customer Acquisition Cost → Conversion, followed by time trends, channel/campaign efficiency views and a concise KBI conclusion. I also kept intentional whitespace rather than adding visuals without a distinct business question.

### Q178. Why should you check copied visuals after creating a new page?

**Answer:**
Copying a visual preserves formatting and fields, but it can also preserve labels or titles that belong to the previous page. On Page 4 I explicitly checked the title and corrected it to `Marketing Efficiency & Revenue` so the page heading matched its analytical purpose.

### Q179. What did you learn from building Page 4?

**Answer:**
I reinforced that a good dashboard page should have one clear analytical purpose, reuse established KPI definitions where appropriate, use separate visuals for distinct business questions and end with concise dynamic insights rather than simply adding more charts.


# 24. Page 3 DAX / Technical Interview Quick Revision

### `TOPN`
Used to return the top rows from a table based on a specified expression. In this project it identifies the campaign with the highest Leads or ROAS.

### `ADDCOLUMNS`
Adds calculated columns to a table expression. In the KBI measures it creates a temporary campaign-level table containing the metric used for ranking.

### `MAXX`
Iterates over a table and returns the maximum expression result. In the KBI measures it is used to extract the campaign name/value from the one-row `TOPN` result.

### `VALUES`
Returns the distinct campaign names visible in the current filter context.

### Filter context
The KBI measures respond to the report's Date Range and Channel filters because the campaign table is evaluated in the current filter context.

### Business principle
A dynamic insight should describe the current filtered view and should not be presented as a universal conclusion outside that context.


# 2026-10-02 — New Project-Based Interview Questions from Page 5

## 26. Cohort & Segment Analysis

### Q180. What is the purpose of Page 5 in your Power BI project?

**Answer:**
Page 5 focuses on acquisition cohorts and segment-level performance. It answers how conversion changes across acquisition months and how funnel progression differs by channel, without repeating the headline KPI cards already covered on the earlier pages.

### Q181. Why did you not add another KPI row to Page 5?

**Answer:**
The primary KPIs were already established on Pages 1–4. Page 5 has a different analytical purpose, so I used cohort trends, channel charts, a funnel comparison matrix and a dynamic segment insight instead of repeating the same headline metrics.

### Q182. What does Acquisition Cohort Conversion Trend represent?

**Answer:**
It shows acquisition-to-enrolled conversion for leads grouped by their acquisition month. The Date axis defines the cohort through `FactLeads[LeadDate]`, and the cohort measures follow those selected leads into later funnel stages.

### Q183. Why can a recent acquisition cohort show lower conversion?

**Answer:**
A recent cohort may not have had enough time to progress from lead creation to qualification, demo and enrollment. Therefore, a lower recent-cohort conversion should not automatically be interpreted as a deterioration in performance, especially when the reporting period is still open or partial.

### Q184. What is the difference between Channel Funnel Comparison and the historical funnel on Page 2?

**Answer:**
Page 5 uses acquisition-cohort measures, so the channel comparison asks how leads acquired through each channel progressed to later stages. Page 2's Historical Funnel is based on stage-event dates. They answer different business questions and therefore do not need to produce identical stage counts.

## 27. Dynamic KBI and Filter Context

### Q185. How did you build the Segment Insight KBI?

**Answer:**
I used `VALUES(DimCampaign[Channel])` to capture the channels in the current filter context, `ADDCOLUMNS` to calculate cohort conversion for each visible channel, `TOPN` to identify the highest conversion when multiple channels are available, and `MAXX` to extract the channel name and conversion value for the dynamic text.

### Q186. Why did you change the KBI logic for a single selected channel?

**Answer:**
When exactly one channel is selected, there is no meaningful ranking to perform because the comparison set contains only that channel. I therefore made the measure explicitly report that selected channel's conversion. When multiple channels are selected, the measure identifies the highest-converting channel among the selected channels.

### Q187. What filter-context issue did you find while validating the Segment Insight?

**Answer:**
The KBI initially responded to the Date filter but did not behave as expected when the Channel slicer was changed. I checked the visual interaction first and ensured the Channel slicer filtered the Segment Insight. I then adjusted the measure so its wording and logic distinguish between a single selected channel and a multi-channel comparison.

### Q188. What does `VALUES(DimCampaign[Channel])` return in this KBI?

**Answer:**
It returns the distinct channels visible in the current filter context. If Google is selected, the table contains Google. If multiple channels are selected, it contains those selected channels. With no channel restriction, it contains the channels available in the current report context.

### Q189. Why is visual interaction important when debugging DAX?

**Answer:**
A measure can be logically correct but still appear not to respond to a slicer if the visual interaction is disabled. I therefore check both the DAX filter context and the report-level visual interaction settings before changing the calculation.

## 28. Dashboard Design / Page 5

### Q190. Why did you keep intentional whitespace on Page 5?

**Answer:**
I prefer a clear visual hierarchy over filling every available area. Additional visuals should answer a distinct business question; otherwise they can increase cognitive load without adding useful information.

### Q191. What formatting standards did you apply to Page 5?

**Answer:**
I standardized white backgrounds, light-grey 1 px borders, consistent chart title typography, slicer formatting, matrix readability, aligned visual rows and a consistent Key Business Insights panel.

### Q192. What is an important business caveat for the September 2026 cohort?

**Answer:**
The dataset ends on 15-Sep-2026, so September is a partial month. I would not compare it directly with complete months without accounting for the incomplete reporting period.

### Q193. What did Page 5 teach you about dashboard design?

**Answer:**
Each page should have a distinct business purpose. Page 5 reinforced that cohort and segment analysis can be more useful than repeating executive KPIs, and that filter behavior should be validated from the user's perspective, not only from the DAX formula.

# 2026-10-05 — New Project-Based Interview Questions from Page 6

## 29. Data Quality & Validation

### Q194. Why did you create a separate Data Quality & Validation page?

**Answer:**
I wanted a dedicated page to demonstrate that the report is reliable, not just visually attractive. It validates lead IDs, dates, stage history, relationships, financial fields and business-rule consistency so stakeholders can see whether the underlying data passes key checks.

### Q195. What is the purpose of the Overall Data Quality Status KPI?

**Answer:**
It provides a single dynamic PASS or CHECK result based on multiple validation measures. Instead of asking a stakeholder to inspect many individual cards, the KPI summarizes whether all defined integrity checks are currently passing.

### Q196. Why did you not hardcode 30,000 as the required number of leads in the overall status?

**Answer:**
Because the dataset can grow. I validate integrity conditions such as duplicates, blanks and orphan records rather than assuming the total number of leads must always remain 30,000.

### Q197. What did `ALL(DimDate)` teach you?

**Answer:**
`ALL(DimDate)` removes filters from the DimDate table. In the validation measures I used it so the minimum and maximum calendar dates come from the complete calendar, even if a Date Range slicer is currently selecting only part of the period.

### Q198. What is the difference between `VAR` and `RETURN` in DAX?

**Answer:**
`VAR` creates an intermediate value that can be reused later in the measure. `RETURN` defines the final expression that produces the measure result. For example, I stored the minimum and maximum calendar dates in variables and then used them in the validation condition.

### Q199. What does `||` mean in DAX?

**Answer:**
`||` means OR. In the date validation, it checks whether a date is before the minimum calendar date OR after the maximum calendar date.

### Q200. How did you validate dates in FactLeads?

**Answer:**
I checked for blank LeadDate values and then checked whether any LeadDate fell outside the complete DimDate calendar range. Both checks returned zero in the current dataset.

### Q201. How did you validate LeadStageHistory dates?

**Answer:**
I checked for blank StageDate values and for StageDate values outside the DimDate calendar range. Both validations returned zero.

### Q202. How did you validate that Lead Created dates are correct?

**Answer:**
For each Lead Created history record, I compared its StageDate with the corresponding FactLeads LeadDate. The mismatch count was zero, confirming that the historical Lead Created events align with acquisition dates.

### Q203. How did you validate the Lead Created event count?

**Answer:**
I compared the unique lead count in FactLeads with the Lead Created event count in LeadStageHistory. Both were 30,000, so the reconciliation difference was zero.

### Q204. How did you validate the funnel logically?

**Answer:**
I checked that the stage counts follow the expected decreasing order: Lead Created must be greater than or equal to Qualified, Qualified greater than or equal to Demo, and Demo greater than or equal to Enrolled. The current data passes this rule: 30,000 → 9,561 → 5,268 → 2,054.

### Q205. Why is a funnel consistency check different from a duplicate check?

**Answer:**
A duplicate check validates technical uniqueness. A funnel consistency check validates a business rule. Both are important because data can be technically clean but still violate expected business logic.

### Q206. What does Stage Count Reconciliation validate?

**Answer:**
It confirms that all 46,883 LeadStageHistory records belong to one of the four expected stages: Lead Created, Qualified, Demo or Enrolled. The reconciliation difference is zero.

### Q207. How did you validate campaign relationships?

**Answer:**
I used `EXCEPT` to compare the unique CampaignIDs in each fact table with the CampaignIDs in DimCampaign. Both FactLeads and FactAdSpend returned zero orphan CampaignIDs.

### Q208. Why is `EXCEPT` useful for data-quality validation?

**Answer:**
`EXCEPT` returns values that exist in the first table but not in the second. It is useful for finding orphan keys, such as a CampaignID present in a fact table but missing from the corresponding dimension.

### Q209. How did you validate Revenue?

**Answer:**
I checked for negative Revenue records and blank Revenue records. Both returned zero. This provides a basic integrity check before using Revenue in ROAS and efficiency analysis.

### Q210. How did you validate Ad Spend?

**Answer:**
I checked for negative Ad Spend, blank Ad Spend, blank Ad Spend dates and Ad Spend dates outside the DimDate calendar. All returned zero. I also checked for orphan CampaignIDs in FactAdSpend, which returned zero.

### Q211. Why did you not automatically classify a negative revenue value as an error?

**Answer:**
Negative revenue could represent a legitimate business event such as a refund or reversal. The validation first identifies whether negative values exist. If they did, I would investigate the business meaning before declaring them invalid.

### Q212. What were the final results of the Page 6 validation?

**Answer:**
All defined validation checks passed. Duplicate, blank, orphan, date-range, stage, reconciliation, revenue and Ad Spend checks returned zero where zero was the expected integrity result, the funnel consistency check returned PASS, and the Overall Data Quality Status returned PASS.

## 30. Page 6 Dashboard Design

### Q213. Why did you use cards for Page 6 instead of charts?

**Answer:**
Most validation questions are binary or count-based: how many duplicates, blanks, orphan records or mismatches exist? Cards communicate these checks more directly than charts. I retained one reconciliation table because stage counts are easier to inspect as a small table.

### Q214. Why did you group the validation cards into sections?

**Answer:**
Grouping reduces cognitive load. Lead Integrity covers IDs and campaign relationships, Date & History Integrity covers dates and historical records, and Business Validation covers stage, funnel, financial and Ad Spend rules.

### Q215. Why did you keep the KPI cards white with light borders?

**Answer:**
The rest of the dashboard uses a clean professional style. White cards with subtle borders separate validation metrics without adding unnecessary visual noise. I used emphasis mainly for PASS values rather than coloring every zero.

### Q216. Why did you keep whitespace on Page 6?

**Answer:**
I did not want to add decorative visuals just to fill the canvas. Every visual should answer a validation or business question. Intentional whitespace makes the validation sections easier to scan.

### Q217. Why is the Stage Reconciliation Table useful when the cards already show stage checks?

**Answer:**
The table provides a direct reconciliation view: Lead Created 30,000, Qualified 9,561, Demo 5,268 and Enrolled 2,054, totaling 46,883. It gives stakeholders the underlying stage counts behind the reconciliation result.

### Q218. What would you do if Overall Data Quality Status changed from PASS to CHECK after a refresh?

**Answer:**
I would inspect the individual validation cards to identify which rule failed, then trace that issue back to the relevant source table, relationship, transformation or business definition. I would not immediately change the DAX just to force the status back to PASS.

### Q219. What is the main lesson from Page 6?

**Answer:**
A professional BI report needs both analysis and trust. The analytical pages explain performance, while the validation page provides evidence that the underlying data and model are behaving consistently.

# 31. Historical Study Status After Page 6 (5 October 2026)

### Completed

- Executive Overview
- Funnel & Conversion
- Channel & Campaign Performance
- Marketing Efficiency & Revenue
- Cohort & Segment Analysis
- Data Quality & Validation

### Next priority

Final UAT / dashboard quality review, including checking slicer behavior, KPI consistency, visual interactions, date-context behavior and page-to-page metric definitions.

### Later

- Drill Down / Drill Through where it adds a genuine business workflow
- Power BI Service deployment if required
- Final business storytelling and presentation refinement


# 2026-10-06 — Relationship Modeling and Refresh Troubleshooting Interview Questions

### Q146. Why did you keep the `DimDate → LeadStageHistory[StageDate]` relationship inactive?

**Answer:**
I have two different business dates: `FactLeads[LeadDate]` is acquisition date, while `LeadStageHistory[StageDate]` is the date of a stage event. The acquisition-date relationship remains active for cohort analysis. I keep StageDate inactive to avoid an unwanted competing date path and activate it with `USERELATIONSHIP()` for historical stage-event calculations.

### Q147. What is the difference between an active and inactive relationship in DAX?

**Answer:**
An active relationship is used automatically when its filter path applies. An inactive relationship is not used automatically; I explicitly activate it inside `CALCULATE()` with `USERELATIONSHIP()`.

### Q148. Why is `FunnelStages` disconnected?

**Answer:**
It is a helper/control table rather than transactional data. It contains `Leads`, `Qualified`, `Demo` and `Enrolled` plus `StageOrder`. The funnel measure reads the selected stage with `SELECTEDVALUE()` and calculates the corresponding metric, so a physical relationship is unnecessary.

### Q149. Why is `DimCustomer` disconnected?

**Answer:**
`FactLeads` does not contain `CustomerID`, so there is no valid relationship key. I did not create an artificial relationship just to connect every table.

### Q150. How did you validate the Power BI relationships?

**Answer:**
I checked cardinality, filter direction, the unique side, table grain and business purpose for each relationship. I also verified the intentional inactive StageDate relationship and the disconnected `FunnelStages` and `DimCustomer` tables. The audit passed without relationship changes.

### Q151. What did you do after the relationship audit?

**Answer:**
I performed a full Power BI Desktop refresh. It completed successfully with no errors. I then treat business validation separately because a technically successful refresh does not automatically prove that KPI results are correct.

### Q152. What are common causes of Power BI refresh failures?

**Answer:**
Common causes include missing or moved source files, changed source schema or column names, data-type conversion errors, Power Query transformation errors, model/evaluation or dependency problems, invalid relationships, database connectivity or credentials, and Power BI Service/Gateway configuration. I first read the exact error and locate the first failing step rather than changing unrelated DAX.

### Q153. What does “Waiting for other queries” mean during refresh?

**Answer:**
It does not necessarily mean those queries are independently broken. A query may be waiting because an upstream query failed. I investigate the original error first, fix the root cause and then refresh the dependent queries.

### Q154. Does a successful refresh guarantee correct business numbers?

**Answer:**
No. It confirms that Power BI processed the model and data successfully, but I still need to validate definitions, grain, relationships, filter context and KPI reconciliation.

### Q155. What refresh issue did you encounter in this project?

**Answer:**
I previously encountered a cyclic-reference evaluation error during refresh. I checked Power Query dependencies, DAX/calculated columns, relationships and hidden date-table behavior, then identified Power BI Auto date/time as the cause. I disabled Auto date/time and the refresh completed successfully. The project now uses the explicit `DimDate` table.


# 2026-10-06 — Refresh Failure Troubleshooting Interview Questions

### Q. What would you do if a Power BI refresh failed?

**Answer:**
I would not immediately change the model. First, I would read the exact error message and identify the first table or query that failed. If other queries show “Waiting for other queries,” I would treat them as possible consequences. Then I would check the source connection, file path or database credentials, schema changes such as renamed or missing columns, data types and Power Query Applied Steps. If the source and Power Query are fine, I would investigate model evaluation, DAX, calculated columns, relationships and environment settings. After fixing the root cause, I would refresh again and validate the resulting business KPIs.

### Q. What are common reasons for a Power BI refresh failure?

**Answer:**
Common categories include source-file or database connection problems, changed or missing columns, data-type errors, failed Power Query transformations, credential or network issues, model/DAX evaluation problems, relationship or dependency problems, and Power BI environment/settings issues.

### Q. What does “Waiting for other queries” mean during refresh?

**Answer:**
It does not necessarily mean those queries are independently broken. A query may be waiting because it depends on another query that failed first. I would identify the first actual error and investigate that root cause before changing the dependent queries.

### Q. Tell me about a refresh issue you actually faced in your Power BI project.

**Answer:**
During the project, `FactLeads` reported “A cyclic reference was encountered during evaluation,” while other queries showed “Waiting for other queries.” I investigated Power Query dependencies, DAX/calculated columns, sorting and relationships. The issue was ultimately caused by Auto date/time. I disabled Auto date/time under Current File → Data Load, refreshed the model again, and the refresh completed successfully.

### Q. If refresh succeeds, does that mean the report is correct?

**Answer:**
No. A successful refresh means Power BI was able to process the source and model successfully. I still need to validate the business results using reconciliation checks, row counts, keys, relationships, KPI definitions and expected totals. In this project, the Data Quality & Validation page is used for that purpose.

### Q. What is your general refresh troubleshooting framework?

**Answer:**
**Error → first failing component → source/schema → data types/transformation → model/DAX/relationships → environment/settings → fix root cause → refresh → business validation.**


## Bookmarks, Selection Pane, and Button Actions

### Q. What is the Selection pane in Power BI?

**Answer:**
The Selection pane lists objects on a report page and lets the author select them, show or hide them, and manage their layer order. Hiding an object does not delete it. In my Marketing Funnel & Campaign Intelligence project, I used it to control the visibility of the Date Range slicer, Channel slicer, and two filter-panel buttons.

### Q. What is a bookmark in Power BI?

**Answer:**
A bookmark saves a configured report state. Depending on its settings, it can remember data/filter state and the display state of visuals. I created `Filters Open` and `Filters Closed` bookmarks on my Channel & Campaign Performance page to show or hide slicers and switch which button is visible.

### Q. What is the difference between Data and Display in a bookmark?

**Answer:**
**Data** controls whether the bookmark captures/restores data-related state such as slicer and filter selections. **Display** controls whether it captures/restores visual display state, including visibility. For my filter-panel interaction, I used Display ON and Data OFF: the bookmark should show or hide the panel without resetting the user's selected date range or channel. Data can remain ON when the purpose is intentionally to return to a saved filter state.

### Q. How did you implement an open/close filter panel in your Power BI project?

**Answer:**
I used the Selection pane to configure visibility, created `Filters Open` and `Filters Closed` bookmarks, and connected two buttons through Format button → Action → Bookmark. The `Filters` button activates `Filters Open`; the `Close Filters` button activates `Filters Closed`. I updated each bookmark after preparing the required visibility state.

### Q. How did you make the buttons switch based on the filter-panel state?

**Answer:**
For `Filters Open`, both slicers and `Close Filters` are visible, while `Filters` is hidden. For `Filters Closed`, both slicers and `Close Filters` are hidden, while `Filters` is visible. I used the Selection pane to set these states and updated the corresponding bookmarks. This avoids showing two opposing actions at the same time.

### Q. Why use buttons instead of asking users to click the Bookmarks pane?

**Answer:**
The Bookmarks pane is an authoring interface. A button with a bookmark action provides a simpler user-facing interaction inside the report. Users can open or close the filter panel without needing access to the developer's Bookmarks pane.

### Q. How do you test a button action in Power BI Desktop?

**Answer:**
In edit mode, a normal click selects a button. I use Ctrl + Click to execute its action. I tested both directions: `Filters` showed both slicers and `Close Filters`; `Close Filters` hid both slicers and showed `Filters` again.

### Q. Can bookmarks control only slicers?

**Answer:**
No. Bookmarks can save the visibility/display state of many report objects, including slicers, buttons, charts, cards, text boxes and shapes, as well as other supported report state. In my project, I used bookmarks to control both slicer visibility and which action button is shown.

### Q. What is the difference between the Selection pane, bookmark, and button action?

**Answer:**
The Selection pane lets me configure individual objects' visibility and layering. A bookmark saves the intended report state. A button action lets a user activate that bookmark directly from the report. In my project, I used all three to implement the filter-panel interaction.

---

# 2026-10-10 — Row-Level Security (RLS) Practice

## Q. What is Row-Level Security in Power BI?

**Answer:**
Row-Level Security restricts the rows a report consumer can access based on a role's filter expression. In my Marketing Funnel & Campaign Intelligence project, I practised restricting lead records by city for regional managers and allowing the Marketing Head to see all cities.

## Q. What is the difference between Static RLS and Dynamic RLS?

**Answer:**
Static RLS uses a fixed filter, such as `FactLeads[City] = "Bangalore"`. Dynamic RLS determines the permitted data from the current user's identity and a mapping table. I created `RLS_Bangalore` for the static exercise and `RLS_Dynamic` for the email-to-city mapping exercise.

## Q. How did you implement Static RLS?

**Answer:**
In Modeling → Manage roles, I created the `RLS_Bangalore` role and applied a filter to `FactLeads[City]` for the Bangalore value. I then used the View as option in Power BI Desktop to simulate the role. I learned that a reduced row count is not enough by itself; the city values should also be checked to confirm the intended restriction.

## Q. Why did you create a `UserCityAccess` table?

**Answer:**
I created a mapping table with `UserEmail` and `City` columns. It maps each user's identity to the city they are permitted to access, so the security logic can look up the user's access rather than hard-code a separate city filter for each person.

## Q. What does `USERPRINCIPALNAME()` do?

**Answer:**
`USERPRINCIPALNAME()` returns the identity of the user being evaluated, typically their sign-in email in Power BI Service. In Desktop, I can use View as → Other user to simulate a test identity.

## Q. What does `LOOKUPVALUE()` do in the Dynamic RLS formula?

**Answer:**
`LOOKUPVALUE` searches `UserCityAccess[UserEmail]` for the current user's identity and returns the corresponding `UserCityAccess[City]`. That result becomes the user's permitted city.

## Q. Explain the Dynamic RLS expression you used.

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

**Answer:**
The formula identifies the current user, looks up their permitted city, and evaluates each row of `FactLeads`. If the user has no mapping, `NOT ISBLANK` prevents rows from passing this rule. If the mapped value is `ALL`, the rule allows all lead rows; otherwise, it allows only rows where `FactLeads[City]` matches the assigned city. `&&` means AND and `||` means OR.

## Q. Why did you first apply a formula to `UserCityAccess` and then move the rule to `FactLeads`?

**Answer:**
The first formula filtered the mapping table itself. It did not automatically secure the lead records because `UserCityAccess` was not connected to the lead table. The final rule was placed on `FactLeads`, where the city restriction applies to the actual lead rows. The mapping table is used as a lookup source.

## Q. What does `AllowedCity = "ALL"` mean?

**Answer:**
`ALL` is a text label I defined in the mapping table for the Marketing Head. It is not a special DAX function in this expression. The condition explicitly treats that label as permission to see all cities in `FactLeads` under the rule.

## Q. How did you test Dynamic RLS in Desktop?

**Answer:**
I used Modeling → View as, selected `RLS_Dynamic`, and also selected Other user to simulate an email present in `UserCityAccess`. Selecting the role without Other user uses the current identity, which may not match the practice email. I tested city-manager access and the Marketing Head's all-city access; the report visuals changed, and the Marketing Head saw the unrestricted total of 30,000 leads.

## Q. Does creating an RLS role in Desktop finish the deployment?

**Answer:**
No. Desktop role simulation verifies the DAX logic, but after publishing I must assign real users or groups to the role in Power BI Service and test access there. I also need to review all tables and relationships to ensure no visuals expose data outside the intended scope. Workspace Admins, Members, and Contributors are not restricted by RLS in the same way as Viewers, so workspace permissions must be considered.

## Q. What is the next step after testing RLS in Desktop?

**Answer:**
Save the PBIX in its normal unrestricted state, publish it to Power BI Service, configure the semantic model as needed, assign users or groups to `RLS_Dynamic` in Security settings, and test the published report with appropriate accounts.


# 2026-10-10 — Report Tooltip, UAT, and Deployment Readiness Q&A

## Report-page tooltips

### Q. What is a report-page tooltip in Power BI, and why did you use one?
**Answer:** A report-page tooltip is a dedicated report page designed to appear when a user hovers over a data point in another visual. In this project, I used it to show campaign-specific details such as Leads, Conversion %, and ROAS from the Campaign Performance matrix without adding more columns or visuals to the main page.

### Q. How does a report-page tooltip get the correct campaign context?
**Answer:** The hovered data point supplies filter context to the tooltip page. The tooltip visuals then evaluate their measures under that context, so the user sees the metrics for the campaign they hovered over. I validate the result by hovering over known campaign rows and comparing the tooltip values with the corresponding campaign metrics in the report.

### Q. How did you validate the tooltip in this project?
**Answer:** I hovered over campaign rows and compared the displayed Leads, Conversion %, and ROAS with the campaign matrix. Examples observed during testing were Meta Lead Gen: 557 leads, 6.10% conversion, ROAS 12.05; Google Search: 2,402 leads, 6.37% conversion, ROAS 13.00; and Google Performance Max: 1,761 leads, 9.09% conversion, ROAS 13.43. These values depend on the report's filter context.

### Q. What is the difference between a report-page tooltip and a drill-through page?
**Answer:** A tooltip gives a quick contextual view on hover and keeps the user on the current page. Drill-through navigates to a separate report page filtered to the selected entity, making it more suitable for deeper investigation.

### Q. What can go wrong with a report-page tooltip?
**Answer:** The tooltip page may not be configured as a tooltip, the source visual may not be assigned to use it, or the expected campaign fields/filter context may not flow into it. Measures can also display unexpected totals if their DAX removes filters. I test multiple known data points and reconcile the tooltip values against the source visual under the same filters.

## UAT and troubleshooting

### Q. What UAT checks have been completed in this project?
**Answer:** The recorded checks include data-quality baseline, channel and date slicers, page navigation, KPI consistency, bookmark/filter-panel interaction, campaign tooltip, cross-filtering, slicer interaction, refresh, default/reset state, report-filter validation, cross-page consistency, Desktop Dynamic RLS simulation, and visual layout/usability. Power BI Service RLS and deployment checks are still pending.

### Q. Why did `Lead Created Row Count` stay at 30,000 when filters changed?
**Answer:** The measure uses `ALL(LeadStageHistory)` inside its calculation, which removes filters from that table before counting Lead Created rows. In this project, we kept it as a global source-integrity count. A temporary test measure without `ALL` responded to channel/date filters and was used to diagnose the behaviour; the existing measure was intentionally left unchanged.

### Q. Does a successful Power BI Desktop refresh mean the report is production-ready?
**Answer:** No. Refresh success confirms the model processed without a refresh error. I still need to validate the business results, check saved source paths and normal report state, configure Service credentials/refresh as applicable, assign RLS users, and test the published report.

### Q. What is the remaining step for Dynamic RLS?
**Answer:** Desktop simulation has passed for the practice roles. After publishing, I must assign real users or groups to `RLS_Dynamic` in Power BI Service, test the published report with appropriate accounts, and review whether the model's relationships and visuals restrict every relevant table as intended.

### Q. What should I do when restarting this project after a break?
**Answer:** Reopen the existing PBIX, verify that it is the latest saved version, confirm source paths, refresh, and check that no test filters or View as/RLS simulation remain active. Continue from the deployment-readiness checklist rather than rebuilding the six completed pages.

## 2026-10-10 — Pre-Publish Checks and Dynamic RLS Validation Q&A

### Q. What did you verify before publishing the Power BI report?
**Answer:** I reopened the existing PBIX, confirmed the report pages, reviewed Data Source Settings, and ran a refresh. The current file was `Marketing_Funnel_Campaign_Intelligence.pbix`. The report had eight visible pages, including Campaign Detail and Campaign Tooltip. Eight CSV sources were listed, and Desktop refresh completed successfully. I also returned View as roles to `None` and saved before preparing the deployment checks.

### Q. What does the `RLS_Dynamic` rule do in this project?
**Answer:** It uses `USERPRINCIPALNAME()` to identify the current user, then `LOOKUPVALUE()` to retrieve that user's city from `UserCityAccess`. If no city is mapped, the rule denies rows. If the mapped value is the explicit text `ALL`, it allows all cities; otherwise, it keeps only rows where `FactLeads[City]` matches the mapped city.

### Q. Why must I validate Dynamic RLS again in Power BI Service if it worked in Desktop?
**Answer:** Desktop View as is a simulation. In Service, I must assign real users or groups to the published semantic model's role, confirm their actual sign-in identity matches `UserCityAccess[UserEmail]`, and test the published report with those accounts. Workspace permissions also matter; users with elevated workspace roles may not be restricted in the same way as Viewers. Desktop success is not proof that Service access is configured correctly.

### Q. What was the result of the latest Dynamic RLS test?
**Answer:** I reviewed the `FactLeads` DAX rule and tested the mapped identities using View as → `RLS_Dynamic` in Power BI Desktop. I confirmed that the test was working. The project log records this as user-confirmed Desktop PASS; Service role assignment and published-access validation are still pending.

### Q. Why did two users show the same numbers under `RLS_Bangalore`?
**Answer:** Both identities were simulated under the same static role, so they were subject to the same role filter. Matching numbers under that role do not prove Dynamic RLS is wrong or right. The correct test is to select `RLS_Dynamic` and verify each identity against its mapping in `UserCityAccess`.

### Q. What should be checked if `RLS_Dynamic` works in Desktop but not in Service?
**Answer:** Check that the user is assigned to the correct role in the published semantic model, that `USERPRINCIPALNAME()` matches the mapped email, that the mapping row is present and unambiguous, and that model relationships/filter paths propagate security to relevant tables and visuals. Also check workspace role, because elevated workspace roles may bypass normal RLS restrictions.

### Q. What is the deployment status now?
**Answer:** The current PBIX and source inventory were checked, Desktop refresh succeeded, the report was saved with no role simulation active, and Dynamic RLS was reported working in Desktop. The remaining tasks are to confirm free Power BI Service/workspace access, publish if available without a paid upgrade, assign role members, and validate the published report and security behavior.


---

## 2026-10-12 — MySQL Staging and Bulk CSV Loading Interview Q&A

### Q. Why did you create a separate `marketing_funnel_mysql` database?
**Answer:** I wanted to practise loading the Marketing Funnel & Campaign Intelligence data into MySQL and later connect Power BI to a relational database source. I created a separate staging database so the existing PBIX and original CSV files remain untouched while I validate the migration.

### Q. How did you verify the `FactLeads` table schema?
**Answer:** I ran `DESCRIBE FactLeads` in MySQL Workbench. I checked that the eight column names matched the CSV and that the key and data types were appropriate: `LeadID` is `VARCHAR(10)` and the primary key, `LeadDate` is `DATE`, and `Revenue` is `DECIMAL(12,2)`. Matching names reduces source-migration work, but I would still validate Power Query steps, relationships, measures, refresh, and RLS after switching sources.

### Q. How did you import `FactLeads.csv`, and how did you validate it?
**Answer:** I used MySQL Workbench's Table Data Import Wizard and selected the existing `marketing_funnel_mysql.factleads` table. I kept “Truncate table before import” unchecked and confirmed the eight CSV columns mapped to their matching table columns. The wizard completed successfully, and `SELECT COUNT(*) FROM FactLeads;` returned 30,000 rows, matching the expected dataset count.

### Q. What is `LOAD DATA LOCAL INFILE`?
**Answer:** It is a MySQL SQL statement for bulk-loading data from a file on the client computer into a table. It can be more efficient than row-by-row insertion for large CSV files, but performance depends on file format, indexes, settings, and the environment. I would validate the data and test the method rather than assume it is always faster.

### Q. What does `local_infile = OFF` mean?
**Answer:** Initially, `SHOW GLOBAL VARIABLES LIKE 'local_infile';` returned `OFF`. Later in the troubleshooting session, I executed `SET GLOBAL local_infile = ON` and verified the global and session values as `ON`. I also attempted a Workbench client option and used `LOAD DATA LOCAL INFILE` for `DimCampaign`. The first attempt failed/loaded zero rows; the corrected LF row terminator loaded 10 rows. The earlier statement that no setting was changed was a preliminary note and is superseded by the later troubleshooting record.

### Q. Why shouldn't you enable `LOCAL INFILE` without checking first?
**Answer:** Local-file loading has security implications because it allows a client to send a local file to the MySQL server for loading. I should understand the client and server configuration and use trusted files before enabling it. The Workbench Import Wizard is a valid fallback.

### Q. What would you do if a CSV import failed partway through?
**Answer:** I would inspect the wizard log and query the destination row count first. I would not blindly rerun the import, because rows may already exist and a primary key can cause duplicate-key errors. If cleanup is necessary, I would clear only the table data after confirming the intended action, preserving the table schema.

### Q. Does matching the MySQL table names to the CSV names guarantee that Power BI will work without changes?
**Answer:** No. Matching table and column names helps reduce changes, but I must still check data types, Power Query source steps, transformations, relationships, DAX measures, refresh, report visuals, and RLS. I will perform the source migration in a separate PBIX copy and keep the original unchanged.

### Q. Why is `DimMonth` a special case in this migration?
**Answer:** The existing Power BI model's `DimMonth` was created as a Power Query Reference from `DimDate`, although a `DimMonth.csv` also exists in the source folder. Before migration, I need to choose the intended source and avoid unintentionally loading duplicate versions of the monthly table.

### Q. Which MySQL commands did you use during database setup and validation?
**Answer:** I created the separate `marketing_funnel_mysql` database, selected it with `USE marketing_funnel_mysql;`, checked the table list with `SHOW TABLES;`, verified the `FactLeads` structure with `DESCRIBE FactLeads;`, and checked the local bulk-loading setting with `SHOW VARIABLES LIKE 'local_infile';`. After importing the CSV through Workbench, `SELECT COUNT(*) AS total_rows FROM FactLeads;` returned 30,000.

### Q. Did you enable `local_infile` after finding it was OFF?
**Answer:** No. The query `SHOW VARIABLES LIKE 'local_infile';` returned `OFF`. I documented the possible configuration steps, but did not execute `SET GLOBAL local_infile = ON`, edit the server configuration, or run `LOAD DATA LOCAL INFILE`. The Workbench Import Wizard already loaded `FactLeads.csv` successfully, so there was no need to change the setting before reviewing the security and client-configuration requirements.

### Q. How could you enable MySQL local bulk loading if it is deliberately needed?
**Answer:** First, I would verify the current server setting using `SHOW VARIABLES LIKE 'local_infile';` and confirm that the MySQL client/Workbench connection also permits local-file loading. If authorized and appropriate, a temporary server setting can be changed with `SET GLOBAL local_infile = ON;`, followed by another `SHOW VARIABLES` check. That requires sufficient privileges, may not persist after a restart, and is not the same as configuring the client. A persistent server configuration may require `local_infile=ON` under `[mysqld]` in the MySQL configuration file and a controlled restart. I would not enable it casually because local-file loading has security implications; I would use the Import Wizard if bulk loading is not needed.

### Q. What is the difference between enabling `local_infile` and running `LOAD DATA LOCAL INFILE`?
**Answer:** `local_infile` is a configuration setting that controls whether the server permits the local-file loading capability. `LOAD DATA LOCAL INFILE` is the SQL statement that uses that capability to load a client-side file into a table. The statement may still fail if the server or client configuration disallows it, even if the SQL syntax is correct.

## 2026-10-12 — MySQL import troubleshooting and connection profiles

### Q. Why did you use `Local instance MySQL80` instead of `Sales_Insights`?
**Answer:** I used `Local instance MySQL80` because that was the active Workbench connection where I checked the `local_infile` server/session values, selected `marketing_funnel_mysql`, and tested the CSV import. The two saved profiles show `localhost:3306` and `127.0.0.1:3306`; these often point to the same local computer, but their stored connection options can differ. I have not proved that the profiles are identical, and I have not concluded that `Sales_Insights` is wrong. I should compare the host, port, server identity, selected schema, and connection options before choosing a profile for later work.

### Q. What is the difference between a Workbench connection profile and a database/schema?
**Answer:** A Workbench connection profile stores how Workbench connects to a MySQL server, such as host, port, credentials, and client options. A schema such as `marketing_funnel_mysql` is a database on that server. A profile does not itself equal a schema; after connecting, I select the required schema with `USE marketing_funnel_mysql;`.

### Q. How did you import `DimCampaign.csv` after the first attempt inserted zero rows?
**Answer:** The initial command used `LINES TERMINATED BY '\r\n'` and inserted zero rows. I checked the source file in Notepad++ without editing it and saw `Unix (LF)` in the status bar. I changed the statement to `LINES TERMINATED BY '\n'`, ran `LOAD DATA LOCAL INFILE` again, and validated with `SELECT COUNT(*)`. The table then contained 10 rows and the first five records displayed correctly.

### Q. What row counts have been verified in the MySQL practice database so far?
**Answer:** `FactLeads` contains 30,000 rows after import through the Workbench Table Data Import Wizard. `DimCampaign` contains 10 rows after the line-ending correction to the `LOAD DATA LOCAL INFILE` statement. Other tables are not yet confirmed imported, so I should not report the full database load as complete.

### Q. What happened when you checked `local_infile`?
**Answer:** On `Local instance MySQL80`, the global value was initially `OFF`. I then executed `SET GLOBAL local_infile = ON;` and verified global and session values as `ON`. I also tried adding `OPT_LOCAL_INFILE=1` under the connection profile's Advanced → Others settings. The first `LOAD DATA LOCAL INFILE` attempt returned error 2068, showing that client-side local-file restrictions can still matter. After adjusting the CSV line-ending clause to match the source file, the `DimCampaign` import succeeded. I should distinguish the server setting from client permissions and use bulk loading only when appropriate.

### Q. Why is checking line endings useful when importing a CSV?
**Answer:** `LOAD DATA` needs the row terminator to match the file. If the file uses LF but the SQL expects CRLF, the statement may not split rows as intended. I checked the actual file in Notepad++ and changed the SQL clause, not the original CSV, to match its LF line endings.

### Q. What validation should follow a CSV import?
**Answer:** First check the row count with `SELECT COUNT(*)`. Then inspect sample rows with `SELECT * ... LIMIT 5`, and validate key quality where relevant—for `DimCampaign`, check whether `CampaignID` values are unique. Compare actual results with the source file and expected schema before importing the next table.


## 2026-10-12 — Additional interview questions from the complete import troubleshooting

### Q. Why did you use `Local instance MySQL80` instead of `Sales_Insights`?
**Answer:** I continued in `Local instance MySQL80` because it was the active Workbench profile where I was checking the server setting and importing into `marketing_funnel_mysql`. The profiles showed `localhost:3306` and `127.0.0.1:3306`; both often point to the same computer, but their saved credentials and client options can differ. I have not proved the profiles are identical or that `Sales_Insights` is wrong. I would compare the server identity, port, selected schema, and relevant client options before deciding.

### Q. How can you compare two MySQL Workbench connection profiles?
**Answer:** Connect through each profile and run `SELECT @@hostname AS ServerName, @@port AS Port, VERSION() AS MySQLVersion, DATABASE() AS CurrentDatabase;`. This compares server identity, port, version, and selected database. I would also inspect each profile's saved connection and Advanced settings because those client options are not all represented by the SQL result.

### Q. What did you do after `local_infile` initially returned `OFF`?
**Answer:** I ran `SET GLOBAL local_infile = ON` in `Local instance MySQL80`, then checked both `SHOW GLOBAL VARIABLES LIKE 'local_infile'` and `SHOW SESSION VARIABLES LIKE 'local_infile'`; both were verified as `ON`. I then went to Workbench Home → Manage Connections → selected `Local instance MySQL80` → Advanced → Others and added `OPT_LOCAL_INFILE=1`, saved, and reconnected. This was an attempted client-option configuration, and I would verify the exact supported syntax for the connector version rather than assume it was accepted.

### Q. Why did the first `LOAD DATA LOCAL INFILE` attempt not import `DimCampaign`?
**Answer:** The first attempt returned error 2068 indicating the local-file request was rejected due to access restrictions. A later attempt using `LINES TERMINATED BY '\r\n'` reported zero rows affected and no warnings; the table count was still zero. I therefore checked the source file and validated the table instead of assuming that a warning-free message meant success.

### Q. How did you check a CSV's line endings in Notepad++ without changing the file?
**Answer:** I opened the CSV in Notepad++, checked Edit → EOL Conversion only to understand the menu, and closed it without selecting a conversion. Then I checked the bottom-right status bar, which displayed `Unix (LF)`. I did not edit or save the source file. I changed the SQL's `LINES TERMINATED BY` clause to match the file.

### Q. What change fixed the `DimCampaign` import?
**Answer:** I changed the SQL row terminator from `LINES TERMINATED BY '\r\n'` to `LINES TERMINATED BY '\n'`, because Notepad++ showed that the CSV used Unix LF endings. After rerunning the import, `SELECT COUNT(*) AS TotalRows FROM DimCampaign` returned 10, and a sample query showed campaign IDs C001–C005.

### Q. Why is `SELECT COUNT(*)` necessary after an import?
**Answer:** The import interface can report zero affected rows without warnings, so I need to query the destination table to verify that data actually arrived. I also inspect sample rows and check key uniqueness. In this exercise, the first attempt left `DimCampaign` at zero rows, while the corrected attempt produced 10 rows.

### Q. What is the difference between `local_infile` and `LINES TERMINATED BY`?
**Answer:** `local_infile` is a server configuration setting governing whether local-file loading is permitted. Client settings can also restrict it. `LINES TERMINATED BY` is part of the import statement and tells MySQL how rows are separated in the source file. Enabling local loading does not make an incorrect line terminator correct.

### Q. What was the final verified import status at this point?
**Answer:** `FactLeads` has 30,000 rows from the Workbench Import Wizard, and `DimCampaign` has 10 rows from `LOAD DATA LOCAL INFILE` after matching the LF line ending. The uniqueness query for `CampaignID` is still pending, and the other seven tables have not yet been confirmed imported.

## 2026-10-12 — Interview Q&A: DimCustomer bulk import

### Q. Why would you use `LOAD DATA LOCAL INFILE` instead of the Table Data Import Wizard?
**Answer:** For a CSV with many rows, `LOAD DATA LOCAL INFILE` is an efficient bulk-loading option and lets me repeat the import through SQL. The Import Wizard is still useful for GUI-based mapping and troubleshooting. I choose based on the file, schema alignment, and import requirements rather than assuming one method is always best.

### Q. How did you import `DimCustomer` into MySQL?
**Answer:** I connected through `Local instance MySQL80`, selected `marketing_funnel_mysql`, checked that `DimCustomer` was empty, and ran `LOAD DATA LOCAL INFILE` against `DimCustomer.csv`. The statement used comma-separated fields, optional double-quote enclosure, `LINES TERMINATED BY '\\n'`, and `IGNORE 1 LINES` to skip the header. The import completed and I reported that 100 customer rows were imported.

### Q. What does `IGNORE 1 LINES` do in a CSV import?
**Answer:** It skips the first line of the file, which is commonly the column header, so that header text is not loaded as a data row.

### Q. Why should a bulk-load statement explicitly list target columns when needed?
**Answer:** Without a column list, MySQL maps input fields to the table's columns in their expected order. If the CSV and table orders differ, values can go into the wrong columns or cause errors. I should inspect the CSV header and table definition and provide a target-column list when the order is not guaranteed to match.

### Q. Is the `DimCustomer` import fully validated?
**Answer:** The import completed and 100 rows were reported. I should still run `SELECT COUNT(*) FROM DimCustomer` and inspect sample records with `SELECT * FROM DimCustomer LIMIT 5` to independently verify the destination table. I should distinguish the reported import result from post-import validation.


---

## 2026-10-12 — Interview Q&A: DimDate bulk-load troubleshooting

### Q. How did you troubleshoot an incorrect date during a MySQL CSV import?
**Answer:** I inspected the target table with `DESCRIBE DimDate` and checked the actual CSV values in Notepad++. My first query assumed `DD-MM-YYYY` and used `STR_TO_DATE(..., '%d-%m-%Y')`, but the source contained dates in `YYYY-MM-DD` format. The imported row showed `0000-00-00`, so I corrected the approach to load the date directly, after ensuring the incorrect row was cleared.

### Q. Why did you remove `STR_TO_DATE()` in the corrected `DimDate` import?
**Answer:** The source dates were already in `YYYY-MM-DD`, which MySQL can read as a `DATE`. The conversion mask was based on the wrong format, so direct loading was simpler and matched the source data.

### Q. How do you determine whether a CSV delimiter is a comma or tab?
**Answer:** I inspect the actual CSV in a text editor such as Notepad++ and examine the separators in the header and data lines. A spreadsheet-style grid alone is not sufficient proof of the raw delimiter. For this file, the visible data line used commas.

### Q. What checks should follow a successful `LOAD DATA LOCAL INFILE`?
**Answer:** I check the total row count, inspect sample records, verify key fields, and for a date dimension check `MIN(Date)`, `MAX(Date)`, and whether any invalid zero dates remain. I only report counts and date ranges as verified after reading the query output.

### Q. What was the root cause of the first `DimDate` import problem?
**Answer:** The date parsing format was wrong. I treated the source as `DD-MM-YYYY`, but the CSV showed `YYYY-MM-DD`. The correction was to stop using the incorrect `STR_TO_DATE` mask and load the date directly.


## 2026-10-12 — Confirmed DimDate validation

### Q. How did you validate the `DimDate` import?
**Answer:** I ran a query using `COUNT(*)`, `MIN(Date)`, and `MAX(Date)`. It returned 623 rows, a first date of `2025-01-01`, and a last date of `2026-09-15`.

### Q. Why is validating the date range important after importing a date dimension?
**Answer:** The row count alone does not prove that the dates loaded correctly. Checking the minimum and maximum dates confirms the calendar starts and ends at the expected dates. I also inspect sample rows and check for invalid zero dates.

### Q. What was the final verified result for `DimDate`?
**Answer:** The confirmed result was 623 rows, from `2025-01-01` through `2026-09-15`, matching the expected source period.

### Q. What should you do before importing the next table?
**Answer:** Check that the target table is empty or understand its current contents, inspect the CSV header and date/field formats, compare the CSV columns with the target schema, load the data, and validate row counts and sample records.

## 2026-10-14 — Interview Q&A: DimMonth CSV bulk import

### Q. How did you import the `DimMonth` CSV into MySQL?
**Answer:** I checked that `DimMonth` was empty, inspected the CSV columns and the target table schema, then used `LOAD DATA LOCAL INFILE` with comma-separated fields, optional double-quote enclosure, `LINES TERMINATED BY '\n'`, and `IGNORE 1 LINES`. I explicitly listed the five target columns to make the mapping clear.

### Q. What columns are present in the `DimMonth` table?
**Answer:** `Start of Month`, `Year`, `MonthNo`, `Month`, and `YearMonth`. `Start of Month` is a `DATE` primary key.

### Q. What went wrong when you initially used `STR_TO_DATE()` for `DimMonth`?
**Answer:** The import generated warnings and an invalid `0000-00-00` date. The error showed an incoming value like `2025-01-01`, which already uses `YYYY-MM-DD`. The assumed `DD-MM-YYYY` format was not supported by the actual value received by MySQL.

### Q. How did you fix the `DimMonth` date issue?
**Answer:** I stopped applying an unnecessary date-format conversion and loaded the source date directly into the MySQL `DATE` column. I cleared the incorrect row before retrying, then validated the result.

### Q. Why can an Excel date display be misleading when troubleshooting CSV imports?
**Answer:** Excel can display a date using cell formatting, so the visible format is not always proof of the literal text stored in the CSV. Inspect the actual CSV text and the MySQL error message before choosing a `STR_TO_DATE()` format.

### Q. How did you validate the `DimMonth` import?
**Answer:** I used `COUNT(*)`, `MIN(Start of Month)`, and `MAX(Start of Month)`. The result was 21 rows, from `2025-01-01` through `2026-09-01`.

### Q. What is the lesson from this troubleshooting exercise?
**Answer:** Don't repeatedly guess at date masks. Check the actual input value, clear any bad test data before retrying, load dates directly when they are already in a compatible format, and validate both the count and date range.


## New Section — 14 October 2026: FactAdSpend bulk-loading interview Q&A

### Q: How did you import FactAdSpend from CSV into MySQL?
**Answer:** I first confirmed the destination table was empty, inspected the CSV header and MySQL schema, and verified that the dates were stored as `YYYY-MM-DD`. I then used `LOAD DATA LOCAL INFILE` with comma-delimited fields, LF line endings, and `IGNORE 1 LINES` to skip the header. I mapped the six CSV columns explicitly to the existing table columns.

### Q: Why did you not use `STR_TO_DATE()` for FactAdSpend?
**Answer:** The CSV already contained dates in `YYYY-MM-DD`, which MySQL accepts for a `DATE` column. I loaded the date directly instead of adding an unnecessary conversion.

### Q: How did you validate the import?
**Answer:** I used `COUNT(*)`, `MIN(Date)`, and `MAX(Date)`. The result was 6,230 rows, with dates ranging from `2025-01-01` to `2026-09-15`. I would also check the composite primary key `(Date, CampaignID)` for duplicates and inspect sample records.

### Q: Why inspect the table schema before importing?
**Answer:** To ensure the CSV fields map to the correct destination columns and that data types are compatible—for example, `AdSpend` to `DECIMAL(12,2)` and `Date` to `DATE`.

### Q: What is the purpose of `IGNORE 1 LINES` in `LOAD DATA`?
**Answer:** It skips the CSV header row so the column names are not treated as data.

### Q: Which validations should follow a bulk import?
**Answer:** Check the row count, date range, sample rows, nulls where they are not allowed, and key uniqueness. For this table, verify that each `(Date, CampaignID)` pair is unique.

## 2026-10-14 — CampaignBudget import: interview questions

### Q: How did you bulk-load CampaignBudget from CSV into MySQL?
**Answer:** I used MySQL Workbench connected to `Local instance MySQL80`, selected `marketing_funnel_mysql`, and ran `LOAD DATA LOCAL INFILE` with comma-separated fields, optional double-quote enclosure, LF line endings, and `IGNORE 1 LINES` to skip the header. I explicitly mapped `BudgetID`, `CampaignID`, `MonthStart`, and `BudgetAmount` to the existing table.

### Q: Why did you not use `STR_TO_DATE()` for `CampaignBudget.MonthStart`?
**Answer:** I inspected the raw CSV in Notepad++ and confirmed that the stored date text was `YYYY-MM-DD`, such as `2025-01-01`. Excel displayed the date differently, so I used the raw CSV text as the source of truth and loaded it directly into the MySQL `DATE` column.

### Q: How did you validate the CampaignBudget import?
**Answer:** I checked total rows, minimum and maximum month dates, and distinct budget IDs. The result was 210 rows, from `2025-01-01` through `2026-09-01`, with 210 distinct `BudgetID` values.

### Q: What did the CampaignBudget schema tell you before import?
**Answer:** `BudgetID` was `VARCHAR(15)` and the primary key; `CampaignID` was `VARCHAR(10)`; `MonthStart` was `DATE`; and `BudgetAmount` was `DECIMAL(12,2)`. I used that schema to check the CSV column mapping and data types before loading.

### Q: Why inspect a CSV in Notepad++ when Excel already shows the data?
**Answer:** Spreadsheet applications can display dates in a formatted way. Looking at the raw CSV confirms the actual stored date text, delimiters, and header, which helps avoid incorrect conversion masks and column parsing.

## 2026-10-14 — Interview Q&A: CRMActivity import

### Q: How did you import CRMActivity into MySQL?
**Answer:** I first confirmed the destination table was empty, inspected its schema, and checked the CSV header and sample rows. Since the CSV was comma-delimited and its `ActivityDate` values were already in `YYYY-MM-DD` format, I used `LOAD DATA LOCAL INFILE` with `IGNORE 1 LINES` and explicit column mapping to load the existing table.

### Q: Why didn't you use STR_TO_DATE() for ActivityDate?
**Answer:** The actual CSV text already used ISO date format such as `2025-07-16`, which MySQL accepts for a `DATE` column. I loaded it directly instead of applying an unnecessary conversion.

### Q: How did you validate the CRMActivity import?
**Answer:** I checked total rows, distinct ActivityID values, and the minimum and maximum ActivityDate. The result was 36,057 rows, 36,057 unique ActivityIDs, and a date range from `2025-01-01` to `2026-09-15`. This showed that no duplicate ActivityID values were detected.

### Q: Why inspect the CSV as text instead of trusting how dates appear in Excel?
**Answer:** Spreadsheet software can display dates differently from the underlying CSV text. Inspecting the raw CSV helps choose the correct loading and date-conversion approach and prevents incorrect dates such as `0000-00-00`.

### Q: What should be checked before importing the next table?
**Answer:** Check that the target table is empty or understand its existing data, compare the CSV headers and column order with the destination schema, verify delimiters and date formats, then import and validate row counts, key uniqueness, and relevant date ranges.

## 2026-10-14 — Bulk loading LeadStageHistory and validating all tables

### Q: How did you import `LeadStageHistory` from CSV into MySQL?
**Answer:** I inspected the CSV header and sample rows, compared them with the existing table schema, and confirmed the date text was already in `YYYY-MM-DD` format. I used `LOAD DATA LOCAL INFILE` with comma-separated fields, `LINES TERMINATED BY '\\n'`, `IGNORE 1 LINES`, and explicit column mapping. Because the dates were already ISO-formatted, I loaded `StageDate` directly without `STR_TO_DATE()`.

### Q: How did you validate the `LeadStageHistory` import?
**Answer:** I checked the total row count, distinct `StageHistoryID` count, minimum date, and maximum date. The results were 46,883 rows, 46,883 unique IDs, first date `2025-01-01`, and last date `2026-09-15`. The total and distinct ID counts matched, so the validation detected no duplicate history IDs.

### Q: How did you verify that the full CSV import phase was complete?
**Answer (corrected after documentation audit):** The historical notes list these per-table counts: `FactLeads` 30,000; `DimCampaign` 10; `DimCustomer` 100; `DimDate` 623; `DimMonth` 21; `FactAdSpend` 6,230; `CampaignBudget` 210; `CRMActivity` 36,057; and `LeadStageHistory` 46,883. Those values sum to 120,134, not 83,754. The old aggregate statement is therefore inconsistent and must not be presented as confirmed. I would rerun a live `COUNT(*)` query for every table and record the date before stating the current database total.

### Q: Does matching row counts prove that every aspect of the imported data is correct?
**Answer:** No. Row counts are an important first check, but I should also validate primary-key uniqueness, date ranges, nulls, data types, sample records, and relationships between tables. Matching counts alone do not prove that all values or relationships are correct.

### Q: What is the next step after loading the source tables?
**Answer:** Validate the schema and relationships, then connect a copy of the existing Power BI report to the MySQL database. I would preserve the original PBIX and CSV files, verify the model and measures after switching sources, and test refresh behavior before treating the migration as complete.


## 2026-10-14 — Interview Q&A: reviewing M code and RLS before a source migration

### Q: Why inspect all Power Query M code before replacing CSV sources with MySQL?
**Answer:** M code documents the source connection and every transformation after it. Reviewing it first helps identify which steps need to change and which must remain, such as data-type conversions, custom columns, merges, expansions, and query dependencies. It reduces the risk of breaking report logic during migration.

### Q: Which transformations exist in the `FactLeads` query?
**Answer:** It reads an eight-column CSV, promotes headers, assigns data types, creates `RevenueStatus` from `Revenue`, derives `Month Name` from `LeadDate`, left-outer merges to `DimCampaign` on `CampaignID`, and expands `CampaignName`, `Channel`, and `Objective`. When switching the source, I should preserve these transformations and validate the final row count and campaign matches.

### Q: What does a left outer merge do in Power Query?
**Answer:** It retains all rows from the left-hand table (`FactLeads`) and brings in matching rows from the right-hand table (`DimCampaign`) based on `CampaignID`. If a campaign has no match, the expanded campaign fields can be null. I would validate match coverage and avoid changing the join kind without a business reason.

### Q: What potential issue should be checked in `DimCampaign`'s `Extra` custom column?
**Answer:** The query first changes `CampaignID` to text, then compares `[CampaignID] = 0`, where zero is numeric. That type mismatch may mean the condition does not behave as intended. I would inspect actual values and confirm the business requirement before correcting it; I would not silently mix a logic change into the source migration.

### Q: Why is `DimMonth` treated differently from the other source queries?
**Answer:** `DimMonth` begins with `Source = DimDate`, then keeps only `Start of Month` and removes duplicates. It is a reference/dependent query, not an independent CSV import. Once `DimDate` is migrated, `DimMonth` can continue to reference its output, provided the expected column name and data remain available.

### Q: What should be checked when `DimDate` has both `Start of Month` and `Start of the Month`?
**Answer:** They are different column names: one is derived from `Date` and the other is the renamed original `YearMonth` column. I would preserve both initially and check relationships, measures, and query references before considering any cleanup.

### Q: What is `UserCityAccess`, and should it be migrated to MySQL?
**Answer:** It is a small embedded table created inside M code, with `UserEmail` and `City` columns and two email replacement steps. It is not sourced from CSV. Because it appears to support RLS, I would keep it embedded and preserve the replacements during the source migration unless the security design is deliberately changed and retested.

### Q: How does the `RLS_Bangalore` role work?
**Answer:** It applies a filter to `FactLeads[City]` requiring the value to equal `Bangalore`. Its effect on other tables depends on the model relationships and filter propagation, so I would test the role in the report rather than assuming every table is filtered identically.

### Q: Explain the `RLS_Dynamic` DAX rule.
**Answer:** `USERPRINCIPALNAME()` identifies the current signed-in principal. `LOOKUPVALUE` retrieves that user's city from `UserCityAccess`. The rule returns true only when a city is found and either the city is `ALL` or the current `FactLeads[City]` matches the allowed city. If no user mapping is found, the rule denies those rows.

### Q: What conditions must hold for the dynamic RLS lookup to work?
**Answer:** The current principal name must match a value in `UserCityAccess[UserEmail]`, the lookup must return an unambiguous city, and the city values must align with `FactLeads[City]`. I would test normal city access, `ALL` access, and an unmapped user. I would also confirm how the identity is represented in Power BI Service.

### Q: Why should I not modify RLS at the same time as changing data sources?
**Answer:** That combines two types of change and makes failures harder to diagnose. I should first preserve the role expressions and security mapping, migrate and validate the sources, then test each role independently using representative users and expected city-level results.

### Q: The Queries pane shows 10 queries, but the model security table list also shows `FunnelStages`. What should I conclude?
**Answer:** I should not assume `FunnelStages` is a CSV-backed Power Query query. It may be a calculated table or another model artifact. I should inspect its origin in the model before planning source migration.

### Q: What validations are needed after changing a Power BI query from CSV to MySQL?
**Answer:** Compare column names and types, row counts, key uniqueness, nulls, date ranges, and sample values; validate merges and relationships; refresh report visuals and measures; then test RLS and refresh behavior. A successful connection or matching row count alone does not prove the migration is correct.

### Q: What is the safe migration sequence for this report?
**Answer:** Work in the copied PBIX and leave the original PBIX and CSV files unchanged. Connect to the existing MySQL database, migrate `DimCampaign` and validate it, then migrate `FactLeads` while preserving its merge and derived columns. Migrate the remaining CSV-backed queries, keep `DimMonth` dependent on `DimDate`, preserve the embedded `UserCityAccess` table, and validate the model, visuals, refresh, and RLS before calling the migration complete.


---

---



> **Historical answer-state note:** The answers below describe what was known on 14 October 2026. Their pending-migration statements are preserved as history and are superseded by the later 15–18 October gateway, refresh, and RLS entries.

## Historical Q&A Appendix — Power Query M Source Migration to MySQL and Privacy Troubleshooting (14 October 2026)

### Q. How did you approach migrating an existing Power BI report from CSV to MySQL?
**Answer:** I worked in a copied PBIX to protect the original report and CSV files. I reviewed the M code first, identified the source step and downstream transformations for each query, then used the MySQL connector to navigate to the corresponding table. I preserved the existing data types, custom columns, merges, and expansions, and validated row counts and report refresh before moving on to relationships, KPI parity, and RLS.

### Q. What is the difference between Power Query M and SQL in this migration?
**Answer:** M is Power Query's language for connecting to sources and shaping data before it loads into the model. SQL is the database query language used to read or transform data inside MySQL. For example, M can connect with `MySQL.Database(...)` and navigate to `factleads`; the equivalent simple SQL read is `SELECT * FROM marketing_funnel_mysql.factleads;`. The two are related but not interchangeable: replacing a CSV source with a MySQL table does not automatically convert every M transformation into SQL.

### Q. Show an example of the original CSV source M and the MySQL source M.
**Answer:** The CSV source was similar to:

```powerquery
Source = Csv.Document(
    File.Contents("C:\Users\USER\Downloads\MarTech_PowerBI_Project_Tables\FactLeads.csv"),
    [Delimiter=",", Columns=8, QuoteStyle=QuoteStyle.None]
)
```

The MySQL connector/navigation pattern was:

```powerquery
Source = MySQL.Database("localhost:3306", "marketing_funnel_mysql", [ReturnSingleDatabase=true]),
FactLeadsTable = Source{[Schema="marketing_funnel_mysql", Item="factleads"]}[Data]
```

The equivalent SQL table read is:

```sql
SELECT LeadID, LeadDate, CampaignID, Source, City, Program, LeadStatus, Revenue
FROM marketing_funnel_mysql.factleads;
```

After changing the source, I must keep and test the later M steps rather than assuming the source change is enough.

### Q. Which transformations in `FactLeads` must be preserved?
**Answer:** After reading the eight source columns and applying types, the query creates `RevenueStatus` based on whether Revenue is greater than zero, derives `Month Name` from `LeadDate`, left-outer merges to `DimCampaign` using `CampaignID`, and expands campaign name, channel, and objective. Those steps support existing report fields, so I preserve them and validate their outputs after changing the source.

### Q. How would you express the `FactLeads` campaign merge in SQL?
**Answer:** The equivalent join concept is:

```sql
SELECT f.*, d.CampaignName, d.Channel, d.Objective
FROM marketing_funnel_mysql.factleads AS f
LEFT JOIN marketing_funnel_mysql.dimcampaign AS d
    ON f.CampaignID = d.CampaignID;
```

This illustrates the left join; it is not automatically the query currently running in Power Query. I would only move the merge into SQL deliberately and compare results, because that changes the implementation and can affect column names, types, and folding behavior.

### Q. What does a left outer merge mean here?
**Answer:** It keeps every row from `FactLeads` and attaches matching fields from `DimCampaign`. If no campaign key matches, the lead row remains but the expanded campaign fields can be null. I would check unmatched campaign IDs and confirm that the dimension key is unique.

### Q. Why can a Power Query privacy-level prompt appear during a merge?
**Answer:** The query is combining data from more than one source—in this case MySQL and a local CSV dimension. Power Query applies privacy rules to help prevent data from one source being unintentionally passed to another. I need to choose appropriate privacy levels and make sure the source design follows the data-handling policy; I should not simply disable privacy checks to make the prompt disappear.

### Q. What happened when you tried to save the privacy level, and what did you do?
**Answer:** Power BI repeatedly raised this exception: `SetPrivacyGroup ... dataSource was not passed as a method argument`. I cancelled the failing dialog rather than repeatedly forcing the same action. The main report subsequently refreshed without a visible refresh error, but I recorded that as a partial success. I still need to inspect the source permissions/privacy settings and migrate remaining CSV-dependent queries consistently before declaring the migration complete.

### Q. Does the `SetPrivacyGroup` error mean the MySQL password is wrong?
**Answer:** Not by itself. The error message is about Power BI's privacy-group operation, not a MySQL authentication failure. I would diagnose the specific error path instead of resetting the database password or changing server settings without evidence.

### Q. Why is it important to inspect Data source settings after a successful refresh?
**Answer:** Because a report can refresh successfully while some queries still use CSV and others use MySQL. In this case, Data source settings still listed several CSV files alongside the MySQL database. That means the report was in a mixed-source state at that point. I should inspect every query's Source step and complete the intended migration before calling it done.

### Q. Which row-count checks have been completed in Power BI?
**Answer:** I selected the tables in the model/data view and confirmed `FactLeads` had 30,000 rows, `FactAdSpend` had 6,230 rows, and `LeadStageHistory` had 46,883 rows. Those counts match the previously validated MySQL tables. I still need to check the remaining tables and validate keys, types, dates, relationships, measures, and RLS.

### Q. Does matching row counts prove the migration is correct?
**Answer:** No. It is one useful validation. I also need to check unique keys, nulls, date ranges, data types, unmatched joins, relationship cardinality, filter direction, KPI values, all report pages, refresh, and RLS. A table can have the right number of rows but still contain different or incorrectly typed values.

### Q. The refreshed report shows 48M revenue and 10.17 ROAS. Is that proof that the migration is correct?
**Answer:** No. Those were observed values after refresh, but I must compare them with the original report's baseline. A successful refresh and plausible-looking visuals do not establish KPI parity. I would compare measures under the same date and channel filters and investigate any unexplained difference.

### Q. Why keep `DimMonth` as a reference of `DimDate`?
**Answer:** `DimMonth` is derived from `DimDate` by keeping the start-of-month field and removing duplicates. It has one row per month and is expected to have 21 rows. Keeping the reference avoids duplicating month-generation logic and preserves the query dependency; I would check that the source column remains available and correctly typed after migration.

### Q. What should be done with the embedded `UserCityAccess` table during this source migration?
**Answer:** It is an embedded M table rather than one of the nine imported CSV tables, so I should not replace it with a MySQL source automatically. I should preserve its mappings and verify that each email matches `USERPRINCIPALNAME()` in Power BI Service. Any security-table redesign should be a separate, documented change.

### Q. What is your safe next step after the refresh?
**Answer:** Inspect Model view first and document existing relationships, cardinalities, and filter directions before changing anything. Then inventory the source step of every query, finish the remaining CSV-to-MySQL changes, validate all table counts and KPI parity, resolve the privacy dialog carefully, and test RLS. I would save the final migration as a separate PBIX and leave the original untouched.

---

# 2026-10-15 to 2026-10-16 — Interview Q&A: Power BI Service, MySQL gateway, connection troubleshooting, and refresh validation

## A. Architecture and connection types

### Q: Why does Power BI Service need a gateway to refresh from MySQL running on my laptop?
**Answer:** Power BI Service runs in Microsoft's cloud and cannot interpret `localhost` as my personal laptop. The standard on-premises data gateway is installed on the laptop and provides the bridge between the cloud service and the local MySQL server. When a refresh is requested, Service routes the operation through the gateway, and the gateway accesses MySQL on the local machine. The laptop and MySQL service must be running and reachable for refresh to work.

### Q: What is the difference between a Cloud connection and an on-premises gateway connection?
**Answer:** They are different connection routes. A Cloud connection is used when Service can reach the source through a cloud connection configuration. An on-premises connection is attached to a registered gateway cluster, which can reach sources on a local or private network. In my project, the MySQL server is on my laptop at `localhost:3306`, so the on-premises gateway is the appropriate route. The same server/database names in both connection objects do not make the routes equivalent.

### Q: Why is `localhost` a problem for a Cloud connection?
**Answer:** `localhost` means the machine making the connection. From Power BI Service's cloud environment, it does not point to my laptop. The on-premises gateway runs on my laptop, so when the gateway executes the source connection, `localhost:3306` refers to the MySQL server on that machine.

### Q: Does creating a gateway connection automatically connect the semantic model to it?
**Answer:** No. Creating a connection object only stores the source configuration under the gateway. In the semantic model settings, I must enable the gateway, select the gateway cluster, map the model's source to the matching gateway connection in **Maps to**, and click **Apply**. I then verify the route with a manual refresh.

## B. Troubleshooting the gateway installation

### Q: Why did the on-premises gateway installer fail when I selected the D drive?
**Answer:** The installer log showed error `0x80070070`, which indicates insufficient disk space. C: had only 30.3 MB free, even though D: had 111 GB free and was selected as the installation folder. The installer still needed temporary and cache space under C:, including the user's Temp folder and `C:\\ProgramData\\Package Cache`. Selecting D: does not move every temporary/cache operation to D:.

### Q: Which log lines confirmed the installation failure?
**Answer:** The key lines were `Error 0x80070070: Failed to set end of file`, `Failed to extract all files from container`, and `Failed while caching, aborting execution`. The log also showed a system restore point warning `0x8004231f`, but the explicit terminal installation failure was `0x80070070`.

### Q: How did I resolve the installer failure safely?
**Answer:** I checked the installer log first, then used Windows + R to open `%temp%` and deleted the contents, skipping files Windows reported as in use. I did not intentionally delete Power BI project files, source CSVs, or MySQL database folders. After cleanup, the gateway installer and registration completed successfully.

### Q: What should be checked before deleting temporary files?
**Answer:** Save work and close applications when possible. Confirm the path is a temporary folder such as `%temp%`; delete its contents rather than the folder itself; skip locked/in-use files; and avoid deleting project folders, Downloads, Program Files, or database data. After cleanup, check free space and retry the installer only when sufficient space is available.

## C. Gateway registration and credentials

### Q: What gateway did I register, and how did I confirm it was online?
**Answer:** I registered a standard on-premises gateway named `MySQL_OnPrem_Gateway` in Central India. The gateway application displayed “The gateway MySQL_OnPrem_Gateway is online and ready to be used.” In Power BI Service's **Manage Connections and Gateways → On-premises data gateways**, it appeared with the machine running it (`<LOCAL_GATEWAY_HOST>`) and the registered account as contact information.

### Q: Are the gateway registration account and MySQL credentials the same?
**Answer:** No. The Microsoft work/school identity registers and manages the gateway in Power BI Service. The MySQL connection uses database credentials, in this case Basic authentication with the MySQL username `root` and its password. The gateway recovery key is a third, separate secret used to restore or migrate the gateway. I must never share or store the password or recovery key in project documentation.

### Q: What is the gateway recovery key for?
**Answer:** It is used to restore or migrate the gateway and must be saved securely. It is not the MySQL password or Microsoft account password. Anyone with the recovery key may be able to assist with gateway recovery, so it should remain private.

## D. Diagnosing the original Cloud connection failure

### Q: What was the initial Service refresh problem?
**Answer:** The MySQL semantic model initially showed a failed refresh and a message that scheduled refresh was disabled because at least one data source was missing credentials. The source settings showed `localhost:3306`, database `marketing_funnel_mysql`, and blank username/password/privacy fields. The report opened and its filters responded, but that did not prove the source could refresh.

### Q: What error appeared when trying to save credentials on the original Cloud connection?
**Answer:** Power BI Service said it was unable to update connection credentials and could not connect to the data source, listing possible causes such as an inaccessible source, connection timeout, or invalid credentials. Changing the encryption option from `Encrypted` to `Not encrypted` did not resolve that error.

### Q: Can I claim the Cloud connection failed only because of encryption?
**Answer:** No. The error was generic, and changing encryption did not fix it. The source was a local MySQL instance addressed as `localhost`, which is not a suitable route from the cloud service to my laptop; the connection also initially lacked credentials. The exact contribution of credentials, TLS, driver, or other validation details was not isolated. The defensible conclusion is that the original Cloud connection did not validate, and I tested a separate on-premises gateway route.

### Q: Why not delete the Cloud connection after creating the gateway connection?
**Answer:** I kept it so the original setup remained available for diagnosis and comparison. Once the on-premises route was proven through a successful refresh, I could investigate or clean up the Cloud connection separately, but I should not delete it without a deliberate decision and confirmation that no other item depends on it.

## E. Creating and mapping the correct on-premises MySQL connection

### Q: What details were used to create the new connection?
**Answer:** In **Manage Connections and Gateways → Connections → New**, I chose **On-premises**, gateway cluster `MySQL_OnPrem_Gateway`, connection type `MySQL`, and name `Marketing_Funnel_MySQL_Connection`. I used server `localhost:3306`, database `marketing_funnel_mysql`, Basic authentication, the MySQL username `root`, encrypted connection `Encrypted`, and privacy level `Organizational`. I did not enable “Skip test connection.” The UI confirmed that the connection was created.

### Q: What proved the new connection was associated with the gateway?
**Answer:** In Manage Connections and Gateways, the new connection row showed type `MySQL` and gateway cluster name `MySQL_OnPrem_Gateway`. This verified the connection object was created under the intended gateway, but it was not enough on its own to prove refresh would succeed.

### Q: How did I map the semantic model to the gateway connection?
**Answer:** In the semantic model's **Settings → Gateway and cloud connections**, I switched **Use an On-premises or VNet data gateway** On, selected the gateway shown as running on `<LOCAL_GATEWAY_HOST>`, and mapped the MySQL source for `localhost:3306` and `marketing_funnel_mysql` to `Marketing_Funnel_MySQL_Connection`. I clicked **Apply** and received confirmation that the gateway connection was updated.

### Q: What is the difference between a connection being created and a refresh succeeding?
**Answer:** A created connection confirms the connection object and its configuration were saved. The semantic model still needs to be mapped to it, credentials must be usable, the gateway must reach the database, and the refresh itself must complete. I therefore treat the on-demand refresh history as the end-to-end test rather than relying on the creation confirmation alone.

## F. Successful refresh and remaining validation

### Q: What was the final manual refresh result?
**Answer:** After mapping the semantic model to `Marketing_Funnel_MySQL_Connection`, I ran **Refresh now** for `Marketing_Funnel_Campaign_Intelligence_using_MySQL_database`. Refresh history showed Type `On demand`, Start `10/16/2026, 9:20:03 AM`, End `10/16/2026, 9:20:35 AM`, Status `Completed`. The duration was 32 seconds. This is direct evidence that the mapped on-premises route successfully refreshed the semantic model at that time.

### Q: Does a completed manual refresh mean scheduled refresh is configured?
**Answer:** No. A manual refresh proves only that an on-demand refresh completed. At the 16 October 2026 checkpoint, scheduled refresh had not yet been validated. A later scheduled-refresh test completed successfully on 18 October 2026 (see Q145 and the current status at the top). Future scheduled runs and gateway/MySQL availability still need monitoring.

### Q: Does a completed refresh prove every dashboard measure is correct?
**Answer:** No. It confirms the refresh operation completed, but I should still open the report, compare key KPI values against Desktop or known validation results, and investigate any unexpected differences. Refresh success and business/data correctness are separate validation checks.

### Q: What were the next validation steps after the 16 October manual refresh?
**Answer (historical checkpoint, updated with later evidence):** At that time, the next steps were report comparison, scheduled refresh, and additional RLS testing. By 18 October, documented Service/Desktop comparisons had been performed for selected scenarios and one scheduled-refresh test had completed successfully. Remaining work is to monitor future scheduled runs, test gateway/MySQL availability after a laptop restart, finish full KPI/source parity checks, reconcile live table counts, and validate Mumbai, Delhi, and `ALL` RLS scenarios with suitable authorized identities. The original CSV report remains untouched.

## G. Short interview summary / STAR-style explanation

### Q: Explain the issue and resolution in a concise interview answer.
**Answer (updated to current documented state):** “I migrated a Power BI marketing funnel report from CSV files to a local MySQL database and published a separate MySQL-based semantic model, keeping the original CSV report and PBIX untouched. The Service refresh initially failed because the local data source lacked a working route through the cloud connection. I diagnosed a gateway installer failure using its log: error `0x80070070` occurred when C: had only 30.3 MB free, even though I selected D: as the installation location. After safely clearing temporary files, I registered an on-premises gateway, created and mapped a MySQL connection, and verified a successful manual refresh. On 18 October, a scheduled-refresh test also completed successfully. I configured the intended 10 AM and 8 PM IST schedule, which still needs ongoing monitoring. I also tested Bangalore RLS behavior in Desktop and Service; additional city mappings and full CSV-to-MySQL KPI parity remain follow-up work.”

---

# New Interview Questions — Power BI Service, Gateway, Refresh and RLS (18 October 2026)



### Live row-count verification query

Use this before stating the current total in an interview or README. The result is live only when run against the current MySQL database.

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
SELECT table_name, row_count FROM table_counts
UNION ALL
SELECT 'TOTAL', SUM(row_count) FROM table_counts;
```

### Q143. What is the difference between publishing a Power BI report and configuring scheduled refresh?
**Answer:** Publishing sends the report and semantic model to Power BI Service. Refresh configuration is a separate step that tells the Service how to retrieve updated data. For a local database, the source credentials and gateway mapping must be configured appropriately before scheduled refresh can work.

### Q144. Why did you configure an on-premises data gateway for a local MySQL database?
**Answer:** MySQL was running on my laptop, while Power BI Service runs in Microsoft's cloud. The on-premises gateway provides a secure bridge so the Service can reach the local data source for refresh. The laptop, MySQL service and gateway must be running and reachable at refresh time.

### Q145. How did you verify that scheduled refresh was working?
**Answer:** I enabled a daily schedule in India Standard Time and checked Refresh History. The 18 October scheduled test started at 6:01 PM and completed at 6:12:03 PM. The history showed a total elapsed duration of 11 minutes 3 seconds, while the data stage itself ran for 22 seconds. I recorded the successful status and did not assume the unexplained wait before the data stage was caused by the gateway.

### Q146. Why can a scheduled refresh take longer overall than the data refresh stage?
**Answer:** The overall request elapsed time and the data-processing stage duration are different measurements. In my test, the request started at 6:01 PM, but the data stage began at 6:11:40 PM and finished at 6:12:03 PM. The UI did not provide enough evidence to identify the reason for the gap, so I would investigate logs or further runs rather than guess.

### Q147. How did you validate RLS in Power BI Desktop and Service?
**Answer:** I temporarily added a table containing `FactLeads[City]`. With no role applied, all cities were visible. Under `RLS_Bangalore`, only Bangalore was visible. Under `RLS_Dynamic`, when tested with the Chetan/Bangalore identity mapping, only Bangalore was visible. I repeated the role test in Power BI Service and observed the same behavior, then removed the temporary visual and restored the report layout.

### Q148. Why is opening a report normally as a Workspace Admin not a valid RLS test?
**Answer:** Workspace Admins, Members and Contributors generally have edit-level workspace permissions and aren't restricted by RLS in the same way as Viewers. I use the Service's Test as role functionality or an appropriate Viewer account to validate the role's row filtering.

### Q149. Does a successful manual refresh prove scheduled refresh works?
**Answer:** No. Manual refresh confirms that a refresh can succeed on demand. Scheduled refresh must be verified separately by checking a scheduled entry in Refresh History and confirming its final status.

### Q150. What precautions did you take when troubleshooting a separate MySQL deployment?
**Answer:** I kept the original CSV-based report and semantic model untouched and published the MySQL version under a distinct name. I verified the MySQL source and gateway mapping on the correct semantic model instead of assuming the original CSV model's credential warning applied to the MySQL model.

### Q151. What is still unvalidated in the RLS implementation?
**Answer:** The Bangalore mapping was validated in Desktop and Service. Additional Mumbai, Delhi and `ALL` identity scenarios still need testing in Service. I would not claim those scenarios passed until I have evidence from an appropriate test identity.

### Q152. What would you include when publishing this project to GitHub?
**Answer:** I would include a clear README, business problem and KPIs, architecture/data-flow diagram, data dictionary, model/relationship explanation, selected DAX measures, sanitized screenshots, refresh and RLS test results, and setup instructions. I would exclude passwords, gateway secrets, private account details, sensitive source data and machine-specific paths.


---

# Consolidated Answer Boundaries — 18 October 2026

- **MySQL import:** all nine project tables were imported; individual row counts are recorded in `PROJECT_LOG.md`. The historical aggregate total of 83,754 conflicts with the arithmetic sum of the recorded individual counts (120,134), so the aggregate must be rechecked in MySQL before it is stated as verified.
- **Gateway and refresh:** the gateway was registered and online, the MySQL semantic model was mapped to the on-premises connection, a manual refresh succeeded, and a scheduled-refresh test completed successfully on 18 October. The configured daily slots are 10:00 AM and 8:00 PM IST; future slot-specific runs still need monitoring.
- **RLS:** Bangalore behavior was tested in Desktop and Service using role testing. Mumbai, Delhi, and `ALL` scenarios remain unvalidated in Service. Do not describe them as passed. Normal workspace-admin viewing is not a valid substitute for a role test.
- **KPI parity:** the post-migration display of approximately 48M Revenue and 10.17 ROAS was an observation, not by itself proof of parity with the original CSV model. Report only the comparison scenarios actually checked.
- **Credential hardening:** the historical gateway connection used the MySQL username `root`. Before a public demo or production-like setup, use a dedicated least-privilege account and keep credentials/recovery keys out of GitHub.
- **Cohort analysis:** the acquisition-cohort funnel is implemented; a full month-0/month-1/month-2 cohort matrix remains a future enhancement.
- **Publication:** GitHub upload has not been performed as part of this consolidation. Prepare sanitized, GitHub-safe assets only after the user reviews these two master documents.


## Consolidation audit update — 18 October 2026

- Corrected the old 83,754-row interview answer so it no longer presents an internally inconsistent aggregate as confirmed. Added a live SQL verification query.
- Updated the deployment interview summary and next steps to reflect the successful 18 October scheduled-refresh test, while retaining follow-up monitoring and other unresolved validations.
- Sanitized personal email identities, local Windows user paths, and the local gateway host/name in examples for safer sharing. `@example.com` identities are placeholders only and are not actual RLS test accounts.
- These are documentation corrections only: the live MySQL row counts were not queried during this edit, and no GitHub upload was performed.

- **Security review:** added the least-privilege MySQL account follow-up; do not expose credentials or gateway recovery keys.
