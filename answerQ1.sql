-- ecommerceDB_schema.sql
-- CREATE DATABASE
DROP DATABASE IF EXISTS ecommerceDB;
CREATE DATABASE ecommerceDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ecommerceDB;

-- ----------------------------
-- Table: customers
-- ----------------------------
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(30),
    address VARCHAR(300),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ----------------------------
-- Table: categories
-- ----------------------------
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(500)
) ENGINE=InnoDB;

-- ----------------------------
-- Table: products
-- ----------------------------
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    product_sku VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    buy_price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    sell_price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    quantity_in_stock INT NOT NULL DEFAULT 0,
    category_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
      ON DELETE SET NULL
      ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ----------------------------
-- Table: orders
-- ----------------------------
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    shipped_date DATETIME NULL,
    status ENUM('Pending','Processing','Shipped','Cancelled','Completed') NOT NULL DEFAULT 'Pending',
    total_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
      ON DELETE RESTRICT
      ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ----------------------------
-- Table: order_items (junction table)
-- ----------------------------
CREATE TABLE order_items (
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price_each DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
      ON DELETE RESTRICT
      ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ----------------------------
-- Optional: suppliers table (example of another relationship)
-- ----------------------------
CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(150) NOT NULL,
    contact_email VARCHAR(255),
    phone VARCHAR(30)
) ENGINE=InnoDB;

-- Link products to suppliers (optional One-to-Many)
ALTER TABLE products
ADD COLUMN supplier_id INT NULL AFTER category_id,
ADD FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
  ON DELETE SET NULL
  ON UPDATE CASCADE;

-- ----------------------------
-- Sample data (small dataset)
-- ----------------------------
INSERT INTO customers (customer_name, email, phone, address)
VALUES
('John Doe', 'john@example.com', '+254700111222', '123 Nairobi Rd'),
('Jane Smith', 'jane@example.com', '+254700222333', '45 Mombasa Ave');

INSERT INTO categories (category_name, description)
VALUES ('Laptops', 'Portable computers'), ('Accessories', 'Computer accessories');

INSERT INTO suppliers (supplier_name, contact_email, phone)
VALUES ('Tech Supply Ltd', 'sales@techsupply.co', '+254700999888');

INSERT INTO products (product_name, product_sku, description, buy_price, sell_price, quantity_in_stock, category_id, supplier_id)
VALUES
('SuperLaptop Pro', 'SLP-1000', '15" laptop, 16GB RAM', 800.00, 1200.00, 10, 1, 1),
('Wireless Mouse', 'MSE-200', 'Ergonomic wireless mouse', 5.00, 15.00, 150, 2, 1);

-- Create an example order with items
INSERT INTO orders (customer_id, status, total_amount)
VALUES (1, 'Processing', 1215.00);

INSERT INTO order_items (order_id, product_id, quantity, price_each)
VALUES (1, 1, 1, 1200.00), (1, 2, 1, 15.00);

-- Update order total based on items (simple demonstration)
UPDATE orders o
SET o.total_amount = (
    SELECT COALESCE(SUM(oi.quantity * oi.price_each),0)
    FROM order_items oi
    WHERE oi.order_id = o.order_id
)
WHERE o.order_id = 1;

-- End of script
