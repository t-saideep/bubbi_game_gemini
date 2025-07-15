import SwiftUI

class GameLogic: ObservableObject {
    @Published var balloonPosition: CGPoint = .zero
    @Published var balloonVelocity: CGVector = .zero
    @Published var isPopped = true
    @Published var scale: CGFloat = 1.0
    @Published var balloonOpacity = 1.0

    private var bounds: CGSize = .zero

    func setBounds(_ bounds: CGSize) {
        self.bounds = bounds
    }

    func updateBalloonPosition() {
        guard !isPopped else { return }
        var newPosition = CGPoint(
            x: self.balloonPosition.x + self.balloonVelocity.dx * (Constants.balloonSpeed / 60.0),
            y: self.balloonPosition.y + self.balloonVelocity.dy * (Constants.balloonSpeed / 60.0)
        )

        let radius = Constants.balloonSize / 2

        if newPosition.x < radius || newPosition.x > bounds.width - radius {
            self.balloonVelocity.dx *= -1
            newPosition.x = max(radius, min(newPosition.x, bounds.width - radius))
        }
        if newPosition.y < radius || newPosition.y > bounds.height - radius {
            self.balloonVelocity.dy *= -1
            newPosition.y = max(radius, min(newPosition.y, bounds.height - radius))
        }

        self.balloonPosition = newPosition
    }

    func popBalloon() {
        guard !isPopped else { return }
        isPopped = true
        withAnimation(.spring()) {
            self.scale = 2.0
        }
        withAnimation(.easeOut(duration: Constants.popAnimationDuration).delay(0.1)) {
            self.balloonOpacity = 0.0
        }
    }

    func resetBalloon() {
        self.isPopped = false
        self.scale = 1.0
        self.balloonOpacity = 1.0
        self.balloonPosition = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let randomAngle = Double.random(in: 0..<(2 * .pi))
        self.balloonVelocity = CGVector(dx: cos(randomAngle), dy: sin(randomAngle))
    }
}
