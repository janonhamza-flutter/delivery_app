import 'package:delivery_app/features/history/presentation/widgets/history_status_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('History status helper', () {
    test('returns distinct labels and colors for active delivery statuses', () {
      final accepted = getHistoryStatusInfo('accepted');
      final onTheWay = getHistoryStatusInfo('on_the_way');
      final arrived = getHistoryStatusInfo('arrived');
      final delivered = getHistoryStatusInfo('delivered');
      final cancelled = getHistoryStatusInfo('cancelled');

      expect(accepted.label, 'Accepted');
      expect(onTheWay.label, 'On The Way');
      expect(arrived.label, 'Arrived');
      expect(delivered.label, 'Delivered');
      expect(cancelled.label, 'Cancelled');

      expect(accepted.color, isNot(equals(onTheWay.color)));
      expect(onTheWay.color, isNot(equals(arrived.color)));
      expect(arrived.color, isNot(equals(delivered.color)));
      expect(delivered.color, isNot(equals(cancelled.color)));
    });
  });
}
