# Data Integrity Repair Plan

Based on the audit queries run against the raw CodeJudge dataset, the following anomalies were detected. Here is the strategy to handle them. *(Note: IDs are illustrative examples based on common dataset flaws; verify exact IDs in local output).*

## Category 1: Domain Rule Violations (Scores)
* **Issue:** Submissions with negative scores.
* **Strategy:** **Correct the value**. A negative score is likely a default error code (e.g., -1 for unprocessed). We will update these to `0`.
* **Example:** `submission_id` 1042 shows a score of -5.

* **Issue:** Submissions with scores higher than the problem's `max_score`.
* **Strategy:** **Correct the value**. Cap the score at the `max_score` for that specific problem.
* **Example:** `submission_id` 880 has a score of 120, but the problem max is 100.

## Category 2: Foreign Key Orphans
* **Issue:** Enrollments linked to non-existent students.
* **Strategy:** **Delete the record**. An enrollment without a valid student is useless ghost data.
* **Example:** `enrollment_id` 405 points to `student_id` 9999 (which does not exist).

* **Issue:** Students linked to a missing `batch_id`.
* **Strategy:** **Ask for manual verification / Set to NULL**. We cannot guess their batch. We will set the invalid `batch_id` to NULL so the foreign key constraint passes, and flag it for the admin.
* **Example:** `student_id` 112 points to `batch_id` 99.

## Category 3: Logical Constraints
* **Issue:** Contest end time is before the start time.
* **Strategy:** **Ask for manual verification**. We cannot know if the start time was logged late or the end time was logged early. 
* **Example:** `contest_id` 3 shows start: '2024-05-10 10:00' and end: '2024-05-09 10:00'.

## Category 4: Duplicates
* **Issue:** Duplicate email addresses in the `students` table.
* **Strategy:** **Move to rejected/staging**. If two distinct `student_id`s share an email, one might be a fraudulent account. Move the newer one to an audit table and NULL the email in the main table to enforce the UNIQUE constraint.
* **Example:** `student_id` 210 and `student_id` 211 both use 'duplicate@email.com'.

* **Issue:** Exact duplicate rows in `enrollments`.
* **Strategy:** **Delete the record**. Keep the row with the earlier enrollment date and delete the exact duplicate to satisfy the composite UNIQUE key constraint.
* **Example:** `student_id` 45 enrolled in `course_id` 2 twice.

## Category 5: Invalid Enums
* **Issue:** Unrecognized status in `attendance`.
* **Strategy:** **Correct the value**. Statuses like 'P' or 'A' should be mapped to 'Present' or 'Absent'.
* **Example:** `attendance_id` 800 has status 'P'.
