-- Roberto Herrera
-- CS3380
-- Project Phase 3

USE project;

-- Populating Tables Using Synthetic Data

-- Populating Farmer Table
INSERT INTO FARMER (Company_name, Email) VALUES ('Green Acres', 'contact@greenacres.com');
INSERT INTO FARMER (Company_name, Email) VALUES ('Sunny Farm', 'info@sunnyfarm.com');
INSERT INTO FARMER (Company_name, Email) VALUES ('Harvest Fields', 'support@harvestfields.com');

-- Populating Farmer_Phone Table
INSERT INTO FARMER_PHONE (FarmerID, Phone) VALUES (1, '5551234567');
INSERT INTO FARMER_PHONE (FarmerID, Phone) VALUES (2, '5552345678');
INSERT INTO FARMER_PHONE (FarmerID, Phone) VALUES (3, '5553456789');

-- Populating Farmer_Address Table
INSERT INTO FARMER_ADDRESS (FarmerID, Address) VALUES (1, '101 Greenway, Farmville');
INSERT INTO FARMER_ADDRESS (FarmerID, Address) VALUES (2, '202 Sunshine Blvd, Agritown');
INSERT INTO FARMER_ADDRESS (FarmerID, Address) VALUES (3, '303 Harvest Lane, Cropsburg');

-- Populating Farm Table
-- Farms owned by Farmer 1
INSERT INTO FARM (Size, Location, FarmerID) VALUES (120, 'North Valley', 1);
INSERT INTO FARM (Size, Location, FarmerID) VALUES (95, 'East Hill', 1);
-- Farm owned by Farmer 2
INSERT INTO FARM (Size, Location, FarmerID) VALUES (150, 'South Ridge', 2);
-- Farm owned by Farmer 3
INSERT INTO FARM (Size, Location, FarmerID) VALUES (180, 'West Plains', 3);

-- Populating Crop Table
-- Crops for Farm 1
INSERT INTO CROP (Health_status, Planting_date, Crop_yield, Crop_name, Locations, Irrigation_Method, Equipment_necessary, FarmID, FarmerID) 
VALUES ('Good', '2023-03-01', 500, 'Wheat', 'Field 1A', 'Drip', 'Tractor', 1, 1);
INSERT INTO CROP (Health_status, Planting_date, Crop_yield, Crop_name, Locations, Irrigation_Method, Equipment_necessary, FarmID, FarmerID) 
VALUES ('Fair', '2023-04-15', 400, 'Corn', 'Field 1B', 'Sprinkler', 'Harvester', 1, 1);
-- Crops for Farm 2
INSERT INTO CROP (Health_status, Planting_date, Crop_yield, Crop_name, Locations, Irrigation_Method, Equipment_necessary, FarmID, FarmerID) 
VALUES ('Excellent', '2023-02-20', 600, 'Tomatoes', 'Field 2A', 'Surface', 'Fertilizer Spreader', 2, 1);
INSERT INTO CROP (Health_status, Planting_date, Crop_yield, Crop_name, Locations, Irrigation_Method, Equipment_necessary, FarmID, FarmerID) 
VALUES ('Good', '2023-05-10', 450, 'Onions', 'Field 2B', 'Subsurface', 'Cultivator', 2, 1);
-- Crops for Farm 3
INSERT INTO CROP (Health_status, Planting_date, Crop_yield, Crop_name, Locations, Irrigation_Method, Equipment_necessary, FarmID, FarmerID) 
VALUES ('Good', '2023-03-05', 550, 'Rice', 'Field 3A', 'Flood', 'Seeder', 3, 2);
INSERT INTO CROP (Health_status, Planting_date, Crop_yield, Crop_name, Locations, Irrigation_Method, Equipment_necessary, FarmID, FarmerID) 
VALUES ('Fair', '2023-06-01', 300, 'Potatoes', 'Field 3B', 'Manual', 'Plow', 3, 2);
-- Crops for Farm 4
INSERT INTO CROP (Health_status, Planting_date, Crop_yield, Crop_name, Locations, Irrigation_Method, Equipment_necessary, FarmID, FarmerID) 
VALUES ('Excellent', '2023-02-25', 650, 'Carrots', 'Field 4A', 'Automated', 'Tractor', 4, 3);
INSERT INTO CROP (Health_status, Planting_date, Crop_yield, Crop_name, Locations, Irrigation_Method, Equipment_necessary, FarmID, FarmerID) 
VALUES ('Good', '2023-05-15', 500, 'Lettuce', 'Field 4B', 'Drip', 'Harvester', 4, 3);


