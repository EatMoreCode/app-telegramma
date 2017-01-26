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
  $self->config(App::TeleGramma::Config->new);
  $self->config->create_if_necessary && do
    {
      say $self->config->config_created_message;
      exit 0;
    };

  # prep plugins
  $self->plugins(App::TeleGramma::PluginManager->new(config => $self->config));
  $self->plugins->load_plugins;

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
  # override bot brain here
}

sub setup {
}

1;
