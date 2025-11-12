USE PC4U; /* Créer une base de données nommée PC4U au préalable */
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
	product_id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
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
	product_id BIGINT NOT NULL,
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
	product_id BIGINT NOT NULL,
	product_quantity INT NOT NULL CHECK (product_quantity >= 0),
	price_at_purchase DECIMAL(10,2) NOT NULL CHECK (price_at_purchase >= 0),
	line_total AS (product_quantity*price_at_purchase),
	FOREIGN KEY (transaction_id) REFERENCES Transactions(transaction_id),
	FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
CREATE TABLE dbo.Staging_CPU (
  name NVARCHAR(300) NOT NULL,
  price NVARCHAR(100) NOT NULL,
  core_count NVARCHAR(50) NOT NULL,
  core_clock NVARCHAR(50) NOT NULL,
  boost_clock NVARCHAR(50) NOT NULL,
  microarchitecture NVARCHAR(200) NOT NULL,
  tdp NVARCHAR(50) NOT NULL,
  graphics NVARCHAR(200) NOT NULL
);

CREATE TABLE CPU_Specs (
  product_id BIGINT NOT NULL PRIMARY KEY,
  core_count INT NOT NULL,
  core_clock_ghz DECIMAL(6,3) NOT NULL,
  boost_clock_ghz DECIMAL(6,3) NOT NULL,
  microarchitecture NVARCHAR(200) NOT NULL,
  tdp_watts INT NOT NULL,
  graphics NVARCHAR(200) NOT NULL
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE dbo.Staging_GPU (
  name NVARCHAR(MAX) NOT NULL,
  price NVARCHAR(100) NOT NULL,
  chipset NVARCHAR(100) NOT NULL,
  memory NVARCHAR(50) NOT NULL,
  core_clock NVARCHAR(50) NOT NULL,
  boost_clock NVARCHAR(50) NOT NULL,
  color NVARCHAR(200) NOT NULL,
  length NVARCHAR(50) NOT NULL
);

CREATE TABLE GPU_Specs (
  product_id BIGINT NOT NULL PRIMARY KEY,
  chipset NVARCHAR(100) NOT NULL,
  memory NVARCHAR(50) NOT NULL,
  core_clock INT NOT NULL,
  boost_clock INT NOT NULL,
  color NVARCHAR(50) NOT NULL,
  length INT NOT NULL
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE dbo.Staging_Monitors (
  name NVARCHAR(MAX) NOT NULL,
  price NVARCHAR(100) NOT NULL,
  screen_size NVARCHAR(100) NOT NULL,
  resolution NVARCHAR(400) NOT NULL,
  refresh_rate NVARCHAR(50) NOT NULL,
  response_time NVARCHAR(50) NOT NULL,
  panel_type NVARCHAR(200) NOT NULL,
  aspect_ratio NVARCHAR(50) NOT NULL
);

CREATE TABLE Monitor_Specs (
  product_id BIGINT NOT NULL PRIMARY KEY,
  screen_size INT NOT NULL,
  resolution NVARCHAR(50) NOT NULL,
  refresh_rate NVARCHAR(50) NOT NULL,
  response_time INT NOT NULL,
  panel_type NVARCHAR(50) NOT NULL,
  aspect_ratio INT NOT NULL
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE dbo.Staging_Memory (
  name NVARCHAR(MAX) NOT NULL,
  price NVARCHAR(100) NOT NULL,
  speed NVARCHAR(100) NOT NULL,
  modules NVARCHAR(50) NOT NULL,
  price_per_gb NVARCHAR(50) NOT NULL,
  color NVARCHAR(50) NOT NULL,
  first_word_latency NVARCHAR(200) NOT NULL,
  cas_latency NVARCHAR(50) NOT NULL
);

CREATE TABLE Memory_Specs (
  product_id BIGINT NOT NULL PRIMARY KEY,
  speed INT NOT NULL,
  modules NVARCHAR(50) NOT NULL,
  price_per_gb DECIMAL(10,2) NOT NULL,
  color NVARCHAR(50) NOT NULL,
  first_word_latency INT NOT NULL,
  cas_latency INT NOT NULL
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE dbo.Staging_Hard_Drive (
  name NVARCHAR(MAX) NOT NULL,
  price NVARCHAR(100) NULL,
  type NVARCHAR(100) NULL,
  interface NVARCHAR(MAX) NULL,
  capacity NVARCHAR(50) NULL,
  price_per_gb NVARCHAR(50) NULL,
  color NVARCHAR(200) NULL
);

CREATE TABLE Hard_Drive_Specs (
  product_id BIGINT NOT NULL PRIMARY KEY,
  type NVARCHAR(50) NOT NULL,
  interface NVARCHAR(100) NOT NULL,
  capacity INT NOT NULL,
  price_per_gb DECIMAL(10,2) NOT NULL,
  color NVARCHAR(50) NOT NULL
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE dbo.Staging_Power_Supply (
  name NVARCHAR(MAX) NOT NULL,
  price NVARCHAR(100) NULL,
  type NVARCHAR(100) NULL,
  efficiency NVARCHAR(50) NULL,
  wattage NVARCHAR(50) NULL,
  modular NVARCHAR(50) NULL,
  color NVARCHAR(200) NULL
);

CREATE TABLE Power_supply_Specs (
  product_id BIGINT NOT NULL PRIMARY KEY,
  type NVARCHAR(50) NOT NULL,
  efficiency NVARCHAR(50) NOT NULL,
  wattage INT NOT NULL,
  modular NVARCHAR(50) NOT NULL,
  color NVARCHAR(50) NOT NULL
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE dbo.Staging_Cases (
  name NVARCHAR(MAX) NOT NULL,
  price NVARCHAR(100) NULL,
  type NVARCHAR(100) NULL,
  color NVARCHAR(200) NULL,
  side_panel NVARCHAR(50) NULL,
  external_volume NVARCHAR(50) NULL,
  internal_35_bays NVARCHAR(50) NULL
);

CREATE TABLE Case_Specs (
  product_id BIGINT NOT NULL PRIMARY KEY,
  type NVARCHAR(50) NOT NULL,
  color NVARCHAR(50) NOT NULL,
  side_panel NVARCHAR(100) NOT NULL,
  external_volume DECIMAL(4,2) NOT NULL,
  internal_35_bays INT NOT NULL
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE dbo.Staging_Motherboards (
  name NVARCHAR(MAX) NOT NULL,
  price NVARCHAR(100) NULL,
  socket NVARCHAR(50) NULL,
  form_factor NVARCHAR(50) NULL,
  max_memory NVARCHAR(50) NULL,
  memory_slots NVARCHAR(50) NULL,
  color NVARCHAR(50) NULL
);

CREATE TABLE Motherboard_Specs (
  product_id BIGINT NOT NULL PRIMARY KEY,
  socket NVARCHAR(50) NOT NULL,
  form_factor NVARCHAR(50) NOT NULL,
  max_memory INT NOT NULL,
  memory_slots INT NOT NULL,
  color NVARCHAR(50) NOT NULL
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

