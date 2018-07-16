package RT::Action::NotifySlack;
use base 'RT::Action';

use strict;
use warnings;
use HTTP::Request::Common qw(POST);
use LWP::UserAgent;
use JSON;

sub Describe  {
  my $self = shift;
  return (ref $self . " will post ticket updates to slack channel.");
}

sub Prepare  {
    return 1;
}

sub Commit {
    my $self = shift;

    my $webhook_url = RT->Config->Get( 'SlackWebHookUrl' );
    my $default_channel = RT->Config->Get( 'SlackDefaultChannel' );

    my $ua = LWP::UserAgent->new;
    $ua->timeout(15);

    my $slack_message = 'Ticket #' . $self->TicketObj->id . ' updated';

    my $payload = {
        channel => $default_channel // $default_channel,
        text => $slack_message,
    };

    my $req = POST("$webhook_url", ['payload' => encode_json($payload)]);

    my $resp = $ua->request($req);

    if ($resp->is_success) {
        RT::Logger->debug('Posted to slack!');
    } else {
        RT::Logger->debug("Failed post to slack, status is:" . $resp->status_line);
    }

    return 1;
}

1;
