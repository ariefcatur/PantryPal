//
//  README.md
//  PantryPall
//
//  Created by Arief Catur on 19/08/25.
//

# PantryPal (iOS, SwiftUI + SwiftData)
Aplikasi sederhana untuk mencatat stok dapur dan mengingatkan tanggal kedaluwarsa.

## Fitur
- Tambah item: nama, kategori, jumlah, lokasi, tanggal kedaluwarsa
- Filter: Hampir Expired (≤3 hari) & Expired
- Notifikasi H-3 dan H-1
- Pencarian cepat
- Widget ringkas (jumlah item near-expiry)

## Tech
- iOS 17+, SwiftUI, SwiftData
- UserNotifications, WidgetKit, AppIntents

## Setup
1. Buka `PantryPal.xcodeproj` / `.xcworkspace`
2. Pilih target **PantryPal** → **Signing & Capabilities** → atur Team & Bundle ID unik
3. Run di Simulator / device

## Catatan Pengembangan
- Pastikan **scheme** di-share: Xcode → Scheme → Manage Schemes… → centang **Shared** (perlu untuk CI)
- Notifikasi: app akan minta izin saat pertama run

## Roadmap
- [ ] Impor/ekspor CSV
- [ ] iCloud sync (CloudKit)
- [ ] Ikon kategori & quick actions

## Lisensi
MIT – lihat [LICENSE](LICENSE).
