package Imperium::Main;

# Pragmas --------------------------------------------------------------
use warnings;
use strict;
# External libraries ---------------------------------------------------
use Gtk2;
use Gtk2::Ex::Dialogs ( 
	destroy_with_parent => 1, 
	modal 				=> 1, 
	no_separator 		=> 0 
);
#=======================================================================
# Global Vars
my $DEFAULTSERVER = "empiredirectory.net";
my $DEFAULTSERVERPORT = "3458";

# Create Defs
my $ConfServerHost = $DEFAULTSERVER;
my $ConfServerPort = $DEFAULTSERVERPORT;
my $ConfPlayerName = "";
my $ConfPlayerPswd = "";
my $LastSavedServerHost = "";
my $LastSavedServerPort = "";
my $LastSavedPlayerName = "";
my $LastSavedPlayerPswd = "";
#=======================================================================
sub new { 
	my ($class) = @_;
	
	my $self = bless { }, $class; 
	
	return $self;
}
#=======================================================================
sub quit { 
	my ($self) = @_;
	
	return unless Gtk2::Ex::Dialogs::Question->ask(
		icon	=> q/question/,
		title 	=> "Exit PerlImp?",
		text 	=> "<span color='#a00'>Do you really want to quit?</span>",
		resizeable  => 0	# ZZZ What should this be?
	);

	return Gtk2->main_quit;
}
#======================================================================
# Resets the server settings to default
sub resetDefaults {
	$ConfServerHost = $DEFAULTSERVER;
	$ConfServerPort = $DEFAULTSERVERPORT;
	$ConfPlayerName = "";
	$ConfPlayerPswd = "";
}
#======================================================================
# Resets the server settings to last saved
sub resetLastSaved {
	$ConfServerHost = $LastSavedServerHost;
	$ConfServerPort = $LastSavedServerPort;
	$ConfPlayerName = $LastSavedPlayerName;
	$ConfPlayerPswd = $LastSavedPlayerPswd;
	#PrefWindow->hide()	# ZZZ How to do this?
}
#======================================================================
1;
