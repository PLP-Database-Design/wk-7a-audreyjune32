-- Question 1: Achieving 1NF
-- Original table has multiple products in one column, violating 1NF.
-- The goal is to split each product into its own row.

-- Assuming the original table is called ProductDetail with columns OrderID, CustomerName, Products (comma-separated).

-- You can create a new normalized table called ProductDetail_1NF with one product per row:

-- Create normalized table
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100)
);

-- Insert data by splitting the Products column (example uses MySQL JSON functions for splitting; 
-- if not supported, this can be done in application code or with stored procedures)

-- Since MySQL lacks a built-in split function, here’s an example using multiple UNION ALLs for this small dataset:

INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product) VALUES
(101, 'John Doe', 'Laptop'),
(101, 'John Doe', 'Mouse'),
(102, 'Jane Smith', 'Tablet'),
(102, 'Jane Smith', 'Keyboard'),
(102, 'Jane Smith', 'Mouse'),
(103, 'Emily Clark', 'Phone');

-- Now each row contains a single product, satisfying 1NF.

----------------------------------------------------------

-- Question 2: Achieving 2NF
-- The original table OrderDetails has partial dependency: CustomerName depends only on OrderID, not on full composite key (OrderID, Product).
-- To remove partial dependency, separate Customer information into a separate Orders table.

-- Step 1: Create Orders table (OrderID, CustomerName)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Step 2: Create OrderDetails table (OrderID, Product, Quantity)
CREATE TABLE OrderDetails_2NF (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product)
);

-- Step 3: Insert data into Orders (unique OrderID and CustomerName)
INSERT INTO Orders (OrderID, CustomerName) VALUES
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Emily Clark');

-- Step 4: Insert data into OrderDetails_2NF with only attributes fully dependent on whole key
INSERT INTO OrderDetails_2NF (OrderID, Product, Quantity) VALUES
(101, 'Laptop', 2),
(101, 'Mouse', 1),
(102, 'Tablet', 3),
(102, 'Keyboard', 1),
(102, 'Mouse', 2),
(103, 'Phone', 1);

-- Now CustomerName is stored only once per OrderID, and OrderDetails only contains info fully dependent on (OrderID, Product),
-- thus satisfying 2NF.
