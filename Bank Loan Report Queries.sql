  				BANK LOAN REPORT QUERY 
-- KPIs
-------------------------------------------------------------------------------------------------------------
-- 1. Total loan applications 
SELECT COUNT(id) AS Total_Applications 
FROM bank_loan

-- 2. Month To Date applications 
SELECT COUNT(id) AS MTD_Total_Loan_Applications
FROM bank_loan 
WHERE EXTRACT(MONTH FROM issue_date) = 12 AND EXTRACT(YEAR FROM issue_date) = 2021  -- 4,314

-- 3. Previous MTD(November)(PMTD) Loan Applications
SELECT COUNT(id) AS PMTD_Total_Loan_Applications
FROM bank_loan 
WHERE EXTRACT(MONTH FROM issue_date) = 11  -- 4,035

-- 4. Month to Month Total Applications
WITH MTD_app AS (
		SELECT COUNT(id) AS MTD_Total_Loan_Applications
		FROM bank_loan 
		WHERE EXTRACT(MONTH FROM issue_date) = 12 AND EXTRACT(YEAR FROM issue_date) = 2021),
PMTD_app  AS (
		SELECT COUNT(id) AS PMTD_Total_Loan_Applications
		FROM bank_loan 
		WHERE EXTRACT(MONTH FROM issue_date) = 11 AND EXTRACT(YEAR FROM issue_date)=2021	
)
	SELECT ((MTD.MTD_Total_Loan_Applications - PMTD.PMTD_Total_Loan_Applications)*100/PMTD.PMTD_Total_Loan_Applications) AS MOM_loan_applications
	FROM MTD_app MTD , PMTD_app PMTD -- 6.91%

-------------------------------------------------------------------------------------------------------------
-- 4. Total Funded Amount
SELECT ROUND(SUM(loan_amount),0) Total_Funded_Amount
FROM bank_loan

-- 5. MTD Funded Amount
SELECT ROUND(SUM(loan_amount),0) AS MTD_Total_Funded_Amount
FROM bank_loan 
WHERE EXTRACT(MONTH FROM issue_date) = 12 AND EXTRACT(YEAR FROM issue_date) = 2021

-- 6. PMTD Funded Amount
SELECT ROUND(SUM(loan_amount),0) AS PMTD_Total_Funded_Amount
FROM bank_loan 
WHERE EXTRACT(MONTH FROM issue_date) = 11

-- 7. MOM of loan funded 
WITH MTD_funded AS (
	SELECT ROUND(SUM(loan_amount),0) AS MTD_Total_Funded_Amount
    FROM bank_loan 
    WHERE EXTRACT(MONTH FROM issue_date) = 12 AND EXTRACT(YEAR FROM issue_date) = 2021
),
PMTD_funded AS (
	SELECT ROUND(SUM(loan_amount),0) AS PMTD_Total_Funded_Amount
    FROM bank_loan 
	WHERE EXTRACT(MONTH FROM issue_date) = 11 AND EXTRACT(YEAR FROM issue_date) = 2021
)
SELECT ((mtd_f.MTD_funded - pmtd_f.PMTD_funded)*100/pmtd_f.PMTD_funded) AS mom_loans_funded
FROM MTD_funded mtd_f, PMTD_funded pmtd_f

-------------------------------------------------------------------------------------------------------------
-- 8. Total Amount Received
SELECT ROUND(SUM(total_payment),0) AS Total_Amount_Received
FROM bank_loan

-- 9. Total Amount Received MTD 
SELECT ROUND(SUM(total_payment),0) AS MTD_Total_Amount_Received
FROM bank_loan
WHERE EXTRACT(MONTH FROM issue_date) = 12 AND EXTRACT(YEAR FROM issue_date) = 2021

-- 10. Total Amount Received PMTD
SELECT ROUND(SUM(total_payment),0) AS PMTD_Total_Amount_Received
FROM bank_loan 
WHERE EXTRACT(MONTH FROM issue_date) = 11

