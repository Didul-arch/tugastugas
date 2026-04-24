#import "lib/format_ppki.typ": *

#let nama-mahasiswa = "Syafiq Syadidul Azmi"
#let nrp = "G6401231075"
#let kelas-paralel = "K3"
#let nama-dosen = "Dr. Toto Haryanto, S.Kom, M.Si"
#let nama-asisten = ("Ahmad Nur Rohim", "Salsabila Azzahra")

#show: ppki.with(
  judul: "LKP 7 - Filtering Domain Frekuensi",
  nama-penulis: nama-mahasiswa,
  nim: nrp,
  program-studi: "Ilmu Komputer",
  fakultas: "Sekolah Sains Data Matematika dan Informatika",
  tahun: "2026",
  jenis-karya: "laporan-akhir",
)

// Halaman 1: Sampul
#show: bagian-awal

#halaman-sampul(
  judul: "LEMBAR KERJA PRAKTIKUM",
  nama: nama-mahasiswa,
  nim: nrp,
  program-studi: "ILMU KOMPUTER",
  fakultas: "SEKOLAH SAINS DATA MATEMATIKA DAN INFORMATIKA",
  tahun: "2026",
  logo: image("assets/logo-ipb.png", width: 2.5cm),
)

// Halaman 2: Identitas Praktikum (tengah, rapi)
#pagebreak()
#set page(numbering: none, header: none, footer: none)
#set par(first-line-indent: 0pt, justify: false)

