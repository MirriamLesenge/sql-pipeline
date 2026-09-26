-- ================================================================
--Table creation:
--Creates the gold.grade_summary table to store overall performance 
--statistics for Grades 10, 11, and 12.
-- =================================================================

USE dwh_collage;
GO

CREATE TABLE gold.grade_summary (
    grade_band              NVARCHAR(10),
    student_count           INT,
    average_of_averages     DECIMAL(5,2),
    pass_count              INT,
    fail_count              INT,
    pass_rate               DECIMAL(5,2)
);

-- ============================================================
--Student count:
--Counts the number of students in each grade and inserts one 
--summary row for each grade.
-- ============================================================


INSERT INTO gold.grade_summary (grade_band, student_count)

SELECT
    '10' AS grade_band,
    COUNT(*) AS student_count
FROM silver.prelim_science_students_marks_g10

UNION ALL

SELECT
    '11' AS grade_band,
    COUNT(*) AS student_count
FROM silver.prelim_science_students_marks_g11

UNION ALL

SELECT
    '12' AS grade_band,
    COUNT(*) AS student_count
FROM silver.prelim_science_students_marks_g12;

-- ==========================================================================
--Average of averages:
--Calculates the average of the students' overall average marks for each grade.
-- ===========================================================================


USE dwh_collage;
GO

UPDATE gold.grade_summary
SET average_of_averages =
    CASE
        WHEN grade_band = '10' THEN
            (SELECT AVG(average_mark)
             FROM silver.prelim_science_students_marks_g10)

        WHEN grade_band = '11' THEN
            (SELECT AVG(average_mark)
             FROM silver.prelim_science_students_marks_g11)

        WHEN grade_band = '12' THEN
            (SELECT AVG(average_mark)
             FROM silver.prelim_science_students_marks_g12)
    END;


-- =============================================================================
--Pass count:
--Counts the number of students in each grade whose average mark is 50 or higher.
-- ==============================================================================


USE dwh_collage;
GO

UPDATE gold.grade_summary
SET
    pass_count =
        CASE
            WHEN grade_band = '10' THEN
                (SELECT COUNT(*)
                 FROM silver.prelim_science_students_marks_g10
                 WHERE average_mark >= 50)

            WHEN grade_band = '11' THEN
                (SELECT COUNT(*)
                 FROM silver.prelim_science_students_marks_g11
                 WHERE average_mark >= 50)

            WHEN grade_band = '12' THEN
                (SELECT COUNT(*)
                 FROM silver.prelim_science_students_marks_g12
                 WHERE average_mark >= 50)
        END;

-- =======================================================================
--Fail count:
--Counts the number of students in each grade whose average mark is below 50.
-- =========================================================================


USE dwh_collage;
GO

UPDATE gold.grade_summary
SET
    fail_count =
        CASE
            WHEN grade_band = '10' THEN
                (SELECT COUNT(*)
                 FROM silver.prelim_science_students_marks_g10
                 WHERE average_mark < 50)

            WHEN grade_band = '11' THEN
                (SELECT COUNT(*)
                 FROM silver.prelim_science_students_marks_g11
                 WHERE average_mark < 50)

            WHEN grade_band = '12' THEN
                (SELECT COUNT(*)
                 FROM silver.prelim_science_students_marks_g12
                 WHERE average_mark < 50)
        END;

-- =======================================================================================================================
---Pass rate:
---Calculates the percentage of students who passed in each grade by dividing the pass count by the total number of students.
-- =========================================================================================================================

USE dwh_collage;
GO

UPDATE gold.grade_summary
SET
    Pass_rate =
        CASE
            WHEN grade_band = '10' THEN
                (SELECT
                    COUNT(CASE WHEN average_mark >= 50 THEN 1 END) * 100.0
                    / COUNT(*)
                 FROM silver.prelim_science_students_marks_g10)

            WHEN grade_band = '11' THEN
                (SELECT
                    COUNT(CASE WHEN average_mark >= 50 THEN 1 END) * 100.0
                    / COUNT(*)
                 FROM silver.prelim_science_students_marks_g11)

            WHEN grade_band = '12' THEN
                (SELECT
                    COUNT(CASE WHEN average_mark >= 50 THEN 1 END) * 100.0
                    / COUNT(*)
                 FROM silver.prelim_science_students_marks_g12)
        END;

SELECT *
FROM gold.grade_summary;

-- =======================================================================================================================
--Table creation:
--Creates the gold.subject_performance table to store performance statistics for each subject across Grades 10, 11, and 12.
-- =======================================================================================================================

USE dwh_collage;
GO

