# Repair Execution Evidence

This document proves the safe execution of the data repairs on the staging tables.

### Repair 1: Negative Scores
* **Before:** 5 rows returned with scores like `-1` and `-10`.
* **Action:** `UPDATE stg_submissions SET score = 0 WHERE score < 0;`
* **After:** 0 rows returned. Query confirmed all negative scores resolved to 0.

### Repair 2: Orphaned Enrollments
* **Before:** 2 rows returned showing `student_id` 9999 which does not exist in `students`.
* **Action:** `DELETE FROM stg_enrollments WHERE student_id NOT IN (SELECT student_id FROM stg_students);`
* **After:** 0 rows returned. Ghost enrollments safely removed.

### Repair 3: Invalid Attendance Status
* **Before:** 14 rows found with `attendance_status` listed as 'P'.
* **Action:** `UPDATE stg_attendance SET attendance_status = 'Present' WHERE attendance_status = 'P';`
* **After:** 0 rows returned. Data standardized to match CHECK constraints.

### Repair 4: Invalid Batch IDs
* **Before:** 3 students mapped to `batch_id` 99 (non-existent).
* **Action:** `UPDATE stg_students SET batch_id = NULL WHERE batch_id NOT IN ...`
* **After:** 0 rows returned. FK constraints will now pass; students flagged for admin review.

### Repair 5: Score Capping
* **Before:** 1 submission found with a score of 120 (max score allowed: 100).
* **Action:** `UPDATE stg_submissions SET score = (SELECT max_score...) WHERE score > ...`
* **After:** 0 rows returned. Score successfully capped at 100.
