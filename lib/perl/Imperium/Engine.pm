package Imperium::Engine;

# Pragmas --------------------------------------------------------------
use warnings;
use strict;	

# External libraries ---------------------------------------------------
use Gtk2::Ex::Dialogs ( 
	destroy_with_parent => 1, 
	modal 				=> 1, 
	no_separator 		=> 0 
);
#use Net::Telnet;
use IO::Select;
use IO::Socket::INET;
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
	
	#-------------------------------------------------------------------
	$::GUI_Terminal->signal_connect( 'size-allocate' =>
		sub {
			my $adj = $::GUI_MainDisplayWindow->get_vadjustment;
			$adj->set_value( $adj->upper - $adj->page_size );
			return;
		}
	);
	#-------------------------------------------------------------------
	$::GUI_MainInput->signal_connect( event =>
        sub {
			# We have nothing to do in this situation... ---------------
			return unless $self->{ sock };
			
			# Act only on return... ------------------------------------
            return if $_[1]->type ne q/key-release/ or $_[1]->keyval != Gtk2::Gdk->keyval_from_name( q[Return] );

			# Set text in a TextView -----------------------------------
			my $txt = $::GUI_MainInput->get_text() . "\n";
            $::GUI_Terminal->get_buffer->insert_at_cursor( $txt );
            
            # Clear user input -----------------------------------------
            $::GUI_MainInput->set_text( q[] );

			# Send message to a server ---------------------------------
			my @ready = $self->{ sock }->can_write();
			my $sock = shift @ready;
			$sock->syswrite( $txt );
			
			# Always "return;" ...and never "return 1;" ----------------
            return;
        }
    );
    #-------------------------------------------------------------------
}
#=======================================================================
sub openConnect {
	my ($self) = @_;
	
	# Connect to the server --------------------------------------------
	my $sock = IO::Socket::INET->new(
	PeerAddr => $::Main->active->ServerHost,
        PeerPort => $::Main->active->ServerPort,
        Proto    => 'tcp'
	) or return Gtk2::Ex::Dialogs::ErrorMsg->new_and_run( 
		icon	=> q/error/,
		title 	=> 	"Error while connecting...",
		text 	=> 	"<span color='#a00'>Cannot connect to server!</span>\n\n$@"
	);
	
	# Set the menu options ---------------------------------------------
	$::OpenConMenuItem ->set_sensitive(0);
	$::CloseConMenuItem->set_sensitive(1);
	
	# Show messages from server ----------------------------------------
	$self->{ sock } = IO::Select->new( $sock );
	
	$self->{ hid } = Glib::Timeout->add( 1000,
		sub {
			return unless $self->{ sock };
			
			while( my @ready = $self->{ sock }->can_read( 0 ) ){
				last unless scalar( @ready );
				my $sock = shift @ready;
				$sock->sysread( my $txt, 1000 );
				return 1 unless length( $txt );
				# Check for our introduction leaders
				if (($txt =~ /^\:/) || ($txt =~ /^\!/) || ($txt =~ /:Enter player name:/))
				{
					# Saw one of them, so parse it
					processServerOutput($txt,$self);
				}
				else
				{
					# None, so send all output
					$::GUI_Terminal->get_buffer->insert_at_cursor( $txt );					
				}
			}
			return 1;
		}
	);
	
	return;
}

sub processServerOutput{
	my ($txt,$self) = @_;
	if ($txt =~ ":")
	{
		# Was password or player prompt
		if ($txt =~ /:Enter player name:/)
		{	
			$txt = ($txt . $::Main->active->PlayerName . "\n");
			$::GUI_Terminal->get_buffer->insert_at_cursor( substr($txt, 1) );
			if ($::Main->active->PlayerName ne "")
			{
				my @ready = $self->{ sock }->can_write();
				my $sock = shift @ready;
				$sock->syswrite( $::Main->active->PlayerName . "\n" );
			}
		}
		elsif ($txt =~ /^:Enter player password:/)
		{
			if ($::Main->active->PlayerPswd ne "")
			{
				$txt = ($txt . "*******\n");
				$::GUI_Terminal->get_buffer->insert_at_cursor( substr($txt, 1) );	
				my @ready = $self->{ sock }->can_write();
				my $sock = shift @ready;
				$sock->syswrite( $::Main->active->PlayerPswd  . "\n");
			}else
			{
				$::GUI_Terminal->get_buffer->insert_at_cursor( substr($txt, 1) );
			}
		}
		else
		{
			$::GUI_Terminal->get_buffer->insert_at_cursor( $txt);
		}
	}
	else
	{
		# One of the other intros
	}

}
#=======================================================================
sub connected {
	return $_[0]->{ sock } ? 1 : 0;
}
#=======================================================================
sub closeConnect {
	my ($self) = @_;

	# Close socket -----------------------------------------------------
	my ($sock) = $self->{ sock }->handles;
	delete( $self->{ sock } )->remove( $sock );
	$sock->close;
	
	# Reset terminal ---------------------------------------------------
	$::GUI_Terminal->get_buffer->set_text( q[] );
	
	# Reset menu options -----------------------------------------------
	$::OpenConMenuItem->set_sensitive ( 1 );
	$::CloseConMenuItem->set_sensitive( 0 );
	
	return;
}
#=======================================================================

1;
