#!/usr/bin/perl
#
#  Takes input from apache-access-times.pl and calculates the given timeTaken percentile.
#  Performs NO filtering on URLS - assumes is done externally.
#
#   Logic: http://www.dummies.com/how-to/content/how-to-calculate-percentiles-in-statistics.html
#

use strict;
use warnings;
use Data::Dumper;
use POSIX qw(ceil);



my @times = (); 

my $num_calls = 0;
while( my $line = <STDIN>)  {
#    print $line;
	chomp $line;

	my ($timestamp, $status, $reqLine, $timeTaken) = split /\t/, $line;
	push @times, $timeTaken;
	$num_calls++;
}

my @sorted_times = sort {$a <=> $b} @times;

#print "SORT:ED ".$sorted_times[3]."\n";
#print Dumper(\@sorted_times);

print "Total Calls: $num_calls\n";

while (my $PERCENTILE = shift @ARGV) {

	my $index = $num_calls * ($PERCENTILE / 100);

	my $ceil = ceil($index);
	my $result;

	# perl zero-based indexes...
	$index--;
	$ceil--;

	if ($index == $ceil) {
		# index is whole number, average index and value above
		$result = ($sorted_times[$index] + $sorted_times[$index + 1]) / 2;
	}
	else {
		# index is fraction, take ceil
		$result = $sorted_times[$ceil];
	}

	printf "%d\t%6.0f\n", $PERCENTILE, $result;

}
