 # Prelim Science Marks — Data Warehouse Project

## Project Overview

This project transforms a flat student marks CSV file into a structured data warehouse using the **Medallion Architecture**.

The source dataset contains **100 students**, their grade information, and marks for **7 subjects** in a wide-format structure.

The project builds a complete:

**Bronze → Silver → Gold**

data pipeline using SQL Server.

The purpose of the project is to demonstrate how raw data can be loaded, cleaned, transformed, validated, and aggregated into reporting-ready datasets.

---

## Architecture

```text
                    SOURCE
                       │
                       ▼
        prelim_science_students_marks.csv
                       │
                       ▼
                 ┌───────────┐
                 │  BRONZE   │
                 │ Raw +     │
                 │ Split     │
                 └─────┬─────┘
                       │
                       ▼
                 ┌───────────┐
                 │  SILVER   │
                 │ Cleaned + │
                 │ Typed +   │
                 │ Derived   │
                 └─────┬─────┘
                       │
                       ▼
                 ┌───────────┐
                 │   GOLD    │
                 │ Aggregated │
                 │ Reporting │
                 └───────────┘
```

The pipeline is split by grade band:

```text
Grade 10 → Bronze G10 → Silver G10
Grade 11 → Bronze G11 → Silver G11
Grade 12 → Bronze G12 → Silver G12
                         │
                         ▼
                    Gold Layer
```

---

# Source Data

**Source file:** `prelim_science_students_marks.csv`

The source contains:

* 100 students
* 7 subjects
* Student identification information
* Grade information
* Subject marks
* Overall total and average marks

The source data is provided as a single wide-format CSV file and is split into Grade 10, Grade 11, and Grade 12 during the Bronze loading process.

---

# Database Structure

Two databases are used in the project:

```text
collage_stg
└── bronze

dwh_collage
├── silver
└── gold
```

### Staging Database

`collage_stg`

Contains the Bronze layer and preserves the source data after splitting it by grade band.

### Data Warehouse

`dwh_collage`

Contains the Silver and Gold layers.

---

# Bronze Layer

## Purpose

The Bronze layer is the raw landing layer.

Its purpose is to preserve the source data before business transformations are applied.

The source dataset is split into three grade-specific tables:

```text
bronze.prelim_science_students_marks_g10
bronze.prelim_science_students_marks_g11
bronze.prelim_science_students_marks_g12
```

### Bronze responsibilities

* Split the source data by grade band.
* Preserve the original values.
* Do not clean student names.
* Do not calculate new fields.
* Do not apply pass/fail logic.
* Do not perform business transformations.

The Bronze layer therefore acts as the raw reference point for downstream processing.

---

# Silver Layer

## Purpose

The Silver layer contains cleaned, typed, validated, and conformed student-level data.

Each grade has its own Silver table:

```text
silver.prelim_science_students_marks_g10
silver.prelim_science_students_marks_g11
silver.prelim_science_students_marks_g12
```

### Silver transformations

The following transformations are applied:

### 1. Student name cleaning

Student names are trimmed and formatted consistently.

### 2. Subject mark conversion

The seven subject marks are converted to integer values.

The subjects are:

* Mathematics
* Physical Science
* Life Sciences
* English Home Language
* Life Orientation
* Information Technology
* Agricultural Science

### 3. Grade band

A `grade_band` column is derived from the original `grade`.

For example:

```text
10A → 10
10B → 10
11A → 11
11B → 11
12A → 12
12B → 12
```

This preserves the student's grade-band lineage throughout the pipeline.

### 4. Subjects failed

A `subjects_failed` column counts the number of subjects where the student's mark is below **40**.

For example:

```text
Mathematics          65
Physical Science     35
Life Sciences        72
English              31
Life Orientation     80
Information Technology 74
Agricultural Science 60
```

Two subjects are below 40, therefore:

```text
subjects_failed = 2
```

### 5. Overall result

The `overall_result` column is derived from `subjects_failed`.

