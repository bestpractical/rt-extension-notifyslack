use strict;
use warnings;
package RT::Extension::NotifySlack;

our $VERSION = '0.02';

use RT::Transaction;

# Set message for Slack notification transactions
$RT::Transaction::_BriefDescriptions{'SlackNotified'} = sub {
    my $self = shift;
    return ( 'Slack notified' );    #loc()
};

=head1 NAME

RT-Extension-NotifySlack - RT ScripAction Slack/Teams integration

=head1 DESCRIPTION

This extension allows for Slack or Teams updates to be sent out
in the same manner that emails are dispatched. Meaning that
on any condition a Slack or Teams action can be called and a
specific Slack or Teams template can be used to update a channel.

=head1 RT VERSION

Works with RT 4.4

=head1 INSTALLATION

=over

=item C<perl Makefile.PL>

=item C<make>

=item C<make install>

May need root permissions

=item C<make initdb>

See the CONFIGURATION section below before running this command.

Only run this the first time you install this module.

If you run this twice, you may end up with duplicate data
in your database.

=item Edit your F</opt/rt4/etc/RT_SiteConfig.pm>

Add this line:

    Plugin('RT::Extension::NotifySlack');

=item Clear your mason cache

    rm -rf /opt/rt4/var/mason_data/obj

=item Restart your webserver

=back

=head1 CONFIGURATION

You must add the desired Slack or Teams channels and webhook URLs to
the RT %SlackWebHookUrls config value in RT_SiteConfig.pm. These values
can be retrieved from the Slack or Teams API's Incoming Webhooks
configuration settings. See example below:

    Set( %SlackWebHookUrls,
        '#channel' => 'https://myslackwebhookurl...',
    );

The 'Notify Slack' ScripAction posts to one Slack or Teams channel.
The default channel is currently set to #general. You can update this in
the initialdata file by changing the 'Notify Slack' ScripAction
Argument to the desired channel ( be sure to include the '#'
when indicating the channel name and no '#' for direct messaging ).
To post to additional channels, copy the ScripAction giving it
a new Name and Argument, something like "Slack Updates To #Support".
Note that the template formats vary between Slack and Teams.

=head1 AUTHOR

Best Practical Solutions, LLC E<lt>modules@bestpractical.comE<gt>

=for html <p>All bugs should be reported via email to <a
href="mailto:bug-RT-Extension-NotifySlack@rt.cpan.org">bug-RT-Extension-NotifySlack@rt.cpan.org</a>
or via the web at <a
href="http://rt.cpan.org/Public/Dist/Display.html?Name=RT-Extension-NotifySlack">rt.cpan.org</a>.</p>

=for text
    All bugs should be reported via email to
        bug-RT-Extension-NotifySlack@rt.cpan.org
    or via the web at
        http://rt.cpan.org/Public/Dist/Display.html?Name=RT-Extension-NotifySlack

=head1 SEE ALSO

L<https://api.slack.com/messaging/webhooks>,
L<https://docs.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/how-to/add-incoming-webhook>

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2018 by Best Practical Solutions, LLC

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut

1;
