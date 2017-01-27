package App::TeleGramma::BotAction::Listen;

use Mojo::Base 'App::TeleGramma::BotAction';

has 'command';
has 'response';

sub process_message {
  my $self = shift;
  my $msg  = shift;

  if ($self->command eq $msg->text) {
    $self->response->($msg);
  }
}

1;