```text
subjects_failed > 0 → FAIL
subjects_failed = 0 → PASS
```

Therefore, a student fails overall if at least one subject has a mark below 40.

---

# Gold Layer

The Gold layer contains aggregated, reporting-ready data.

No individual student-level records are stored in the Gold reporting tables.

Two Gold tables are created:

```text
gold.grade_summary
gold.subject_performance
```

---

# Grade Summary

The `gold.grade_summary` table provides one row for each grade band.

It contains:

| Column                | Description                                    |
| --------------------- | ---------------------------------------------- |
| `grade_band`          | Grade 10, 11, or 12                            |
| `student_count`       | Number of students in the grade                |
| `average_of_averages` | Average of students' overall average marks     |
| `pass_count`          | Number of students with an overall PASS result |
| `fail_count`          | Number of students with an overall FAIL result |
| `pass_rate`           | Percentage of students who passed              |

The table is aggregated from the Silver layer using `GROUP BY grade_band`.

The Gold layer does not read directly from the original CSV.

---

# Subject Performance

The `gold.subject_performance` table provides one row for each combination of:

```text
Grade Band × Subject
```

There are:

```text
3 grade bands × 7 subjects = 21 rows
```

The table contains:

| Column         | Description                             |
| -------------- | --------------------------------------- |
| `grade_band`   | Grade 10, 11, or 12                     |
| `subject`      | Subject name                            |
| `average_mark` | Average mark for the subject            |
| `min_mark`     | Lowest mark achieved                    |
| `max_mark`     | Highest mark achieved                   |
| `fail_count`   | Number of students with a mark below 40 |

The table is generated by aggregating the Silver student-level data.

---

# Data Quality

Data quality was considered during the transformation process.

The Silver layer is responsible for:

* Standardising student names.
* Converting subject marks to the required numeric data type.
* Preserving grade-band lineage.
* Identifying students with failed subjects.
* Deriving an overall pass/fail result.

Duplicate records are also considered during loading to prevent the same student from being repeatedly inserted into the Silver layer.

The Bronze layer remains unchanged so that the original source values can always be traced and compared against downstream transformations.

---

# Pass/Fail Rule

The project uses a **40-mark subject threshold** as specified by the project requirements.

```text
Subject mark < 40
        ↓
Subject failure
        ↓
subjects_failed increases
        ↓
subjects_failed > 0
        ↓
Overall result = FAIL
```

If no subject has a mark below 40:

```text
subjects_failed = 0
        ↓
Overall result = PASS
```

This logic is calculated at the Silver layer and then aggregated in Gold.

---

# Technologies

* **SQL Server**
* **T-SQL**
* **SQL Server Management Studio (SSMS)**
* **CSV**

---

# Project Structure

```text
school-report-etl/
│
├── README.md
│
├── BRONZE LAYER.sql
├── SILVER LAYER.sql
├── GOLD LAYER.sql
│
└── data/
    └── prelim_science_students_marks.csv
```

---

# Key SQL Concepts Demonstrated

This project demonstrates practical use of:

* Database creation
* Schema creation
* Table creation
* `IF NOT EXISTS`
* `INSERT INTO ... SELECT`
* `CASE`
* `COUNT`
* `AVG`
* `MIN`
* `MAX`
* `GROUP BY`
* `UNION ALL`
* `NOT EXISTS`
* Data type conversion
* Data cleaning
* Derived columns
* Conditional aggregation
* Medallion Architecture
* Bronze → Silver → Gold data flow

---

# Project Outcome

The completed pipeline transforms raw student marks into structured datasets suitable for reporting and analysis.

The final Gold layer allows users to answer questions such as:

* How many students are in each grade?
* What is the average overall performance by grade?
* How many students passed or failed?
* What is the pass rate for each grade?
* What is the average mark for each subject?
* What are the minimum and maximum marks by subject?
* How many students failed each subject?

The project demonstrates the full journey from **raw source data to reporting-ready business information** while maintaining grade-band lineage throughout the pipeline.
