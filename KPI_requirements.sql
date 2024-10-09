select * from loans;

/* Data Cleaning */
UPDATE loans
SET 
    issue_date = TO_DATE(issue_date, 'DD-MM-YYYY'),
    last_credit_pull_date = TO_DATE(last_credit_pull_date, 'DD-MM-YYYY'),
    last_payment_date = TO_DATE(last_payment_date, 'DD-MM-YYYY'),
    next_payment_date = TO_DATE(next_payment_date, 'DD-MM-YYYY');

ALTER TABLE loans
ALTER COLUMN issue_date TYPE DATE USING issue_date::DATE,
ALTER COLUMN last_credit_pull_date TYPE DATE USING last_credit_pull_date::DATE,
ALTER COLUMN last_payment_date TYPE DATE USING last_payment_date::DATE,
ALTER COLUMN next_payment_date TYPE DATE USING next_payment_date::DATE;

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'loans';

/* First Problem Statement - KPI Requirements */

/* 1. Total Loan Applications 
We need to caluclate the total number of loan applications received during a specified period.
Additionally, we need to monitor the Month-to-Date (MTD) Loan Applications, and track changes
Month-to-Month (MoM). */

SELECT COUNT(id) AS total_loan_applications
FROM loans;

SELECT COUNT(id) AS MTD_total_loan_applications
FROM loans
WHERE EXTRACT(MONTH FROM issue_date) = 12
	AND EXTRACT(YEAR FROM issue_date) = 2021;

SELECT COUNT(id) AS PMTD_total_loan_applications
FROM loans
WHERE EXTRACT(MONTH FROM issue_date) = 11
	AND EXTRACT(YEAR FROM issue_date) = 2021;

SELECT 
    EXTRACT(YEAR FROM issue_date) AS year,
    EXTRACT(MONTH FROM issue_date) AS month,
    COUNT(id) AS total_loan_applications,
    LAG(COUNT(id)) OVER (ORDER BY EXTRACT(YEAR FROM issue_date), EXTRACT(MONTH FROM issue_date)) AS previous_month_applications,
    COUNT(id) - LAG(COUNT(id)) OVER (ORDER BY EXTRACT(YEAR FROM issue_date), EXTRACT(MONTH FROM issue_date)) AS MoM_change
FROM loans
GROUP BY year, month
ORDER BY year, month;

/* 2. Total Funded Amount
It is crucial to understand how much funds are disbursed as loans. We want to keep an eye on the
MTD Total Funded Amount, and analyse the MoM changes in this metric. */

SELECT SUM(loan_amount) AS MTD_total_funded_amount
FROM loans
WHERE EXTRACT(MONTH FROM issue_date) = 12
	AND EXTRACT(YEAR FROM issue_date) = 2021;

SELECT SUM(loan_amount) AS PMTD_total_funded_amount
FROM loans
WHERE EXTRACT(MONTH FROM issue_date) = 11
	AND EXTRACT(YEAR FROM issue_date) = 2021;

SELECT
	EXTRACT(YEAR FROM issue_date) AS year,
	EXTRACT(MONTH FROM issue_date) AS month,
	SUM(loan_amount) AS total_loan_amount,
	LAG(SUM(loan_amount)) OVER (ORDER BY EXTRACT(YEAR FROM issue_date), EXTRACT(MONTH FROM issue_date)) AS previous_month_amount,
	SUM(loan_amount) - LAG(SUM(loan_amount)) OVER (ORDER BY EXTRACT(YEAR FROM issue_date), EXTRACT(MONTH FROM issue_date)) AS MoM_change
FROM loans
GROUP BY year, month
ORDER BY year, month;

/* 3. Total Amount Received
It is crucial to track total amount received from borrowers to assess the bank's cash flow and loan repayment. We want to keep an eye on the
MTD Total Amount Received, and analyse the MoM changes. */

SELECT SUM(total_payment) as total_amount_received
FROM loans;

SELECT SUM(total_payment) AS MTD_total_amount_received
FROM loans
WHERE EXTRACT(MONTH FROM issue_date) = 12
	AND EXTRACT(YEAR FROM issue_date) = 2021;

SELECT
	EXTRACT(YEAR FROM issue_date) AS year,
	EXTRACT(MONTH FROM issue_date) AS month,
	SUM(loan_amount) as total_amount_received,
	LAG(SUM(loan_amount)) OVER (ORDER BY EXTRACT(YEAR FROM issue_date), EXTRACT(MONTH FROM issue_date)) AS previous_month_amount_received,
	SUM(loan_amount) - LAG(SUM(loan_amount)) OVER (ORDER BY EXTRACT(YEAR FROM issue_date), EXTRACT(MONTH FROM issue_date)) AS MoM_change
FROM loans
GROUP BY year, month
ORDER BY year, month;

/* 4. Average Interest Rate
Calculating the average interest rate across all loans, MTD and monitoring the MpM variations in interest rates will provide insights into
our lending portfolio's overall cost. */

SELECT ROUND(AVG(int_rate)::numeric, 4) * 100 AS avg_int_rate
FROM loans;

SELECT ROUND(AVG(int_rate)::numeric, 4) * 100 AS MTD_avg_int_rate
FROM loans
WHERE EXTRACT(MONTH FROM issue_date) = 12
	AND EXTRACT(YEAR FROM issue_date) = 2021;

SELECT
	EXTRACT(YEAR FROM issue_date) AS year,
	EXTRACT(MONTH FROM issue_date) AS month,
	ROUND(AVG(int_rate)::numeric, 4) * 100 AS avg_int_rate,
	LAG(ROUND(AVG(int_rate)::numeric, 4) * 100) OVER (ORDER BY EXTRACT(YEAR FROM issue_date), EXTRACT(MONTH FROM issue_date)) AS previous_month_int_rate,
	ROUND(AVG(int_rate)::numeric, 4) * 100 - LAG(ROUND(AVG(int_rate)::numeric, 4) * 100) OVER (ORDER BY EXTRACT(YEAR FROM issue_date), EXTRACT(MONTH FROM issue_date)) AS MoM_change
FROM loans
GROUP BY year, month
ORDER BY year, month;

/* 5. Average Debt-to-Income (DTI) Ratio
Evaluating the average DTI for our borrowers helps us to gauge their financial health. We need to compute the average DTI for all loans and
track MoM fluctuations. */

SELECT ROUND(AVG(dti)::numeric, 4) * 100 AS avg_dti
FROM loans;

SELECT ROUND(AVG(dti)::numeric, 4) * 100 AS MTD_avg_dti
FROM loans
WHERE EXTRACT(MONTH FROM issue_date) = 12
	AND EXTRACT(YEAR FROM issue_date) = 2021;

SELECT
	EXTRACT(YEAR FROM issue_date) AS year,
	EXTRACT(MONTH FROM issue_date) AS month,
	ROUND(AVG(dti)::numeric, 4) * 100 AS avg_dti,
	LAG(ROUND(AVG(dti)::numeric, 4) * 100) OVER (ORDER BY EXTRACT(YEAR FROM issue_date), EXTRACT(MONTH FROM issue_date)) AS previous_month_dti,
	ROUND(AVG(dti)::numeric, 4) * 100 - LAG(ROUND(AVG(dti)::numeric, 4) * 100) OVER (ORDER BY EXTRACT(YEAR FROM issue_date), EXTRACT(MONTH FROM issue_date)) AS MoM_change
FROM loans
GROUP BY year, month
ORDER BY year, month;



