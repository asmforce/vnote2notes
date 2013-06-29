#!/usr/bin/perl
#
# Copyright (c) 2012, Vitaliy Krutko, asmxforce@gmail.com
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy of  this
# software and associated documentation files (the "Software"), to deal in the  Software
# without restriction, including without limitation the  rights  to  use,  copy,  modify,
# merge, publish, distribute, sublicense, and/or sell copies of  the  Software,  and  to
# permit persons to whom the Software is furnished to do so, subject  to  the  following
# conditions:
#
#  The above copyright notice and this permission notice shall be included in all copies
# or substantial portions of the Software.
#
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS  OR  IMPLIED,
# INCLUDING  BUT  NOT  LIMITED  TO  THE WARRANTIES  OF  MERCHANTABILITY,   FITNESS   FOR
# A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS  OR  COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN  ACTION  OF
# CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH  THE  SOFTWARE
# OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#


$src = shift();
$out = shift();

if( !defined($src) )  {
  print "usage: vnote2note.pl <source> [output]\n";
  exit( -1 );
}


if( defined($out) )  {
  open( STDOUT, ">$out" )
    or die('error: cannot redirect standard output stream to file `$out`');
}
binmode( STDOUT, ":raw:utf8" );



sub unescape_vnote
{
  my $note = shift();

  use bytes;
  $note =~ s/=([a-fA-F\d]{2})/pack('H*',$1)/eg;
  return $note;
}


sub parse_vnote
{
  my $file = shift();
  my $begin = false;
  my $end = false;

  my $creationTime;
  my $modificationTime;
  my $note;

  while( my $line = <$file> )
  {
    chomp $line;

    if( $line =~ m/\s*BEGIN\s*:\s*VNOTE\s*/ )
    {
      if( $begin eq true || $end eq true )
      {
        print STDERR "error: unexpected line `$line`\n";
        return false;
      }
      $begin = true;
      #print "vnote  {\n";
      next;
    }

    if( $line =~ m/\s*BODY.*?:(.*)/ )
    {
      $note = $1;

      while( chop($line) eq '=' )
      {
        chop $note;

        # must be a note body continuation
        $line = <$file> or last;
        chomp $line;

        $note .= $line;
      }

      $note = unescape_vnote( $note );
      next;
    }

    if( $line =~ m/\s*DCREATED\s*:\s*(\d\d\d\d)(\d\d)(\d\d)T(\d\d)(\d\d)(\d\d)\s*/ )
    {
      #$creationTime = "$1.$2.$3 $4:$5:$6";
      $creationTime = "$3.$2.$1 $4:$5";
      next;
    }

    if( $line =~ m/\s*LAST-MODIFIED\s*:\s*(\d\d\d\d)(\d\d)(\d\d)T(\d\d)(\d\d)(\d\d)\s*/ )
    {
      #$modificationTime = "$1.$2.$3 $4:$5:$6";
      $modificationTime = "$3.$2.$1 $4:$5";
      next;
    }

    if( $line =~ m/\s*END\s*:\s*VNOTE\s*/ )
    {
      if( $begin eq false || $end eq true )
      {
        print STDERR "error: unexpected line `$line`\n";
        return false;
      }
      $end = true;
      next;
    }

    # else - ignore a line
  }

  if( $begin eq true && $end eq true )
  {
    print $creationTime, "\n";
    print( $modificationTime, "\n" ) if( $creationTime != $modificationTime );
    print $note, "\n\n";
    return true;
  }

  return false;
}



foreach my $srcname ( reverse glob("$src") )
{
  if( -f $srcname )
  {
    open( my $file, '<:crlf:utf8', $srcname ) or next;

    if( false eq parse_vnote($file) )  {
      print STDERR "error: ill-formed vnote in `$scrname`\n";
    }
    close( $file );
  }
}
