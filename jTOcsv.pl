use strict;
use warnings;
use JSON qw( decode_json );
use Class::CSV;
use File::Slurp;
use Data::Dumper;
#open csv and create collumns
# 0:data, 1:open, 2:high, 3:low, 4:close, 5:volume
my $csv = Class::CSV->new(
  fields => [qw/meantempm meanvism meanwindspeedm meandewptm precipm/]
);


local $/;
	my $filename = 'AAPL.json';

		open(FILE, $filename) or die "Can't read file 'filename' [$!]\n";  
		my $document = <FILE>; 
		close (FILE);  

		my $decoded = decode_json($document);
		my @arr = @{ $decoded->{'data'}};

		foreach my $f (@arr){ 
			$csv->add_line($f);
		    #print $f->{"meanvism"};
	}

write_file( 'AAPLout.csv', $csv->string() ) ;

