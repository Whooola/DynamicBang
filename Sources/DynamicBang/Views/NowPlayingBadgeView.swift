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
    @State private var animate = false

    var body: some View {
        GeometryReader { _ in
            let spacing: CGFloat = 24

            HStack(spacing: spacing) {
                Text(text)
                Text(text)
            }
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(.white)
            .lineLimit(1)
            .fixedSize()
            .background(
                GeometryReader { textGeo in
                    Color.clear.onAppear {
                        let singleW = textGeo.size.width / 2
                        let duration = max(Double(singleW + spacing) / 25.0, 1.5)
                        withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                            animate = true
                        }
                    }
                }
            )
            .offset(x: animate ? -(textWidth) : 0)
            .mask(
                HStack(spacing: 0) {
                    Rectangle()
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .white]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: 12)
                }
            )
        }
    }

    private var textWidth: CGFloat {
        let font = NSFont.systemFont(ofSize: 11, weight: .medium)
        let attrs = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: attrs)
        return size.width + 24
    }
}
