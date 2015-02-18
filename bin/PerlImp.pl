#!/usr/bin/perl

# Pragmas --------------------------------------------------------------
use warnings;
use strict;
use lib qw( ../lib/perl );

# External libraries ---------------------------------------------------
use Gtk2 -init;
use Gtk2::GladeXML::OO;
use Net::Telnet;

# Internal libraries ---------------------------------------------------
use Imperium::Main;
#=======================================================================

# Initialization of Gtk2 objects ---------------------------------------
our $Glade = Gtk2::GladeXML::OO->new('../lib/glade/PerlImp.glade');
$Glade->signal_autoconnect_from_package('main');
$Glade->load_objects;

# Main object ----------------------------------------------------------
our $Main = Imperium::Main->new;

#=======================================================================
Gtk2->main;
exit 0;
#=======================================================================

