-- ==========================================
-- TASK 1: ROW COUNT AND IMPORT VALIDATION
-- ==========================================

-- 1. Row count of each table (Example for a few core tables, repeat as needed)
SELECT 'students' AS table_name, COUNT(*) AS row_count FROM students
UNION ALL
SELECT 'submissions', COUNT(*) FROM submissions
UNION ALL
SELECT 'test_results', COUNT(*) FROM test_results;

-- 2. Number of distinct primary key values in each table
SELECT 'students' AS table_name, COUNT(DISTINCT student_id) AS distinct_pks FROM students
UNION ALL
SELECT 'submissions', COUNT(DISTINCT submission_id) FROM submissions;

-- 3. Number of NULL or blank values in important columns
SELECT 
    COUNT(CASE WHEN full_name IS NULL OR full_name = '' THEN 1 END) as missing_names,
    COUNT(CASE WHEN email IS NULL OR email = '' THEN 1 END) as missing_emails
FROM students;

-- 4. Check if any expected table is empty
SELECT 
    (SELECT COUNT(*) FROM batches) AS batches_count,
    (SELECT COUNT(*) FROM courses) AS courses_count;
    -- If any return 0, the table is empty.
