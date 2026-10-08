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

}
