package App::TeleGramma::PluginManager;

use Mojo::Base -base;
use File::Spec::Functions qw/catdir/;

require Module::Pluggable;

has 'config';
has 'search_dirs' => sub { [catdir($ENV{HOME}, '.telegramma', 'plugins')] };
has 'list';

sub load_plugins {
  my $self = shift;
  $self->list([]);

  Module::Pluggable->import(
    search_path => ['App::TeleGramma::Plugin'],
    search_dirs => $self->search_dirs,
    require     => 1,
    except      => [qw/App::TeleGramma::Plugin::Base/]
  );

  foreach my $p ($self->plugins) {
    if (! $p->check_prereqs()) {
      warn "$p - failed prereq check\n";
    }

    # instantiate it
    my $o = $p->new(app_config => $self->config);
    $o->create_default_config_if_necessary;

    push @{ $self->list }, $o
      if ($o->read_config->{enable} =~ /yes/i);

    # register it
    $o->register;
  }
}

1;
