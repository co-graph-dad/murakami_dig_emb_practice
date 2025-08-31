CREATE DATABASE IF NOT EXISTS sampledb;
USE sampledb;

DROP TABLE IF EXISTS middle_telecom_customers;
CREATE TABLE middle_telecom_customers (
  customer_id BIGINT,
  contract_type VARCHAR(255),
  prefecture VARCHAR(255),
  age BIGINT,
  age_group VARCHAR(255),
  gender VARCHAR(255),
  contract_date VARCHAR(255),
  plan_type VARCHAR(255),
  monthly_fee BIGINT,
  fee_category VARCHAR(255),
  device_type VARCHAR(255),
  network_type VARCHAR(255),
  data_usage_gb DOUBLE,
  usage_category VARCHAR(255),
  call_minutes BIGINT,
  payment_method VARCHAR(255),
  credit_score BIGINT,
  family_size BIGINT,
  annual_income BIGINT,
  income_category VARCHAR(255),
  last_login_date VARCHAR(255),
  support_contacts BIGINT,
  is_active BOOLEAN,
  churn_risk_score DOUBLE,
  risk_category VARCHAR(255),
  customer_segment VARCHAR(255)
);

LOAD DATA LOCAL INFILE '/middle_data/middle_telecom_customers000.00.csv'
INTO TABLE middle_telecom_customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;