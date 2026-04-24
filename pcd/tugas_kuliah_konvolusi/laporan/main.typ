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
  judul: "Laporan tugas kuliah pengolahan citra digital materi konvolusi",
  nama: "SYAFIQ SYADIDUL AZMI",
  nim: "G6401231075",
  kelas: "PCD K3",
  program-studi: "ILMU KOMPUTER",
  fakultas: "Sekolah Sains Data Matematika dan Informatika",
  tahun: "2026",
  logo: image("assets/logo-ipb.png", width: 2.5cm),
)

#daftar-isi()
#daftar-tabel()    // hapus baris ini jika tabel ≤ 1
#daftar-gambar()   // hapus baris ini jika gambar ≤ 1

// ── Bagian Isi (nomor halaman Arab: 1, 2, 3, …) ────────
#show: bagian-isi

= TUGAS 1 

== Tugas 1.1 - Deteksi Tepi Daun (Manual)
$ I = mat(
  delim: "[",
  10, 20, 30, 200, 210;
  15, 25, 35, 205, 215;
  12, 22, 32, 195, 205;
  8,  18, 28, 190, 200;
  5,  15, 25, 185, 195;
) $

Matrix di atas merupakan Matriks citra digital dengan ukuran 5x5 piksel. Setiap elemen dalam matriks tersebut mewakili intensitas piksel pada posisi tertentu dalam citra. Tujuan tugas ini adalah 

=== Perhitungan Korelasi pada Piksel (2,2)

Pada operasi korelasi, kernel $G_x$ digunakan secara langsung tanpa rotasi. Proses perhitungan dilakukan dengan mengalikan elemen kernel dengan area $3 times 3$ di sekitar piksel $(2,2)$ pada matriks $I$:

$ G_x = mat(delim: "[", -1, 0, 1; -2, 0, 2; -1, 0, 1) $

Langkah perhitungan "multiply and accumulate" adalah sebagai berikut:

$ S &= (-1 times 25) + (0 times 35) + (1 times 205) \
  &quad + (-2 times 22) + (0 times 32) + (2 times 195) \
  &quad + (-1 times 18) + (0 times 28) + (1 times 190) $

$ S &= (-25 + 0 + 205) + (-44 + 0 + 390) + (-18 + 0 + 190) \
  &= (180) + (346) + (172) \
  &= 698 $

Jadi, nilai piksel pada posisi $(2,2)$ setelah dilakukan korelasi adalah *698*.

=== Perhitungan Konvolusi pada Piksel (2,2)

Pada operasi konvolusi, kernel $G_x$ harus dirotasi terlebih dahulu sebesar $180^o$ sebelum dikalikan dengan citra. Kernel Sobel vertikal setelah dirotasi menjadi:

$ G_x' = mat(delim: "[", 1, 0, -1; 2, 0, -2; 1, 0, -1) $

Karena kernel ini tidak simetris terhadap rotasi $180^o$, maka hasil konvolusi akan berbeda dengan hasil korelasi. Jika dilakukan perhitungan "multiply and accumulate" pada posisi $(2,2)$ menggunakan kernel yang telah dirotasi:

$ S &= (1 times 25) + (0 times 35) + (-1 times 205) \
  &quad + (2 times 22) + (0 times 32) + (-2 times 195) \
  &quad + (1 times 18) + (0 times 28) + (-1 times 190) \
  &= -698 $

Jadi, nilai piksel $(2,2)$ hasil konvolusi adalah *-698*. Perbedaan tanda ini menunjukkan arah gradien yang dideteksi oleh kernel.

=== Analisis Perbandingan

#set enum(numbering: "a.")
+ *Alasan Perbedaan*: Perbedaan tanda ($+$ dan $-$) disebabkan oleh rotasi $180^o$ pada operasi konvolusi terhadap kernel yang asimetris.
+ *Pemilihan Metode*: Korelasi lebih tepat karena memberikan nilai positif pada transisi gelap-ke-terang, sesuai dengan struktur citra daun yang diamati karena matriks $I$ menunjukkan peningkatan intensitas dari kiri ke kanan, yang sesuai dengan deteksi tepi vertikal oleh kernel Sobel.

