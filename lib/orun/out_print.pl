# Proof of Concept in Perl

use strict;

foreach (@ARGV) {
  print "$_\n" || exit 1;
}

exit 0;
