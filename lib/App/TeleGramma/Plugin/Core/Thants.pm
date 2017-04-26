package App::TeleGramma::Plugin::Core::Thants;

# ABSTRACT: TeleGramma plugin to give thants where necessary

use Mojo::Base 'App::TeleGramma::Plugin::Base';
use App::TeleGramma::BotAction::Listen;
use App::TeleGramma::Constants qw/:const/;

use File::Spec::Functions qw/catfile/;

my $regex = qr/^thanks [,]? \s* (\w+)/xi;
#$regex = qr/(a)/i;

sub synopsis {
  "Gives the appropriate response to thanks"
}

sub default_config {
  my $self = shift;
  return { };
}

sub register {
  my $self = shift;
  my $thanks_happens = App::TeleGramma::BotAction::Listen->new(
    command  => $regex,
    response => sub { $self->thants(@_) }
  );

  return ($thanks_happens);
}

sub thants {
  my $self = shift;
  my $msg  = shift;

  my ($thankee) = ($msg->text =~ $regex);

  my $result = $thankee;
  while (length $result) {
    last if $result =~ /^[aeiou]/i;
    $result = substr $result, 1;
  }

  return PLUGIN_DECLINED if ! length $result;

  my $thants = "Thanks $thankee, th". lc $result;

  $self->reply_to($msg, $thants);
  return PLUGIN_RESPONDED;
}

1;
