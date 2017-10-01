# shorewall-merged

Manage shorewall and shorewall6 files with a "don't repeat yourself" approach

# What it does

It produces a `shorewall` configuration and a `shorewall6` configuration, from common and specific information, reducing the work required to maintain a dual-stack firewall.

# How it works

* output configuration are in `build`
* there is one output configuration for `shorewall` and one for `shorewall6`
* each file in `raw-common` folder is copied to both `shorewall` and `shorewall6` output configuration
* each file in `raw-shorewall` folder is appened to the config file in `shorewall` output
* each file in `raw-shorewall6` folder is appened to the config file in `shorewall6` output
* the host names and their ip are defined in `processed/addresses` and dispatched in `shorewall/params` and `shorewall6/params`
* zones and interfaces and defined in `processed/interfaces` and dispatched in `shorewall/zones`, `shorewall6/zones`, `shorewall/interfaces`, `shorewall6/interfaces`

# How to use

* edit the files in `raw-*`
* add your hosts and addresses in `processed/addresses`
* add your interfaces and options in `processed/interfaces`
* run `bin/merge.sh`
