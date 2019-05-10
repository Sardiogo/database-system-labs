-- CREATE DATABASE IF NOT EXISTS bank;

DROP TABLE IF EXISTS borrower;
DROP TABLE IF EXISTS loan;
DROP TABLE IF EXISTS depositor;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS account;
DROP TABLE IF EXISTS branch;

-- To CREATE the database,
-- you will need to CREATE the TABLEs (with the SQL command CREATE TABLE)
-- and then load the records to fill each TABLE.
CREATE TABLE customer
   (customer_name VARCHAR(255) NOT NULL UNIQUE,
    customer_street VARCHAR(255) NOT NULL,
    customer_city VARCHAR(255) NOT NULL,
    PRIMARY KEY(customer_name));

CREATE TABLE branch
   (branch_name VARCHAR(255),
    branch_city VARCHAR(255),
    assets numeric(20,2),
    PRIMARY KEY(branch_name));

CREATE TABLE account
   (account_number VARCHAR(255),
    branch_name VARCHAR(255),
    balance numeric(20,2),
    PRIMARY KEY(account_number),
    FOREIGN KEY(branch_name) REFERENCES branch(branch_name));

CREATE TABLE depositor
   (customer_name VARCHAR(255),
    account_number VARCHAR(255),
    PRIMARY KEY(customer_name, account_number),
    FOREIGN KEY(customer_name) REFERENCES customer(customer_name),
    FOREIGN KEY(account_number) REFERENCES account(account_number));

CREATE TABLE loan
   (loan_number VARCHAR(255),
    branch_name VARCHAR(255),
    amount numeric(20,2),
    PRIMARY KEY(loan_number),
    FOREIGN KEY(branch_name) REFERENCES branch(branch_name));

CREATE TABLE borrower
   (customer_name VARCHAR(255),
    loan_number VARCHAR(255),
    PRIMARY KEY(customer_name, loan_number),
    FOREIGN KEY(customer_name) REFERENCES customer(customer_name),
    FOREIGN KEY(loan_number) REFERENCES loan(loan_number));