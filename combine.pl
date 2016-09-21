use Text::CSV;
use Data::Dumper;
use strict;
use warnings;
use Class::CSV;
use File::Slurp;

use JSON qw( decode_json );

my $csvF = Class::CSV->new(
  fields => [qw/meantempm meanvism meanwindspeedm meandewptm precipm closep/]
);

my @apple;
my $csv = Text::CSV->new();
#ny2012.csv AAPLout.csv
open (FILE, "AAPLout.csv") or die "Couldn't open location file: $!";
while (<FILE>) {
    $csv->parse($_);
    push(@apple, [$csv->fields]);
}
close FILE;

my @weather;
my $csv1 = Text::CSV->new();
#ny2012.csv AAPLout.csv
open (FILE, "ny2012.csv") or die "Couldn't open location file: $!";
while (<FILE>) {
    $csv1->parse($_);
    push(@weather, [$csv1->fields]);
}
close FILE;

my @combined;
#size of apple
my $size = scalar @apple;
#var to go through weather
my $j = 0;
for(my $i = 0; $i <= 100; $i++){
	#take row 'i' and turn into an array
	my @appleday = @{$apple[$i]};
	my @weatherday = @{$apple[$j]};
	if($appleday[0] eq $weatherday[0]){
		print "eq";
		#if days match you combine
		$csvF->add_line([$weatherday[0], $weatherday[1], $weatherday[2], $weatherday[3], $weatherday[4], $appleday[4]]);

		# push @weatherday, $appleday[4];
		# push @combined, @weatherday;
	}else{
		#if they dont match then keep apple at the same 
		#and move up weather
		$i--;
	}
	
	$j++;
}
write_file( 'sdfghjkCSV.csv', $csv->string() ) ;

# foreach my $star (@apple){
# 	#turn into array
# 	my @star1 = @{$star};
# 	#take first element
# 	my $date =  $star1[0];
# }
#my @test = @{$apple[0]};
#print $test[0];
