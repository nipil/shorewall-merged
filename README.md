# shorewall-merged

Manage shorewall and shorewall6 files with a "don't repeat yourself" approach

# What it does

It produces a shorewall configuration and a shorewall6 configuration, from common and specific information, reducing the work required to maintain a dual-stack firewall.

# How it works

* output configuration are in build
* there is ont output configuration for shorewall and shorewall6
* each file in raw-common folder is copied to both shorewall and shorewall6 output configuration
* each file in raw-shorewall folder is appened to the config file in shorewall output
* each file in raw-shorewall6 folder is appened to the config file in shorewall6 output
* the host names and their ip are managed centrally, and dispatched in the appropriate targets
* zones and interfaces and their configuration are managed centrally and dispatched to the appropriate targets
