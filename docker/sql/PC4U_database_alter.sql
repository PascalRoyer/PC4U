/* remplacer des nulls encombrants dans certaines tables */
UPDATE Monitor_Specs
SET screen_size =
	CASE
		WHEN resolution LIKE '1360x768' THEN 13
		WHEN resolution LIKE '1366x768' THEN 13
		WHEN resolution LIKE '1440x900' THEN 14
		WHEN resolution LIKE '1600x900' THEN 19
		WHEN resolution LIKE '1920x1080' THEN 22
		WHEN resolution LIKE '1920x1200' THEN 24
		WHEN resolution LIKE '2560x1080' THEN 29
		WHEN resolution LIKE '2560x1440' THEN 27
		WHEN resolution LIKE '2560x1600' THEN 28
		WHEN resolution LIKE '2560x2880' THEN 27
		WHEN resolution LIKE '3440x1440' THEN 34
		WHEN resolution LIKE '3840x1600' THEN 38
		WHEN resolution LIKE '3840x2160' THEN 27
		WHEN resolution LIKE '3840x2560' THEN 32
		WHEN resolution LIKE '5120x1440' THEN 49
		WHEN resolution LIKE '5120x2160' THEN 34
		WHEN resolution LIKE '7680x4320' THEN 32
		ELSE screen_size
	END
WHERE screen_size IS NULL;

UPDATE Monitor_Specs
SET refresh_rate = 60
WHERE refresh_rate = 0;


UPDATE Monitor_Specs
SET response_time =
    CASE
		WHEN panel_type = 'IPS' AND refresh_rate <= 75 THEN 5.00
        WHEN panel_type = 'IPS' AND refresh_rate BETWEEN 80 AND 170 THEN 4.00
        WHEN panel_type = 'IPS' AND refresh_rate >= 180 THEN 1.00
        WHEN panel_type = 'VA' AND refresh_rate <= 75 THEN 8.00
        WHEN panel_type = 'VA' AND refresh_rate BETWEEN 80 AND 170 THEN 6.00
        WHEN panel_type = 'VA' AND refresh_rate = 180 THEN 4.00
        WHEN panel_type = 'VA' AND refresh_rate >= 240 THEN 3.00
        WHEN panel_type = 'TN' THEN 0.50
        WHEN panel_type LIKE '%Mini%' AND refresh_rate <= 120 THEN 4.00
        WHEN panel_type LIKE '%Mini%' AND refresh_rate > 120 THEN 2.00
        WHEN panel_type LIKE '%OLED%' THEN 0.03
        ELSE 5.00
    END
WHERE response_time IS NULL;

UPDATE Memory_Specs
SET modules =
    CASE
        WHEN modules = '8,4'   THEN '8x4'
        WHEN modules = '8,24'  THEN '8x24'
        WHEN modules = '8,8'   THEN '8x8'
        WHEN modules = '4,24'  THEN '4x24'
        WHEN modules = '2,1'   THEN '2x1'
        WHEN modules = '4,8'   THEN '4x8'
        WHEN modules = '2,8'   THEN '2x8'
        WHEN modules = '3,2'   THEN '3x2'
        WHEN modules = '1,4'   THEN '1x4'
        WHEN modules = '4,64'  THEN '4x64'
        WHEN modules = '1,2'   THEN '1x2'
        WHEN modules = '1,32'  THEN '1x32'
        WHEN modules = '4,32'  THEN '4x32'
        WHEN modules = '2,48'  THEN '2x48'
        WHEN modules = '1,8'   THEN '1x8'

        WHEN modules = '4,4'   THEN '4x4'
        WHEN modules = '2,16'  THEN '2x16'
        WHEN modules = '2,64'  THEN '2x64'
        WHEN modules = '4,2'   THEN '4x2'
        WHEN modules = '8,48'  THEN '8x48'
        WHEN modules = '2,32'  THEN '2x32'
        WHEN modules = '8,64'  THEN '8x64'
        WHEN modules = '1,64'  THEN '1x64'
        WHEN modules = '4,48'  THEN '4x48'
        WHEN modules = '1,16'  THEN '1x16'
        WHEN modules = '8,32'  THEN '8x32'
        WHEN modules = '3,4'   THEN '3x4'
        WHEN modules = '8,16'  THEN '8x16'
        WHEN modules = '1,48'  THEN '1x48'
        WHEN modules = '3,8'   THEN '3x8'
        WHEN modules = '3,1'   THEN '3x1'
        WHEN modules = '2,4'   THEN '2x4'
        WHEN modules = '2,2'   THEN '2x2'
        WHEN modules = '3,16'  THEN '3x16'
        WHEN modules = '2,24'  THEN '2x24'
        WHEN modules = '4,16'  THEN '4x16'
        WHEN modules = '1,1'   THEN '1x1'
        WHEN modules = '1,24'  THEN '1x24'

        ELSE modules
    END;

UPDATE Memory_Specs
SET first_word_latency = 10
WHERE first_word_latency IS NULL;

UPDATE Hard_Drive_Specs
SET interface = 'USB Type-A 3.2 Gen 1'
WHERE interface IS NULL
   OR LTRIM(RTRIM(interface)) = '';

UPDATE Power_supply_Specs
SET efficiency =
    CASE
        WHEN type = 'ATX' AND modular = 'Full' AND wattage >= 1200 THEN 'Platinum'
        WHEN type = 'ATX' AND modular = 'Full' AND wattage >= 850 THEN 'Gold'
        WHEN type = 'ATX' AND modular = 'Full' THEN 'Gold'

        WHEN type = 'ATX' AND modular = 'Semi' THEN 'Bronze'
        WHEN type = 'ATX' AND modular = 'FALSE' THEN 'Bronze'

        WHEN type IN ('SFX', 'TFX') THEN 'Bronze'

        ELSE 'Bronze'   -- fallback safe
    END
