import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyC6wvOZHUPb6kgwVFZ6D1wsEpmWPYSML4w")
    GMSPlacesClient.provideAPIKey("AIzaSyC6wvOZHUPb6kgwVFZ6D1wsEpmWPYSML4w")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
