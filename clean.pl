#!/usr/bin/perl
#
# Program ini digunakan untuk mengekstrak bagian konten dari sebuah file HTML
#
# Author: Taufik Fuadi Abidin
# Department of Informatics
# College of Science, Syiah Kuala Univ
# 
# Date: Mei 2011
# http://www.informatika.unsyiah.ac.id/tfa
#
# Dependencies:
# INSTALASI HTML-EXTRACTCONTENT
# See http://www.cpan.org/
#
# 1. Download HTML-ExtractContent-0.10.tar.gz and install
# 2. Download Exporter-Lite-0.02.tar.gz and install
# 3. Download Class-Accessor-Lvalue-0.11.tar.gz and install
# 4. Download Class-Accessor-0.34.tar.gz and install
# 5. Download Want-0.18.tar.gz and install
#

use strict;
use warnings;
use HTML::ExtractContent;
use File::Basename;

# Directory where clean data are stored, its better to set this in config file
my $PATHCLEAN = "/home/tamam/Documents/Belajar_Py/Tugas_4_TWM/Download/clean_sport";

# Directory containing HTML files
my $HTML_DIR = "/home/tamam/Documents/Belajar_Py/Tugas_4_TWM/Download/training_sport";

# Loop through each HTML file in the specified directory
opendir(my $dh, $HTML_DIR) || die "Can't opendir $HTML_DIR: $!";
while (my $file = readdir $dh) {
    next if $file =~ /^\./; # skip hidden files
    next unless $file =~ /\.txt$/; # only process .txt files
    my $html_file = "$HTML_DIR/$file";

    # Extract filename
    my $fileout = basename($html_file) . ".clean.dat";
    print "Processing file: $html_file\n";

    # Open output file
    open my $output_fh, '>', "$PATHCLEAN/$fileout" or die "Cannot open output file: $!";

    # Object
    my $extractor = HTML::ExtractContent->new;
    my $html;

    # Read HTML content from file
    {
        local $/;  # Slurp mode
        open my $html_fh, '<', $html_file or die "Cannot open HTML file: $!";
        $html = <$html_fh>;
        close $html_fh;
    }

    # Extract TITLE
    if ($html =~ /<title.*?>(.*?)<\/title>/) {
        my $title = $1;
        $title = clean_str($title);
        print "<title>$title\t$fileout</title>\n";
        print $output_fh "<title>$title</title>\n";
    }

    # Extract BODY (Content)
    $extractor->extract($html);
    my $content = $extractor->as_text;
    $content = clean_str($content);

    # Split content into three parts based on sentences
    my @sentences = split /\./, $content;
    my $total_sentences = scalar @sentences;
    my $part_size = int($total_sentences / 3);
    my @first_part = @sentences[0..($part_size - 1)];
    my @second_part = @sentences[$part_size..(2 * $part_size - 1)];
    my @third_part = @sentences[(2 * $part_size)..($total_sentences - 1)];

    my $first_content = join "\n", @first_part;
    my $second_content = join "\n", @second_part;
    my $third_content = join "\n", @third_part;

    print $output_fh "<atas>$first_content</atas>\n";
    print $output_fh "<tengah>$second_content</tengah>\n";
    print $output_fh "<bawah>$third_content</bawah>\n";

    close $output_fh;
}

closedir $dh;

sub clean_str {
    my $str = shift;
    $str =~ s/>//g;
    $str =~ s/&.*?;//g;
    #$str =~ s/[\:\]\|\[\?\!\@\#\$\%\*\&\,\/\\\(\)\;"]+//g;
    $str =~ s/[\]\|\[\@\#\$\%\*\&\\\(\)\"]+//g;
    $str =~ s/-/ /g;
    $str =~ s/\n+//g;
    $str =~ s/\s+/ /g;
    $str =~ s/^\s+//g;
    $str =~ s/\s+$//g;
    $str =~ s/^$//g;
    return $str;
}
