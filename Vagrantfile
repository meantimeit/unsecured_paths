# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.define "el6" do |el6|
    config.vm.box = "bento/centos-6.8"
    config.ssh.insert_key = false
    config.vm.provision "shell", inline: <<-SHELL
        yum -y install perl make automake gcc gmp-devel libffi zlib xz tar git gnupg
        curl -sSL https://get.haskellstack.org/ | sh
    SHELL
  end

  config.vm.define "el7" do |el7|
    config.vm.box = "bento/centos-7.2"
    config.ssh.insert_key = false
    config.vm.provision "shell", inline: <<-SHELL
        yum -y install perl make automake gcc gmp-devel libffi zlib xz tar git gnupg
        curl -sSL https://get.haskellstack.org/ | sh
    SHELL
  end

end
