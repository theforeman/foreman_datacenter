# Foreman Datacenter Plugin

This plugin lets you document your physical servers across multiple datacenters. It documents racks, devices, interfaces, connections between machines (servers or switches).

Foreman Datacenter plugin documents following:

* **Sites** - contains all physical locations (datacenters) where servers are stored
* **Racks** - contains all racks across all datacenters
* **Rack groups** - group of racks, e.g. one room where this group of racks is stored
* **Devices** - contains all devices (switches, servers, etc.)
* **Device types** - contains all device types (e.g. HP ProLiant DL180 G6)
* **Device roles** - e.g. server, switch, etc.
* **Manufacturers** - contains all manufacturers (HP, Dell, etc.)
* **Platforms** - e.g. ipmi, mgmt interface, etc.
* **Console connections** - lists all e.g. RS232 connections
* **Power connections** - lists all connections of power cables
* **Interface connections** - lists all connections between interfaces

## Introduction Video presentation

* https://www.youtube.com/watch?v=HVmJ6UYPaz0

## Installation by package

See [Plugins Installation](https://theforeman.org/plugins/#2.Installation) for how to install Foreman plugins.

### Ubuntu/Debian instructions
```
apt-get install ruby-foreman-datacenter
```

### Redhat/Centos instructions
```
yum install ruby-foreman-datacenter
```

NOTE: on both platforms, after the plugin is installed you have to precompile assets!
```
foreman-rake assets:precompile
```

## Installation by gem

### Redhat/Centos instructions (confirmed on Katello 3.4/Foreman 1.15.6 and 1.16)

You may need to install additional Gems and feed db:
```
# Install some required gems for precompile assets
gem install --ignore-dependencies sprockets
gem install --ignore-dependencies sass
gem install --ignore-dependencies sass-listen
gem install --ignore-dependencies rb-fsevent
gem install --ignore-dependencies rb-inotify
gem install --ignore-dependencies ffi

# Add repo cause ffi needs ruby22-ruby-devel
cat > /etc/yum.repos.d/CentOS-SCLo-scl.repo << EOF
[centos-sclo-sclo-rh]
name=CentOS-7 - SCLo sclo ruby22
baseurl=http://mirror.centos.org/centos/7/sclo/x86_64/rh/
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo
EOF

# Install ruby22-ruby-devel for ruby gem ffi
yum install rh-ruby22-ruby-devel
gem install --ignore-dependencies ffi

# Precompile assets should work now
foreman-rake assets:precompile

# Now feed database
RAILS_ENV=production rake db:migrate

# If it fails
cd /opt/rh/rh-ruby22/root/usr/local/share/gems/gems/foreman_datacenter-0.1.49/db/migrate
for F in `ls`;do  sed -i ${F} -e 's/\[4.2\]//';done;
```

## Usage

### Create a device type

Here you can create a particular device type, for example a model of switch and then create all interfaces only here, so when you create a particular switch, it will have all the desired interfaces. Just click on **Device types** -> **New device type**, fill in information and save. Then click on the desired device type and you can add all the interfaces here.

### Create a device

You can either just create a device - then you have to create first Manufacturer, Device Type, Device Role, Platform; or you can import device from Puppet facts (this feature is still in development phase) - you just click **Devices** -> **Import from host** and then will search your host and click **Import to device**. Then you will get a page with additional information about the machine to be filled like location, position in rack, etc. Once device is created, you can list it in **Devices** section and when you click on this device, you can fill in additional information, e.g. connect its interfaces to a switch, etc.

### Possible problem

Sometimes you may encounter a problem that does not work dropdown select field(like this https://github.com/theforeman/foreman_datacenter/issues/12 or this https://github.com/theforeman/foreman_datacenter/issues/9)

Please make assets precompilation manually as following in foreman installation dir:
```
foreman-rake assets:precompile
```

We are working on this problem

## Contributing

Fork and send a Pull Request. Thanks!

## Copyright

Copyright (c) *cloudevelops, Inc.*

Authors: *Pavel Ivanov* and *Eugene Loginov*

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
