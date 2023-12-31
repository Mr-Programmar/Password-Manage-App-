import 'entries.dart';
import 'entry.dart';

class SortedEntries<T extends Entry<T>> extends Entries<T> {
  final List<T> _entrySet;

  @override
  Iterable<T> get entries => _entrySet;

  SortedEntries({Map<String, T>? entries})
      : _entrySet = entries?.values.toList() ?? [],
        super(entries: entries) {
    sort();
  }

  void sort() => _entrySet.sort((a, b) => a.compareTo(b));

  @override
  void setEntry(T entry) {
    if (!_entrySet.contains(entry)) {
      _entrySet.add(entry);
      sort();
    }
    super.setEntry(entry);
  }

  @override
  void removeEntry(String key) {
    super.removeEntry(key);
    _entrySet.remove(getEntry(key)!);
  }
}
