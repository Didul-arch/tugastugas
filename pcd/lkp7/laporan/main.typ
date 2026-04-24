#import "lib/format_ppki.typ": *

#show: ppki.with(
  judul: "Laporan Kerja Praktikum 7 Pengolahan Citra Digital: Transformasi Hough",
  nama-penulis: "Syafiq Syadidul Azmi",
  nim: "G6401231075",
  program-studi: "Ilmu Komputer",
  fakultas: "Sekolah Sains Data Matematika dan Informatika",
  tahun: "2026",
  jenis-karya: "laporan-akhir",
)

#show: bagian-awal

#halaman-sampul(
  judul: "Laporan Kerja Praktikum 7 Pengolahan Citra Digital Materi Transformasi Hough",
  nama: "SYAFIQ SYADIDUL AZMI",
  nim: "G6401231075",
  program-studi: "ILMU KOMPUTER",
  fakultas: "Sekolah Sains Data Matematika dan Informatika",
  tahun: "2026",
  logo: image("assets/logo-ipb.png", width: 2.5cm),
)

#daftar-isi()
#daftar-gambar()

#show: bagian-isi

= Hough Line Transform

#table(
  columns: (1fr,),
  stroke: .5pt,
  inset: 8pt,
  [
```python
def gridtest_hough_lines(values, detector, title, file_prefix, parameter_name):
    fig, axes = plt.subplots(1, len(values), figsize=(6 * len(values), 6))
    for idx, value in enumerate(values):
        img = base_img_lines.copy()
        lines = detector(value)
        draw_hough_lines(img, lines, (0, 255, 255))
        axes[idx].imshow(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))
        axes[idx].set_title(f'{parameter_name} = {value}')
        axes[idx].axis('off')
    plt.savefig(f'{output_dir}/{file_prefix}_grid.png', dpi=200, bbox_inches='tight')

gridtest_hough_lines(
    rho_values,
    lambda rho: cv2.HoughLines(edges_lines, rho, np.pi / 180, 80),
    'Variasi Parameter rho - Hough Lines',
    'hough_lines_rho',
    'rho',
)
```
  ],
)

Potongan kode di atas menunjukkan fungsi utama `gridtest_hough_lines` yang melakukan pengujian beberapa nilai parameter secara otomatis dalam satu kali jalan.
== Pengaruh `rho`
Parameter ini menentukan tingkat ketelitian (resolusi) jarak dalam piksel. Umumnya diisi dengan angka `1` yang berarti jarak dihitung per 1 piksel (sangat akurat). Jika angka ini diperbesar (misalnya menjadi `10`), maka pencarian garis akan menjadi lebih kasar dan kurang presisi karena komputer menghitung dengan lompatan jarak tiap 10 piksel.

#figure(
  image("assets/output/hough_lines_rho_grid.png", width: 85%),
  caption: [Variasi parameter rho pada Hough Lines],
)

== Pengaruh `theta`
Parameter ini menentukan tingkat ketelitian (resolusi) sudut dalam satuan radian. Biasanya diisi dengan `np.pi / 180` yang setara dengan 1 derajat. Jika nilainya diperbesar, maka komputer akan memindai kemiringan garis dengan rentang sudut yang lebih lebar/kasar, sehingga bisa menyebabkan garis yang posisinya agak miring tidak terdeteksi dengan tepat.

#figure(
  image("assets/output/hough_lines_theta_grid.png", width: 85%),
  caption: [Variasi parameter theta pada Hough Lines],
)

== Pengaruh `threshold`
Ini adalah ambang batas perolehan suara (akumulator) minimum agar sebuah deretan piksel diakui sebagai garis lurus. Jika angkanya terlalu tinggi (misalnya `200`), syaratnya terlalu ketat sehingga tidak ada garis yang lolos seleksi. Jika angkanya terlalu rendah (misalnya `50`), syaratnya terlalu longgar sehingga muncul terlalu banyak garis yang saling bertumpuk.

#figure(
  image("assets/output/hough_lines_threshold_grid.png", width: 85%),
  caption: [Variasi parameter threshold pada Hough Lines],
)

== Pengaruh `srn`
Parameter ini digunakan jika ingin menerapkan metode Multi-scale Hough Transform. `srn` bertindak sebagai pembagi (divisor) untuk resolusi jarak. Jika diisi `0`, program menggunakan metode klasik (Standard Hough Transform). Jika diisi angka positif (misalnya `10`), maka akurasi pencarian jarak akan ditingkatkan menjadi `rho / srn`.

#figure(
  image("assets/output/hough_lines_srn_grid.png", width: 85%),
  caption: [Variasi parameter srn pada Hough Lines],
)

== Pengaruh `stn`
Sama fungsinya dengan `srn`, tetapi `stn` bertindak sebagai pembagi untuk resolusi sudut pada Multi-scale Hough Transform. Akurasi sudut akan ditingkatkan menjadi `theta / stn`. Jika dibiarkan `0`, maka mode Multi-scale tidak diaktifkan.

