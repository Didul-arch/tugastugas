#import "lib/format_ppki.typ": *

#show: ppki.with(
  judul: "Judul Karya Ilmiah Anda",
  nama-penulis: "Syafiq Syadidul Azmi",
  nim: "G6401231075",
  program-studi: "Ilmu Komputer",
  fakultas: "Sekolah Sains Data Matematika dan Informatika",
  tahun: "2026",
  jenis-karya: "laporan-akhir",
)

// ── Bagian Awal (nomor halaman Romawi: i, ii, iii, …) ──
#show: bagian-awal

#halaman-sampul(
  judul: "Laporan tugas kuliah pengolahan citra digital materi morfologi",
  nama: "SYAFIQ SYADIDUL AZMI",
  nim: "G6401231075",
  kelas: "PCD K3",
  program-studi: "ILMU KOMPUTER",
  fakultas: "Sekolah Sains Data Matematika dan Informatika",
  tahun: "2026",
  logo: image("assets/logo-ipb.png", width: 2.5cm),
)

#daftar-isi()
#daftar-gambar()   // hapus baris ini jika gambar ≤ 1

// ── Bagian Isi (nomor halaman Arab: 1, 2, 3, …) ────────
#show: bagian-isi

= BAGIAN 1 
== Nomor 1.1
Morfologi matematika dalam pengolahan citra digital adalah teknik analisis citra yang didasarkan pada bentuk geometri.
Dua Operasi dasar dalam morfologi adalah:

+ *Erosi* ($A minus.o B$)
  Operasi ini "mengikis" batas objek. Secara formal didefinisikan sebagai:
  $ A minus.o B = { z | (B)_z subset.eq A } $

+ *Dilatasi* ($A plus.o B$)
  Operasi ini "mempertebal" atau menambahkan lapisan ke batas objek. Secara formal didefinisikan sebagai:
  $ A plus.o B = { z | (hat(B))_z inter A != nothing } $

== Nomor 1.2
Structuring Element (B) adalah sebuah matriks atau pola kecil yang digunakan dalam operasi morfologi seperti cetakan/pemindai untuk menentukan bagaimana piksel di sekitar piksel pusat (z) akan diproses. Contoh structuring element: 
$ B = mat(delim: "[",
  0, 1, 0;
  1, 1, 1;
  0, 1, 0;
) $ adalah structuring element berbentuk lingkaran untuk menghilangkan tonjolan tajam yang tidak berbentuk bulat.

$ B = mat(delim: "[", 0, 0, 0; 1, 1, 1; 0, 0, 0) $ atau $ B = mat(delim: "[", 0, 1, 0; 0, 1, 0; 0, 1, 0) $ 
adalah structuring element berbentuk garis yang berfungsi untuk menghilangkan semua struktur kecil kecuali yang memiliki arah atau orientasi yang sama dengan garis tersebut.

== Nomor 1.3
Diberikan citra $A$ berukuran $5 times 5$ dan elemen penstruktur $B$ ($3 times 3$ persegi, pusat di tengah):
$ A = mat(delim: "[",
  0, 0, 0, 0, 0;
  0, 1, 1, 1, 0;
  0, 1, 1, 1, 0;
  0, 1, 1, 1, 0;
  0, 0, 0, 0, 0;
), quad B = mat(delim: "[",
  1, 1, 1;
  1, 1, 1;
  1, 1, 1;
) $

=== Erosi ($A minus.o B$)
*Langkah:* Pusat $B$ diletakkan pada setiap piksel $A$. Hasil bernilai $1$ hanya jika seluruh elemen $B$ (kotak $3 times 3$) menutupi angka $1$ pada $A$.
- Pada citra $A$, hanya piksel di koordinat $(3,3)$ yang memiliki tetangga $3 times 3$ berisi angka $1$ semua.
- Piksel tepi lainnya akan menyentuh angka $0$, sehingga berubah menjadi $0$.

*Hasil Akhir:*
$ A minus.o B = mat(delim: "[",
  0, 0, 0, 0, 0;
  0, 0, 0, 0, 0;
  0, 0, 1, 0, 0;
  0, 0, 0, 0, 0;
  0, 0, 0, 0, 0;
) $

=== Dilatasi ($A plus.o B$)
*Langkah:* Pusat $B$ diletakkan pada setiap piksel $A$. Hasil bernilai $1$ jika minimal ada satu elemen $B$ yang menyentuh angka $1$ pada $A$.
- Objek $1$ pada $A$ akan "melebar" satu lapis ke segala arah.
- Karena objek asli berada di tengah ($3 times 3$), maka dilatasi akan memenuhi seluruh matriks $5 times 5$.

*Hasil Akhir:*
$ A plus.o B = mat(delim: "[",
  1, 1, 1, 1, 1;
  1, 1, 1, 1, 1;
  1, 1, 1, 1, 1;
  1, 1, 1, 1, 1;
  1, 1, 1, 1, 1;
) $

=== Opening ($A circle B$)
Operasi *Opening* didefinisikan sebagai erosi yang diikuti oleh dilatasi.

