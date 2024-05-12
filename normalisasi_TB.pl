#!/usr/bin/perl

use strict;
use warnings;
use File::Basename;

# Path ke folder masukan dan folder keluaran
my $input_folder = '/home/tamam/Documents/Belajar_Py/Tugas_4_TWM/Download/clean_finance';
my $output_folder = '/home/tamam/Documents/Belajar_Py/Tugas_4_TWM/Download/normalized_finance';

# Pastikan folder keluaran ada atau buat jika belum ada
unless (-e $output_folder or mkdir $output_folder) {
    die "Unable to create $output_folder";
}

# List semua file dalam folder masukan
opendir(my $dh, $input_folder) || die "Can't open $input_folder: $!";
my @files = grep { -f "$input_folder/$_" } readdir($dh);
closedir $dh;

# Proses setiap file dalam folder masukan
foreach my $file (@files) {
    my $input_file = "$input_folder/$file";
    my $output_file = "$output_folder/" . basename($file) . '.dat';

    # Buka file masukan
    open(my $in_fh, '<', $input_file) or die "Could not open file '$input_file' $!";

    # Buka file keluaran
    open(my $out_fh, '>', $output_file) or die "Could not open file '$output_file' $!";

    # Baca isi file masukan, hapus tanda baca kecuali tanda kurung sudut, ubah menjadi huruf kecil, dan tulis ke file keluaran
    while (my $line = <$in_fh>) {
        # Hapus tanda baca kecuali tanda kurung sudut
        $line =~ s/[^\w\s<>]//g;
        # Ubah semua huruf menjadi huruf kecil
        $line = lc($line);
        # Tulis baris yang sudah dimodifikasi ke file keluaran
        print $out_fh $line;
    }

    # Tutup file
    close($in_fh);
    close($out_fh);

    print "Tanda baca berhasil dihapus kecuali tanda kurung sudut <> dan semua huruf telah diubah menjadi huruf kecil. Hasil disimpan di '$output_file'.\n";
}

print "Proses normalisasi selesai.\n";
