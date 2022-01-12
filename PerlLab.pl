#!/usr/bin/perl
use warnings;
use strict;
use Data::Dumper;

my $filename = "./raw_info.txt";
open(my $fh, '<', $filename)
        or die "could not open file $filename $!";

open(my $ofh, '>', "output.csv");

my @unsorted;
my $regex = join '|', @ARGV;
my $lineNum = 1;
while(my $line = <$fh>)
{
	chomp$line;
	if($lineNum == 1)
	{ 
		print "$line";
		print $ofh "$line"; #print $ofh will print out whatever it is into the file "output.txt" as named above.
                print $ofh "\n";

	}
	elsif($lineNum == 2)
	{
		print "$line";
		print $ofh "$line";
                print $ofh "\n";

	}
	elsif($lineNum == 3) #These first three checks will make it so it'll ALWAYS print the first three lines
	{
		my @line_elements = split(/\s{2,}/, $line);
		my $bestLine = join ",", @line_elements;
		print $ofh "$bestLine";
		print $ofh "\n";
	}
	elsif(scalar(@ARGV) == 0) #This is a filter that will only print the line if the line does not contain what is in the string $regex, separated by |'s, it is also split based on whether there are 0 parameters, or 1 or more parameters
	{
        	if($line !~ /(---%)/ && $line =~ /[A-Za-z0-9]+/) #This filter will remove any line with a ---% on it, and will only consider lines that take any sort of character.
		{
			$line =~ s/%/  %/g; #search and replace, globally, the line, and replace each instance of a % with two spaces, followed by a %, for comparison later.
			my @line_element = split(/\s{2,}/, $line); #split the line into an array of elements, based on a regex search of two or more spaces 
			push @unsorted, [@line_element]; #push these line arrays into an array called unsorted, later to be sorted
		}
	}
	elsif(scalar(@ARGV) > 0)
	{
		if($line !~ /$regex|(---%)/ && $line =~ /[A-Za-z0-9]+/)
                {
			$line =~ s/%/  %/g;
                        my @line_element = split(/\s{2,}/, $line);
			
                        push @unsorted, [@line_element];
                }

	}
        $lineNum = $lineNum + 1;
}

my @sorted = sort { $b->[4] <=> $a->[4] } @unsorted; #Sort the array in descending order, based on the 4th element, which is the percentage number without the percentage

my @complete;
foreach my $val ( @sorted ) {
        push(@complete, join(",", @$val)); #Create the array, "complete" and push into it, the joined array values within the array "sorted", separated by a , 
}
@complete = map {$_ =~ s/\,%/%/g; $_} @complete; #replace each instance of a ,% with a % in each value of the array "complete"

foreach(@complete) #print the array
{
	print $ofh  "$_\n";
}
close $ofh;
close $fh;