CREATE TABLE gold.subject_performance
(
    grade_band NVARCHAR(10),
    subject NVARCHAR(100),
    average_mark DECIMAL(10,2),
    min_mark INT,
    max_mark INT,
    fail_count INT
);


-- ==========================================================================
--Grade and subject combinations:
--Creates one row for each grade and subject combination, resulting in 21 rows.
-- =============================================================================

USE dwh_collage;
GO

INSERT INTO gold.subject_performance
    (grade_band, subject)

SELECT '10', 'Mathematics'
UNION ALL
SELECT '10', 'Physical Science'
UNION ALL
SELECT '10', 'Life Sciences'
UNION ALL
SELECT '10', 'English Home Language'
UNION ALL
SELECT '10', 'Life Orientation'
UNION ALL
SELECT '10', 'Information Technology'
UNION ALL
SELECT '10', 'Agricultural Science'

UNION ALL

SELECT '11', 'Mathematics'
UNION ALL
SELECT '11', 'Physical Science'
UNION ALL
SELECT '11', 'Life Sciences'
UNION ALL
SELECT '11', 'English Home Language'
UNION ALL
SELECT '11', 'Life Orientation'
UNION ALL
SELECT '11', 'Information Technology'
UNION ALL
SELECT '11', 'Agricultural Science'

UNION ALL

SELECT '12', 'Mathematics'
UNION ALL
SELECT '12', 'Physical Science'
UNION ALL
SELECT '12', 'Life Sciences'
UNION ALL
SELECT '12', 'English Home Language'
UNION ALL
SELECT '12', 'Life Orientation'
UNION ALL
SELECT '12', 'Information Technology'
UNION ALL
SELECT '12', 'Agricultural Science';

-- ============================================================
--Average mark:
--Calculates the average mark for each subject within each grade.
-- ============================================================

UPDATE gold.subject_performance
SET average_mark =
    CASE

        WHEN grade_band = '10' AND subject = 'Mathematics' THEN
            (SELECT AVG(mathematics_mark)
             FROM silver.prelim_science_students_marks_g10)

        WHEN grade_band = '10' AND subject = 'Physical Science' THEN
            (SELECT AVG(physical_science_mark)
             FROM silver.prelim_science_students_marks_g10)

        WHEN grade_band = '10' AND subject = 'Life Sciences' THEN
            (SELECT AVG(life_sciences_mark)
             FROM silver.prelim_science_students_marks_g10)

        WHEN grade_band = '10' AND subject = 'English Home Language' THEN
            (SELECT AVG(english_home_language_mark)
             FROM silver.prelim_science_students_marks_g10)

        WHEN grade_band = '10' AND subject = 'Life Orientation' THEN
            (SELECT AVG(life_orientation_mark)
             FROM silver.prelim_science_students_marks_g10)

        WHEN grade_band = '10' AND subject = 'Information Technology' THEN
            (SELECT AVG(information_technology_mark)
             FROM silver.prelim_science_students_marks_g10)

        WHEN grade_band = '10' AND subject = 'Agricultural Science' THEN
            (SELECT AVG(agricultural_science_mark)
             FROM silver.prelim_science_students_marks_g10)


        WHEN grade_band = '11' AND subject = 'Mathematics' THEN
            (SELECT AVG(mathematics_mark)
             FROM silver.prelim_science_students_marks_g11)

        WHEN grade_band = '11' AND subject = 'Physical Science' THEN
            (SELECT AVG(physical_science_mark)
             FROM silver.prelim_science_students_marks_g11)

        WHEN grade_band = '11' AND subject = 'Life Sciences' THEN
            (SELECT AVG(life_sciences_mark)
             FROM silver.prelim_science_students_marks_g11)

        WHEN grade_band = '11' AND subject = 'English Home Language' THEN
            (SELECT AVG(english_home_language_mark)
             FROM silver.prelim_science_students_marks_g11)

        WHEN grade_band = '11' AND subject = 'Life Orientation' THEN
            (SELECT AVG(life_orientation_mark)
             FROM silver.prelim_science_students_marks_g11)

        WHEN grade_band = '11' AND subject = 'Information Technology' THEN
            (SELECT AVG(information_technology_mark)
             FROM silver.prelim_science_students_marks_g11)

        WHEN grade_band = '11' AND subject = 'Agricultural Science' THEN
            (SELECT AVG(agricultural_science_mark)
             FROM silver.prelim_science_students_marks_g11)


        WHEN grade_band = '12' AND subject = 'Mathematics' THEN
            (SELECT AVG(mathematics_mark)
             FROM silver.prelim_science_students_marks_g12)

        WHEN grade_band = '12' AND subject = 'Physical Science' THEN
            (SELECT AVG(physical_science_mark)
             FROM silver.prelim_science_students_marks_g12)

        WHEN grade_band = '12' AND subject = 'Life Sciences' THEN
            (SELECT AVG(life_sciences_mark)
             FROM silver.prelim_science_students_marks_g12)

        WHEN grade_band = '12' AND subject = 'English Home Language' THEN
            (SELECT AVG(english_home_language_mark)
             FROM silver.prelim_science_students_marks_g12)

        WHEN grade_band = '12' AND subject = 'Life Orientation' THEN
            (SELECT AVG(life_orientation_mark)
             FROM silver.prelim_science_students_marks_g12)

        WHEN grade_band = '12' AND subject = 'Information Technology' THEN
            (SELECT AVG(information_technology_mark)
             FROM silver.prelim_science_students_marks_g12)

        WHEN grade_band = '12' AND subject = 'Agricultural Science' THEN
            (SELECT AVG(agricultural_science_mark)
             FROM silver.prelim_science_students_marks_g12)

    END;

