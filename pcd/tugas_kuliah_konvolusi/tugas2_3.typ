== Tugas 2.3 – Aplikasi Sederhana: Identifikasi Tekstur Penyakit

=== (a) Desain Kernel

Tiga kelas dipilih untuk dibedakan: *Apple Scab* (bercak gelap berbatas tegas), *Apple Rust* (bercak oranye dengan tekstur berbulu, lebih difus), dan *Apple Black Rot* (lesi gelap besar dengan tepi tidak beraturan).

Kernel yang dirancang adalah *Laplacian 4-tetangga* sebagai pendeteksi energi tekstur lokal:

$ K = mat(delim: "[", 0, -1, 0; -1, 4, -1; 0, -1, 0) $

Alasan pemilihan setiap angka:
- Nilai pusat $+4$: mengangkat intensitas piksel pusat terhadap rata-rata tetangganya.
- Nilai tetangga $-1$ (atas/bawah/kiri/kanan): mengurangi kontribusi piksel sekitar secara aksial.
- Diagonal $= 0$: membuat kernel fokus pada struktur aksial (venasi, tepi bercak) dan tidak terlalu sensitif terhadap noise diagonal.
- Pada area *uniform* (intensitas konstan), jumlah perkalian menghasilkan $\approx 0$. Pada area bertekstur atau berbercak, kernel menghasilkan nilai absolut yang tinggi.

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

Berdasarkan hasil di atas, kernel berhasil memisahkan ketiga kelas dengan pola yang konsisten dengan karakteristik visualnya. *Apple Rust* menghasilkan respons terendah ($0{,}0460$) karena teksturnya yang difus dan transisi intensitas yang gradual — perubahan antar piksel kecil sehingga Laplacian tidak teraktivasi kuat. *Apple Scab* berada di tengah ($0{,}1255$) dengan bercak gelap yang berbatas cukup tegas. *Apple Black Rot* menghasilkan respons tertinggi ($0{,}1892$) karena lesinya yang besar dengan tepi kasar dan tidak beraturan, menghasilkan banyak transisi tajam yang direspons kuat oleh kernel.

Selisih antara kelas terendah dan tertinggi mencapai $0{,}143$, yang menunjukkan kernel ini *cukup efektif* sebagai pemisah kelas. Namun perlu dicatat bahwa standar deviasi Apple Scab cukup besar, yang mengindikasikan variasi tekstur antar sampel dalam kelas tersebut cukup tinggi.

=== (d) Diskusi: Konvolusi Fixed Kernel vs. Learned Kernels pada CNN

*Konvolusi dengan kernel tetap* seperti yang digunakan pada tugas ini memiliki kelebihan berupa interpretabilitas tinggi — setiap nilai kernel memiliki makna fisik yang jelas dan tidak membutuhkan data latih. Namun keterbatasannya nyata: satu kernel hanya menangkap satu jenis fitur, sehingga kelas yang memiliki karakteristik serupa (misalnya dua jenis bercak dengan ukuran berbeda) sulit dibedakan hanya dari satu nilai skalar rata-rata.

*Learned kernels pada CNN* bekerja secara berbeda. Layer konvolusi pertama CNN secara otomatis mempelajari puluhan filter yang secara fungsional menyerupai Sobel, Gaussian, dan Laplacian, namun dioptimalkan khusus untuk tugas klasifikasi yang diberikan. Layer lebih dalam kemudian menggabungkan fitur-fitur tingkat rendah tersebut menjadi representasi tingkat tinggi seperti bentuk lesi, distribusi bercak, dan pola warna. Untuk dataset sebesar New Plant Disease dengan 87.000 gambar dan 38 kelas, pendekatan CNN jauh lebih unggul karena mampu menangkap kompleksitas pola yang tidak dapat direpresentasikan oleh satu kernel tunggal.

Kesimpulannya, kernel manual berguna sebagai langkah eksplorasi awal dan preprocessing (seperti pengurangan noise dengan Gaussian sebelum ekstraksi fitur), sedangkan learned kernels pada CNN lebih cocok untuk sistem produksi yang membutuhkan akurasi tinggi pada banyak kelas sekaligus.
