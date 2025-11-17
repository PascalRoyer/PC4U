USE PC4U; /* Cr�er une base de donn�es nomm�e PC4U au pr�alable */
CREATE TABLE UserTypes (
	user_type_id TINYINT NOT NULL PRIMARY KEY,
	type_names NVARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Users (
	user_id_number BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	user_pseudo NVARCHAR(100) NOT NULL UNIQUE,
	email NVARCHAR(100) NOT NULL UNIQUE,
	user_password NVARCHAR(100) NOT NULL,
	register_date DATETIME2 NOT NULL DEFAULT CURRENT_TIMESTAMP,
	user_type_id TINYINT NOT NULL,
	FOREIGN KEY (user_type_id) REFERENCES UserTypes(user_type_id)
);

CREATE TABLE Categories (
	category_id INT NOT NULL PRIMARY KEY,
	category_name NVARCHAR(50) NOT NULL
);

CREATE TABLE Products (
	product_id INT NOT NULL PRIMARY KEY,
	product_name NVARCHAR(100) NOT NULL,
	category_id INT NOT NULL,
	product_price DECIMAL(10,2) NOT NULL CHECK (product_price >= 0),
	stock INT NOT NULL CHECK (stock >= 0),
	image_url NVARCHAR(100),
	FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE Cart (
	cart_id BIGINT NOT NULL PRIMARY KEY,
	user_id_number BIGINT NOT NULL,
	product_id INT NOT NULL,
	quantity INT NOT NULL CHECK (quantity >= 0),
	FOREIGN KEY (user_id_number) REFERENCES Users(user_id_number),
	FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Transactions (
	transaction_id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	transaction_date DATETIME2(7) NOT NULL,
	total_items INT NOT NULL,
	total_cost DECIMAL(10,2) NOT NULL CHECK (total_cost >= 0),
	user_id_number BIGINT NOT NULL,
	FOREIGN KEY (user_id_number) REFERENCES Users(user_id_number)
);

CREATE TABLE Transaction_Details (
	details_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	transaction_id BIGINT NOT NULL,
	product_id INT NOT NULL,
	product_quantity INT NOT NULL CHECK (product_quantity >= 0),
	price_at_purchase DECIMAL(10,2) NOT NULL CHECK (price_at_purchase >= 0),
	line_total AS (product_quantity*price_at_purchase),
	FOREIGN KEY (transaction_id) REFERENCES Transactions(transaction_id),
	FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
CREATE TABLE Templates (
  template_id INT IDENTITY(1,1) PRIMARY KEY,
  template_name NVARCHAR(100) NOT NULL,
  user_id_number BIGINT NOT NULL,
  total_price DECIMAL(10,2) NOT NULL CHECK (total_price >= 0),
  created_at DATETIME2 DEFAULT GETDATE(),
  FOREIGN KEY (user_id_number) REFERENCES Users(user_id_number)
);

CREATE TABLE TemplateComponents (
  component_id INT IDENTITY(1,1) PRIMARY KEY,
  template_id INT NOT NULL,
  component_name NVARCHAR(100) NOT NULL,
  selected_option NVARCHAR(100),
  price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
  FOREIGN KEY (template_id) REFERENCES Templates(template_id)
);

