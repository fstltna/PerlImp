#!/bin/bash
echo "Loading required extensions..."
set -vx # Echo commands & output
/usr/bin/perl -MCPAN -e 'install Gtk2::Ex::Utils'
/usr/bin/perl -MCPAN -e 'install Gtk2::GladeXML::OO'
/usr/bin/perl -MCPAN -e 'install Net::Telnet'
/usr/bin/perl -MCPAN -e 'install Storable'
/usr/bin/perl -MCPAN -e 'install Readonly'
/usr/bin/perl -MCPAN -e 'install File::Type'
/usr/bin/perl -MCPAN -e 'install Config::Tiny'
/usr/bin/perl -MCPAN -e 'install Class::Accessor::Fast'
/usr/bin/perl -MCPAN -e 'install Hash::AsObject'
/usr/bin/perl -MCPAN -e 'install Array::AsObject'
/usr/bin/perl -MCPAN -e 'install Text::Table'
exit(0)
