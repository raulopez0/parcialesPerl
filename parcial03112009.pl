#!/usr/bin/perl

$fileCultivos = "Cultivos";

@hoy = localtime( time );

while ( $#hoy >2 ) {
  pop( @hoy );
}

print join("/", @hoy);
if ( $#ARGV+1 < 1 ) {
  die "ERROR: cantidad de parametros incorrecto";
}

$fileOut = shift( @ARGV );

open( FILECULTIVOS, "<".$fileCultivos ) or die "ERROR:no existe el archivo de cultivos o no se puede abrir";
$cultivos = join( "", <FILECULTIVOS> );
@losCultivos = split( /\n/, $cultivos );

if ( $#losCultivos == -1 ) {
  die "ERROR:El archivo de cultivos esta vacio.";
}

if ( -f "$fileOut" ) {
    die "ERROR:El archivo salida ya existe.";
}

print "Codigo de zona:";
$codigoDeZona = <STDIN>;
chomp( $codigoDeZona );

( $resultado, $nombreZona, $cultivo ) = validarZona( $codigoDeZona );
if ( $resultado eq "ERROR" ) {
  die "ERROR: el codigo de zona ingresado no existe";
}

%datos;

foreach $line ( @losCultivos ) {
  chomp( $line );
  @registro = split( /:/, $line );

  if ( $registro[1] eq $codigoDeZona ) {
    $datos{ $registro[2] } += $registro[5] - $registro[3];
    print "\n {".$registro[2]."} += ".$registro[3]." - ".$registro[5];  
  
  }
}

open( FILEOUT, ">".$fileOut ) or die "ERROR: no exuiste el archivo de salida";

foreach $i ( keys( %datos ) ) {
  if ( $datos{ $i } < 0 ) {
    print FILEOUT $codigoDeZona.";".$nombreZona.";".$i.";".$datos{ $i }.";".$ENV{"USER"}.";".$ENV{"date"}."\n";
  }
}


sub validarZona() {
  $resultado = "ERROR";

  my $codZona = shift( @_ );
  open( FILEZONAS, "zonas.tab" ) or die "No existe el archivo de zonas";

  $misZonasStr = join( "", <FILEZONAS> );
  @misZonas = split( /\n/, $misZonasStr);

  while ( ($resultado eq "ERROR") && ($#misZonas+1>0) ) {
    $zonaActual = shift( @misZonas );

    ( $miCodigo, $miNombre ) = split( /;/, $zonaActual );

    if ( $miCodigo eq $codZona ) {
      $resultado = "NOERROR";
    }
  }
  close( FILEZONAS );

  return ( $resultado, $miCodigo, $miNombre );
}

close( FILECULTIVOS );
close( FILEOUT );
