USE PC4U;
/* Exécuter après PC4U_init_database. Chacun des blocs de codes suivant peuvent être utilisés individuellement ou en groupe,
	dépendamment de la situation. */

/* Insertion des types d'utilisateurs 
INSERT INTO UserTypes(user_type_id, type_names) VALUES
(1, 'superadmin'),
(2, 'admin'),
(3, 'customer');

/* Insertion d'utilisateurs dans la base de données. L'id est incrémenté automatiquement avec IDENTITY. 
register_date est entré automatiquement avec le CURRENT_TIMESTAMP */
INSERT INTO Users(user_pseudo, email, user_password, user_type_id) VALUES
('pseudo', 'n123@email.com', 'hashedpassword', 3);*/


/* Insertion de catégories. On peut réviser ensemble les catégories*/
INSERT INTO Categories(category_id, category_name) VALUES
(1, 'CPU'),
(2, 'GPU'),
(3, 'Monitors'),
(4, 'Memory_RAM'),
(5, 'Storage'),
(6, 'Power_supply'),
(7, 'Cases'),
(8, 'Motherboards');

-- Lecture des id de catégories depuis la table Catégories
DECLARE @CPU_CATEGORY_ID			INT = (SELECT category_id FROM Categories WHERE category_name = N'CPU');
DECLARE @GPU_CATEGORY_ID			INT = (SELECT category_id FROM Categories WHERE category_name = N'GPU');
DECLARE @MONITORS_CATEGORY_ID		INT = (SELECT category_id FROM Categories WHERE category_name = N'Monitors');
DECLARE @MEMORY_RAM_CATEGORY_ID		INT = (SELECT category_id FROM Categories WHERE category_name = N'Memory_RAM');
DECLARE @STORAGE_CATEGORY_ID		INT = (SELECT category_id FROM Categories WHERE category_name = N'Storage');
DECLARE @POWER_SUPPLY_CATEGORY_ID	INT = (SELECT category_id FROM Categories WHERE category_name = N'Power_supply');
DECLARE @CASES_CATEGORY_ID			INT = (SELECT category_id FROM Categories WHERE category_name = N'Cases');
DECLARE @MOTHERBOARDS_CATEGORY_ID	INT = (SELECT category_id FROM Categories WHERE category_name = N'Motherboards');

/* Insertion de produits.Le prix et le stock doivent être égaux ou supérieurs à 0, sinon erreur. 
	Valeurs à modifier évidemment.*/
--Script pour insertion des CPUs dans Produits à partir de la table de staging
INSERT INTO Products (product_name, category_id, product_price, stock, image_url)
SELECT DISTINCT -- pour s'assurer d'avoir des produits uniques
	s.name AS product_name,
	@CPU_CATEGORY_ID AS category_id,
	TRY_CONVERT(DECIMAL(10,2),(s.price)) AS product_price,
	100 AS stock,
	NULL AS image_url
FROM Staging_CPU s
WHERE
	s.name IS NOT NULL AND TRY_CONVERT(DECIMAL(10,2),(s.price)) IS NOT NULL
	AND NOT EXISTS (
		SELECT 1 FROM Products p
		WHERE p.product_name = s.name
		AND p.category_id = @CPU_CATEGORY_ID
);

--Script pour insertion des GPUs dans Produits à partir de la table de staging
INSERT INTO Products (product_name, category_id, product_price, stock, image_url)
SELECT DISTINCT -- pour s'assurer d'avoir des produits uniques
	LTRIM(RTRIM(s.name + ' ' + s.chipset)) AS product_name,
	@GPU_CATEGORY_ID AS category_id,
	TRY_CONVERT(DECIMAL(10,2),(s.price)) AS product_price,
	100 AS stock,
	NULL AS image_url
FROM Staging_GPU s
WHERE
	s.name IS NOT NULL AND TRY_CONVERT(DECIMAL(10,2),(s.price)) IS NOT NULL
	AND NOT EXISTS (
		SELECT 1 FROM Products p
		WHERE p.product_name = LTRIM(RTRIM(s.name + ' ' + s.chipset))
		AND p.category_id = @GPU_CATEGORY_ID
);

--Script pour insertion des moniteurs
INSERT INTO Products (product_name, category_id, product_price, stock, image_url)
SELECT DISTINCT -- pour s'assurer d'avoir des produits uniques
	s.name AS product_name,
	@MONITORS_CATEGORY_ID AS category_id,
	TRY_CONVERT(DECIMAL(10,2),(s.price)) AS product_price,
	100 AS stock,
	NULL AS image_url
