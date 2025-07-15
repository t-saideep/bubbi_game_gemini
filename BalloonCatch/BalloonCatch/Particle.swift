import SwiftUI

struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGVector
    var opacity: Double = 1.0
    var size: CGFloat
}
