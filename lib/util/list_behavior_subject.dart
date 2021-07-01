import 'package:rxdart/rxdart.dart';

typedef ListModifier<T> = List<T> Function(List<T> list);

class ListBehaviorSubject<T> {
  final BehaviorSubject<List<T>> _listBs =
      BehaviorSubject<List<T>>.seeded([]);

  Observable<List<T>> get stream {
    return _listBs.stream;
  }

  List<T> _list = [];

  void modify(ListModifier<T> modifyFn) {
    var modifiedList = modifyFn(List.from(_list));
    _list = modifiedList;
    _listBs.value = _list;
  }
}