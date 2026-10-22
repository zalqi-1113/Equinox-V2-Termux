# Equinox Terminal V2

> Lingkungan terminal berbasis **Bash murni** untuk **Termux (Android)** — juga jalan di Linux biasa.
> Satu perintah `eqx` berisi 90+ perintah bawaan plus beberapa modul opsional: info sistem,
> monitor live, jaringan, manajemen berkas, catatan & todo, keamanan, manajer paket, tema,
> prompt cantik, plugin, simulasi tampilan terminal lain, dashboard performa, chat AI lewat
> API Anda sendiri, dan wizard untuk bikin "modul" tampilan sendiri.

```
 ___    ___    _   _   ___   _  _    ___   __  __
| __|  / _ \  | | | | |_ _| | \| |  / _ \  \ \/ /
| _|  | (_) | | |_| |  | |  | .` | | (_) |  >  <
|___|  \__\_\  \___/  |___| |_|\_|  \___/  /_/\_\
                                                  V2 "Zenith"
```

> **Prinsip desain V2:** semua yang *terdengar* seperti kemampuan sistem (override thermal,
> OS lain, "AI bawaan", dsb.) di Equinox **jujur tentang batasnya**. Fitur kosmetik (simulasi
> tampilan, efek visual) jelas berlabel kosmetik; fitur yang butuh root dan tidak tersedia di
> Termux standar tidak dipura-purakan berhasil; absolute-ai tidak pernah menyimpan API key Anda.

---

## Daftar isi

1. [Instalasi cepat](#instalasi-cepat)
2. [Fitur utama](#fitur-utama)
3. [Cara pakai](#cara-pakai)
4. [Daftar perintah](#daftar-perintah)
5. [Tema & gaya prompt](#tema--gaya-prompt)
6. [Konfigurasi](#konfigurasi)
7. [Plugin](#plugin)
8. [Modul xxq](#modul-xxq)
9. [fallenAngel (reconnaissance & audit keamanan legal)](#fallenangel-reconnaissance--audit-keamanan-legal)
10. [simulation-terminal (simulasi tampilan OS lain)](#simulation-terminal-simulasi-tampilan-os-lain)
11. [Boost (dashboard performa & pembersih)](#boost-dashboard-performa--pembersih)
12. [absolute-ai (chat lewat API Anda sendiri)](#absolute-ai-chat-lewat-api-anda-sendiri)
13. [change-repo (ganti skin terminal)](#change-repo-ganti-skin-terminal)
14. [fake-module (bikin modul tampilan sendiri)](#fake-module-bikin-modul-tampilan-sendiri)
15. [Opsi Installer](#opsi-installer)
16. [Autostart](#autostart)
17. [Memperbarui & mencopot](#memperbarui--mencopot)
18. [Struktur repo & data](#struktur-repo--data)
19. [Pemecahan masalah](#pemecahan-masalah)
20. [FAQ](#faq)
21. [Kontribusi](#kontribusi)

---

## Instalasi cepat

Salin dan tempel di Termux:

```bash
pkg update && pkg install git -y && git clone https://github.com/zalqi-1113/Equinox-Linux-Terminal-.git && cd Equinox-Linux-Terminal- && chmod +x equinox-v2-installer.sh && ./equinox-v2-installer.sh
```

Setelah selesai, jalankan:

```bash
equinox        # masuk ke shell interaktif Equinox
eqx help       # lihat semua perintah
```

Installer akan otomatis:

1. Mendeteksi lingkungan (Termux / Linux, package manager, lokasi pemasangan)
2. Memeriksa versi Bash, ruang disk, hak tulis, dan koneksi internet
3. Memasang dependensi yang kurang (`curl`, `gawk`, `procps`, `ncurses-utils`, dll.)
4. Mencari `Equinox-Core-System.bash` (lokal, atau mengunduh dari GitHub bila tidak
   ada) - plus `ai_modelsetting.sh` bila tersedia (opsional, hanya untuk absolute-ai;
   instalasi tetap berjalan normal tanpa berkas itu)
5. Memvalidasi sintaks inti, mencadangkan instalasi lama, lalu menyalin berkas
6. Membuat perintah `equinox` dan `eqx`, metadata, serta konfigurasi awal
7. (Opsional) mengaktifkan autostart
8. Menjalankan uji verifikasi (sintaks, peluncur, *selftest*)

> **Pasang lengkap sekaligus** (nano, jq, tree, openssl, termux-api, git, zip, unzip + autostart):
> `./equinox-v2-installer.sh --yes --full --autostart`

Modul-modul tambahan (fallenAngel, simulation-terminal, boost, absolute-ai) **tidak otomatis
aktif** - pasang satu per satu sesuai kebutuhan lewat `eqx install <nama>` setelah Equinox
terpasang. Lihat bagian masing-masing di bawah.

---

## Fitur utama

| Kategori | Isi |
|---|---|
| **Shell interaktif** | Prompt dua baris dengan cabang git & kode error, riwayat persisten, alias, fungsi bantu, tab-completion untuk `eqx` |
| **Sistem** | `info` (gaya neofetch), `sys`, `mem`, `battery`, `storage`, `proc`, `monitor` live, `clock` besar, `doctor` |
| **Jaringan** | IP lokal/publik, tes koneksi, tes kecepatan, ping, cuaca, header HTTP, DNS, cek port, server HTTP, unduh dengan resume, SSH |
| **Berkas** | `usage`, `big`, `tree`, `extract`/`pack` (zip, tar.gz, 7z, ...), `backup`, deteksi duplikat, tempat sampah aman, bookmark folder, rename massal |
| **Produktivitas** | Catatan, todo berprioritas, timer, stopwatch, pomodoro, statistik riwayat |
| **Keamanan** | Generator password + estimasi entropi, hash/verify, enkripsi AES-256, kunci SSH |
| **Paket** | Pembungkus `pkg`/`apt`/`dnf`/`pacman`/`apk`/`zypper` + bundle siap pasang (`dev`, `net`, `term`, ...) |
| **Termux** | Izin storage, extra-keys preset, Termux:API (notifikasi, getar, clipboard, senter) |
| **Kustomisasi** | 8 tema warna, 6 gaya prompt, alias kustom, sistem plugin, banner teks sendiri (`xxq banner-custom`) |
| **Hiburan** | Matrix rain, cowsay, rainbow, dadu, koin, tebak angka, kutipan, `xxq hollywood`, `xxq typer` |
| **xxq** | Lapisan perintah ekstra khusus sesi Equinox (tidak ada di Termux biasa) — lihat [Modul xxq](#modul-xxq) |
| **fallenAngel** | Modul opsional reconnaissance & audit keamanan legal — lihat [bagian terkait](#fallenangel-reconnaissance--audit-keamanan-legal) |
| **simulation-terminal** | Simulasi tampilan Ubuntu/Debian/Kali/BlackArch/Termux, 100% kosmetik — lihat [bagian terkait](#simulation-terminal-simulasi-tampilan-os-lain) |
| **Boost** | Dashboard performa & pembersih sistem dengan data & aksi nyata — lihat [bagian terkait](#boost-dashboard-performa--pembersih) |
| **absolute-ai** | Chat lewat API Anda sendiri, 4 alias, tanpa menyimpan API key — lihat [bagian terkait](#absolute-ai-chat-lewat-api-anda-sendiri) |
| **change-repo & fake-module** | Ganti skin prompt, atau bikin "modul" `eqx install` sendiri — lihat [change-repo](#change-repo-ganti-skin-terminal) / [fake-module](#fake-module-bikin-modul-tampilan-sendiri) |

Desain: **tanpa dependensi aneh** — hanya Bash 4.2+ dan utilitas standar (coreutils, curl, awk, sed, grep).

---

## Cara pakai

### Dua mode

```bash
equinox            # tanpa argumen  -> shell interaktif (prompt, alias, banner)
eqx info           # dengan argumen -> perintah tunggal (mode CLI)
```

Di dalam shell Equinox, `eqx` adalah fungsi, jadi cukup:

```bash
eqx help               # semua perintah
eqx help theme         # bantuan satu perintah
eqx menu               # menu interaktif bernomor
```

### Contoh sehari-hari

```bash
eqx info                          # ringkasan sistem + logo
eqx monitor                       # RAM/disk/baterai/proses live (tekan q)
eqx note "beli kuota"             # catatan cepat
eqx todo add "kirim laporan !tinggi"
eqx todo done 1
eqx timer 25m "fokus selesai"
eqx pass 24                       # password 24 karakter
eqx big ~ 20                      # 20 file terbesar di HOME
eqx backup create ~/proyek        # arsip .tar.gz ke ~/.equinox/backups
eqx trash put file.txt            # hapus aman (bisa dipulihkan)
eqx bm add proyek ~/proyek && eqx bm go proyek
eqx weather Jakarta
eqx speed 20                      # tes unduh 20 MB
eqx tools install dev             # python, nodejs, clang, make, cmake, git
```

### Alias & fungsi bawaan di shell interaktif

| Perintah | Fungsi |
|---|---|
| `ll`, `la`, `lt` | daftar berkas (detail / semua / urut waktu) |
| `..`, `...`, `up 3` | naik direktori |
| `mkcd nama` | buat folder lalu masuk |
| `bak file` | salin dengan stempel waktu |
| `psg nama` | cari proses |
| `hg kata` | cari di riwayat |
| `cheat tar` | contekan perintah (cheat.sh) |
| `extract arsip` | ekstrak otomatis berdasarkan ekstensi |
| `myip`, `ports`, `reload` | jalan pintas `eqx ip`, `eqx ports`, `eqx reload` |

---

## Daftar perintah

### Sistem
`info` · `sys` · `mem` · `battery` · `storage` · `proc [n] [mem|cpu]` · `monitor [detik]` · `clock` · `uptime` · `doctor` · `env` · `watch <detik> <perintah>`

### Jaringan
`ip [geo]` · `net` · `speed [MB]` · `ping [host] [n]` · `weather [kota] [short]` · `headers <url>` · `dns <domain> [tipe]` · `ports` · `portcheck <host> <port>` · `wifi` · `serve [port] [dir]` · `download <url> [nama]` · `sshd start|stop|status`

### Berkas
`usage [dir]` · `big [dir] [n]` · `ff <pola>` · `sr <teks>` · `tree [dir] [dalam]` · `extract` · `pack` · `backup [create|list|restore|prune]` · `dups [dir]` · `trash [put|list|restore|empty]` · `bm [add|go|list|del]` · `rename 's/a/b/' files` · `calc 'ekspresi'`

### Produktivitas
`note [add|list|show|del|search|edit|clear]` · `todo [add|list|done|undo|del|clear]` · `timer <durasi>` · `stopwatch` · `pomodoro [kerja] [istirahat] [siklus]` · `hist [top|search|stats|clear]`

### Keamanan & alat data
`pass [panjang] [jumlah] [--simple|--pin]` · `hash [-a algo] <file>|-s <teks>` · `verify <file> <hash>` · `crypt enc|dec <file>` · `sshkey create|show` · `b64 enc|dec` · `url enc|dec` · `uuid` · `rand` · `epoch` · `json` · `count` · `colors`

### Paket
`pkg install|remove|search|upgrade|list|info|clean|count` · `tools list|install <bundle>|status` · `git [status|log|user]`

### Termux
`termux storage|reload|keys [default|dev|mini]|api|notify|vibrate|toast|torch|clip`

### Kustomisasi
`theme list|set|preview` · `prompt list|set|user` · `alias list|add|del` · `config list|get|set|reset|edit|path` · `plugin list|enable|disable|new|dir` · `banner [teks]` · `tips` · `xxq <modul>` · `change-repo [1-4|reset|status|menu]` · `fake-module new|list|show|remove`

### Hiburan
`quote` · `cow [teks]` · `dice [n] [sisi]` · `coin` · `guess [maks]` · `rainbow [teks]` · `matrix` · `xxq hollywood` · `xxq typer`

### Pemeliharaan
`menu` · `update` · `reload` · `version` · `selftest` · `log [n|clear|path]` · `uninstall` · `exit` (keluar dari simulasi, bukan dari shell)

### Modul opsional (`eqx install <nama>`)
`fallenAngel` · `simulation-terminal` · `boost` · `absolute-ai` — lihat bagian masing-masing di bawah.

**Alias singkat:** `fetch`/`neofetch`/`i` → `info`, `n` → `note`, `t` → `todo`, `p` → `pkg`, `top` → `monitor`, `pw` → `pass`, `cfg` → `config`, `fa` → `fallenangel`, `repo` → `change-repo`, `fm` → `fake-module`.

---

## Tema & gaya prompt

**Tema** (`eqx theme set <nama>`): `equinox` · `aurora` · `ocean` · `sunset` · `matrix` · `dracula` · `nord` · `mono`

**Gaya prompt** (`eqx prompt set <gaya>`):

```
equinox   ╭─ equinox in ~/proyek ⎇ main            14:02
          ╰─❯