-- 11. MOM of Total Amount Received
WITH MTD_loans_paid_back AS (
	SELECT ROUND(SUM(total_payment),0) AS MTD_Total_Amount_Received
	FROM bank_loan
	WHERE EXTRACT(MONTH FROM issue_date) = 12 AND EXTRACT(YEAR FROM issue_date) = 2021
),
PMTD_loans_paid_back AS (
	SELECT ROUND(SUM(total_payment),0) AS PMTD_Total_Amount_Received
	FROM bank_loan 
	WHERE EXTRACT(MONTH FROM issue_date) = 11 AND EXTRACT(YEAR FROM issue_date)=2021
)
SELECT((MTD_r.MTD_Total_Amount_Received - PMTD_r.PMTD_Total_Amount_Received)*100/PMTD_r.PMTD_Total_Amount_Received) AS month_to_month_loans_received
FROM MTD_loans_paid_back MTD_r, PMTD_loans_paid_back PMTD_r

-------------------------------------------------------------------------------------------------------------
-- 12. Average Interest Rates
SELECT AVG(int_rate) AS Avg_Interest_Rate
FROM bank_loan

-- 13. MTD Average Interest Rate
SELECT AVG(int_rate) AS MTD_Avg_Interest_Rate
FROM bank_loan 
WHERE EXTRACT(MONTH FROM issue_date) = 12 AND EXTRACT(YEAR FROM issue_date) = 2021

-- 14. PMTD Average Interest Rate
SELECT AVG(int_rate) AS PMTD_Avg_Interest_Rate
FROM bank_loan 
WHERE EXTRACT(MONTH FROM issue_date) = 11

-- 15. MOM Interest rate
WITH MTD_avg_int AS (
	SELECT AVG(int_rate) AS MTD_Avg_Interest_Rate
    FROM bank_loan 
    WHERE EXTRACT(MONTH FROM issue_date) = 12 AND EXTRACT(YEAR FROM issue_date) = 2021
),
PMTD_avg_int AS (
	SELECT AVG(int_rate) AS PMTD_Avg_Interest_Rate
	FROM bank_loan 
	WHERE EXTRACT(MONTH FROM issue_date) = 11 AND EXTRACT(YEAR FROM issue_date)=2021
)
SELECT((MTD_int.MTD_Avg_Interest_Rate - PMTD_int.PMTD_Avg_Interest_Rate)*100/PMTD_int.PMTD_Avg_Interest_Rate) AS month_to_month_avg_int
FROM MTD_avg_int MTD_int, PMTD_avg_int PMTD_int

-------------------------------------------------------------------------------------------------------------
-- 16. Average Debt to Income Ratio (DTI)
SELECT ROUND((AVG(dti)*100),6) AS Avg_DTI
FROM bank_loan

-- 17. MTD Average Debt to Income Ratio (DTI)
SELECT ROUND((AVG(dti)*100),6) AS Avg_DTI 
FROM bank_loan 
WHERE EXTRACT(MONTH FROM issue_date) = 12 AND EXTRACT(YEAR FROM issue_date) = 2021

-- 18. PMTD Average Debt to Income Ratio (DTI)
SELECT ROUND((AVG(dti)*100),6) AS PMTD_Avg_Interest_Rate
FROM bank_loan 
WHERE EXTRACT(MONTH FROM issue_date) = 11

-- 19. MOM average Debt to Income Ratio (DTI) 
WITH MTD_avg_dti AS (
	SELECT ROUND((AVG(dti)*100),6) AS MTD_Avg_DTI 
	FROM bank_loan 
	WHERE EXTRACT(MONTH FROM issue_date) = 12 AND EXTRACT(YEAR FROM issue_date) = 2021
),
PMTD_avg_dti AS (
	SELECT ROUND((AVG(dti)*100),6) AS PMTD_Avg_DTI
	FROM bank_loan 
	WHERE EXTRACT(MONTH FROM issue_date) = 11 AND EXTRACT(YEAR FROM issue_date)=2021
)
SELECT((MTD_dti.MTD_Avg_DTI - PMTD_dti .PMTD_Avg_DTI)*100/PMTD_dti.PMTD_Avg_DTI) AS month_to_month_avg_dti
FROM MTD_avg_dti MTD_dti, PMTD_avg_dti PMTD_dti