== Tugas 1.2 – Smoothing Citra Buah (Manual)

Diberikan citra $A$ berukuran $3 times 3$ dengan *salt noise* pada pusatnya ($255$):
$ A = mat(delim: "[", 34, 35, 36; 37, 255, 39; 40, 41, 42) $

=== Filter Mean (Box Filter) $3 times 3$
Filter mean menghitung rata-rata dari seluruh piksel di dalam jendela kernel.
Kernel $w$:
$ w = 1/9 mat(delim: "[", 1, 1, 1; 1, 1, 1; 1, 1, 1) $

Perhitungan pada posisi pusat (1,1):
$ S &= 1/9 (34 + 35 + 36 + 37 + 255 + 39 + 40 + 41 + 42) \
  &= 1/9 (559) \
  &approx 62.11 $

=== Filter Median
Filter median mengambil nilai tengah setelah seluruh piksel di dalam jendela diurutkan.
1. *Urutkan nilai neighborhood*:
   $34, 35, 36, 37, 39, 40, 41, 42, 255$
2. *Ambil nilai tengah (posisi ke-5)*:
   Nilai median adalah *39*.

=== Filter Max
Filter max mengambil nilai tertinggi di dalam jendela kernel.
1. *Himpunan nilai*: ${34, 35, 36, 37, 255, 39, 40, 41, 42}$
2. *Nilai tertinggi*: *255*.

=== Analisis Efektivitas terhadap Salt Noise
#set enum(numbering: "1.")
+ *Filter Paling Efektif*: Filter Median.
+ *Alasan*: 
  - *Salt noise* (nilai 255) adalah pencilan (*outlier*) yang sangat ekstrim. 
  - *Filter Mean* gagal karena nilai 255 tetap ikut dijumlahkan, sehingga hasil akhirnya (62.11) tetap jauh lebih tinggi dari nilai asli piksel sekitarnya (sekitar 30-an), yang mengakibatkan citra terlihat agak kabur (*blur*).
  - *Filter Max* justru mempertahankan *noise* tersebut karena 255 adalah nilai maksimum.
  - *Filter Median* sangat efektif karena nilai ekstrim (255) akan selalu berada di ujung urutan, sehingga yang terpilih sebagai nilai baru adalah nilai yang lebih merepresentasikan lingkungan sekitarnya (39) tanpa mengaburkan tepi citra secara signifikan.

= TUGAS 2

== Tugas 2.1 – Eksplorasi Filter pada Citra Daun

=== Persiapan Dataset dan Preprocessing

Dataset yang digunakan adalah *New Plant Disease Dataset* dari Kaggle. Dipilih 5 citra dari folder `train` yang mewakili kelas dengan karakteristik tekstur berbeda:

#figure(
  table(
    columns: (auto, auto, auto),
    align: (center, left, left),
    table.header([*No.*], [*File*], [*Deskripsi Kelas*]),
    [1], [`apple-scab.JPG`],         [Apple Scab — bercak gelap tidak beraturan di permukaan daun],
    [2], [`grape-blackrot.JPG`],      [Grape Black Rot — lesi bulat besar berwarna coklat-hitam],
    [3], [`peach-bacterialspot.JPG`], [Peach Bacterial Spot — bercak kecil tersebar, disertai klorosis],
    [4], [`soybean-healthy.JPG`],     [Soybean Healthy — daun sehat, venasi jelas, warna hijau uniform],
    [5], [`tomato-leafmold.JPG`],     [Tomato Leaf Mold — perubahan warna difus kekuningan],
  ),
  caption: [Daftar citra yang digunakan pada Tugas 2.1],
)