minimal   proyek ⎇ main ❯
classic   user@host:~/proyek$
hacker    ┌──(equinox@host)-[~/proyek]
          └─$
lean      14:02 equinox proyek ⎇ main ❯
arrow     ~/proyek ⎇ main ➜
```

Panah berubah merah dan menampilkan `✘kode` jika perintah terakhir gagal.
Jika font terminal tidak mendukung Unicode: `eqx config set UNICODE off`.

---

## Konfigurasi

File: `~/.equinox/equinox.conf` (format `KUNCI="nilai"`). Ubah lewat `eqx config set KUNCI nilai`, lalu `eqx reload`.

| Kunci | Default | Keterangan |
|---|---|---|
| `THEME` | `equinox` | tema warna |
| `PROMPT_STYLE` | `equinox` | gaya prompt |
| `PROMPT_USER` | *(kosong)* | nama di prompt (kosong = `equinox` di Termux, nama user di Linux) |
| `UNICODE` | `auto` | `auto` / `on` / `off` |
| `BANNER` | `on` | tampilkan logo saat shell dibuka |
| `TIPS` | `on` | tips acak di banner |
| `GIT_PROMPT` | `on` | tampilkan cabang git |
| `GIT_DIRTY` | `off` | tandai `*` jika ada perubahan (lebih lambat di repo besar) |
| `HIST_SIZE` | `5000` | ukuran riwayat |
| `LOAD_BASHRC` | `off` | ikut memuat `~/.bashrc` saat masuk shell Equinox |
| `WEATHER_CITY` | *(kosong)* | kota default untuk `eqx weather` |
| `EDITOR_CMD` | *(kosong)* | editor untuk `note edit` / `config edit` |
| `CONFIRM_DANGEROUS` | `on` | konfirmasi aksi berbahaya |
| `UPDATE_BRANCH` | `main` | branch untuk `eqx update` |
| `BANNER_CUSTOM` | *(kosong)* | teks banner kustom untuk `eqx info` (diatur lewat `xxq banner-custom`) |
| `HIBP_API_KEY` | *(kosong)* | API key Have I Been Pwned untuk `fa osint checkemail` |

Alias pribadi: `eqx alias add gs 'git status'` (disimpan di `~/.equinox/aliases.sh`).

---

## Plugin

Plugin adalah file `.sh` di `~/.equinox/plugins/`. Perintah plugin = fungsi `eqx_cmd_<nama>`:

```bash
eqx plugin new halo        # buat template
eqx reload
eqx halo dunia             # -> "Halo dari plugin halo! Argumen: dunia"
eqx plugin disable halo    # nonaktifkan (file jadi halo.sh.off)
```

Isi template:

```bash
eqx_cmd_halo() {
  eqx_ok "Halo dari plugin halo! Argumen: $*"
}
eqx_reg halo plugin "Plugin buatan sendiri: halo" "eqx halo [argumen]"
```

Fungsi bantu yang bisa dipakai plugin: `eqx_info`, `eqx_ok`, `eqx_warn`, `eqx_err`, `eqx_kv`, `eqx_bar`, `eqx_confirm`, `eqx_ask`, `eqx_run` (spinner), `eqx_have`, `eqx_human`, `eqx_cfg_get`.
> Hanya pasang plugin dari sumber yang Anda percaya — plugin dijalankan sebagai kode shell biasa.

---

## Modul xxq

`xxq` adalah lapisan perintah "ekstra" yang **hanya ada di dalam sesi Equinox** — di Termux
polos (sebelum masuk `equinox`), perintah `xxq` tidak dikenal. Ini sengaja jadi pembeda:
begitu Anda masuk Equinox, `xxq` tersedia sebagai perintah tersendiri.

```bash
xxq                         # daftar modul yang tersedia
xxq hollywood                # efek layar "hacker" dua panel ala film (q untuk keluar)
xxq typer                    # efek "hacker typer" komedi - tekan tombol apa saja
xxq banner-custom set "Toko Sejahtera"   # ganti teks banner di `eqx info`
xxq banner-custom preview    # lihat hasilnya
xxq banner-custom clear      # kembali ke logo Equinox bawaan
```

Catatan:
- `hollywood` dan `typer` **murni visual/komedi** — tidak membaca, mengubah, atau
  mengirim apa pun; aman dipakai untuk demo atau sekadar iseng.
- `banner-custom` dipakai juga oleh `eqx info` dan banner pembuka shell. Jika `figlet`
  terpasang (`eqx pkg install figlet`), teksnya dirender sebagai ASCII art besar;
  jika tidak, ditampilkan dalam kotak sederhana memakai warna tema aktif.
- `xxq <modul>` juga bisa dipanggil lewat `eqx xxq <modul>` di mode CLI non-interaktif.

---

## fallenAngel (reconnaissance & audit keamanan legal)

`eqx install fallenAngel` memasang modul keamanan **opsional** berisi perangkat
reconnaissance & audit yang legal. Modul ini **sengaja tidak berisi alat eksploitasi**
(tidak ada SQL injection, brute force login, pembuat payload, dsb.) — fokusnya murni pada
hal-hal yang sah: memasang lingkungan belajar (Kali), memindai jaringan milik sendiri,
mengaudit header keamanan situs sendiri, dan mengecek kebocoran data milik sendiri.

```bash
eqx install fallenAngel      # pasang modul (akan menampilkan & meminta persetujuan aturan pakai)
eqx fallenangel help         # atau: fa help   (alias pendek tersedia setelah terpasang)
```

### Submodul

| Perintah | Keterangan |
|---|---|
| `fa kali install\|enter\|status\|remove` | pasang/masuk **Kali Linux** lewat `proot-distro` — cara resmi Termux, bukan kode eksploitasi |
| `fa scan <target> [quick\|full\|service\|ping]` | pembungkus **nmap** (pemindaian port/servis informasional, bukan exploit) |
| `fa webaudit <url>` | audit **pasif/read-only**: header keamanan HTTP, sertifikat TLS, robots.txt/sitemap — situs **milik Anda sendiri** |
| `fa osint checkpass [sandi]` | cek apakah kata sandi pernah bocor, via API k-anonymity pwnedpasswords.com (sandi asli **tidak pernah dikirim**) |
| `fa osint checkemail <email>` | cek kebocoran akun lewat API Have I Been Pwned (butuh API key sendiri) |
| `fa authorize add\|remove\|list <target>` | daftarkan target yang **sudah Anda konfirmasi milik/izin Anda**, supaya `scan` tidak bertanya ulang tiap kali |
| `fa report new <target>\|list\|show <file>` | jalankan `webaudit`/`scan` lalu simpan hasilnya sebagai laporan teks di `~/.equinox/fallenangel-reports/` |
| `fa log [jumlah]` | lihat riwayat aktivitas modul ini (dicatat otomatis di log Equinox) |

### Aturan pakai (ditegakkan di kode, bukan cuma imbauan)

- `scan` **selalu** meminta konfirmasi eksplisit sebelum memindai target yang belum ada
  di daftar `authorize`, dan tidak bisa dilewati lewat pengaturan `CONFIRM_DANGEROUS`.
- Gunakan `scan` dan `webaudit` **hanya** pada sistem milik Anda sendiri, atau yang Anda
  miliki izin tertulis eksplisit untuk mengujinya. Memindai/menguji sistem orang lain
  tanpa izin dapat melanggar hukum (UU ITE, Computer Misuse Act, CFAA, dsb. — tergantung
  yurisdiksi Anda).
- `osint checkpass` tanpa argumen akan meminta kata sandi lewat prompt **tersembunyi**
  (tidak tercetak, tidak masuk riwayat perintah). Memberi sandi langsung sebagai argumen
  tetap didukung untuk scripting, tapi akan tercatat di riwayat shell — hindari jika bisa.
- Semua pemindaian dicatat ke `~/.equinox/logs/equinox.log` (lihat lewat `fa log`) sebagai
  jejak audit untuk Anda sendiri.

---

## simulation-terminal (simulasi tampilan OS lain)

```bash
eqx install simulation-terminal     # pasang modul, langsung tampilkan menu pilihan
eqx simulation menu                 # buka menu pilihan kapan saja
eqx simulation start kali           # langsung pilih tanpa menu (ubuntu|debian|kali|blackarch|termux)
eqx simulation status               # lihat simulasi yang sedang aktif
eqx exit                            # keluar dari simulasi, kembali ke Equinox normal
```

**100% kosmetik**: hanya mengganti prompt (`PS1`) dan banner pembuka. Semua perintah yang Anda
jalankan tetap Equinox/Bash asli - tidak ada OS lain yang benar-benar terpasang atau berjalan.
Status simulasi disimpan dan **bertahan lintas sesi** sampai Anda `eqx exit` secara eksplisit.

Untuk Kali Linux **sungguhan** (rootfs nyata lewat `proot-distro` resmi Termux, lengkap dengan
tools aslinya), pakai `eqx fallenangel kali install` - lihat bagian fallenAngel di atas.

`eqx exit` **hanya** mengelola simulasi dan **tidak pernah** menutup shell Equinox; untuk keluar
dari shell sepenuhnya tetap pakai perintah bawaan `exit`.

---

## Boost (dashboard performa & pembersih)

```bash
eqx install boost      # pasang modul, langsung tampilkan dashboard + menu
eqx boost               # dashboard performa (RAM, disk, baterai, suhu - data asli perangkat)
eqx boost clean         # bersihkan cache Equinox/pkg/pip/npm
eqx boost procs         # cek & hentikan proses milik Anda yang nyangkut (aman, tak pernah proses sistem)
eqx boost thermal       # suhu perangkat (baca saja, lewat sensor /sys/class/thermal)
eqx boost nice <pid> [level]   # ubah prioritas proses milik Anda (renice)
eqx boost speed         # tes kecepatan unduh (sama seperti `eqx speed`)
```

**Jujur soal batasan:** tanpa akses root, Android/Termux standar **tidak mengizinkan** aplikasi
mengubah CPU governor, membongkar pembatas termal pabrik, atau memanipulasi jaringan tingkat
kernel. Boost **tidak** berpura-pura melakukan hal itu - semua angka di dashboard adalah data
asli perangkat, dan setiap aksi di menu benar-benar dijalankan (atau melapor jujur kalau gagal/
tidak didukung), bukan sekadar teks animasi.

---

## absolute-ai (chat lewat API Anda sendiri)

```bash
eqx install absolute-ai
```

absolute-ai **tidak menyertakan AI apa pun** - ini wadah ringan untuk mengobrol lewat API milik
Anda sendiri (OpenAI, Anthropic, atau server yang kompatibel dengan salah satu format itu),
dibungkus 4 alias:

| Alias | Nama tampilan |
|---|---|
| `mno` | Mono V1 |
| `mvx` | Mono VX |
| `chb` | Chatbox 5 |
| `qdx` | Qodex |

Langkah pakai:

```bash
# 1) Atur satu slot - provider, endpoint, model, dan NAMA variabel env untuk API key
xxq absolute-ai-config mno openai https://api.openai.com/v1/chat/completions gpt-4o-mini MNO_API_KEY

