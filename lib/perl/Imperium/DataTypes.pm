#
#===============================================================================
#
#         FILE: DataTypes.pm
#
#  DESCRIPTION: Data types used in rest of app
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Marisa Giancarla (MG), info@empiredirectory.net
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 02/22/2015 07:59:28
#     REVISION: ---
#===============================================================================

use strict;
use warnings;

# Planet table definitions 
$Planets{"Default"} = {
	flags => '',		# Bitfield - See above for meanings
	last_seen => '',
	class => '',		# What planet class
	size => '',			# Planet size
	eff => '',			# Efficiency
	polut => '',		# Polution level
	minr => '',			# Minerals
	gold => '',			# Richness of gold
	water => '',		# Pct water
	gas => '',			# Pct gas
	mobil => '',		# Mobility units
	PopPct => '',		# Population percent
	PF => '',			# Plague factor
	TF => '',			# Tech factor
	xfer => '',			# How the planet was transferred
	owner => '',		# Planet owner
	lstOwn => '',		# Previous owner
	plgStg => '',		# Plague stage
	RF => '',			# Research Factory
	ResLv => '',		# Research level
	TechLv => '',		# Technology level
	pl_row => '',		# Location (row)
	pl_col => '',		# LOcation (col)
	pl_btu => '',		# BTUs
	prod => {},			# prod[PPROD_LAST + 1], /* Production points/type     */
	quant => {},		# quant[IT_LAST + 1];   /* Items on planet            */
	workPer => {},		# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
	name => '',
	chkpoint => ''
};

# Ship table definitions
$Ships{"Default"} = {
	flags => '',      # Bitfield - See above for meanings
	last_seen => '',
	ShipType => '',   # st_a -> st_m
	planet => '',     # What planet it is on, if any
	fuelLeft => '',   # fuel left
	cargo => '',      # current cargo amount
	armourLeft => '', # Armor left on hull
	sh_row => '',     # What row it is in 
	sh_col => '',     # What col it is in 
	shields => '',    # energy in shields 
	shieldsKeep => '', # energy to maintain in shields
	airLeft => '',    # Amount of air left
	energy => '',     # Energy left       
	sh_tf => '',      # Global tech factor
	fleet => '',      # Fleet it is in    
	efficiency => '', # Efficiency        
	owner => '',      # Who owns it       
	plagueStage => '', # What stage of the plague is it in
	hullTF => '',
	engTF => '',
	engEff => '',
	name => '', 		# Ship name, if any
	num_torp => '',   # Number of torps on board
	num_ore => '',    # Amount of ore on board
	num_gold => '',   # Amount of gold bars on board
	num_civ => '',
	num_sci => '',
	num_mil => '',
	num_ofc => '',
	num_misl => '',
	num_airt => '',
	num_ftnk => '',
	num_comp => '',
	num_eng => '',
	num_life => '',
	num_wpn => '',
	num_elect => '';
};

