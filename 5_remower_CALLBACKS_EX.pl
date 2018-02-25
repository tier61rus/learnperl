#!/usr/bin/perl -w
use strict;
use Data::Dumper;
my $folder_path = "./20_for_format_zopfli";
my @folders = ('32x32','45x45','90x90','180x180');
our $functions;

my $command = shift @ARGV or die "got no command in ARGS!\nUsage: $0 --command file_name1 file_name2 etc\n";
$command = ($command =~ /--(\S+)$/) ? $1 : undef;
#print "Command:--$command--\n";

if (!$command) {
    die "no command in input\n";
} elsif (not exists $functions->{$command}) {
    #print "--$functions->{$command}--\n";
    print "all_supportable functions :".(Dumper $functions);
    die "UNSUPPORTABLE COMMAND \n";
}

my @files = @ARGV or die "NOT ENOUGHT INPUT ARGS!\nUsage: $0 --command file_name1 file_name2 etc\n";

ARRAY_ITER: {
    foreach my $file_name (@files) {
        print (("="x50)."\n");
        foreach my $folder (@folders){
            print (("-"x30)."\n");
            my $file_full = $folder_path.'/'.$folder.'/'.$file_name;
            print "we make ".uc($command)." of file_full = $file_full\n";
            print $functions->{$command}->($file_full);#making calback
        }
    }
}
BEGIN {
    our $functions = {
        'remove' => sub {
            my $file = shift;
            if (-f $file){
                print "We are deleting $file\n";
                unlink $file;
            } else {
                return "Error: File $file you want to delete doesn't exist\n";
            }
            if (-f $file){
                return "Error: File $file wasn't deleted\n";
            } else {
                return "OK: File $file was deleted\n";
            }
            #unlink $file;
        },
        'check' => sub {
            if (-f $_[0]){
                return "file $_[0] is OK\n";
            } else {
                return "no such file\n";
            }
        }
    }
}
