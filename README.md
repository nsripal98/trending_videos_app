# 📱 TrendVault — Trending Videos Aggregator

> Discover what's trending across Instagram, X (Twitter), Facebook & YouTube — filtered by your location, from city level to nationwide.

![Flutter](https://img.shields.io/badge/Flutter-3.19-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0-blue?logo=dart)
![Android](https://img.shields.io/badge/Android-5.0%2B-green?logo=android)
![CI/CD](https://img.shields.io/github/actions/workflow/status/YOUR_USERNAME/trendvault/build.yml?label=CI%2FCD)

---

## ✨ Features

| Feature | Description |
|---|---|
| 🔥 **Multi-Platform Trending** | Pulls trending videos from Instagram, X, Facebook, YouTube, TikTok |
| 📍 **Location-Based Filtering** | Filter by Country → State → District → City |
| 🏙️ **City-Level Trends** | See what's trending specifically in Hyderabad, Mumbai, Delhi, etc. |
| #️⃣ **Trending Hashtags** | Live hashtag tracking with growth rate (e.g. `#HyderabadElections +342%`) |
| 💡 **AI Content Insights** | For each trending video, get: summary, key topics, 5 content ideas for creators |
| 📊 **Creator Analytics** | Platform distribution, category breakdown, engagement estimates |
| 🔍 **Search & Filter** | Search by title, hashtag, creator; filter by platform & category |
| 📋 **One-Tap Copy** | Copy hashtags or all suggested hashtags to clipboard instantly |
| 🔗 **Open Original** | Opens the video directly on the source platform |

---

## 📸 Screens

```
├── Home (Trending Feed)     — All trending videos, filterable
├── Topics                   — Trending hashtags ranked by growth
├── Creator Insights         — Analytics + AI content ideas
└── Location Picker          — GPS or manual state/district selection
```

---

## 🏗️ Architecture

```
lib/
├── main.dart                    # App entry + bottom nav
├── constants/
│   └── app_constants.dart       # Theme, colors
├── models/
│   └── trending_video.dart      # Data models
├── providers/
│   ├── trending_provider.dart   # State management (videos, filters)
│   └── location_provider.dart   # Location state
├── screens/
│   ├── home_screen.dart         # Main feed
│   ├── video_detail_screen.dart # Video detail + AI insights
│   ├── topics_screen.dart       # Trending hashtags
│   ├── analytics_screen.dart    # Creator analytics
│   └── location_screen.dart     # Location picker
├── services/
│   └── mock_data_service.dart   # Data layer (swap for real API)
└── widgets/
    └── video_card.dart          # Reusable video card
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter 3.19+ ([install guide](https://docs.flutter.dev/get-started/install))
- Android Studio or VS Code
- Android device or emulator (API 21+)

### Run locally
```bash
git clone https://github.com/YOUR_USERNAME/trendvault.git
cd trendvault
flutter pub get
flutter run
```

### Build APK manually
```bash
# Debug APK
flutter build apk --debug

# Release APK (universal)
flutter build apk --release

# Split APKs per ABI (smaller size)
flutter build apk --release --split-per-abi
```

---

## 🔄 CI/CD — Auto APK Build

Every push to `main` builds a **debug APK** automatically via GitHub Actions.

To trigger a **release build + GitHub Release**:
```bash
git tag v1.0.0
git push origin v1.0.0
```

This will:
1. Run tests & lint
2. Build release APK
3. Create a GitHub Release with the APK attached

### GitHub Secrets needed for signed release
| Secret | Description |
|---|---|
| `KEYSTORE_BASE64` | Base64-encoded `.jks` keystore file |
| `KEY_ALIAS` | Key alias inside keystore |
| `KEY_PASSWORD` | Key password |
| `STORE_PASSWORD` | Keystore password |

Generate a keystore:
```bash
keytool -genkey -v -keystore trendvault-release.jks \
  -alias trendvault -keyalg RSA -keysize 2048 -validity 10000

# Then encode it:
base64 trendvault-release.jks | pbcopy   # macOS
base64 trendvault-release.jks            # Linux (copy output)
```

---

## 🗺️ Location Features

The app supports filtering at 4 levels:

```
🌍 India (Country)
  └── 🗺️ Telangana (State)
        └── 📍 Hyderabad (District)
              └── 🏙️ Hyderabad City
```

**Example:** When Hyderabad has municipal elections, videos with `#HyderabadElections` or `#GHMC` appear at the top when the user is filtering by Hyderabad.

---

## 🔌 Connecting Real APIs

The app is architected so `mock_data_service.dart` can be swapped for real API calls:

| Platform | API / Method |
|---|---|
| YouTube | YouTube Data API v3 — `videos.list` with `chart=mostPopular` |
| Instagram | Meta Graph API — trending reels by region |
| X (Twitter) | Twitter API v2 — `GET /2/trends/by/woeid` |
| Facebook | Meta Graph API — trending videos |
| TikTok | TikTok Research API — trending hashtags |

Replace `MockDataService.generateTrendingVideos()` with your API service.

---

## 📦 Key Dependencies

| Package | Purpose |
|---|---|
| `provider` | State management |
| `geolocator` | GPS location detection |
| `geocoding` | Reverse geocoding (lat/lng → city name) |
| `cached_network_image` | Efficient image loading |
| `url_launcher` | Open videos on platforms |
| `timeago` | Relative timestamps |
| `fl_chart` | Analytics charts |
| `share_plus` | Share videos |

---

## 📋 Roadmap

- [ ] Real API integrations (YouTube, Instagram, X)
- [ ] Push notifications for trending spikes
- [ ] Saved/bookmarked videos
- [ ] Content calendar integration
- [ ] Cross-platform: iOS support
- [ ] Regional language support (Telugu, Hindi, Tamil)
- [ ] Dark/Light theme toggle

---

## 🤝 Contributing

1. Fork the repo
2. Create feature branch: `git checkout -b feature/my-feature`
3. Commit: `git commit -m 'Add my feature'`
4. Push: `git push origin feature/my-feature`
5. Open a Pull Request

---

## 📄 License

MIT License — see [LICENSE](LICENSE)
