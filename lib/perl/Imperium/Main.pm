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
		title 	=> "End of work...",
		text 	=> "<span color='#a00'>Are you really want to quit?</span>"
	);

	return Gtk2->main_quit;
}
#======================================================================
1;