Setiap gambar diproses melalui tiga tahap preprocessing:
+ Konversi ke *grayscale* menggunakan `cv2.COLOR_BGR2GRAY`.
+ *Resize* ke ukuran tetap $256 times 256$ piksel.
+ *Normalisasi* ke rentang $[0, 1]$ dengan membagi nilai piksel dengan $255$.

=== Definisi Kernel

*a) Low-pass: Gaussian $5 times 5$ ($sigma = 1$)*

Dibangun dengan menempatkan nilai $1$ pada pusat matriks nol $5 times 5$, kemudian diterapkan `ndimage.gaussian_filter(sigma=1)`. Kernel ini berperan sebagai filter perata yang memberikan bobot lebih besar pada piksel terdekat.

*b) High-pass: Laplacian 8-tetangga*

$ L = mat(delim: "[", -1, -1, -1; -1, 8, -1; -1, -1, -1) $

*c) Deteksi Tepi: Sobel X, Sobel Y, dan Magnitudo*

$ G_x = mat(delim: "[", -1, 0, 1; -2, 0, 2; -1, 0, 1), quad
  G_y = mat(delim: "[", -1, -2, -1; 0, 0, 0; 1, 2, 1), quad
  |G| = sqrt(G_x^2 + G_y^2) $

Semua konvolusi dilakukan dengan `scipy.signal.convolve2d` menggunakan `mode='same'`.

=== Hasil Visualisasi

Untuk setiap citra ditampilkan subplot $2 times 3$: (a) citra asli grayscale, (b) Gaussian, (c) Laplacian, (d) Sobel X, (e) Sobel Y, (f) Magnitudo Sobel.

#figure(
  image("assets/result_apple-scab.png", width: 100%),
  caption: [Hasil konvolusi pada citra _apple-scab_],
)

#figure(
  image("assets/result_grape-blackrot.png", width: 100%),
  caption: [Hasil konvolusi pada citra _grape-blackrot_],
)

#figure(
  image("assets/result_peach-bacterialspot.png", width: 100%),
  caption: [Hasil konvolusi pada citra _peach-bacterialspot_],
)

#figure(
  image("assets/result_soybean-healthy.png", width: 100%),
  caption: [Hasil konvolusi pada citra _soybean-healthy_],
)

#figure(
  image("assets/result_tomato-leafmold.png", width: 100%),
  caption: [Hasil konvolusi pada citra _tomato-leafmold_],
)

=== Analisis

==== Fitur yang Ditonjolkan Masing-Masing Filter

*Filter Gaussian* menekan komponen frekuensi tinggi dengan merata-ratakan intensitas piksel berbobot jarak. Misalnya pada `grape-blackrot` menunjukkan bahwa transisi tajam antar-piksel berhasil diperhalus. Hasilnya secara visual tampak lebih "blur" dan tekstur permukaan daun yang kasar menjadi lebih halus.

*Filter Laplacian* merespons perubahan intensitas ke segala arah sekaligus sehingga menonjolkan seluruh struktur tepi dan tekstur lokal. Pada `grape-blackrot` di antara semua citra, yang mencerminkan kontras tajam antara lesi besar coklat-hitam dan jaringan daun hijau sekitarnya. Pada `peach-bacterialspot` terlihat lebih tajam. Pada area seragam seperti tengah helai daun sehat, gambar Laplacian hampir seragam gelap karena tidak ada perubahan intensitas signifikan.

*Sobel X* mendeteksi tepi vertikal (transisi ke arah horizontal), sedangkan *Sobel Y* mendeteksi tepi horizontal. *Magnitudo Sobel* menggabungkan keduanya dan merupakan representasi tepi yang paling lengkap dan robust terhadap arah. `grape-blackrot` memiliki magnitudo tertinggi karena menghasilkan banyak tepi kuat di kedua arah, sedangkan `soybean-healthy` memiliki magnitudo terendah karena tekstur yang lebih seragam.