#figure(
  image("assets/output/hough_lines_stn_grid.png", width: 85%),
  caption: [Variasi parameter stn pada Hough Lines],
)

= Hough Circle Transform


#table(
  columns: (1fr,),
  stroke: .5pt,
  inset: 8pt,
  [
```python
def gridtest_hough_circles(values, detector, title, file_prefix, parameter_name):
    fig, axes = plt.subplots(1, len(values), figsize=(6 * len(values), 6))
    for idx, value in enumerate(values):
        img = base_img_circles.copy()
        circles = detector(value)
        draw_hough_circles(img, circles, (0, 255, 0), (0, 0, 255))
        axes[idx].imshow(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))
        axes[idx].set_title(f'{parameter_name} = {value}')
        axes[idx].axis('off')
    plt.savefig(f'{output_dir}/{file_prefix}_grid.png', dpi=200, bbox_inches='tight')

gridtest_hough_circles(
    dp_values,
    lambda dp: cv2.HoughCircles(gray_circles, cv2.HOUGH_GRADIENT, dp, minDist_base,
        param1=param1_base, param2=param2_base, minRadius=minRadius_base, maxRadius=maxRadius_base),
    'Variasi Parameter dp - Hough Circles',
    'hough_circles_dp',
    'dp',
)
```
  ],
)

Fungsi utama `gridtest_hough_circles` bekerja mirip dengan pengujian garis, yaitu melakukan iterasi nilai parameter, menggambar hasil lingkaran pada citra, lalu menyusun hasil menjadi grid per parameter. 

== Pengaruh `dp`
Parameter ini adalah rasio invers dari resolusi matriks akumulator terhadap resolusi gambar asli. Jika diatur `1`, maka resolusi akumulator sama dengan gambar (sangat detail). Jika diatur `2`, maka ukuran akumulator menjadi setengah dari gambar aslinya (lebih cepat diproses, namun sedikit berkurang ketajamannya). Secara umum, `1` adalah nilai yang paling stabil.

#figure(
  image("assets/output/hough_circles_dp_grid.png", width: 85%),
  caption: [Variasi parameter dp pada Hough Circles],
)

== Pengaruh `minDist`
Parameter ini menentukan jarak minimum antar titik pusat lingkaran. Jika nilainya terlalu kecil, program bisa salah mengartikan satu objek menjadi dua atau tiga lingkaran yang saling bertumpuk. Jika nilainya terlalu besar, objek yang posisinya berdekatan tidak akan terdeteksi karena dianggap sebagai bagian dari lingkaran tetangganya.

#figure(
  image("assets/output/hough_circles_minDist_grid.png", width: 85%),
  caption: [Variasi parameter minDist pada Hough Circles],
)

== Pengaruh `param1`
Parameter ini merupakan nilai threshold atas untuk proses pendeteksian tepi (Canny Edge Detection) yang berjalan otomatis di dalam fungsi ini. Jika angkanya terlalu besar, hanya perbedaan warna atau tepi objek yang sangat kontras yang akan dihitung. Jika terlalu kecil, bercak atau pantulan cahaya bisa salah diartikan sebagai tepi objek.

#figure(
  image("assets/output/hough_circles_param1_grid.png", width: 85%),
  caption: [Variasi parameter param1 pada Hough Circles],
)

== Pengaruh `param2`
Parameter ini merupakan nilai threshold (ambang batas suara) untuk menentukan apakah sebuah bentuk lengkung sah menjadi lingkaran. Jika terlalu kecil (misalnya `15`), program rawan menghasilkan false positive. Jika terlalu besar (misalnya `100`), syaratnya terlalu ketat sehingga hanya objek yang sangat bulat dan jelas yang akan terdeteksi.

#figure(
  image("assets/output/hough_circles_param2_grid.png", width: 85%),
  caption: [Variasi parameter param2 pada Hough Circles],
)

== Pengaruh `minRadius`
Parameter ini menentukan batas minimum ukuran jari-jari lingkaran (dalam piksel) yang ingin dicari. Dengan memperkecil nilainya, objek lingkaran kecil tetap bisa terdeteksi. Namun jika terlalu kecil, pola melingkar yang bukan objek utama juga bisa ikut terdeteksi.

#figure(
  image("assets/output/hough_circles_minRadius_grid.png", width: 85%),
  caption: [Variasi parameter minRadius pada Hough Circles],
)

== Pengaruh `maxRadius`
Parameter ini menentukan batas maksimum ukuran jari-jari lingkaran (dalam piksel) yang ingin dicari. Pada citra *citrus.jpeg*, objek jeruk memiliki variasi jarak dari kamera. Dengan memperlebar rentang nilai `minRadius` dan `maxRadius`, program bisa mendeteksi objek berukuran kecil maupun besar dalam satu proses.

#figure(
  image("assets/output/hough_circles_maxRadius_grid.png", width: 85%),
  caption: [Variasi parameter maxRadius pada Hough Circles],
)