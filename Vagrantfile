
Vagrant::configure("2") do |config|

  #
  # define the dev-box VM
  #
  config.vm.define :"dev-box2" do | devbox_config |

    # configure the basebox
    devbox_config.vm.box = "boxcutter/ubuntu1404-desktop"

    # hostname
    devbox_config.vm.hostname = "dev-box2.local"

    # virtualbox customizations
    devbox_config.vm.provider :virtualbox do |vbox, override|
      vbox.customize ["modifyvm", :id,
        "--name", "dev-box2",
        "--memory", 512,
        "--cpus", 4
      ]
      # yes we have a gui
      vbox.gui = true
    end

    # Setup:
    #  - install ChefDK inside the VM
    #  - install THIS repository into the VM
    devbox_config.vm.provision :shell, privileged: false, path: "scripts/setup/install_chefdk.sh"
    devbox_config.vm.provision :shell, privileged: false, path: "scripts/setup/install_repository.sh"

    # Update the VM via Chef
    devbox_config.vm.provision :shell, privileged: false, inline: "/home/vagrant/setup/scripts/update-vm.sh"
  end
end