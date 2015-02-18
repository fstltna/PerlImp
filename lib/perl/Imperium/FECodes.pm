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
#      VERSION: 1.0
#      CREATED: 02/18/2015 04:06:28
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
 
#           Messages that Imperium may send

$FE_COMMENT =		"!<";		# Introduces all codes

# Planet Codes
$FE_PLDUMP = 		"!@D";		# Introduces a planet dump
$FE_PLDIRTY =		"!@U";		# Introduces a "dirty" planet #
$FE_PLGEO =			"!@1";		# A planet geo report follows
$FE_PLPOP =			"!@2";		# A planet population report follow
$FE_PLITE =			"!@3";
$FE_PLBIG =			"!@4";		# A planet big item report follow
$FE_PLPRO =			"!@51";		# A planet production report line 1
$FE_PLPRO2 =		"!@52";		# A planet production report line 2
$FE_PLSCAN =		"!@6";		# A planet scan line
$FE_PLRETSCAN =		"!@7";		# Info we got about a planet who scanned us

# Ship Codes
$FE_SHDUMP =		"!$D";		# Introduces a ship dump line
$FE_SHDIRTY =		"!$U";		# Introduces a "dirty" ship #
$FE_SHSTAT =		"!$1";		# A ship status report follows
$FE_SHCARGO =		"!$2";		# A ship cargo report follows
$FE_SHBIG =			"!$3";		# A ship big item report follows
$FE_SHCONF =		"!$4";		# A ship config report follows
$FE_SHSCAN =		"!$5";		# A ship scan line
$FE_SHSCDET =		"!$6";		# A ship detected via scan line
$FE_SHRETSCAN =		"!$7";		# Info we got about a ship who scanned us

# Scan Codes
$FE_SRS =			"!)S";		# Short Range Scan
$FE_LRS =			"!)R";		# Long Range Scan
$FE_VRS =			"!)V";		# Visual Range Scan

# Misc Codes
$FE_CHREQ =			"!*C\n";	# Change Request
$FE_PLAYLIST =		"!*L";		# A player list follows
$FE_POWREP =		"!*\x50";	# A power report follows
$FE_RACEREP =		"!*R1";		# A race report follows
$FE_RACEREP2 =		"!*R2";		# A race report (line 2) follows
$FE_PLAYSTAT =		"!*SS";		# Player status command follows
$FE_PLAYHOME =		"!*SH";		# A player status (home plan) follows
$FE_PRINTREALM =	"!*A";		# A realm line follows
$FE_WSIZE =			"!*W";		# A info world size line follows
$FE_DISP_PROMPT =	"!(";		# The prompt (if any) follows
                                # the "!(" sequence (until EOL)
$FE_GET_LINE =		"![\n";		# The FE should get a line from the
                                # user
$FE_GET_CANC =		"!]\n";		# The previous line requenst has
                                # been canceled

# Attack Codes
$FE_ATTLOSE =		"!&L\n";	# The last attack failed
$FE_ATTWIN =		"!&W\n";	# The last attack succeeded


#		Bit-values for items the FE wants to see

$FE_WANT_COMM =		0x0001;		# The player wants comments
$FE_WANT_PLAN =		0x0002;		# The player wants planet info
$FE_WANT_SHIP =		0x0004;		# The player wants ship info
$FE_WANT_MISC =		0x0008;		# The player wants misc. info
$FE_WANT_SCAN =		0x0010;		# The player wants scanner info
$FE_WANT_ATTK =		0x0020;		# The player wants attack info

#		Bit-values for things the FE supports

$FE_HAS_GRAPH =		0x0100;
$FE_HAS_SOUND =		0x0200;
$FE_HAS_MOUSE =		0x0400;
$FE_HAS_JOYST =		0x0800;
$FE_HAS_2COLR =		0x1000;
$FE_HAS_4COLR =		0x2000;
$FE_HAS_PROMPT =	0x4000;		# The FE supports "prompt" mode