FROM Staging_Monitors s
WHERE
	s.name IS NOT NULL AND TRY_CONVERT(DECIMAL(10,2),(s.price)) IS NOT NULL
	AND NOT EXISTS (
		SELECT 1 FROM Products p
		WHERE p.product_name = s.name
		AND p.category_id = @MONITORS_CATEGORY_ID
);

--Script pour insertion des mémoires
INSERT INTO Products (product_name, category_id, product_price, stock, image_url)
SELECT DISTINCT -- pour s'assurer d'avoir des produits uniques
	s.name AS product_name,
	@MEMORY_RAM_CATEGORY_ID AS category_id,
	TRY_CONVERT(DECIMAL(10,2),(s.price)) AS product_price,
	100 AS stock,
	NULL AS image_url
FROM Staging_Memory s
WHERE
	s.name IS NOT NULL AND TRY_CONVERT(DECIMAL(10,2),(s.price)) IS NOT NULL
	AND NOT EXISTS (
		SELECT 1 FROM Products p
		WHERE p.product_name = s.name
		AND p.category_id = @MEMORY_RAM_CATEGORY_ID
);

--Script pour insertion des disques durs
INSERT INTO Products (product_name, category_id, product_price, stock, image_url)
SELECT DISTINCT -- pour s'assurer d'avoir des produits uniques
	s.name AS product_name,
	@STORAGE_CATEGORY_ID AS category_id,
	TRY_CONVERT(DECIMAL(10,2),(s.price)) AS product_price,
	100 AS stock,
	NULL AS image_url
FROM Staging_Hard_Drive s
WHERE
	s.name IS NOT NULL AND TRY_CONVERT(DECIMAL(10,2),(s.price)) IS NOT NULL
	AND NOT EXISTS (
		SELECT 1 FROM Products p
		WHERE p.product_name = s.name
		AND p.category_id = @STORAGE_CATEGORY_ID
);

--Script pour insertion des alimentations
INSERT INTO Products (product_name, category_id, product_price, stock, image_url)
SELECT DISTINCT -- pour s'assurer d'avoir des produits uniques
	s.name AS product_name,
	@POWER_SUPPLY_CATEGORY_ID AS category_id,
	TRY_CONVERT(DECIMAL(10,2),(s.price)) AS product_price,
	100 AS stock,
	NULL AS image_url
FROM Staging_Power_Supply s
WHERE
	s.name IS NOT NULL AND TRY_CONVERT(DECIMAL(10,2),(s.price)) IS NOT NULL
	AND NOT EXISTS (
		SELECT 1 FROM Products p
		WHERE p.product_name = s.name
		AND p.category_id = @POWER_SUPPLY_CATEGORY_ID
);

--Script pour insertion des caissiers
INSERT INTO Products (product_name, category_id, product_price, stock, image_url)
SELECT DISTINCT -- pour s'assurer d'avoir des produits uniques
	s.name AS product_name,
	@CASES_CATEGORY_ID AS category_id,
	TRY_CONVERT(DECIMAL(10,2),(s.price)) AS product_price,
	100 AS stock,
	NULL AS image_url
FROM Staging_Cases s
WHERE
	s.name IS NOT NULL AND TRY_CONVERT(DECIMAL(10,2),(s.price)) IS NOT NULL
	AND NOT EXISTS (
		SELECT 1 FROM Products p
		WHERE p.product_name = s.name
		AND p.category_id = @CASES_CATEGORY_ID
);

--Script pour insertion des cartes-mères
INSERT INTO Products (product_name, category_id, product_price, stock, image_url)
SELECT DISTINCT -- pour s'assurer d'avoir des produits uniques
	s.name AS product_name,
	@MOTHERBOARDS_CATEGORY_ID AS category_id,
	TRY_CONVERT(DECIMAL(10,2),(s.price)) AS product_price,
	100 AS stock,
	NULL AS image_url
FROM Staging_Motherboards s
WHERE
	s.name IS NOT NULL AND TRY_CONVERT(DECIMAL(10,2),(s.price)) IS NOT NULL
	AND NOT EXISTS (
		SELECT 1 FROM Products p
		WHERE p.product_name = s.name
		AND p.category_id = @MOTHERBOARDS_CATEGORY_ID
);

