-- ## SQL Task
-- Create SQL queries to analyze the same log data stored in a relational database and identify potential data exfiltration attempts.

-- ### Solution Example:
-- -- Assume we have a table named 'cloud_upload_logs' with columns:
-- -- id, timestamp, user_id, service, bytes_uploaded
-- -- 1. Identify users with high upload volumes in a short time window
-- -- 2. Identify users uploading to multiple services within a short time frame
-- -- 3. Detect sudden increases in upload activity compared to user's normal behavior