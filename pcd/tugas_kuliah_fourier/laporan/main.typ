#import "lib/format_ppki.typ": *

#let placeholder-figure(label, height: 6cm) = figure(caption: [#label])[ 
  box(
    width: 100%,
    height: height,
    stroke: 0.8pt,
    inset: 1em,
  )[
    align(center + horizon)[
      [#label]
    ]
  ]
]

#show: ppki.with(
  judul: "Laporan Analisis Fourier pada Citra Daun dan Surface Defect",
  nama-penulis: "Syafiq Syadidul Azmi",
  nim: "G6401231075",
  kelas: "PCD K3",
  program-studi: "Ilmu Komputer",
  fakultas: "Sekolah Sains Data Matematika dan Informatika",
  tahun: "2026",
  jenis-karya: "laporan-akhir",
)

// Bagian awal: halaman sampul, abstrak, daftar isi, dan daftar gambar/tabel.
#show: bagian-awal

#halaman-sampul(
  judul: "Laporan Analisis Fourier pada Citra Daun dan Surface Defect",
  nama: "SYAFIQ SYADIDUL AZMI",
  nim: "G6401231075",
  kelas: "PCD K3",
  program-studi: "ILMU KOMPUTER",
  fakultas: "Sekolah Sains Data Matematika dan Informatika",
  tahun: "2026",
  logo: image("assets/logo-ipb.png", width: 2.5cm),
)

#daftar-isi()
#daftar-tabel()
#daftar-gambar()

// Bagian isi: nomor halaman Arab.
#show: bagian-isi

= METODE PERCOBAAN

== Data dan Preprocessing
Pada bagian leaf disease, citra dibaca dari dataset daun sehat dan daun sakit, lalu dikonversi ke grayscale agar analisis frekuensi hanya fokus pada struktur intensitas piksel. Setiap citra dicatat ukuran `rows` dan `cols`-nya, kemudian disimpan sebagai metadata agar proses FFT dan visualisasi bisa ditelusuri kembali.

Langkah teknis yang dijalankan:
1. Pendefinisian folder kelas dilakukan dengan memisahkan `tomat sehat` dan `tomat leafmold`.
2. Seluruh file citra valid pada tiap folder dibaca secara berurutan.
3. Citra dikonversi ke grayscale.
4. Metadata dan array citra disimpan ke `data_gambar`.

```python
kelas_dirs = {
  "tomat sehat": Path("./data/Tomat_sehat"),
  "tomat leafmold": Path("./data/Tomat_sakit"),
}

for nama_kelas, root in kelas_dirs.items():
  for img_path in sorted(root.rglob("*")):
    img = cv2.imread(str(img_path), cv2.IMREAD_GRAYSCALE)
    rows, cols = img.shape[:2]
    data_gambar.append({
      "kelas": nama_kelas,
      "rows": rows,
      "cols": cols,
      "img": img,
    })
```

Tahapan preprocessing:
+ Konversi ke grayscale

Resize tidak menjadi fokus utama karena seluruh citra pada notebook sudah berada pada ukuran yang seragam, sehingga setiap citra bisa langsung dibandingkan pada domain frekuensi tanpa bias skala spasial.

== Transformasi Fourier
Setelah preprocessing, citra ditransformasikan ke domain frekuensi memakai FFT. Tujuannya bukan hanya menghasilkan gambar spektrum, tetapi juga memisahkan komponen frekuensi rendah dan tinggi sebagai fitur numerik. Frekuensi rendah mewakili pola halus dan bentuk umum daun, sedangkan frekuensi tinggi mewakili tepi, tekstur kasar, dan detail kecil yang sering berubah akibat penyakit.

Sebelum dihitung spektrum, citra dikalikan faktor `(-1)^(r+c)` untuk memindahkan komponen DC ke pusat spektrum. Langkah ini membuat visualisasi dan pemisahan low-frequency/high-frequency menjadi lebih intuitif karena pusat spektrum merepresentasikan energi rendah.

Potongan kode inti transformasi FFT:

```python
def stdFftImage(img_gray, rows, cols):
  fimg = img_gray.astype(np.float32).copy()
  for r in range(rows):
    for c in range(cols):
      if (r + c) % 2:
        fimg[r][c] *= -1
  return fftImage(fimg, rows, cols)

fft = stdFftImage(item["img"], item["rows"], item["cols"])
amp, spec = graySpectrum(fft)
```

