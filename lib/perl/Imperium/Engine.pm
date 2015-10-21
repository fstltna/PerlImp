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

	# Update GUI status -------------------------------------------------
	$::GUI_StatusField->set_text( "Online" );
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
				if (($txt =~ /^\:/) || ($txt =~ /!\$/) || ($txt =~ /:Enter player name:/))
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
#=======================================================================
#removes unneeded text
sub cleanText{
	my ($txt, $n) = @_;
	my $data = substr($txt,index($txt,$n) + 3);
	$data =~ s/\s//g;
	$n = quotemeta $n;
	$data =~ s/$n/REP/;
	$data =~ s/!.*//g;
	return $data;
}
#=======================================================================
#extracts ship number and T
sub getShipNT{
	my (@arrdata) = @_;
	my $shipn = substr($arrdata[0],0,length($arrdata[0])-1) + 0;
	my $shipt = substr($arrdata[0],length($arrdata[0])-1);
	return ($shipn, $shipt);	
}
#=======================================================================
sub processServerOutput{
	my ($txt,$self) = @_;
	if($txt =~ /!\$/)
	{
		#process ship codes
		my $data = "";
		my $line = "";
		my $found = 0;
		my $storedship = "";
		if($txt =~ /!\$1/){	#status line
			$data = cleanText($txt, "\!\$1");
			my @datalines = split("REP", $data);
			foreach $line (@datalines){
				my @arrdata = split('\|', $line);

				my $shipn = 0;
				my $shipt = 0;
				($shipn, $shipt) = getShipNT(@arrdata);	
				#find if ship data exist or create new one
				my $ship = "";
				foreach $storedship ($::Main->{ ships}->list()){
					
					if(ref($storedship) =~ /Hash::AsObject/ && ($storedship->{ShipNumber} == $shipn)){
						$ship = $storedship;
						$found = 1;
						last;
					}
				}
				if($found == 0){
					$ship = $::Main->init_newShip();
				}
				$ship->ShipNumber( $shipn );
				$ship->ShipType( $shipt );
	
				my @shiprc = split(',', $arrdata[1]);
				$ship->sh_row( $shiprc[0] );
				$ship->sh_col( $shiprc[1] );

				$ship->F( $arrdata[2] );
				$ship->efficiency( $arrdata[3] );
				$ship->sh_tf( $arrdata[4] );
				$ship->energy( $arrdata[5] );
				$ship->fuelLeft( $arrdata[6] );
				$ship->armorLeft( $arrdata[7] );
				$ship->price( $arrdata[8] );
				$ship->planet( $arrdata[9] );
				$ship->name( $arrdata[10] ) if($arrdata[10]);
				if($found == 0){
					$::Main->{ ships }->push($ship);
				}
			}
		#----------------------------------------------------------
		}elsif($txt =~ /!\$2/){	#cargo line
			
			$data = cleanText($txt, "\!\$2");
			my @datalines = split("REP", $data);
			foreach $line (@datalines){
				my @arrdata = split('\|', $line);

				my $shipn = 0;
				my $shipt = 0;
				($shipn, $shipt) = getShipNT(@arrdata);	
				#find if ship data exist or create new one
				my $ship = "";
				foreach $storedship ($::Main->{ ships}->list()){
					if(ref($storedship) =~ /Hash::AsObject/ && $storedship->{ShipNumber} == $shipn){
						$ship = $storedship;
						$found = 1;
						last;
					}
				}
				if($found == 0){
					$ship = $::Main->init_newShip();
				}
				$ship->ShipNumber( $shipn );
				$ship->ShipType( $shipt );

				$ship->cargo_Avl( $arrdata[1] );
				$ship->num_civ( $arrdata[2] );
				$ship->num_sci( $arrdata[3] );
				$ship->num_mil( $arrdata[4] );
				$ship->num_ofc( $arrdata[5] );
				$ship->num_misl( $arrdata[6] );
				$ship->cargo_Pln( $arrdata[7] );
				$ship->num_ore( $arrdata[8] );
				$ship->num_gold( $arrdata[9] );
				$ship->num_airt( $arrdata[10] );
				$ship->num_ftnk( $arrdata[11] );
				$ship->num_comp( $arrdata[12] );
				$ship->num_eng( $arrdata[13] );
				$ship->num_life( $arrdata[14] );
				$ship->num_elect( $arrdata[15] );
				$ship->num_wpn( $arrdata[16] );
				if($found == 0){
					$::Main->{ ships }->push($ship);
				}
			}
		#----------------------------------------------------------
		}elsif($txt =~ /!\$3/){	#others
			
			#parseText
			$data = cleanText($txt, "\!\$3");
			
		#----------------------------------------------------------
		}elsif($txt =~ /!\$4/){	#config line
			
			$data = cleanText($txt, "\!\$4");
			my @datalines = split("REP", $data);
			foreach $line (@datalines){
				my @arrdata = split('\|', $line);

				my $shipn = 0;
				my $shipt = 0;
				($shipn, $shipt) = getShipNT(@arrdata);	
				#find if ship data exist or create new one
				my $ship = "";
				foreach $storedship ($::Main->{ ships}->list()){
					if(ref($storedship) =~ /Hash::AsObject/ && $storedship->{ShipNumber} == $shipn){
						$ship = $storedship;
						$found = 1;
						last;
					}
				}
				if($found == 0){
					$ship = $::Main->init_newShip();
				}
				$ship->ShipNumber( $shipn );
				$ship->ShipType( $shipt );
			
				my @shiprc = split(',', $arrdata[1]);
				$ship->sh_row( $shiprc[0] );
				$ship->sh_col( $shiprc[1] );
			
				$ship->F( $arrdata[2] );
				$ship->energy( $arrdata[3] );
				$ship->shields( $arrdata[4] );
				$ship->shieldsKeep( $arrdata[5] );
				$ship->config_DAK( substr($arrdata[6],0,1) . " " . substr($arrdata[6],1,1) . " " . substr($arrdata[6],2,1));
				if($found == 0){
					$::Main->{ ships }->push($ship);
				}
			}
		}
		$::GUI_Terminal->get_buffer->insert_at_cursor( $txt);
		#update ship census window
		updateShipWindow();
	}
	elsif ($txt =~ ":")
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
		elsif ($txt =~ /^:Enter player password/)
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
	}else{
		# One of the other intros
		$::GUI_Terminal->get_buffer->insert_at_cursor( $txt);
	}

}

