/*TABLE DEFINITIONS*/

-- Products
CREATE TABLE products1(
	product_id INTEGER PRIMARY KEY AUTOINCREMENT,
	name TEXT NOT NULL,
	sku TEXT UNIQUE,
	shelf_life_days INTEGER,
	allergen_info TEXT
);
SELECT * FROM products1;

-- Ingredients
CREATE TABLE ingredients(
	ingredient_id INTEGER PRIMARY KEY AUTOINCREMENT,
	name TEXT,
	unit TEXT,
	shelf_life_days INTEGER
);
SELECT * FROM ingredients;

-- Recipes
CREATE TABLE recipes(
	recipe_id INTEGER PRIMARY KEY AUTOINCREMENT,
	product_id INTEGER NOT NULL,
	name TEXT,
	yield_qty REAL,
	yield_unit TEXT,
	FOREIGN KEY (product_id) REFERENCES products1(product_id)
);
SELECT * FROM recipes;

-- Recipe ingredients
CREATE TABLE recipe_ingredients(
	rec_ing_id INTEGER PRIMARY KEY AUTOINCREMENT,
	recipe_id INTEGER,
	ingredient_id INTEGER,
	qty REAL,
	FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id),
	FOREIGN KEY (ingredient_id) REFERENCES ingredients(ingredients_id)
);

-- Production lines
CREATE TABLE production_lines(
	line_id INTEGER PRIMARY KEY AUTOINCREMENT,
	name TEXT,
	available_hours_per_day REAL
);
SELECT * FROM production_lines;

-- Shifts
CREATE TABLE shifts(
	shift_id INTEGER PRIMARY KEY AUTOINCREMENT,
	line_id INTEGER,
	shift_name TEXT,
	start_time TEXT,
	end_time TEXT,
	FOREIGN KEY (line_id) REFERENCES production_lines(line_id)
);
SELECT * FROM shifts;

-- Production Orders
CREATE TABLE production_orders(
	prod_order_id INTEGER PRIMARY KEY AUTOINCREMENT,
	product_id INTEGER,
	planned_date DATE,
	planned_qty REAL,
	status TEXT, -- e.g., Planned, In progress, Complete
	line_id INTEGER,
	shift_id INTEGER,
	FOREIGN KEY (product_id) REFERENCES products1(product_id),
	FOREIGN KEY (line_id) REFERENCES production_lines(line_id)
);
SELECT * FROM production_orders;

-- Production Order steps
CREATE TABLE prod_order_steps(
	step_id INTEGER PRIMARY KEY AUTOINCREMENT,
	prod_order_id INTEGER,
	step_name TEXT,
	actual_start DATETIME,
	actual_end DATETIME,
	status TEXT,
	FOREIGN KEY (prod_order_id) REFERENCES production_orders(prod_order_id)
);
SELECT * FROM prod_order_steps;

-- Employees
CREATE TABLE employees(
	employee_id INTEGER PRIMARY KEY AUTOINCREMENT,
	name TEXT,
	role TEXT
);
SELECT * FROM employees;

-- Suppliers
CREATE TABLE suppliers1(
	supplier_id INTEGER PRIMARY KEY AUTOINCREMENT,
	name TEXT,
	rating INTEGER
);
SELECT * FROM suppliers1;

-- Purchase orders
CREATE TABLE purchase_orders1(
	po_id INTEGER PRIMARY KEY AUTOINCREMENT,
	supplier_id INTEGER,
	ingredient_id INTEGER,
	qty REAL,
	order_date DATE,
	delivery_date DATE,
	status TEXT,
	FOREIGN KEY (supplier_id) REFERENCES suppliers1(supplier_id),
	FOREIGN KEY (ingredient_id) REFERENCES ingredients(ingredient_id)
);
SELECT * FROM purchase_orders1;

-- Inventory
CREATE TABLE inventory1(
	inv_id INTEGER PRIMARY KEY AUTOINCREMENT,
	item_type TEXT, -- 'Ingredient' or 'Product'
	item_id INTEGER,
	location TEXT,
	qty_on_hand REAL,
	expiry_date DATE 
);
SELECT * FROM inventory1;

-- DATA
-- Products (SKUs)
INSERT INTO products1 (name, sku, shelf_life_days, allergen_info) VALUES
('Sourdough Bread', 'BRD001', 5, 'Contains Gluten'),
('Chocolate Muffin','MUF002', 7, 'Contains Egg, Dairy, Gluten');

-- Ingredients
INSERT INTO ingredients(name, unit, shelf_life_days) VALUES
('Flour', 'kg', 180),
('Yeast', 'g', 90),
('Water', 'L', 30),
('Chocolate Chips', 'kg', 120),
('Sugar', 'kg', 365),
('Butter', 'kg', 60),
('Eggs', 'dozen', 14);

-- Recipes
INSERT INTO recipes(product_id, name, yield_qty, yield_unit) VALUES
(1, 'Sourdough Bread Batch', 20, 'Loaves'),
(2, 'Chocolate Muffins batch', 50, 'Muffins');

