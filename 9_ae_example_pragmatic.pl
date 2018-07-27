#!/usr/bin/env perl
use strict;
use warnings;

# Подключаем AE
use AnyEvent;
# Асинхронный юзер-агент
use AnyEvent::HTTP;
#http://pkg.corp.mail.ru/centos/6/mailru-testing/x86_64/uber_parser-0.30-1.noarch.rpm

my $urls = ['http://pkg.corp.mail.ru/centos/6/mailru-testing/x86_64/uber_parser-0.29-1.noarch.rpm', 'http://pkg.corp.mail.ru/centos/6/mailru-testing/x86_64/uber_parser-0.30-1.noarch.rpm'];

# $cv - переменная состояния
my $cv = AnyEvent->condvar();
# количество запросов
my $count = 0;

for my $url (@$urls) {
    # вывод нам поможет понять, как именно, а что более важно, в каком порядке, выполняется приложение
    print "New event: GET => $url\n";

    #Подобный прием не редкость. Он используется для того, чтобы сборщик мусора не утилизировал наш callback (увеличиваем счетчик ссылок на 1). Если мы уберем undef $guard, ничего работать не будет. 
    my $guard;$guard = http_get(
        $url, sub {
            undef $guard;# ругается тут если нет my $guard;$guard = http_get(
            my ($content, $headers) = @_; 
            print "Content of $url: ".length($content)."\n";
            $count++;
            # если количество успешных запросов равно размеру списка URLов, отправляем данные, на уровень выше.
            $cv->send("Done from $url\n") if $count == scalar @$urls;
        },  
    );  
}
# Нельзя вызывать метод recv без send, или без событий.


my $result = $cv->recv(); # блокировка и ожидание. Собственной персоной.

print "$result\n";
