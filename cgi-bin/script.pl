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

print <<'HTML';
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Resultados de Búsqueda</title>
</head>
<body>
    <h1>Resultados de la búsqueda</h1>
HTML

if (@resultados) {
    print "<table border='1'>";
    print "<tr><th>Código</th><th>Nombre</th><th>Tipo</th><th>Licenciamiento</th><th>Fecha Inicio</th><th>Fecha Fin</th><th>Periodo</th><th>Departamento</th><th>Ubicación</th></tr>";
    foreach my $universidad (@resultados) {
        my ($codigo, $nombre, $tipo, $licenciamiento, $fecha_inicio, $fecha_fin, $periodo, $departamento, $latitud, $longitud) = @$universidad;

        my $google_maps_link = qq{<a href="https://www.google.com/maps/search/?api=1&query=$latitud,$longitud" target="_blank">Ver en Google Maps</a>};
        print "<tr><td>$codigo</td><td>$nombre</td><td>$tipo</td><td>$licenciamiento</td><td>$fecha_inicio</td><td>$fecha_fin</td><td>$periodo</td><td>$departamento</td><td>$google_maps_link</td></tr>";
    }
    print "</table>";
} else {
    print "<p>No se encontraron coincidencias.</p>";
}

print <<'HTML';
</body>
</html>
HTML
sub buscar_por_nombre {
    my ($nombre) = @_;
    my @resultados;
    foreach my $universidad (@universidades) {
        if ($universidad->[1] =~ /\Q$nombre\E/i) {
            push @resultados, $universidad;
        }
    }
    return @resultados;
}



