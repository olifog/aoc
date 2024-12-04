
import 'dart:io';

void main() {
  final file = File('in.q2.txt');
  final lines = file.readAsLinesSync();

  int count = 0;

  for (final line in lines) {
    final parts = line.split(' ');

    bool foundSafe = false;

    for (var droppedIndex = 0; droppedIndex < parts.length; droppedIndex++) {
      bool? ascending = null;
      int? prev = null;
      bool safe = true;

      for (var i = 0; i < parts.length; i++) {
        if (i == droppedIndex) {
          continue;
        }

        final num = int.parse(parts[i]);
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
        foundSafe = true;
        break;
      }
    }

    if (foundSafe) {
      count++;
    }
  }

  print(count);
}
