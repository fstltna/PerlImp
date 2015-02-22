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
	last_seen => '',	# When the planet was last seen
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
	pl_col => '',		# Location (col)
	pl_btu => '',		# BTUs
	prod_civ => '',		# prod[PPROD_LAST + 1], /* Production points/type     */
	prod_mil => '',		# prod[PPROD_LAST + 1], /* Production points/type     */
	prod_tech => '',	# prod[PPROD_LAST + 1], /* Production points/type     */
	prod_research => '',	# prod[PPROD_LAST + 1], /* Production points/type     */
	prod_educ => '',	# prod[PPROD_LAST + 1], /* Production points/type     */
	prod_ocs => '',		# prod[PPROD_LAST + 1], /* Production points/type     */
	prod_oremine => '',	# prod[PPROD_LAST + 1], /* Production points/type     */
	prod_goldmine => '',	# prod[PPROD_LAST + 1], /* Production points/type     */
	prod_airtank => '',	# prod[PPROD_LAST + 1], /* Production points/type     */
	prod_fueltank => '',	# prod[PPROD_LAST + 1], /* Production points/type     */
	prod_weapons => '',	# prod[PPROD_LAST + 1], /* Production points/type     */
	prod_engines => '',	# prod[PPROD_LAST + 1], /* Production points/type     */
	prod_hull => '',	# prod[PPROD_LAST + 1], /* Production points/type     */
	prod_missle => '',	# prod[PPROD_LAST + 1], /* Production points/type     */
	prod_planes => '',	# prod[PPROD_LAST + 1], /* Production points/type     */
	prod_electronics => '',		# prod[PPROD_LAST + 1], /* Production points/type     */
	prod_cash => '',	# prod[PPROD_LAST + 1], /* Production points/type     */
	quant_civ => '',	# quant[IT_LAST + 1];   /* Items on planet            */
	quant_sci => '',	# quant[IT_LAST + 1];   /* Items on planet            */
	quant_mil => '',	# quant[IT_LAST + 1];   /* Items on planet            */
	quant_off => '',	# quant[IT_LAST + 1];   /* Items on planet            */
	quant_misl => '',	# quant[IT_LAST + 1];   /* Items on planet            */
	quant_planes => '',	# quant[IT_LAST + 1];   /* Items on planet            */
	quant_ore => '',	# quant[IT_LAST + 1];   /* Items on planet            */
	quant_bars => '',	# quant[IT_LAST + 1];   /* Items on planet            */
	quant_airTanks => ''	# quant[IT_LAST + 1];   /* Items on planet            */
	quant_fuelTanks => '',	# quant[IT_LAST + 1];   /* Items on planet            */
	quant_comput => '',	# quant[IT_LAST + 1];   /* Items on planet            */
	quant_engines => '',	# quant[IT_LAST + 1];   /* Items on planet            */
	quant_lifeSupp => '',	# quant[IT_LAST + 1];   /* Items on planet            */
	quant_elect => '',	# quant[IT_LAST + 1];   /* Items on planet            */
	quant_weapons => '',	# quant[IT_LAST + 1];   /* Items on planet            */
	quant_civ => '',	# quant[IT_LAST + 1];   /* Items on planet            */
	workPer_civ => '',	# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
	workPer_sci => '',	# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
	workPer_mil => '',	# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
	workPer_off => '',	# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
	workPer_misl => '',	# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
	workPer_planes => '',	# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
	workPer_ore => '',	# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
	workPer_bars => '',	# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
	workPer_airTanks => '',		# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
	workPer_fuelTanks => '',	# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
	workPer_comput => '',	# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
	workPer_engines => '',	# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
	workPer_lifeSup => '',	# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
	workPer_elect => '',	# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
	workPer_weapons => '',	# workPer[PPROD_LAST + 1]; /* 0-100% of prodct    */
	name => '',				# Name of planet
	chkpoint => ''			# Planet checkpoint
};

# Ship table definitions
$Ships{"Default"} = {
	flags => '',		# Bitfield - See above for meanings
	last_seen => '',	# WHen the planet was last seen
	ShipType => '',		# st_a -> st_m
	planet => '',		# What planet it is on, if any
	fuelLeft => '',		# fuel left
	cargo => '',		# current cargo amount
	armourLeft => '',	# Armor left on hull
	sh_row => '',		# What row it is in 
	sh_col => '',		# What col it is in 
	shields => '',		# energy in shields 
	shieldsKeep => '',	# energy to maintain in shields
	airLeft => '',		# Amount of air left
	energy => '',		# Energy left       
	sh_tf => '',		# Global tech factor
	fleet => '',		# Fleet it is in    
	efficiency => '',	# Efficiency        
	owner => '',		# Who owns it       
	plagueStage => '',	# What stage of the plague is it in
	hullTF => '',		# Hull tech factor
	engTF => '',		# Engine tech factorr
	engEff => '',		# Engine efficiency
	name => '', 		# Ship name, if any
	num_torp => '',		# Number of torps on board
	num_ore => '',		# Amount of ore on board
	num_gold => '',		# Amount of gold bars on board
	num_civ => '',		# Civilians
	num_sci => '',		# Scientists
	num_mil => '',		# Military
	num_ofc => '',		# Officers
	num_misl => '',		# Missles
	num_airt => '',		# Air tanks
	num_ftnk => '',		# Fuel tanks
	num_comp => '',		# Computers
	num_eng => '',		# Engines
	num_life => '',		# Life support
	num_wpn => '',		# Weapons
	num_elect => ''		# Electronics
};

1;
