import os  # Modul untuk berinteraksi dengan sistem operasi
import requests  # Modul untuk membuat permintaan HTTP
from bs4 import BeautifulSoup  # Modul untuk scraping web

def DownloadBerita(kategori, indeks, bulan, tgl_awal, tgl_akhir, tahun):
    Tgl = int(tgl_awal)
    Tanggal_Akhir = int(tgl_akhir)
    
    while Tgl <= Tanggal_Akhir:
        indeks_loop = 1
        
        while True:
            try:
                Tgl_Awal = f"{Tgl:02d}"
                # Mendapatkan halaman HTML dari Detik berdasarkan parameter yang diberikan
                respon = requests.get(f'https://{kategori}.detik.com/indeks/{indeks_loop}?date={bulan}%2F{Tgl_Awal}%2F{tahun}').text
                print(f'Mengunduh berita dari: https://{kategori}.detik.com/indeks/{indeks_loop}?date={bulan}%2F{Tgl_Awal}%2F{tahun}')
                # Parsing halaman HTML menggunakan BeautifulSoup
                parser = BeautifulSoup(respon, 'lxml')
                # Mendapatkan daftar artikel berita dari halaman HTML
                list_berita = parser.select('div.grid-row.list-content')[0].find_all("article")

                if not list_berita:
                    break
                
                indeks_ditemukan = False

                # Looping untuk setiap artikel berita pada halaman ini
                for berita in list_berita:        
                    link_berita = berita.find('h3', class_='media__title')
                    if link_berita:
                        link_berita = link_berita.find('a').get('href')
                        req_berita = requests.get(link_berita)
                        if req_berita.status_code == 200:
                            # Jika permintaan berhasil, simpan berita ke dalam file teks
                            namaFile = berita.find('h3', {'class':'media__title'}).text.replace(" ","_")
                            namaFile = "".join(x for x in namaFile if x.isalnum() or x in [' ', '_', '.'])
                            # Menyimpan berita ke dalam file dengan nama berdasarkan judul
                            with open(os.path.join("E:\Informatika\KKP BPS\program\detik_sport", f"{namaFile}.txt"), "w", encoding='utf-8') as file:
                                file.write(req_berita.text)
                            indeks_ditemukan = True
                        else:
                            print(f"Gagal untuk mendownload. Error : {req_berita.status_code}")
                    else:
                        print("Tautan berita tidak ditemukan.")

                # Jika tidak ada artikel berita lagi, keluar dari loop
                if not indeks_ditemukan:
                    break

                print(f"Indeks halaman {indeks_loop} selesai diunduh!")
                indeks_loop += 1

            except Exception as e:
                print(f"Terjadi kesalahan saat mengakses URL: {e}")
                continue

        # Menampilkan pesan bahwa semua berita pada tanggal tertentu telah diunduh
        print(f"Berita pada tanggal {bulan}/{Tgl}/{tahun} selesai diunduh.")
        Tgl += 1

# Memanggil fungsi dengan rentang tanggal
DownloadBerita("sport", 1, "06", "01", "30", 2023)