package App::TeleGramma::Store;

# ABSTRACT: Persistent datastore for TeleGramma and plugins

use Mojo::Base -base;
use Storable qw/store retrieve/;
use Carp qw/croak/;
use File::Spec::Functions qw/catfile/;

has 'path';
has 'dbs' => sub { {} };

sub hash {
  my $self = shift;
  my $db   = shift || die "no db?";

  $self->check_db_name($db);

  if (! $self->dbs->{$db} ) {
    my $hash = $self->read_db_into_hash($db);
    $self->dbs->{$db} = $hash;
  }
  return $self->dbs->{$db};
}

sub check_db_name {
  my $self = shift;
  my $db   = shift;

  if ($db !~ /^[\w\-]+$/) {
    croak "invalid db name '$db'\n";
  }

}

sub read_db_into_hash {
  my $self = shift;
  my $db   = shift;

  if (! -d $self->path) {
    croak "no path '" . $self->path . "'?";
  }

  my $db_file = catfile($self->path, $db);
  if (! -e $db_file) {
    my $hash = {};
    store($hash, $db_file);
    return $hash;
  }
  return retrieve($db_file);
}

sub save {
  my $self = shift;
  my $db   = shift;

  my $db_file = catfile($self->path, $db);
  store($self->hash($db), $db_file);
}

sub save_all {
  my $self = shift;
  my @dbs = keys %{ $self->dbs };
  $self->save($_) foreach @dbs;
}

1;
