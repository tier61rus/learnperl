#!/usr/bin/perl
$| = 1;

use strict;
use warnings;

use Coro;

# Создание coro-потока с помощью Coro::async
#Coro::async {
#    my $thread_id = shift;
#
#    # Устанавливаем описание для coro-потока
#    $Coro::current->desc("Thread #$thread_id");
#    for (my $i = 0; $i < 1_000_000; $i++) {
#        if ($i % 1000 == 0) {
#            print "$Coro::current->{desc} - Processed: $i items\n";
#            # Помещаем текущий coro-поток в конец ready-очереди
#            $Coro::current->ready();
#            # Передаём управление следующему потоку из ready-очереди
#            Coro::schedule();
#        }
#    }
#} 0;

# Эта функция будет выполняться в отдельном coro-потоке
sub my_thread {
    my $thread_id = shift;

    $Coro::current->desc("Thread #$thread_id");
    for (my $i = 0; $i < 1_000_000; $i++) {
        if ($i % 1000 == 0) {
            print "$Coro::current->{desc} - Processed: $i items\n";
            # Временно передаём управление следующему coro-потоку
            Coro::cede();# поместить текущий поток в конец очереди и достать следующий
        }
    }
}

my @threads = ();
for (my $thread_id = 1; $thread_id < 5; $thread_id++) {
    # Создаём неактивный coro-поток с помощью Coro::new()
    my $thread = new Coro(\&my_thread, $thread_id);
    # Помещаем созданный coro-поток в конец ready-очереди
    $thread->ready();
    push @threads, $thread;
}

while (my $thread = shift @threads) {
    # Блокируем главный coro-поток до тех пор, пока очередной coro-поток не завершится
    $thread->join();
}
