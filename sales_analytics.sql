-- ============================================================
-- PROJECT: Retail Sales Performance Analysis
-- Author:  [Your Name]
-- Tools:   SQL (SQLite / MySQL / PostgreSQL compatible)
-- Dataset: Simulated retail sales data (2023)
-- ============================================================

-- ============================================================
-- SECTION 0: CREATE & POPULATE SAMPLE TABLES
-- (Run this block to set up the demo database)
-- ============================================================

CREATE TABLE IF NOT EXISTS customers (
    customer_id   INTEGER PRIMARY KEY,
    customer_name VARCHAR(100),
    region        VARCHAR(50),
    segment       VARCHAR(50)   -- 'Consumer', 'Corporate', 'Home Office'
);

CREATE TABLE IF NOT EXISTS products (
    product_id    VARCHAR(20) PRIMARY KEY,
    product_name  VARCHAR(150),
    category      VARCHAR(50),
    sub_category  VARCHAR(50),
    unit_cost     DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS orders (
    order_id      VARCHAR(20),
    order_date    DATE,
    ship_date     DATE,
    customer_id   INTEGER,
    product_id    VARCHAR(20),
    quantity      INTEGER,
    unit_price    DECIMAL(10,2),
    discount      DECIMAL(4,2),
    PRIMARY KEY (order_id, product_id)
);

-- Sample data inserts (abbreviated — full CSV available in /data folder)
INSERT OR IGNORE INTO customers VALUES
  (1001, 'Alpha Corp',     'West',    'Corporate'),
  (1002, 'Beta LLC',       'East',    'Consumer'),
  (1003, 'Gamma Inc',      'Central', 'Home Office'),
  (1004, 'Delta Partners', 'South',   'Corporate'),
  (1005, 'Epsilon Co',     'West',    'Consumer');

INSERT OR IGNORE INTO products VALUES
  ('P001', 'Wireless Keyboard',    'Technology',  'Accessories',  45.00),
  ('P002', 'Ergonomic Chair',       'Furniture',   'Chairs',      180.00),
  ('P003', 'A4 Paper Ream',         'Office Supp', 'Paper',         8.50),
  ('P004', '27" Monitor',           'Technology',  'Monitors',    220.00),
  ('P005', 'Filing Cabinet',        'Furniture',   'Storage',     130.00),
  ('P006', 'Ballpoint Pens (12pk)', 'Office Supp', 'Pens',          4.00),
  ('P007', 'Laptop Stand',          'Technology',  'Accessories',  35.00),
  ('P008', 'Whiteboard 4x3',        'Furniture',   'Boards',       75.00);

INSERT OR IGNORE INTO orders VALUES
  ('ORD-001','2023-01-05','2023-01-08',1001,'P001',  5,  55.00,0.00),
  ('ORD-002','2023-01-12','2023-01-15',1002,'P002',  2, 220.00,0.10),
  ('ORD-003','2023-02-03','2023-02-06',1003,'P003', 20,  10.00,0.05),
  ('ORD-004','2023-02-18','2023-02-22',1004,'P004',  3, 270.00,0.00),
  ('ORD-005','2023-03-07','2023-03-10',1005,'P005',  1, 150.00,0.15),
  ('ORD-006','2023-03-22','2023-03-25',1001,'P006', 50,   5.00,0.00),
  ('ORD-007','2023-04-11','2023-04-14',1002,'P007',  4,  42.00,0.05),
  ('ORD-008','2023-04-28','2023-05-01',1003,'P008',  2,  90.00,0.00),
  ('ORD-009','2023-05-15','2023-05-18',1004,'P001', 10,  55.00,0.10),
  ('ORD-010','2023-05-30','2023-06-02',1005,'P004',  2, 270.00,0.00),
  ('ORD-011','2023-06-10','2023-06-13',1001,'P002',  3, 220.00,0.05),
  ('ORD-012','2023-06-25','2023-06-28',1002,'P003', 30,  10.00,0.00),
  ('ORD-013','2023-07-08','2023-07-11',1003,'P007',  6,  42.00,0.10),
  ('ORD-014','2023-07-20','2023-07-23',1004,'P005',  2, 150.00,0.00),
  ('ORD-015','2023-08-05','2023-08-08',1005,'P006', 40,   5.00,0.05),
  ('ORD-016','2023-08-19','2023-08-22',1001,'P004',  1, 270.00,0.00),
  ('ORD-017','2023-09-03','2023-09-06',1002,'P008',  3,  90.00,0.10),
  ('ORD-018','2023-09-17','2023-09-20',1003,'P001',  8,  55.00,0.00),
  ('ORD-019','2023-10-02','2023-10-05',1004,'P003', 25,  10.00,0.00),
  ('ORD-020','2023-10-18','2023-10-21',1005,'P002',  1, 220.00,0.20),
  ('ORD-021','2023-11-05','2023-11-08',1001,'P007',  5,  42.00,0.05),
  ('ORD-022','2023-11-20','2023-11-23',1002,'P005',  2, 150.00,0.00),
  ('ORD-023','2023-12-06','2023-12-09',1003,'P006', 60,   5.00,0.00),
  ('ORD-024','2023-12-15','2023-12-18',1004,'P004',  4, 270.00,0.05),
  ('ORD-025','2023-12-28','2023-12-31',1005,'P001',  3,  55.00,0.00);


-- ============================================================
-- SECTION 1: OVERALL SALES SUMMARY
-- Business Question: What were our total revenue and volume
-- for the full year 2023?
-- ============================================================

SELECT
    COUNT(DISTINCT o.order_id)                                      AS total_orders,
    SUM(o.quantity)                                                 AS total_units_sold,
    ROUND(SUM(o.quantity * o.unit_price * (1 - o.discount)), 2)    AS total_revenue,
    ROUND(SUM(o.quantity * (o.unit_price - p.unit_cost)
              * (1 - o.discount)), 2)                               AS total_profit,
    ROUND(
        SUM(o.quantity * (o.unit_price - p.unit_cost) * (1 - o.discount))
        / NULLIF(SUM(o.quantity * o.unit_price * (1 - o.discount)), 0) * 100
    , 2)                                                            AS profit_margin_pct
FROM orders o
JOIN products p ON o.product_id = p.product_id;


-- ============================================================
-- SECTION 2: MONTHLY REVENUE TREND
-- Business Question: Is revenue growing month-over-month?
-- Used for: Line chart in Power BI / Tableau
-- ============================================================

SELECT
    strftime('%Y-%m', order_date)                                   AS month,
    COUNT(DISTINCT order_id)                                        AS orders,
    ROUND(SUM(quantity * unit_price * (1 - discount)), 2)           AS monthly_revenue
FROM orders
GROUP BY month
ORDER BY month;


-- ============================================================
-- SECTION 3: REVENUE BY PRODUCT CATEGORY
-- Business Question: Which categories drive the most revenue?
-- Used for: Bar / Pie chart
-- ============================================================

SELECT
    p.category,
    COUNT(DISTINCT o.order_id)                                      AS orders,
    SUM(o.quantity)                                                 AS units_sold,
    ROUND(SUM(o.quantity * o.unit_price * (1 - o.discount)), 2)    AS revenue,
    ROUND(SUM(o.quantity * (o.unit_price - p.unit_cost)
              * (1 - o.discount)), 2)                               AS profit,
    ROUND(
        SUM(o.quantity * (o.unit_price - p.unit_cost) * (1 - o.discount))
        / NULLIF(SUM(o.quantity * o.unit_price * (1 - o.discount)), 0) * 100
    , 2)                                                            AS margin_pct
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;


-- ============================================================
-- SECTION 4: TOP 5 BEST-SELLING PRODUCTS
-- Business Question: Which products generate the most revenue?
-- ============================================================

SELECT
    p.product_name,
    p.category,
    SUM(o.quantity)                                                 AS units_sold,
    ROUND(SUM(o.quantity * o.unit_price * (1 - o.discount)), 2)    AS revenue,
    ROUND(SUM(o.quantity * (o.unit_price - p.unit_cost)
              * (1 - o.discount)), 2)                               AS profit
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY revenue DESC
LIMIT 5;


-- ============================================================
-- SECTION 5: SALES BY REGION AND CUSTOMER SEGMENT
-- Business Question: Which region + segment combination
-- is most profitable?
-- Used for: Heatmap / Matrix visual in Power BI
-- ============================================================

SELECT
    c.region,
    c.segment,
    COUNT(DISTINCT o.order_id)                                      AS orders,
    ROUND(SUM(o.quantity * o.unit_price * (1 - o.discount)), 2)    AS revenue,
    ROUND(SUM(o.quantity * (o.unit_price - p.unit_cost)
              * (1 - o.discount)), 2)                               AS profit
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products  p ON o.product_id  = p.product_id
GROUP BY c.region, c.segment
ORDER BY profit DESC;


-- ============================================================
-- SECTION 6: CUSTOMER LIFETIME VALUE (CLV)
-- Business Question: Who are our highest-value customers?
-- ============================================================

SELECT
    c.customer_name,
    c.region,
    c.segment,
    COUNT(DISTINCT o.order_id)                                      AS total_orders,
    MIN(o.order_date)                                               AS first_purchase,
    MAX(o.order_date)                                               AS last_purchase,
    ROUND(SUM(o.quantity * o.unit_price * (1 - o.discount)), 2)    AS lifetime_revenue,
    ROUND(AVG(o.quantity * o.unit_price * (1 - o.discount)), 2)    AS avg_order_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name, c.region, c.segment
ORDER BY lifetime_revenue DESC;


-- ============================================================
-- SECTION 7: DISCOUNT IMPACT ANALYSIS
-- Business Question: Are discounts hurting profitability?
-- ============================================================

SELECT
    CASE
        WHEN discount = 0          THEN '0% – No Discount'
        WHEN discount <= 0.05      THEN '1–5%'
        WHEN discount <= 0.10      THEN '6–10%'
        WHEN discount <= 0.20      THEN '11–20%'
        ELSE '20%+'
    END                                                             AS discount_band,
    COUNT(*)                                                        AS order_lines,
    ROUND(SUM(quantity * unit_price * (1 - discount)), 2)           AS revenue,
    ROUND(AVG(quantity * unit_price * (1 - discount)), 2)           AS avg_order_value
FROM orders
GROUP BY discount_band
ORDER BY
    CASE discount_band
        WHEN '0% – No Discount' THEN 1
        WHEN '1–5%'             THEN 2
        WHEN '6–10%'            THEN 3
        WHEN '11–20%'           THEN 4
        ELSE 5
    END;


-- ============================================================
-- SECTION 8: SHIPPING EFFICIENCY
-- Business Question: How quickly are orders being shipped?
-- ============================================================

SELECT
    ROUND(AVG(julianday(ship_date) - julianday(order_date)), 1)    AS avg_days_to_ship,
    MIN(julianday(ship_date) - julianday(order_date))              AS fastest_ship_days,
    MAX(julianday(ship_date) - julianday(order_date))              AS slowest_ship_days,
    COUNT(CASE WHEN julianday(ship_date) - julianday(order_date) <= 3
               THEN 1 END)                                          AS shipped_within_3d,
    COUNT(*)                                                        AS total_orders
FROM orders;


-- ============================================================
-- SECTION 9: QUARTER-OVER-QUARTER COMPARISON (CTE)
-- Business Question: How did Q4 compare to Q3?
-- ============================================================

WITH quarterly_sales AS (
    SELECT
        CASE
            WHEN strftime('%m', order_date) IN ('01','02','03') THEN 'Q1'
            WHEN strftime('%m', order_date) IN ('04','05','06') THEN 'Q2'
            WHEN strftime('%m', order_date) IN ('07','08','09') THEN 'Q3'
            ELSE 'Q4'
        END                                                         AS quarter,
        SUM(quantity * unit_price * (1 - discount))                 AS revenue
    FROM orders
    GROUP BY quarter
)
SELECT
    quarter,
    ROUND(revenue, 2)                                               AS revenue,
    ROUND(revenue - LAG(revenue) OVER (ORDER BY quarter), 2)       AS qoq_change,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY quarter))
        / NULLIF(LAG(revenue) OVER (ORDER BY quarter), 0) * 100
    , 1)                                                            AS qoq_pct_change
FROM quarterly_sales
ORDER BY quarter;


-- ============================================================
-- SECTION 10: EXECUTIVE KPI SUMMARY VIEW
-- Creates a reusable view for dashboard tools (Power BI / Tableau)
-- ============================================================

CREATE VIEW IF NOT EXISTS vw_kpi_summary AS
SELECT
    strftime('%Y-%m', o.order_date)                                 AS month,
    p.category,
    c.region,
    c.segment,
    COUNT(DISTINCT o.order_id)                                      AS orders,
    SUM(o.quantity)                                                 AS units,
    ROUND(SUM(o.quantity * o.unit_price * (1 - o.discount)), 2)    AS revenue,
    ROUND(SUM(o.quantity * (o.unit_price - p.unit_cost)
              * (1 - o.discount)), 2)                               AS profit
FROM orders o
JOIN products  p ON o.product_id  = p.product_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY month, p.category, c.region, c.segment;

-- End of script
