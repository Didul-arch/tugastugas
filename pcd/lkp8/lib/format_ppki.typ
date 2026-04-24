// ==============================================================
// format_ppki.typst
// Template Karya Ilmiah Tugas Akhir IPB
// Berdasarkan Pedoman Penulisan Karya Ilmiah (PPKI) Edisi ke-4
// IPB Press, Desember 2019
//
// Referensi utama: Lampiran 16 PPKI Edisi ke-4
//   (Ringkasan Ketentuan Pengetikan)
// ==============================================================
//
// CARA PENGGUNAAN
// ---------------
// Di file .typst lain, tulis:
//
//   #import "format_ppki.typst": *
//
//   #show: ppki.with(
//     judul:         "Judul Karya Ilmiah Anda",
//     nama-penulis:  "Nama Lengkap Penulis",
//     nim:           "NXXXXXXXXX",
//     kelas-paralel: "K3",
//     nama-dosen:    "Nama Dosen",
//     nama-asisten:  "Nama Asisten",
//     program-studi: "Nama Program Studi",
//     departemen:    "Nama Departemen",   // kosongkan jika tidak ada
//     fakultas:      "Nama Fakultas",
//     tahun:         "2024",
//   )
//
//   // ── Bagian Awal (nomor halaman Romawi: i, ii, iii, …) ──
//   #show: bagian-awal
//
//   #halaman-sampul(
//     judul:         "Judul Karya Ilmiah",
//     nama:          "Nama Lengkap",
//     nim:           "NXXXXXXXXX",
//     program-studi: "Program Studi",
//     departemen:    "Departemen",
//     fakultas:      "Fakultas",
//     tahun:         "2024",
//     logo:          image("logo-ipb.png"),  // opsional
//   )
//
//   #abstrak(
//     nama:        "NAMA MAHASISWA",
//     judul:       "Judul Skripsi dalam Bahasa Indonesia",
//     pembimbing:  ("Nama Pembimbing 1", "Nama Pembimbing 2"),
//     isi:         [Narasi abstrak maks. 200 kata, 1 paragraf.],
//     kata-kunci:  "kata1, kata2, kata3",
//   )
//
//   #abstract-en(
//     nama:       "STUDENT NAME",
//     judul:      "Thesis Title in English",
//     pembimbing: ("Supervisor Name 1", "Supervisor Name 2"),
//     isi:        [Abstract narrative, max 200 words, 1 paragraph.],
//     keywords:   "keyword1, keyword2, keyword3",
//   )
//
//   #daftar-isi()
//   #daftar-tabel()    // hapus baris ini jika tabel ≤ 1
//   #daftar-gambar()   // hapus baris ini jika gambar ≤ 1
//
//   // ── Bagian Isi (nomor halaman Arab: 1, 2, 3, …) ────────
//   #show: bagian-isi
//
//   = PENDAHULUAN
//   == Latar Belakang
//   Teks paragraf dimulai di sini …
//
//   == Tujuan Penelitian
//   ...
//
//   = TINJAUAN PUSTAKA
//   ...
//
//   #daftar-pustaka[
//     Satria A. 2015. Politik Kelautan dan Perikanan. Jakarta: Obor. \
//     Smith J, Doe A. 2020. Judul Artikel. J Nama Jurnal. 10(2):1−10. \
//   ]
//
//   #lampiran[
//     // Konten lampiran...
//   ]
//
//   #riwayat-hidup[
//     Penulis dilahirkan di … pada tanggal …
//   ]
//
// ==============================================================


// ─── Konstanta ───────────────────────────────────────────────

// Jenis huruf utama (PPKI Lampiran 16: Times New Roman)
#let _font = "Times New Roman"

// Ukuran huruf teks biasa: 12pt (PPKI Lampiran 16)
#let _sz-body = 12pt

// Ukuran huruf judul bab: 14pt (PPKI Lampiran 16)
#let _sz-bab = 14pt

// Jarak antarbaris (1 spasi). Nilai 0.65em adalah setara
// dengan "single spacing" pada Typst untuk teks 12pt.
#let _leading = 0.65em

