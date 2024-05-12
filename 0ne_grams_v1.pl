#!/usr/bin/perl

use lib '../lib';
use Lingua::EN::Bigram;
use strict;

my $PATH = "/home/tamam/Documents/Belajar_Py/Tugas_4_TWM/one_grams";
open TOFILE, "> $PATH/kamus_1grams.txt" or die "Cannot Open File!!!";

my %stopwords;

load_stopwords(\%stopwords);

my $file = $ARGV[ 0 ];
if (! $file) {
  print "Cara jalankan: $0 <file>\n";
  exit;
}

open F, $file or die "Can't open input: $!\n";
my $text = do { local $/; <F> };


close F;


# build n-grams
my $ngrams = Lingua::EN::Bigram->new;
$ngrams->text( $text );

# get word counts
my $word_count = $ngrams->word_count;

my $index = 0;


foreach my $word (keys %$word_count ) {
	
	# skip stopwords and punctuation
	next if ( $stopwords{ $word } );
	next if ( $word =~ /[,.?!:;()\-]/ );
	
	$index++;

	print TOFILE "$$word_count{ $word }\t$word\n";

}

sub load_stopwords 
{
  my $hashref = shift;
  open IN, "</home/tamam/Documents/Belajar_Py/Tugas_4_TWM/stopword.txt" or die "Cannot Open File!!!";
  while (<IN>)
  {
    chomp;
    if(!defined $$hashref{$_})
    {
       $$hashref{$_} = 1;
    }
  }  
}

  