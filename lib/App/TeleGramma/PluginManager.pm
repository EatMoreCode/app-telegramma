package App::TeleGramma::PluginManager;

use Mojo::Base -base;
use File::Spec::Functions qw/catdir/;

require Module::Pluggable;

has 'config';
has 'search_dirs' => sub { [catdir($ENV{HOME}, '.telegramma', 'plugins')] };
has 'list' => sub { [] };
has 'listeners' => sub { [] };
has 'app';

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
    my $o = $p->new(app_config => $self->config, app => $self->app);
    $o->create_default_config_if_necessary;

    if ($o->read_config->{enable} =~ /yes/i) {

      # register it
      my @botactions = $o->register;
      foreach my $ba (@botactions) {
        if (ref($ba) eq 'App::TeleGramma::BotAction::Listen') {
          push @{ $self->listeners }, $ba;
        }
      }

      # add it to our list of plugins
      push @{ $self->list }, $o;
    }
  }
}

1;