-------------------------------------------------------------------------------------------------------------
				GOOD LOAN ISSUED
----------------------------------------------

-- 1. Good Loans Issued
SELECT loan_status , COUNT(*) 
FROM bank_loan 
GROUP BY loan_status

-- All loans with a status of current and fully paid are good loans
-- 2. Good Loan Percentage
SELECT 
	(COUNT (
			CASE WHEN loan_status = 'Fully Paid' OR 
					  loan_status = 'Current' THEN id
			END
	) * 100
	) / COUNT(id) AS good_loan_percentage
FROM bank_loan

-- 3. Good Loan Applications
SELECT COUNT(id) AS Good_loan_applications
FROM bank_loan
WHERE loan_status = 'Fully Paid' OR 
	  loan_status = 'Current' -- 33243

-- 4. Good Loan Funded Amount
SELECT ROUND(SUM(loan_amount),0) AS Good_loan_funded_amt
FROM bank_loan
WHERE loan_status = 'Fully Paid' OR 
	  loan_status = 'Current' --$370,224,850

-- 5. Good Loan Amount Received
SELECT ROUND(SUM(total_payment),0) AS Good_loan_amount_received
FROM bank_loan
WHERE loan_status = 'Fully Paid' OR 
	  loan_status = 'Current' -- $435,786,170

-------------------------------------------------------------------------------------------------------------
				BAD LOANS ISSUED
--------------------------------------------
-- 1. Bad Loan Applications
SELECT COUNT(id) Bad_loan_Apllications 
FROM bank_loan
WHERE loan_status = 'Charged Off' 	-- 5333

-- 2. Bad Loan Percentage
SELECT
	  (COUNT (CASE WHEN loan_status = 'Charged Off'
	  					THEN id 
			  END

	  )* 100
	  ) / COUNT(id) AS Bad_loans_percentage
FROM bank_loan

-- 3. Bad Loan Funded Amount
SELECT SUM(loan_amount) AS Bad_Loan_Funded_Amount
FROM bank_loan
WHERE loan_status = 'Charged Off'

-- 4. Bad Loan Amount Received 
SELECT SUM(total_payment) AS Bad_Loan_Funded_Amount
FROM bank_loan
WHERE loan_status = 'Charged Off'

-------------------------------------------------------------------------------------------------------------
				LOAN STATUS
---------------------------------------------

SELECT 
		loan_status,
		COUNT(id) AS Loan_Count,
		SUM(total_payment) AS Total_Amount_Received,
		SUM(loan_amount) AS Total_Funded_Amount,
		AVG(int_rate * 100) AS Interest_Rate,
		AVG(dti * 100) AS DTI
FROM bank_loan
GROUP BY 1

-- MTD Loan Status
SELECT loan_status,
	   SUM(total_payment) AS MTD_Total_Amount_Received,
	   SUM(loan_amount) AS MTD_Total_Funded_Amount
FROM bank_loan
WHERE EXTRACT(MONTH FROM issue_date) = 12
GROUP BY loan_status

-------------------------------------------------------------------------------------------------------------
				BANK LOAN OVERVIEW
-------------------------------------------------
	-- 1. MONTHLY ANALYSIS
	
SELECT EXTRACT(MONTH FROM issue_date) AS Month_Number,
	   TO_CHAR(issue_date, 'Month') AS Month_Name,
	   COUNT(id) AS Total_Loan_Applications,
	   SUM(loan_amount) AS Total_Funded_Amount,
	   SUM(total_payment) AS Total_Amount_Received,
	   (SUM(total_payment) - SUM(loan_amount)) AS Interest_earned_per_month
