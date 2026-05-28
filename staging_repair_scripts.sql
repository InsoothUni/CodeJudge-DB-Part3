-- ==========================================
-- TASK 6: REPAIR SCRIPTS ON STAGING TABLES
-- ==========================================

-- Create Staging Tables
CREATE TABLE stg_submissions AS SELECT * FROM submissions;
CREATE TABLE stg_enrollments AS SELECT * FROM enrollments;
CREATE TABLE stg_students AS SELECT * FROM students;
CREATE TABLE stg_attendance AS SELECT * FROM attendance;

-- ---------------------------------------------------------
-- REPAIR 1: Fix Negative Scores
-- Decision: Update negative scores to 0 as they represent un-scored/error states.
-- ---------------------------------------------------------
SELECT submission_id, score FROM stg_submissions WHERE score < 0;

UPDATE stg_submissions 
SET score = 0 
WHERE score < 0;

SELECT submission_id, score FROM stg_submissions WHERE score < 0;

-- ---------------------------------------------------------
-- REPAIR 2: Delete Orphaned Enrollments
-- Decision: Delete enrollments pointing to non-existent students.
-- ---------------------------------------------------------
SELECT e.enrollment_id, e.student_id 
FROM stg_enrollments e 
LEFT JOIN stg_students s ON e.student_id = s.student_id 
WHERE s.student_id IS NULL;

DELETE FROM stg_enrollments 
WHERE student_id NOT IN (SELECT student_id FROM stg_students);

SELECT e.enrollment_id, e.student_id 
FROM stg_enrollments e 
LEFT JOIN stg_students s ON e.student_id = s.student_id 
WHERE s.student_id IS NULL;

-- ---------------------------------------------------------
-- REPAIR 3: Fix Invalid Attendance Statuses
-- Decision: Standardize shorthand 'P' to 'Present'.
-- ---------------------------------------------------------
SELECT attendance_id, attendance_status FROM stg_attendance WHERE attendance_status = 'P';

UPDATE stg_attendance 
SET attendance_status = 'Present' 
WHERE attendance_status = 'P';

SELECT attendance_id, attendance_status FROM stg_attendance WHERE attendance_status = 'P';

-- ---------------------------------------------------------
-- REPAIR 4: Handle Invalid Batch IDs in Students
-- Decision: Set orphaned batch_ids to NULL to satisfy FK constraints pending manual review.
-- ---------------------------------------------------------
SELECT student_id, batch_id FROM stg_students WHERE batch_id NOT IN (SELECT batch_id FROM batches);

UPDATE stg_students 
SET batch_id = NULL 
WHERE batch_id NOT IN (SELECT batch_id FROM batches);

SELECT student_id, batch_id FROM stg_students WHERE batch_id NOT IN (SELECT batch_id FROM batches);

-- ---------------------------------------------------------
-- REPAIR 5: Cap Scores above Max Score
-- Decision: Cap erroneously high scores to the problem's max score limit.
-- ---------------------------------------------------------
SELECT s.submission_id, s.score, p.max_score 
FROM stg_submissions s JOIN problems p ON s.problem_id = p.problem_id 
WHERE s.score > p.max_score;

UPDATE stg_submissions 
SET score = (
    SELECT p.max_score 
    FROM problems p 
    WHERE p.problem_id = stg_submissions.problem_id
)
WHERE score > (
    SELECT p.max_score 
    FROM problems p 
    WHERE p.problem_id = stg_submissions.problem_id
);

SELECT s.submission_id, s.score, p.max_score 
FROM stg_submissions s JOIN problems p ON s.problem_id = p.problem_id 
WHERE s.score > p.max_score;
