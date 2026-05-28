-- ==========================================
-- TASK 2: PRIMARY KEY AND UNIQUENESS AUDIT
-- ==========================================

-- 1. Duplicate Primary Key values (Example: students)
SELECT student_id, COUNT(*) 
FROM students 
GROUP BY student_id HAVING COUNT(*) > 1;

-- 2. Duplicate Email values (Candidate Key)
SELECT email, COUNT(*) 
FROM students 
WHERE email IS NOT NULL AND email != ''
GROUP BY email HAVING COUNT(*) > 1;

-- 3. Duplicate Enrollment records (Composite Key check)
SELECT student_id, course_id, COUNT(*) 
FROM enrollments 
GROUP BY student_id, course_id HAVING COUNT(*) > 1;

-- 4. Duplicate Test-Result records
SELECT submission_id, test_case_id, COUNT(*) 
FROM test_results 
GROUP BY submission_id, test_case_id HAVING COUNT(*) > 1;

-- ==========================================
-- TASK 3: FOREIGN KEY AND RELATIONSHIP AUDIT
-- ==========================================

-- 1. Students linked to missing batches
SELECT s.student_id, s.batch_id 
FROM students s 
LEFT JOIN batches b ON s.batch_id = b.batch_id 
WHERE s.batch_id IS NOT NULL AND b.batch_id IS NULL;

-- 2. Enrollments linked to missing students
SELECT e.enrollment_id, e.student_id 
FROM enrollments e 
LEFT JOIN students s ON e.student_id = s.student_id 
WHERE s.student_id IS NULL;

-- 3. Submissions linked to missing problems
SELECT sub.submission_id, sub.problem_id 
FROM submissions sub 
LEFT JOIN problems p ON sub.problem_id = p.problem_id 
WHERE p.problem_id IS NULL;

-- 4. Test results linked to missing submissions
SELECT tr.result_id, tr.submission_id 
FROM test_results tr 
LEFT JOIN submissions sub ON tr.submission_id = sub.submission_id 
WHERE sub.submission_id IS NULL;
