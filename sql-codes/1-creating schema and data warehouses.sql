

-- ============================================================
-- CREATE STAGING DATABASE
-- ===========================================================

if not exists(
             SELECT 
                   1
             FROM 
                 sys.databases
             WHERE
                 name = 'collage_stg'
              ) 
              CREATE DATABASE collage_stg;

-- ============================================================
-- CREATE BRONZE SCHEMA IN STAGING DATABASE
-- ============================================================

USE collage_stg;
go

if not exists(
              SELECT 
                    1 
              FROM 
                   sys.schemas
              WHERE
                   name = 'bronze'
) execute ('CREATE SCHEMA bronze');



-- ============================================================
-- CREATE DATA WAREHOUSE DATABASE
-- ============================================================


if not exists( 
      SELECT 
            1
      FROM 
           sys.databases
     WHERE 
          name = 'dwh_collage'
          )
CREATE DATABASE dwh_collage;


-- ============================================================
-- CREATE SILVER SCHEMA
-- ============================================================


USE dwh_collage;
go

if not exists(
    SELECT 
          1
    FROM 
         sys.schemas
    WHERE
        name = 'silver'
) execute('CREATE SCHEMA silver');


-- ============================================================
-- CREATE GOLD SCHEMA
-- ============================================================



USE dwh_collage;
go

if not exists(
        SELECT 
              1
        FROM 
             sys.schemas
        WHERE 
             name = 'gold'
        ) execute ('CREATE SCHEMA gold');







