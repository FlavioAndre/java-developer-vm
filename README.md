
# Java Developer VM Example

[![Circle CI](https://circleci.com/gh/tknerr/java-developer-vm/tree/master.svg?style=shield)](https://circleci.com/gh/tknerr/java-developer-vm/tree/master)

A minimal example / template project for a Chef-managed Java developer VM,
based on the [linux-developer-vm](https://github.com/Zuehlke/linux-developer-vm).

It consists of two main parts:

 * the `update-vm.sh` script, which makes sure that [ChefDK](https://downloads.chef.io/chef-dk/)
   is installed, triggers the Chef run for updating the VM, and verifies the VM using a suite of
   [Serverspec](http://serverspec.org/) tests.
 * the `cookbooks/vm` cookbook, which contains the recipes to be applied to the VM and the
   tests that come along with it.

## Prerequisites

As a developer using the final product (i.e. the resulting developer VM) you
only need a VM host like [VirtualBox](http://virtualbox.org/wiki/Downloads)
installed.

As the guy who will be building and customizing the initial developer VM package
you will additionally need [Vagrant](http://www.vagrantup.com/) installed.

## Java Developer Tools

The Java Developer VM is based on Ubuntu 14.04 and includes:

 * Git 1.9
 * Oracle JDK 8
 * Maven 3.1.1
 * Eclipse Mars 4.5

It also includes the ChefDK so it can be updated from within the VM.

## Usage

In short:

 1. customize it
 2. package it
 3. run it

### Customize It

First, you bring up an isolated VM for testing your changes:
```
$ vagrant up
```

Now it gets a bit more Cheffy. The typical tasks are:

 * add a new recipe to `cookbooks/vm/recipes`
 * include it in the `default.rb` recipe
 * if you want to reuse existing cookbooks from [the supermarket](https://supermarket.chef.io/),
   add the dependencies to `cookbooks/vm/metadata.rb` so that Berkshelf can resolve it
 * for whatever you do, add a test in `cookbooks/vm/spec/integration`

Once you have added some Chef recipes, provision the VM to see it in effect:
```
$ vagrant provision
```

**Note:** you may need to login and logout for some settings to take effect.

Whenever something is done:
```
$ git add .
$ git commit -m "added awesome new tool to our developer VM"
```

Now rinse and repeat until you have a first version of your customized developer VM ready.


### Package It

Whenever you have a state ready enough for distributing it to your developers,
you can package / export it as a VirtualBox image.

First, start from a clean state:
```
$ vagrant destroy -f
$ vagrant up
```

Now you have to copy the repository from the shared folder into the VM:
```
$ vagrant ssh -c "cp -r /vagrant /home/vagrant/vm-setup"
```

You should also unmount the shared folders now:
```
$ vagrant ssh -c "sudo umount /vagrant"
```

Optionally, you may want to clean out the VM for a minimal export image:
```
$ vagrant ssh -c "wget -qO- https://raw.githubusercontent.com/boxcutter/ubuntu/master/script/cleanup.sh | sudo bash"
```

Finally, export the VM as an .ova file:
```
$ vagrant halt
$ VBoxManage export dev-box --output "dev-box-v0.1.ova" --options manifest,nomacs
```


### Run It

As a developer using the VM you typically:

 * import the .ova into VirtualBox (File -> Import Appliance...)
 * start the VM and log in using "vagrant" / "vagrant"
 * hack on some development stuff

At certain points in time you may want to update the VM:
```
$ cd /home/vagrant/setup
$ git pull
$ scripts/update-vm.sh
```


## Keyboard Layout

Seems to be too hard to automate for me, so you have to do this manually:
```
sudo dpkg-reconfigure keyboard-configuration
```


## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github
