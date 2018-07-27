#!/usr/bin/env perl

use strict;
use warnings;

use Coro;
use AnyEvent;
use AnyEvent::HTTP;

use Data::Dumper;

my $coro = async {
	print {*STDERR} "async: before get\n";

	http_get "http://pkg.corp.mail.ru/", Coro::rouse_cb();
	my @ret = Coro::rouse_wait();

	print {*STDERR} "async: after get\n";

	#print Dumper $ret[1];
    print "status asynk = ".$ret[1]->{'Status'}."\n";

	return 1;
}

#main

print {*STDERR} "main: before get\n";
http_get "http://pkg.corp.mail.ru/", Coro::rouse_cb();
my @ret = Coro::rouse_wait();
print {*STDERR} "main: after get\n";
print "status main = ".$ret[1]->{'Status'}."\n";

my $r = $coro->join();
print {*STDERR} "main: join ret: $r\n";


######### OUT ##########
#main: before get
#async: before get
#main: after get
#status main = 200
#async: after get
#status asynk = 200
#main: join ret: 1