# 2) Simpan API key ANDA SENDIRI sebagai env var (Equinox tidak pernah menyimpannya)
export MNO_API_KEY="sk-xxxxxxxx"      # taruh di ~/.bashrc agar permanen

# 3) Ngobrol
xxq absolute-ai-mno Prompt=halo, apa kabar?

# Lihat status & konfigurasi jujur semua slot (provider/endpoint/model asli, bukan samaran)
xxq absolute-ai-information
```

Provider yang didukung: `openai` (format `/chat/completions`, juga cocok untuk banyak server
self-hosted/OpenAI-compatible seperti Ollama, LM Studio, vLLM) dan `anthropic` (formformat
`/v1/messages`). Berkas `ai_modelsetting.sh` bersifat **opsional** - kalau tidak ada di folder
instalasi, perintah `xxq absolute-ai-*` cuma melapor modul belum ditemukan, sisanya tetap normal.

---

## change-repo (ganti skin terminal)

```bash
eqx change-repo          # menu pilihan
eqx change-repo 1        # langsung pilih lewat nomor
eqx change-repo reset    # kembali ke tampilan Equinox normal
eqx change-repo status
```

Pilihan tampilan:

| # | Nama |
|---|---|
| 1 | Linux Equinox-vXF-1-0-0 |
| 2 | Termux-repo-mirror |
| 3 | Linux terminal by domainesia |
| 4 | windows-cmd-terminal |

**Penting:** ini **bukan** `termux-change-repo` - tidak mengganti mirror/repositori paket APT
sungguhan. Ini cuma skin prompt yang lebih ringan dari `simulation-terminal` (tanpa banner masuk
penuh), dan saling eksklusif dengannya - mengaktifkan salah satu otomatis menonaktifkan yang lain.

---

## fake-module (bikin modul tampilan sendiri)

Wizard untuk membuat "modul" `eqx install <nama>` milik Anda sendiri - banner teks plus sampai 6
baris info. **Murni tampilan, tersimpan lokal** di `~/.equinox/fake-modules/` - "Publish" tidak
mengunggah apa pun ke internet.

```bash
eqx fake-module new
```

Wizard akan menanyakan:

1. **Nama** - label yang ditampilkan (mis. "Fake Test Module")
2. **Installer code / slug** - identitas teknis untuk `eqx install <slug>` (mis. `fakeTest`)
3. **Akses**: `private` (hanya jalan kalau diketik persis namanya) atau `public` (ikut muncul
   di daftar `eqx install` tanpa argumen)
4. **Teks banner**
5. Sampai **6 baris info** (`label` lalu `nilai`, kosongkan label untuk selesai lebih awal)
6. Konfirmasi **Publish**

Setelah dipublish:

```bash
eqx install fakeTest          # menampilkan banner + info yang Anda buat
eqx fake-module list          # semua fake-module Anda (termasuk yang private)
eqx fake-module show fakeTest # pratinjau tanpa lewat alur 'install'
eqx fake-module remove fakeTest
```

---

## Opsi Installer

```text
./equinox-v2-installer.sh [opsi]

  -y, --yes           setuju otomatis memasang dependensi
      --full          pasang juga nano, jq, tree, openssl, termux-api, git, zip, unzip
      --autostart     buka Equinox otomatis saat shell dibuka
      --no-autostart  jangan tanya autostart
      --update        perbarui inti saja (konfigurasi dipertahankan)
      --uninstall     copot Equinox   (+ --purge hapus data ~/.equinox)
      --check         periksa kesiapan sistem tanpa mengubah apa pun
      --no-deps       lewati pemasangan dependensi
      --offline       jangan unduh dari GitHub
      --download      paksa unduh inti terbaru dari GitHub
      --prefix DIR    pasang ke DIR (bin/ dan lib/equinox/)
  -v, --version       versi installer
  -h, --help          bantuan
