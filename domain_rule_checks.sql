-- ==========================================
-- TASK 4: DOMAIN AND RULE VALIDATION
-- ==========================================

-- 1. Negative scores
SELECT submission_id, score 
FROM submissions 
WHERE score < 0;

-- 2. Scores greater than maximum allowed marks
SELECT s.submission_id, s.score, p.max_score 
FROM submissions s
JOIN problems p ON s.problem_id = p.problem_id
WHERE s.score > p.max_score;

-- 3. Invalid difficulty values
SELECT problem_id, difficulty 
FROM problems 
WHERE difficulty NOT IN ('Easy', 'Medium', 'Hard');

-- 4. Invalid attendance statuses
SELECT attendance_id, attendance_status 
FROM attendance 
WHERE attendance_status NOT IN ('Present', 'Absent', 'Late');

-- 5. End time before start time in contests
SELECT contest_id, start_time, end_time 
FROM contests 
WHERE end_time <= start_time;

-- 6. Resolved time before requested time in regrades
SELECT request_id, requested_at, resolved_at 
FROM regrade_requests 
WHERE resolved_at < requested_at;

-- 7. NULL values in columns that should be mandatory
SELECT problem_id 
FROM problems 
WHERE title IS NULL OR title = '';