-- =================================================================
--Minimum mark:
--Identifies the lowest mark achieved in each subject for each grade.
-- ==================================================================

UPDATE gold.subject_performance
SET min_mark =
    CASE
        WHEN grade_band = '10' AND subject = 'Mathematics' THEN
            (SELECT MIN(mathematics_mark)
             FROM silver.prelim_science_students_marks_g10)

        WHEN grade_band = '10' AND subject = 'Physical Science' THEN
            (SELECT MIN(physical_science_mark)
             FROM silver.prelim_science_students_marks_g10)

        WHEN grade_band = '10' AND subject = 'Life Sciences' THEN
            (SELECT MIN(life_sciences_mark)
             FROM silver.prelim_science_students_marks_g10)

        WHEN grade_band = '10' AND subject = 'English Home Language' THEN
            (SELECT MIN(english_home_language_mark)
             FROM silver.prelim_science_students_marks_g10)

        WHEN grade_band = '10' AND subject = 'Life Orientation' THEN
            (SELECT MIN(life_orientation_mark)
             FROM silver.prelim_science_students_marks_g10)

        WHEN grade_band = '10' AND subject = 'Information Technology' THEN
            (SELECT MIN(information_technology_mark)
             FROM silver.prelim_science_students_marks_g10)

        WHEN grade_band = '10' AND subject = 'Agricultural Science' THEN
            (SELECT MIN(agricultural_science_mark)
             FROM silver.prelim_science_students_marks_g10)


        WHEN grade_band = '11' AND subject = 'Mathematics' THEN
            (SELECT MIN(mathematics_mark)
             FROM silver.prelim_science_students_marks_g11)

        WHEN grade_band = '11' AND subject = 'Physical Science' THEN
            (SELECT MIN(physical_science_mark)
             FROM silver.prelim_science_students_marks_g11)

        WHEN grade_band = '11' AND subject = 'Life Sciences' THEN
            (SELECT MIN(life_sciences_mark)
             FROM silver.prelim_science_students_marks_g11)

        WHEN grade_band = '11' AND subject = 'English Home Language' THEN
            (SELECT MIN(english_home_language_mark)
             FROM silver.prelim_science_students_marks_g11)

        WHEN grade_band = '11' AND subject = 'Life Orientation' THEN
            (SELECT MIN(life_orientation_mark)
             FROM silver.prelim_science_students_marks_g11)

        WHEN grade_band = '11' AND subject = 'Information Technology' THEN
            (SELECT MIN(information_technology_mark)
             FROM silver.prelim_science_students_marks_g11)

        WHEN grade_band = '11' AND subject = 'Agricultural Science' THEN
            (SELECT MIN(agricultural_science_mark)
             FROM silver.prelim_science_students_marks_g11)


        WHEN grade_band = '12' AND subject = 'Mathematics' THEN
            (SELECT MIN(mathematics_mark)
             FROM silver.prelim_science_students_marks_g12)

        WHEN grade_band = '12' AND subject = 'Physical Science' THEN
            (SELECT MIN(physical_science_mark)
             FROM silver.prelim_science_students_marks_g12)

        WHEN grade_band = '12' AND subject = 'Life Sciences' THEN
            (SELECT MIN(life_sciences_mark)
             FROM silver.prelim_science_students_marks_g12)

        WHEN grade_band = '12' AND subject = 'English Home Language' THEN
            (SELECT MIN(english_home_language_mark)
             FROM silver.prelim_science_students_marks_g12)

        WHEN grade_band = '12' AND subject = 'Life Orientation' THEN
            (SELECT MIN(life_orientation_mark)
             FROM silver.prelim_science_students_marks_g12)

        WHEN grade_band = '12' AND subject = 'Information Technology' THEN
            (SELECT MIN(information_technology_mark)
             FROM silver.prelim_science_students_marks_g12)

        WHEN grade_band = '12' AND subject = 'Agricultural Science' THEN
            (SELECT MIN(agricultural_science_mark)
             FROM silver.prelim_science_students_marks_g12)
    END;