```

Lokasi pemasangan otomatis: Termux → `$PREFIX`, Linux root → `/usr/local`, Linux biasa → `~/.local`.

---

## Autostart

Aktifkan lewat `./equinox-v2-installer.sh --autostart` (atau jawab *ya* saat ditanya). Installer menambahkan blok bertanda ke `~/.bashrc` (dengan backup otomatis). Perlindungan bawaan:

- Tidak masuk ke dalam dirinya sendiri (variabel `EQUINOX_ACTIVE`).
- Jika Equinox berhenti dalam < 3 detik (mis. error), Anda tetap mendapat shell biasa — **tidak akan terkunci**.
- Lewati sekali: `EQX_SKIP=1 bash`
- Matikan permanen tanpa edit file: `touch ~/.equinox/noautostart`

---

## Memperbarui & mencopot

```bash
eqx update                        # tarik dari GitHub lalu pasang ulang
# atau manual:
cd Equinox-Terminal-V2 && git pull && ./equinox-v2-installer.sh --update
```

Instalasi lama otomatis dicadangkan di `~/.equinox/backups/install-<waktu>/`.

```bash
eqx uninstall                     # atau: ./equinox-v2-installer.sh --uninstall
./equinox-v2-installer.sh --uninstall --purge   # sekaligus hapus semua data pribadi
```

---

## Struktur repo & data

```text
Equinox-Linux-Terminal-/        # folder hasil clone (nama proyek/rilis: Equinox-Terminal-V2)
├── equinox-v2-installer.sh    # pemasang (juga dipakai untuk update & uninstall)
├── Equinox-Core-System.bash   # inti Equinox (shell interaktif + semua perintah eqx)
├── ai_modelsetting.sh         # modul absolute-ai (opsional - disource otomatis oleh inti)
└── Readme-v2.md

