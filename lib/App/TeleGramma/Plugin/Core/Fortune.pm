package App::TeleGramma::Plugin::Core::Fortune;

use Mojo::Base 'App::TeleGramma::Plugin::Base';
use App::TeleGramma::BotAction::Listen;
use App::TeleGramma::Constants qw/:const/;

use File::Spec::Functions qw/catfile/;
use Mojo::Util qw/slurp/;

sub synopsis {
  "Responds with fortunes"
}

sub default_config {
  my $self = shift;
  return { fortune_path => "/your/path/here" };
}

sub register {
  my $self = shift;

  # sanity checks
  my $fp = $self->read_config->{fortune_path};
  die "fortune_path '$fp' does not exist or is not a directory - check your config\n"
    unless (-d $fp);

  my $fortune_command = App::TeleGramma::BotAction::Listen->new(
    command  => '/fortune',
    response => sub { $self->emit_fortune(@_) }
  );
  return ($fortune_command);
}

sub emit_fortune {
  my $self = shift;
  my $msg  = shift;

  $self->reply_to($msg, $self->_get_fortune());
  return PLUGIN_RESPONDED;
}

sub _get_fortune {
  my $self = shift;
  my $path = $self->read_config->{fortune_path};

  opendir (my $dh, $path) || die "can't opendir $path: $!";
  my @files = grep { ! /.dat$/ && -f catfile($path, $_) } readdir($dh);
  closedir($dh);

  my $file = $files[rand @files];
  my $entries = slurp(catfile($path, $file));

  my @entries = split /^%$/m, $entries;
  my $entry = $entries[rand @entries];

  return $entry;
}

1;
