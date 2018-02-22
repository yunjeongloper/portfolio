CREATE TABLE `member` (
  `no` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(10) DEFAULT NULL,
  `id` varchar(10) DEFAULT NULL,
  `pwd` varchar(100) DEFAULT NULL,
  `phone` varchar(13) DEFAULT NULL,
  `authority` varchar(2) DEFAULT '0',
  PRIMARY KEY (`no`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE `board` (
  `no` int(11) NOT NULL AUTO_INCREMENT,
  `subject` varchar(45) NOT NULL,
  `content` varchar(1000) NOT NULL,
  `writer` int(11) NOT NULL,
  `write_date` datetime DEFAULT NULL,
  `notice` tinyint(1) DEFAULT NULL,
  `parents_no` int(11) DEFAULT '0',
  `count` int(11) DEFAULT '0',
  `delete_ok` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`no`),
  KEY `board_ibfk_1` (`writer`),
  CONSTRAINT `board_ibfk_1` FOREIGN KEY (`writer`) REFERENCES `member` (`no`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE `board_file` (
  `no` int(11) NOT NULL AUTO_INCREMENT ,
  `board_no` int(11) NOT NULL ,
  `origin_name` varchar(1000) DEFAULT NULL ,
  `save_name` varchar(1000) DEFAULT NULL ,
  `url` varchar(100)  DEFAULT NULL,
  `delete_yn` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`no`),
  KEY `board_file_ibfk_1` (`board_no`),
  CONSTRAINT `board_file_ibfk_1` FOREIGN KEY (`board_no`) REFERENCES `board` (`no`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE `board_image` (
  `no` int(11) NOT NULL AUTO_INCREMENT,
  `board_no` int(11) NOT NULL,
  `origin_name` varchar(1000) NOT NULL,
  `save_name` varchar(1000) NOT NULL,
  `url` varchar(1000)  DEFAULT NULL,
  PRIMARY KEY (`no`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE `comment` (
  `no` int(11) NOT NULL AUTO_INCREMENT,
  `board_no` int(11) NOT NULL,
  `content` varchar(1000) DEFAULT NULL,
  `writer` int(11) NOT NULL,
  `write_date` datetime DEFAULT NULL,
  `parents_no` int(11) NOT NULL DEFAULT '0',
  `delete_ok` int(11) DEFAULT '0',
  PRIMARY KEY (`no`),
  KEY `comment_ibfk_1` (`board_no`),
  KEY `comment_ibfk_2` (`writer`),
  CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`board_no`) REFERENCES `board` (`no`),
  CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`writer`) REFERENCES `member` (`no`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE `loginlog` (
  `member_no` int(11) NOT NULL,
  `login_fail_count` int(2) DEFAULT '0',
  `is_account_lock` varchar(2)  DEFAULT 'N',
  `latest_login_date` date DEFAULT NULL,
  KEY `idx_loginlog_member_no` (`member_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `member` (`no`, `name`, `id`, `pwd`, `phone`, `authority`) VALUES ('1', 'admin', 'admin', '$2a$10$6BqouMTa9noFitZ7oY/J7eLan7sMLwpHxrYsmNoqtZNTDy6pYFZrC', '010-7723-8677', '1');