WHERE LTRIM(RTRIM(efficiency)) = '';

UPDATE Case_Specs
SET side_panel = 'SECC'
WHERE side_panel = ''

ALTER TABLE Case_Specs
ALTER column external_volume DECIMAL(5,2)

UPDATE Case_Specs
SET external_volume = (470*206*482)/1000000
WHERE product_id = 6681

UPDATE Case_Specs
SET external_volume = (620*235*595)/1000000
WHERE product_id = 6692

UPDATE Case_Specs
SET external_volume = (469*285*400)/1000000
WHERE product_id = 6697

UPDATE Case_Specs
SET external_volume = (467*220*486)/1000000
WHERE product_id = 6712

UPDATE Case_Specs
SET external_volume = (351*200*390)/1000000
WHERE product_id = 6721

UPDATE Case_Specs
SET external_volume = (477*220*486)/1000000
WHERE product_id = 6723

UPDATE Case_Specs
SET external_volume = (405*205*400)/1000000
WHERE product_id = 6732

UPDATE Case_Specs
SET external_volume = (412*185*440)/1000000
WHERE product_id = 6733

UPDATE Case_Specs
SET external_volume = 39.64
WHERE product_id = 6734

UPDATE Case_Specs
SET external_volume = 58.05
WHERE product_id = 6737

UPDATE Case_Specs
SET external_volume = (520*205*500)/1000000
WHERE product_id = 6773

UPDATE Case_Specs
SET external_volume = (350*350*350)/1000000
WHERE product_id = 6774

UPDATE Case_Specs
SET external_volume = (558*490*490)/3000000
WHERE product_id = 6781

UPDATE Case_Specs
SET external_volume = (435*368*368)/3000000
WHERE product_id = 6782

UPDATE Case_Specs
SET external_volume = (610*481*529)/1000000
WHERE product_id = 6783

UPDATE Case_Specs
SET external_volume = (553*245*484)/1000000
WHERE product_id = 6818

UPDATE Case_Specs
SET external_volume = (40.5*20.5*49.2)/1000
WHERE product_id = 6825

UPDATE Case_Specs
SET external_volume = (650*306*651)/1000000
WHERE product_id = 6843

UPDATE Case_Specs
SET external_volume = (516*224*510)/1000000
WHERE product_id = 6851

UPDATE Case_Specs
SET external_volume = (516*224*510)/1000000
WHERE product_id = 6852

UPDATE Case_Specs
SET external_volume = (556*279*540)/1000000
WHERE product_id = 6854

UPDATE Case_Specs
SET external_volume = 40.3
WHERE product_id = 6857

UPDATE Case_Specs
SET external_volume = (435.5*217.5*410)/1000000
WHERE product_id = 6858

UPDATE Case_Specs
SET external_volume = (496*217*469)/1000000
WHERE product_id = 6861

UPDATE Case_Specs
SET external_volume = (278*216*294)/1000000
WHERE product_id = 6872

UPDATE Case_Specs
SET external_volume = (525*228*502)/1000000
WHERE product_id = 6873

UPDATE Case_Specs
SET external_volume = (702*306*410)/1000000
WHERE product_id = 6878

UPDATE Case_Specs
SET external_volume = 33.9
WHERE product_id = 6887

UPDATE Case_Specs
SET external_volume = 38.24
WHERE product_id = 6889

UPDATE Case_Specs
SET external_volume = 38.24
WHERE product_id = 6890

UPDATE Case_Specs
SET external_volume = (307*698*698)/1000000
WHERE product_id = 6919

UPDATE Case_Specs
SET external_volume = (398*276*351)/1000000
WHERE product_id = 6920

UPDATE Case_Specs
SET external_volume = (210*495*463)/1000000
WHERE product_id = 6949

UPDATE Case_Specs
SET external_volume = (43*20.5*47)/1000
WHERE product_id = 6962

UPDATE Case_Specs
SET external_volume = (420*212*403)/1000000
WHERE product_id = 6964

UPDATE Case_Specs
SET external_volume = (420*212*403)/1000000
WHERE product_id = 6965

UPDATE Case_Specs
SET external_volume = (393*230*460)/1000000
WHERE product_id = 7051

UPDATE Case_Specs
SET external_volume = (397*210*425)/1000000
WHERE product_id = 7056

UPDATE Case_Specs
SET external_volume = (363*210*447)/1000000
WHERE product_id = 7062

UPDATE Case_Specs
SET external_volume = (490*192*490)/1000000
WHERE product_id = 7118

UPDATE Case_Specs
SET external_volume = (35.8*20.3*41.9)/1000
WHERE product_id = 7126

UPDATE Case_Specs
SET external_volume = 13.28
WHERE product_id = 7129

UPDATE Case_Specs
SET external_volume = (575.5*558.5*234)/1000000
WHERE product_id = 7191

UPDATE Case_Specs
SET external_volume = (575.5*558.5*234)/1000000
WHERE product_id = 7192

UPDATE Case_Specs
SET external_volume = (678.5*279*674)/1000000
WHERE product_id = 7196

UPDATE Case_Specs
SET external_volume = (370*210*480)/1000000
WHERE product_id = 7229

UPDATE Case_Specs
SET external_volume = (370*210*480)/1000000
WHERE product_id = 7230

UPDATE Case_Specs
SET external_volume = (421*210*499)/1000000
WHERE product_id = 7237

UPDATE Case_Specs
SET external_volume = (430*215*450)/1000000
WHERE product_id = 7250

UPDATE Case_Specs
SET external_volume = (430*215*450)/1000000
WHERE product_id = 7251