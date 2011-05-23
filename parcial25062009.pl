#!/usr/bin/perl


if ( $#ARGV+1 < 4 ) {
  print "ERROR, faltan parametros...\n";
  exit;
}

$fileOut = "salida.txt";
print "\nIngrese archivod e salida (".$fileOut.") :";

$in = <STDIN>;
chomp( $in );

if ( $in ne "" ) {
  $fileOut = $in;
}

$file = shift( @ARGV );
$separador = shift( @ARGV );
$posProducto = shift( @ARGV );
$posCantidad = shift( @ARGV );

if ( posProducto == posCantidad || posCantidad>6 || posProducto>6 ) {
  print "ERROR en parametros";
  exit;
}
open( PRODFILE, '<'.$file ) or die "\n ERROR, no se pudo abrir el archivo de datos,,,\n";
open( OUTFILE, ">".$fileOut ) or die "\n ERROR, no se pudo abrir el archivo de salida,,,\n";

$fileStr = "";


while ( <PRODFILE> ) {
  $fileStr = $fileStr.$_;
}
close(PRODFILE);
$fileStr =~ tr/\n/_/s;
@registros = split( /_/, $fileStr );

%datos;

foreach $reg ( @registros ) {

  @campos = split( /$separador/, $reg );

  if ( $#campos+1 < 2 ) {
    print "\n ERROR 2 campos...\n";
  }

  $producto = $campos[ $posProducto ];
  $cantidad = $campos[ $posCantidad ];


  if ( exists $datos{ $producto } ) {
    $datos{ $producto } = $datos{ $producto }  + $cantidad;
  }
  else {
    $datos{ $producto } = $cantidad;
  }
}

foreach $key ( keys(%datos) ) {
  if ( $datos{ $key } >= 1000 ) {
    print OUTFILE $key." --> ".$datos{ $key }."\n";
  }
}

close(OUTFILE);
