import SwiftUI

struct ContentView: View {
    @StateObject private var game = GameLogic()
    private let timer = Timer.publish(every: 1.0/60.0, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.cyan.edgesIgnoringSafeArea(.all)

                ForEach(game.particles) { particle in
                    Circle()
                        .fill(Color.red)
                        .frame(width: particle.size, height: particle.size)
                        .position(particle.position)
                        .opacity(particle.opacity)
                }

                if !game.isPopped {
                    BalloonView()
                        .accessibilityIdentifier("balloon")
                        .scaleEffect(game.scale)
                        .opacity(game.balloonOpacity)
                        .position(game.balloonPosition)
                        .onTapGesture {
                            game.popBalloon()
                        }
                }
            }
            .onAppear {
                game.setBounds(geometry.size)
                game.resetBalloon()
            }
            .onReceive(timer) { _ in
                game.updateBalloonPosition()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
