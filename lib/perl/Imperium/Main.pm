package Imperium::Main;

# Pragmas --------------------------------------------------------------
use warnings;
use strict;	
use base qw( Class::Accessor::Fast );

# External libraries ---------------------------------------------------
use Clone qw( clone );
use Gtk2;
use Gtk2::Ex::Dialogs ( 
	destroy_with_parent => 1, 
	modal 				=> 1, 
	no_separator 		=> 0 
);

use Hash::AsObject;
use Storable;
#=======================================================================
Imperium::Main->mk_accessors( qw( vars defs default planets ships active ) );
#=======================================================================
sub new { 
	my ($class) = @_;
	
	my $self = bless { }, $class; 
	$self->init_cfg;
	$self->init_gui;
	
	return $self;
}
#=======================================================================
sub init_cfg {
	my ($self) = @_;
	
	# Global Vars
	$self->{ vars } = Hash::AsObject->new(
		DEFAULTSERVER 		=> "empiredirectory.net",
		DEFAULTSERVERPORT 	=> "3458",
		BaseFileName 		=> "Basename",	# What the left part of the file name should be
		BaseFilePath 		=> "/usr/bin/",	# What the path should be
		DirtyData 			=> 0,
		AtMainPrompt 		=> 0,
		QueueOk 			=> 1,
		QueueEcho 			=> 1,
		StopQueue 			=> 0,
		NumCmds 			=> 0,
		Game_Time 			=> 0,
		Game_BTUs 			=> 0,
		GameSocket 			=> -1,
		ConnectGood 		=> 0,
		ActiveConnection 	=> "",
	);
	
	
	# Create Defs
	$self->{ defs } = Hash::AsObject->new(	
		ConfServerHost 		=> $self->vars->DEFAULTSERVER,
		ConfServerPort 		=> $self->vars->DEFAULTSERVERPORT,
		ConfPlayerName 		=> "",
		ConfPlayerPswd 		=> "",
		LastSavedServerHost => "",
		LastSavedServerPort => "",
		LastSavedPlayerName => "",
		LastSavedPlayerPswd => "",
	);

	# Main App Settings
	$self->{ default } = Hash::AsObject->new(	
		ServerHost			=> $self->vars->DEFAULTSERVER,
		ServerPort			=> $self->vars->DEFAULTSERVERPORT,
		PlayerName			=> '',
		PlayerPswd			=> '',
		GameVersion 		=> 1,
		GameDesc			=> '',
		SizeX				=> 255,
		SizeY				=> 255,
		NextShip			=> 0,
		LastShip			=> 0,
		NextPlanet			=> 0,
		LastPlanet			=> 0,
		LastX				=> 0,
		LastY				=> 0,
		NextItem			=> 0,
		HomePlanet			=> 0,
		HomeRow				=> 0,
		HomeCol				=> 0,
		PlayerNum			=> 0
	);

	# Planet table definitions 
	$self->{ planets } = Hash::AsObject->new(	
		flags => 0,			# Bitfield - See above for meanings
		last_seen => '',	# When the planet was last seen
		class => '',		# What planet class
		size => 0,			# Planet size
		eff => 0,			# Efficiency
		polut => 0,			# Polution level
		minr => 0,			# Minerals
		gold => 0,			# Richness of gold
		water => 0,			# Pct water
		gas => 0,			# Pct gas
		mobil => 0,			# Mobility units
		PopPct => 0,		# Population percent
		PF => 0,			# Plague factor
		TF => 0,			# Tech factor
		xfer => 0,			# How the planet was transferred
		owner => 0,			# Planet owner
		lstOwn => 0,		# Previous owner
		plgStg => 0,		# Plague stage
		RF => 0,			# Research Factory
		ResLv => 0,			# Research level
		TechLv => 0,		# Technology level
		pl_row => 0,		# Location (row)
		pl_col => 0,		# Location (col)
		pl_btu => 0,		# BTUs
		prod_civ => 0,		# prod[PPROD_LAST + 1], /* Production points/type     */
		prod_mil => 0,		# prod[PPROD_LAST + 1], /* Production points/type     */
		prod_tech => 0,		# prod[PPROD_LAST + 1], /* Production points/type     */
		prod_research => 0,	# prod[PPROD_LAST + 1], /* Production points/type     */
		prod_educ => 0,		# prod[PPROD_LAST + 1], /* Production points/type     */
		prod_ocs => 0,		# prod[PPROD_LAST + 1], /* Production points/type     */
		prod_oremine => 0,	# prod[PPROD_LAST + 1], /* Production points/type     */
		prod_goldmine => 0,	# prod[PPROD_LAST + 1], /* Production points/type     */
		prod_airtank => 0,	# prod[PPROD_LAST + 1], /* Production points/type     */
		prod_fueltank => 0,	# prod[PPROD_LAST + 1], /* Production points/type     */
		prod_weapons => 0,	# prod[PPROD_LAST + 1], /* Production points/type     */
		prod_engines => 0,	# prod[PPROD_LAST + 1], /* Production points/type     */
		prod_hull => 0,		# prod[PPROD_LAST + 1], /* Production points/type     */
		prod_missle => 0,	# prod[PPROD_LAST + 1], /* Production points/type     */
		prod_planes => 0,	# prod[PPROD_LAST + 1], /* Production points/type     */
		prod_electronics => 0,		# prod[PPROD_LAST + 1], /* Production points/type     */
		prod_cash => 0,		# prod[PPROD_LAST + 1], /* Production points/type     */
		quant_civ => 0,		# quant[IT_LAST + 1];   /* Items on planet            */
		quant_sci => 0,		# quant[IT_LAST + 1];   /* Items on planet            */
		quant_mil => 0,		# quant[IT_LAST + 1];   /* Items on planet            */
		quant_off => 0,		# quant[IT_LAST + 1];   /* Items on planet            */
		quant_misl => 0,	# quant[IT_LAST + 1];   /* Items on planet            */
		quant_planes => 0,	# quant[IT_LAST + 1];   /* Items on planet            */
		quant_ore => 0,		# quant[IT_LAST + 1];   /* Items on planet            */
		quant_bars => 0,	# quant[IT_LAST + 1];   /* Items on planet            */
		quant_airTanks => 0,	# quant[IT_LAST + 1];   /* Items on planet            */
		quant_fuelTanks => 0,	# quant[IT_LAST + 1];   /* Items on planet            */
		quant_comput => 0,	# quant[IT_LAST + 1];   /* Items on planet            */
		quant_engines => 0,	# quant[IT_LAST + 1];   /* Items on planet            */
		quant_lifeSupp => 0,	# quant[IT_LAST + 1];   /* Items on planet            */
		quant_elect => 0,	# quant[IT_LAST + 1];   /* Items on planet            */
		quant_weapons => 0,	# quant[IT_LAST + 1];   /* Items on planet            */
		quant_civ => 0,		# quant[IT_LAST + 1];   /* Items on planet            */
		workPer_civ => 0,	# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
		workPer_sci => 0,	# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
		workPer_mil => 0,	# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
		workPer_off => 0,	# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
		workPer_misl => 0,	# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
		workPer_planes => 0,	# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
		workPer_ore => 0,	# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
		workPer_bars => 0,	# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
		workPer_airTanks => 0,		# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
		workPer_fuelTanks => 0,	# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
		workPer_comput => 0,	# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
		workPer_engines => 0,	# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
		workPer_lifeSup => 0,	# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
		workPer_elect => 0,	# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
		workPer_weapons => 0,	# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
		name => '',				# Name of planet
		chkpoint => ''			# Planet checkpoint
	);

	# Ship table definitions
	$self->{ ships } = Hash::AsObject->new(	
		flags => 0,			# Bitfield - See above for meanings
		last_seen => '',	# When the planet was last seen
		ShipType => '',		# st_a -> st_m
		planet => 0,		# What planet it is on, if any
		fuelLeft => 0,		# fuel left
		cargo => 0,			# current cargo amount
		armourLeft => 0,	# Armor left on hull
		sh_row => 0,		# What row it is in 
		sh_col => 0,		# What col it is in 
		shields => 0,		# energy in shields 
		shieldsKeep => 0,	# energy to maintain in shields
		airLeft => 0,		# Amount of air left
		energy => 0,		# Energy left       
		sh_tf => 0,			# Global tech factor
		fleet => '',		# Fleet it is in    
		efficiency => 0,	# Efficiency        
		owner => 0,			# Who owns it       
		plagueStage => 0,	# What stage of the plague is it in
		hullTF => 0,		# Hull tech factor
		engTF => 0,			# Engine tech factorr
		engEff => 0,		# Engine efficiency
		name => '', 		# Ship name, if any
		num_torp => 0,		# Number of torps on board
		num_ore => 0,		# Amount of ore on board
		num_gold => 0,		# Amount of gold bars on board
		num_civ => 0,		# Civilians
		num_sci => 0,		# Scientists
		num_mil => 0,		# Military
		num_ofc => 0,		# Officers
		num_misl => 0,		# Missles
		num_airt => 0,		# Air tanks
		num_ftnk => 0,		# Fuel tanks
		num_comp => 0,		# Computers
		num_eng => 0,		# Engines
		num_life => 0,		# Life support
		num_wpn => 0,		# Weapons
		num_elect => 0		# Electronics
	);
	
	#-------------------------------------------------------------------
	$self->active( clone( $self->default ) );
	#-------------------------------------------------------------------
	
	return;
}
#=======================================================================
sub init_gui {
	my ($self) = @_;
	
	# Set font for a terminal view -------------------------------------
	$::GUI_Terminal->modify_font(
        Gtk2::Pango::FontDescription->from_string( 'monospace' )
    );
	
	# Set base foldersr ------------------------------------------------
	my $dir = Glib::get_home_dir();
	$::FileSaveChooser->set_current_folder($dir);
	$::FileOpenChooser->set_current_folder($dir);
	
	# Set filter -------------------------------------------------------
	my $filter = Gtk2::FileFilter->new();
	$filter->add_pattern( '*.perlimp'				);
	$filter->set_name	( 'Imperium   (*.perlimp)'	);
	
	$::FileSaveChooser->add_filter( $filter );
	$::FileOpenChooser->add_filter( $filter );
	
	#-------------------------------------------------------------------
	return;
}
#=======================================================================
sub quit { 
	my ($self) = @_;
	
	return unless Gtk2::Ex::Dialogs::Question->ask(
		icon	=> q/question/,
		title 	=> "Exit PerlImp?",
		text 	=> "<span color='#a00'>Do you really want to quit?</span>"
	);

	return Gtk2->main_quit;
}
#======================================================================
# Resets the server settings to default
sub resetDefaults {
	my ($self) = @_;
	
	$self->active( clone( $self->default ) );
	$self->resetMenuState();
	
	return;
}
#======================================================================
# Resets the server settings to last saved
sub resetLastSaved {
	my ($self) = @_;
	
	$self->active->ServerHost( $self->defs->LastSavedServerHost );
	$self->active->ServerPort( $self->defs->LastSavedServerPort );
	$self->active->PlayerName( $self->defs->LastSavedPlayerName );
	$self->active->PlayerPswd( $self->defs->LastSavedPlayerPswd );
	
	$::ConfServerHost->set_text( $self->defs->LastSavedServerHost );
	$::ConfServerPort->set_text( $self->defs->LastSavedServerPort );
	$::ConfPlayerName->set_text( $self->defs->LastSavedPlayerName );
	$::ConfPlayerPswd->set_text( $self->defs->LastSavedPlayerPswd );
	
	$::PrefWindow->hide();
	
	return;
}
#======================================================================
# Load in data
sub loadData {
	my( $self ) = @_;
	
	#-------------------------------------------------------------------
	my $filter = Gtk2::FileFilter->new();
	$filter->set_name	( "PerlImp" );
	$filter->add_pattern( "*.plimp" );
	$::FileOpenChooser->add_filter( $filter );
	my $selectedFile = $::FileOpenChooser->get_filename;
	
	#-------------------------------------------------------------------
	if( $selectedFile ne "" ){
		my $WorkPos   = rindex($selectedFile, '/');
		$self->vars->BaseFilePath( substr($selectedFile, 0, $WorkPos + 1 ) );
		$self->vars->BaseFileName( substr($selectedFile,    $WorkPos + 1 ) );
		$WorkPos = rindex($self->vars->BaseFileName, '.');
		
		if ($WorkPos != 0 ) {
			$self->vars->BaseFileName( substr( $self->vars->BaseFileName, 0, $WorkPos ) );
		}
		chdir( $self->vars->BaseFilePath );
		
		$self->setConfiguredMenuState();
		
		# Load the data tables
		my $Planets = retrieve( $self->vars->BaseFileName . ".plan");
		die "Unable to retrieve planets from " . $self->vars->BaseFileName . ".plan!\n" unless defined $Planets;
		$self->planets( Hash::AsObject->new( $Planets ) );
		
		my $Ships = retrieve( $self->vars->BaseFileName . ".ship");
		die "Unable to retrieve ships from " . $self->vars->BaseFileName . ".ship!\n" unless defined $Ships;
		$self->ships( Hash::AsObject->new( $Ships ) );
		
		my $Globals = retrieve( $self->vars->BaseFileName . ".perlimp" );
		die "Unable to retrieve globals from " . $self->vars->BaseFileName . ".perlimp!\n" unless defined $Globals;
		$self->vars( Hash::AsObject->new( $Globals ) );
		
		$self->defs->LastSavedServerHost( $self->vars->DEFAULTSERVER 	 );
		$self->defs->LastSavedServerPort( $self->vars->DEFAULTSERVERPORT );
		$self->defs->LastSavedPlayerName( "" );
		$self->defs->LastSavedPlayerPswd( "" );
		
		$::FileOpenChooser->hide();
	}
}
#======================================================================
# Save data
sub saveData {
	my ($self) = @_;
	
	store $self->planets, 	$self->vars->BaseFileName . ".plan";
	store $self->ships, 	$self->vars->BaseFileName . ".ship";
	store $self->vars, 		$self->vars->BaseFileName . ".perlimp";
}
#======================================================================
# Save new data struct
sub fileSaveInit {
	my ($self) = @_;
	
	my $filter = Gtk2::FileFilter->new();
	$filter->set_name	( "PerlImp" );
	$filter->add_pattern( "*.plimp" );
	$::FileSaveChooser->add_filter($filter);
	my $selectedFile = $::FileSaveChooser->get_filename;
	
	if( $selectedFile ){
		my $WorkPos = rindex($selectedFile, '/');
		$self->vars->BaseFilePath( substr($selectedFile, 0, $WorkPos + 1) );
		$self->vars->BaseFileName( substr($selectedFile,    $WorkPos + 1) );
		$WorkPos = rindex( $self->vars->BaseFileName, '.' );
		if ($WorkPos != 0) {
			$self->vars->BaseFileName( substr($self->vars->BaseFileName, 0, $WorkPos ) );
		}
		chdir( $self->vars->BaseFilePath );
		
		#$Globals{$BaseFileName} = $Globals{"Default"};					# WTF?
		
		# Save the data tables
		$self->saveData();
		$self->setConfiguredMenuState();
		
		$::FileSaveChooser->hide();
	}
}
#======================================================================
sub loadConfigVars {
	my ($self) = @_;
	
	$self->defs->ConfServerHost( $::ConfServerHost->get_text );
	$self->defs->ConfServerPort( $::ConfServerPort->get_text );
	$self->defs->ConfPlayerName( $::ConfPlayerName->get_text );
	$self->defs->ConfPlayerPswd( $::ConfPlayerPswd->get_text );
	$self->defs->LastSavedServerHost( $::ConfServerHost->get_text );
	$self->defs->LastSavedServerPort( $::ConfServerPort->get_text );
	$self->defs->LastSavedPlayerName( $::ConfPlayerName->get_text );
	$self->defs->LastSavedPlayerPswd( $::ConfPlayerPswd->get_text );
	
	$::PrefWindow->hide();
}
#======================================================================
sub setConfiguredMenuState {
	my ($self) = @_;
	
	# File Menu Options
	$::NewMenuItem->set_sensitive(0);
	$::OpenMenuItem->set_sensitive(0);
	$::SaveMenuItem->set_sensitive(1);
	$::CloseMenuItem->set_sensitive(1);
	$::Configuration->set_sensitive(1);
	
	# Connection Menu Options
	$::OpenConMenuItem->set_sensitive(1);
	$::CloseConMenuItem->set_sensitive(0);
	
	# View menu options
	$::MapMenuItem->set_sensitive(1);
	$::ShipsMenuItem->set_sensitive(1);
	$::PlanetsMenuItem->set_sensitive(1);
	$::ScriptsMenuItem->set_sensitive(1);
	$::CommandsMenuItem->set_sensitive(1);
	$::ClearMenuItem->set_sensitive(1);
}
#======================================================================
sub resetMenuState {
	my ($self) = @_;
	
	# File Menu Options
	$::NewMenuItem->set_sensitive(1);
	$::OpenMenuItem->set_sensitive(1);
	$::SaveMenuItem->set_sensitive(0);
	$::CloseMenuItem->set_sensitive(0);
	$::Configuration->set_sensitive(0);
	
	# Connection Menu Options
	$::OpenConMenuItem->set_sensitive(0);
	$::CloseConMenuItem->set_sensitive(0);
	
	# View menu options
	$::MapMenuItem->set_sensitive(0);
	$::ShipsMenuItem->set_sensitive(0);
	$::PlanetsMenuItem->set_sensitive(0);
	$::ScriptsMenuItem->set_sensitive(0);
	$::CommandsMenuItem->set_sensitive(0);
	$::ClearMenuItem->set_sensitive(0);
}
#=======================================================================
sub method {
	my $self = shift;

	if($#_ == -1) {
		print "Callback without params!\n";
	} else {
		print "Parameters: @_\n"; 
	}
}
#======================================================================

1;
