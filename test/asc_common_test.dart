import 'package:asc_common/asc_common.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AscLocalizations.parseXml', () {
    test('đọc đúng name/value từ file strings.xml kiểu Android', () {
      const xml = '''
<resources>
  <string name="hello">Xin chào</string>
  <string name="bye">Tạm biệt</string>
</resources>
''';
      final strings = AscLocalizations.parseXml(xml);
      expect(strings['hello'], 'Xin chào');
      expect(strings['bye'], 'Tạm biệt');
    });

    test('tr() trả về chính key khi chưa có bản dịch', () {
      final loc = AscLocalizations({'hello': 'Xin chào'});
      expect(loc.tr('hello'), 'Xin chào');
      expect(loc.tr('missing_key'), 'missing_key');
    });

    test('trArgs() thay {0}, {1}... theo đúng thứ tự', () {
      final loc = AscLocalizations({'greet': 'Chào {0}, bạn có {1} tin nhắn'});
      expect(loc.trArgs('greet', ['An', 3]), 'Chào An, bạn có 3 tin nhắn');
    });
  });

  group('AdLoadState', () {
    test('các nhánh sealed class phân biệt đúng qua switch', () {
      String describe(AdLoadState s) => switch (s) {
        AdIdle() => 'idle',
        AdLoading() => 'loading',
        AdLoaded() => 'loaded',
        AdFailed(:final error) => 'failed:$error',
        AdShown() => 'shown',
      };
      expect(describe(const AdIdle()), 'idle');
      expect(describe(const AdFailed('timeout')), 'failed:timeout');
    });
  });

  group('AscConsentStatus', () {
    test('các nhánh sealed class phân biệt đúng qua switch', () {
      bool needsForm(AscConsentStatus s) => switch (s) {
        AscConsentRequired() => true,
        AscConsentUnknown() ||
        AscConsentNotRequired() ||
        AscConsentObtained() => false,
      };
      expect(needsForm(const AscConsentRequired()), true);
      expect(needsForm(const AscConsentObtained()), false);
    });
  });

  group('AscAdFrequencyTracker', () {
    test('cho hiện quảng cáo lần đầu, chặn ngay sau khi vừa hiện', () {
      final tracker = AscAdFrequencyTracker(
        minInterval: const Duration(minutes: 1),
      );
      expect(tracker.canShow, true);
      tracker.markShown();
      expect(tracker.canShow, false);
    });
  });
}
