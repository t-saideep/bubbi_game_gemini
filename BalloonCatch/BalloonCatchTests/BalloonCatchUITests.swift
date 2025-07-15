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

        let resetButton = app.buttons["resetButton"]
        XCTAssertTrue(resetButton.waitForExistence(timeout: 1))
        resetButton.tap()

        XCTAssertTrue(balloon.waitForExistence(timeout: 1))
    }
}
