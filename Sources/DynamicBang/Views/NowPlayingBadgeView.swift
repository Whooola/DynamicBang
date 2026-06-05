import SwiftUI

struct NowPlayingBadgeView: View {
    let viewModel: PillViewModel

    var body: some View {
        if !viewModel.nowPlayingText.isEmpty {
            HStack(spacing: 5) {
                if let art = viewModel.nowPlayingArt {
                    Image(nsImage: art)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "music.note")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.7))
                }

                MarqueeText(text: viewModel.nowPlayingText)
                    .frame(width: 60)
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(Color.white.opacity(0.1))
            .clipShape(Capsule())
        }
    }
}

struct MarqueeText: View {
    let text: String
    @State private var offset: CGFloat = 0
    @State private var textWidth: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let containerWidth = geo.size.width
            let needsScroll = textWidth > containerWidth

            Text(text)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white)
                .lineLimit(1)
                .fixedSize()
                .background(
                    GeometryReader { textGeo in
                        Color.clear.onAppear {
                            textWidth = textGeo.size.width
                        }
                    }
                )
                .offset(x: needsScroll ? offset : 0)
                .onAppear {
                    guard needsScroll else { return }
                    let duration = Double(textWidth) / 30.0
                    let animation = Animation.linear(duration: duration)
                        .repeatForever(autoreverses: false)
                    offset = containerWidth - textWidth - 10
                    withAnimation(animation) {}
                }
                .mask(
                    HStack(spacing: 0) {
                        Rectangle()
                        LinearGradient(
                            gradient: Gradient(colors: [.clear, .white]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: 10)
                    }
                )
        }
    }
}
