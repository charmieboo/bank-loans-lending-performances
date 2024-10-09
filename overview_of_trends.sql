/* DASHBOARD 2: Overview */

/* 1. Monthly Trends by Issue Date */
SELECT
	EXTRACT(MONTH FROM issue_date),
	to_char(issue_date, 'Month') AS month,
	COUNT(id) AS total_loan_applications,
	SUM(loan_amount) AS total_funded_amt,
	SUM(total_payment) AS total_received_amt
FROM loans
GROUP BY EXTRACT(MONTH FROM issue_date), month
ORDER BY EXTRACT(MONTH FROM issue_date), month;

/* 2. Regional Analysis by State */
SELECT
	address_state AS state,
	COUNT(id) AS total_loan_applications,
	SUM(loan_amount) AS total_funded_amt,
	SUM(total_payment) AS total_received_amt
FROM loans
GROUP BY address_state
ORDER BY SUM(loan_amount) DESC;

/* 3. Loan Term Analysis */
SELECT
	term,
	COUNT(id) AS total_loan_applications,
	SUM(loan_amount) AS total_funded_amt,
	SUM(total_payment) AS total_received_amt
FROM loans
GROUP BY term
ORDER BY term;

/* 4. Employee Length Analysis */
SELECT
	emp_length,
	COUNT(id) AS total_loan_applications,
	SUM(loan_amount) AS total_funded_amt,
	SUM(total_payment) AS total_received_amt
FROM loans
GROUP BY emp_length
ORDER BY total_loan_applications;

/* 5. Loan Purpose Breakdown */
SELECT
	purpose,
	COUNT(id) AS total_loan_applications,
	SUM(loan_amount) AS total_funded_amt,
	SUM(total_payment) AS total_received_amt
FROM loans
GROUP BY purpose
ORDER BY total_loan_applications DESC;

/* 6. Home Ownership Analysis */
SELECT
	home_ownership,
	COUNT(id) AS total_loan_applications,
	SUM(loan_amount) AS total_funded_amt,
	SUM(total_payment) AS total_received_amt
FROM loans
GROUP BY home_ownership
ORDER BY total_loan_applications DESC;