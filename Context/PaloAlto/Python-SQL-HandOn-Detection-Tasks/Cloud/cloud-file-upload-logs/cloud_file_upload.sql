-- ## SQL Task
-- Create SQL queries to analyze the same log data stored in a relational database and identify potential data exfiltration attempts.

-- ### Solution Example:
-- -- Assume we have a table named 'cloud_upload_logs' with columns:
-- -- id, timestamp, user_id, service, bytes_uploaded
-- -- 1. Identify users with high upload volumes in a short time window
-- -- 2. Identify users uploading to multiple services within a short time frame
-- -- 3. Detect sudden increases in upload activity compared to user's normal behavior

-- Task Description: Write SQL queries to analyze cloud storage access logs and detect potential data exfiltration attempts. The script should identify unusual patterns of data access or transfer, such as large volumes of data being accessed from unfamiliar IP addresses or during atypical hours.