#=======================================================================
sub addbuttons{
	my ($VBox, @vals) = @_;
	my $hbox = Gtk2::HBox->new (0, 0);
	
	my $button = "";
	my $header = "";
	foreach my $val (@vals){
		$button = Gtk2::Button->new($val);
		$button->set_size_request(50, 15);
		$button->set_focus_on_click(0);
		$hbox->pack_start($button, 1, 1, 0);
		$button->show;	
	}
	$VBox->pack_start($hbox,1,1,0);
	$hbox->show_all;
}

sub addlabel{
	my ($VBox,$value) = @_;
	my $titlelabel = Gtk2::Label->new($value);
	$titlelabel->set_text($value);
	$VBox->pack_start($titlelabel,1,1,0);
	$titlelabel->show;
}

#=======================================================================
sub updateShipWindow{
	my $VBox = Gtk2::VBox->new(0, 0);
	
	#create status rows
	addlabel($VBox, "Ship Status");
	my @statusHeaders = ("Ship#","T","Owner","Row","Col","F","Eff","TF","Energ","Fuel","Armor","Price","Planet","Name");
	addbuttons($VBox, @statusHeaders);
	foreach my $ship ($::Main->{ ships}->list()){
		if(ref($ship) =~ /Hash::AsObject/ && $ship->ShipType){
			my @statusVals = ($ship->ShipNumber,$ship->ShipType,$ship->owner,$ship->sh_row,$ship->sh_col,$ship->F,$ship->efficiency,$ship->sh_tf,$ship->energy,$ship->fuelLeft,$ship->armorLeft,$ship->price,$ship->planet,$ship->name);
			addbuttons($VBox, @statusVals);
		}
	}
	#----------------------------------------------------------
	#create cargo rows
	addlabel($VBox, "Ship Cargo");
	my @cargoHeaders = ("Ship#","T","Avl","Civ","Sci","Mil","Off","Mis","Pln","Ore","Bar","Air","FTn","Cmp","Eng","Lif","Ele","Wpn");
	addbuttons($VBox, @cargoHeaders);
	foreach my $ship ($::Main->{ ships}->list()){
		if(ref($ship) =~ /Hash::AsObject/ && $ship->ShipType){
			my @cargoVals = ($ship->ShipNumber,$ship->ShipType,$ship->cargo_Avl,$ship->num_civ,$ship->num_sci,$ship->num_mil,$ship->num_ofc,$ship->num_misl,$ship->cargo_Pln,$ship->num_ore,$ship->num_gold,$ship->num_airt,$ship->num_ftnk,$ship->num_comp,$ship->num_eng,$ship->num_life,$ship->num_elect,$ship->num_wpn);
			addbuttons($VBox, @cargoVals);
		}
	}
	#----------------------------------------------------------
	#create config rows
	addlabel($VBox, "Ship Config");
	my @configHeaders = ("Ship#","T","Row","Col","F","Energ","Shld","ShLev","D A K");
	addbuttons($VBox, @configHeaders);
	foreach my $ship ($::Main->{ ships}->list()){
		if(ref($ship) =~ /Hash::AsObject/ && $ship->ShipType){
			my @configVals = ($ship->ShipNumber,$ship->ShipType,$ship->sh_row,$ship->sh_col,$ship->F,$ship->energy,$ship->shields,$ship->shieldsKeep,$ship->config_DAK);
			addbuttons($VBox, @configVals);
		}
	}
	#----------------------------------------------------------
	$::ShipView->get_child->destroy;
	$::ShipView->add($VBox);
	$VBox->show_all;	
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
	# Update GUI status -------------------------------------------------
	$::GUI_StatusField->set_text( "Offline" );
	
	# Reset terminal ---------------------------------------------------
	$::GUI_Terminal->get_buffer->set_text( q[] );
	
	# Reset menu options -----------------------------------------------
	$::OpenConMenuItem->set_sensitive ( 1 );
	$::CloseConMenuItem->set_sensitive( 0 );
	
	return;
}
#=======================================================================

1;