// Pengaturan layout Daftar Isi agar nomor subbab sejajar dengan judul bab.
#let _toc-prefix-width = 1em
#let _toc-level1-prefix-width = 0.85em
#let _toc-prefix-gap = 0.45em
#let _toc-level-step = 0.4em

#let _nomor-halaman-header(fmt, kelas-paralel: "", nama-dosen: "") = context {
  let n = counter(page).get().first()
  let nomor = counter(page).display(fmt)
  let kelas = if kelas-paralel != "" { upper(kelas-paralel) } else { "" }
  let dosen = if nama-dosen != "" { upper(nama-dosen) } else { "" }

  if kelas == "" and dosen == "" {
    align(if calc.even(n) { left } else { right })[
      #nomor
    ]
  } else {
    table(
      columns: (1fr, 1fr, auto),
      inset: 0pt,
      stroke: none,
      [#text(size: 9pt)[#kelas]],
      [#align(center)[#text(size: 9pt)[#dosen]]],
      [#align(right)[#nomor]],
    )
  }
}

#let _toc-entry-content(it) = {
  if it.level == 1 {
    [
      #box(width: _toc-level1-prefix-width)[#it.prefix()]
      #h(_toc-prefix-gap)
      #it.body()
    ]
  } else {
    let extra-indent = if it.level > 2 {
      (it.level - 2) * _toc-level-step
    } else {
      0em
    }
    pad(left: _toc-prefix-width + _toc-prefix-gap + extra-indent)[
      #it.prefix()
      #h(_toc-prefix-gap)
      #it.body()
    ]
  }
}

#let _toc-entry(it) = {
  link(
    it.element.location(),
    table(
      columns: (1fr, auto),
      inset: 0pt,
      stroke: none,
      [#_toc-entry-content(it)],
      [#it.page()],
    ),
  )
}


// ─── Penomoran Halaman ────────────────────────────────────────

/// Aktifkan penomoran halaman Romawi kecil (i, ii, iii, …).
/// Digunakan untuk bagian awal (abstrak s.d. daftar lampiran).
///
/// Gunakan: #show: bagian-awal
#let bagian-awal(body) = {
  set page(numbering: "i", header: none, footer: none)
  counter(page).update(1)
  body
}

/// Aktifkan penomoran halaman Arab (1, 2, 3, …).
/// Digunakan mulai dari Bab Pendahuluan.
///
/// Gunakan: #show: bagian-isi
#let bagian-isi(body, kelas-paralel: "", nama-dosen: "") = {
  set page(numbering: none, header: _nomor-halaman-header("1", kelas-paralel: kelas-paralel, nama-dosen: nama-dosen), footer: none)
  counter(page).update(1)
  body
}


// ─── Template Utama ──────────────────────────────────────────

