#
#===============================================================================
#
#         FILE: FECodes.pm
#
#  DESCRIPTION: Contains the FE indicator codes
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Marisa Giancarla (MG), info@empiredirectory.net
# ORGANIZATION: 
#      VERSION: 2.0
#      CREATED: 02/18/2015 04:06:28
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use Readonly;
 
#           Messages that Imperium may send

Readonly $FE_COMMENT =>		"!<";		# Introduces a comment

# Planet Codes
Readonly $FE_PLDUMP => 		"!@D";		# Introduces a planet dump
Readonly $FE_PLDIRTY =>		"!@U";		# Introduces a "dirty" planet #
Readonly $FE_PLGEO =>		"!@1";		# A planet geo report follows
Readonly $FE_PLPOP =>		"!@2";		# A planet population report follow
Readonly $FE_PLITE =>		"!@3";
Readonly $FE_PLBIG =>		"!@4";		# A planet big item report follow
Readonly $FE_PLPRO =>		"!@51";		# A planet production report line 1
Readonly $FE_PLPRO2 =>		"!@52";		# A planet production report line 2
Readonly $FE_PLSCAN =>		"!@6";		# A planet scan line
Readonly $FE_PLRETSCAN =>	"!@7";		# Info we got about a planet who scanned us

# Ship Codes
Readonly $FE_SHDUMP =>		"!$D";		# Introduces a ship dump line
Readonly $FE_SHDIRTY =>		"!$U";		# Introduces a "dirty" ship #
Readonly $FE_SHSTAT =>		"!$1";		# A ship status report follows
Readonly $FE_SHCARGO =>		"!$2";		# A ship cargo report follows
Readonly $FE_SHBIG =>		"!$3";		# A ship big item report follows
Readonly $FE_SHCONF =>		"!$4";		# A ship config report follows
Readonly $FE_SHSCAN =>		"!$5";		# A ship scan line
Readonly $FE_SHSCDET =>		"!$6";		# A ship detected via scan line
Readonly $FE_SHRETSCAN =>	"!$7";		# Info we got about a ship who scanned us

# Scan Codes
Readonly $FE_SRS =>			"!)S";		# Short Range Scan
Readonly $FE_LRS =>			"!)R";		# Long Range Scan
Readonly $FE_VRS =>			"!)V";		# Visual Range Scan

# Misc Codes
Readonly $FE_CHREQ =>		"!*C\n";	# Change Request
Readonly $FE_PLAYLIST =>	"!*L";		# A player list follows
Readonly $FE_POWREP =>		"!*\x50";	# A power report follows
Readonly $FE_RACEREP =>		"!*R1";		# A race report follows
Readonly $FE_RACEREP2 =>	"!*R2";		# A race report (line 2) follows
Readonly $FE_PLAYSTAT =>	"!*SS";		# Player status command follows
Readonly $FE_PLAYHOME =>	"!*SH";		# A player status (home plan) follows
Readonly $FE_PRINTREALM =>	"!*A";		# A realm line follows
Readonly $FE_WSIZE =>		"!*W";		# A info world size line follows
Readonly $FE_DISP_PROMPT =>	"!(";		# The prompt (if any) follows
                           			    # the "!(" sequence (until EOL)
Readonly $FE_GET_LINE =>	"![\n";		# The FE should get a line from the
                                		# user
Readonly $FE_GET_CANC =>	"!]\n";		# The previous line requenst has
                                		# been canceled

# Attack Codes
Readonly $FE_ATTLOSE =>		"!&L\n";	# The last attack failed
Readonly $FE_ATTWIN =>		"!&W\n";	# The last attack succeeded


#		Bit-values for items the FE wants to see

Readonly $FE_WANT_COMM =>	0x0001;		# The player wants comments
Readonly $FE_WANT_PLAN =>	0x0002;		# The player wants planet info
Readonly $FE_WANT_SHIP =>	0x0004;		# The player wants ship info
Readonly $FE_WANT_MISC =>	0x0008;		# The player wants misc. info
Readonly $FE_WANT_SCAN =>	0x0010;		# The player wants scanner info
Readonly $FE_WANT_ATTK =>	0x0020;		# The player wants attack info

#		Bit-values for things the FE supports

Readonly $FE_HAS_GRAPH =>	0x0100;
Readonly $FE_HAS_SOUND =>	0x0200;
Readonly $FE_HAS_MOUSE =>	0x0400;
Readonly $FE_HAS_JOYST =>	0x0800;
Readonly $FE_HAS_2COLR =>	0x1000;
Readonly $FE_HAS_4COLR =>	0x2000;
Readonly $FE_HAS_PROMPT =>	0x4000;		# The FE supports "prompt" mode
1;
