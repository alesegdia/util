#!/usr/bin/env perl

use DateTime;
use File::Basename;

my $numargs = $#ARGV + 1;

if( $numargs != 2 )
{
	print "Invalid number of arguments\n";
	exit -1;
}

my $source_folder = $ARGV[0];
my $target_folder = $ARGV[1];
my $source_basename = basename($source_folder);

if( false == (-d "$source_folder") ) {
	print "Source folder is not a directory\n";
	exit -1;
}

if( false == (-d "$target_folder") ) {
	print "Target folder is not a directory\n";
	exit -1;
}

sub check_backups {
	my $n_args = scalar(@_);
	if ($n_args != 2) {
		exit -1;
	}
	my $subfolder = @_[0];
	my $frequency = @_[1];

	print "Checking $target_folder/$subfolder\n";

	my @files = <"$target_folder/$subfolder/$source_basename\.backup\.*">;
	my $newest_date = new DateTime(
		year 	=> 1,
		month 	=> 1,
		day 	=> 1
	);

	foreach my $file (@files) {
		my ($day, $month, $year) = $file =~ /^.*(\d\d)\.(\d\d)\.(\d\d\d\d)$/;
		if (defined($day) && defined($month) && defined($year)) {
			my $current_date = new DateTime(
				year 	=> $year,
				month 	=> $month,
				day 	=> $day
			);
			if ($current_date->epoch() > $newest_date->epoch()) {
				$newest_date = $current_date;
			}
		}
	}

	my $next_backup_date = $newest_date->add( days => $frequency );
	my $cmp = DateTime->compare( $next_backup_date, DateTime->today() );
	if( $cmp < 0 )
	{
		print("Needs backup\n");
	}
	else
	{
		print( "No backup needed\n" );
	}

	print "\n";
}

print "source: $source_folder\n";
print "target: $target_folder\n";

check_backups( "daily", 1 );
check_backups( "weekly", 7 );
check_backups( "monthly", 30 );
