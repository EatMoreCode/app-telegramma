package App::TeleGramma::BotAction::ListenAll;

use Mojo::Base 'App::TeleGramma::BotAction';
use App::TeleGramma::Constants qw/:const/;

has 'response';

sub can_listen { 1 }

sub process_message {
  my $self = shift;
  my $msg  = shift;

  return $self->response->($msg);
}

1;
