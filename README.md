# 🏨 Hotel Booking Analytics – End-to-End Data Engineering Project

## 📌 Project Overview

This project implements an end-to-end Hotel Booking Analytics Platform using **Databricks Lakeflow Spark Declarative Pipelines** and the Medallion Architecture.

The objective is to ingest raw hotel booking data, clean and transform it, generate business-level analytical tables, and build an interactive dashboard to monitor hotel performance and data quality.

## 🛠️ Technologies Used

- Databricks
- Lakeflow Spark Declarative Pipelines
- SQL
- Medallion Architecture
- Databricks AI/BI Dashboard

## 🏗️ Project Architecture

The project follows the Medallion Architecture:

### 1. Bronze Layer
- Ingests raw hotel booking CSV data.
- Preserves source records.
- Adds source filename and ingestion timestamp.

### 2. Silver Layer
- Removes duplicate booking records.
- Standardizes text columns.
- Handles missing values.
- Calculates missing nights and booking amounts.
- Identifies invalid dates and negative room rates.
- Stores rejected records separately.

### 3. Gold Layer
Creates business-ready analytical tables:

- `gold_monthly_bookings`
- `gold_hotel_summary`
- `gold_room_type_summary`
- `gold_channel_summary`
- `gold_data_quality`

## 📊 Dashboard

Created an interactive Hotel Booking Analytics Dashboard using Databricks AI/BI.

The dashboard contains three pages:

1. **Hotel Booking Overview**
   - Total bookings
   - Net revenue
   - Room nights
   - Cancelled bookings
   - Monthly revenue trends
   - Revenue by city

2. **Hotel Performance Analysis**
   - Revenue by hotel
   - Room nights by hotel
   - Average Daily Rate (ADR)
   - Revenue by room type
   - Average guest rating
   - Cancellation rate by booking channel

3. **Data Quality Monitoring**
   - Total Bronze records
   - Total clean records
   - Total rejected records
   - Duplicate records removed
   - Data quality issue counts
   - Reconciliation status

## 📈 Data Quality Reconciliation

| Metric | Records |
|---|---:|
| Bronze Records | 1,316 |
| Clean Records | 1,269 |
| Rejected Records | 21 |
| Duplicate Records Removed | 26 |
| Reconciled Records | 1,316 |
| Reconciliation Status | PASS |

**Reconciliation Formula:**

Bronze Records = Clean Records + Rejected Records + Duplicate Records Removed

## 📁 Project Structure

```text
Hotel_Booking_Analytics_DE_Project/
│
├── data/
│   └── hotel_bookings_raw.csv
│
├── bronze_layer/
│   └── bronze_transformation.sql
│
├── silver_layer/
│   ├── silver_clean.sql
│   └── silver_rejected.sql
│
├── gold_layer/
│   ├── gold_monthly_bookings.sql
│   ├── gold_hotel_summary.sql
│   ├── gold_room_type_summary.sql
│   ├── gold_channel_summary.sql
│   └── gold_data_quality.sql
│
├── screenshots/
│   ├── pipeline_graph.png
│   ├── hotel_booking_overview.png
│   ├── hotel_performance_analysis.png
│   └── data_quality_monitoring.png
│
└── README.md
```

## 🎯 Business Objectives

- Analyze monthly hotel booking trends.
- Measure hotel and city-wise performance.
- Understand room type performance.
- Identify booking channel cancellation patterns.
- Monitor data quality and pipeline reconciliation.
- Generate reliable business insights.

## 🚀 Key Learning Outcomes

- Understanding Medallion Architecture.
- Building data pipelines using Databricks.
- Implementing SQL-based data transformations.
- Handling missing, duplicate, and invalid records.
- Creating Gold-layer analytical tables.
- Building interactive business dashboards.
- Validating data quality through reconciliation.

## 👨‍💻 Author

**Samarth Amale**

Data Analytics & Data Engineering Aspirant

- GitHub: https://github.com/samarthamle
- LinkedIn: https://www.linkedin.com/in/samarth-amale-744a7325a/