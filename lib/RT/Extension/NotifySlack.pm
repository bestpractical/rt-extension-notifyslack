use strict;
use warnings;
package RT::Extension::NotifySlack;

our $VERSION = '0.01';

use RT::Transaction;

# Set message for Slack notification transactions
$RT::Transaction::_BriefDescriptions{'SlackNotified'} = sub {
    my $self = shift;
    return ( 'Slack notified' );    #loc()
};

=head1 NAME

RT-Extension-NotifySlack - RT ScripAction Slack integration

=head1 DESCRIPTION

This extension provides the following Slack functionality with RT:

* post ticket updates to desired Slack channels

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

You must add the desired Slack channels and webhook URLs to the
RT %SlackWebHookUrls config value in RT_SiteConfig.pm. These values
can be retrieved from Slack's API Incoming Webhooks configuration
settings.

The 'Notify Slack' ScripAction posts to one Slack channel. The default
Slack channel is currently set to #general. You can update this in
the initialdata file by changing the 'Notify Slack' ScripAction
Argument to the desired Slack channel ( be sure to include the '#'
when indicating the channel name ). To post to additional Slack channels,
copy the ScripAction giving it a new Name and Argument.

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

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2018 by Best Practical Solutions, LLC

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut

1;
