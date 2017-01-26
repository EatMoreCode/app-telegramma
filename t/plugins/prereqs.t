use Test::More;

use strict;
use warnings;

use Data::Dumper;

use File::Temp qw/tempdir/;
use File::Spec::Functions qw/catdir catfile/;

my $td = tempdir( CLEANUP => 1 );

mkdir catdir($td, 'App');
mkdir catdir($td, 'App', 'TeleGramma');
mkdir catdir($td, 'App', 'TeleGramma', 'Plugin');
mkdir catdir($td, 'App', 'TeleGramma', 'Plugin', 'Test');

my $dir = catdir($td, qw/App TeleGramma Plugin Test/);

open my $fh, ">", catfile($dir, "TestPrereq.pm") || die $!;

print $fh "package App::TeleGramma::Plugin::Test::TestPrereq;\n";
print $fh "use Mojo::Base 'App::TeleGramma::Plugin::Base';\n";
print $fh "1;\n";
close $fh;

use App::TeleGramma::PluginManager;
use App::TeleGramma::Config;

my $cfg = App::TeleGramma::Config->new;
my $pm = App::TeleGramma::PluginManager->new(config => $cfg, search_dirs => $td);
$pm->load_plugins;

done_testing;


1;
