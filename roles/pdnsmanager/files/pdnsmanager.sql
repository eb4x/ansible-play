CREATE TABLE IF NOT EXISTS domains (
    id int(11) NOT NULL AUTO_INCREMENT,
    name varchar(255) NOT NULL,
    master varchar(128) DEFAULT NULL,
    last_check int(11) DEFAULT NULL,
    type varchar(6) NOT NULL,
    notified_serial int(11) DEFAULT NULL,
    account varchar(40) DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY name_index (name)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS records (
    id int(11) NOT NULL AUTO_INCREMENT,
    domain_id int(11) DEFAULT NULL,
    name varchar(255) DEFAULT NULL,
    type varchar(6) DEFAULT NULL,
    content varchar(255) DEFAULT NULL,
    ttl int(11) DEFAULT NULL,
    prio int(11) NOT NULL DEFAULT '0',
    change_date int(11) DEFAULT NULL,
    disabled TINYINT(1) DEFAULT 0,
    auth TINYINT(1) DEFAULT 1,
    PRIMARY KEY (id),
    KEY nametype_index (name,type),
    KEY domain_id (domain_id),
    KEY rec_name_index (name),
    CONSTRAINT records_ibfk_1 FOREIGN KEY (domain_id) REFERENCES domains (id) ON DELETE CASCADE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

/*
ALTER TABLE records
  ADD CONSTRAINT IF NOT EXISTS records_ibfk_1 FOREIGN KEY (domain_id) REFERENCES domains (id) ON DELETE CASCADE;
*/

CREATE TABLE IF NOT EXISTS domainmetadata (
    id INT AUTO_INCREMENT,
    domain_id INT NOT NULL,
    kind VARCHAR(32),
    content TEXT,
    PRIMARY KEY (id)
) Engine=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS user (
    id int(11) NOT NULL AUTO_INCREMENT,
    name varchar(50) NOT NULL,
    password varchar(200) NOT NULL,
    type varchar(20) NOT NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

INSERT INTO user (name, password, type) VALUES ('admin', '$2y$10$jD1dCWsbmWlqlI.I3hht.Obq76iMgLK0SP87uiN4v1QEofU8MLwFG', 'admin');

CREATE TABLE IF NOT EXISTS permissions (
    user int(11) NOT NULL,
    domain int(11) NOT NULL,
    PRIMARY KEY (user, domain),
    KEY domain (domain),
    CONSTRAINT permissions_ibfk_1 FOREIGN KEY (domain) REFERENCES domains (id) ON DELETE CASCADE,
    CONSTRAINT permissions_ibfk_2 FOREIGN KEY (user) REFERENCES user (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*
ALTER TABLE permissions
  ADD CONSTRAINT permissions_ibfk_1 FOREIGN KEY (domain) REFERENCES domains (id) ON DELETE CASCADE;
ALTER TABLE permissions
  ADD CONSTRAINT permissions_ibfk_2 FOREIGN KEY (user) REFERENCES user (id) ON DELETE CASCADE;
*/

CREATE TABLE IF NOT EXISTS remote (
    id int(11) NOT NULL AUTO_INCREMENT,
    record int(11) NOT NULL,
    description varchar(255) NOT NULL,
    type varchar(20) NOT NULL,
    security varchar(2000) NOT NULL,
    nonce varchar(255) DEFAULT NULL,
    PRIMARY KEY (id),
    KEY record (record),
    CONSTRAINT remote_ibfk_1 FOREIGN KEY (record) REFERENCES records (id) ON DELETE CASCADE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

/*
ALTER TABLE remote
    ADD CONSTRAINT remote_ibfk_1 FOREIGN KEY (record) REFERENCES records (id) ON DELETE CASCADE;
*/

CREATE TABLE IF NOT EXISTS options (
    name varchar(255) NOT NULL,
    value varchar(2000) DEFAULT NULL,
    PRIMARY KEY (name)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

INSERT INTO options(name,value) VALUES ('schema_version', 3);

