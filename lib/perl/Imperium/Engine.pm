package Imperium::Engine;

# Pragmas --------------------------------------------------------------
use warnings;
use strict;	

# External libraries ---------------------------------------------------

#=======================================================================
sub new {
	my ($class) = @_;
	
	my $self = bless { }, $class;
	$self->init;
	
	return $self;
}
#=======================================================================
sub init {
	my ($self) = @_;
	
	$::GUI_MainInput->signal_connect( event =>
        sub {
			# Act only on return... ------------------------------------
            return if $_[1]->type ne q/key-release/ or $_[1]->keyval != Gtk2::Gdk->keyval_from_name( q[Return] );

			# Set text in a TextView -----------------------------------
            $::GUI_Terminal ->get_buffer->set_text( $::GUI_MainInput->get_text ); 
            
            # Clear user input -----------------------------------------
            $::GUI_MainInput->set_text( q[] );

			# Always "return;" ...and never "return 1;" ----------------
            return;
        }
    );
}
#=======================================================================

1;
