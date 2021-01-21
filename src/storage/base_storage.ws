
// any storage used in RER inherits from this class.
abstract class RER_BaseStorage extends IModStorageData {
  public function save(): bool {
    return GetModStorage().save(this);
  }
}
