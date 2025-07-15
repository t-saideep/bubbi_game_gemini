import SwiftUI

class GameLogic: ObservableObject {
    @Published var balloonPosition: CGPoint = .zero
    @Published var balloonVelocity: CGVector = .zero
    @Published var isPopped = true
    @Published var scale: CGFloat = 1.0
    @Published var balloonOpacity = 1.0
    @Published var particles: [Particle] = []

    private var bounds: CGSize = .zero

    func setBounds(_ bounds: CGSize) {
        self.bounds = bounds
    }

    func updateBalloonPosition() {
        guard !isPopped else {
            updateParticles()
            return
        }
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
        createParticles()
    }

    func resetBalloon() {
        self.isPopped = false
        self.scale = 1.0
        self.balloonOpacity = 1.0
        self.particles = []
        self.balloonPosition = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let randomAngle = Double.random(in: 0..<(2 * .pi))
        self.balloonVelocity = CGVector(dx: cos(randomAngle), dy: sin(randomAngle))
    }

    private func createParticles() {
        for _ in 0..<Constants.particleCount {
            let angle = Double.random(in: 0..<(2 * .pi))
            let velocity = CGVector(dx: cos(CGFloat(angle)) * Constants.particleSpeed, dy: sin(CGFloat(angle)) * Constants.particleSpeed)
            let particle = Particle(position: balloonPosition, velocity: velocity, size: CGFloat.random(in: 5...15))
            particles.append(particle)
        }
    }

    private func updateParticles() {
        guard !particles.isEmpty else { return }
        for i in 0..<particles.count {
            particles[i].position.x += particles[i].velocity.dx / 60.0
            particles[i].position.y += particles[i].velocity.dy / 60.0
            particles[i].opacity -= 1.0 / (Constants.particleLifetime * 60.0)
        }
        particles.removeAll { $0.opacity <= 0 }
    }
}
