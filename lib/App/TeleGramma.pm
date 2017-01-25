package App::TeleGramma;

# ABSTRACT: A modular Telegram Bot

use Mojo::Base 'Telegram::Bot::Brain';

use App::TeleGramma::Config;
use App::TeleGramma::PluginManager;

use feature 'say';

has 'config';
has 'plugins';
has 'token' => '267770718:AAGHRP-_OzW5-WRajtkPSMPnGs0kAdc733k';

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

  $self->plugins->list;

}

sub init {
  # override bot brain here
}

# load plugins
sub setup {


}

1;
