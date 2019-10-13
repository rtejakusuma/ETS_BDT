# ETS - Basis Data Terdistribusi

1. Desain dan Implementasi Infrastruktur
    * Desain Infrastruktur Basis Data Terdistribusi
        - Gambar Infrastruktur<br>
            ![Untitled Diagram](https://user-images.githubusercontent.com/32433590/66365342-d0540e00-e9b6-11e9-8508-8d0aa8c35a5c.png)
        - Jumlah Server<br>
            Jumlah server yang digunakan ==> 5<br>
            1. Server Database --> 3 buah
            2. Proxy --> 1 buah
            3. Apache web server --> 1 buah
        - Spesifikasi Hardware
            1. Server Database<br>
                - OS : `bento/ubuntu-16.04`<br>
                - RAM : `512` MB
                - MySQL server
            2. Proxy<br>
                - Proxy MySQL
                - OS : `bento/ubuntu-16.04`
                - RAM : `512` MB
            3. Apache Webserver<br>
                - Linux Mint 18.3
                - RAM : `4096` MB
        - Pembagian IP<br>
            1. Server Database<br>
                - 192.168.16.13 (MySQL Server 1)
                - 192.168.16.14 (MySQL Server 2)
                - 192.168.16.15 (MySQL Server 3)
            2. Proxy<br>
                - 192.168.16.12 (Proxy MySQL)
            3. Apache Webserver<br>
                - localhost

## Implementasi Infrastruktur Basis Data Terdistribusi
1. Persiapan
    - Host : Linux Mint 18.3
    - Aplikasi yang dibutuhkan:
        - Vagrant
        - Virtual box
        - php 7.2
        
2. Implementasi
    - Membuat `vagrantfile`<br>
    Dibuat dengan mengetikkan<br>
    ```bash
    sudo vagrant init
    ```
    - Mengedit `vagrantfile`
    Setelah membuat `vagrantfile` lalu edit dengan menggunakan `visual studio code` menjadi sebagai berikut
    ```bash
    # -*- mode: ruby -*-
    #vi: set ft=ruby :
    
    # All Vagrant configuration is done below. The "2" in Vagrant.configure
    # configures the configuration version (we support older styles for
    # backwards compatibility). Please don't change it unless you know what
    # you're doing.

    Vagrant.configure("2") do |config|
        # MySQL Cluster dengan 3 node
        (1..3).each do |i|
            config.winrm.timeout = 600
            config.vm.boot_timeout = 600
            config.vm.define "db#{i}" do |node|
                node.vm.hostname = "db#{i}"
                node.vm.box = "bento/ubuntu-16.04"
                node.vm.network "private_network", ip: "192.168.16.#{i+12}"

                # Opsional. Edit sesuai dengan nama network adapter di komputer
                #node.vm.network "public_network", bridge: "Qualcomm Atheros QCA9377 Wireless Network Adapter"
        
                node.vm.provider "virtualbox" do |vb|
                    vb.name = "db#{i}"
                    vb.gui = false
                    vb.memory = "512"
                end
    
                node.vm.provision "shell", path: "sh/server#{i}.sh", privileged: false
            end
        end
        config.vm.define "proxy" do |proxy|
            proxy.vm.hostname = "proxy"
            proxy.vm.box = "bento/ubuntu-16.04"
            proxy.vm.network "private_network", ip: "192.168.16.12"
            #proxy.vm.network "public_network",  bridge: "Qualcomm Atheros QCA9377 Wireless Network Adapter"
            proxy.vm.provider "virtualbox" do |vb|
                vb.name = "proxy"
                vb.gui = false
                vb.memory = "512"
            end
            proxy.vm.provision "shell", path: "sh/proxy.sh", privileged: false
        end
    end
    ```
    - Membuat Provision
        - Script untuk `db1`
        ```bash
        # Changing the APT sources.list to kambing.ui.ac.id
        sudo cp '/vagrant/sources.list' '/etc/apt/sources.list'
        
        # Updating the repo with the new sources
        sudo apt-get update -y
        
        # Install required library
        sudo apt-get install libaio1
        sudo apt-get install libmecab2
        
        # Get MySQL binaries
        curl -OL https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-common_5.7.23-1ubuntu16.04_amd64.deb
        curl -OL https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-community-client_5.7.23-1ubuntu16.04_amd64.debcurl -OL https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-client_5.7.23-1ubuntu16.04_amd64.debcurl -OL https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-community-server_5.7.23-1ubuntu16.04_amd64.deb
        
        # Setting input for installation
        sudo debconf-set-selections <<< 'mysql-community-server mysql-community-server/root-pass password admin'
        sudo debconf-set-selections <<< 'mysql-community-server mysql-community-server/re-root-pass password admin'
        
        # Install MySQL Community Server
        sudo dpkg -i mysql-common_5.7.23-1ubuntu16.04_amd64.deb
        sudo dpkg -i mysql-community-client_5.7.23-1ubuntu16.04_amd64.deb
        sudo dpkg -i mysql-client_5.7.23-1ubuntu16.04_amd64.deb
        sudo dpkg -i mysql-community-server_5.7.23-1ubuntu16.04_amd64.deb
        
        # Allow port on firewall
        sudo ufw allow 33061
        sudo ufw allow 3306
        
        # Copy MySQL configurations
        sudo mv /etc/mysql/my.cnf /etc/mysql/my.cnf.backup
        sudo cp /vagrant/cnf/server1.cnf /etc/mysql/my.cnf
        
        # Restart MySQL services
        sudo service mysql restart
        
        # Cluster bootstrapping
        sudo mysql -u root -padmin < /vagrant/sql/cluster_bootstrap.sql
        sudo mysql -u root -padmin < /vagrant/sql/addition_to_sys.sql
        sudo mysql -u root -padmin < /vagrant/sql/proxy_user.sql
        # sudo mysql -u root -padmin < /vagrant/sql/elaporan.sql
        ```
        - Script untuk `db2`
        ```bash
        # Changing the APT sources.list to kambing.ui.ac.id
        sudo cp '/vagrant/sources.list' '/etc/apt/sources.list'
        
        # Updating the repo with the new sources
        sudo apt-get update -y
        
        # Install required library
        sudo apt-get install libaio1
        sudo apt-get install libmecab2
        
        # Get MySQL binaries
        curl -OL https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-common_5.7.23-1ubuntu16.04_amd64.deb
        curl -OL https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-community-client_5.7.23-1ubuntu16.04_amd64.deb
        curl -OL https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-client_5.7.23-1ubuntu16.04_amd64.deb
        curl -OL https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-community-server_5.7.23-1ubuntu16.04_amd64.deb
        
        # Setting input for installation
        sudo debconf-set-selections <<< 'mysql-community-server mysql-community-server/root-pass password admin'
        sudo debconf-set-selections <<< 'mysql-community-server mysql-community-server/re-root-pass password admin'
        
        # Install MySQL Community Server
        sudo dpkg -i mysql-common_5.7.23-1ubuntu16.04_amd64.deb
        sudo dpkg -i mysql-community-client_5.7.23-1ubuntu16.04_amd64.deb
        sudo dpkg -i mysql-client_5.7.23-1ubuntu16.04_amd64.deb
        sudo dpkg -i mysql-community-server_5.7.23-1ubuntu16.04_amd64.deb
        
        # Allow port on firewall
        sudo ufw allow 33061
        sudo ufw allow 3306
        
        # Copy MySQL configurations
        sudo mv /etc/mysql/my.cnf /etc/mysql/my.cnf.backup
        sudo cp /vagrant/cnf/server2.cnf /etc/mysql/my.cnf
        
        # Restart MySQL services
        sudo service mysql restart
        
        # Cluster bootstrapping
        sudo mysql -u root -padmin < /vagrant/sql/member.sql
        # sudo mysql -u root -padmin < /vagrant/sql/cluster_bootstrap.sql
        # sudo mysql -u root -padmin < /vagrant/sql/addition_to_sys.sql
        # sudo mysql -u root -padmin < /vagrant/sql/proxy_user.sql
        # sudo mysql -u root -padmin < /vagrant/sql/elaporan.sql
        ```
        - Script untuk `db3`
        ```bash
        # Changing the APT sources.list to kambing.ui.ac.id
        sudo cp '/vagrant/sources.list' '/etc/apt/sources.list'
        
        # Updating the repo with the new sources
        sudo apt-get update -y
        
        # Install required library
        sudo apt-get install libaio1
        sudo apt-get install libmecab2
        
        # Get MySQL binaries
        curl -OL https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-common_5.7.23-1ubuntu16.04_amd64.deb
        curl -OL https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-community-client_5.7.23-1ubuntu16.04_amd64.deb
        curl -OL https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-client_5.7.23-1ubuntu16.04_amd64.deb
        curl -OL https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-community-server_5.7.23-1ubuntu16.04_amd64.deb
        
        # Setting input for installation
        sudo debconf-set-selections <<< 'mysql-community-server mysql-community-server/root-pass password admin'
        sudo debconf-set-selections <<< 'mysql-community-server mysql-community-server/re-root-pass password admin'
        
        # Install MySQL Community Server
        sudo dpkg -i mysql-common_5.7.23-1ubuntu16.04_amd64.deb
        sudo dpkg -i mysql-community-client_5.7.23-1ubuntu16.04_amd64.deb
        sudo dpkg -i mysql-client_5.7.23-1ubuntu16.04_amd64.deb
        sudo dpkg -i mysql-community-server_5.7.23-1ubuntu16.04_amd64.deb
        
        # Allow port on firewall
        sudo ufw allow 33061
        sudo ufw allow 3306
        
        # Copy MySQL configurations
        sudo mv /etc/mysql/my.cnf /etc/mysql/my.cnf.backup
        sudo cp /vagrant/cnf/server3.cnf /etc/mysql/my.cnf
        
        # Restart MySQL services
        sudo service mysql restart
        
        # Cluster bootstrapping
        sudo mysql -u root -padmin < /vagrant/sql/member.sql
        # sudo mysql -u root -padmin < /vagrant/sql/cluster_bootstrap.sql
        # sudo mysql -u root -padmin < /vagrant/sql/addition_to_sys.sql
        # sudo mysql -u root -padmin < /vagrant/sql/proxy_user.sql
        # sudo mysql -u root -padmin < /vagrant/sql/elaporan.sql
        ```
        - Script untuk `proxy`
        ```bash
        # Changing the APT sources.list to kambing.ui.ac.id
        sudo cp '/vagrant/sources.list' '/etc/apt/sources.list'
        
        # Updating the repo with the new sources
        sudo apt-get update -y
        
        cd /tmp
        curl -OL https://github.com/sysown/proxysql/releases/download/v1.4.4/proxysql_1.4.4-ubuntu16_amd64.deb
        curl -OL https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-common_5.7.23-1ubuntu16.04_amd64.deb
        curl -OL https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-community-client_5.7.23-1ubuntu16.04_amd64.deb
        curl -OL https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-client_5.7.23-1ubuntu16.04_amd64.deb
        
        sudo apt-get install libaio1
        sudo apt-get install libmecab2
        
        sudo dpkg -i proxysql_1.4.4-ubuntu16_amd64.deb
        sudo dpkg -i mysql-common_5.7.23-1ubuntu16.04_amd64.deb
        sudo dpkg -i mysql-community-client_5.7.23-1ubuntu16.04_amd64.deb
        sudo dpkg -i mysql-client_5.7.23-1ubuntu16.04_amd64.deb
        
        sudo ufw allow 33061
        sudo ufw allow 3306
        
        sudo systemctl start proxysql
        sudo mysql -u admin -padmin -h 127.0.0.1 -P 6032 < /vagrant/sql/proxysql.sql
        ```
    
    - Membuat Konfigurasi cnf
        - Pada `db1`
        ```bash
        #
        # The MySQL database server configuration file.
        #
        # You can copy this to one of:
        # - "/etc/mysql/my.cnf" to set global options,
        # - "~/.my.cnf" to set user-specific options.
        # 
        # One can use all long options that the program supports.
        # Run program with --help to get a list of available options and with
        # --print-defaults to see which it would actually understand and use.
        #
        # For explanations see
        # http://dev.mysql.com/doc/mysql/en/server-system-variables.html
        #
        # * IMPORTANT: Additional settings that can override those from this file!
        #   The files must end with '.cnf', otherwise they'll be ignored.
        #

        !includedir /etc/mysql/conf.d/
        !includedir /etc/mysql/mysql.conf.d/

        [mysqld]

        # General replication settings
        gtid_mode = ON
        enforce_gtid_consistency = ON
        master_info_repository = TABLE
        relay_log_info_repository = TABLE
        binlog_checksum = NONE
        log_slave_updates = ON
        log_bin = binlog
        binlog_format = ROW
        transaction_write_set_extraction = XXHASH64
        loose-group_replication_bootstrap_group = OFF
        loose-group_replication_start_on_boot = ON
        loose-group_replication_ssl_mode = REQUIRED
        loose-group_replication_recovery_use_ssl = 1

        # Shared replication group configuration
        loose-group_replication_group_name = "82a56cf6-86d5-420a-bc67-386bc98e3c8b"
        loose-group_replication_ip_whitelist = "192.168.16.13, 192.168.16.14, 192.168.16.15"
        loose-group_replication_group_seeds = "192.168.16.13:33061, 192.168.16.14:33061, 192.168.16.15:33061"

        # Single or Multi-primary mode? Uncomment these two lines
        # for multi-primary mode, where any host can accept writes
        loose-group_replication_single_primary_mode = OFF
        loose-group_replication_enforce_update_everywhere_checks = ON

        # Host specific replication configuration
        server_id = 1
        bind-address = "192.168.16.13"
        report_host = "192.168.16.13"
        loose-group_replication_local_address = "192.168.16.13:33061"
        ```
        - Pada `db2`
        ```bash
        #
        # The MySQL database server configuration file.
        #
        # You can copy this to one of:
        # - "/etc/mysql/my.cnf" to set global options,
        # - "~/.my.cnf" to set user-specific options.
        # 
        # One can use all long options that the program supports.
        # Run program with --help to get a list of available options and with
        # --print-defaults to see which it would actually understand and use.
        #
        # For explanations see
        # http://dev.mysql.com/doc/mysql/en/server-system-variables.html

        #
        # * IMPORTANT: Additional settings that can override those from this file!
        #   The files must end with '.cnf', otherwise they'll be ignored.
        #

        !includedir /etc/mysql/conf.d/
        !includedir /etc/mysql/mysql.conf.d/

        [mysqld]

        # General replication settings
        gtid_mode = ON
        enforce_gtid_consistency = ON
        master_info_repository = TABLE
        relay_log_info_repository = TABLE
        binlog_checksum = NONE
        log_slave_updates = ON
        log_bin = binlog
        binlog_format = ROW
        transaction_write_set_extraction = XXHASH64
        loose-group_replication_bootstrap_group = OFF
        loose-group_replication_start_on_boot = ON
        loose-group_replication_ssl_mode = REQUIRED
        loose-group_replication_recovery_use_ssl = 1

        # Shared replication group configuration
        loose-group_replication_group_name = "82a56cf6-86d5-420a-bc67-386bc98e3c8b"
        loose-group_replication_ip_whitelist = "192.168.16.13, 192.168.16.14, 192.168.16.15"
        loose-group_replication_group_seeds = "192.168.16.13:33061, 192.168.16.14:33061, 192.168.16.15:33061"

        # Single or Multi-primary mode? Uncomment these two lines
        # for multi-primary mode, where any host can accept writes
        loose-group_replication_single_primary_mode = OFF
        loose-group_replication_enforce_update_everywhere_checks = ON

        # Host specific replication configuration
        server_id = 2
        bind-address = "192.168.16.14"
        report_host = "192.168.16.14"
        loose-group_replication_local_address = "192.168.16.14:33061"
        ```
        - Pada `db3`
        ```bash
        #
        # The MySQL database server configuration file.
        #
        # You can copy this to one of:
        # - "/etc/mysql/my.cnf" to set global options,
        # - "~/.my.cnf" to set user-specific options.
        # 
        # One can use all long options that the program supports.
        # Run program with --help to get a list of available options and with
        # --print-defaults to see which it would actually understand and use.
        #
        # For explanations see
        # http://dev.mysql.com/doc/mysql/en/server-system-variables.html

        #
        # * IMPORTANT: Additional settings that can override those from this file!
        #   The files must end with '.cnf', otherwise they'll be ignored.
        #

        !includedir /etc/mysql/conf.d/
        !includedir /etc/mysql/mysql.conf.d/

        [mysqld]

        # General replication settings
        gtid_mode = ON
        enforce_gtid_consistency = ON
        master_info_repository = TABLE
        relay_log_info_repository = TABLE
        binlog_checksum = NONE
        log_slave_updates = ON
        log_bin = binlog
        binlog_format = ROW
        transaction_write_set_extraction = XXHASH64
        loose-group_replication_bootstrap_group = OFF
        loose-group_replication_start_on_boot = ON
        loose-group_replication_ssl_mode = REQUIRED
        loose-group_replication_recovery_use_ssl = 1

        # Shared replication group configuration
        loose-group_replication_group_name = "82a56cf6-86d5-420a-bc67-386bc98e3c8b"
        loose-group_replication_ip_whitelist = "192.168.16.13, 192.168.16.14, 192.168.16.15"
        loose-group_replication_group_seeds = "192.168.16.13:33061, 192.168.16.14:33061, 192.168.16.15:33061"

        # Single or Multi-primary mode? Uncomment these two lines
        # for multi-primary mode, where any host can accept writes
        loose-group_replication_single_primary_mode = OFF
        loose-group_replication_enforce_update_everywhere_checks = ON

        # Host specific replication configuration
        server_id = 3
        bind-address = "192.168.16.15"
        report_host = "192.168.16.15"
        loose-group_replication_local_address = "192.168.16.15:33061"
        ```

    - Membuat file SQL yang sekiranya diperlukan
        - File `addition_to-sys.sql`
        ```bash
        USE sys;

        DELIMITER $$

        CREATE FUNCTION IFZERO(a INT, b INT)
        RETURNS INT
        DETERMINISTIC
        RETURN IF(a = 0, b, a)$$

        CREATE FUNCTION LOCATE2(needle TEXT(10000), haystack TEXT(10000), offset INT)
        RETURNS INT
        DETERMINISTIC
        RETURN IFZERO(LOCATE(needle, haystack, offset), LENGTH(haystack) + 1)$$

        CREATE FUNCTION GTID_NORMALIZE(g TEXT(10000))
        RETURNS TEXT(10000)
        DETERMINISTIC
        RETURN GTID_SUBTRACT(g, '')$$

        CREATE FUNCTION GTID_COUNT(gtid_set TEXT(10000))
        RETURNS INT
        DETERMINISTIC
        BEGIN
        DECLARE result BIGINT DEFAULT 0;
        DECLARE colon_pos INT;
        DECLARE next_dash_pos INT;
        DECLARE next_colon_pos INT;
        DECLARE next_comma_pos INT;
        SET gtid_set = GTID_NORMALIZE(gtid_set);
        SET colon_pos = LOCATE2(':', gtid_set, 1);
        WHILE colon_pos != LENGTH(gtid_set) + 1 DO
            SET next_dash_pos = LOCATE2('-', gtid_set, colon_pos + 1);
            SET next_colon_pos = LOCATE2(':', gtid_set, colon_pos + 1);
            SET next_comma_pos = LOCATE2(',', gtid_set, colon_pos + 1);
            IF next_dash_pos < next_colon_pos AND next_dash_pos < next_comma_pos THEN
            SET result = result +
                SUBSTR(gtid_set, next_dash_pos + 1,
                        LEAST(next_colon_pos, next_comma_pos) - (next_dash_pos + 1)) -
                SUBSTR(gtid_set, colon_pos + 1, next_dash_pos - (colon_pos + 1)) + 1;
            ELSE
            SET result = result + 1;
            END IF;
            SET colon_pos = next_colon_pos;
        END WHILE;
        RETURN result;
        END$$

        CREATE FUNCTION gr_applier_queue_length()
        RETURNS INT
        DETERMINISTIC
        BEGIN
        RETURN (SELECT sys.gtid_count( GTID_SUBTRACT( (SELECT
        Received_transaction_set FROM performance_schema.replication_connection_status
        WHERE Channel_name = 'group_replication_applier' ), (SELECT
        @@global.GTID_EXECUTED) )));
        END$$

        CREATE FUNCTION gr_member_in_primary_partition()
        RETURNS VARCHAR(3)
        DETERMINISTIC
        BEGIN
        RETURN (SELECT IF( MEMBER_STATE='ONLINE' AND ((SELECT COUNT(*) FROM
        performance_schema.replication_group_members WHERE MEMBER_STATE != 'ONLINE') >=
        ((SELECT COUNT(*) FROM performance_schema.replication_group_members)/2) = 0),
        'YES', 'NO' ) FROM performance_schema.replication_group_members JOIN
        performance_schema.replication_group_member_stats USING(member_id));
        END$$

        CREATE VIEW gr_member_routing_candidate_status AS SELECT
        sys.gr_member_in_primary_partition() as viable_candidate,
        IF( (SELECT (SELECT GROUP_CONCAT(variable_value) FROM
        performance_schema.global_variables WHERE variable_name IN ('read_only',
        'super_read_only')) != 'OFF,OFF'), 'YES', 'NO') as read_only,
        sys.gr_applier_queue_length() as transactions_behind, Count_Transactions_in_queue as 'transactions_to_cert' from performance_schema.replication_group_member_stats;$$

        DELIMITER ;
        ```
        - File `cluster_bootsrap.sql`
        ```bash
        SET SQL_LOG_BIN=0;
        CREATE USER 'repl'@'%' IDENTIFIED BY 'password' REQUIRE SSL;
        GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';
        FLUSH PRIVILEGES;
        SET SQL_LOG_BIN=1;

        CHANGE MASTER TO MASTER_USER='repl', MASTER_PASSWORD='password' FOR CHANNEL 'group_replication_recovery';
        INSTALL PLUGIN group_replication SONAME 'group_replication.so';

        SET GLOBAL group_replication_bootstrap_group=ON;
        START GROUP_REPLICATION;
        SET GLOBAL group_replication_bootstrap_group=OFF;
        ```
        - File `elaporan.sql` <br>
        Ini merupakan file dumb sql dari web app yang sudah dimodifikasi dengan menambahkan `primary key` di setiap tabelnya.
        - File `elaporanv2.sql` <br>
        Yang membedakan file ini terhadap `elaporan.sql` ialah tidak adanya Foreign Key dalam databasenya karena jika ada FK bisa menyebabkan `mysql has gone` karena keterbatasan memori dll. Selain tidak adanya FK semuanya sama.

        - File `member.sql`
        ```bash
        SET SQL_LOG_BIN=0;
        CREATE USER 'repl'@'%' IDENTIFIED BY 'password' REQUIRE SSL;
        GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';
        FLUSH PRIVILEGES;
        SET SQL_LOG_BIN=1;

        CHANGE MASTER TO MASTER_USER='repl', MASTER_PASSWORD='password' FOR CHANNEL 'group_replication_recovery';
        INSTALL PLUGIN group_replication SONAME 'group_replication.so';
        ```
        - File `proxy_user.sql`
        ```bash
        CREATE USER 'monitor'@'%' IDENTIFIED BY 'password';
        GRANT SELECT on sys.* to 'monitor'@'%';
        FLUSH PRIVILEGES;

        CREATE USER 'proxuser'@'%' IDENTIFIED BY 'proxpassword';
        GRANT ALL PRIVILEGES on elaporan.* to 'proxuser'@'%';
        FLUSH PRIVILEGES;
        ```
        - File `proxysql.sql`
        ```bash
        UPDATE global_variables SET variable_value='admin:admin' WHERE variable_name='admin-admin_credentials';
        LOAD ADMIN VARIABLES TO RUNTIME;
        SAVE ADMIN VARIABLES TO DISK;

        UPDATE global_variables SET variable_value='monitor' WHERE variable_name='mysql-monitor_username';
        LOAD MYSQL VARIABLES TO RUNTIME;
        SAVE MYSQL VARIABLES TO DISK;

        INSERT INTO mysql_group_replication_hostgroups (writer_hostgroup, backup_writer_hostgroup, reader_hostgroup, offline_hostgroup, active, max_writers, writer_is_also_reader, max_transactions_behind) VALUES (2, 4, 3, 1, 1, 3, 1, 100);

        INSERT INTO mysql_servers(hostgroup_id, hostname, port) VALUES (2, '192.168.16.13', 3306);
        INSERT INTO mysql_servers(hostgroup_id, hostname, port) VALUES (2, '192.168.16.14', 3306);
        INSERT INTO mysql_servers(hostgroup_id, hostname, port) VALUES (2, '192.168.16.15', 3306);

        LOAD MYSQL SERVERS TO RUNTIME;
        SAVE MYSQL SERVERS TO DISK;

        INSERT INTO mysql_users(username, password, default_hostgroup) 
        VALUES ('proxuser', 'proxpassword', 2);

        LOAD MYSQL USERS TO RUNTIME;
        SAVE MYSQL USERS TO DISK;   
        ```

3. Menjalankan Vagrant
    - Setelah dirasa semua provisonnya sudah maka jalankan VM dengan cara
    ```bash
    sudo vagrant up
    ```
    - Setelah proses `sudo vagrant up` selesai maka bisa masuk ke VM yang ada dengan cara
        - Untuk masuk ke Database 1
        ```bash
        sudo vagrant ssh db1
        ```
        - Untuk masuk ke Database 2
        ```bash
        sudo vagrant ssh db2
        ```
        - Untuk masuk ke Database 3
        ```bash
        sudo vagrant ssh db3
        ```
        - Untuk masuk ke Proxy
        ```bash
        sudo vagrant ssh proxy
        ```
    - Masuk ke VM proxy dengan cara `sudo vagrant ssh proxy` lalu lakukan
    ```bash
    sudo mysql -u admin -padmin -h 127.0.0.1 -P 6032 < /vagrant/sql/proxysql.sql
    ```
    Kenapa perlu melakukan provisiong diatas karena script tersebut tidak bisa berjalan ketika melakukan `vagrant up` sehingga dilakukan secara manual.

    - Masuk ke VM salah satu database lalu lakukan
    ```bash
    sudo mysql -u root -padmin < /vagrant/sql/elaporan.sql
    ```
    Perlu melakukan perintah diatas untuk memasukkan data dump yang sudah di modifikasidari web appnya.

4. Menjalankan Web Server<br>
    Pada kali ini menggunakan PHP sebagai webserver dengan cara menjalankan perintah ini
    ```bash
    php -S localhost:8000
    ```
    Sehingga wes app bisa di akses di `localhost:8000`

5. Web APP
    - Nama Aplikasi<br>
    **ELAPORAN**
    - Deskripsi Aplikasi<br>
    **Elaporan** ialah merupakan sistem manajemen laporan yang berbasis web (menggunakan CodeIgniter) yang diperuntukan untuk semua OPD yang ada di Kota Madiun. Sehingga ketika pegawai dari OPD tersebut ingin membuat sebuah laporan tinggal mengisi saja isian untuk laporan tersebut sesuai dengan tipenya. Jika dalam laporan tersebut ada data yang berasal dari API aplikasi lain maka pegawai tersebut tidak perlu memasukkan data lagi. Selain itu **Elaporan** juga menyediakan untuk langsung  mengunduh laporan yang telah dibuat menjadi excel.

    - Download Web App <br>
    Web app ini bisa di download di [elaporan](https://github.com/rtejakusuma/elaporan)
    
    - Merubah Setting Database<br>
    Agar aplikasi ini bisa berjalan pada tugas BDT ini ada beberapa hal yang harus diiubah yaitu
        - Database Connection 
        ```bash
        $active_group = 'elaporan';
        ```
        ```bash
        $db['elaporan'] = array(
            'dsn'	=> '',
            'hostname' => '192.168.16.12:6033',
            'username' => 'proxuser',
            'password' => 'proxpassword',
            'database' => 'elaporan',
            'dbdriver' => 'mysqli',
            'dbprefix' => '',
            'pconnect' => FALSE,
            'db_debug' => (ENVIRONMENT !== 'production'),
            'cache_on' => FALSE,
            'cachedir' => '',
            'char_set' => 'utf8',
            'dbcollat' => 'utf8_general_ci',
            'swap_pre' => '',
            'encrypt' => FALSE,
            'compress' => FALSE,
            'stricton' => FALSE,
            'failover' => array(),
            'save_queries' => TRUE
        );
        ```
        - Struktur Database<br>
        Karena ketika melakukan dump pada tugas ini untuk setiap tabelnya harus memiliki `primary key` maka untuk tabel yang awal nya tidak memiliki `primary key` sehingga perlu ditambahkan dan jadilah file `/vagrant/sql/elaporan.sql`

6. Simulai FailOver
    - Pertama kita masuk ke proxy dengan cara `sudo vagrant ssh proxy` dan masuk ke mysql yang sebagai user dengan cara
    ```bash
    sudo mysql -u proxuser -pproxuser -h 127.0.0.1 -P 6033
    ```
    Lalu setelah masuk ke dalam `>mysql` lalu cek hostnamenya dengan cara
    ```bash
    select @@hostname
    ```
    ![fasdfasdf](https://user-images.githubusercontent.com/32433590/66716451-fb47c300-edf7-11e9-9e5c-bb3f34cb8297.png)
    
    - Setelah mengatahui `hostname` pada proxy maka sekarang mematikan service dari `hostname` tersebut dengan cara
    ```bash
    service mysql stop
    ```
    ![failasdfa](https://user-images.githubusercontent.com/32433590/66716461-1d414580-edf8-11e9-9f02-c49514f26f98.png)
    
    - Setelah langkah yang sebelumnya berhasil maka cek kembali `hostname` pada proxy dengan cara yang sama
    ```bash
    select @@hostname
    ```
    - Jika failovernya berhasil maka `hostname` dari proxy tadi akan berubah
    
    ![fadsfasdfasfads](https://user-images.githubusercontent.com/32433590/66716467-30ecac00-edf8-11e9-95fa-7651f8f9ce96.png)
    
    - Sekarang akan mengetes failover dari segi datanya karena tadi ada salah satu server yang sudah mati maka mencoba masuk ke server lain dan masuk ke mysqlnya dan membuat sebuah database seperti gambar dibawah
    
    ![fail4](https://user-images.githubusercontent.com/32433590/66716476-49f55d00-edf8-11e9-8d65-d23bf71c739f.png)
    
    - Setelah itu kita hidupkan kembali server yang kita matikan tadi dan cek di databasenya apakah database yang kita buat sebelumnya sudah ada atau belum
    
     ![failasdfa](https://user-images.githubusercontent.com/32433590/66716461-1d414580-edf8-11e9-9f02-c49514f26f98.png)
     
     Jika sudah ada maka failovernya telah berjalan.
