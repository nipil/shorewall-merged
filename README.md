# shorewall-merged

Manage shorewall and shorewall6 files with a "don't repeat yourself" approach

# What it does

It produces a `shorewall` configuration and a `shorewall6` configuration, from common and specific information, reducing the work required to maintain a dual-stack firewall.

# How it works

* output configuration are in `build`
* there is one output configuration for `shorewall` and one for `shorewall6`
* each file in `raw-common` folder is copied to both `shorewall` and `shorewall6` output configuration
* each file in `raw-shorewall` folder is appended to the config file in `shorewall` output
* each file in `raw-shorewall6` folder is appended to the config file in `shorewall6` output
* the host names and their ip are defined in `processed/addresses` and appended to `shorewall/params` and `shorewall6/params`
* zones and interfaces and defined in `processed/interfaces` and appended to `shorewall/zones`, `shorewall6/zones`, `shorewall/interfaces`, `shorewall6/interfaces`

# How to use

* edit the files in `raw-*`
* add your hosts and addresses in `processed/addresses`
* add your interfaces and options in `processed/interfaces`
* run `bin/merge.sh`

# Then what ?

Once your configurations are generated, you can push them to your firewall(s).

## if your firewall uses `shorewall` and `shorewall6`

* push the files in `build/shorewall` to your firewall's `/etc/shorewall` folder
* push the files in `build/shorewall6` to your firewall's `/etc/shorewall6` folder
* run `sudo shorewall check` on your firewall
* run `sudo shorewall6 check` on your firewall
* run `sudo shorewall restart` on your firewall
* run `sudo shorewall6 restart` on your firewall

This can be done using the helper script :

    bin/apply-full.sh FWHOST1 FWHOST2 FWHOST3 ...

## if your firewall uses `shorewall-lite` and `shorewall6-lite`

Pre-requisites :

* `LOGFILE` must be defined in the configuration of `shorewall-lite` and `shorewall6-lite` on each remote firewall : you can install `rsyslog` on each remote firewall and use `/var/log/syslog` as `LOGFILE`

To apply on a remote host named `FIREWALLHOST` which you can reach as `root` using SSH :

* run `shorewall remote-start -c build/shorewall FIREWALLHOST` on your computer
* run `shorewall6 remote-start -c build/shorewall6 FIREWALLHOST` on your computer

This can be done using the helper script :

    bin/apply-lite.sh FWHOST1 FWHOST2 FWHOST3 ...
