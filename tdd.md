# Technical Document: Balloon Catch

## Project Structure

The project is built using `xcodegen` which generates an Xcode project. This allows for easy command-line builds and dependency management.

```
BalloonCatch/
├── BalloonCatch/
│   ├── BalloonCatchApp.swift
│   ├── ContentView.swift
│   ├── Balloon.swift
│   ├── Constants.swift
│   └── Assets.xcassets/
├── BalloonCatchTests/
│   └── BalloonCatchTests.swift
└── project.yml
```

## Implementation Details

### Constants

All constants are defined in `Constants.swift` for easy modification of game parameters.

### Balloon

The balloon's visual representation is in `Balloon.swift`, defining its shape and color.

### ContentView

`ContentView.swift` holds the main game logic. It uses a `Timer` to drive the animation and updates the balloon's position on each frame. It also handles the tap gesture for popping the balloon.

### Game Logic

- **Movement**: The balloon's movement is handled by updating its position based on its velocity in the `onReceive` block of a `Timer`. The velocity is a `CGVector` that is initialized with a random direction.
- **Bouncing**: The app checks for collisions with the screen edges and reverses the velocity on the appropriate axis.
- **Popping**: A tap gesture on the balloon triggers a popping animation (scaling up and fading out) and then removes the balloon from the view.

### Animation

The popping animation is implemented using SwiftUI's `withAnimation` block, which animates changes to the balloon's scale and opacity.

### Input Mechanism

A simple `.onTapGesture` modifier is attached to the balloon view to handle taps.

## Testing

The project is configured with two test targets:
- **BalloonCatchUnitTests**: For unit testing the core game logic.
- **BalloonCatchUITests**: For UI testing the application flow.

To run all tests from the command line:
```bash
xcodegen
xcodebuild test -scheme BalloonCatch -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.5'
```

## Building and Running

The project is built and run from the command line using `xcodegen` to generate the project and `xcodebuild` to build and run the app on the simulator.

To build and run the app on the simulator:
```bash
xcodegen
xcodebuild build -scheme BalloonCatch -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.5'
# Find the app path
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "BalloonCatch.app" -print0 | xargs -0 ls -td | head -n 1)
# Install and launch
open -a Simulator && xcrun simctl install booted $APP_PATH && xcrun simctl launch booted com.example.BalloonCatch
```

### Running on a Physical Device

1.  Open the generated project in Xcode: `open BalloonCatch/BalloonCatch.xcodeproj`
2.  Connect your iPhone to your computer.
3.  In the Xcode toolbar, select your iPhone from the device list.
4.  Click the **Run** button (or press `Cmd+R`).