/// Fungsi pembungkus format dokumen PPKI. Terapkan dengan:
///   #show: ppki.with(...)
///
/// Parameter:
///   judul          - Judul karya ilmiah
///   nama-penulis   - Nama lengkap penulis
///   nim            - Nomor Induk Mahasiswa
///   jenis-karya    - "laporan-akhir" | "skripsi" | "tesis" | "disertasi"
///   program-studi  - Nama program studi
///   departemen     - Nama departemen (boleh kosong)
///   fakultas       - Nama fakultas/sekolah
///   tahun          - Tahun lulus (string, mis. "2024")
#let ppki(
  judul: "",
  nama-penulis: "",
  nim: "",
  jenis-karya: "skripsi",
  kelas-paralel: "",
  nama-dosen: "",
  program-studi: "",
  departemen: "",
  fakultas: "",
  tahun: "",
  body,
) = {
  // ── Kertas & Pias (Margin) ────────────────────────────────
  // A4: 21,0 cm × 29,7 cm  (PPKI Lampiran 16: Bahan dan Ukuran Kertas)
  // Pias kiri 4 cm, kanan 3 cm, atas 3 cm, bawah 3 cm (PPKI Lampiran 16 butir 2)
  set page(
    paper: "a4",
    margin: (
      right: 3cm,
      left: 4cm,
      top: 3cm,
      bottom: 3cm,
    ),
    // Nomor halaman di luar atas: ganjil kanan, genap kiri.
    numbering: none,
    header: _nomor-halaman-header("1", kelas-paralel: kelas-paralel, nama-dosen: nama-dosen),
    footer: none,
  )

  // ── Jenis & Ukuran Huruf ─────────────────────────────────
  // Times New Roman 12pt (PPKI Lampiran 16 butir 1)
  set text(
    font: _font,
    size: _sz-body,
    lang: "id",
  )

  // ── Paragraf ─────────────────────────────────────────────
  // • Jarak baris: 1 spasi (PPKI Lampiran 16 butir 5)
  // • Alinea pertama menjorok 1 cm dari batas kiri bidang tulisan (butir 6)
  // • Rata kanan-kiri / justified (butir 6)
  // • Tidak ada spasi ekstra antarparagraf
  set par(
    leading: _leading,
    spacing: _leading,
    first-line-indent: 1cm,
    justify: true,
  )

  // ── Penomoran Heading ─────────────────────────────────────
  // Level 1 (Bab)        → angka Romawi kapital, contoh: II
  // Level 2 (Subbab)     → angka Arab berpola 1.1, contoh: 2.1
  // Level 3 (Sub-subbab) → angka Arab berpola 1.1.1, contoh: 2.1.1
  // (PPKI Lampiran 16 butir 8 dan Lampiran 17)
  set heading(numbering: (..nums) => {
    let n = nums.pos()
    if n.len() == 1 {
      numbering("I", n.at(0))
    } else if n.len() == 2 {
      numbering("1.1", ..nums)
    } else if n.len() >= 3 {
      numbering("1.1.1", ..nums)
    }
  })

  // ── Tampilan Judul Bab (Level 1) ──────────────────────────
  // • Times New Roman 14pt, tebal (bold), huruf kapital semua
  // • Posisi: di tengah (centered)
  // • Setiap bab baru dimulai di halaman baru
  // • Jarak sebelum judul bab: before 6pt (PPKI aturan "spasi 1 dan before 6")
  // (PPKI Lampiran 16 butir 9 dan Lampiran 17)
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    set par(first-line-indent: 0pt, spacing: 0pt, leading: _leading)
    v(6pt)
    align(
      center,
      text(font: _font, size: _sz-bab, weight: "bold")[
        #if it.numbering != none {
          // Tampilkan nomor Romawi lalu spasi
          context counter(heading).display("I")
          h(1em)
        }
        #upper(it.body)
      ],
    )
    v(_leading)
  }

  // ── Tampilan Judul Subbab (Level 2) ───────────────────────
  // • Times New Roman 12pt, tebal (bold), kapital tiap kata
  // • Posisi: kiri (left-aligned)
  // • 2 spasi dari konten di atas, 1 spasi dari konten di bawah
  // (PPKI Lampiran 16 butir 10)
  show heading.where(level: 2): it => {
    set par(first-line-indent: 0pt, spacing: 0pt, leading: _leading)
    v(2 * _leading)
    text(font: _font, size: _sz-body, weight: "bold")[
      #if it.numbering != none {
        context counter(heading).display("1.1")
        h(0.75em)
      }
      #it.body
    ]
    v(_leading)
  }

  // ── Tampilan Judul Sub-subbab (Level 3) ───────────────────
  // • Times New Roman 12pt, TIDAK tebal (regular), kapital tiap kata
  // • Posisi: kiri (left-aligned)
  // • 1,5 spasi dari konten di atas, 1 spasi dari konten di bawah
  // (PPKI Lampiran 16 butir 11)
  show heading.where(level: 3): it => {
    set par(first-line-indent: 0pt, spacing: 0pt, leading: _leading)
    v(1.5 * _leading)
    text(font: _font, size: _sz-body, weight: "regular")[
      #if it.numbering != none {
        context counter(heading).display("1.1.1")
        h(0.75em)
      }
      #it.body
    ]
    v(_leading)
  }

  // ── Tabel ────────────────────────────────────────────────
  // • Caption/judul tabel di ATAS tabel (PPKI Bab VI butir 6.1)
  // • Hanya tiga garis horizontal; tidak ada garis vertikal
  // • Catatan kaki tabel: Times New Roman 10pt (PPKI 6.1.1d butir 7)
  //
  // Cara membuat tabel dengan format PPKI (contoh 3 garis horizontal):
  //   #figure(
  //     caption: [Judul tabel singkat],
  //     kind: table,
  //     table(
  //       columns: (auto, 1fr),
  //       table.hline(stroke: 0.75pt),       // ← garis atas
  //       [*Kolom 1*], [*Kolom 2*],
  //       table.hline(stroke: 0.75pt),       // ← garis bawah header
  //       [Data 1],    [Data 2],
  //       table.hline(stroke: 0.75pt),       // ← garis bawah tabel
  //     ),
  //   )
  show figure.where(kind: table): set figure.caption(position: top)
  set table(stroke: none) // garis diatur manual dengan table.hline()

  // ── Gambar ───────────────────────────────────────────────
  // • Caption/judul gambar di BAWAH gambar (PPKI Bab VI butir 6.2)
  show figure.where(kind: image): set figure.caption(position: bottom)

  // ── Mulai Konten ─────────────────────────────────────────
  body
}