== Ekstraksi Fitur Frekuensi
Setiap citra menghasilkan magnitude spectrum dan dari sana dihitung energi frekuensi rendah dan tinggi. Energi rendah dihitung dari area pusat spektrum dengan radius tertentu, sedangkan energi tinggi dihitung dari area luar radius tersebut. Dari dua nilai ini juga dihitung rasio `low/high` sebagai metrik sederhana untuk membandingkan seberapa dominan detail tinggi pada citra.

Dalam notebook, fitur yang disimpan untuk tiap citra adalah `energy_low`, `energy_high`, `energy_total`, dan `ratio_lh`. Fitur-fitur ini penting karena laporan tidak berhenti di visualisasi, tetapi juga menyajikan angka yang bisa dibandingkan antar kelas secara objektif.

Potongan kode inti ekstraksi fitur:

```python
fitur = hitung_energi_frekuensi(amp, radius_pct=0.1)
item.update(fitur)

records.append({
  "kelas": item["kelas"],
  "energy_low": item["energy_low"],
  "energy_high": item["energy_high"],
  "ratio_lh": item["ratio_low_high"],
})
```

=== Uji Radius dan Alasan Pemilihan Parameter
Untuk menghindari penggunaan satu nilai default, dilakukan uji beberapa radius pemisah low/high pada data surface: 0.08, 0.10, 0.15, dan 0.20. Hasilnya, selisih rasio terbesar muncul pada radius 0.20. Meskipun demikian, untuk menjaga konsistensi dengan eksperimen leaf disease, pipeline utama tetap memakai radius 0.10.

Ringkasan uji radius:
+ radius 0.20: selisih rasio 112
+ radius 0.08: selisih rasio 106
+ radius 0.10: selisih rasio 60.8
+ radius 0.15: selisih rasio 45.9

Keputusan ini dipertahankan agar perbandingan antar domain tetap setara, sambil tetap mencatat bahwa parameter radius memengaruhi kekuatan pemisahan kelas.

= HASIL DAN VISUALISASI

== Bagian A - Leaf Disease

=== Visualisasi FFT

#figure(
  image("assets/leaf_citra_asli_sehat_grid.png", width: 100%),
  caption: [Perbandingan citra asli daun sehat],
)

#figure(
  image("assets/leaf_citra_asli_sakit_grid.png", width: 100%),
  caption: [Perbandingan citra asli daun sakit],
)

#figure(
  image("assets/leaf_spectrum_sehat_grid.png", width: 100%),
  caption: [Log magnitude spectrum daun sehat],
)

#figure(
  image("assets/leaf_spectrum_sakit_grid.png", width: 100%),
  caption: [Log magnitude spectrum daun sakit],
)

=== Ringkasan Metrik Leaf Disease

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, center, center, center),
    table.header([*Kelas*], [*Energi Rendah*], [*Energi Tinggi*], [*Rasio Low/High*]),
    [Daun sehat], [5.48e13], [1.07e12], [65.33],
    [Daun sakit], [5.81e13], [4.70e11], [145.21],
  ),
  kind: table,
  caption: [Ringkasan energi frekuensi rata-rata untuk daun sehat dan daun sakit],
)

=== Pembahasan Singkat Leaf Disease
Pada data yang ditampilkan, daun sakit punya rasio low/high lebih besar dibanding daun sehat. Artinya, komponen frekuensi rendah masih dominan di kedua kelas, tapi pada daun sakit dominasi itu lebih kuat.

Scatter low vs high memperlihatkan titik kedua kelas masih overlap. Jadi Fourier global bisa dipakai sebagai fitur tambahan, tapi belum cukup kalau dipakai sendirian.

Satu hal yang menjadi perhatian: energy_high daun sakit pada eksperimen ini tidak selalu naik. Secara teori, bercak dan tepi tajam seharusnya mendorong komponen frekuensi tinggi. Namun pada data ini, kemungkinan area hijau yang relatif mulus pada sebagian citra daun sakit masih lebih dominan secara global, sedangkan beberapa citra daun sehat justru memiliki kontras urat daun (venation) yang kuat. Karena FFT diterapkan pada seluruh citra, komponen global tersebut dapat menutup sinyal lokal bercak.

#figure(
  image("assets/leaf_energy_bar.png", width: 100%),
  caption: [Perbandingan rata-rata fitur energi frekuensi daun sehat dan daun sakit],
)

#figure(
  image("assets/leaf_energy_scatter.png", width: 85%),
  caption: [Scatter plot energi frekuensi rendah dan tinggi untuk daun sehat dan daun sakit],
)

#figure(
  image("assets/leaf_ratio_boxplot.png", width: 70%),
  caption: [Distribusi rasio energi frekuensi low/high untuk daun sehat dan daun sakit],
)


== Bagian B - Surface Defect

