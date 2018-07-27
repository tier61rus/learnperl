#!/usr/bin/perl -w 
#use AnyEvent;
use AnyEvent::Strict;
#Программа ожидает ввода пользователя с STDIN, и если ввода нет в течении 10 секунд, или получили нужный сигнал— прерывает свою работу. 
#Если ввод есть — выводит введённую строку.


print "Start work with $$\n";
my $sign = "CHLD";
print "For stoping use:\nkill -".$sign." ".$$."\n";
$|++;
my $done = AnyEvent->condvar; # это уникальный тип, который можно отождествить с обещаниями, т.е. будущими значениями, которые мы ожидаем получить. Поскольку в интерфейсе AnyEvent нет как такового основного цикла событий (т.е. когда программа переходит в режим блокирующего ожидания), то единственным способ заблокироваться в ожидании — попытаться получить значение переменной состояния:

my ($w, $t, $s);
#my ($w, $t);
$w = AnyEvent->io (
    fh => \*STDIN,
    poll => 'r',
    cb => sub {
        chomp (my $input = <STDIN>);
        warn "read: $input\n";
        undef $w;
        undef $t;
        undef $s;
        $done->send();
    });

$t = AnyEvent->timer (
    after => 10,
    cb => sub {
        if (defined $w) {
            warn "no input for a 10 sec\n";
            undef $w;
            undef $t;
            undef $s;
        }
        $done->send();
    });

#Signal watchers can be used to wait for "signal events", which means your process was sent a signal (such as SIGTERM or SIGUSR1).
$s = AnyEvent->signal (
    signal => "CHLD",
    cb => sub {
            warn "GOT SIGCHLD, END of work\n";
            undef $w;
            undef $t;
            undef $s; 
        $done->send();
    });

$done->recv()
