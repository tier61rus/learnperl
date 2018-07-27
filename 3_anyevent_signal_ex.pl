#!/usr/bin/perl

use strict;
use warnings;

use AnyEvent;
use AnyEvent::Strict;
$|++;

print "START with pid $$\n";
my $done = AnyEvent->condvar;

# set up event handler
my $w = AnyEvent->signal(signal => "HUP", cb => sub {
    print "Got SIGHUP, reloading...\n";
    $done -> send();
});

# wait for event
$done->recv;

exit 0;
