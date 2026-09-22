# asc_common

Shared internal Flutter package của ASC Tech Soft — dùng chung cho nhiều app
(vai trò tương đương `bacha_common` bên Bachasoft, nhưng viết lại theo công
nghệ hiện đại hơn: **không GetX, không flutter_screenutil**, dùng Riverpod +
Dart 3 sealed class/pattern matching).

## UI primitives (`lib/src/ui/`)

| File | Mô tả |
|---|---|
| `AppText` | Text widget chuẩn, ăn theo `Theme`/`DefaultTextStyle` của app gọi |
| `AppTextAutoResize` | `AppText` tự thu nhỏ cỡ chữ vừa khung chứa (dùng `FittedBox`, không cần thư viện ngoài) |
| `AppBox` | Bọc `Container` gọn tay hơn (padding/margin/màu/bo góc) |
| `AppRow` / `AppColumn` | `Row`/`Column` mặc định `mainAxisSize: min` |
| `AppIcon` / `AppSpacer` / `AppDivider` | UI primitives nhỏ |

## Localization (`lib/src/localization/`)

Vẫn dùng file XML kiểu Android `values-*/strings.xml` để giữ nguyên quy
trình dịch thuật 60+ ngôn ngữ hiện có — chỉ đổi cách nạp: `AscLocalizations`
+ `AscLocalizationsDelegate` là `LocalizationsDelegate` **chuẩn Flutter**,
gắn vào `MaterialApp.localizationsDelegates`, thay vì tự parse rải rác ngoài
vòng đời Flutter như bản cũ.

## Ads (`lib/src/ads/`)

Wrapper `google_mobile_ads`:

- `AscBannerAdView`, `AscNativeAdView` — widget tự tải/dispose theo vòng đời.
- `AscInterstitialAdService`, `AscRewardedAdService`, `AscAppOpenAdService` —
  service tự quản tải trước/hiện/tải lại, trạng thái là `AdLoadState`
  (`sealed class`: `AdIdle`/`AdLoading`/`AdLoaded`/`AdFailed`/`AdShown`) thay
  vì `GetxController` + biến rời rạc.
- `AscAdPreloadService` — gom cả ba loại full-screen ad, tải trước một lượt
  lúc khởi động.
- `AscAdFrequencyTracker` — giới hạn tần suất hiện quảng cáo.
- `AscTestAdIds` — ID test chính thức của Google, chỉ dùng lúc dev.

## GDPR / UMP (`lib/src/gdpr/`)

`AscGdprNotifier` — Riverpod `AsyncNotifier<AscConsentStatus>` bọc luồng UMP
(`ConsentInformation`/`ConsentForm`). `AscConsentStatus` là `sealed class`
(`Unknown`/`NotRequired`/`Required`/`Obtained`) — nơi dùng `switch` đủ nhánh
thay vì so sánh chuỗi/enum rời rạc.

## Firebase utils (`lib/src/firebase/`)

- `AscCrashlytics` — gắn bắt lỗi Flutter + lỗi async chưa bắt, log breadcrumb.
- `AscAnalytics` — log event qua `AscAnalyticsEvent` (type-safe hơn string tự do).
- `AscRemoteConfig` + `ascRemoteConfigProvider` — app tự truyền `defaults`,
  package **không hardcode key/project nào**.

## Prefs (`lib/src/prefs/`)

`AscPrefs` + `AscPrefKey<T>` — đọc/ghi `SharedPreferences` theo khoá có kiểu,
tránh gõ nhầm string key hoặc đọc sai kiểu.

## Permission (`lib/src/permissions/`)

`AscPermissions` — bọc `permission_handler`, tự mở Settings khi bị từ chối
vĩnh viễn.

## Device / Connectivity (`lib/src/device/`, `lib/src/connectivity/`)

- `AscDeviceInfo` — thông tin thiết bị gọn, chung field cho Android/iOS.
- `ascConnectivityProvider`, `ascIsOnlineProvider` — trạng thái mạng qua
  Riverpod `StreamProvider`.

## Logging (`lib/src/logging/`)

`AscLogger` — bọc gói `logger`, có `onLog` để nối sang Crashlytics làm
breadcrumb.

## In-app review (`lib/src/review/`)

`AscReview` — bọc gói chính thức `in_app_review`, thay cho dialog 5 sao tự
chế của bản cũ.

## Bootstrap (`lib/src/init/`)

`AscCommon.bootstrap(...)` — entry point khởi động **duy nhất**: nhận
`FirebaseOptions` + `remoteConfigDefaults` từ app gọi, tự
`Firebase.initializeApp`, gắn Crashlytics, fetch Remote Config, init Mobile
Ads SDK (nếu `initAds: true`). Không tự chạy luồng GDPR (cần
`ProviderContainer` thật, gọi `ascGdprProvider` sau khi `ProviderScope` đã
dựng xong) và không tự gọi `runApp`/dựng `ProviderScope` — app vẫn tự chủ UI
của mình.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final result = await AscCommon.bootstrap(
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
    remoteConfigDefaults: {'some_flag': false},
    initAds: true,
  );
  runApp(
    ProviderScope(
      overrides: [ascRemoteConfigProvider.overrideWithValue(result.remoteConfig)],
      child: const MyApp(),
    ),
  );
}
```

## Dependency đáng chú ý

`firebase_core`, `firebase_crashlytics`, `firebase_analytics`,
`firebase_remote_config`, `google_mobile_ads`, `flutter_riverpod`,
`permission_handler`, `shared_preferences`, `connectivity_plus`,
`device_info_plus`, `in_app_review`, `xml`, `logger`.

**Không có**: `get` (GetX), `flutter_screenutil` — cố tình bỏ, xem phần đầu
file này.

---

Tóm: shared infra layer — UI primitives, ads, GDPR, Firebase utils,
localization XML, prefs/permission/device/connectivity/logging/review có
kiểu. Mọi app của ASC Tech Soft pull chung package qua Git dependency:

```yaml
dependencies:
  asc_common:
    git:
      url: https://github.com/asctechsoft/asc_common.git
      ref: main
```
