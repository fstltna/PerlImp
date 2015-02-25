package Imperium::Main;

# Pragmas --------------------------------------------------------------
use warnings;
#use strict;	# ZZZ Remove this

# External libraries ---------------------------------------------------
use Gtk2;
use Gtk2::Ex::Dialogs ( 
	destroy_with_parent => 1, 
	modal 				=> 1, 
	no_separator 		=> 0 
);
use Net::Telnet;
use Storable;
#=======================================================================
# Global Vars
my $DEFAULTSERVER = "empiredirectory.net";
my $DEFAULTSERVERPORT = "3458";
my $BaseFilename = "Basename";	# What the left part of the file name should be
my $DirtyData = 0;
my $AtMainPrompt = 0;
my $QueueOk = 1;
my $QueueEcho = 1;
my $StopQueue = 0;
my $NumCmds = 0;
my $Game_Time = 0;
my $Game_BTUs = 0;
my $GameSocket = -1;

# Create Defs
my $ConfServerHost = $DEFAULTSERVER;
my $ConfServerPort = $DEFAULTSERVERPORT;
my $ConfPlayerName = "";
my $ConfPlayerPswd = "";
my $LastSavedServerHost = "";
my $LastSavedServerPort = "";
my $LastSavedPlayerName = "";
my $LastSavedPlayerPswd = "";

# Main App Settings
$Globals{"Default"} = {
	ServerHost	=> $DEFAULTSERVER,
	ServerPort	=> $DEFAULTSERVERPORT,
	PlayerName	=> '',
	PlayerPswd	=> '',
	GameVersion => 1,
	GameDesc	=> '',
	SizeX		=> 255,
	SizeY		=> 255,
	NextShip	=> 0,
	LastShip	=> 0,
	NextPlanet	=> 0,
	LastPlanet	=> 0,
	LastX		=> 0,
	LastY		=> 0,
	NextItem	=> 0,
	HomePlanet	=> 0,
	HomeRow		=> 0,
	HomeCol		=> 0,
	PlayerNum	=> 0
};

# Planet table definitions 
$Planets{"Default"} = {
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
};

# Ship table definitions
$Ships{"Default"} = {
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
};

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
	$Globals{"Active"} = $Globals{"Default"};
}
#======================================================================
# Resets the server settings to last saved
sub resetLastSaved {
	$Globals{"Active"} = {
		ServerHost => $LastSavedServerHost,
		ServerPort => $LastSavedServerPort,
		PlayerName => $LastSavedPlayerName,
		PlayerPswd => $LastSavedPlayerPswd
	}
}
#======================================================================
# Load in data
sub loadData {
	$Planets = retrieve("$BaseFilename.plan");
	$Ships = retrieve("$BaseFilename.ship");
	$Globals = retrieve("$BaseFilename.plimp");
}
#======================================================================
# Save data
sub saveData {
	store($Planets, "$BaseFileName.plan");
	store($Ships, "$BaseFileName.ship");
	store($Globals, "$BaseFileName.plimp");
}
#======================================================================
# Save new data struct
sub fileSaveInit {
	my $self = shift;

	print "Parameters: @_\n"; 
	$BaseFileName = "";
	#saveData();
}
#======================================================================
sub method {
	my $self = shift;

	if($#_ == -1) {
		print "Callback without params!\n";
	} else {
		print "Parameters: @_\n"; 
	}
}
#======================================================================
sub openConnect {
	print "called openConnect\n";
}
#======================================================================
sub closeConnect {
	print "Called closeConnect\n";
}
#======================================================================

1;
