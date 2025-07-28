# 🐝 SQL-data-analysis-project-for-Production-Planning-Detailed-Scheduling
This repository represents a comprehensive SQLLite-based data and analytics solution for production planning and detailed scheduling in food manufacturing sector

---
## 🐹 Overview
This project accounts for sector requirements such as perishability, batch processing, capacity, seasonal demand, and line scheduling

### Highlights
- Advanced SQL schema for food production plannning and scheduling scenarios
- Sample data and key analysis queries

---

## 🐉 Business Problem
Food manufacturers must:
- Manage perishable raw materials
- Schedule multi-step process (mixing, baking, cooling, packing)
- Coordinate workforce/machine availability
- Handle fluctuating demand, complex receipes and allergen changeovers

**Objective**: Use SQL analytics for precise planning and efficient, data-driven scheduling decisions

---

## 🪿 Database schema
|*Table*|*Definitions*|
|-------|-------------|
|products|defines finished food items/SKUs|
|recipes|links each product to its recipe and process flow|
|ingredients|raw materials with shelf life|
|recipe_ingredients|which ingredients (and how much) for recipe|
|Production_lines|production lines; capacities/constraints|
|shifts|work shifts for scheduling|
|production_orders|planned production jobs with dates, batch qty and status|
|prod_order_steps|stepwise status per production order|
|employees|workers(optional, for advance scheduling/assignments)|
|inventory|tracks ingredients and finished product stocks|
|suppliers|supplier master data|
|purchase_orders|tracks ingredient procurement|

---

## 🎍 Case study


