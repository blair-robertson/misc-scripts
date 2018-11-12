#!/usr/bin/perl

#  Extract into TSV the HTTP Status, HTTP Request and Time Taken from the apache access logs

use strict;
use warnings;

use Data::Dumper;

my $i = 0;
while( my $line = <STDIN>)  {
#    print $line;
	chomp $line;

	if ($line =~ /^\[([^]]+)\] .* "([^"]+) HTTP\/1\.." ([0-9-]+) [0-9-]+ ([0-9]+) us /) {
		my ($timestamp, $reqLine, $status, $timeTaken) = ($1, $2, $3, $4);

		# [Thu Jun 11 15:10:14 2015]
		$timestamp =~ s!^[^ ]+ ([^ ]*) ([0-9]+) (.*:.*:.*) ([0-9]+)!$4-$1-$2 $3!;

		# microseconds to milliseconds
		$timeTaken = $timeTaken / 1000;

		print $timestamp."\t".$status."\t".$reqLine."\t".$timeTaken."\n";
		$i++;
	}

}

print STDERR "Wrote $i lines\n";

