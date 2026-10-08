# asc_common

Shared internal Flutter package của ASC Tech Soft — dùng chung cho nhiều app
(vai trò tương đương `bacha_common` bên Bachasoft, nhưng viết lại theo công
nghệ hiện đại hơn: **không GetX, không Riverpod, không flutter_screenutil**,
Dart 3 sealed class/pattern matching). Firebase + quảng cáo ở package `dsp_base`.

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

## Prefs (`lib/src/prefs/`)

`AscPrefs` + `AscPrefKey<T>` — đọc/ghi `SharedPreferences` theo khoá có kiểu,
tránh gõ nhầm string key hoặc đọc sai kiểu.

## Permission (`lib/src/permissions/`)

`AscPermissions` — bọc `permission_handler`, tự mở Settings khi bị từ chối
vĩnh viễn.

## Device / Connectivity (`lib/src/device/`, `lib/src/connectivity/`)

- `AscDeviceInfo` — thông tin thiết bị gọn, chung field cho Android/iOS.
- `AscConnectivity` — `onChanged` (Stream), `isOnline()`; thuần Dart, không
  phụ thuộc state management.

## Logging (`lib/src/logging/`)

`AscLogger` — bọc gói `logger`, có `onLog` để nối sang Crashlytics làm
breadcrumb.

## In-app review (`lib/src/review/`)

`AscReview` — bọc gói chính thức `in_app_review`, thay cho dialog 5 sao tự
chế của bản cũ.

## Dependency đáng chú ý

`permission_handler`, `shared_preferences`, `connectivity_plus`,
`device_info_plus`, `in_app_review`, `xml`, `logger`.

**Không có**: `get` (GetX), `flutter_screenutil` — cố tình bỏ, xem phần đầu
file này.

---

Tóm: shared infra layer — UI primitives,
localization XML, prefs/permission/device/connectivity/logging/review có
kiểu. Mọi app của ASC Tech Soft pull chung package qua Git dependency:

```yaml
dependencies:
  asc_common:
    git:
      url: https://github.com/asctechsoft/asc_common.git
      ref: main
```
