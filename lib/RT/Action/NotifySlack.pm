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

    my $webhook_urls = RT->Config->Get( 'SlackWebHookUrls' ) || {};
    my $channel = $self->Argument;

    my $webhook_url = undef;
    for my $key ( keys %{ $webhook_urls } ) {
        if ( $key eq $channel ) {
            $webhook_url = $webhook_urls->{ $key };
        }
    }
    my $ua = LWP::UserAgent->new;
    $ua->timeout(15);

    my $slack_message = 'Ticket #' . $self->TicketObj->id . ' updated';

    my $payload = {
        text => $slack_message,
    };
    return RT::Logger->error( 'Slack channel: ' . $channel .  ' not found. Check %SlackWebHookUrls config values.' ) unless $webhook_url;

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
