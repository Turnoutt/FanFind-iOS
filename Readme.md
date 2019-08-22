# Usage Instructions

1. First add the pod to your `Podfile`.
    > ``` pod 'FanFind'```

2. In your Info.plist, add the following Keys

    > ```
    >FANFIND_API_KEY = {Api Key Given By Us}
    >FANFIND_THEME = {`Light` or `Dark`}
    >FANFIND_SECONDARY_COLOR = {Secondary Color For Team}
    >FANFIND_PRIMARY_COLOR = {Primary Color For Team}
    >```

2. You should now be able to access the SDK from within your application. In your AppDelegate in `didFinishLaunchingWithOptions`, you will need to add the following lines

    > ``` swift
    >// This allows visit tracking to start working again on an iOS callback.
    >if let keys = launchOptions?.keys {
    >   if keys.contains(.location) {
    >       FanFindClient.shared.startTrackingLocation()
    >   }
    >}
    > ```       

3. If a user id is assigned to the user you will want to make the following call after this occurs.

    >   ``` swift
    >   // This will allow us to track metrics across devices.
    >   FanFindClient.shared.signIn(userId: newUserId) { (err) in }
    >   ```