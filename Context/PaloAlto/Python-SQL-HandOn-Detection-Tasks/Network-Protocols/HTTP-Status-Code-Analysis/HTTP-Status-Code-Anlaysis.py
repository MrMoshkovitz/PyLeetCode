# Analyzing HTTP Status Codes for Potential Security Issues
"""
import pandas as pd
import matplotlib.pyplot as plt

# Assume we have a CSV file with columns: timestamp, source_ip, method, url, status_code
logs = pd.read_csv('http_logs.csv')

# Group by status code and count occurrences
status_counts = logs['status_code'].value_counts()

# Calculate percentage of 4xx and 5xx errors
error_percentage = (status_counts[status_counts.index >= 400].sum() / len(logs)) * 100

# Plot status code distribution
plt.figure(figsize=(12, 6))
status_counts.plot(kind='bar')
plt.title(f'HTTP Status Code Distribution (Error Rate: {error_percentage:.2f}%)')
plt.xlabel('Status Code')
plt.ylabel('Count')
plt.tight_layout()
plt.show()

# Identify potential security issues
potential_issues = logs[
    (logs['status_code'] == 403) |  # Forbidden
    (logs['status_code'] == 401) |  # Unauthorized
    (logs['method'] == 'OPTIONS') |  # Potential recon
    (logs['url'].str.contains('admin|login|password', case=False))  # Sensitive endpoints
]

print("Potential security issues detected:")
print(potential_issues.groupby(['source_ip', 'method', 'url']).size().reset_index(name='count').sort_values('count', ascending=False).head(10))
"""