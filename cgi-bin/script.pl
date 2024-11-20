#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use Text::CSV;

my $cgi = CGI->new;
print $cgi->header("text/html; charset=UTF-8");

my $csvArchivo = "/usr/lib/cgi-bin/Data_Universidades_LAB06.csv";
my @universidades;
my @resultados;
my $csv = Text::CSV->new({ binary => 1, auto_diag => 1 });
