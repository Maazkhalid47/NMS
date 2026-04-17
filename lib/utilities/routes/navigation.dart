class NavigationRepository {
  int currentIndex = 0;

  void updateIndex(int index) {
    currentIndex = index;
  }

  int getIndex() {
    return currentIndex;
  }
}