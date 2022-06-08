# wwdc-pre-warming-samples

## Summary
Pre-warming is a feature of iOS when the operating system tries to launch your application faster by loading some parts of the application resources even before the user taps on the app icon. Lyft is interested in tracking the app launch time (from the app icon tap to the moment the user could interact with the UI) and splitting this time by different spans.
There were some cases where the startup time significantly increase but the application was not opened for these cases and we believe it could be related to the prewarming feature.

## Details
We start tracking the launch time in the AppDelegate’s `didFinishLaunching()` method and finish when the application’s bootstrap is being completed - some of the screens are shown with all the needed information. 

Seems like sometimes when the OS starts pre-warming applicationDidFinishLaunching() is called which is not expected by us from the official [documentation](https://developer.apple.com/documentation/uikit/app_and_environment/responding_to_the_launch_of_your_app/about_the_app_launch_sequence?language=objc#3894431).

One of our observations is that we have caught some information about pre-warming in logs during the application launch.
Further, by adding logs to AppDelegate’s and SceneDelegate’s lifecycle methods, we were not able to see any calls of it. So it’s still unclear.

`RunningBoard	process	default	15:11:38.784456-0700	runningboardd	Executing launch request for application<com.xyz> (DAS Prewarm launch)`

Some more cases where we were able to find some information about similar problems:
- https://sourcediving.com/solving-mysterious-logout-issues-on-ios-15-8b818c089466
- https://github.com/MobileNativeFoundation/discussions/discussions/146
- https://twitter.com/steipete/status/1466013492180312068?lang=en
- https://openradar.appspot.com/FB9780579
- https://theiosdude.medium.com/ios-confessions-episode-2-ios15-prewarming-logouts-and-our-answer-to-the-keychain-not-available-43fcca4420c5

For now, one of our hypotheses is to use the `isProtectedDataAvailable` property of `UIApplication` to understand it the application is pre-warming or not to exclude tracking of these events at least.

## Actual questions:
1. Is this a known issue? (I see it in the community but was not able to find an official info). Also, it's very hard to reproduce.
2. Is this possible to detect application was pre-warmed during the launch? If the problem with `didFinishLaunching()` could potentially happen - what's the best way to handle it now?
3. Are there any tips how to simulat prewarming for testing and experiments?
4. Is it possible to simulate it during the testing? Example: `XCUITests`
5. We have both `AppDelegate` and `SceneDelegate` lifecycles for different applications. Could it be somehow related?
6. Do you have any suggestions how to track app launch properly since the processStartTime including the pre-warming?
