package App::TeleGramma::Constants;

use strict;
use warnings;

use Exporter qw/import/;

use constant {
  PLUGIN_NO_RESPONSE      => 'NO_RESPONSE',
  PLUGIN_NO_RESPONSE_LAST => 'NO_RESPONSE_LAST',
  PLUGIN_RESPONDED        => 'RESPONDED',
  PLUGIN_RESPONDED_LAST   => 'RESPONDED_LAST'
};

our @EXPORT_OK = qw/
  PLUGIN_NO_RESPONSE
  PLUGIN_NO_RESPONSE_LAST
  PLUGIN_RESPONDED
  PLUGIN_RESPONDED_LAST
/;
our %EXPORT_TAGS = (const => \@EXPORT_OK);
