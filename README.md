# Bank Loan Report: Analysis of Lending Performance
![Banner](https://github.com/user-attachments/assets/50d0c6be-467b-4080-a0cb-9cda37a82649)


## 📚 Table of Contents 📚

| Section | Title                                                                                          |
|---------|------------------------------------------------------------------------------------------------|
| 1       | [Introduction](#section0)                                                                      |
| 2       | [Problem Statement](#section1)                                                                 |
| 3       | [Project Goals](#section2)                                                                     |
| 4       | [Data Overview](#section3)                                                                     |
| 5       | [Approach to Problem](#section4)                                                               |
| 6       | [Tools and Technologies](#section5)                                                            |
| 7       | [SQL Queries](#section6)                                                                       |
| 8       | [Data Visualization: Tableau](#section7)                                                  |
| 9       | [Insights and Actionable Recommendations](#section8)                                                              |
| 10      | [Conclusion](#section9)                                                                         |
| 11      | [Future Work](#section10)                                                                       |

<a id=section0></a>
## 1. Introduction
The **Bank Loan Report** project aims to analyze the performance of lending activities through comprehensive metrics and visualizations. By employing SQL for data extraction and Tableau for visualization, this project enables stakeholders to make data-driven decisions to enhance lending strategies and assess portfolio health.

<a id=section1></a>
## 2. Problem Statement
To monitor and assess our bank's lending activities, we need a comprehensive report to track key loan-related metrics over time. This project aims to provide insights into total loan applications, funded amounts and repayment trends, facilitating informed lending strategies and risk assessments.

<a id=section2></a>
## 3. Project Goals
- **Track Key Performance Indicators (KPIs)**: Monitor total loan applications, funded amounts, and amounts received.
- **Evaluate Loan Quality**: Distinguish between 'Good Loans' and 'Bad Loans' to assess portfolio quality.
- **Visualize Trends**: Create dynamic visualizations to showcase trends in lending activities across various dimensions, such as purpose, state, and home ownership【10†source】.

<a id=section3></a>
## 4. Data Overview
The dataset consists of loan application records containing the following key fields:
- **Loan ID**: Unique identifier for each loan application.
- **Purpose**: Purpose of the loan (e.g., debt consolidation, credit card).
- **Loan Amount**: Amount requested by the borrower.
- **Interest Rate**: Interest rate applied to the loan.
- **Status**: Current status of the loan (e.g., Fully Paid, Charged Off).

<a id=section4></a>
## 5. Approach to Problem
- **Data Extraction**: SQL queries were utilized to calculate key metrics for the report, including total loan applications, funded amounts, and average interest rates.
- **Data Visualization**: Tableau was employed to create visual representations of the loan data, allowing for easy interpretation of trends and patterns.

<a id=section5></a>
## 6. Tools and Technologies
The project utilized the following tools and technologies:
- **SQL**: The primary language used for data manipulation, exploration, and analysis.
- **PostgreSQL**: Used for database creation, data parsing, and initial data exploration.
- **Tableau**: For creating a variety of visualizations and interactive dashboards based on SQL query findings.

<a id=section6></a>
## 7. SQL Queries

### Database
Using PostgreSQL to store data in a database,
```sql
CREATE TABLE loans (
    id SERIAL PRIMARY KEY,
    address_state VARCHAR(50),
    application_type VARCHAR(50),
    emp_length VARCHAR(50),
    emp_title VARCHAR(255),
    grade VARCHAR(50),
    home_ownership VARCHAR(50),
    issue_date TEXT,
    last_credit_pull_date TEXT,
    last_payment_date TEXT,
    loan_status VARCHAR(50),
    next_payment_date TEXT,
    member_id INTEGER,
    purpose VARCHAR(100),
    sub_grade VARCHAR(10),
    term TEXT,
    verification_status VARCHAR(50),
    annual_income FLOAT,
    dti FLOAT,
    installment FLOAT,
    int_rate FLOAT,
    loan_amount FLOAT,
    total_acc INTEGER,
    total_payment FLOAT
);
```

SQL was utilized to extract, manipulate, and analyze data efficiently. The following key SQL queries demonstrate how I leveraged SQL to derive actionable insights into the bank's lending activities:

### Total Loan Applications
```sql
SELECT COUNT(id) AS Total_Applications FROM bank_loan_data;
```
<img width="133" alt="image" src="https://github.com/user-attachments/assets/7bf8d11d-2045-4271-a24d-d47a9801a4c6">

```sql
SELECT 
    EXTRACT(YEAR FROM issue_date) AS year,
    EXTRACT(MONTH FROM issue_date) AS month,
    COUNT(id) AS total_loan_applications,
    LAG(COUNT(id)) OVER (ORDER BY EXTRACT(YEAR FROM issue_date), EXTRACT(MONTH FROM issue_date)) AS previous_month_applications,
    COUNT(id) - LAG(COUNT(id)) OVER (ORDER BY EXTRACT(YEAR FROM issue_date), EXTRACT(MONTH FROM issue_date)) AS MoM_change
FROM loans
GROUP BY year, month
ORDER BY year, month;
```
<img width="383" alt="image" src="https://github.com/user-attachments/assets/420ae04b-0818-4afc-b42c-93b240332ddc">

This query counts the total number of loan applications received, providing a foundational metric for assessing the bank's overall lending activity. Understanding the volume of applications is essential for evaluating operational capacity and forecasting future loan processing requirements.

### Total Funded Amount
```sql
SELECT SUM(loan_amount) AS Total_Funded_Amount FROM bank_loan_data;
```
<img width="130" alt="image" src="https://github.com/user-attachments/assets/a8899e55-9fbd-4688-b249-4c82729b3929">

```sql
SELECT
	EXTRACT(YEAR FROM issue_date) AS year,
	EXTRACT(MONTH FROM issue_date) AS month,
	SUM(loan_amount) AS total_loan_amount,
	LAG(SUM(loan_amount)) OVER (ORDER BY EXTRACT(YEAR FROM issue_date), EXTRACT(MONTH FROM issue_date)) AS previous_month_amount,
	SUM(loan_amount) - LAG(SUM(loan_amount)) OVER (ORDER BY EXTRACT(YEAR FROM issue_date), EXTRACT(MONTH FROM issue_date)) AS MoM_change
FROM loans
GROUP BY year, month
ORDER BY year, month;
```
<img width="389" alt="image" src="https://github.com/user-attachments/assets/760046de-e422-4cab-8b22-c0466352fd5a">

These queries calculate the total amount of funds disbursed through loans, and compare the amount funded in the current month with the previous month. This metric is critical for assessing the financial performance of the lending operations and understanding cash flow implications.

### Total Amount Received

```sql
SELECT SUM(total_payment) AS Total_Amount_Collected FROM bank_loan_data;
```
<img width="116" alt="image" src="https://github.com/user-attachments/assets/68c5b86d-5cd1-4445-a191-893b0c4ce942">

```sql
SELECT
	EXTRACT(YEAR FROM issue_date) AS year,
	EXTRACT(MONTH FROM issue_date) AS month,
	SUM(loan_amount) as total_amount_received,
	LAG(SUM(loan_amount)) OVER (ORDER BY EXTRACT(YEAR FROM issue_date), EXTRACT(MONTH FROM issue_date)) AS previous_month_amount_received,
	SUM(loan_amount) - LAG(SUM(loan_amount)) OVER (ORDER BY EXTRACT(YEAR FROM issue_date), EXTRACT(MONTH FROM issue_date)) AS MoM_change
FROM loans
GROUP BY year, month
ORDER BY year, month;
```
<img width="369" alt="image" src="https://github.com/user-attachments/assets/b227aa75-498f-40ba-b80c-61181149317a">

This set of queries sums up the total payments received from borrowers, the payments received in the current month, and the payments received in the previous month. Monitoring these figures helps in evaluating loan repayment trends and overall cash flow health.

We also did comparisons for the queries of Average Interest Rates and Average Debt-to-Income (DTI) Ratio which you can refer to here for the full document.

### Significance of SQL in Data Analysis

Utilizing SQL in this project allowed for:
- **Data Extraction**: Efficiently querying large datasets to gather relevant information quickly. The ability to retrieve data accurately is fundamental for any data analyst role.
  
- **Data Aggregation**: Summarizing key metrics to derive insights that support decision-making processes. Understanding how to aggregate and analyze data is crucial for presenting actionable findings to stakeholders.
  
- **Performance Measurement**: Establishing KPIs such as loan applications, funded amounts, and repayment totals. These indicators are vital for evaluating the effectiveness of business operations.

- **Quality Assessment**: Distinguishing between good and bad loans provides a clear picture of the lending portfolio's health, enabling proactive risk management and strategy adjustments.

By showcasing these SQL queries, I demonstrated my ability to translate business needs into data-driven insights through effective database management.

<a id=section7></a>
## 8. Data Visualization: Tableau
<img width="1190" alt="Screenshot 2024-10-09 at 11 00 07 PM" src="https://github.com/user-attachments/assets/36cd0e0b-78d9-48ae-b2dc-1c2dd81e92e6">

The Tableau dashboards created for this project includes:
1. **Summary Dashboard**: Displays overall lending metrics, including total loan applications and funded amounts.
2. **Overview Dashboard**: Visualizes lending trends over time and by region, highlighting differences in loan performance across states and purposes.
3. **Details Dashboard**: Provides a granular view of loan data, allowing users to drill down into specific loan characteristics and statuses.

Access the live dashboard on Tableau Public: [Fortress Finance Loan Report](https://public.tableau.com/shared/WZZ8Q72TK?:display_count=n&:origin=viz_share_link)

<a id=section8></a>
## 9. Insights and Actionable Recommendations
Insights gathered from the dashboard highlight various facets:
- The report indicates a total of **38.6K loan applications**, with a **month-to-date (MTD) increase of 4.0K**, representing a 6.9% month-over-month (MoM) growth. This consistent increase suggests a robust demand for loans.
- A significant portion of the loans issued are categorized as **Good Loans, accounting for 86.2%** of total loans issued. This indicates that the bank is effectively lending to creditworthy borrowers, which is a strong sign of its risk assessment processes. The total amount received from good loans is higher than the funded amounts, demonstrating **profitability** in this segment.
- Approximately **13.8% of loans are classified as Bad Loans**. The total funded amount for these loans is **$65.5M, with only $37.3M received**, indicating a concerning trend of defaults that could impact the bank’s overall financial health. Further investigation into these borrowers' credit reports and scores is recommended to mitigate future risks.
- The average interest rate stands at 12.0% across loans, with an average **debt-to-income (DTI) ratio of 13.3%**. Monitoring these metrics helps the bank ensure competitive pricing while managing risk. The stability in these averages month-over-month suggests consistent lending practices.
- The total **funded amount is $435.8M**, with monthly funding showing slight growth. The trend in funding amounts can guide the bank's capital allocation and investment strategies, ensuring that sufficient funds are available for prospective loans.
- The analysis reveals that a significant portion of loans is for **debt consolidation (over $253.8M)**, which indicates a **strong demand** in this category. This insight can inform the bank's marketing efforts and product offerings tailored to help customers manage debt more effectively.

<a id=section9></a>
## 10. Conclusion
The Bank Loan Report provides valuable insights into the bank's lending activities, highlighting key performance indicators (KPIs) such as total loan applications, funded amounts, and amounts received. The analysis indicates that the amount received from good loans exceeds the funded amounts, demonstrating the bank's profitability in this area. Conversely, the data reveals losses from bad loans, suggesting the need for further investigations into borrower creditworthiness through credit reports and scores.

The project also identified significant seasonal trends and long-term patterns in lending activities, as well as regional disparities in loan performance. Analyzing loan terms and borrower employment lengths has helped understand the distribution of loans and the impact of employment history on applications. Furthermore, insights into loan purposes and home ownership reveal essential factors influencing borrowing behavior.

Overall, this comprehensive analysis equips the bank with the necessary data to optimize lending strategies, enhance risk management, and tailor products to meet customer needs, ultimately driving improved business performance in a competitive market.

<a id=section10></a>
## 11. Future Work
Future iterations of this project could include:
- Implementing machine learning (predictive modelling) models to predict loan defaults based on borrower characteristics.
- Integration with other data sources of loan data with economic indicators to analyze external factors influencing lending performance.
