import XCTest
@testable import BalloonCatch

class BalloonCatchUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testBalloonIsVisibleAndTappable() throws {
        let balloon = app.otherElements["balloon"]
        XCTAssertTrue(balloon.waitForExistence(timeout: 5))
        balloon.tap()

        // Wait for the old balloon to disappear
        XCTAssertFalse(balloon.waitForExistence(timeout: 1))

        // Wait for the new balloon to appear
        let newBalloon = app.otherElements["balloon"]
        XCTAssertTrue(newBalloon.waitForExistence(timeout: 5))
    }
}
