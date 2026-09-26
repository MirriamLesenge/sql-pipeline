 📊 Project Summary – Data Warehouse Pipeline (Medallion Architecture)
This project implements a Bronze → Silver → Gold data warehouse pipeline to process Grade 10–12 student marks from a single CSV source file. The design follows the Medallion Architecture, ensuring raw data preservation, structured cleaning, and reporting-ready aggregation.

Bronze Layer:
Raw student marks are split into three grade-specific tables (10, 11, 12) without modification. This preserves the integrity of the source data and provides full traceability for downstream processes.

Silver Layer:
Data is cleaned and standardized. Student names are trimmed and title-cased, subject marks are cast to integers, and derived fields such as grade_band, subjects_failed, and overall_result are introduced. This layer enforces consistency and embeds business rules (e.g., pass/fail thresholds).

Gold Layer:
Aggregated reporting tables are created for decision-making.

Grade Summary: Provides student counts, average performance, pass/fail counts, and pass rates per grade.

Subject Performance: Delivers subject-level insights (average, min, max marks, fail counts) across all grades.

This structured pipeline ensures data lineage, quality, and usability. It supports both operational monitoring (student-level detail in Silver) and strategic reporting (aggregates in Gold). The approach demonstrates strong data engineering practices, balancing raw data preservation with business-ready insights.
