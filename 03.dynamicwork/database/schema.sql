CREATE DATABASE IF NOT EXISTS theletter 
DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE theletter;

CREATE TABLE IF NOT EXISTS user (
    id BIGINT(16) PRIMARY KEY COMMENT 'mobile number',
    name VARCHAR(32),
    password VARCHAR(32),
    ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
