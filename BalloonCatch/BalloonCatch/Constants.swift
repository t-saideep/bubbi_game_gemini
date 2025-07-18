import Foundation
import SwiftUI

struct Constants {
    /// The diameter of the balloon in points.
    static let balloonSize: CGFloat = 100
    /// The length of the string attached to the balloon in points.
    static let stringLength: CGFloat = 50
    /// The speed of the balloon in points per second.
    static let balloonSpeed: Double = 100.0
    /// The duration of the pop animation in seconds.
    static let popAnimationDuration: Double = 0.2
    /// The number of particles to create when the balloon pops.
    static let particleCount = 20
    /// The lifetime of the particles in seconds.
    static let particleLifetime = 0.5
    /// The speed of the particles in points per second.
    static let particleSpeed: CGFloat = 200
}
