# E-Commerce Customer & Order Analytics

## Project Overview

This project analyzes e-commerce customer and order data to understand purchasing behavior, order trends, payment performance, delivery experience, and customer satisfaction.

The project follows an end-to-end Data Analytics workflow using **Python, PostgreSQL, and Power BI**.

## Business Problem

An e-commerce business wants to understand:

* How orders and revenue change over time
* Customer purchasing and repeat-order behavior
* Which payment methods contribute the most revenue
* How efficiently orders are delivered
* Whether late deliveries are associated with lower customer satisfaction
* Overall customer review performance

## Business Objectives

1. Analyze overall orders, customers, revenue, and average order value.
2. Identify monthly order and revenue trends.
3. Understand one-time versus repeat customer behavior.
4. Analyze revenue by payment method.
5. Evaluate delivery performance and on-time delivery.
6. Analyze customer review scores and negative review rates.
7. Examine the relationship between delivery performance and customer satisfaction.
8. Perform customer segmentation using RFM analysis.

## Dataset

The project uses an e-commerce transactional dataset containing six finalized analytical tables:

| Table | Rows |
|---|---:|
| Orders | 99,441 |
| Customers | 99,441 |
| Products | 32,951 |
| Payments | 103,886 |
| Reviews | 99,224 |
| Sellers | 3,095 |

### Main Data Domains

The dataset contains information related to:

* Orders and order status
* Customers and customer locations
* Product catalog information
* Payment methods and installments
* Customer reviews and ratings
* Seller locations

## Tools & Technologies

| Tool | Purpose |
| --- | --- |
| Python | Data Cleaning & Exploratory Data Analysis |
| Pandas | Data manipulation and validation |
| PostgreSQL | SQL analysis and business queries |
| Power BI | Data modeling, DAX and dashboard development |
| GitHub | Project documentation and portfolio |

## Project Workflow

Raw E‑Commerce Dataset  
↓  
Python Data Cleaning  
↓  
Exploratory Data Analysis  
↓  
Final Cleaned Data  
↓  
PostgreSQL  
↓  
SQL Business Analysis  
↓  
Power BI Data Modeling  
↓  
DAX Measures  
↓  
Interactive Dashboard  
↓  
Business Insights & Recommendations

## Python Analysis

Python was used for:

- Data inspection  
- Data type validation  
- Missing-value analysis  
- Duplicate checks  
- Data cleaning  
- Date handling  
- Data quality validation  
- Exploratory Data Analysis  
- Customer and order exploration  
- Payment analysis  
- Delivery analysis  
- Review analysis

Notebook:

python/E-Commerce_Customer_Order_Python_Analytics.ipynb

## PostgreSQL Analysis

PostgreSQL was used to perform eight core business analyses:

- Data Validation  
- Overall E-Commerce KPIs  
- Order & Monthly Trend Analysis  
- Customer Analytics  
- Payment Analytics  
- Delivery Analytics  
- Review & Customer Satisfaction Analysis  
- RFM Customer Analysis  

---

### SQL concepts used include:
- JOIN  
- GROUP BY  
- CASE  
- Aggregate functions  
- CTEs  
- Window functions  
- LAG()  
- NTILE()  
- Date and time analysis  
- Customer segmentation  

SQL file:

sql/E-Commerce_Customer_Order_SQL_Analytics.sql

## Power BI Dashboard

The Power BI report contains three pages:

### 1. Executive Overview
Provides a high-level view of:
- Total Revenue  
- Total Orders  
- Total Customers  
- Average Order Value  
- Monthly Revenue Trend  
- Order Status Distribution  
- Revenue by Payment Method  

### 2. Customer & Order Analytics
Focuses on:
- Total Customers  
- Repeat Customer Rate  
- Total Orders  
- Average Order Value  
- Monthly Order Trend  
- Customer Type Distribution  
- Top 5 Customers by Revenue  

### 3. Delivery & Customer Experience
Focuses on:
- Average Delivery Days  
- On-Time Delivery %  
- Average Review Score  
- Negative Review Rate  
- Monthly Delivery Time Trend  
- On-Time vs Late Delivery  
- Average Review Score by Delivery Status  
- Review Score Distribution

Power BI file:

powerbi/E-Commerce_Customer_Order_Analytics.pbix

## Key KPIs

| KPI                   | Overall Result |
| --------------------- | -------------: |
| Total Orders          |         99,441 |
| Total Customers       |         96,096 |
| Total Revenue         |  16,008,872.12 |
| Average Order Value   |         160.99 |
| Repeat Customer Rate  |          3.12% |
| Average Delivery Days |          12.50 |
| On-Time Delivery      |         91.89% |
| Average Review Score  |           4.09 |
| Negative Review Rate  |         14.63% |

# Key Business Insights

## Order & Revenue Performance
The analysis covers 99,441 orders and 96,096 unique customers.
Total revenue was approximately 16.01M.
Average order value was 160.99.
November 2017 recorded the highest order volume.
December 2016 recorded the lowest order volume.

## Customer Behavior
96.88% of customers were one-time customers.
3.12% were repeat customers.
The low repeat-customer rate indicates an opportunity to improve customer retention and repeat purchases.
The analysis also identified the top 5 customers by revenue.

## Payment Performance
Credit card generated the highest revenue among payment methods.

## Delivery Performance
91.89% of delivered orders were completed on time.
Average delivery time was approximately 12.50 days.
Late delivery performance represents an area for operational improvement.

## Customer Satisfaction
The overall average review score was 4.09.
14.63% of reviews were negative reviews.
Orders delivered on time had an average review score of 4.30, compared with 2.57 for late deliveries.
This indicates a strong relationship between delivery experience and customer satisfaction.

## Business Recommendations
Improve customer retention strategies to increase the repeat-customer rate.
Investigate the causes of late deliveries and focus on reducing delivery delays.
Monitor delivery performance because lower delivery performance is associated with lower customer review scores.
Maintain a strong payment experience for major payment methods, particularly credit cards.
Identify high-value customers and develop targeted retention or loyalty strategies.
Monitor monthly order trends to understand seasonal demand and support operational planning.


## Dashboard Preview

### 1. Executive Overview
...

### 2. Customer & Order Analytics
...

### 3. Delivery & Customer Experience
...

# Data Preparation Note
The original source dataset contained multiple source files that were used during the Python preparation and exploratory analysis stage.  
The final PostgreSQL analytical layer for this project consists of six cleaned tables used for SQL analysis and Power BI reporting.

