-- Create Ingredient Table
CREATE TABLE re_ingredient (
    ingredient_id INT IDENTITY(1,1) PRIMARY KEY, -- this is a field that auto generates the id values for us. Start at 1 and increment at one each time. 
    ingredient_desc VARCHAR(50) NOT NULL,
    calories DECIMAL(6,2) DEFAULT 0
)

-- create menu table
CREATE TABLE re_menu_item (
    menu_item_id INT IDENTITY(1,1) PRIMARY KEY,
    menu_item_desc VARCHAR(60) NOT NULL,
    price DECIMAL(4,2) NOT NULL CHECK(price > 0)
)

--create recipe table -- adding constraint so that we cannot add anything into this junction table that references the tables above
CREATE TABLE re_recipe (
    recipe_id INT IDENTITY(1,1) PRIMARY KEY,
    ingredient_id INT NOT NULL,
    menu_item_id INT NOT NULL,
    quantity INT NOT NULL,
    CONSTRAINT fk_rec_ing_id_ref_ing_ing_id FOREIGN KEY (ingredient_id) REFERENCES re_ingredient(ingredient_id),-- foreign key in recipe table, ingredient id referencing ingredient table, ingredient id
    CONSTRAINT fk_rec_menu_item_id_ref_men_menu_item_id FOREIGN KEY (menu_item_id) REFERENCES re_menu_item (menu_item_id)
)

--ASSIGN INDE FOR MENU ITEM DESCIPTION
CREATE NONCLUSTERED INDEX idx_menu_item_menu_item_desc ON re_menu_item(menu_item_desc)

--Add data to ingredient
INSERT INTO re_ingredient VALUES
('Bun',140.00),
('Beef Patty', 200.00),
('Cheese', 50.00),
('Chicken Patty', 150.00),
('Buffalo Sauce', 20.00);

--Add data to menu
INSERT INTO re_menu_item VALUES
('Cheeseburger',2.99),
('Hamburger',1.75),
('Chicken Sandwich',2.99),
('Buffalo Chicken Sandwich', 3.19);

--Add data to recipe
INSERT INTO re_recipe VALUES
(1,1,1),
(2,1,1),
(3,1,1),
(1,2,1),
(2,2,1),
(1,3,1),
(4,3,1),
(1,4,1),
(4,4,1),
(5,4,1);

-- set operators
SELECT m.menu_item_desc, m.price
FROM re_menu_item m 
JOIN re_recipe r ON m.menu_item_id = r.menu_item_id
JOIN re_ingredient i ON r.ingredient_id = i.ingredient_id
WHERE i.ingredient_desc = 'Chicken Patty';


--UNION implementation

-- UNION 


-- set operators
SELECT m.menu_item_desc, m.price
FROM re_menu_item m 
JOIN re_recipe r ON m.menu_item_id = r.menu_item_id
JOIN re_ingredient i ON r.ingredient_id = i.ingredient_id
WHERE i.ingredient_desc = 'Cheese';

-- WINDOW FUNCTION
SELECT m.menu_item_desc, m.price, i.ingredient_desc, i.calories,
SUM(i.calories) OVER (PARTITION BY m.menu_item_desc) AS total_calories
FROM re_menu_item m 
JOIN re_recipe r ON m.menu_item_id = r.menu_item_id
JOIN re_ingredient i ON r.ingredient_id = i.ingredient_id
