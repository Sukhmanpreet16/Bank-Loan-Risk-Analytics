-- =========================================
-- BANK LOAN ANALYSIS PROJECT
-- SQL Queries by Sukhmanpreet Singh Toor
-- =========================================

-- =========================
-- 0. SCHEMA CREATION
-- =========================

CREATE TABLE customers(
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    age INT,
    gender VARCHAR(10),
    income NUMERIC(12,2),
    credit_score INT
);

CREATE TABLE loans(
    loan_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    loan_type VARCHAR(50),
    loan_amount NUMERIC(12,2),
    interest_rate NUMERIC(5,2),
    tenure_months INT,
    status VARCHAR(20)  -- 'Active', 'Closed', 'Defaulted'
);

CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    loan_id INT REFERENCES loans(loan_id),
    payment_date DATE,
    amount_paid NUMERIC(12,2)
);

CREATE TABLE defaults (
    default_id SERIAL PRIMARY KEY,
    loan_id INT REFERENCES loans(loan_id),
    default_date DATE,
    reason VARCHAR(200)
);

-- =========================
-- 1. DATA INSERTION
-- =========================

INSERT INTO customers (name, age, gender, income, credit_score) VALUES
('Amit Sharma', 32, 'Male', 75000, 720),
('Priya Verma', 28, 'Female', 65000, 680),
('Rahul Mehta', 45, 'Male', 90000, 750),
('Sneha Kapoor', 38, 'Female', 82000, 710),
('Arjun Singh', 29, 'Male', 58000, 640),
('Neha Jain', 34, 'Female', 72000, 700),
('Karan Malhotra', 41, 'Male', 100000, 770),
('Divya Nair', 27, 'Female', 60000, 660),
('Rohit Kumar', 36, 'Male', 85000, 730),
('Meera Joshi', 30, 'Female', 70000, 690),
('Sanjay Gupta', 40, 'Male', 95000, 760),
('Pooja Rani', 26, 'Female', 55000, 630),
('Vikram Sethi', 33, 'Male', 80000, 710),
('Anjali Sharma', 35, 'Female', 72000, 695),
('Ramesh Yadav', 42, 'Male', 87000, 745),
('Shreya Patel', 31, 'Female', 67000, 675),
('Manoj Singh', 39, 'Male', 91000, 735),
('Kavita Iyer', 29, 'Female', 64000, 660),
('Nikhil Verma', 37, 'Male', 89000, 725),
('Alisha Khan', 28, 'Female', 61000, 650);

INSERT INTO loans (customer_id, loan_type, loan_amount, interest_rate, tenure_months, status) VALUES
(1, 'Home Loan', 1500000, 7.5, 240, 'Active'),
(2, 'Car Loan', 500000, 9.0, 60, 'Closed'),
(3, 'Personal Loan', 200000, 12.5, 36, 'Active'),
(4, 'Education Loan', 300000, 10.0, 48, 'Closed'),
(5, 'Car Loan', 400000, 9.5, 48, 'Defaulted'),
(6, 'Personal Loan', 250000, 11.0, 24, 'Active'),
(7, 'Home Loan', 1800000, 7.2, 240, 'Active'),
(8, 'Car Loan', 450000, 8.9, 60, 'Closed'),
(9, 'Personal Loan', 220000, 12.0, 36, 'Active'),
(10, 'Education Loan', 280000, 9.8, 60, 'Defaulted'),
(11, 'Home Loan', 2000000, 7.0, 240, 'Active'),
(12, 'Car Loan', 380000, 9.3, 48, 'Closed'),
(13, 'Personal Loan', 300000, 11.8, 36, 'Active'),
(14, 'Education Loan', 250000, 9.7, 48, 'Closed'),
(15, 'Car Loan', 420000, 9.0, 48, 'Defaulted'),
(16, 'Home Loan', 1700000, 7.4, 240, 'Active'),
(17, 'Personal Loan', 210000, 12.2, 36, 'Active'),
(18, 'Car Loan', 500000, 9.1, 60, 'Closed'),
(19, 'Education Loan', 270000, 9.6, 60, 'Defaulted'),
(20, 'Personal Loan', 230000, 11.5, 24, 'Active');