*Langkah 1: Erosi ($A minus.o B$)*
Pada tahap ini, pusat $B$ diletakkan pada setiap piksel $A$. Hanya koordinat $(3,3)$ yang seluruh tetangga $3 times 3$-nya bernilai 1.
$ A_"erosi" = mat(delim: "[",
  0, 0, 0, 0, 0;
  0, 0, 0, 0, 0;
  0, 0, 1, 0, 0;
  0, 0, 0, 0, 0;
  0, 0, 0, 0, 0;
) $

*Langkah 2: Dilatasi hasil erosi ($A_"erosi" plus.o B$)*
Satu titik bernilai 1 di pusat $(3,3)$ didilatasi dengan $B$ ($3 times 3$), sehingga area di sekitarnya kembali menjadi 1.
$ A circle B = mat(delim: "[",
  0, 0, 0, 0, 0;
  0, 1, 1, 1, 0;
  0, 1, 1, 1, 0;
  0, 1, 1, 1, 0;
  0, 0, 0, 0, 0;
) $

=== Closing ($A bullet B$)
Operasi *Closing* didefinisikan sebagai dilatasi yang diikuti oleh erosi.

*Langkah 1: Dilatasi ($A plus.o B$)*
Objek $3 times 3$ pada $A$ melebar 1 lapis ke segala arah. Karena batasan matriks $5 times 5$, maka seluruh elemen menjadi 1.
$ A_"dilatasi" = mat(delim: "[",
  1, 1, 1, 1, 1;
  1, 1, 1, 1, 1;
  1, 1, 1, 1, 1;
  1, 1, 1, 1, 1;
  1, 1, 1, 1, 1;
) $

*Langkah 2: Erosi hasil dilatasi ($A_"dilatasi" minus.o B$)*
Matriks penuh tersebut dikikis kembali. Piksel di pinggir akan menjadi 0 karena elemen $B$ akan keluar dari jangkauan objek saat berada di tepi.
$ A bullet B = mat(delim: "[",
  0, 0, 0, 0, 0;
  0, 1, 1, 1, 0;
  0, 1, 1, 1, 0;
  0, 1, 1, 1, 0;
  0, 0, 0, 0, 0;
) $


== Nomor 1.4

Operasi *Opening* dan *Closing* adalah kombinasi dari erosi dan dilatasi, namun memiliki urutan dan fungsi yang berlawanan dalam memperbaiki citra biner.

+ *Opening* ($A circle B$): Dilakukan dengan operasi erosi terlebih dahulu, kemudian diikuti oleh dilatasi. Operasi ini berfungsi untuk menghilangkan objek-objek kecil atau noise yang bukan bagian dari struktur utama serta memutus sambungan tipis antar objek.
  - *Contoh Aplikasi:* Menghilangkan bintik-bintik kecil (salt noise) pada citra dokumen hasil scan agar teks lebih bersih.

+ *Closing* ($A bullet B$): Dilakukan dengan operasi dilatasi terlebih dahulu, kemudian diikuti oleh erosi. Operasi ini berfungsi untuk menutup lubang-lubang kecil di dalam objek dan menyambungkan celah sempit antara dua objek yang berdekatan.
  - *Contoh Aplikasi:* Menyambungkan garis-garis sidik jari yang terputus agar pola alurnya menjadi utuh dan kontinu.



== Nomor 1.5

Transformasi *Hit-or-Miss* adalah operasi morfologi yang digunakan untuk mendeteksi atau menemukan lokasi pola struktur tertentu yang spesifik dalam sebuah citra biner. Operasi ini bekerja dengan cara mencocokkan bentuk objek sekaligus bentuk latar belakang di sekitarnya secara bersamaan.

+ *Cara Kerja*: Operasi ini menggunakan dua elemen penstruktur yang berbeda, yaitu $B_1$ (untuk memeriksa bagian objek/ *foreground*) dan $B_2$ (untuk memeriksa bagian luar objek/ *background*).
  - *Hit*: Terjadi jika $B_1$ cocok dengan piksel objek (nilai 1) di citra.
  - *Miss*: Terjadi jika $B_2$ cocok dengan piksel latar belakang (nilai 0) di citra.
  Hasil akhirnya hanya akan bernilai 1 jika kedua kondisi (*hit* dan *miss*) terpenuhi secara presisi pada titik tersebut.

+ *Kegunaan*: Operasi ini sangat berguna dalam pengenalan pola (*pattern matching*), ekstraksi kerangka (*skeletonization*), serta penipisan (*thinning*) atau penebalan (*thickening*) suatu objek berdasarkan struktur lokalnya.

+ *Contoh Pola yang Dapat Dideteksi*:
  - Menemukan titik ujung (*end-points*) dari sebuah garis tipis.
  - Mendeteksi pojok kanan atas dari sebuah objek persegi.
  - Mencari lokasi persimpangan pada citra jaringan jalan atau pembuluh darah.

= Bagian 2

