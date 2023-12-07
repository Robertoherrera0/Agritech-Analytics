-- Roberto Herrera
-- CS3380
-- Project Phase 3

USE project;

-- Creating Tables 

CREATE TABLE IF NOT EXISTS FARMER (
    FarmerID INT AUTO_INCREMENT,
    Company_name VARCHAR(255),
    Email VARCHAR(255) UNIQUE NOT NULL,
    PRIMARY KEY (FarmerID)
);

CREATE TABLE IF NOT EXISTS FARMER_PHONE (
    FarmerID INT,
    Phone VARCHAR(10) NOT NULL,
    PRIMARY KEY (FarmerID, Phone),
    FOREIGN KEY (FarmerID) REFERENCES FARMER(FarmerID)
);


CREATE TABLE IF NOT EXISTS FARMER_ADDRESS (
    FarmerID INT,
    Address VARCHAR(255) NOT NULL,
    PRIMARY KEY (FarmerID, Address),
    FOREIGN KEY (FarmerID) REFERENCES FARMER(FarmerID)
);


CREATE TABLE IF NOT EXISTS FARM (
    FarmID INT AUTO_INCREMENT,
    Size DECIMAL(10, 2),
    Location VARCHAR(255) NOT NULL,
    FarmerID INT,
    PRIMARY KEY (FarmID),
    FOREIGN KEY (FarmerID) REFERENCES FARMER(FarmerID)
);


CREATE TABLE IF NOT EXISTS CROP (
	CropID INT AUTO_INCREMENT,
	Health_status VARCHAR(50),
    Planting_date DATE,
    Crop_yield DECIMAL(10, 2),
    Crop_name VARCHAR(255),
    Locations VARCHAR(255),
    Irrigation_Method ENUM('Drip', 'Sprinkler', 'Surface', 'Subsurface', 'Flood', 'Manual', 'Automated') NOT NULL,
    Equipment_necessary VARCHAR(255),
    FarmID INT,
    FarmerID INT,
    PRIMARY KEY (CropID),
    FOREIGN KEY (FarmID) REFERENCES FARM(FarmID) ON DELETE CASCADE,
    FOREIGN KEY (FarmerID) REFERENCES FARMER(FarmerID) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS SENSORS (
    SensorID INT AUTO_INCREMENT,
    Sensor_Type ENUM('Weather', 'Monitoring') NOT NULL,
    Sensor_Status ENUM('Active', 'Inactive', 'Under Maintenance', 'Faulty') NOT NULL,
    Location VARCHAR(255),
    Installation_date DATE,
    Last_Maintenance_Date DATE,
    CropID INT,
    PRIMARY KEY (SensorID),
    FOREIGN KEY (CropID) REFERENCES CROP(CropID) ON DELETE SET NULL
);



CREATE TABLE IF NOT EXISTS CROP_MONITORING (
    SensorID INT,
    MonitoringRange DECIMAL(10, 2),
    Water_Quality ENUM('Excellent', 'Good', 'Fair', 'Poor', 'Critical') NOT NULL,
    Soil_Moisture ENUM('Dry', 'Optimal', 'Wet') NOT NULL,
    Plague_Detection BOOLEAN,
    PRIMARY KEY (SensorID),
    FOREIGN KEY (SensorID) REFERENCES SENSORS(SensorID) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS WEATHER_SENSORS (
    SensorID INT,
    Wind DECIMAL(5, 2),
    Precipitation DECIMAL(5, 2),
    Humidity DECIMAL(5, 2),
    Temperature DECIMAL(5, 2),
    PRIMARY KEY (SensorID),
    FOREIGN KEY (SensorID) REFERENCES SENSORS(SensorID) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS MONITORING (
    CropID INT,
    SensorID INT,
    PRIMARY KEY (CropID, SensorID),
    FOREIGN KEY (CropID) REFERENCES CROP(CropID) ON DELETE CASCADE,
    FOREIGN KEY (SensorID) REFERENCES SENSORS(SensorID) ON DELETE CASCADE
);
