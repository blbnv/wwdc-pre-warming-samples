@UIApplicationMain
final class PassengerAppDelegate: UIResponder, UIApplicationDelegate {

    let appLaunchReportingProvider = getAppLifecycleReportingProvider()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        let appLaunchSpan = self.appLaunchReportingProvider.span("app_launch")

        BootstrapManager.bootstrap { in
            appLaunchSpan.complete()
        }
    }
}
