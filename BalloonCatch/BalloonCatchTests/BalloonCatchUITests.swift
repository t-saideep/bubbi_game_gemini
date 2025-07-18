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
        XCTAssertTrue(resetButton.waitForExistence(timeout: 5))
        resetButton.tap()

        XCTAssertTrue(balloon.waitForExistence(timeout: 5))
    }
}

extension XCUIElement {
    func waitForNonExistence(timeout: TimeInterval) -> Bool {
        let predicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
}