--Cette table sert à garder les propriétés des CPU à part grâce à une jointure de staging_cpu et products
INSERT INTO CPU_Specs(product_id, core_count, core_clock_ghz, boost_clock_ghz, microarchitecture, tdp_watts, graphics)
SELECT DISTINCT 
	p.product_id AS product_id,
	TRY_CONVERT(INT, s.core_count) AS core_count,
	TRY_CONVERT(DECIMAL(6,3), s.core_clock) AS core_clock_ghz,
	TRY_CONVERT(DECIMAL(6,3), s.boost_clock) AS boost_clock_ghz,
	s.microarchitecture AS microarchitecture,
	TRY_CONVERT(INT, s.tdp) AS tdp_watts,
	s.graphics AS graphics
FROM Staging_CPU s
JOIN Products p
	ON p.product_name = s.name
	AND p.category_id = @CPU_CATEGORY_ID
WHERE NOT EXISTS (
	SELECT 1 FROM CPU_Specs cs WHERE cs.product_id = p.product_id
);

--Même principe pour les GPUs
;WITH GPUSource AS (
    SELECT
        p.product_id,
        TRY_CONVERT(INT, s.memory)      AS memory,
        TRY_CONVERT(INT, s.core_clock)  AS core_clock,
        TRY_CONVERT(INT, s.boost_clock) AS boost_clock,
        NULLIF(LTRIM(RTRIM(s.color)), '') AS color,
        TRY_CONVERT(INT, s.length)      AS length,
        ROW_NUMBER() OVER (
            PARTITION BY p.product_id
            ORDER BY p.product_id
        ) AS rn
    FROM Staging_GPU s
    JOIN Products p
        ON p.category_id = @GPU_CATEGORY_ID
       AND (
            -- cas 1 : Products contient seulement le name
            p.product_name = LTRIM(RTRIM(s.name))
            -- cas 2 : Products contient name + chipset (ex : "Sapphire PULSE Radeon RX 9060 XT")
         OR p.product_name = LTRIM(RTRIM(s.name + ' ' + s.chipset))
       )
)
INSERT INTO GPU_Specs(product_id, memory, core_clock, boost_clock, color, length)
SELECT
    product_id,
    memory,
    core_clock,
    boost_clock,
    color,
    length
FROM GPUSource
WHERE rn = 1;  -- une seule ligne par product_id


--Moniteurs
WITH MonitorSource AS (
	SELECT 
		p.product_id AS product_id,
		TRY_CONVERT(INT, s.screen_size) AS screen_size,
		s.resolution AS resolution,
		TRY_CONVERT(INT, s.refresh_rate) AS refresh_rate,
		TRY_CONVERT(DECIMAL(5,2), s.response_time) AS response_time,
		s.panel_type AS panel_type,
		NULLIF(LTRIM(RTRIM(s.aspect_ratio)), '') AS aspect_ratio,
		ROW_NUMBER() OVER (
            PARTITION BY p.product_id
            ORDER BY p.product_id
        ) AS rn
FROM Staging_Monitors s
JOIN Products p
	ON p.product_name = s.name
	AND p.category_id = @MONITORS_CATEGORY_ID
)
INSERT INTO Monitor_Specs(product_id, screen_size, resolution, refresh_rate, response_time, panel_type, aspect_ratio)
	SELECT
    product_id,
    screen_size,
    resolution,
    refresh_rate,
    response_time,
    panel_type,
    aspect_ratio
FROM MonitorSource
WHERE rn = 1; --pour obtenir une seule ligne par product_id


--Mémoires
WITH MemorySource AS (
	SELECT
		p.product_id,
		TRY_CONVERT(INT, REPLACE(s.speed, ',', '')) AS speed,
        s.modules                                    AS modules,
        TRY_CONVERT(DECIMAL(10,2), s.price_per_gb)  AS price_per_gb,
        NULLIF(LTRIM(RTRIM(s.color)), '')           AS color,
        TRY_CONVERT(INT, s.first_word_latency)      AS first_word_latency,
        TRY_CONVERT(INT, s.cas_latency)             AS cas_latency,
        ROW_NUMBER() OVER (
            PARTITION BY p.product_id
            ORDER BY p.product_id
        ) AS rn
	FROM Staging_Memory s
	JOIN Products p
		ON p.product_name = s.name
		AND p.category_id = @MEMORY_RAM_CATEGORY_ID
)
INSERT INTO Memory_Specs(product_id, speed, modules, price_per_gb, color, first_word_latency, cas_latency)
	SELECT
		product_id, 
		speed, 
		modules, 
		price_per_gb, 
		color, 
		first_word_latency, 
		cas_latency