FROM bank_loan
GROUP BY EXTRACT(MONTH FROM issue_date), TO_CHAR(issue_date, 'Month')
ORDER BY Month_Number


	-- 2. BY STATE
SELECT 
	address_state AS State,
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received,
    (SUM(total_payment) - SUM(loan_amount)) AS Interest_earned_per_state
FROM bank_loan
GROUP BY address_state
ORDER BY Total_Funded_Amount DESC, Interest_earned_per_state DESC
LIMIT 3

	-- 3. TERM
SELECT 
	term AS Term,
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received,
    (SUM(total_payment) - SUM(loan_amount)) AS Interest_earned_per_term
FROM bank_loan
GROUP BY term
ORDER BY Interest_earned_per_term DESC

	-- 4. EMPLOYEE LENGTH
SELECT 
	emp_length AS Employee_Length,
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received,
    (SUM(total_payment) - SUM(loan_amount)) AS Interest_earned
FROM bank_loan
GROUP BY emp_length
ORDER BY Interest_earned DESC

	-- 5. PURPOSE
SELECT 
	purpose AS Purpose_of_Loan,
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received,
    (SUM(total_payment) - SUM(loan_amount)) AS Interest_earned
FROM bank_loan
GROUP BY purpose
ORDER BY purpose 

	-- 6. HOME OWNERSHIP
SELECT 
	home_ownership AS Home_ownership,
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received,
    (SUM(total_payment) - SUM(loan_amount)) AS Interest_earned
FROM bank_loan
GROUP BY 1
ORDER BY Interest_earned DESC 

SELECT * FROM bank_loan

-------------------------------------------------------------------------------------------------------------
			--  ADDITIONAL QUERIES
				-------------------
			 INCOME TO LOAN ANALYSIS 

-------------------------------------------------------------------------------------------------------------

-- 1. Income-to-Loan Ratio Analysis
-- A. Debt Burden Metrics

SELECT 
	(CASE 
        WHEN annual_income < 30000 THEN 'Low Income (<$30k)'
        WHEN annual_income BETWEEN 30000 AND 70000 THEN 'Middle Income ($30k-$70k)'
        WHEN annual_income > 70000 THEN 'High Income (>$70k)'
    END) AS income_group,
    ROUND(AVG(annual_income), 0) AS avg_income,
    ROUND(AVG(loan_amount), 0) AS avg_loan,
    ROUND(AVG(loan_amount) / AVG(annual_income) * 100, 1) AS loan_to_income_ratio,
    COUNT(id) AS loans,
    ROUND((COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0 / COUNT(id)),5) AS default_rate
FROM bank_loan
GROUP BY 
    CASE 
        WHEN annual_income < 30000 THEN 'Low Income (<$30k)'
        WHEN annual_income BETWEEN 30000 AND 70000 THEN 'Middle Income ($30k-$70k)'
        WHEN annual_income > 70000 THEN 'High Income (>$70k)'
    END
ORDER BY default_rate DESC

-- B. DTI (Debt-to-Income) Risk Thresholds**

SELECT 
    CASE 
        WHEN dti < 15 THEN 'Low DTI (<15%)'
        WHEN dti BETWEEN 15 AND 25 THEN 'Moderate DTI (15-25%)'
        WHEN dti > 25 THEN 'High DTI (>25%)'
    END AS dti_segment,
    AVG(int_rate) AS avg_interest,
    (COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0 / COUNT(id)) AS default_rate
FROM bank_loan
GROUP BY dti_segment
ORDER BY default_rate DESC

-- 2. Loan Purpose Risk Stratification
-- A. Income-Adjusted Purpose Analysis
WITH income_segments AS (
    SELECT 
        purpose,
        CASE 
            WHEN annual_income < 40000 THEN 'Low Income'
            ELSE 'Middle/High Income'
        END AS income_group,
        ROUND(AVG(loan_amount),2) AS avg_loan_size,
        COUNT(id) AS loans,
        ROUND((COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0 / COUNT(id)),5) AS default_rate
    FROM bank_loan
    GROUP BY purpose, income_group
)
SELECT * FROM income_segments
ORDER BY default_rate DESC
LIMIT 10