// ─── Halaman Sampul ──────────────────────────────────────────

/// Membuat halaman sampul karya ilmiah.
/// Referensi: Lampiran 1b (skripsi), 1d (tesis), 1e (disertasi) PPKI.
///
/// Parameter:
///   judul         - Judul dalam HURUF KAPITAL, maks. 3 baris, ≤ 15 kata
///   nama          - Nama lengkap mahasiswa (nama akhir tidak disingkat)
///   nim           - NIM (ditampilkan di punggung sampul, bukan di muka)
///   program-studi - Nama program studi
///   departemen    - Nama departemen (boleh kosong)
///   fakultas      - Nama fakultas/sekolah
///   institusi     - Default: "INSTITUT PERTANIAN BOGOR"
///   kota          - Default: "BOGOR"
///   tahun         - Tahun lulus
///   logo          - Konten logo IPB (diameter 2,5 cm). Contoh:
///                    image("logo-ipb.png", height: 2.5cm)
///                   Jika dikosongkan, logo tidak ditampilkan.
///
/// Catatan: Halaman ini tidak memiliki nomor halaman.
/// Pengukuran vertikal berdasarkan Lampiran 1b PPKI:
///   ±5 cm dari atas kertas → judul
///   ±12 cm dari atas kertas → nama
///   ±18 cm dari atas kertas → logo
///   ±23,7 cm dari atas kertas → nama departemen/fakultas/institusi
#let halaman-sampul(
  judul: "",
  nama: "",
  nim: "",
  program-studi: "",
  departemen: "",
  kelas-paralel: "",
  nama-dosen: "",
  nama-asisten: "",
  fakultas: "",
  institusi: "INSTITUT PERTANIAN BOGOR",
  kota: "BOGOR",
  tahun: "",
  logo: none,
) = {
  set page(
    paper: "a4",
    margin: (left: 4cm, right: 3cm, top: 0pt, bottom: 0pt),
    numbering: none,
    header: none,
    footer: none,
  )
  set text(font: _font, size: _sz-bab)
  set par(leading: _leading, first-line-indent: 0pt, justify: false)
  // Posisi absolut mengikuti template DOTX: judul 5 cm, nama 12 cm,
  // logo 18 cm, dan blok institusi 23,7 cm dari atas kertas.
  let dept-line = if departemen != "" { "\n" + upper(departemen) } else { "" }
  let kelas-line = if kelas-paralel != "" { "\n" + upper(kelas-paralel) } else { "" }
  let dosen-line = if nama-dosen != "" { "\n" + upper(nama-dosen) } else { "" }

  place(top + center, dy: 5cm)[
    #text(weight: "bold")[#upper(judul)]
  ]

  place(top + center, dy: 12cm)[
    #text(weight: "bold")[#nama]
  ]

  if logo != none {
    place(top + center, dy: 18cm)[#logo]
  }

  place(top + center, dy: 23.7cm)[
    #text(weight: "bold")[
      #(
        upper(program-studi)
          + kelas-line
          + dosen-line
          + dept-line
          + "\n"
          + upper(fakultas)
          + "\n"
          + upper(institusi)
          + "\n"
          + upper(kota)
          + "\n"
          + tahun
      )
    ]
  ]

  // Kunci tinggi halaman agar konten berikutnya selalu mulai di halaman baru.
  box(height: 29.7cm, width: 100%)[ ]
}

