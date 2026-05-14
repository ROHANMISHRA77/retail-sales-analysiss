# 📊 Retail Sales Performance Analysis — FY 2023

> **End-to-end SQL analytics project** covering revenue analysis, customer segmentation, discount impact, and executive KPI reporting for a simulated retail business.

---

## 🧑‍💼 About This Project

This is a portfolio project built to demonstrate entry-level Data Analyst skills.  
It simulates a real-world analytics workflow: from raw transactional data → SQL queries → business insights → professional report.

**Tools Used:** `SQL (SQLite)` · `Microsoft Excel` · `Power BI`  
**Author:** Rohan Mishra  
**Contact:** mishrarohan7822@gmail.com

---

## 📁 Project Files

| File | Description |
|------|-------------|
| `sales_analytics.sql` | All 10 SQL query sections with setup DDL + sample data |
| `Sales_Analytics_Insights_Report.docx` | 9-section professional insights report with KPI tables & recommendations |
| `README.md` | Project overview (this file) |

---

## 🗃️ Database Schema

Three relational tables were designed and populated with sample data:

```
customers        products           orders
──────────       ──────────         ──────────────────
customer_id  ──► customer_id        order_id
customer_name    product_id    ◄──  product_id
region           product_name       order_date
segment          category           ship_date
                 sub_category       quantity
                 unit_cost          unit_price
                                    discount
```

---

## 🔍 SQL Queries — What's Inside

| Section | Query Topic | SQL Concepts Used |
|---------|-------------|-------------------|
| 0 | Create tables & insert sample data | DDL, INSERT |
| 1 | Overall sales summary (revenue, profit, margin) | SUM, COUNT, ROUND, NULLIF |
| 2 | Monthly revenue trend | strftime, GROUP BY, ORDER BY |
| 3 | Revenue & profit by product category | Multi-column GROUP BY, margin % |
| 4 | Top 5 best-selling products | ORDER BY, LIMIT |
| 5 | Region × segment profitability matrix | Multi-table JOINs |
| 6 | Customer Lifetime Value (CLV) ranking | MIN, MAX, AVG, GROUP BY |
| 7 | Discount impact analysis | CASE WHEN bucketing |
| 8 | Shipping efficiency | julianday(), date math, COUNT CASE |
| 9 | Quarter-over-Quarter comparison | CTE (WITH), LAG() window function |
| 10 | Executive KPI summary view | CREATE VIEW |

---

## 📈 Key Business Insights

- 💰 **Total Revenue: ₹8,47,350** across 25 orders in FY 2023
- 📦 **Technology** was the #1 revenue category despite lowest unit volume
- 🏆 **West region Corporate** customers delivered the highest profit (₹65,914)
- 🔖 **Zero-discount orders** generated **54.5% of total revenue** — discounts above 10% dropped average order value by 32%
- 📅 **Q2 2023** saw the strongest growth at **+63.5% QoQ**
- 🚚 Average shipping time: **3.1 days** per order

---

## 💡 Business Recommendations

1. **Focus on West & South Corporate accounts** — highest CLV and profit per order
2. **Cap discounts at 10%** — orders above this threshold significantly erode margin
3. **Expand Technology product range** — #1 category with healthy 31% margins
4. **Run a Q3 promotional campaign** — revenue dipped 20% vs Q2 every quarter
5. **Connect `vw_kpi_summary` view to Power BI** for live executive dashboard

---

## 🚀 How to Run

1. Download `sales_analytics.sql`
2. Open any SQL tool — **DB Browser for SQLite** (free), MySQL Workbench, or pgAdmin
3. Run **Section 0** first to create tables and insert sample data
4. Run any section independently — each is self-contained with comments

```sql
-- Example: Run Section 4 to see Top 5 products
SELECT
    p.product_name,
    SUM(o.quantity) AS units_sold,
    ROUND(SUM(o.quantity * o.unit_price * (1 - o.discount)), 2) AS revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_id
ORDER BY revenue DESC
LIMIT 5;
```

---

## 📬 Connect With Me

- 📧 mishrarohan7822@gmail.com  
- 📍 Delhi, India  
- 💼 Open to **Data Analyst internships & entry-level roles**

---

*Built as part of my Data Analytics portfolio. Feedback welcome!* 🙌
