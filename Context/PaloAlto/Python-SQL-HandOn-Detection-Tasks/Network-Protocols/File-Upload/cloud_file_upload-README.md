# Detecting Suspicious File Upload Activity

## Python Task
Create a Python script to analyze log data and detect potentially suspicious file upload activity across multiple cloud services.
This script will help identify possible data exfiltration attempts.

### Solution Example:
```python3
import pandas as pd
import matplotlib.pyplot as plt
from datetime import datetime, timedelta

# Load log data (assume we have a CSV file with columns: timestamp, user_id, service, bytes_uploaded)
logs = pd.read_csv('cloud_upload_logs.csv')

# Convert timestamp to datetime
logs['timestamp'] = pd.to_datetime(logs['timestamp'])

# Set a threshold for suspicious upload size (e.g., 100 MB)
SUSPICIOUS_THRESHOLD = 100 * 1024 * 1024  # 100 MB in bytes

# Function to detect suspicious uploads
def detect_suspicious_uploads(df, threshold, time_window=timedelta(hours=1)):
    suspicious_uploads = []
    
    for user in df['user_id'].unique():
        user_logs = df[df['user_id'] == user].sort_values('timestamp')
        
        for i, row in user_logs.iterrows():
            window_start = row['timestamp']
            window_end = window_start + time_window
            
            window_uploads = user_logs[(user_logs['timestamp'] >= window_start) & 
                                       (user_logs['timestamp'] <= window_end)]
            
            total_bytes = window_uploads['bytes_uploaded'].sum()
            
            if total_bytes > threshold:
                suspicious_uploads.append({
                    'user_id': user,
                    'start_time': window_start,
                    'end_time': window_end,
                    'total_bytes': total_bytes,
                    'services': ', '.join(window_uploads['service'].unique())
                })
    
    return pd.DataFrame(suspicious_uploads)

# Detect suspicious uploads
suspicious_activities = detect_suspicious_uploads(logs, SUSPICIOUS_THRESHOLD)

# Display results
print(suspicious_activities)

# Visualize suspicious activities
plt.figure(figsize=(12, 6))
plt.scatter(suspicious_activities['start_time'], suspicious_activities['total_bytes'] / (1024 * 1024))
plt.xlabel('Time')
plt.ylabel('Total Upload Size (MB)')
plt.title('Suspicious Upload Activities')
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()
```

## SQL Task
Create SQL queries to analyze the same log data stored in a relational database and identify potential data exfiltration attempts.

### Solution Example:
```sql
-- Assume we have a table named 'cloud_upload_logs' with columns:
-- id, timestamp, user_id, service, bytes_uploaded

-- 1. Identify users with high upload volumes in a short time window
WITH user_upload_windows AS (
    SELECT 
        user_id,
        timestamp,
        SUM(bytes_uploaded) OVER (
            PARTITION BY user_id 
            ORDER BY timestamp 
            RANGE BETWEEN INTERVAL '1 HOUR' PRECEDING AND CURRENT ROW
        ) AS total_bytes_1h
    FROM cloud_upload_logs
)
SELECT DISTINCT
    user_id,
    timestamp AS suspicious_activity_time,
    total_bytes_1h / (1024 * 1024) AS total_mb_1h
FROM user_upload_windows
WHERE total_bytes_1h > 100 * 1024 * 1024  -- 100 MB threshold
ORDER BY total_mb_1h DESC;

-- 2. Identify users uploading to multiple services within a short time frame
WITH user_service_activity AS (
    SELECT 
        user_id,
        COUNT(DISTINCT service) AS service_count,
        SUM(bytes_uploaded) AS total_bytes,
        MIN(timestamp) AS start_time,
        MAX(timestamp) AS end_time
    FROM cloud_upload_logs
    GROUP BY 
        user_id,
        DATE_TRUNC('hour', timestamp)
    HAVING 
        COUNT(DISTINCT service) > 2 AND
        SUM(bytes_uploaded) > 50 * 1024 * 1024  -- 50 MB threshold
)
SELECT 
    user_id,
    service_count,
    total_bytes / (1024 * 1024) AS total_mb,
    start_time,
    end_time,
    EXTRACT(EPOCH FROM (end_time - start_time)) / 60 AS duration_minutes
FROM user_service_activity
ORDER BY total_mb DESC;

-- 3. Detect sudden increases in upload activity compared to user's normal behavior
WITH user_daily_stats AS (
    SELECT
        user_id,
        DATE(timestamp) AS activity_date,
        SUM(bytes_uploaded) AS daily_bytes
    FROM cloud_upload_logs
    GROUP BY user_id, DATE(timestamp)
),
user_averages AS (
    SELECT
        user_id,
        AVG(daily_bytes) AS avg_daily_bytes,
        STDDEV(daily_bytes) AS stddev_daily_bytes
    FROM user_daily_stats
    GROUP BY user_id
)
SELECT
    s.user_id,
    s.activity_date,
    s.daily_bytes / (1024 * 1024) AS daily_mb,
    a.avg_daily_bytes / (1024 * 1024) AS avg_daily_mb,
    (s.daily_bytes - a.avg_daily_bytes) / a.stddev_daily_bytes AS z_score
FROM user_daily_stats s
JOIN user_averages a ON s.user_id = a.user_id
WHERE (s.daily_bytes - a.avg_daily_bytes) / a.stddev_daily_bytes > 3  -- Z-score > 3
ORDER BY z_score DESC;
```


