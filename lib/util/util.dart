class Util {
  static void swapElementsInList<T>(List<T> list, int first, int second) {
    assert (list.length > 1);
    assert (list.length > first);
    assert (list.length > second);
    assert (first < second);
    T temp = list.removeAt(first);
    list.insert(first, list.removeAt(second - 1));
    list.insert(second, temp);
  }
}