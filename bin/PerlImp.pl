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
use Imperium::Audio;
use Imperium::Engine;
use Imperium::Main;
#=======================================================================

# Initialization of Gtk2 objects ---------------------------------------
our $Glade = Gtk2::GladeXML::OO->new('../lib/glade/PerlImp.glade');
$Glade->signal_autoconnect_from_package('main');
$Glade->load_objects;

# Singletons -----------------------------------------------------------
our $Main  	= Imperium::Main->new;
our $Audio 	= Imperium::Audio->new; 
our $Engine	= Imperium::Engine->new;
#=======================================================================
Gtk2->main;
exit 0;
#=======================================================================

