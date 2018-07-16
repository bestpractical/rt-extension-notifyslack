use inc::Module::Install;

RTx     'RT-Extension-NotifySlack';
license 'gpl_2';
repository 'https://github.com/bestpractical/rt-extension-notifyslack';

requires_rt '4.4.0';
rt_too_new '4.6.0';

sign;
WriteAll;
