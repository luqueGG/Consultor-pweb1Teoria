#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use Text::CSV;

my $cgi = CGI->new;
print $cgi->header("text/html; charset=UTF-8");
