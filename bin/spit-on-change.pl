#!/usr/bin/perl

# Takes a deliminated file (comma, tab, space, whatever) and a field number
# then outputs each the current line each time the field value changes
#
#
# Usage : 
#   $ spit-on-change.pl [DELIM REGEX] [FIELD Number] < input.txt > output.txt
#   $ spit-on-change.pl '\s+' '2' < input.txt > output.txt

use strict;
use warnings;

use Data::Dumper;

my $DELIM = shift @ARGV || die "Delim arg required";
my $FIELD = shift @ARGV || die "Field arg required";

my $prev_field = "ZZZZZZZZZZZZZZZZZZZ";
my $end_found = 0;
while( my $line = <STDIN>)  {
    #print $line;
	chomp $line;

	my @fields = split /$DELIM/, $line;
	
	my $field = $fields[$FIELD];
		
	if ($field ne $prev_field) {
		# print $field."\n";
		print $line."\n";
		$prev_field = $field;
	}

}