FROM MemorySource
WHERE rn = 1;

--Disques durs
WITH HardDriveSource AS (
	SELECT
		p.product_id,
        s.type AS type,
        s.interface AS interface,
        TRY_CONVERT(INT, s.capacity) AS capacity,
        TRY_CONVERT(DECIMAL(10,2), s.price_per_gb) AS price_per_gb,
        NULLIF(LTRIM(RTRIM(s.color)), '') AS color,
		ROW_NUMBER() OVER (
			PARTITION BY  p.product_id
			ORDER BY p.product_id
		) as rn
FROM Staging_Hard_Drive s
JOIN Products p
	ON p.product_name = s.name
	AND p.category_id = @STORAGE_CATEGORY_ID
	)
INSERT INTO Hard_Drive_Specs(product_id, type, interface, capacity, price_per_gb, color)
SELECT
    product_id, type, interface, capacity, price_per_gb, color
FROM HardDriveSource
WHERE rn = 1;

--Power supply
WITH PowerSource AS (
	SELECT
		p.product_id,
        s.type AS type,
        s.efficiency AS efficiency,
        TRY_CONVERT(INT, s.wattage) AS wattage,
        s.modular AS modular,
        NULLIF(LTRIM(RTRIM(s.color)), '') AS color,
		ROW_NUMBER() OVER (
            PARTITION BY p.product_id
            ORDER BY p.product_id
        ) AS rn
FROM Staging_Power_Supply s
JOIN Products p
	ON p.product_name = s.name
	AND p.category_id = @POWER_SUPPLY_CATEGORY_ID
)
INSERT INTO Power_supply_Specs(product_id, type, efficiency, wattage, modular, color)
SELECT
    product_id, type, efficiency, wattage, modular, color
FROM PowerSource
WHERE rn = 1;

--Boîtiers
WITH CaseSource AS (
    SELECT
        p.product_id,
        s.type AS type,
        NULLIF(LTRIM(RTRIM(s.color)), '') AS color,
        s.side_panel AS side_panel,
        TRY_CONVERT(DECIMAL(4,2), s.external_volume) AS external_volume,
        TRY_CONVERT(INT, s.internal_35_bays) AS internal_35_bays,
        ROW_NUMBER() OVER (
            PARTITION BY p.product_id
            ORDER BY p.product_id
        ) AS rn
    FROM Staging_Cases s
    JOIN Products p
        ON p.product_name = s.name
       AND p.category_id  = @CASES_CATEGORY_ID
)
INSERT INTO Case_Specs(product_id, type, color, side_panel, external_volume, internal_35_bays)
SELECT
    product_id, type, color, side_panel, external_volume, internal_35_bays
FROM CaseSource
WHERE rn = 1;


--Cartes-mères
;WITH MoboSource AS (
    SELECT
        p.product_id,
        s.socket                     AS socket,
        s.form_factor                AS form_factor,
        TRY_CONVERT(INT, s.max_memory)    AS max_memory,
        TRY_CONVERT(INT, s.memory_slots)  AS memory_slots,
        NULLIF(LTRIM(RTRIM(s.color)), '') AS color,
        ROW_NUMBER() OVER (
            PARTITION BY p.product_id
            ORDER BY p.product_id
        ) AS rn
    FROM Staging_Motherboards s
    JOIN Products p
        ON p.product_name = s.name
       AND p.category_id  = @MOTHERBOARDS_CATEGORY_ID
)
INSERT INTO Motherboard_Specs(product_id, socket, form_factor, max_memory, memory_slots, color)
SELECT
    product_id, socket, form_factor, max_memory, memory_slots, color
FROM MoboSource
WHERE rn = 1;


/* Insertion dans le panier 
INSERT INTO Cart(cart_id, user_id_number, product_id, quantity) VALUES
(1, 3, 1234, 2),
(1, 3, 1235, 1);*/

/* Insertion dans la table des transactions. total_items est la somme des quantités et total_cost est la somme de line total.
 Note: Les inserts into pour Transactions et Transactions_details resteront vide jusqu'à ce que le code pour le backend soit amorcé. Il est plus
 pertinent que ce soit le backend qui gère ces deux tables là. 
INSERT INTO Transactions(transaction_date, total_items, total_cost, user_id_number) VALUES */