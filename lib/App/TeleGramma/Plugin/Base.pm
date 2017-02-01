package App::TeleGramma::Plugin::Base;

# ABSTRACT: Base class for TeleGramma plugins

use Mojo::Base -base;

use App::TeleGramma::Constants qw/:const/;
use App::TeleGramma::Store;
use File::Spec::Functions qw/catdir/;

has 'app_config';
has 'app';
has '_store';

=method truncated_package_name

Provide the name of the plugin, in perl form (hierarchy delimited with '::')
but without the leading C<App::TeleGramma::Plugin>.

=cut

sub truncated_package_name {
  my $self = shift;
  my $package = ref($self);
  $package =~ s/^App::TeleGramma::Plugin:://;
  return $package;
}

=method short_name

Provide the name of the plugin, with the '::' separators changed to '-', and
the leading 'App::TeleGramma::Plugin::' removed.

=cut

sub short_name {
  my $self = shift;
  my $package = ref($self);
  $package =~ s/^App::TeleGramma::Plugin:://;
  $package =~ s/::/-/g;

  return "plugin-" . $package;
}

=method default_config

Override this method in your subclass if you want to provide a default
configuration for your plugin (apart from the "enabled" flag).

=cut

# override: optional
sub default_config { {} }

# override: optional
sub check_prereqs {
  1;
}

=method synopsis

Override this method to provide a one-line synopsis of your plugin.

=cut

sub synopsis {
  "My author did not provide a synopsis!";
}

=method register

Override this method to register your plugin. It must setup any required
listeners. See L<App::TeleGramma::Plugin::Core::Fortune> for an example.

=cut

sub register {
  my $self = shift;
  die ref($self) .  " did not supply a register method\n";
}

sub create_default_config_if_necessary {
  my $self = shift;
  my $section = $self->short_name();

  $self->app_config->read();

  if (! %{ $self->read_config }) {
    $self->app_config->config->{$section} = $self->default_config;
    $self->app_config->config->{$section}->{enable} = 'no';
    $self->app_config->write();
  }
}

=method read_config

Read the configuration specific to this plugin.

Returns a hashref

=cut

sub read_config {
  my $self = shift;
  my $section = $self->short_name();
  $self->app_config->read();
  return $self->app_config->config->{$section} || {};
}

=method reply_to

Reply to a message, with text.

Should be provided the Telegram::Bot::Message object, and the text string
to respond with.

=cut

sub reply_to {
  my $self  = shift;
  my $msg   = shift;
  my $reply = shift;

  my $app = $self->app;

  $app->send_message_to_chat_id($msg->chat->id, $reply);
}

=method data_dir

Returns the path on disk that your plugin should store any data.

=cut

sub data_dir {
  my $self = shift;
  my $data_dir = catdir($self->app_config->path_plugin_data, $self->short_name);
  mkdir $data_dir unless -d $data_dir;
  return $data_dir;
}

=method store

Returns an L<App::TeleGramma::Store> object for you to persist your plugin data.

=cut

sub store {
  my $self = shift;
  return $self->_store if ($self->_store);
  my $data_dir = $self->data_dir;

  my $store_dir = catdir($data_dir, 'store');
  mkdir $store_dir unless -d $store_dir;

  my $store = App::TeleGramma::Store->new(path => $store_dir);
  $self->_store($store);
  return $store;
}

1;