-- =================================================================
--Maximum mark:
--Identifies the highest mark achieved in each subject for each grade.
-- ==================================================================

UPDATE gold.subject_performance
SET max_mark =
    CASE
        WHEN grade_band = '10' AND subject = 'Mathematics' THEN
            (SELECT MAX(mathematics_mark)
             FROM silver.prelim_science_students_marks_g10)

        WHEN grade_band = '10' AND subject = 'Physical Science' THEN
            (SELECT MAX(physical_science_mark)
             FROM silver.prelim_science_students_marks_g10)

        WHEN grade_band = '10' AND subject = 'Life Sciences' THEN
            (SELECT MAX(life_sciences_mark)
             FROM silver.prelim_science_students_marks_g10)

        WHEN grade_band = '10' AND subject = 'English Home Language' THEN
            (SELECT MAX(english_home_language_mark)
             FROM silver.prelim_science_students_marks_g10)

        WHEN grade_band = '10' AND subject = 'Life Orientation' THEN
            (SELECT MAX(life_orientation_mark)
             FROM silver.prelim_science_students_marks_g10)

        WHEN grade_band = '10' AND subject = 'Information Technology' THEN
            (SELECT MAX(information_technology_mark)
             FROM silver.prelim_science_students_marks_g10)

        WHEN grade_band = '10' AND subject = 'Agricultural Science' THEN
            (SELECT MAX(agricultural_science_mark)
             FROM silver.prelim_science_students_marks_g10)


        WHEN grade_band = '11' AND subject = 'Mathematics' THEN
            (SELECT MAX(mathematics_mark)
             FROM silver.prelim_science_students_marks_g11)

        WHEN grade_band = '11' AND subject = 'Physical Science' THEN
            (SELECT MAX(physical_science_mark)
             FROM silver.prelim_science_students_marks_g11)

        WHEN grade_band = '11' AND subject = 'Life Sciences' THEN
            (SELECT MAX(life_sciences_mark)
             FROM silver.prelim_science_students_marks_g11)

        WHEN grade_band = '11' AND subject = 'English Home Language' THEN
            (SELECT MAX(english_home_language_mark)
             FROM silver.prelim_science_students_marks_g11)

        WHEN grade_band = '11' AND subject = 'Life Orientation' THEN
            (SELECT MAX(life_orientation_mark)
             FROM silver.prelim_science_students_marks_g11)

        WHEN grade_band = '11' AND subject = 'Information Technology' THEN
            (SELECT MAX(information_technology_mark)
             FROM silver.prelim_science_students_marks_g11)

        WHEN grade_band = '11' AND subject = 'Agricultural Science' THEN
            (SELECT MAX(agricultural_science_mark)
             FROM silver.prelim_science_students_marks_g11)


        WHEN grade_band = '12' AND subject = 'Mathematics' THEN
            (SELECT MAX(mathematics_mark)
             FROM silver.prelim_science_students_marks_g12)

        WHEN grade_band = '12' AND subject = 'Physical Science' THEN
            (SELECT MAX(physical_science_mark)
             FROM silver.prelim_science_students_marks_g12)

        WHEN grade_band = '12' AND subject = 'Life Sciences' THEN
            (SELECT MAX(life_sciences_mark)
             FROM silver.prelim_science_students_marks_g12)

        WHEN grade_band = '12' AND subject = 'English Home Language' THEN
            (SELECT MAX(english_home_language_mark)
             FROM silver.prelim_science_students_marks_g12)

        WHEN grade_band = '12' AND subject = 'Life Orientation' THEN
            (SELECT MAX(life_orientation_mark)
             FROM silver.prelim_science_students_marks_g12)

        WHEN grade_band = '12' AND subject = 'Information Technology' THEN
            (SELECT MAX(information_technology_mark)
             FROM silver.prelim_science_students_marks_g12)

        WHEN grade_band = '12' AND subject = 'Agricultural Science' THEN
            (SELECT MAX(agricultural_science_mark)
             FROM silver.prelim_science_students_marks_g12)
    END;