-- B. Cash Flow Underwriting

-- SQL Verification Query
SELECT 
    AVG(CASE 
        WHEN has_npl = 1 THEN loan_amount/annual_income 
        ELSE NULL 
    END) AS risky_debt_ratio
FROM (
    SELECT 
        id,
        annual_income,
        loan_amount,
        CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END AS has_npl
    FROM bank_loan
) subq; --0.21874386482478945516

-- 3. Income and loan applications 
-- A. Find the ID that has taken the highest loan for home_ownership and rank them --

WITH RankedLoan AS (
SELECT id, home_ownership, loan_amount,
ROW_NUMBER() OVER(PARTITION BY home_ownership ORDER BY loan_amount DESC) AS Purpose_Rank
FROM bank_loan
)

SELECT  id, home_ownership, loan_amount
FROM RankedLoan
where Purpose_Rank = '1'

-- B. Find the relationship between loan status and income--
SELECT
    loan_status,
    AVG(annual_income) AS average_income,
    MIN(annual_income) AS min_income,
    MAX(annual_income) AS max_income,
    COUNT(*) AS total_loans
FROM
    bank_loan
GROUP BY
    loan_status

-- C. Rank the emp_title based on the total sum of loans for each region 
SELECT
    emp_title,
    address_state,
    SUM(loan_amount) AS total_loan_amount,
    RANK() OVER (PARTITION BY emp_title ORDER BY SUM(loan_amount) DESC) AS rank_in_region
FROM
    bank_loan
GROUP BY
    emp_title, address_state
ORDER BY
    address_state, rank_in_region
    
--D.  Probability of Default
  SELECT 
      loan_status,
      COUNT(id) AS loans,
      (COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0 / COUNT(id)) AS PD_percentage
  FROM bank_loan
  GROUP BY loan_status
  
-- E. Loss given Default 
 SELECT 
      (SUM(loan_amount) - SUM(total_payment)) / SUM(loan_amount) AS LGD
  FROM bank_loan
  WHERE loan_status = 'Charged Off'
  
-- F. Risk-Adjusted Pricing Analysis 

SELECT 
    purpose,
    ROUND(AVG(int_rate  * 100),5) AS avg_interest,
    ROUND((COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0 / COUNT(id)),5) AS default_rate,
    ROUND(AVG(dti *100),5) AS avg_dti
FROM bank_loan
GROUP BY purpose
ORDER BY default_rate DESC

-- G. Prepayment Risk & Duration Analysis 
-- Weighted Average Life (WAL) Estimation:  
 
  SELECT 
      term,
      AVG(EXTRACT(MONTH FROM AGE(last_payment_date, issue_date))) AS avg_loan_duration_months
  FROM bank_loan
  WHERE loan_status = 'Fully Paid' OR loan_status = 'Current' -- 36 months -0.19802490679781074007
  GROUP BY term												   -- 60 months -0.85776559970108357205

-- H. Concentration Risk
  
SELECT 
    address_state,
    SUM(loan_amount) AS exposure,
    SUM(loan_amount) * 100.0 / (SELECT SUM(loan_amount) FROM bank_loan) AS portfolio_pct
FROM bank_loan
GROUP BY address_state
ORDER BY exposure DESC
LIMIT 5

-------------------------------------------------------------------------------------------------------------

-- 1. Use of recursive CTEs - all loans for a customer and their associated referrals 
WITH RECURSIVE customer_loans AS (
	SELECT 
			id,
			loan_amount
	FROM bank_loan
	WHERE id = 1059497
	UNION ALL 
	SELECT 
		bl.id,
		bl.loan_amount
	FROM bank_loan bl
	JOIN customer_loans cl ON bl.referred_by = cl.id
)
SELECT * FROM customer_loans


