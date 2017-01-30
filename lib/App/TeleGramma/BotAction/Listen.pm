package App::TeleGramma::BotAction::Listen;

# ABSTRACT: Base class for bot actions that listen

use Mojo::Base 'App::TeleGramma::BotAction';
use App::TeleGramma::Constants qw/:const/;

has 'command';
has 'response';

sub can_listen { 1 }

sub process_message {
  my $self = shift;
  my $msg  = shift;

  my $cmd = $self->command;

  if ($msg->text && $msg->text =~ /^\Q$cmd\E \b @? /x) {
    return $self->response->($msg);
  }

  return PLUGIN_DECLINED;
}

1;