-- ==============================================================================
--Fail count:
--Counts the number of students who scored below 50 in each subject for each grade.
-- ================================================================================


UPDATE gold.subject_performance
SET fail_count =
    CASE
        WHEN grade_band = '10' AND subject = 'Mathematics' THEN
            (SELECT COUNT(*)
             FROM silver.prelim_science_students_marks_g10
             WHERE mathematics_mark < 50)

        WHEN grade_band = '10' AND subject = 'Physical Science' THEN
            (SELECT COUNT(*)
             FROM silver.prelim_science_students_marks_g10
             WHERE physical_science_mark < 50)

        WHEN grade_band = '10' AND subject = 'Life Sciences' THEN
            (SELECT COUNT(*)
             FROM silver.prelim_science_students_marks_g10
             WHERE life_sciences_mark < 50)

        WHEN grade_band = '10' AND subject = 'English Home Language' THEN
            (SELECT COUNT(*)
             FROM silver.prelim_science_students_marks_g10
             WHERE english_home_language_mark < 50)

        WHEN grade_band = '10' AND subject = 'Life Orientation' THEN
            (SELECT COUNT(*)
             FROM silver.prelim_science_students_marks_g10
             WHERE life_orientation_mark < 50)

        WHEN grade_band = '10' AND subject = 'Information Technology' THEN
            (SELECT COUNT(*)
             FROM silver.prelim_science_students_marks_g10
             WHERE information_technology_mark < 50)

        WHEN grade_band = '10' AND subject = 'Agricultural Science' THEN
            (SELECT COUNT(*)
             FROM silver.prelim_science_students_marks_g10
             WHERE agricultural_science_mark < 50)


        WHEN grade_band = '11' AND subject = 'Mathematics' THEN
            (SELECT COUNT(*)
             FROM silver.prelim_science_students_marks_g11
             WHERE mathematics_mark < 50)

        WHEN grade_band = '11' AND subject = 'Physical Science' THEN
            (SELECT COUNT(*)
             FROM silver.prelim_science_students_marks_g11
             WHERE physical_science_mark < 50)

        WHEN grade_band = '11' AND subject = 'Life Sciences' THEN
            (SELECT COUNT(*)
             FROM silver.prelim_science_students_marks_g11
             WHERE life_sciences_mark < 50)

        WHEN grade_band = '11' AND subject = 'English Home Language' THEN
            (SELECT COUNT(*)
             FROM silver.prelim_science_students_marks_g11
             WHERE english_home_language_mark < 50)

        WHEN grade_band = '11' AND subject = 'Life Orientation' THEN
            (SELECT COUNT(*)
             FROM silver.prelim_science_students_marks_g11
             WHERE life_orientation_mark < 50)

        WHEN grade_band = '11' AND subject = 'Information Technology' THEN
            (SELECT COUNT(*)
             FROM silver.prelim_science_students_marks_g11
             WHERE information_technology_mark < 50)

        WHEN grade_band = '11' AND subject = 'Agricultural Science' THEN
            (SELECT COUNT(*)
             FROM silver.prelim_science_students_marks_g11
             WHERE agricultural_science_mark < 50)


        WHEN grade_band = '12' AND subject = 'Mathematics' THEN
            (SELECT COUNT(*)
             FROM silver.prelim_science_students_marks_g12
             WHERE mathematics_mark < 50)

        WHEN grade_band = '12' AND subject = 'Physical Science' THEN
            (SELECT COUNT(*)
             FROM silver.prelim_science_students_marks_g12
             WHERE physical_science_mark < 50)

        WHEN grade_band = '12' AND subject = 'Life Sciences' THEN
            (SELECT COUNT(*)
             FROM silver.prelim_science_students_marks_g12
             WHERE life_sciences_mark < 50)

        WHEN grade_band = '12' AND subject = 'English Home Language' THEN
            (SELECT COUNT(*)
             FROM silver.prelim_science_students_marks_g12
             WHERE english_home_language_mark < 50)

        WHEN grade_band = '12' AND subject = 'Life Orientation' THEN
            (SELECT COUNT(*)
             FROM silver.prelim_science_students_marks_g12
             WHERE life_orientation_mark < 50)

        WHEN grade_band = '12' AND subject = 'Information Technology' THEN
            (SELECT COUNT(*)
             FROM silver.prelim_science_students_marks_g12
             WHERE information_technology_mark < 50)

        WHEN grade_band = '12' AND subject = 'Agricultural Science' THEN
            (SELECT COUNT(*)
             FROM silver.prelim_science_students_marks_g12
             WHERE agricultural_science_mark < 50)
    END;
SELECT *
FROM gold.subject_performance;