==== Gaussian untuk Reduksi Noise pada Citra Daun

Filter Gaussian efektif menekan noise frekuensi tinggi yang berasal dari tekstur permukaan daun, artefak sensor, atau variasi pencahayaan. Pada `tomato-leafmold`, citra ini memiliki gradien intensitas yang tersebar halus (bukan bercak tajam), sehingga Gaussian berhasil meratakan transisi tersebut tanpa banyak kehilangan informasi.

Gaussian paling bermanfaat sebagai *preprocessing* sebelum deteksi tepi. Dengan terlebih dahulu memperhalus noise, respons Sobel/Laplacian berikutnya menjadi lebih bersih dan tidak terdistraksi oleh artefak piksel tunggal.

==== Laplacian/Sobel untuk Pengukuran Luas Daun dan Deteksi Lesi

Peta magnitudo Sobel secara langsung merepresentasikan lokasi dan kekuatan tepi pada citra. Pada `grape-blackrot`, lesi bulat besar tampak sebagai tepi yang jelas pada output magnitudo, karena terdapat transisi tajam.

==== Filter Paling Berguna untuk Sistem Deteksi Dini Penyakit

Untuk sistem deteksi dini penyakit berbasis perubahan tekstur daun, *kombinasi Gaussian + Sobel Magnitudo* adalah yang paling direkomendasikan:

#set enum(numbering: "1.")
+ *Gaussian* sebagai preprocessing: mengurangi noise sensor dan variasi tekstur permukaan yang tidak relevan.
+ *Sobel Magnitudo* sebagai ekstraktor fitur utama: mendeteksi distribusi batas lesi secara robust terhadap arah. Data menunjukkan `grape-blackrot` memiliki rata-rata magnitudo hampir dua kali lipat kelas lain, sehingga fitur ini dapat langsung digunakan sebagai indikator keparahan penyakit.

== Tugas 2.2 – Perbandingan Penanganan Batas (Border Handling)

=== Pembuatan Citra Sintetis

Citra sintetis berukuran $6 times 6$ dibuat dengan persegi putih $4 times 4$ di tengah latar hitam:

$ S = mat(delim: "[",
  0, 0, 0, 0, 0, 0;
  0, 1, 1, 1, 1, 0;
  0, 1, 1, 1, 1, 0;
  0, 1, 1, 1, 1, 0;
  0, 1, 1, 1, 1, 0;
  0, 0, 0, 0, 0, 0
) $

=== Implementasi dan Hasil Numerik

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, left),
    table.header([*Metode*], [*Implementasi Python*], [*Perilaku di Tepi*]),
    [Zero Padding], [`signal.convolve2d(mode='same',` \ `boundary='fill')`], [Piksel luar citra dianggap bernilai 0],
    [Replikasi],    [`ndimage.convolve(mode='nearest')`],                    [Piksel tepi direplikasi ke luar batas],
    [Refleksi],     [`ndimage.convolve(mode='mirror')`],                     [Nilai dicerminkan dari piksel dalam],
    [Cropping],     [`signal.convolve2d(mode='valid')`],                     [Output $4 times 4$, hanya posisi kernel muat penuh],
  ),
  caption: [Empat metode penanganan batas yang diimplementasikan],
)

Hasil numerik *Zero Padding* (output $6 times 6$):
$ R_"zero" = mat(delim: "[",
  -1, -1, 0, 0, 1, 1;
  -3, -3, 0, 0, 3, 3;
  -4, -4, 0, 0, 4, 4;
  -4, -4, 0, 0, 4, 4;
  -3, -3, 0, 0, 3, 3;
  -1, -1, 0, 0, 1, 1;
) $

Hasil numerik *Replikasi* (output $6 times 6$):
$ R_"replicate" = mat(delim: "[",
  -1, -1, 0, 0, 1, 1;
  -3, -3, 0, 0, 3, 3;
  -4, -4, 0, 0, 4, 4;
  -4, -4, 0, 0, 4, 4;
  -3, -3, 0, 0, 3, 3;
  -1, -1, 0, 0, 1, 1;
) $