=== Konteks Dataset
Analisis surface defect menggunakan dua kelas:
+ Pitted surface (baseline/normal): 10 citra dengan pola tekstur halus berpori
+ Scratched surface (cacat/defect): 10 citra dengan goresan linear terlihat

Dipilih scratched surface sebagai kelas cacat karena pola goresan lebih terstruktur dan lebih mudah dibedakan dari noise natural. Pitted surface dianggap baseline karena polanya lebih serupa dengan permukaan normal yang hanya memiliki tekstur natural.

=== Visualisasi FFT

#figure(
  image("assets/surface_citra_asli_pitted_grid.png", width: 100%),
  caption: [Perbandingan citra asli pitted surface (normal)],
)

#figure(
  image("assets/surface_citra_asli_scratched_grid.png", width: 100%),
  caption: [Perbandingan citra asli scratched surface (cacat)],
)

#figure(
  image("assets/surface_spectrum_pitted_grid.png", width: 100%),
  caption: [Log magnitude spectrum pitted surface (normal): pola distribusi energi simetris dan merata],
)

#figure(
  image("assets/surface_spectrum_scratched_grid.png", width: 100%),
  caption: [Log magnitude spectrum scratched surface (cacat): pola energi dengan arah linear terlihat jelas (goresan horizontal atau vertikal)],
)

=== Ringkasan Metrik Surface Defect

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, center, center, center),
    table.header([*Kelas*], [*Energi Rendah*], [*Energi Tinggi*], [*Rasio Low/High*]),
    [Pitted (Normal)], [7.27e+13], [1.66e+11], [473.13],
    [Scratched (Cacat)], [2.26e+13], [7.68e+10], [412.31],
  ),
  kind: table,
  caption: [Ringkasan energi frekuensi rata-rata untuk pitted (normal) dan scratched (cacat)],
)

=== Pembahasan Singkat Surface Defect
Perbedaan pitted dan scratched lebih jelas dibanding kasus leaf disease. Nilai energi rendah pitted lebih tinggi, dan ini konsisten dengan pola permukaan pitted yang menyebar ke banyak area citra.

Rasio low/high kedua kelas memang sama-sama tinggi (473.13 vs 412.31), jadi rasio saja belum paling tajam. Karena itu ditambahkan metrik radial $R(r)$ agar pembacaan radius frekuensi lebih detail.

Untuk analisis arah: pada scratched surface terlihat pola garis pada spektrum. Hubungannya bersifat tegak lurus. Jika goresan dominan vertikal di domain spasial, maka spektrum cenderung memanjang horizontal; sebaliknya jika goresan horizontal, spektrum memanjang vertikal. Ini jadi indikator arah cacat yang cukup kuat.

Scatter low vs high menunjukkan pemisahan kelas lebih baik: titik pitted berada di level energi lebih tinggi, scratched lebih rendah.

#figure(
  image("assets/surface_energy_bar.png", width: 100%),
  caption: [Perbandingan rata-rata fitur energi frekuensi pitted vs scratched surface],
)

#figure(
  image("assets/surface_energy_scatter.png", width: 85%),
  caption: [Scatter plot energi frekuensi rendah dan tinggi untuk pitted dan scratched surface: pemisahan kelas terlihat lebih jelas dibanding leaf disease],
)

#figure(
  image("assets/surface_ratio_boxplot.png", width: 70%),
  caption: [Distribusi rasio energi frekuensi low/high untuk pitted dan scratched surface],
)

#figure(
  image("assets/surface_radial_profile.png", width: 100%),
  caption: [Distribusi radial $R(r)$ untuk pitted dan scratched],
)

#figure(
  table(
    columns: (auto, auto),
    align: (left, center),
    table.header([*Kelas*], [*radial_high_mean*]),
    [Pitted (Normal)], [4.59e+02],
    [Scratched (Cacat)], [2.19e+02],
  ),
  kind: table,
  caption: [Metrik radial sederhana berbasis $R(r)$ pada radius tinggi],
)

== Ringkasan Metrik Gabungan

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, center, center, center),
    table.header([*Kelas*], [*Energi Rendah*], [*Energi Tinggi*], [*Rasio Low/High*]),
    [Daun sehat], [5.48e+13], [1.07e+12], [65.33],
    [Daun sakit], [5.81e+13], [4.70e+11], [145.21],
    [Pitted (Normal)], [7.27e+13], [1.66e+11], [473.13],
    [Scratched (Cacat)], [2.26e+13], [7.68e+10], [412.31],
  ),
  kind: table,
  caption: [Ringkasan energi frekuensi rata-rata untuk semua kelas: leaf disease dan surface defect],
)

