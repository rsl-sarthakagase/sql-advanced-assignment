# SQL Advanced Assignment

## Overview

This project contains the SQL solution for the **SQL (Advanced) Assignment** based on an online shopping platform.

The assignment covers:

- Advanced Joins
- Subqueries
- Set Operations
- Window Functions
- Common Table Expressions (CTEs)
- Views
- Indexes and Query Performance
- Stored Procedures and Functions
- Transactions
- SQL Triggers
- Performance Tuning

## Database Schema

### Customers

- `customer_id`
- `customer_name`
- `city`
- `email`

### Products

- `product_id`
- `product_name`
- `category`
- `price`

### Orders

- `order_id`
- `customer_id`
- `product_id`
- `quantity`
- `order_date`

```
+----------------------------------+
| Tables_in_sandbox_db |
+----------------------------------+
| continents                       |
| customers                        |
| order_audit                      |
| orders                           |
| products                         |
| products_above_1000              |
+----------------------------------+
+---------------+--------------+------+-----+---------+-------+
| Field         | Type         | Null | Key | Default | Extra |
+---------------+--------------+------+-----+---------+-------+
| customer_id   | int          | NO   | PRI | NULL    |       |
| customer_name | varchar(100) | NO   |     | NULL    |       |
| city          | varchar(100) | NO   |     | NULL    |       |
| email         | varchar(150) | NO   | UNI | NULL    |       |
+---------------+--------------+------+-----+---------+-------+
+--------------+---------------+------+-----+---------+-------+
| Field        | Type          | Null | Key | Default | Extra |
+--------------+---------------+------+-----+---------+-------+
| product_id   | int           | NO   | PRI | NULL    |       |
| product_name | varchar(150)  | NO   |     | NULL    |       |
| category     | varchar(50)   | NO   | MUL | NULL    |       |
| price        | decimal(10,2) | NO   |     | NULL    |       |
+--------------+---------------+------+-----+---------+-------+
+--------------+---------------+------+-----+---------+-------+
| Field        | Type          | Null | Key | Default | Extra |
+--------------+---------------+------+-----+---------+-------+
| product_id   | int           | NO   |     | NULL    |       |
| product_name | varchar(150)  | NO   |     | NULL    |       |
| category     | varchar(50)   | NO   |     | NULL    |       |
| price        | decimal(10,2) | NO   |     | NULL    |       |
+--------------+---------------+------+-----+---------+-------+
+-------------+------+------+-----+---------+-------+
| Field       | Type | Null | Key | Default | Extra |
+-------------+------+------+-----+---------+-------+
| order_id    | int  | NO   | PRI | NULL    |       |
| customer_id | int  | YES  | MUL | NULL    |       |
| product_id  | int  | NO   | MUL | NULL    |       |
| quantity    | int  | NO   |     | NULL    |       |
| order_date  | date | NO   |     | NULL    |       |
+-------------+------+------+-----+---------+-------+
+-----------------+-------------+------+-----+-------------------+-------------------+
| Field           | Type        | Null | Key | Default           | Extra             |
+-----------------+-------------+------+-----+-------------------+-------------------+
| audit_id        | int         | NO   | PRI | NULL              | auto_increment    |
| order_id        | int         | NO   |     | NULL              |                   |
| customer_id     | int         | YES  |     | NULL              |                   |
| product_id      | int         | NO   |     | NULL              |                   |
| quantity        | int         | NO   |     | NULL              |                   |
| order_date      | date        | NO   |     | NULL              |                   |
| action          | varchar(20) | NO   |     | NULL              |                   |
| audit_timestamp | timestamp   | NO   |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
+-----------------+-------------+------+-----+-------------------+-------------------+
```

## How to Execute

1. Open a MySQL 8.0-compatible SQL environment such as SQLize.online or MySQL Workbench.
2. Open `SQL_Advanced_Assignment_Solution.sql`.
3. Execute the script from top to bottom.
4. The script creates the database, tables, sample data, and all required database objects and queries.

## Advanced SQL Concepts

The solution demonstrates:

- `INNER JOIN`, `LEFT JOIN`, and `CROSS JOIN`
- Subqueries and correlated subqueries
- `UNION` and MySQL alternatives for `INTERSECT`/`EXCEPT`
- `RANK()`, `LAG()`, and running totals
- Non-recursive and recursive CTEs
- Views
- Index creation and `EXPLAIN`
- Stored procedures and functions
- `COMMIT` and `ROLLBACK`
- Triggers and audit logging
- SQL query performance optimization

These correspond to the sections and tasks specified in the assignment.
