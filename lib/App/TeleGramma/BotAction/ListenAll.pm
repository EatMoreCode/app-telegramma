package App::TeleGramma::BotAction::ListenAll;

# ABSTRACT: Base class for bot actions that listen to all messages, indiscriminately

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