== Pembahasan Komparatif Antar Domain
Secara umum, alur kerja Fourier pada citra di laporan ini adalah: citra dibaca, diubah ke grayscale, dihitung FFT, dibentuk log magnitude spectrum, lalu diekstraksi energi frekuensi rendah dan tinggi. Visualisasi dipakai untuk observasi awal, sedangkan metrik energi dipakai untuk pembacaan yang lebih objektif.

=== Perbandingan Leaf Disease vs Surface Defect

Dari kedua domain analisis, terlihat pola yang berbeda.

*Leaf Disease:*
+ Energi daun sehat vs sakit tidak berbeda drastis (keduanya ~5.5e13)
+ Rasio low/high menjadi pembeda utama: sehat 65.33 vs sakit 145.21
+ Pemisahan kelas tidak sempurna pada scatter plot, menunjukkan bahwa perbedaan spektral global tidak signifikan
+ Interpretasi: penyakit daun bersifat lokal, tidak mengubah struktur global spektrum

*Surface Defect:*
+ Energi rendah pitted vs scratched jauh berbeda (7.27e13 vs 2.26e13)
+ Energi tinggi juga berbeda signifikan (1.66e11 vs 7.68e10)
+ Pemisahan kelas pada scatter plot terlihat jelas, dengan pitted di zona energi tinggi dan scratched di zona energi rendah
+ Interpretasi: karakteristik permukaan berbeda pada landasan tekstur, sehingga tercermin dalam spektrum global

Surface defect menunjukkan hasil yang lebih diskriminatif dibanding leaf disease. Hal ini karena perbedaan antara pitted dan scratched merupakan perbedaan tekstural pada landasan pola (acak vs linear), sedangkan perbedaan daun sehat vs sakit lebih bersifat lokal (bercak kecil pada permukaan daun besar). Untuk aplikasi praktis, Fourier global lebih efektif untuk surface defect, sementara untuk leaf disease perlu dikombinasikan dengan teknik lokalisasi seperti segmentasi atau attention mechanism.

= JAWABAN PERTANYAAN FUNDAMENTAL

== Apa yang dimaksud dengan domain frekuensi dalam citra digital?
Domain frekuensi adalah representasi citra berdasarkan tingkat perubahan intensitas piksel, bukan berdasarkan posisi koordinat spasial $(x, y)$. Dalam domain ini, citra diurai menjadi kombinasi gelombang sinus dan kosinus dengan frekuensi, magnitudo, dan fase tertentu.

== Jelaskan hubungan antara perubahan intensitas piksel dengan frekuensi.
Hubungan keduanya berbanding lurus dengan kecepatan perubahan nilai intensitas. Perubahan intensitas yang lambat atau area dengan warna yang cenderung seragam (gradasi halus) menghasilkan komponen frekuensi rendah. Sebaliknya, perubahan intensitas yang mendadak dan tajam dalam jarak yang pendek menghasilkan komponen frekuensi tinggi.

== Mengapa bercak pada daun menghasilkan komponen frekuensi tinggi?
Bercak penyakit seperti leaf mold memiliki batas atau tepi yang kontras terhadap area daun sehat. Transisi warna yang tajam dari hijau daun ke cokelat atau kuning pada bercak merupakan perubahan intensitas piksel yang cepat di domain spasial. Perubahan mendadak ini memicu munculnya magnitudo signifikan pada area frekuensi tinggi di spektrum Fourier.

== Apa perbedaan interpretasi frekuensi tinggi dan rendah pada citra?
Frekuensi rendah merepresentasikan informasi global, struktur utama objek, serta area halus atau homogen pada citra. Frekuensi tinggi merepresentasikan detail halus, tepi objek (edges), garis-garis tajam, tekstur kasar, dan komponen gangguan seperti noise atau bercak penyakit.

== Mengapa dilakukan transformasi log pada magnitude spectrum?
Nilai magnitudo Fourier memiliki rentang dinamis (dynamic range) yang sangat lebar, sehingga energi di pusat (frekuensi rendah) jauh lebih besar daripada energi di pinggiran (frekuensi tinggi). Tanpa transformasi log, spektrum cenderung terlihat sebagai titik terang di pusat dengan latar belakang gelap. Transformasi logaritma
digunakan untuk menyempitkan rentang nilai agar detail frekuensi tinggi yang lemah tetap terlihat.

== Apa yang terjadi jika hanya frekuensi rendah yang dipertahankan?
Jika hanya frekuensi rendah yang dipertahankan (low-pass filtering), citra kehilangan detail tajam, tepi objek, dan tekstur kasar. Hasil citra menjadi lebih halus atau kabur (blur) karena komponen perubahan intensitas cepat telah dibuang.