-- 2. Customers who have taken multiple categories [Use of Arrays]
SELECT 
		id,
		ARRAY_AGG(DISTINCT loan_status) AS loan_status
FROM bank_loan
GROUP BY id
HAVING ARRAY_LENGTH(ARRAY_AGG(DISTINCT loan_status),1) > 1

-- 3. Find the ID that has taken the highest loan for each purpose and rank them --
  WITH RankedLoans AS (
  	SELECT
    id,
    purpose,
	loan_status,
	annual_income,
    loan_amount,
    ROW_NUMBER() OVER (PARTITION BY purpose ORDER BY loan_amount DESC) AS purpose_rank
  FROM
    bank_loan
)

SELECT
  id,
  purpose,
  loan_status,
  annual_income,
  loan_amount,
  purpose_rank
FROM
  RankedLoans
WHERE
  purpose_rank IN ('1','2')

select * from bank_loan

-- 4. Rank customers by Loan Amount within each state
SELECT id,
	   address_state,
	   loan_amount,
	   DENSE_RANK() OVER (PARTITION BY address_state ORDER BY loan_amount DESC) AS loan_rank
FROM bank_loan

-- 5. Customer average loan compared to the Overall Average
SELECT id,
		loan_amount,
		-- ROUND(AVG(loan_amount) OVER (PARTITION BY id),0) AS customer_avg_loan
		AVG(loan_amount) OVER () AS overall_avg_loan
FROM bank_loan

-- 6. Calculate Moving Average of Loan Amounts
SELECT id, 
		issue_date,
		loan_amount,
		AVG(loan_amount) OVER (PARTITION BY id ORDER BY issue_date
		RANGE BETWEEN INTERVAL '2 months' PRECEDING AND CURRENT ROW) AS Moving_avg_loan
FROM bank_loan

SELECT 
    id, 
    issue_date,
    loan_amount,
    AVG(loan_amount) OVER (
        PARTITION BY id 
        ORDER BY issue_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_loan
FROM bank_loan
ORDER BY id, issue_date;


-- 7. Customers that borrowed more than the average - use of CTEs
WITH customer_totals AS (
	SELECT 
			id,
			SUM(loan_amount) AS total_loan_amount
	FROM bank_loan
	GROUP BY id
)
SELECT id,
	   total_loan_amount
FROM customer_totals
WHERE total_loan_amount > (SELECT 
								 AVG(total_loan_amount )
							FROM customer_totals)

-- 8. Purpose of loan and its respective default rates

SELECT 
	purpose AS loan_purpose,
	COUNT(id) number_of_loan_apps,
	ROUND((COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0 / COUNT(id)),2) AS default_rate
FROM bank_loan
GROUP BY purpose
ORDER BY default_rate DESC

-- 9. Employment Length vs. Home Ownership vs Income-Loan Application Relationship

WITH risk_segments AS (
    SELECT 
        emp_length,
        home_ownership,
        AVG(annual_income) AS segment_income,
        COUNT(*) AS segment_count,
        AVG(loan_amount) AS avg_loan
    FROM bank_loan
    GROUP BY emp_length, home_ownership
)

SELECT 
    r.emp_length,
    r.home_ownership,
    r.segment_income,
    r.avg_loan,
    ROUND(r.avg_loan * 0.35 / NULLIF(r.segment_income,0), 4) AS loan_to_income_ratio,
    d.default_rate
FROM risk_segments r
JOIN (
    SELECT 
        emp_length, 
        home_ownership,
        ROUND(COUNT(*) FILTER (WHERE loan_status = 'Charged Off') * 100.0 / COUNT(*), 2) AS default_rate
    FROM bank_loan
    GROUP BY emp_length, home_ownership
) d ON r.emp_length = d.emp_length AND r.home_ownership = d.home_ownership
ORDER BY default_rate DESC
LIMIT 10;