INSERT INTO payments (loan_id, payment_date, amount_paid) VALUES
(1, '2024-01-15', 20000),
(1, '2024-02-15', 20000),
(2, '2023-05-10', 30000),
(3, '2024-03-01', 15000),
(3, '2024-04-01', 15000),
(4, '2023-08-20', 20000),
(5, '2024-01-25', 12000),
(6, '2024-02-10', 18000),
(7, '2024-01-12', 25000),
(8, '2023-09-05', 28000),
(9, '2024-02-14', 16000),
(10, '2023-12-18', 10000),
(11, '2024-01-30', 30000),
(12, '2023-07-22', 15000),
(13, '2024-02-20', 20000),
(14, '2023-09-10', 17000),
(15, '2024-01-05', 12000),
(16, '2024-01-19', 28000),
(17, '2024-02-25', 14000),
(18, '2023-10-10', 20000),
(19, '2023-11-18', 15000),
(20, '2024-03-01', 18000);

INSERT INTO defaults (loan_id, default_date, reason) VALUES
(5, '2024-02-28', 'Job Loss'),
(10, '2023-12-15', 'Business Failure'),
(15, '2024-01-12', 'Medical Emergency'),
(19, '2023-11-20', 'Missed EMIs');

-- =========================
-- 2. CUSTOMER ANALYSIS
-- =========================

-- 2a. Customer Gender Count
SELECT gender, COUNT(*) AS total_customers
FROM customers
GROUP BY gender;

-- 2b. Customer Age Group Count
SELECT
  CASE
    WHEN age BETWEEN 18 AND 25 THEN '18-25'
    WHEN age BETWEEN 26 AND 35 THEN '26-35'
    WHEN age BETWEEN 36 AND 50 THEN '36-50'
    ELSE '50+'
  END AS age_group,
  COUNT(*) AS total_customers
FROM customers
GROUP BY age_group;

-- =========================
-- 3. LOAN PORTFOLIO ANALYSIS
-- =========================

-- 3a. Total Loans and Total Amount
SELECT COUNT(*) AS total_loans,
       SUM(loan_amount) AS total_amount
FROM loans;

-- 3b. Average Loan Amount by Type
SELECT loan_type,
       ROUND(AVG(loan_amount), 2) AS avg_loan_amount
FROM loans
GROUP BY loan_type;

-- 3c. Loan Status Count and Amount
SELECT status,
       COUNT(*) AS loan_count,
       SUM(loan_amount) AS total_amount
FROM loans
GROUP BY status;

-- 3d. Loan Type Share by Total Amount
SELECT loan_type,
       SUM(loan_amount) AS total_amount,
       ROUND(100.0 * SUM(loan_amount) / (SELECT SUM(loan_amount) FROM loans), 2) AS percentage_share
FROM loans
GROUP BY loan_type
ORDER BY total_amount DESC;

-- =========================
-- 4. PAYMENT / DEFAULT ANALYSIS
-- =========================

-- 4a. Repayment and Default Rates
SELECT
round(100* sum(case when status= 'Closed' then 1 else 0 end)/count(*),2) as repayment_rate,
round(100* sum(case when status= 'Defaulted' then 1 else 0 end)/count(*),2) as default_rate
FROM loans;

-- 4b. Total Paid per Customer
SELECT
    c.customer_id,
    c.name,
    SUM(p.amount_paid) AS total_paid
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
JOIN payments p ON l.loan_id = p.loan_id
GROUP BY c.customer_id, c.name
ORDER BY total_paid DESC;

-- =========================
-- 5. RISK / PORTFOLIO INSIGHTS
-- =========================

-- 5a. High-Risk Customers (Defaulted Loans)
SELECT DISTINCT c.customer_id, c.name, c.age, c.gender, c.income, c.credit_score
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
WHERE l.status = 'Defaulted';

-- 5b. Loan Type Share (by Amount)
SELECT loan_type,
       SUM(loan_amount) AS total_amount,
       ROUND(100.0 * SUM(loan_amount) / (SELECT SUM(loan_amount) FROM loans), 2) AS percentage_share
FROM loans
GROUP BY loan_type
ORDER BY total_amount DESC;

-- =========================================
-- END OF BANK LOAN ANALYSIS SQL QUERIES
-- =========================================