== Apa yang terjadi jika hanya frekuensi tinggi yang dipertahankan?
Jika hanya frekuensi tinggi yang dipertahankan (high-pass filtering), area dengan intensitas seragam atau gradasi lambat menjadi gelap karena energinya dibuang. Citra hasil filter menyisakan tepi objek, garis halus, dan tekstur tajam, sehingga pendekatan ini sering dipakai untuk deteksi tepi atau penajaman citra (sharpening).

= JAWABAN PERTANYAAN ANALISIS

== Bandingkan spektrum Fourier antara daun sehat dan daun sakit.
Secara visual, spektrum daun sehat dan sakit sama-sama terang di pusat (low frequency dominan), jadi tidak langsung terpisah tegas. Perbedaannya lebih terasa di sebaran energi: pada data ini daun sakit cenderung punya rasio low/high lebih tinggi. Jadi saya pakai angka metrik, bukan hanya lihat gambar spektrum.

== Bagaimana distribusi energi frekuensi pada citra defect dibandingkan citra normal?
Pada eksperimen surface, pitted (normal baseline) punya energi lebih besar daripada scratched, baik di low maupun high. Jadi pembeda utama di data ini bukan sekadar naik-turun high frequency, tapi pola distribusi total energinya.

== Apakah pola pada citra defect memiliki arah tertentu pada spektrum?
Ya. Pada scratched surface terlihat pola berarah, dan hubungan arahnya tegak lurus antara domain spasial dan domain frekuensi. Goresan vertikal di citra asli akan muncul sebagai pola horizontal di spektrum Fourier, dan sebaliknya.

== Fourier lebih efektif untuk pola acak atau pola terstruktur?
Dari hasil saya, Fourier lebih efektif untuk pola terstruktur seperti goresan scratched. Untuk pola yang lokal dan tidak terlalu teratur seperti bercak daun, Fourier global masih membantu, tapi pemisahannya tidak sekuat pada surface defect.

== Buat satu metrik sederhana berbasis frekuensi untuk membedakan kelas citra.
Metrik yang dipakai adalah radial_high_mean dari distribusi radial $R(r)$, yaitu rata-rata magnitudo FFT pada radius tinggi (60% radius terluar). Angka 60% dipilih berdasarkan observasi grafik radial (Gambar distribusi radial) saat perbedaan distribusi energi antara pitted dan scratched mulai tampak signifikan pada frekuensi menengah ke atas. Pada data surface, nilai rata-ratanya:
+ pitted: 4.59e+02
+ scratched: 2.19e+02

Metrik ini lebih informatif daripada rasio total karena langsung melihat bagaimana energi tersebar terhadap radius frekuensi.

== Apakah Fourier cukup untuk klasifikasi? Jelaskan keterbatasannya.
Belum cukup jika dipakai sendirian. Keterbatasan paling penting adalah transformasi Fourier mengabaikan aspek lokalisasi spasial: komponen frekuensi dapat diketahui, tetapi posisi bercak pada citra tidak dapat ditentukan secara langsung. Karena itu, Fourier sebaiknya digabung dengan segmentasi ROI atau fitur spasial lain.

= KESIMPULAN

Laporan ini mempresentasikan dua studi kasus penggunaan transformasi Fourier untuk analisis citra: leaf disease dan surface defect.

*Pada Leaf Disease*: 
Transformasi Fourier berhasil mengekstraksi fitur spektral yang membedakan daun sehat dan sakit. Hasil menunjukkan rasio frekuensi low/high dapat memisahkan kecenderungan kelas (sehat 65.33 vs sakit 145.21), tetapi pemisahan kelas tidak sempurna. Ini wajar karena penyakit daun bersifat lokal dan global spectrum tetap didominasi struktur daun yang sehat. Kesimpulannya, Fourier cocok sebagai fitur pendukung, bukan klasifikasi utama.

*Pada Surface Defect*:
Transformasi Fourier menunjukkan efektivitas yang lebih tinggi. Perbedaan energi frekuensi antara pitted (normal) dan scratched (cacat) cukup signifikan dan terlihat dalam visualisasi spektrum. Pitted surface (tekstur acak) menampilkan spektrum simetris dengan energi tersebar, sementara scratched surface (goresan terstruktur) menampilkan pola arah di spektrum. Scatter plot menunjukkan pemisahan kelas yang jauh lebih baik, menjadikan metrik energi Fourier sebagai fitur yang cukup kuat untuk membedakan kedua kelas permukaan.
