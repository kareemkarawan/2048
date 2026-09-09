import Cocoa
import FlutterMacOS
import window_manager_plus

@main
class AppDelegate: FlutterAppDelegate {

  override func applicationDidFinishLaunching(
    _ notification: Notification
  ) {
    super.applicationDidFinishLaunching(notification)

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(windowBecameKey(_:)),
      name: NSWindow.didBecomeKeyNotification,
      object: nil
    )
  }

  @objc private func windowBecameKey(_ notification: Notification) {
    guard let window = notification.object as? WindowManagerPlusFlutterWindow else {
      return
    }

    window.level = .floating

    window.collectionBehavior = [
      .canJoinAllSpaces,
      .fullScreenAuxiliary
    ]
  }

  override func applicationShouldTerminateAfterLastWindowClosed(
    _ sender: NSApplication
  ) -> Bool {
    return NSApp.windows.filter({
      $0 is MainFlutterWindow || $0 is WindowManagerPlusFlutterWindow
    }).count == 1
  }

  override func applicationSupportsSecureRestorableState(
    _ app: NSApplication
  ) -> Bool {
    return true
  }
}