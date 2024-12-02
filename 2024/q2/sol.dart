
import 'dart:io';

void main() {
  final file = File('in.txt');
  final lines = file.readAsLinesSync();

  int count = 0;

  for (final line in lines) {
    final parts = line.split(' ');
    bool? ascending = null;
    int? prev = null;

    bool safe = true;

    for (final part in parts) {
      final num = int.parse(part);
      if (prev != null) {
        if (ascending == null) {
          ascending = num > prev;
        }

        if (ascending && num < prev || !ascending && num > prev || (num - prev).abs() > 3 || (num - prev).abs() < 1) {
          safe = false;
          break;
        }
      }
      prev = num;
    }

    if (safe) {
      count++;
    }
  }

  print(count);
}
