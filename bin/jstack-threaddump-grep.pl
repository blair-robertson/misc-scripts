#!/usr/bin/perl
use strict;
use warnings;

use Data::Dumper;

my $THREAD_FILTER = shift @ARGV || die "THREAD_FILTER arg required";

my $prev_field = "ZZZZZZZZZZZZZZZZZZZ";
my $end_found = 0;
my $thread_open = 0;
my $output_thread = 0;
my $thread_content = "";
while( my $line = <STDIN>)  {
    #print $line;
	#chomp $line;

	if ($line =~ /^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}/) {
		# timestamp at start of threaddump
		print $line;
	}
	elsif ($line =~ /^Full thread dump .*/) {
		# first line of threaddump after timestamp
		print $line;
	}
	elsif ($line =~ /^"/) {
		# First line of thread info
		print $thread_content if ($thread_content =~ /$THREAD_FILTER/ms);

		$thread_open = 1;
		$thread_content = $line;
	}
	elsif ($line =~ /^JNI global references/) {
		# last line of thread dump
		print $thread_content if ($thread_content =~ /$THREAD_FILTER/ms);
		
		$thread_open = 0;
		$thread_content = "";
		print $line;
	}
	elsif ($thread_open) {
		$thread_content .= $line;
	}
	else {
		print $line;
	}

}
