package App::TeleGramma::BotAction::Listen;

use Mojo::Base 'App::TeleGramma::BotAction';
use App::TeleGramma::Constants qw/:const/;

has 'command';
has 'response';

sub process_message {
  my $self = shift;
  my $msg  = shift;

  if ($self->command eq $msg->text) {
    return $self->response->($msg);
  }

  return PLUGIN_DECLINED;
}

1;
