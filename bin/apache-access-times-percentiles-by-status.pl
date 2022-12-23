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



my $times = ();

while( my $line = <STDIN>)  {
#    print $line;
	chomp $line;

	my ($timestamp, $status, $reqLine, $timeTaken) = split /\t/, $line;

	if (!defined($times->{$status})) {
		$times->{$status} = ();
	}
	push @{$times->{$status}}, $timeTaken;
}

# print Dumper($times);

for my $status (sort {$a <=> $b} keys %$times) {

	my @sorted_times = sort {$a <=> $b} @{$times->{$status}};
	my $num_calls = scalar @sorted_times;

	#print "SORT:ED ".$sorted_times[3]."\n";
	#print Dumper(\@sorted_times);

	print "HTTP Status: $status           Total Calls: $num_calls\n";

	for my $PERCENTILE (@ARGV) {

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
	print "\n";
}

exit;

