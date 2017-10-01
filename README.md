# shorewall-merged

Manage shorewall and shorewall6 files with a "don't repeat yourself" approach

# What it does

It produces a shorewall configuration and a shorewall6 configuration, from common and specific information, reducing the work required to maintain a dual-stack firewall.

# How it works

* output configuration are in build
* there is one output configuration for shorewall and shorewall6
* each file in raw-common folder is copied to both shorewall and shorewall6 output configuration
* each file in raw-shorewall folder is appened to the config file in shorewall output
* each file in raw-shorewall6 folder is appened to the config file in shorewall6 output
* the host names and their ip are managed centrally, and dispatched in params for each target
* zones and interfaces and their configuration are managed centrally and dispatched in zones and interfaces for each target

# How to use

* edit the raw files
* add your hosts and addresses in processed/addresses
* add your interfaces and options in processed/interfaces
* run bin/merge.sh
