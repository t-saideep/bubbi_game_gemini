import SwiftUI

struct ContentView: View {
    @StateObject private var game = GameLogic()
    private let timer = Timer.publish(every: 1.0/60.0, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.cyan.edgesIgnoringSafeArea(.all)
                if !game.isPopped {
                    BalloonView()
                        .accessibilityIdentifier("balloon")
                        .scaleEffect(game.scale)
                        .opacity(game.balloonOpacity)
                        .position(game.balloonPosition)
                        .onTapGesture {
                            game.popBalloon()
                        }
                } else {
                    Button("Reset") {
                        game.resetBalloon()
                    }
                    .accessibilityIdentifier("resetButton")
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
