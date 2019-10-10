CREATE USER 'monitor'@'%' IDENTIFIED BY 'password';
GRANT SELECT on sys.* to 'monitor'@'%';
FLUSH PRIVILEGES;

CREATE USER 'proxuser'@'%' IDENTIFIED BY 'proxpassword';
GRANT ALL PRIVILEGES on elaporan.* to 'proxuser'@'%';
FLUSH PRIVILEGES;