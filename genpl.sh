#! /bin/bash --
# by pts@fazekas.hu at Sun Feb  3 14:50:42 CET 2019

set -ex
# Example #1: -DCONFIG_DEBUG
gcc -C -E -DCONFIG_LANG_PERL "$@" -ansi -O2 -W -Wall -Wextra -Werror muaxzcat.c >muaxzcat.pl.tmp1
(<muaxzcat.c perl -ne '
    $_ = join("", <STDIN>);
    die "Missing numeric constants.\n" if !s@NUMERIC_CONSTANTS[^\n]*\n(.*?\n)#endif@@s;
    $_ = "$1\n";
    s@/[*].*?[*]/@ @sg;
    s@^#define\s+(\w+)\s+(.*?)\s*$@sub $1() { $2 }@mg;
    s@\s*\n\s*@\n@g;
    s@\A\s+@@;
    print "$_\n\n"' &&
<muaxzcat.pl.tmp1 perl -0777 -pe 's@\A.*START_PREPROCESSED\s+@@s') >muaxzcat.pl.tmp2 || exit "$?"
(echo '#! /usr/bin/env perl
#
# muxzcat.pl: tiny .xz and .lzma decompression filter
# by pts@fazekas.hu at Thu Feb  7 00:19:59 CET 2019
#
# Usage: perl muxzcat.pl <input.xz >output.bin
#
# https://github.com/pts/muxzcat
#
# This is free software, GNU GPL >=2.0. There is NO WARRANTY. Use at your risk.
#
# This file was autogenerated by genpl.sh from muaxzcat.c.
#
BEGIN { $^W = 1 }
use integer;  # This is required.
use strict;   # Optional.
BEGIN {
die "fatal: your Perl does not support integer arithmetic\n" if 1 / 2 * 2;
die "fatal: your Perl cannot do 32-bit integer arithmetic\n" if
    abs(1 << 31 >> 31) != 1;
$_ = <<'\''ENDEVAL'\'';
' &&
<muaxzcat.pl.tmp2 perl -0777 -pe 's@^#(?!!).*\n@@gm; sub cont($) { my $s = $_[0]; $s =~ s@\A\s+@@; $s =~ s@\s+\Z(?!\n)@@; $s =~ s@\n[ \t]?([ \t]*)@\n$1# @g; $s } s@/[*](.*?)[*]/\n*@ "# " . cont($1) . "\n" @gse;
    s@([^\s#]) (#.*)|(#.*)@ defined($1) ? "$1  $2" : $3 @ge;
    s@^[ \t]*do \{\} while \(0 && .*\n@@mg;
    s@^[ \t]*;[ \t]*\n@@mg;
    s@(#.*)|[ \t]+;@ defined($1) ? $1 : ";" @ge;
    s@^[ \t]*GLOBAL @@mg' &&
echo 'ENDEVAL
if ((1 << 31) < 0) {  # 32-bit Perl.
  sub lt32($$) {
    my $a = $_[0] & 0xffffffff;
    my $b = $_[1] & 0xffffffff;
    ($a < 0 ? $b >= 0 : $b < 0) ? $b < 0 : $a < $b
  }
  s@\bLT\[([^\]]+)\],\[([^\]]+)\]@lt32($1, $2)@g;
  s@\bLE\[([^\]]+)\],\[([^\]]+)\]@!lt32($2, $1)@g;
  s@\bGT\[([^\]]+)\],\[([^\]]+)\]@lt32($2, $1)@g;
  s@\bGE\[([^\]]+)\],\[([^\]]+)\]@!lt32($1, $2)@g;
} else {  # At least 33-bit Perl, typically 64-bit.
  my %cmph = qw(LT < LE <= GT > GE >=);
  # This is much faster than lt32 above.
  s@\b(LT|LE|GT|GE)\[([^\]]+)\],\[([^\]]+)\]@((($2) & 0xffffffff) $cmph{$1} (($3) & 0xffffffff))@g;
}
eval; die $@ if $@ }

exit(Decompress())') >muaxzcat.pl || exit "$?"
# TODO(pts): Better multiline comments with * continuation.
# TODO(pts): Keep empty lines above FUNC_ARG0(SRes, Decompress) (gcc -C -E removes it).
: cp -a muaxzcat.pl muxzcat.pl

: genpl.sh OK.
