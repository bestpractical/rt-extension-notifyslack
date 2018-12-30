package RT::Action::NotifySlack;
use base 'RT::Action';

use strict;
use warnings;
use HTTP::Request::Common qw(POST);
use LWP::UserAgent;
use JSON;

sub Describe  {
  my $self = shift;
  return (ref $self . "Send template payload to Slack API.");
}

sub Prepare  {
    return 1;
}

sub Commit {
    my $self = shift;
    # Need to create our MIMEObj
    $self->TemplateObj->Parse(
        TicketObj      => $self->TicketObj,
        TransactionObj => $self->TransactionObj,
        Argument       => $self->Argument,
        ConditionArgs  => $self->ScripObj->{values}->{ConditionArgs}
    );

    my $webhook_urls = RT->Config->Get( 'SlackWebHookUrls' ) || {};
    my $channel = $self->Argument;

    my $webhook_url = undef;
    for my $key ( keys %{ $webhook_urls } ) {
        if ( $key eq $channel ) {
            $webhook_url = $webhook_urls->{ $key };
        }
    }
    return RT::Logger->error( 'Slack channel: ' . $channel .  ' not found. Check %SlackWebHookUrls config values.' ) unless $webhook_url;

    my $ua = LWP::UserAgent->new;
    $ua->timeout(15);

    return unless $self->TemplateObj && $self->TemplateObj->MIMEObj;
    my $payload = $self->TemplateObj->MIMEObj->as_string;

    my $req = POST("$webhook_url", ['payload' => $payload]);

    my $resp = $ua->request($req);

    RT::Logger->error("Failed post to slack, status is:" . $resp->status_line) unless $resp->is_success;

    return 1;
}

1;
