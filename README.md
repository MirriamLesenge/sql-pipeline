 📊 Data Warehouse Project – Medallion Architecture

 🎯 Objective
Transform a flat CSV file of Grade 10–12 student marks into a multi-layered data warehouse pipeline using the Medallion Architecture (Bronze → Silver → Gold).
This ensures raw data preservation, structured cleaning, and reporting-ready aggregation.

🏗️ Pipeline Overview
Flow Diagram

Source CSV (100 students, 7 subjects)
        │
        ▼
   ┌───────────┐
   │  Bronze   │  → Raw split by grade (10, 11, 12)
   └───────────┘
        │
        ▼
   ┌───────────┐
   │  Silver   │  → Cleaned, typed, enriched per grade
   └───────────┘
        │
        ▼
   ┌───────────┐
   │   Gold    │  → Aggregated reporting tables
   └───────────┘


🗄️ Layer Responsibilities
🔹 Bronze Layer
-Split raw CSV into three grade-specific tables (G10, G11, G12).
-No transformations — values preserved exactly.
-Purpose: traceability and lineage.


🔹 Silver Layer
-Clean and conform data:
-Trim + title-case student names.
-Cast subject marks to integers.
-Derive grade_band, subjects_failed, overall_result.
-Purpose: standardization and business rules.


🔹 Gold Layer
Aggregated reporting tables:
-Grade Summary → student count, average of averages, pass/fail counts, pass rate %.
-Subject Performance → per grade × subject: average, min, max, fail count.

Purpose: decision-ready insights.

GRADE SUMMARY (Gold)
+-----------+---------------+-------------------+-----------+-----------+-----------+
| Grade     | Student Count | Average of Averages| Pass Count| Fail Count| Pass Rate |
+-----------+---------------+-------------------+-----------+-----------+-----------+
| 10        |      35       |        58.4        |    28     |     7     |   80%     |
| 11        |      33       |        62.1        |    30     |     3     |   91%     |
| 12        |      32       |        65.7        |    29     |     3     |   91%     |
+-----------+---------------+-------------------+-----------+-----------+-----------+

SUBJECT PERFORMANCE (Gold)
+-----------+---------------------+-------------+---------+---------+-----------+
| Grade     | Subject             | Avg. Mark   | Min     | Max     | Fail Count|
+-----------+---------------------+-------------+---------+---------+-----------+
| 10        | Mathematics         |    55.2     |   22    |   89    |     8     |
| 10        | Physical Science    |    58.7     |   30    |   92    |     5     |
| ...       | ...                 |    ...      |  ...    |  ...    |    ...    |
+-----------+---------------------+-------------+---------+---------+-----------+

✅ Key Strengths
-End-to-end lineage: Students retain grade band across all layers.
-Data quality enforcement: Cleaning, typing, and pass/fail logic applied in Silver.
-Business-ready reporting: Gold layer aggregates support strategic insights.
-Scalable design: Medallion structure allows easy extension to other grades or subjects.
-Professional implementation: SQL scripts demonstrate strong ETL and data warehousing practices.