Hasil numerik *Refleksi* (output $6 times 6$):
$ R_"mirror" = mat(delim: "[",
   0, -2, 0, 0, 2, 0;
   0, -3, 0, 0, 3, 0;
   0, -4, 0, 0, 4, 0;
   0, -4, 0, 0, 4, 0;
   0, -3, 0, 0, 3, 0;
   0, -2, 0, 0, 2, 0;
) $

Hasil numerik *Cropping* (output $4 times 4$):
$ R_"crop" = mat(delim: "[",
  -3, 0, 0, 3;
  -4, 0, 0, 4;
  -4, 0, 0, 4;
  -3, 0, 0, 3;
) $

#figure(
  image("assets/result_border_comparison.png", width: 100%),
  caption: [Perbandingan keempat metode penanganan batas pada citra sintetis $6 times 6$],
)

=== Analisis

*Zero Padding* Nilai di luar batas dianggap 0. Menghasilkan respons yang melemah di tepi dan sudut citra karena sebagian kernel bertemu nilai nol yang tidak representatif. Artefak berupa gradien palsu muncul di baris/kolom paling luar.

*Replikasi* Piksel paling tepi direplikasi ke luar. Untuk citra sintetis ini hasilnya identik dengan zero padding karena piksel tepi bernilai 0 — replikasi 0 sama dengan zero padding. Pada citra nyata (tepi bukan nol), replikasi lebih baik dari zero padding.

*Refleksi* Nilai dicerminkan dari dalam ke luar batas. Menghasilkan artefak paling sedikit karena nilai bayangan konsisten dengan konten aktual citra. Terlihat dari hasil: kolom paling tepi bernilai 0 (bukan ±1 seperti zero padding), menunjukkan tidak ada gradien palsu di batas.

*Cropping* Hanya menghitung posisi di mana kernel muat sepenuhnya sehingga output mengecil menjadi 4×4. Tidak ada artefak sama sekali, namun informasi di tepi citra hilang.

==== Rekomendasi untuk Aplikasi Pertanian

Dalam analisis citra daun pertanian, tepi daun sangat kritis karena banyak penyakit muncul pertama kali di tepi helai daun, dan pengukuran luas daun memerlukan deteksi kontur akurat hingga piksel paling tepi. Metode *Refleksi* (`mode='mirror'`) paling direkomendasikan: output berukuran sama dengan input, artefak tepi minimal, dan nilai padding konsisten secara spasial dengan konten aktual citra daun — berbeda dengan zero padding yang memperkenalkan transisi palsu antara nol dan nilai piksel tepi.

== Tugas 2.3 – Aplikasi Sederhana: Identifikasi Tekstur Penyakit

=== (a) Desain Kernel

Tiga kelas dipilih untuk dibedakan: *Apple Scab* (bercak gelap berbatas tegas), *Apple Rust* (bercak oranye dengan tekstur berbulu, lebih difus), dan *Apple Black Rot* (lesi gelap besar dengan tepi tidak beraturan).

Kernel yang dirancang adalah *Laplacian 4-tetangga* sebagai pendeteksi energi tekstur lokal:

$ K = mat(delim: "[", 0, -1, 0; -1, 4, -1; 0, -1, 0) $

Alasan pemilihan setiap angka:
- Nilai pusat $+4$: mengangkat intensitas piksel pusat terhadap rata-rata tetangganya.
- Nilai tetangga $-1$ (atas/bawah/kiri/kanan): mengurangi kontribusi piksel sekitar secara aksial.
- Diagonal $= 0$: membuat kernel fokus pada struktur aksial (venasi, tepi bercak) dan tidak terlalu sensitif terhadap noise diagonal.
- Pada area *uniform* (intensitas konstan), jumlah perkalian menghasilkan sekitar 0. Pada area bertekstur atau berbercak, kernel menghasilkan nilai absolut yang tinggi.

