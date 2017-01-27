package App::TeleGramma;

# ABSTRACT: A modular Telegram Bot

use Mojo::Base 'Telegram::Bot::Brain';

use App::TeleGramma::Config;
use App::TeleGramma::PluginManager;

use feature 'say';

has 'config';
has 'plugins';
has 'token';

# prepare/read config
sub startup {
  my $self = shift;

  # prep config
  my $config_was_created = 0;
  $self->config(App::TeleGramma::Config->new);
  $self->config->create_if_necessary && do
    {
      say $self->config->config_created_message;
      $config_was_created = 1;
    };

  # prep plugins
  $self->plugins(App::TeleGramma::PluginManager->new(config => $self->config, app => $self));
  $self->plugins->load_plugins;

  exit 0 if $config_was_created;

  # load token
  $self->config->read;
  $self->token($self->config->config->{_}->{bot_token});

}

sub bail_if_misconfigured {
  my $self = shift;

  if (! $self->token) {
    die "config file does not have a bot token - bailing out\n";
  }

  if ($self->token =~ /please/i) {
    die "config file has the default bot token - bailing out\n";
  }
}

sub init {
  my $self = shift;

  # add a listener which will pass every message to each listen plugin
  $self->add_listener(
    sub { 1 },  # everything matches
    \&incoming_message
  );

}

sub incoming_message {
  my $self = shift;
  my $msg  = shift;

  # pass it to all registered plugin listeners
  foreach my $listener (@{ $self->plugins->listeners }) {
    # call each one
    # XXX use the result to decide if we keep going
    my $res = $listener->process_message($msg);
  }
}

1;
