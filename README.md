# DataAnalytics-Assessment

# Customer Data Analysis with SQL

This repository contains a set of SQL queries tailored to analyze customer financial data. These queries provide actionable insights to support marketing, finance, and operations teams in decision-making and customer segmentation.

---

## Database Tables Overview

- **users_customuser**: Customer details such as user ID, name, email, date joined, etc.
- **plans_plan**: Details of customer plans (savings and investment), including plan type flags.
- **savings_savingsaccount**: Transaction records related to savings and investment accounts.
- **withdrawal**: Transaction records for withdrawals, including amounts and dates.

---

## Queries and Explanations

### 1. High-Value Customers with Multiple Products

**Objective:**  
Identify customers who hold at least one funded savings plan **and** one funded investment plan. This highlights cross-selling opportunities for the business.

**Approach:**  
- Join users with counts of their savings and investment plans from the `plans_plan` table.  
- Sum the total confirmed deposits from the `savings_savingsaccount` table.  
- Filter to keep only customers who have at least one of each plan type.  
- Sort customers by total deposits in descending order to prioritize the highest-value customers.

**Key Points:**  
- Uses `is_regular_savings` and `is_a_fund` flags to distinguish savings vs. investment plans.  
- Amounts stored in kobo are converted to Naira by dividing by 100.  
- Customers without both plan types are excluded for targeted cross-selling.

---

### 2. Transaction Frequency Analysis

**Objective:**  
Segment customers based on how often they transact monthly into "High", "Medium", or "Low" frequency categories. This helps tailor marketing and customer engagement strategies.

**Approach:**  
- Calculate the monthly transaction count per customer by grouping transactions by user and month.  
- Compute the average transactions per month across all months for each customer.  
- Categorize customers based on their average monthly transactions:  
  - High Frequency: 10 or more  
  - Medium Frequency: 3 to 9  
  - Low Frequency: 2 or fewer  
- Aggregate results to show how many customers fall into each category and their average transaction volume.

**Key Points:**  
- Uses `DATE_FORMAT` to extract year-month for monthly grouping.  
- Categorization enables actionable segmentation for marketing or risk assessment.

---

### 3. Account Inactivity Alert

**Objective:**  
Flag active savings or investment accounts that have had no inflow transactions for over a year (365 days). Useful for operational monitoring and customer re-engagement.

**Approach:**  
- Join plans with their associated savings transactions.  
- Calculate the date of the last transaction per plan.  
- Filter plans that are active (`is_deleted = 0` and `is_archived = 0`) and have no transactions in the last 365 days or no transactions at all.  
- Return plan details, last transaction date, and number of days since last activity.

**Key Points:**  
- Helps identify dormant accounts that may require action.  
- Uses `DATEDIFF` and `MAX` transaction date aggregation.  
- Distinguishes between savings and investment accounts with plan flags.

---

### 4. Customer Lifetime Value (CLV) Estimation

**Objective:**  
Estimate the lifetime value of customers based on account tenure and transaction activity, using a simplified profit model.

**Approach:**  
- Calculate account tenure in months from the user's signup date to now.  
- Count total transactions from savings accounts.  
- Calculate average profit per transaction as 0.1% of the confirmed amount.  
- Estimate CLV by normalizing transaction count by tenure, annualizing it, and multiplying by average profit.  
- Return results ordered by highest estimated CLV.

**Key Points:**  
- Provides a proxy for customer value useful for marketing and retention efforts.  
- Uses `TIMESTAMPDIFF` for tenure calculation.  
- Handles division by zero with `NULLIF` to avoid errors for new accounts.

