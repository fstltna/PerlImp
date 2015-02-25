#!/usr/bin/perl

# Pragmas --------------------------------------------------------------
use warnings;
use strict;
use lib qw( ../lib/perl );

# External libraries ---------------------------------------------------
use Gtk2 -init;
use Gtk2::GladeXML::OO;
use Net::Telnet;
use Storable;

# Internal libraries ---------------------------------------------------
use Imperium::Main;
#=======================================================================

# Initialization of Gtk2 objects ---------------------------------------
our $Glade = Gtk2::GladeXML::OO->new('../lib/glade/PerlImp.glade');
$Glade->signal_autoconnect_from_package('main');
$Glade->load_objects;

# Main object ----------------------------------------------------------
our $Main = Imperium::Main->new;

# Handle audio
if (-e "/usr/bin/afplay") {	# On a Mac
	system("(afplay ../lib/perl/Imperium/theme.mp3 &)");
}
elsif (-e "/usr/bin/vlc") {	# On Linux
	system("(/usr/bin/vlc ../lib/perl/Imperium/theme.mp3 &)");
}

#=======================================================================
Gtk2->main;
exit 0;
#=======================================================================

