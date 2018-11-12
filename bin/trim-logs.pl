#!/usr/bin/perl

#  Trim logs by outputting content only between 2 Regex
#  Useful to take a full days logs and extract a certain time element
#
#
# Usage : 
#   $ trim-logs.pl [START REGEX] [END REGEX] < input.txt > output.txt
#   $ trim-logs.pl '^19.Oct.2016 16:07' '^19.Oct.2016 16:59' < request.log > request.log.trimmed

use strict;
use warnings;

use Data::Dumper;

my $START = shift @ARGV || die "Start arg required";
my $END   = shift @ARGV || die "End arg required";

my $on = 0;
my $end_found = 0;
while( my $line = <STDIN>)  {
    #print $line;
	#chomp $line;

	
	if (!$on && $line =~ /$START/) {
		$on = 1;
		print $line;
	}
	elsif ($on) {
		$on++;
		print $line;
		if ($line =~ /$END/) {
			$end_found = 1;
			last;
		}
	}

}

print STDERR "Wrote $on lines";
print STDERR " *** END STRING NOT FOUND ***" unless ($end_found); 
print STDERR "\n";
