
/// Represents a pickup point displayed on the items screen.
class PickupPointVm {
  String id;
  String description;
  bool isConfirmed = false;

  PickupPointVm();

  PickupPointVm.fromDescription(this.description) {
    id = description.hashCode.toString();
  }

  String toString() {
    return '<$description: $isConfirmed>';
  }
}