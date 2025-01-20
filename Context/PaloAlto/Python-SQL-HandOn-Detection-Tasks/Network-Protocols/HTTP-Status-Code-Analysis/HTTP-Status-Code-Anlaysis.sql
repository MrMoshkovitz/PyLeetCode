-- SQL Task: Detecting Potential HTTP-based Attacks
-- -- Assuming a table named http_logs with columns: timestamp, source_ip, method, url, status_code, user_agent

-- -- Detect potential SQL injection attempts
-- SELECT source_ip, COUNT(*) as attempt_count
-- FROM http_logs
-- WHERE url LIKE '%SELECT%' OR url LIKE '%UNION%' OR url LIKE '%OR 1=1%'
-- GROUP BY source_ip
-- HAVING COUNT(*) > 5
-- ORDER BY attempt_count DESC;

-- -- Identify unusual user agents
-- SELECT user_agent, COUNT(*) as occurrence_count
-- FROM http_logs
-- GROUP BY user_agent
-- HAVING COUNT(*) < 10  -- Adjust threshold as needed
-- ORDER BY occurrence_count;

-- -- Detect potential brute force attacks on login pages
-- SELECT source_ip, COUNT(*) as login_attempts
-- FROM http_logs
-- WHERE url LIKE '%login%' AND status_code = 401
-- GROUP BY source_ip
-- HAVING COUNT(*) > 20  -- Adjust threshold as needed
-- ORDER BY login_attempts DESC;

-- -- Identify sources making an unusually high number of requests
-- SELECT source_ip, COUNT(*) as request_count
-- FROM http_logs
-- WHERE timestamp >= DATEADD(hour, -1, GETDATE())  -- Last hour
-- GROUP BY source_ip
-- HAVING COUNT(*) > 1000  -- Adjust threshold based on normal traffic patterns
-- ORDER BY request_count DESC;
