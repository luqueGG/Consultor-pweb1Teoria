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

open my $fh, '<', $csvArchivo or die "Archivo no puede abrise '$csvArchivo' $!";
while (my $row = $csv->getline($fh)) {
    push @universidades, $row;
}
close $fh;

my $seleccion = $cgi->param('seleccion') || '';
my $ingreso = $cgi->param('ingreso') || '';
my $tipo_lugar = $cgi->param('tipoLugar') || ''; 
my $valor_lugar = $cgi->param('valorLugar') || ''; 

my %despacho = (
    'opcionNombre'    => \&buscar_por_nombre,
    'opcionLicencia'  => \&buscar_por_licenciamiento,
    'opcionLugar'     => \&buscar_por_lugar,
    'opcionGestion'   => \&buscar_por_gestion,
);

my @resultados;
if (exists $despacho{$seleccion}) {
    @resultados = $despacho{$seleccion}->($ingreso, $tipo_lugar, $valor_lugar);
} else {
    print "<p>Opcion de busqueda no valida.</p>";
    exit;
}