#v(8.5cm)
#align(center)[
  #v(1.2em)
  #table(
    columns: (auto, auto, auto),
    inset: 6pt,
    stroke: none,
    column-gutter: 0.8em,
    [Nama],         [:], [#nama-mahasiswa],
    [NRP],          [:], [#nrp],
    [Kelas Paralel],[:], [#kelas-paralel],
    [Nama Dosen],   [:], [#nama-dosen],
    ..nama-asisten.map(asisten => (
      if asisten == nama-asisten.first() {
        (
          [Nama Asisten],
          [:],
          [#asisten],
        )
      } else {
        (
          [],
          [:],
          [#asisten],
        )
      }
    )).flatten(),
  )
]

#pagebreak()
#daftar-isi()

// Bagian isi
#show: bagian-isi
#set par(justify: true)

= HASIL DAN PEMBAHASAN

== Variasi Radius (Type 0)

=== Radius 10, Type 0
#image("assets/radius_10_type_0_lpf_hpf.png", width: 100%)

Penjelasan singkat:
Radius berukuran 10 membuat lingkaran hitam (HighPass Filter) dan putih (LowPass Filter) yang berukuran kecil, hasilnya blur sangat kuat.

=== Radius 20, Type 0
#image("assets/radius_20_type_0_lpf_hpf.png", width: 100%)

Penjelasan singkat: Radius berukuran 20 membuat lingkaran berkuran sedang menghasilkan blur yang sedang pada low pass filter dan garis yang lebih jelas dibanding radius 10. 
#lorem(10)

=== Radius 30, Type 0
File gambar gabungan: `assets/radius_30_type_0_lpf_hpf.png`

#image("assets/radius_30_type_0_lpf_hpf.png", width: 100%)

Penjelasan singkat: Radius berukuran 30 membuat lingkaran yang lebih besar dibanding radius sebelumnya, menghasilkan blur pada low pass filter yang lebih ringan dibanding 2 radius sebelumnya dan garis yang lebih jelas dibanding 2 radius sebelumnya.

=== Kesimpulan Variasi Radius
- Pada Low Pass Filter : Jika nilai radius kecil, maka gerbang filter sangat sempit sehingga hanya frekuensi yang benar-benar rendah (area datar) yang berhasil masuk. Hal ini menyebabkan efek pemburaman (blur) yang dihasilkan sangat kuat dan hampir seluruh detail gambar menghilang. Sebaliknya, pada radius yang besar, filter meloloskan lebih banyak cakupan frekuensi (termasuk frekuensi menengah). Akibatnya, efek blur semakin berkurang dan citra terlihat jauh lebih jelas mendekati wujud aslinya.

- Pada High Pass Filter : Jika nilai radius kecil, area pemblokiran di pusat spektrum masih terlalu sempit, sehingga sebagian frekuensi rendah dan menengah masih ikut lolos. Hal ini menghasilkan ekstraksi garis tepi yang tebal dengan latar belakang yang belum sepenuhnya gelap pekat. Sebaliknya, pada radius yang besar, filter berhasil memblokir area frekuensi rendah secara maksimal dan hanya menyisakan frekuensi yang paling tinggi. Hasilnya, citra menampilkan garis tepi yang sangat tipis, tajam, ekstrem, dengan latar belakang yang benar-benar hitam pekat.


== Variasi Filter Type (Radius 10)

=== Radius 10, Type 0 (Ideal)
#image("assets/type_0_radius_10_lpf_hpf.png", width: 100%)

Penjelasan singkat: Penggunaan filter Ideal (Type 0) melakukan pemotongan frekuensi secara mendadak atau tegak lurus. Karakteristik pemotongan kasar ini menyebabkan komputer "kaget" dan memunculkan *ringing effect* (artefak cincin bergelombang) yang sangat kuat di sekitar objek, sehingga citra terlihat tidak natural.

=== Radius 10, Type 1 (Butterworth)
#image("assets/type_1_radius_10_lpf_hpf.png", width: 100%)

Penjelasan singkat: Filter Butterworth (Type 1) memiliki transisi pemotongan frekuensi yang lebih melengkung (seperti perosotan) dibandingkan tipe Ideal. Kelandaian ini berhasil meredam efek kejutan pada perhitungan, sehingga *ringing effect* berkurang secara drastis. Hasil citra terlihat lebih halus pada LPF dan garis tepinya lebih rapi pada HPF.

=== Radius 10, Type 2 (Gaussian)
#image("assets/type_2_radius_10_lpf_hpf.png", width: 100%)

Penjelasan singkat: Filter Gaussian (Type 2) menggunakan kurva lonceng statistik yang sangat landai untuk memotong frekuensi. Karena transisinya yang perlahan dan paling mulus, filter ini terbukti sepenuhnya bebas dari *ringing effect*. Hasil pemfilteran memberikan efek blur yang paling natural (LPF) dan ekstraksi tepi yang paling bersih (HPF) tanpa ada gangguan riak.

=== Kesimpulan Variasi Filter Type
- Tipe filter (Type) menentukan bagaimana cara transisi saringan dalam memotong frekuensi, yang berdampak langsung pada kehadiran *ringing effect* (efek riak/gelombang). 
- Filter **Ideal (Type 0)** menghasilkan riak yang paling parah karena memotong frekuensi layaknya jurang vertikal. 
- Filter **Butterworth (Type 1)** berperan sebagai jalan tengah dengan memberikan transisi yang lebih landai sehingga meminimalisir riak. 
- Filter **Gaussian (Type 2)** adalah tipe yang paling optimal, memberikan kurva transisi yang paling mulus sehingga gambar 100% terbebas dari efek riak dan menghasilkan visual yang paling natural.

= LAMPIRAN

== Kode Program

#table(
  columns: (65%, 35%),
  stroke: 0.6pt,
  inset: 8pt,
  align: (left, left),

  [*Potongan Kode*], [*Penjelasan Singkat*],

  [
```python
def createLPFilter(shape, center, radius, lpType=2, n=2):
    rows, cols = shape[:2]
    r, c = np.mgrid[0:rows:1, 0:cols:1]
    c -= center[0]
    r -= center[1]
    d = np.power(c, 2.0) + np.power(r, 2.0)

    if lpType == 0:
        lpFilter = np.copy(d)
        lpFilter[lpFilter < pow(radius, 2.0)] = 1
        lpFilter[lpFilter >= pow(radius, 2.0)] = 0
    elif lpType == 1:
        lpFilter = 1.0 / (1 + np.power(np.sqrt(d) / radius, 2 * n))
    else:
        lpFilter = np.exp(-d / (2 * pow(radius, 2.0)))
```
  ],
  [
  Fungsi ini membentuk low-pass filter dalam domain frekuensi dengan tiga tipe: Ideal, Butterworth, dan Gaussian.
  ],

  [
```python
def createHPFilter(shape, center, radius, lpType=2, n=2):
    rows, cols = shape[:2]
    r, c = np.mgrid[0:rows:1, 0:cols:1]
    c -= center[0]
    r -= center[1]
    d = np.power(c, 2.0) + np.power(r, 2.0)

    if lpType == 0:
        lpFilter = np.copy(d)
        lpFilter[lpFilter < pow(radius, 2.0)] = 0
        lpFilter[lpFilter >= pow(radius, 2.0)] = 1
    elif lpType == 1:
        lpFilter = 1.0 - 1.0 / (1 + np.power(np.sqrt(d) / radius, 2 * n))
    else:
        lpFilter = 1.0 - np.exp(-d / (2 * pow(radius, 2.0)))
```
  ],
  [
  Fungsi ini membentuk high-pass filter untuk menonjolkan komponen frekuensi tinggi seperti tepi objek.
  ],

  [
```python
def stdFftImage(img_gray, rows, cols):
    fimg = img_gray.astype(np.float32)
    for r in range(rows):
        for c in range(cols):
            if (r + c) % 2:
                fimg[r][c] = -1 * fimg[r][c]
    img_fft = fftImage(fimg, rows, cols)
    return img_fft

def graySpectrum(fft_img):
    real = np.power(fft_img[:, :, 0], 2.0)
    imaginary = np.power(fft_img[:, :, 1], 2.0)
    amplitude = np.sqrt(real + imaginary)
    spectrum = np.log(amplitude + 1.0)
    return amplitude, spectrum
```
  ],
  [
  Blok ini melakukan sentralisasi spektrum, transformasi Fourier, dan menghitung magnitude spectrum.
  ],

  [
```python
output_dir = "./assets"
os.makedirs(output_dir, exist_ok=True)

for r in radius:
    lowPassFilter = createLPFilter(image_fft.shape, maxLoc, r, tipe_filter[0])
    highPassFilter = createHPFilter(image_fft.shape, maxLoc, r, tipe_filter[0])
    # proses inverse dan visualisasi
    file_path = f"{output_dir}/radius_{r}_type_0_lpf_hpf.png"
    fig.savefig(file_path, dpi=200, bbox_inches="tight")
```
  ],
  [
  Bagian ini menjalankan eksperimen variasi radius (type tetap 0), menampilkan hasil LPF dan HPF, lalu menyimpan gambar ke folder assets.
  ],

  [
```python
radius_tetap = 10
tipe_filter = [0, 1, 2]

for t in tipe_filter:
    lowPassFilter = createLPFilter(image_fft.shape, maxLoc, radius_tetap, t)
    highPassFilter = createHPFilter(image_fft.shape, maxLoc, radius_tetap, t)
    # proses inverse dan visualisasi
    file_path = f"{output_dir}/type_{t}_radius_10_lpf_hpf.png"
    fig.savefig(file_path, dpi=200, bbox_inches="tight")
```
  ],
  [
  Bagian ini menjalankan eksperimen variasi tipe filter (radius tetap 10), kemudian menyimpan hasil tiap tipe secara otomatis.
  ],
)
