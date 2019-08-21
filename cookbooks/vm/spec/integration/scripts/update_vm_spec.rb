require 'spec_helper'

describe 'update-vm.sh' do

  it 'installs chefdk 3.9.0' do
    expect(file('/opt/chefdk/version-manifest.txt')).to contain 'chefdk 3.9.0'
  end

  it 'symlinks the update-vm script to /usr/local/bin/' do
    expect(file('/usr/local/bin/update-vm')).to be_linked_to '/home/vagrant/vm-setup/scripts/update-vm.sh'
  end
end
