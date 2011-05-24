#!/usr/bin/perl

if ( $#ARGV+1 < 1 ) {
  die( "ERROR en parametros" );
}


$filein = shift( ARGV );
$codPais = shift( ARGV );


if ( ( $filein !~ /^BID[0-9][0-9][0-9]$/ ) && ( $filein !~ /^BM[0-9][0-9][0-9]$/ )  ) {
  die( "\nERROR en formato de ".$filein );
}

if ( $filein =~ /^BID[0-9][0-9][0-9]$/ ) {
  $entidad = "BID";
}
if ( $filein =~ /^BM[0-9][0-9][0-9]$/ ) {
  $entidad = "BM";
}


if ( $codPais eq "" ) {
  $codPais = "613";
}

open( INFILE, "<".$filein ) or die "ERROR: el archivo de entrada no existe";

@validacion = validarParametroOpcional( $codPais );

if ( $validacion[0] eq "FALSE" ) {
  print "\nERROR, codigo de pais inválido";
}
  
$fileout = ">salida.txt";
open( OUTFILE, $fileout);

# $oportunidad = 0;
# do {
#   print "\nIngrese archivo de salida:";
#   $fileout = <STDIN>;
# } while ( ! open( OUTIFILE, $fileout) );

# if ( $oportunidad == 5 ){ die(); }



#recibe por parametro INFILE, codigo de pais.return hash key=fecha, val=monto
%estadisticas = cargarEstadisticas( INFILE, $codPais );

$txt = "";
$sum = 0;

foreach $annio ( keys(%estadisticas) ) {
  $txt = $txt."año ".$annio."-->".$estadisticas{ $annio }."\n";
  $suma += $estadisticas{ $annio };
}


print OUTFILE  "Totales de préstamos puestos a disponbilidad por el ";
print OUTFILE  $entidad."en ".$validacion[1]."\n";
print OUTFILE  $txt;
  
close( INFILE );
close( OUTIFILE );

sub cargarEstadisticas() {

  my $INFILE = shift( _ );
  my $codigo = shift( _ );

  foreach $i ( <INFILE> ) {
    chomp( $i );
    @registro = split( /,/, $i);
    if ( $codigo == $registro[0] ) {
      $estadisticas{ $registro[2] } += $registro[3];
    }
  }

  return %estadisticas;
}


sub validarParametroOpcional() {

  my $codigo = shift( @_ );
  open( PAISESFILE , "<paises.tab" ) or die "\n ERROR, no existe el archivo de paises";

  
  $encontrado = "FALSE";

  my $line="";
  while ( ($encontrado eq "FALSE") && ($line = <PAISESFILE>)  ) {
    chomp( $line );

    ( $cod, $nombre ) = split( /;/, $line );
    if ( $cod == $codigo ) {
      $encontrado = "TRUE";
    }
  }

  close PAISESFILE;

  return ( $encontrado, $nombre );
}