import XCTest
import SwiftUI
@testable import BalloonCatch

class GameLogicTests: XCTestCase {
    var game: GameLogic!

    override func setUp() {
        super.setUp()
        game = GameLogic()
        game.setBounds(CGSize(width: 300, height: 500))
    }

    override func tearDown() {
        game = nil
        super.tearDown()
    }

    func testResetBalloon() {
        game.resetBalloon()
        XCTAssertFalse(game.isPopped)
        XCTAssertEqual(game.scale, 1.0)
        XCTAssertEqual(game.balloonOpacity, 1.0)
        XCTAssertEqual(game.balloonPosition, CGPoint(x: 150, y: 250))
        XCTAssertNotEqual(game.balloonVelocity, .zero)
    }

    func testBalloonMovement() {
        game.resetBalloon()
        let initialPosition = game.balloonPosition
        game.updateBalloonPosition()
        XCTAssertNotEqual(game.balloonPosition, initialPosition)
    }

    func testBalloonBounceHorizontalLeft() {
        game.resetBalloon()
        game.balloonPosition = CGPoint(x: (Constants.balloonSize / 2) - 1, y: 250)
        game.balloonVelocity = CGVector(dx: -1, dy: 0)
        let initialVelocityX = game.balloonVelocity.dx
        game.updateBalloonPosition()
        XCTAssertGreaterThan(game.balloonVelocity.dx, initialVelocityX)
    }
    
    func testBalloonBounceHorizontalRight() {
        game.resetBalloon()
        game.balloonPosition = CGPoint(x: 300 - (Constants.balloonSize / 2) + 1, y: 250)
        game.balloonVelocity = CGVector(dx: 1, dy: 0)
        let initialVelocityX = game.balloonVelocity.dx
        game.updateBalloonPosition()
        XCTAssertLessThan(game.balloonVelocity.dx, initialVelocityX)
    }

    func testBalloonBounceVerticalTop() {
        game.resetBalloon()
        game.balloonPosition = CGPoint(x: 150, y: (Constants.balloonSize / 2) - 1)
        game.balloonVelocity = CGVector(dx: 0, dy: -1)
        let initialVelocityY = game.balloonVelocity.dy
        game.updateBalloonPosition()
        XCTAssertGreaterThan(game.balloonVelocity.dy, initialVelocityY)
    }
    
    func testBalloonBounceVerticalBottom() {
        game.resetBalloon()
        game.balloonPosition = CGPoint(x: 150, y: 500 - (Constants.balloonSize / 2) + 1)
        game.balloonVelocity = CGVector(dx: 0, dy: 1)
        let initialVelocityY = game.balloonVelocity.dy
        game.updateBalloonPosition()
        XCTAssertLessThan(game.balloonVelocity.dy, initialVelocityY)
    }

    func testPopBalloon() {
        game.popBalloon()
        XCTAssertTrue(game.isPopped)
    }

    func testResetAfterPop() {
        game.popBalloon()
        game.resetBalloon()
        XCTAssertFalse(game.isPopped)
        XCTAssertEqual(game.scale, 1.0)
        XCTAssertEqual(game.balloonOpacity, 1.0)
    }

    func testBoundaryConditions() {
        // Left edge
        game.resetBalloon()
        game.balloonPosition = CGPoint(x: Constants.balloonSize / 2, y: 250)
        game.balloonVelocity = CGVector(dx: -1, dy: 0)
        game.updateBalloonPosition()
        XCTAssertGreaterThan(game.balloonVelocity.dx, 0)

        // Right edge
        game.resetBalloon()
        game.balloonPosition = CGPoint(x: 300 - Constants.balloonSize / 2, y: 250)
        game.balloonVelocity = CGVector(dx: 1, dy: 0)
        game.updateBalloonPosition()
        XCTAssertLessThan(game.balloonVelocity.dx, 0)

        // Top edge
        game.resetBalloon()
        game.balloonPosition = CGPoint(x: 150, y: Constants.balloonSize / 2)
        game.balloonVelocity = CGVector(dx: 0, dy: -1)
        game.updateBalloonPosition()
        XCTAssertGreaterThan(game.balloonVelocity.dy, 0)

        // Bottom edge
        game.resetBalloon()
        game.balloonPosition = CGPoint(x: 150, y: 500 - Constants.balloonSize / 2)
        game.balloonVelocity = CGVector(dx: 0, dy: 1)
        game.updateBalloonPosition()
        XCTAssertLessThan(game.balloonVelocity.dy, 0)
    }

    func testPopBalloonAlreadyPopped() {
        game.popBalloon()
        let expectation = XCTestExpectation(description: "Wait for pop animation")
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.popAnimationDuration + 0.6) {
            XCTAssertTrue(self.game.isPopped)
            self.game.popBalloon()
            XCTAssertTrue(self.game.isPopped)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testUpdatePositionWhenPopped() {
        game.popBalloon()
        let initialPosition = game.balloonPosition
        game.updateBalloonPosition()
        XCTAssertEqual(game.balloonPosition, initialPosition)
    }

    func testResetBalloonFromPoppedState() {
        game.popBalloon()
        let expectation = XCTestExpectation(description: "Wait for pop animation")
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.popAnimationDuration + 0.6) {
            self.game.resetBalloon()
            XCTAssertFalse(self.game.isPopped)
            XCTAssertEqual(self.game.scale, 1.0)
            XCTAssertEqual(self.game.balloonOpacity, 1.0)
            XCTAssertEqual(self.game.balloonPosition, CGPoint(x: 150, y: 250))
            XCTAssertNotEqual(self.game.balloonVelocity, .zero)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testParticleCreationOnPop() {
        game.resetBalloon()
        XCTAssertTrue(game.particles.isEmpty)
        game.popBalloon()
        XCTAssertEqual(game.particles.count, Constants.particleCount)
    }
}
