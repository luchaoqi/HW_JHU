#! /usr/bin/perl
# convert text to DNA sequence and back using algorithm in
# https://www.sciencemag.org/content/early/2012/08/15/science.1226355.full
#
# Copyright (C) 2012  David Dooling <ddooling@wustl.edu>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

use warnings;
use strict;
use Getopt::Long;
use IO::Handle;
use Pod::Usage;

my $pkg = 'dna-encode';
my $version = '0.3';

# process command line
my ($decode, $little_endian, $revcomp, $verbose);
if (!&GetOptions(help => sub { &pod2usage(-exitval => 0) },
                 decode => \$decode,
                 'little-endian' => \$little_endian,
                 'reverse-complement' => \$revcomp,
                 'seed=i' => sub { srand($_[1]); },
                 verbose => \$verbose,
                 version => sub { print "$pkg $version\n"; exit 0 }))
{
    warn("Try ``$pkg --help'' for more information.\n");
    exit(1);
}

# store information for later
my ($header, $count, $message, @messages);
# loop through input
while (my $line = <>) {
    chomp($line);
    # look for fast[aq] header
    if ($line =~ m/^[+@>]/) {
        # print previous message
        if ($message) {
            push(@messages, [$header, $message]);
        }
        $header = $line;
    }
    else {
        # assume dna
        $message .= $line;
    }
}
# clean up last message
push(@messages, [$header, $message]);

# encode and output the information
foreach my $hm (@messages) {
    my ($header, $message) = @$hm;
    print("$header\n") if $header;
    my ($result, $binary);
    if ($decode) {
        # make sure it looks like DNA
        if ($message =~ m/[^ACGTacgt]/) {
            # just print it (perhaps fastq quality)
            ($result, $binary) = ($message, '');
        }
        else {
            ($result, $binary) = decode($message);
        }
    }
    else {
        ($result, $binary) = encode($message);
    }
    if ($verbose) {
        STDERR->print("$pkg: $message\n");
        STDERR->print(join(' ', "$pkg:", length($message), length($binary)), "\n");
        STDERR->print("$pkg: $binary\n");
    }
    print("$result\n");
}

exit(0);

# encode text to DNA
sub encode {
    my ($text) = @_;

    # convert to big endian binary
    my $template = ($little_endian) ? 'b*' : 'B*';
    my $binary = unpack($template, $text);
    my @bits = split('', $binary);
    # convert to dna
    my @bases;
    foreach my $b (@bits) {
        if ($b == 0) {
            # A or C
            push(@bases, ('A', 'C')[int(rand(2))]);
        }
        else {
            # G or T
            push(@bases, ('G', 'T')[int(rand(2))]);
        }
    }
    if ($revcomp) {
        @bases = map { tr/ACGT/TGCA/; $_ } reverse @bases;
    }
    my $dna = join('', @bases);
    return ($dna, $binary);
}

# decode text to DNA
sub decode {
    my ($dna) = @_;

    # convert to binary
    my @bases = split('', $dna);
    if ($revcomp) {
        @bases = map { tr/ACGT/TGCA/; $_ } reverse @bases;
    }
    my $binary;
    foreach my $base (@bases) {
        if ($base eq 'A' || $base eq 'C') {
            $binary .= '0';
        }
        elsif ($base eq 'G' || $base eq 'T') {
            $binary .= '1';
        }
        else {
            die("$pkg: invalid base: $base");
        }
    }

    # convert binary to text
    my $template = ($little_endian) ? 'b*' : 'B*';
    my $text = pack($template, $binary);

    return ($text, $binary);
}

__END__

=pod

=head1 NAME

dna-encode - encode and decode ASCII text into DNA

=head1 SYNOPSIS

B<dna-encode> [OPTIONS]... F<[FILE]...>

=head1 DESCRIPTION

This script encodes a string of characters first into big endian
(network order) binary and then into DNA where zero become A or C and
one becomes G or T.

This implementation is based on the algorithm described in L<George
M. Church, Yuan Gao, and Sriram Kosuri. Next-Generation Digital
Information Storage in DNA. Science 2012. DOI:
10.1126/science.1226355|https://www.sciencemag.org/content/early/2012/08/15/science.1226355.full>.

=head1 OPTIONS

If an argument to a long option is mandatory, it is also mandatory for
the corresponding short option; the same is true for optional arguments.

=over 4

=item -d, --decode

Decode a DNA sequence into a message rather than the default of
encoding a message into DNA.

=item -h, --help

Display a brief description and listing of all available options.

=item -l, --little-endian

Encode/decode characters using little endian byte order rather than
the default big endian byte order.

=item -r, --reverse-complement

Reverse complement the DNA after encoding (or before decoding).

=item -s SEED, --seed=SEED

Use the seed SEED for the random number generator rather than the Perl
default.

=item --verbose

Output intermediate binary when encoding/decoding.

=item --version

Output version information and exit.

=item --

Terminate option processing.  This option is useful when file names
begin with a dash (-).

=back

=head1 BUGS

No known bugs.

=head1 SEE ALSO

L<https://www.sciencemag.org/content/early/2012/08/15/science.1226355.full>
L<perlfunc(1)>

=head1 AUTHOR

David Dooling <dooling@gmail.com>

=cut