== Pendahuluan
Segmentasi citra merupakan proses memisahkan objek utama dari latar belakangnya. Dalam bidang pertanian, segmentasi digunakan untuk mendeteksi penyakit pada tanaman secara otomatis. Laporan ini berfokus pada **Studi Kasus A: Segmentasi Lesi pada Daun**, di mana tujuannya adalah memisahkan area lesi (bagian yang terinfeksi penyakit/mold) dari jaringan daun yang masih sehat.


== Metodologi
+ *Deskripsi Citra*: Citra yang digunakan adalah citra daun tunggal yang terinfeksi penyakit bercak daun (*leaf spot* atau *mold*). Karakteristik visual lesi pada dataset ini adalah berwarna kuning-kecokelatan yang kontras dengan warna hijau daun asli.
#figure(
  // Ganti path ke file gambar citra kamu
  image("assets/tomato-leafmold.JPG", width: 50%),
  caption: [Citra asli daun dengan lesi bercak daun yang terlihat jelas pada bagian tengah.]
)
+ *Langkah Pra-pemrosesan*:
  - Konversi ruang warna dari BGR ke HSV untuk memisahkan informasi warna (*Hue*) dari pencahayaan. HSV Dipilih sebagai colorspace karena mold yang cenderung berwarna kuning kecokelatan memiliki rentang *Hue* yang spesifik, sehingga memudahkan proses segmentasi berdasarkan warna.

  - Analisis histogram pada saluran *Hue* untuk menentukan ambang batas lesi.
  - *Thresholding* difokuskan pada salurah Hue untuk menangkap spektrum warna kuning/merah pada lesi.
  #figure(
    // Ganti path ke file gambar histogram kamu
    image("assets/histogram_hue.png", width: 100%),
    caption: [Histogram saluran Hue menunjukkan puncak pada rentang warna kuning kecokelatan yang sesuai dengan lesi.]
  )

  Penentuan nilai ambang batas pada saluran *Hue* dilakukan berdasarkan observasi visual terhadap histogram citra. Alasan pemilihan nilai tersebut adalah:

  - *Rentang Hue [10, 45]*: Berdasarkan *Histogram H*, puncak utama daun sehat berada pada nilai $approx 112$ (hijau). Area lesi diidentifikasi pada gundukan distribusi yang jauh lebih rendah, yaitu pada rentang 10 hingga 45 (kuning hingga cokelat muda). Dengan membatasi nilai *Hue* pada rentang ini, sistem dapat mengisolasi area penyakit secara spesifik dan mengabaikan seluruh piksel daun sehat.
  - *Batas Bawah Saturation (S) dan Value (V) [50]*: Angka 50 dipilih sebagai *filter* untuk memastikan hanya piksel dengan saturasi warna yang kuat dan tingkat kecerahan yang cukup yang terdeteksi. Hal ini berfungsi untuk membuang *noise* pada latar belakang yang pudar atau area bayangan gelap yang berpotensi memiliki nilai *Hue* serupa namun bukan merupakan bagian dari lesi.
    
  Penentuan angka-angka ini bersifat eksperimental namun tetap berbasis pada data sebaran piksel yang terlihat pada tahap pra-pemrosesan.

+ *Operasi Morfologi*:
  - *Erosi*: Menggunakan kernel elips $3 times 3$ untuk menghilangkan *noise* bintik putih kecil.
  - *Dilatasi*: Menggunakan kernel elips $5 times 5$ untuk mempertegas area lesi dan menutup celah kecil (*closing* secara manual).
+ *Alat yang Digunakan*: Bahasa pemrograman Python, pustaka OpenCV untuk pengolahan citra, dan Matplotlib untuk visualisasi.

== Hasil
#figure(
  // Ganti path ke file gambar hasil subplot kamu
  image("assets/pipeline_hue.png", width: 100%),
  caption: [Tahapan Segmentasi: (a) Citra Biner awal, (b) Hasil Erosi $3 times 3$, (c) Hasil Dilatasi $5 times 5$, dan (d) Hasil akhir pemisahan lesi.],
)

== Analisis
Berdasarkan hasil segmentasi, metode *thresholding* pada saluran *Hue* terbukti efektif untuk memisahkan lesi karena adanya perbedaan warna yang signifikan antara mold (kuning terang) dan daun sehat (hijau gelap). 

- *Kelebihan*: Operasi morfologi berhasil membersihkan *noise* pada latar belakang dan memperhalus bentuk lesi sehingga terlihat lebih solid.
- *Kekurangan*: Terdapat sedikit bagian tepi daun yang ikut terdeteksi sebagai lesi karena adanya degradasi warna hijau di pinggir daun yang menyerupai warna lesi.
- *Kemungkinan Perbaikan*: Penggunaan *thresholding* adaptif atau penambahan filter pada saluran *Saturation* dapat membantu membedakan antara kuning lesi dengan kuning akibat pantulan cahaya.

== Kesimpulan
Operasi morfologi, khususnya kombinasi erosi dan dilatasi, sangat krusial dalam memperbaiki hasil segmentasi biner mentah. Dalam kasus ini, segmentasi berhasil memisahkan area penyakit pada daun dengan cukup akurat. Hal ini membuktikan bahwa pendekatan morfologi matematika dapat menjadi alat bantu yang kuat dalam identifikasi dini penyakit tanaman.