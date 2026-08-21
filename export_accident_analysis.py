import pandas as pd
import mysql.connector

# -----------------------------
# 1. Connect to MySQL
# -----------------------------
conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="root123",
    database="us_accidents"
)

print("Connected to MySQL!")

# -----------------------------
# 2. Analysis queries
# -----------------------------

queries = {

    "KPI": """
        SELECT
            COUNT(ID) AS total_accidents,
            ROUND(AVG(accident_duration_minutes), 2) AS avg_duration_minutes
        FROM accidents_clean;
    """,

    "Severity": """
        SELECT
            Severity,
            COUNT(ID) AS total_accidents,
            ROUND(
                COUNT(ID) * 100.0 /
                (SELECT COUNT(*) FROM accidents_clean),
                2
            ) AS percentage_contribution
        FROM accidents_clean
        GROUP BY Severity
        ORDER BY Severity DESC;
    """,

    "Hourly": """
        SELECT
            accident_hour,
            COUNT(ID) AS accident_count
        FROM accidents_clean
        GROUP BY accident_hour
        ORDER BY accident_hour;
    """,

    "Day_Night": """
        SELECT
            Sunrise_Sunset,
            COUNT(ID) AS accident_count
        FROM accidents_clean
        WHERE Sunrise_Sunset IS NOT NULL
        GROUP BY Sunrise_Sunset
        ORDER BY accident_count DESC;
    """,

    "Cities": """
        SELECT
            City,
            COUNT(ID) AS accident_count
        FROM accidents_clean
        WHERE City IS NOT NULL
        GROUP BY City
        ORDER BY accident_count DESC
        LIMIT 10;
    """,

    "States": """
        SELECT
            State,
            COUNT(ID) AS accident_count
        FROM accidents_clean
        WHERE State IS NOT NULL
        GROUP BY State
        ORDER BY accident_count DESC
        LIMIT 10;
    """,

    "Weather": """
        SELECT
            Weather_Condition,
            COUNT(ID) AS accident_count
        FROM accidents_clean
        WHERE Weather_Condition IS NOT NULL
        GROUP BY Weather_Condition
        ORDER BY accident_count DESC
        LIMIT 10;
    """,

    "Duration": """
        SELECT
            Severity,
            ROUND(AVG(accident_duration_minutes), 2)
                AS avg_duration_minutes
        FROM accidents_clean
        GROUP BY Severity
        ORDER BY Severity;
    """,

    "Day_Of_Week": """
        SELECT
            DAYNAME(Start_Time) AS day_of_week,
            COUNT(ID) AS accident_count
        FROM accidents_clean
        GROUP BY DAYNAME(Start_Time)
        ORDER BY accident_count DESC;
    """,

    "Monthly": """
        SELECT
            accident_month,
            COUNT(ID) AS accident_count
        FROM accidents_clean
        GROUP BY accident_month
        ORDER BY accident_month;
    """,

    "Yearly": """
        SELECT
            accident_year,
            COUNT(ID) AS accident_count
        FROM accidents_clean
        GROUP BY accident_year
        ORDER BY accident_year;
    """,

    "State_Severity": """
        SELECT
            State,
            COUNT(ID) AS total_accidents,
            SUM(Severity >= 3) AS severe_accidents,
            ROUND(
                SUM(Severity >= 3) * 100.0 / COUNT(ID),
                2
            ) AS severe_ratio,
            ROUND(
                AVG(accident_duration_minutes),
                2
            ) AS avg_duration
        FROM accidents_clean
        WHERE State IS NOT NULL
        GROUP BY State
        ORDER BY severe_ratio DESC
        LIMIT 10;
    """,

    "Severity_Hour": """
        SELECT
            accident_hour,
            Severity,
            COUNT(ID) AS accident_count
        FROM accidents_clean
        GROUP BY accident_hour, Severity
        ORDER BY accident_hour, Severity;
    """,

    "Visibility": """
        SELECT
            Visibility,
            COUNT(ID) AS accident_count
        FROM accidents_clean
        WHERE Visibility IS NOT NULL
        GROUP BY Visibility
        ORDER BY accident_count DESC;
    """
}

# -----------------------------
# 3. Create Excel workbook
# -----------------------------

output_file = "US_Accident_Analysis.xlsx"

with pd.ExcelWriter(output_file, engine="openpyxl") as writer:

    for sheet_name, query in queries.items():

        print(f"Running: {sheet_name}")

        df = pd.read_sql(query, conn)

        df.to_excel(
            writer,
            sheet_name=sheet_name,
            index=False
        )

        print(f"   {len(df)} rows exported")

# -----------------------------
# 4. Close connection
# -----------------------------

conn.close()

print("\nDONE!")
print(f"Created: {output_file}")