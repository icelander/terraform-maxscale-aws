CREATE USER 'mdbadmin'@'%' IDENTIFIED BY 'really_secure_password';
GRANT ALL PRIVILEGES ON *.* TO 'mdbadmin'@'%';

CREATE DATABASE world;

CREATE USER 'dbmonitor'@'%' IDENTIFIED BY 'really_secure_password';
CREATE USER 'dbrepl'@'%' IDENTIFIED BY 'really_secure_password';

GRANT SELECT ON mysql.* to 'dbrepl'@'%'; GRANT SHOW DATABASES ON *.* to 'dbrepl'@'%';