/// Alias: halaman judul (salinan sampul, dicetak di kertas putih).
/// Parameter identik dengan halaman-sampul.
#let halaman-judul = halaman-sampul


// ─── Halaman Pernyataan dan Pelimpahan Hak Cipta ─────────────

/// Membuat halaman pernyataan keaslian dan pelimpahan hak cipta.
/// Referensi: Lampiran 3 PPKI.
///
/// Parameter:
///   nama        - Nama lengkap penulis
///   nim         - Nomor Induk Mahasiswa
///   judul       - Judul karya ilmiah (tanpa tanda petik)
///   jenis-karya - "laporan akhir" | "skripsi" | "tesis" | "disertasi"
///   tanggal     - Tempat dan tanggal tanda tangan, mis. "Bogor, Januari 2024"
#let halaman-pernyataan(
  nama: "",
  nim: "",
  judul: "",
  jenis-karya: "skripsi",
  tanggal: "",
) = {
  set par(first-line-indent: 0pt, justify: true, leading: _leading, spacing: _leading)
  set text(font: _font, size: _sz-body)

  align(center)[
    *#upper("PERNYATAAN MENGENAI " + jenis-karya + " DAN SUMBER INFORMASI")*
    *#upper("SERTA PELIMPAHAN HAK CIPTA")*
  ]

  v(1em)

  [
    Dengan ini saya menyatakan bahwa #jenis-karya dengan judul
    "#judul" adalah karya saya dengan arahan dari dosen pembimbing dan belum
    diajukan dalam bentuk apa pun kepada perguruan tinggi mana pun. Sumber
    informasi yang berasal atau dikutip dari karya yang diterbitkan maupun
    tidak diterbitkan dari penulis lain telah disebutkan dalam teks dan
    dicantumkan dalam Daftar Pustaka di bagian akhir #jenis-karya ini.
  ]

  v(_leading)

  [
    Dengan ini saya melimpahkan hak cipta dari karya tulis saya kepada
    Institut Pertanian Bogor.
  ]

  v(2em)

  align(right)[
    #tanggal
    #v(3em)
    #nama \
    NIM #nim
  ]
}


// ─── Halaman Abstrak (Indonesia) ─────────────────────────────

