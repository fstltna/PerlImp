package Imperium::Audio;

# Pragmas --------------------------------------------------------------
use warnings;
use strict;	

# External libraries ---------------------------------------------------

#=======================================================================
sub new {
	my ($class) = @_;
	
	my $self = bless { }, $class;
	$self->start;
	
	return $self;
}
#=======================================================================
sub start {
	my ($self) = @_;
	
	my $player = -e q[/usr/bin/afplay] 	? q[/usr/bin/afplay]	:
				 -e q[/usr/bin/mplayer] ? q[/usr/bin/mplayer]	:
				 -e q[/usr/bin/vlc]		? q[/usr/bin/vlc]		: undef;
	
	return unless $player;
	
	$self->{ pid } = fork;
	
	return 1 if $self->{ pid };
	
	exec( $player, q[../lib/audio/theme.mp3] ) or die $!;
	exit 1; # We sholud never get there...
}
#=======================================================================
sub stop {
	my ($self) = @_;
	
	return unless $self->{ pid };
	
	kill 2, $self->{ pid };
	
	return 1;
}
#=======================================================================

1;