-- Populating Sensor Table 
-- This function populates two sensors of each type (monitoring and weather) to each crop. 16 sensors in total

DROP PROCEDURE IF EXISTS PopulateSensors;
DELIMITER //

CREATE PROCEDURE PopulateSensors()
BEGIN
    DECLARE sensorId INT DEFAULT 1;
    DECLARE maxSensorId INT DEFAULT 8; -- 8 crops, 2 per farm, 4 farms
    DECLARE cropLocation VARCHAR(255);

    WHILE sensorId <= maxSensorId DO
        -- Retrieve the crop name for the current cropId
        SELECT locations INTO cropLocation FROM CROP WHERE CropID = sensorId;

        -- Insert 'Weather' sensor for the crop
        INSERT INTO SENSORS (Sensor_Type, Sensor_Status, Location, Installation_date, Last_Maintenance_Date, CropID) 
        VALUES ('Weather', 'Active', cropLocation, '2023-01-01', '2023-03-01', sensorId);

        -- Insert 'Monitoring' sensor for the crop
        INSERT INTO SENSORS (Sensor_Type, Sensor_Status, Location, Installation_date, Last_Maintenance_Date, CropID) 
        VALUES ('Monitoring', 'Active', cropLocation, '2023-01-01', '2023-03-01', sensorId);

        -- Increment cropId for the next iteration
        SET sensorId = sensorId + 1;
    END WHILE;
END //

DELIMITER ;
CALL PopulateSensors();

-- Populating Crop_monitoring Table
DROP PROCEDURE IF EXISTS PopulateCropMonitoring;
DELIMITER //

CREATE PROCEDURE PopulateCropMonitoring()
BEGIN
    DECLARE sensorId INT DEFAULT 1;
    DECLARE maxSensorId INT DEFAULT 8; -- 8 crops, each with a 'monitoring' sensor
    DECLARE randomWaterQuality, randomSoilMoisture VARCHAR(255);
    DECLARE randomPlagueDetection BOOLEAN;

    WHILE sensorId <= maxSensorId DO
        -- Randomly pick a value for water quality and soil moisture
        SET randomWaterQuality = ELT(FLOOR(RAND() * 5) + 1, 'Excellent', 'Good', 'Fair', 'Poor', 'Critical');
        SET randomSoilMoisture = ELT(FLOOR(RAND() * 3) + 1, 'Dry', 'Optimal', 'Wet');
        SET randomPlagueDetection = FLOOR(RAND() * 2);

        -- Insert data into CROP_MONITORING
        INSERT INTO CROP_MONITORING (SensorID, MonitoringRange, Water_Quality, Soil_Moisture, Plague_Detection)
        VALUES (sensorId, ROUND(RAND() * 15, 2), randomWaterQuality, randomSoilMoisture, randomPlagueDetection);

        -- Increment sensorId for the next iteration
        SET sensorId = sensorId + 1;
    END WHILE;
END //

DELIMITER ;

CALL PopulateCropMonitoring();

-- Populating Weather_sensors Table

DROP PROCEDURE IF EXISTS PopulateWeatherSensors;
DELIMITER //

CREATE PROCEDURE PopulateWeatherSensors()
BEGIN
    DECLARE sensorId INT DEFAULT 1;
    DECLARE maxSensorId INT DEFAULT 8; -- 8 crops, each with a 'Weather' sensor

    WHILE sensorId <= maxSensorId DO
        INSERT INTO WEATHER_SENSORS (SensorID, Wind, Precipitation, Humidity, Temperature)
        VALUES (
            sensorId, 
            ROUND(RAND() * 20, 2),  -- Random Wind speed
            ROUND(RAND() * 100, 2), -- Random Precipitation level
            ROUND(RAND() * 100, 2), -- Random Humidity percentage
            ROUND(RAND() * 35 + 5, 2) -- Random Temperature
        );
        SET sensorId = sensorId + 1;
    END WHILE;
END //

DELIMITER ;

CALL PopulateWeatherSensors();


-- Populating Monitoring Tablecrop

DROP PROCEDURE IF EXISTS PopulateMonitoring;
DELIMITER //

CREATE PROCEDURE PopulateMonitoring()
BEGIN
    DECLARE cropId INT DEFAULT 1;
    DECLARE maxCropId INT DEFAULT 8; -- Assuming 8 crops

    WHILE cropId <= maxCropId DO
        -- Link each crop to its 'Weather' sensor
        INSERT INTO MONITORING (CropID, SensorID) VALUES (cropId, cropId);
        
        -- Increment cropId for the next iteration
        SET cropId = cropId + 1;
    END WHILE;
END //

DELIMITER ;

CALL PopulateMonitoring();


