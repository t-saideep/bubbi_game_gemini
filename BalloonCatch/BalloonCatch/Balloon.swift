import SwiftUI

struct BalloonView: View {
    var body: some View {
        VStack(spacing: 0) {
            Circle()
                .fill(Color.red)
                .frame(width: Constants.balloonSize, height: Constants.balloonSize)
            Rectangle()
                .fill(Color.black)
                .frame(width: 1, height: Constants.stringLength)
        }
    }
}