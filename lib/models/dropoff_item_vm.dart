class DropOffItemVm {
  DropOffItemVm();

  String masterItemId;
  String description = '';
  int limit = 1;

  String toString() {
    return "id:$masterItemId $description $limit";
  }
}
