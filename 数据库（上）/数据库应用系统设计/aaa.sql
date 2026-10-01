ALTER TABLE Typhoon_base ENGINE=InnoDB;
ALTER TABLE Landfall_record ENGINE=InnoDB;
ALTER TABLE Damage_record ENGINE=InnoDB;
ALTER TABLE Track_monitoring ENGINE=InnoDB;
ALTER TABLE Warning_rule ENGINE=InnoDB;
ALTER TABLE User_info ENGINE=InnoDB;
ALTER TABLE User_warning ENGINE=InnoDB;

-- Landfall_record 表中的外键 typhoon_id
CREATE INDEX idx_landfall_typhoon_id ON Landfall_record(typhoon_id);

-- Damage_record 表中的外键 typhoon_id
CREATE INDEX idx_damage_typhoon_id ON Damage_record(typhoon_id);

-- Track_monitoring 表中的外键 typhoon_id
CREATE INDEX idx_track_typhoon_id ON Track_monitoring(typhoon_id);

-- User_warning 表中的外键 user_id, typhoon_id, rule_id
CREATE INDEX idx_userwarn_user_id ON User_warning(user_id);
CREATE INDEX idx_userwarn_typhoon_id ON User_warning(typhoon_id);
CREATE INDEX idx_userwarn_rule_id ON User_warning(rule_id);

CREATE UNIQUE INDEX uk_user_username ON User_info(username);
CREATE UNIQUE INDEX uk_user_phone ON User_info(phone);

CREATE INDEX idx_typhoon_start_time ON Typhoon_base(start_time);

CREATE INDEX idx_track_typhoon_time ON Track_monitoring(typhoon_id, record_time);

CREATE INDEX idx_damage_area ON Damage_record(province, city, district);

ALTER TABLE User_info ADD COLUMN location POINT NOT NULL SRID 4326;
UPDATE User_info SET location = POINT(longitude, latitude);
CREATE SPATIAL INDEX sp_idx_user_location ON User_info(location);

ALTER TABLE Landfall_record ADD COLUMN location POINT NOT NULL SRID 4326;
UPDATE Landfall_record SET location = POINT(longitude, latitude);
CREATE SPATIAL INDEX sp_idx_landfall_location ON Landfall_record(location);

ALTER TABLE Track_monitoring ADD COLUMN location POINT NOT NULL SRID 4326;
UPDATE Track_monitoring SET location = POINT(longitude, latitude);
CREATE SPATIAL INDEX sp_idx_track_location ON Track_monitoring(location);

ALTER TABLE Track_monitoring PARTITION BY RANGE (YEAR(record_time)) (
    PARTITION p_before_2020 VALUES LESS THAN (2020),
    PARTITION p2020 VALUES LESS THAN (2021),
    PARTITION p2021 VALUES LESS THAN (2022),
    PARTITION p2022 VALUES LESS THAN (2023),
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

ALTER TABLE Landfall_record PARTITION BY RANGE (YEAR(landfall_time)) (
    PARTITION p_before_2020 VALUES LESS THAN (2020),
    PARTITION p2020 VALUES LESS THAN (2021),
    PARTITION p2021 VALUES LESS THAN (2022),
    PARTITION p2022 VALUES LESS THAN (2023),
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

CREATE OR REPLACE VIEW V_Active_Typhoon_Latest_Info AS
SELECT
    tb.typhoon_id,
    tb.name_cn,
    tb.name_en,
    tm.record_time,
    tm.latitude,
    tm.longitude,
    tm.wind_speed,
    tm.pressure,
    tm.move_direction,
    tm.move_speed
FROM
    Typhoon_base tb
JOIN
    Track_monitoring tm ON tb.typhoon_id = tm.typhoon_id
JOIN
    (SELECT typhoon_id, MAX(record_time) AS max_time FROM Track_monitoring GROUP BY typhoon_id) AS latest
    ON tm.typhoon_id = latest.typhoon_id AND tm.record_time = latest.max_time
WHERE
    tb.end_time IS NULL;

CREATE OR REPLACE VIEW V_District_Damage_Summary AS
SELECT
    province,
    city,
    district,
    COUNT(DISTINCT typhoon_id) AS typhoon_count,
    SUM(casualties) AS total_casualties,
    SUM(houses_damaged) AS total_houses_damaged,
    SUM(economic_loss) AS total_economic_loss,
    AVG(rainfall) AS avg_rainfall
FROM
    Damage_record
GROUP BY
    province, city, district;

DELIMITER $$
CREATE TRIGGER TRG_UserInfo_Before_Update_Set_LastLogin
BEFORE UPDATE ON User_info
FOR EACH ROW
BEGIN
    SET NEW.last_login = NOW();
END;$$
DELIMITER ;

-- 创建一个日志表
CREATE TABLE Audit_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    log_time DATETIME NOT NULL,
    log_message VARCHAR(255) NOT NULL
);

-- 创建触发器
DELIMITER $$
CREATE TRIGGER TRG_TyphoonBase_After_Insert_Log
AFTER INSERT ON Typhoon_base
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Log (log_time, log_message)
    VALUES (NOW(), CONCAT('New typhoon recorded: ', NEW.typhoon_id, ' (', NEW.name_cn, ')'));
END;$$
DELIMITER ;

-- 密码应使用更安全复杂的字符串
CREATE USER 'app_server'@'localhost' IDENTIFIED BY 'AppServerPassword123';
CREATE USER 'data_admin'@'localhost' IDENTIFIED BY 'DataAdminPassword123';
CREATE USER 'readonly_user'@'localhost' IDENTIFIED BY 'ReadOnlyPassword123';

-- 授予查询权限
GRANT SELECT ON TyphoonDB.V_Active_Typhoon_Latest_Info TO 'app_server'@'localhost';
GRANT SELECT ON TyphoonDB.V_District_Damage_Summary TO 'app_server'@'localhost';
GRANT SELECT ON TyphoonDB.Typhoon_base, TyphoonDB.Landfall_record, TyphoonDB.Damage_record, TyphoonDB.Track_monitoring, TyphoonDB.Warning_rule TO 'app_server'@'localhost';
-- 授予对用户信息和预警信息的增删改权限
GRANT SELECT, INSERT, UPDATE ON TyphoonDB.User_info TO 'app_server'@'localhost';
GRANT SELECT, INSERT, UPDATE ON TyphoonDB.User_warning TO 'app_server'@'localhost';
-- 授予执行特定存储过程的权限
GRANT EXECUTE ON PROCEDURE TyphoonDB.SP_Generate_Warnings_For_Typhoon TO 'app_server'@'localhost';

GRANT SELECT, INSERT, UPDATE, DELETE ON TyphoonDB.* TO 'data_admin'@'localhost';

GRANT SELECT ON TyphoonDB.* TO 'readonly_user'@'localhost';