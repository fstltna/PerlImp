#!/bin/bash
echo "Loading required extensions..."
set -vx # Echo commands & output
/usr/bin/perl -MCPAN -e 'install Gtk2::GladeXML::OO'
/usr/bin/perl -MCPAN -e 'install Net::Telnet'
/usr/bin/perl -MCPAN -e 'install Storable'
/usr/bin/perl -MCPAN -e 'install Readonly'
exit (0)
