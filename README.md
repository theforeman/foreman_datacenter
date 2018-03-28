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

## Installation

See [Plugins Installation](https://theforeman.org/plugins/#2.Installation) for how to install Foreman plugins.

NOTE: after the plugin is installed you have to precompile assets!

## Usage

### Create a device type

Here you can create a particular device type, for example a model of switch and then create all interfaces only here, so when you create a particular switch, it will have all the desired interfaces. Just click on **Device types** -> **New device type**, fill in information and save. Then click on the desired device type and you can add all the interfaces here.

### Create a device

You can either just create a device - then you have to create first Manufacturer, Device Type, Device Role, Platform; or you can import device from Puppet facts (this feature is still in development phase) - you just click **Devices** -> **Import from host** and then will search your host and click **Import to device**. Then you will get a page with additional information about the machine to be filled like location, position in rack, etc. Once device is created, you can list it in **Devices** section and when you click on this device, you can fill in additional information, e.g. connect its interfaces to a switch, etc.

### Possible problem

Sometimes you may encounter a problem that does not work dropdown select field(like this https://github.com/theforeman/foreman_datacenter/issues/12 or this https://github.com/theforeman/foreman_datacenter/issues/9)

Please make assets precompilation manually.

We are working on this problem

## Contributing

Fork and send a Pull Request. Thanks!

## Copyright

Copyright (c) *cloudevelops, Inc.*

Authors: *Pavel Ivanov* and *Eugene Loginov*

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
