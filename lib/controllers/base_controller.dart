/// A base class for Controllers if you wish to separate UI logic from State Management
/// purely, or this can be an abstract class that Providers extend if you want
/// to enforce a specific structure.
abstract class BaseController {
  void dispose();
}