# setelah terpasang (Termux: $PREFIX = /data/data/com.termux/files/usr)
$PREFIX/bin/equinox          # peluncur
$PREFIX/bin/eqx              # jalan pintas
$PREFIX/lib/equinox/         # Equinox-Core-System.bash, ai_modelsetting.sh, installer.sh, VERSION, README.md

~/.equinox/
├── equinox.conf             # konfigurasi
├── aliases.sh               # alias kustom
├── bookmarks.tsv            # bookmark folder
├── history                  # riwayat perintah
├── install.meta             # info instalasi
├── ai-models.tsv            # konfigurasi 4 slot absolute-ai (TANPA API key - itu selalu di env var Anda)
├── fake-modules/            # *.conf - modul buatan Anda lewat `eqx fake-module new`
├── fallenangel-reports/     # laporan dari `eqx fallenangel report new`
├── .fallenangel_targets     # daftar target yang Anda authorize untuk fallenAngel scan
├── .simulation / .repo_skin # state simulation-terminal / change-repo yang sedang aktif (kalau ada)
├── notes/                   # notes.tsv, todo.tsv
├── plugins/                 # plugin *.sh
├── backups/                 # arsip backup + cadangan instalasi
├── trash/                   # tempat sampah aman
└── logs/                    # equinox.log, install-*.log
```

---

## Pemecahan masalah

**`bad interpreter` / `permission denied` saat `./equinox-v2-installer.sh`**
Jalankan dengan `bash equinox-v2-installer.sh`. Jika masih gagal dan file pernah diedit di Windows, ubah baris baru: `sed -i 's/\r$//' equinox-v2-installer.sh Equinox-Core-System.bash ai_modelsetting.sh`.

**`Perintah wajib belum ada` / gagal memasang paket**
Segarkan mirror Termux lalu ulangi: `termux-change-repo`, kemudian `pkg update -y` dan `./equinox-v2-installer.sh`.

**`equinox: command not found`**
Buka sesi Termux baru (atau `hash -r`). Cek `echo $PATH` memuat `$PREFIX/bin`.

**Karakter prompt berantakan (kotak/tanda tanya)**
Font tidak mendukung Unicode: `eqx config set UNICODE off && eqx reload`.

**Info baterai / notifikasi kosong**
Pasang paket `termux-api` **dan** aplikasi *Termux:API* (dari F-Droid), lalu `eqx termux api`.

**`eqx ports` / `eqx ip` kosong**
Android modern (10+) membatasi akses `/proc/net` dan `ip` bagi aplikasi biasa. Ini batasan sistem, bukan galat Equinox. `eqx ip` tetap menampilkan IP publik jika ada internet.

**`eqx update` gagal**
Cek koneksi. Jika branch default repo bukan `main`: `eqx config set UPDATE_BRANCH master`.

**Equinox bermasalah dan ingin kembali ke shell biasa**
`EQX_SKIP=1 bash` atau `touch ~/.equinox/noautostart`, lalu `./equinox-v2-installer.sh --uninstall`.

Diagnosis cepat: `eqx doctor`, `eqx selftest`, dan log di `~/.equinox/logs/`.

---

## FAQ

**Apakah butuh root?** Tidak. Seluruhnya berjalan sebagai pengguna Termux biasa.

**Apakah mengganti shell bawaan Termux?** Tidak. Equinox adalah Bash dengan `--rcfile` sendiri; `~/.bashrc` Anda tidak diubah kecuali Anda memilih autostart (dengan backup).

**Apakah bisa dipakai di Linux desktop/server?** Ya. Installer mendeteksi `apt`, `dnf`, `pacman`, `apk`, dan `zypper`. Untuk akun biasa, pemasangan ke `~/.local`.

**Data apa yang dikirim ke internet?** Tidak ada telemetri. Koneksi hanya terjadi saat Anda menjalankan perintah jaringan (`weather`, `ip`, `speed`, `update`, dll.) dan ke layanan publik yang tercantum di kode.

**Di mana saya bisa membaca kodenya?** Logika utama ada di `Equinox-Core-System.bash` (terbagi dalam seksi bernomor berkomentar Bahasa Indonesia); modul chat AI ada terpisah di `ai_modelsetting.sh`.

---

## Kontribusi

Issue dan pull request disambut di <https://github.com/zalqi-1113/Equinox-Linux-Terminal->.
Sebelum mengirim perubahan: `bash -n Equinox-Core-System.bash ai_modelsetting.sh equinox-v2-installer.sh` dan `eqx selftest` harus lulus.

Dibuat oleh **zalqi-1113**.