=== (b) Hasil Rata-Rata Output Konvolusi per Kelas

Kernel diterapkan pada 5 sampel dari setiap kelas menggunakan `scipy.signal.convolve2d` dengan `mode='same'` dan `boundary='symm'`. Rata-rata nilai absolut output dirangkum pada tabel berikut:

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, center, left),
    table.header([*Kelas*], [*Rata-rata $|$Output$|$*], [*Karakteristik Tekstur*]),
    [Apple Scab],      [0.1255], [Bercak gelap berbatas tegas, kontras tinggi],
    [Apple Rust],      [0.0460], [Bercak difus berbulu, transisi intensitas halus],
    [Apple Black Rot], [0.1892], [Lesi besar tidak beraturan, tepi kasar],
  ),
  caption: [Rata-rata respons kernel Laplacian 4-tetangga per kelas],
)

#figure(
  image("assets/result_texture_barchart.png", width: 85%),
  caption: [Bar chart perbandingan rata-rata $|$output konvolusi$|$ ketiga kelas penyakit],
)

=== (c) Evaluasi Kernel

Berdasarkan hasil di atas, kernel berhasil memisahkan ketiga kelas dengan pola yang konsisten dengan karakteristik visualnya. *Apple Rust* menghasilkan respons terendah ($0,0460$) karena teksturnya yang difus dan transisi intensitas yang gradual, perubahan antar piksel kecil sehingga Laplacian tidak teraktivasi kuat. *Apple Scab* berada di tengah ($0,1255$) dengan bercak gelap yang berbatas cukup tegas. *Apple Black Rot* menghasilkan respons tertinggi ($0,1892$) karena lesinya yang besar dengan tepi kasar dan tidak beraturan, menghasilkan banyak transisi tajam yang direspons kuat oleh kernel.

Selisih antara kelas terendah dan tertinggi mencapai $0,143$, yang menunjukkan kernel ini *cukup efektif* sebagai pemisah kelas. Namun perlu dicatat bahwa standar deviasi Apple Scab cukup besar, yang mengindikasikan variasi tekstur antar sampel dalam kelas tersebut cukup tinggi.

=== (d) Diskusi: Konvolusi Fixed Kernel vs. Learned Kernels pada CNN

*Konvolusi dengan kernel tetap* seperti yang digunakan pada tugas ini memiliki kelebihan berupa interpretabilitas tinggi. Namun keterbatasannya nyata: satu kernel hanya menangkap satu jenis fitur, sehingga kelas yang memiliki karakteristik serupa (misalnya dua jenis bercak dengan ukuran berbeda) sulit dibedakan hanya dari satu nilai skalar rata-rata.

*Learned kernels pada CNN* bekerja secara berbeda. Layer konvolusi pertama CNN secara otomatis mempelajari puluhan filter yang secara fungsional menyerupai Sobel, Gaussian, dan Laplacian, namun dioptimalkan khusus untuk tugas klasifikasi yang diberikan. Layer lebih dalam kemudian menggabungkan fitur-fitur tingkat rendah tersebut menjadi representasi tingkat tinggi seperti bentuk lesi, distribusi bercak, dan pola warna. Untuk dataset sebesar New Plant Disease dengan 87.000 gambar dan 38 kelas, pendekatan CNN jauh lebih unggul karena mampu menangkap kompleksitas pola yang tidak dapat direpresentasikan oleh satu kernel tunggal.

Kesimpulannya, kernel manual berguna sebagai langkah eksplorasi awal dan preprocessing (seperti pengurangan noise dengan Gaussian sebelum ekstraksi fitur), sedangkan learned kernels pada CNN lebih cocok untuk sistem produksi yang membutuhkan akurasi tinggi pada banyak kelas sekaligus.
