package App::TeleGramma::Plugin::Base;

use Mojo::Base -base;

has 'app_config';

sub _package_to_ini_section {
  my $self = shift;
  my $package = ref($self);
  $package =~ s/^App::TeleGramma::Plugin:://;
  $package =~ s/::/-/g;

  return "plugin-" . $package;
}

sub default_config { {} }

sub create_default_config_if_necessary {
  my $self = shift;
  my $section = $self->_package_to_ini_section();

  $self->app_config->read();

  if (%{ $self->default_config } && ! %{ $self->read_config }) {
    $self->app_config->config->{$section} = $self->default_config;
    $self->app_config->write();
  }

}

sub read_config {
  my $self = shift;
  my $section = $self->_package_to_ini_section();
  return $self->app_config->config->{$section} || {};
}

1;
