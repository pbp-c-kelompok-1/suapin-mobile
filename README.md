# Suap.in Mobile

Aplikasi mobile berbasis Flutter untuk pelacakan jejak karbon (*carbon footprint*) makanan harian di Indonesia, terintegrasi langsung dengan platform web Suap.in melalui Django REST Framework.

Aplikasi ini merupakan bagian dari Proyek Akhir Semester (PAS) mata kuliah Pemrograman Berbasis Platform (CSGE602022), Fakultas Ilmu Komputer, Universitas Indonesia, Semester Gasal 2026/2027.

---

## 👥 Anggota Kelompok (PBP C - Kelompok 1)

| Nama Lengkap | NPM | Akun GitHub |
|---|:---:|:---:|
| Syahid Arkan Fashihurrohman | 2506632936 | [@syahidarkan](https://github.com/syahidarkan) |
| Muhammad Iqbal | 2506657075 | [@labqimm](https://github.com/labqimm) |
| Nasywa Namira Suhendro | 2506532196 | [@nasywanamira](https://github.com/nasywanamira) |
| Annisa Saskya Aulia | 2506537915 | [@annisasaskya3-art](https://github.com/annisasaskya3-art) |
| Muhammad Ziad Ayyash | 2506594364 | [@ziad-ayyash](https://github.com/ziad-ayyash) |

---

## 📖 Deskripsi Aplikasi

**Suap.in** adalah aplikasi pelacak jejak karbon makanan pertama yang dirancang khusus untuk konteks makanan Indonesia. Makanan menyumbang porsi signifikan dari emisi karbon global, namun masyarakat umumnya kesulitan mengetahui besaran dampak lingkungan dari menu yang dikonsumsi sehari-hari. 

Suap.in hadir menjawab kendala tersebut dengan memanfaatkan kebiasaan memotret makanan sebelum makan. Lewat aplikasi mobile ini, pengguna dapat:
1. Memindai foto makanan secara cepat dan memperoleh estimasi emisi karbon (gram CO₂) per porsi.
2. Memantau batas anggaran karbon harian (*daily carbon budget*) agar pola konsumsi tetap ramah lingkungan.
3. Mengembangkan avatar interaktif, mempertahankan *daily streak*, mengumpulkan XP, dan menaikkan level.
4. Bersaing secara positif dengan teman sekampus melalui Leaderboard mingguan dan ajang kompetisi antaruniversitas (*Campus War*).
5. Menyelesaikan misi ramah lingkungan serta membuka episode komik edukatif mengenai rantai pasok makanan.

Seluruh data transaksi dan rekam jejak pengguna tersimpan secara terpusat di server backend Django (PWS) dan disajikan secara asinkron ke aplikasi mobile Flutter.

---

## 🧩 Daftar Modul & Pembagian Kerja

Setiap anggota kelompok bertanggung jawab mengembangkan modul masing-masing secara *end-to-end* (menyediakan endpoint Django REST Framework di backend web serta membangun tampilan antarmuka dan interaksi di aplikasi mobile Flutter):

### 1. Autentikasi, Profil & Avatar (`authentication`)
- **Penanggung Jawab (PIC):** Syahid Arkan Fashihurrohman
- **Cakupan Fitur:**
  - Pendaftaran akun baru (*Register*) dan masuk sistem (*Login*) berbasis sesi/token.
  - Halaman profil pengguna yang memuat riwayat aktivitas, statistik emisi, dan status avatar.
  - Sistem avatar dinamis yang kondisinya merefleksikan kepedulian lingkungan pengguna berdasarkan capaian streak dan skor karbon.

### 2. FoodScan AI & Kalkulator Karbon (`scanner`)
- **Penanggung Jawab (PIC):** Syahid Arkan Fashihurrohman
- **Cakupan Fitur:**
  - Antarmuka pengambilan atau pengunggahan foto makanan dari galeri/kamera ponsel.
  - Visualisasi hasil deteksi item makanan beserta analogi emisi karbon (misal: setara sekian kilometer motor).
  - Penyimpanan log harian makanan (*daily food log*) dan pemantauan sisa anggaran karbon harian (*carbon budget tracker*).

### 3. Gamifikasi, XP, Level & Badge (`gamification`)
- **Penanggung Jawab (PIC):** Muhammad Ziad Ayyash
- **Cakupan Fitur:**
  - Dashboard ringkasan progres harian pengguna.
  - Pelacak *daily streak* beserta mekanisme *streak freeze* untuk menjaga konsistensi pencatatan.
  - Sistem akumulasi XP dan kenaikan tier level pengguna.
  - Galeri koleksi lencana (*badges*) ramah lingkungan yang berhasil diraih.

### 4. Leaderboard, Teman & Campus War (`social`)
- **Penanggung Jawab (PIC):** Muhammad Iqbal
- **Cakupan Fitur:**
  - Papan peringkat emisi terendah (*Leaderboard*) dengan filter lingkup: lingkaran pertemanan, kampus, dan nasional.
  - Ajang kompetisi jejak karbon antarkampus (*Campus War*).
  - Manajemen pertemanan (menemukan sesama pengguna, mengirim, serta menerima permintaan pertemanan).

### 5. Tantangan Harian & Laporan Mingguan (`challenge`)
- **Penanggung Jawab (PIC):** Annisa Saskya Aulia
- **Cakupan Fitur:**
  - Daftar tantangan harian (*Daily Quests*) otomatis berbasis kebiasaan makan pengguna.
  - Rekap laporan emisi mingguan (*Weekly Carbon Report*) yang memuat perbandingan performa minggu lalu dan proyeksi tahunan.
  - Pusat notifikasi terkait pengingat streak, hasil tantangan, dan perkembangan peringkat.

### 6. Story Progression & Duel 1v1 (`story`)
- **Penanggung Jawab (PIC):** Nasywa Namira Suhendro
- **Cakupan Fitur:**
  - Pembaca episode komik digital edukatif (*Story Progression*) yang terbuka bertahap seiring kenaikan level.
  - Klaim penghargaan atas pencapaian tertentu (*Milestone Rewards*).
  - Fitur tantangan tanding emisi satu lawan satu (*1v1 Friend Challenge*).

---

## 👤 Peran (Aktor) Pengguna Aplikasi

Aplikasi Suap.in memiliki dua peran utama pengguna:

1. **Guest (Tamu / Pengguna Belum Masuk)**
   - Dapat menjelajahi halaman pengenalan aplikasi (landing page) dan mempelajari informasi fitur serta edukasi jejak karbon.
   - Dapat mengakses antarmuka masuk (*Login*) dan pendaftaran akun baru (*Register*).

2. **Member (Mahasiswa / Pengguna Terdaftar)**
   - Dapat mengakses seluruh fitur utama aplikasi: memindai makanan, mencatat log harian, mengelola avatar, mengklaim XP, mengikuti tantangan harian, melihat komik cerita, dan berkompetisi di leaderboard teman serta antarkampus.

---

## 🔄 Alur Pengintegrasian Data (Flutter ↔ Web Django REST Framework)

Integrasi data antara aplikasi mobile Flutter dan backend web Django (PWS) berjalan menggunakan pola arsitektur Client-Server berbasis RESTful API:

```
[ Aplikasi Mobile Flutter ]
       │
       │  1. HTTP Request (GET / POST / PUT / DELETE)
       │     Header: Cookie Session / Token + JSON Body
       ▼
[ Django REST Framework (PWS Server) ]
       │
       │  2. Serializer Validasi & ORM Query
       ▼
[ Database PostgreSQL (PWS) ]
       │
       │  3. Data tersimpan / ter-update
       ▼
[ Django REST Framework Response ]
       │
       │  4. HTTP Response JSON (Status Code + Payload)
       ▼
[ Aplikasi Mobile Flutter ]
       │  5. Deserialisasi JSON ke Dart Model
       │  6. Pembaruan State & Tampilan Widget UI
```

### Rincian Tahapan Alur:
1. **Permintaan Data (HTTP Request):**
   Aplikasi Flutter mengirimkan request asinkron (`http` package / `pbp_django_auth`) ke endpoint web service Django yang di-host di PWS.
2. **Autentikasi & Keamanan:**
   Setiap interaksi pengguna yang memerlukan hak akses mengirimkan token atau cookie sesi yang tervalidasi pada backend Django untuk memastikan data pengguna aman dan terisolasi.
3. **Pemrosesan Backend (Django REST Framework):**
   Endpoint Django menerima request, memvalidasi data menggunakan *Serializers*, kemudian melakukan manipulasi data pada basis data PostgreSQL via Django ORM.
4. **Respon JSON (HTTP Response):**
   Backend mengembalikan data dalam format JSON standar beserta status HTTP (misalnya `200 OK`, `201 Created`, atau pesan error validasi `400 Bad Request`).
5. **Deserialisasi & Tampilan Antarmuka:**
   Aplikasi Flutter mengolah (*parse*) string respons JSON menjadi objek model Dart yang *type-safe*, kemudian memperbarui *state* aplikasi sehingga antarmuka widget (Material 3) menampilkan data terbaru secara instan kepada pengguna.

---

## 🎨 Tautan Desain Figma (UI/UX)

Rancangan antarmuka aplikasi Suap.in dapat diakses melalui tautan berikut:  
🔗 **[Desain Figma Suap.in](https://www.figma.com/design/mszscHVDXDGjBYLDDYCKmH/Suap.in-Lo-Fi?node-id=0-1&p=f&t=GTGm14cmdJaEurVJ-0)**

---

## 📦 Tautan Repositori & Deployment

- **Repositori Situs Web (Django PTS):** [https://github.com/pbp-c-kelompok-1/suap.in](https://github.com/pbp-c-kelompok-1/suap.in)
- **Deployment Web PWS:** [https://syahid-arkan-suapin.pws.cs.ui.ac.id/](https://syahid-arkan-suapin.pws.cs.ui.ac.id/)
- **Tautan Berkas APK:** *(Akan diperbarui pada Checkpoint 1 & rilis akhir via GitHub Release / Bitrise)*

---

*Disusun untuk memenuhi Tugas Kelompok Proyek Akhir Semester (PAS) — Pemrograman Berbasis Platform Gasal 2026/2027.*
