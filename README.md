# CodeJudge Database System - Part 3

This repository contains Part 3 of the SQL & DBMS Assignment: Data Integrity Audit, Debugging & Repair Plan.

### Included Files:
* `import_validation.sql`: Queries to verify row counts, NULLs, and basic import sanity.
* `integrity_audit.sql`: Queries identifying duplicate keys and orphaned foreign key relationships.
* `domain_rule_checks.sql`: Queries validating business rules, timestamps, and domain constraints.
* `repair_plan.md`: A structured plan detailing how to handle specific data anomalies found during the audit.
* `staging_repair_scripts.sql`: Safe SQL scripts performing corrections on staging copies of the tables.
* `before_after_evidence.md`: Documentation of the database state before and after the repair scripts were executed.
