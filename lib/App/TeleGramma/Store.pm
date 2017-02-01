package App::TeleGramma::Store;

# ABSTRACT: Persistent datastore for TeleGramma and plugins

=head1 SYNOPSIS

  my $store = App::TeleGramma::Store->new(path => "/some/dir");
  my $hashref1 = $store->hash('mydata-1');
  $hashref1->{foo} = 'bar';
  $hashref1->{bar} = 'baz';
  $store->save('mydata-1');  # persisted

  my $hashref2 = $store->hash('mydata-2'); # new data structure
  $hashref2->{users} = [ qw/ a b c / ];

  $store->save_all;  # persist data in both the 'mydata1' hash and the 'mydata2' hash

=cut

use Mojo::Base -base;
use Storable qw/store retrieve/;
use Carp qw/croak/;
use File::Spec::Functions qw/catfile/;

has 'path';
has 'dbs' => sub { {} };

=method hash

Return the hash reference for a named entry in your data store. Note that
the names become disk filenames, and thus must consist of alphanumeric characters
or '-' only.

=cut

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

=method save

Save a named hash to the data store.

References are saved using L<Storable> and the limitations in terms of data
stored can be found in that documenation.

In general, if you stick with simple hashrefs, arrayrefs and scalars you will
be fine.

=cut

sub save {
  my $self = shift;
  my $db   = shift;

  my $db_file = catfile($self->path, $db);
  store($self->hash($db), $db_file);
}

=method save_all

Persist all named hashrefs to the store at once.

=cut

sub save_all {
  my $self = shift;
  my @dbs = keys %{ $self->dbs };
  $self->save($_) foreach @dbs;
}

1;