/// Membuat halaman Abstrak (bahasa Indonesia) untuk skripsi.
/// Referensi: Lampiran 4a dan 4b PPKI.
///
/// Parameter:
///   nama        - Nama mahasiswa ditulis KAPITAL
///   judul       - Judul karya ilmiah (bahasa Indonesia)
///   pembimbing  - Array nama pembimbing, mis. ("Ali", "Budi")
///   isi         - Narasi abstrak (maks. 200 kata, 1 paragraf)
///   kata-kunci  - Kata kunci dipisah koma, terurut abjad, maks. 5
///
/// Catatan: Ditulis 1 spasi, tidak ada before dan after (PPKI Lampiran 4b).
/// Halaman ini diberi nomor i tetapi nomor tidak dicetak.
#let abstrak(
  nama: "",
  judul: "",
  pembimbing: (),
  isi: [],
  kata-kunci: "",
) = {
  set par(
    leading: _leading,
    spacing: _leading,
    first-line-indent: 0pt,
    justify: true,
  )
  set text(font: _font, size: _sz-body)

  align(center)[*ABSTRAK*]

  v(0.5em)

  // Format nama pembimbing: dipisah "dan" jika lebih dari satu
  let db = if pembimbing.len() == 0 {
    ""
  } else if pembimbing.len() == 1 {
    upper(pembimbing.at(0))
  } else {
    pembimbing.slice(0, -1).map(upper).join(", ") + ", dan " + upper(pembimbing.last())
  }

  // Header abstrak: NAMA. Judul. Dibimbing oleh PEMBIMBING.
  [*#upper(nama).* #judul. Dibimbing oleh #db.]

  v(_leading)

  isi

  v(_leading)

  [*Kata kunci:* #kata-kunci]
}


// ─── Halaman Abstract (Inggris) ──────────────────────────────

/// Membuat halaman Abstract (bahasa Inggris) untuk skripsi.
/// Referensi: Lampiran 4a dan 4b PPKI.
///
/// Parameter:
///   nama        - Nama mahasiswa ditulis CAPITAL
///   judul       - Judul karya ilmiah (bahasa Inggris)
///   pembimbing  - Array nama pembimbing, mis. ("Ali", "Budi")
///   isi         - Narasi abstrak (maks. 200 kata, 1 paragraf)
///   keywords    - Keywords dipisah koma, alphabetical order, maks. 5
#let abstract-en(
  nama: "",
  judul: "",
  pembimbing: (),
  isi: [],
  keywords: "",
) = {
  set par(
    leading: _leading,
    spacing: _leading,
    first-line-indent: 0pt,
    justify: true,
  )
  set text(font: _font, size: _sz-body)

  align(center)[*ABSTRACT*]

  v(0.5em)

  let sv = if pembimbing.len() == 0 {
    ""
  } else if pembimbing.len() == 1 {
    upper(pembimbing.at(0))
  } else {
    pembimbing.slice(0, -1).map(upper).join(", ") + ", and " + upper(pembimbing.last())
  }

  [*#upper(nama).* #judul. Supervised by #sv.]

  v(_leading)

  isi

  v(_leading)

  [*Keywords:* #keywords]
}


// ─── Ringkasan dan Summary (Tesis / Disertasi) ───────────────

/// Membuat halaman Ringkasan (bahasa Indonesia) untuk tesis/disertasi.
/// Tidak lebih dari 2 halaman, ditulis 1 spasi dalam beberapa paragraf.
/// Referensi: Lampiran 5c dan 5d PPKI.
///
/// Parameter sama dengan abstrak().
#let ringkasan(
  nama: "",
  judul: "",
  pembimbing: (),
  isi: [],
  kata-kunci: "",
) = {
  set par(leading: _leading, spacing: _leading, first-line-indent: 0pt, justify: true)
  set text(font: _font, size: _sz-body)

  align(center)[*RINGKASAN*]

  v(0.5em)

  let db = if pembimbing.len() == 0 {
    ""
  } else if pembimbing.len() == 1 {
    upper(pembimbing.at(0))
  } else {
    pembimbing.slice(0, -1).map(upper).join(", ") + ", dan " + upper(pembimbing.last())
  }

  [*#upper(nama).* #judul. Dibimbing oleh #db.]

  v(_leading)
  isi
  v(_leading)

  [*Kata kunci:* #kata-kunci]
}

/// Membuat halaman Summary (bahasa Inggris) untuk tesis/disertasi.
/// Tidak lebih dari 2 halaman, ditulis 1 spasi dalam beberapa paragraf.
/// Referensi: Lampiran 5e PPKI.
#let summary(
  nama: "",
  judul: "",
  pembimbing: (),
  isi: [],
  keywords: "",
) = {
  set par(leading: _leading, spacing: _leading, first-line-indent: 0pt, justify: true)
  set text(font: _font, size: _sz-body)

  align(center)[*SUMMARY*]

  v(0.5em)

  let sv = if pembimbing.len() == 0 {
    ""
  } else if pembimbing.len() == 1 {
    upper(pembimbing.at(0))
  } else {
    pembimbing.slice(0, -1).map(upper).join(", ") + ", and " + upper(pembimbing.last())
  }

  [*#upper(nama).* #judul. Supervised by #sv.]

  v(_leading)
  isi
  v(_leading)

  [*Keywords:* #keywords]
}


// ─── Daftar Isi, Daftar Tabel, Daftar Gambar ─────────────────

/// Membuat halaman Daftar Isi otomatis (berdasarkan heading dalam naskah).
/// Referensi: Lampiran 11 dan 12 PPKI.
#let daftar-isi() = {
  pagebreak(weak: true)
  set par(first-line-indent: 0pt, leading: _leading, spacing: _leading)
  align(center)[
    #text(font: _font, size: _sz-bab, weight: "bold")[DAFTAR ISI]
  ]
  v(2 * _leading)
  show outline.entry: it => _toc-entry(it)
  outline(
    title: none,
    indent: 0pt,
  )
}

/// Membuat halaman Daftar Tabel otomatis.
/// Tampilkan jika jumlah tabel > 1 (PPKI Bab III 3.1.12).
#let daftar-tabel() = {
  pagebreak(weak: true)
  set par(first-line-indent: 0pt, leading: _leading, spacing: _leading)
  heading(level: 1, numbering: none, outlined: true)[DAFTAR TABEL]
  counter(heading).update((ch, ..rest) => (if ch > 0 { ch - 1 } else { 0 },))
  outline(
    title: none,
    target: figure.where(kind: table),
  )
}

/// Membuat halaman Daftar Gambar otomatis.
/// Tampilkan jika jumlah gambar > 1 (PPKI Bab III 3.1.12).
#let daftar-gambar() = {
  pagebreak(weak: true)
  set par(first-line-indent: 0pt, leading: _leading, spacing: _leading)
  heading(level: 1, numbering: none, outlined: true)[DAFTAR GAMBAR]
  counter(heading).update((ch, ..rest) => (if ch > 0 { ch - 1 } else { 0 },))
  outline(
    title: none,
    target: figure.where(kind: image),
  )
}

/// Membuat halaman Daftar Lampiran otomatis (opsional).
#let daftar-lampiran() = {
  pagebreak(weak: true)
  set par(first-line-indent: 0pt, leading: _leading, spacing: _leading)
  heading(level: 1, numbering: none, outlined: true)[DAFTAR LAMPIRAN]
  counter(heading).update((ch, ..rest) => (if ch > 0 { ch - 1 } else { 0 },))
  // Lampiran dibuat sebagai figure dengan kind: "lampiran"
  outline(
    title: none,
    target: figure.where(kind: "lampiran"),
  )
}


// ─── Daftar Pustaka ───────────────────────────────────────────

/// Membuat halaman Daftar Pustaka (halaman baru, tanpa nomor bab).
/// Masuk dalam Daftar Isi.
///
/// Aturan penulisan daftar pustaka (PPKI Bab VII):
///   • Nama penulis dibalik (nama belakang dahulu): Satria A.
///   • Urutan: Penulis. Tahun. Judul. Kota: Penerbit.
///   • Format "hanging indent" 1 cm (baris pertama rata kiri, baris selanjutnya
///     menjorok ke dalam)
///
/// Parameter:
///   bibfile - Path ke file .bib (mis. "reference.bib")
///   style   - Path ke file .csl atau nama style bawaan (mis. "ipb.csl")
///
/// Contoh:
///   #daftar-pustaka("reference.bib", style: "ipb.csl")

// Penulisan daftar pustaka manual
// #let daftar-pustaka(isi) = {
//   pagebreak(weak: true)
//   // Heading level 1 tanpa nomor bab, tetap masuk outline (Daftar Isi)
//   heading(level: 1, numbering: none, outlined: true)[DAFTAR PUSTAKA]
//   // Reset counter agar bab berikutnya tidak terganggu
//   counter(heading).update((ch, ..rest) => (if ch > 0 { ch - 1 } else { 0 },))
//   set par(
//     first-line-indent: 0pt,
//     hanging-indent:    1cm,    // setiap entri: baris kedua dst. menjorok 1 cm
//     leading:           _leading,
//     spacing:           _leading,
//     justify:           true,
//   )
//   isi
// }

// Penulisan daftar pustaka dengan BetterBibTex
#let daftar-pustaka(bibfile, style: "ipb.csl") = {
  pagebreak(weak: true)
  // Heading level 1 tanpa nomor bab, tetap masuk outline (Daftar Isi)
  heading(level: 1, numbering: none, outlined: true)[DAFTAR PUSTAKA]
  // Reset counter agar bab berikutnya tidak terganggu
  counter(heading).update((ch, ..rest) => (if ch > 0 { ch - 1 } else { 0 },))
  set par(
    first-line-indent: 0pt,
    hanging-indent: 1cm, // setiap entri: baris kedua dst. menjorok 1 cm
    leading: _leading,
    spacing: _leading,
    justify: true,
  )
  bibliography(bibfile, title: none, style: style)
}


