package App::TeleGramma::PluginManager;

use Mojo::Base -base;
use File::Spec::Functions qw/catdir/;

has 'config';

use Module::Pluggable
  search_path => ['App::TeleGramma::Plugin'],
  search_dirs => [catdir($ENV{HOME}, '.telegramma', 'plugins')],
  instantiate => 'new',
  except      => [qw/App::TeleGramma::Plugin::Base/];

sub list {
  my $self = shift;

  foreach my $p ($self->plugins(app_config => $self->config)) {
    use Data::Dumper;
    $p->create_default_config_if_necessary;
    warn Dumper $p->read_config;
  }
}

1;
