# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  config.vm.define "server1" do |server1|
    server1.vm.box = "bento/ubuntu-16.04"
    server1.vm.hostname = "server1"

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine. In the example below,
    # accessing "localhost:8080" will access port 80 on the guest machine.
    # NOTE: This will enable public access to the opened port
    # server1.vm.network "forwarded_port", guest: 3306, host: 65000

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine and only allow access
    # via 127.0.0.1 to disable public access
    # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    server1.vm.network "private_network", ip: "192.168.16.12"

    # Create a public network, which generally matched to bridged network.
    # Bridged networks make the machine appear as another physical device on
    # your network.
    # server1.vm.network "public_network"

    server1.vm.provider "virtualbox" do |vb|
      # Display the VirtualBox GUI when booting the machine
      vb.gui = false
    
      # Customize the amount of memory on the VM:
      vb.memory = "512"
    end

    server1.vm.provision "shell", path: "provision/server1.sh", privileged: false

  end

  config.vm.define "server2" do |server2|
    server2.vm.box = "bento/ubuntu-16.04"
    server2.vm.hostname = "server2"

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine. In the example below,
    # accessing "localhost:8080" will access port 80 on the guest machine.
    # NOTE: This will enable public access to the opened port
    # server2.vm.network "forwarded_port", guest: 3306, host: 65000

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine and only allow access
    # via 127.0.0.1 to disable public access
    # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    server2.vm.network "private_network", ip: "192.168.16.13"

    # Create a public network, which generally matched to bridged network.
    # Bridged networks make the machine appear as another physical device on
    # your network.
    # server2.vm.network "public_network"

    server2.vm.provider "virtualbox" do |vb|
      # Display the VirtualBox GUI when booting the machine
      vb.gui = false
    
      # Customize the amount of memory on the VM:
      vb.memory = "512"
    end

    server2.vm.provision "shell", path: "provision/server2.sh", privileged: false

  end

  config.vm.define "server3" do |server3|
    server3.vm.box = "bento/ubuntu-16.04"
    server3.vm.hostname = "server3"

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine. In the example below,
    # accessing "localhost:8080" will access port 80 on the guest machine.
    # NOTE: This will enable public access to the opened port
    # server3.vm.network "forwarded_port", guest: 3306, host: 65000

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine and only allow access
    # via 127.0.0.1 to disable public access
    # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    server3.vm.network "private_network", ip: "192.168.16.14"

    # Create a public network, which generally matched to bridged network.
    # Bridged networks make the machine appear as another physical device on
    # your network.
    # server3.vm.network "public_network"

    server3.vm.provider "virtualbox" do |vb|
      # Display the VirtualBox GUI when booting the machine
      vb.gui = false
    
      # Customize the amount of memory on the VM:
      vb.memory = "512"
    end

    server3.vm.provision "shell", path: "provision/server3.sh", privileged: false

  end

  config.vm.define "proxy" do |proxy|
    proxy.vm.box = "bento/ubuntu-16.04"
    proxy.vm.hostname = "proxy"

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine. In the example below,
    # accessing "localhost:8080" will access port 80 on the guest machine.
    # NOTE: This will enable public access to the opened port
    # proxy.vm.network "forwarded_port", guest: 3306, host: 65000

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine and only allow access
    # via 127.0.0.1 to disable public access
    # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    proxy.vm.network "private_network", ip: "192.168.16.15"

    # Create a public network, which generally matched to bridged network.
    # Bridged networks make the machine appear as another physical device on
    # your network.
    # proxy.vm.network "public_network"

    proxy.vm.provider "virtualbox" do |vb|
      # Display the VirtualBox GUI when booting the machine
      vb.gui = false
    
      # Customize the amount of memory on the VM:
      vb.memory = "512"
    end

    proxy.vm.provision "shell", path: "provision/proxy.sh", privileged: false

  end

end