// ─── Lampiran ─────────────────────────────────────────────────

/// Membuat halaman Lampiran (halaman baru, tanpa nomor bab).
/// Masuk dalam Daftar Isi.
///
/// Untuk membuat lampiran bernomor, gunakan figure dengan kind: "lampiran":
///   #figure(
///     kind:      "lampiran",
///     supplement: [Lampiran],
///     caption:   [Judul Lampiran 1],
///   )[ konten lampiran ]
#let lampiran(isi) = {
  pagebreak(weak: true)
  heading(level: 1, numbering: none, outlined: true)[LAMPIRAN]
  counter(heading).update((ch, ..rest) => (if ch > 0 { ch - 1 } else { 0 },))
  set par(leading: _leading, spacing: _leading, justify: true)
  isi
}


// ─── Riwayat Hidup ────────────────────────────────────────────

/// Membuat halaman Riwayat Hidup (halaman baru, maks. 1 halaman).
/// Tidak masuk dalam Daftar Isi (outlined: false).
/// Referensi: Lampiran 14a (laporan akhir/skripsi) dan 14b (tesis/disertasi) PPKI.
///
/// Contoh:
///   #riwayat-hidup[
///     Penulis dilahirkan di Bogor pada tanggal 1 Januari 2000 sebagai
///     anak pertama dari pasangan Bapak X dan Ibu Y. …
///   ]
#let riwayat-hidup(isi) = {
  pagebreak(weak: true)
  align(center)[
    #text(font: _font, size: _sz-bab, weight: "bold")[RIWAYAT HIDUP]
  ]
  v(_leading)
  set par(leading: _leading, spacing: _leading, first-line-indent: 1cm, justify: true)
  isi
}


// ─── Catatan Penggunaan Tambahan ──────────────────────────────
//
// KUTIPAN DALAM TEKS (PPKI Bab VII)
// ----------------------------------
// Kutipan singkat (≤ 3 baris): langsung di dalam teks
//   "… merantau bagi orang Minangkabau …" (Naim 1984:284).
//
// Kutipan panjang (blok): huruf lebih kecil, dipisak dari teks
//   #block(
//     inset: (left: 1cm, right: 1cm),
//   )[
//     #set text(size: 10pt)
//     Teks kutipan panjang …
//   ]
//
// PENOMORAN DALAM SUBBAB (PPKI Lampiran 16 butir 8)
// --------------------------------------------------
// Jika ada rincian di dalam subbab, gunakan huruf: a, b, c
//   a) Poin pertama
//   b) Poin kedua
//
// Paragraf bertingkat (indentasi bertambah 0,5 cm dari paragraf di atasnya):
//   #pad(left: 0.5cm)[
//     Paragraf bertingkat …
//   ]
//
// UKURAN HURUF CATATAN KAKI TABEL (PPKI 6.1.1d butir 7)
// -------------------------------------------------------
// Times New Roman 10pt atau Arial 9pt:
//   #set text(size: 10pt) [Keterangan: xxx]