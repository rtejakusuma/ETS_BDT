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
                - Windown 10
                - RAM : `4096` MB
        - Pembagian IP<br>
            1. Server Database<br>
                - 192.168.16.12 (MySQL Server 1)
                - 192.168.16.13 (MySQL Server 2)
                - 192.168.16.14 (MySQL Server 3)
            2. Proxy<br>
                - 192.168.16.15 (Proxy MySQL)
            3. Apache Webserver<br>
                - localhost

    * Implementasi Infrastruktur Basis Data Terdistribusi
        - Proses Instalasi<br>
           **TBD**
        - Tahapan-tahapan Konfigurasi<br>
           **TBD**
       
2. Penggunaan Basis Data Terdistribusi dalam Aplikasi
    * Instalasi Aplikasi Tambahan<br>
           **TBD**
    * Konfigurasi Aplikasi Tambahan<br>
           **TBD**
    * Deskripsi Aplikasi yang Dipakai<br>
           **TBD**
    * Konfigurasi Aplikasi untuk Menggunakan Basis Data Terdistribusi  yang Telah Dibuat<br>
           **TBD**