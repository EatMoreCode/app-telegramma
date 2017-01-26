package App::TeleGramma::Plugin::Core::Annoy;

use Mojo::Base 'App::TeleGramma::Plugin::Base';

use App::TeleGramma::BotAction::Listen;

sub synopsis {
  "An example plugin"
}

sub register {
  my $self = shift;
  my $help_command = App::TeleGramma::BotAction::Listen->new(command => '/annoy', response => \&be_annoying);
  return [$help_command];
}

sub be_annoying {
}

1;
