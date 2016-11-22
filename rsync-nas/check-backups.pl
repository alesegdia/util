#!/usr/bin/env perl

use DateTime;
use File::Basename;
use Term::ANSIColor;
use Cwd 'abs_path';

my $numargs = $#ARGV + 1;

if( $numargs != 2 )
{
	print "\n";
	print "Invalid number of arguments\n";
	print "\tUsage: ./check-backups.pl <source-dir> <target-dir>\n\n";
	exit -1;
}


my $source_folder = $ARGV[0];
my $target_folder = $ARGV[1];
my $source_basename = basename($source_folder);

# TODO: add flag to command line to perform this check, instead of always doing it
my $disk_type = `df -P -T $target_folder | tail -n +2 | awk '{print \$2}'`;
$disk_type =~ s/^\s+|\s+$//g;
if( $disk_type ne "nfs" )
{
	print("Source folder is not mounted on network.\n");
	exit(1);
}

print color("bold");
print "**********************\n";
print DateTime->now();
print "\n";
print color("reset");

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

	print color("bold blue");
	print "Checking $target_folder/$subfolder\n";
	print color("reset");

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
	if( $cmp <= 0 )
	{
		print color("bold red");
		print("Needs backup\n");
		print color("reset");

		print color("blue");
		print( ">> Starting to execute rsync script >>>>>>>>>>\n" );
		print color("reset");

		my $abspath = dirname(abs_path($0));
		my $command = "$abspath/sync.sh $source_folder $target_folder/$subfolder/";
		print "$command\n";
		system($command);
		print color("blue");
		print( "<< Finished rsync script <<<<<<<<<<<<<<<<<<<<<\n" );
		print color("reset");
	}
	else
	{
		print color("bold green");
		print( "No backup needed\n" );
		print color("reset");
	}

	print "\n";
}

print "source: $source_folder\n";
print "target: $target_folder\n";

check_backups( "daily", 1 );
check_backups( "weekly", 7 );
check_backups( "monthly", 30 );