-- Recipe ingredients
INSERT INTO recipe_ingredients(recipe_id, ingredient_id, qty) VALUES
(1, 1, 5), -- 5 kg flour
(1, 2, 50), -- 50 g yeast
(1, 3, 3), -- 3 L water
(2, 1, 2), -- 2 kg flour
(2, 4, 0.5), -- 0.5 g choco chips
(2, 5, 1), -- 1kg sugar
(2, 6, 0.8), -- 0.8g butter
(2, 7, 3); -- 3 dozen eggs

-- Production lines
INSERT INTO production_lines(name, available_hours_per_day) VALUES
('Main Bakery line', 16),
('Pastry line', 12);

-- Shifts
INSERT INTO shifts(line_id, shift_name, start_time, end_time) VALUES
(1, 'Morning', '06:00', '14:00'),
(1, 'Afternoon', '14:00', '22:00'),
(2, 'Day', '08:00', '20:00');

-- Production orders
INSERT INTO production_orders(product_id, planned_date, planned_qty, status, line_id, shift_id) VALUES
(1, '2025-07-28', 40, 'Planned', 1, 1),
(2, '2025-07-28', 100, 'Planned', 2, 3);

-- Production Order steps
INSERT INTO prod_order_steps(prod_order_id, step_name, actual_start, actual_end, status) VALUES
(1, 'Mixing', NULL, NULL, 'Pending'),
(1, 'Baking', NULL, NULL, 'Pending'),
(2, 'Mixing', NULL, NULL, 'Pending'),
(2, 'Baking', NULL, NULL, 'Pending');

-- Employees
INSERT INTO employees(name, role) VALUES
('Alice', 'Baker'),
('Bob', 'Packer');

-- Suppliers
INSERT INTO suppliers1(name, rating) VALUES
('Flour Mills', 4),
('Sweet Ingredients', 5);

-- Purchase Orders
INSERT INTO purchase_orders1(supplier_id, ingredient_id, qty, order_date, delivery_date, status) VALUES
(1, 1, 100, '2025-07-06', '2025-07-25', 'Ordered'),
(2, 5, 20, '2025-07-09', '2025-07-29', 'Ordered');

-- Inventory
INSERT INTO inventory1(item_type, item_id, location, qty_on_hand, expiry_date) VALUES
('Ingredient', 1, 'Warehouse A', 20, '2025-11-01'),
('Ingredient', 5, 'Warehouse A', 6, '2026-01-01'),
('Product', 1, 'Bakery Shelf', 10, '2025-08-02'),
('Product', 2, 'Pastry Counter', 15, '2025-08-03');

/*Ingredient availability for Production Scheduling*/
-- For production_order_id = 1 (Sourdough Bread, 40 Loaves)
SELECT 
	i.name AS ingredient,
	ri.qty * (40.0/r.yield_qty) AS required_qty,
	inv.qty_on_hand,
	i.unit,
	(inv.qty_on_hand - ri.qty * (40.0/r.yield_qty)) AS projected_balance
FROM production_orders po
JOIN recipes r ON po.product_id = r.product_id
JOIN recipe_ingredients ri ON r.recipe_id = ri.recipe_id
JOIN ingredients i ON ri.ingredient_id = i.ingredient_id
LEFT JOIN inventory1 inv ON inv.item_type = 'Ingredient' AND inv.item_id = i.ingredient_id
WHERE po.prod_order_id = 1;

/*Scheduled utilization of bakery lines*/
SELECT 
	pl.name AS production_line,
	s.shift_name,
	po.planned_date,
	po.status,
	pr.name AS product,
	po.planned_qty
FROM production_orders po
JOIN production_lines pl ON po.line_id = pl.line_id
JOIN shifts s ON po.shift_id = s.shift_id
JOIN products1 pr ON po.product_id = pr.product_id
WHERE po.planned_date = '2025-07-08'
ORDER BY pl.name, s.start_time;

/*Ingredient expiry & Reordering needs*/
-- Find all ingredients expiring in next 2 weeks or below threshold
SELECT
	i.name,
	inv.qty_on_hand,
	inv.expiry_date,
	CASE WHEN inv.qty_on_hand < 10 THEN 'Reorder'ELSE 'OK' END AS action
FROM inventory1 inv
JOIN ingredients i ON inv.item_id = i.ingredient_id
WHERE inv.item_type = 'Ingredient'
	AND(DATE(inv.expiry_date) <= DATE('2025-08-11') OR inv.qty_on_hand < 10);

/*Production Order Progress Tracking*/
SELECT
	po.prod_order_id,
	pr.product_name AS product,
	po.planned_date,
	po.status,
	pos.step_name,
	pos.status AS step_status,
	pos.actual_start,
	pos.actual_end
FROM production_orders po
JOIN products pr ON po.product_id = pr.product_id
JOIN prod_order_steps pos ON po.prod_order_id = pos.prod_order_id
ORDER BY po.prod_order_id, pos.step_id;

