import SwiftUI

struct PillContentView: View {
    let viewModel: PillViewModel

    var body: some View {
        ZStack {
            NotchPillShape(
                side: viewModel.side,
                pillRadius: viewModel.appearance.cornerRadius,
                notchRadius: NotchGeometryProvider.notchCornerRadius
            )
            .fill(Color.black)

            if viewModel.effectiveIsExpanded {
                ExpandedStateView(viewModel: viewModel)
                    .transition(.opacity.combined(with: .scale(scale: 1.03)))
            } else {
                CollapsedStateView(viewModel: viewModel)
                    .transition(.opacity)
            }
        }
        .frame(
            width: (viewModel.effectiveIsExpanded
                ? viewModel.appearance.expandedWidth
                : viewModel.appearance.collapsedWidth) + NotchGeometryProvider.notchCornerRadius,
            height: viewModel.appearance.pillHeight
        )
        .animation(
            .spring(
                response: viewModel.appearance.animationSpringResponse,
                dampingFraction: viewModel.appearance.animationSpringDamping
            ),
            value: viewModel.effectiveIsExpanded
        )
        .preferredColorScheme(.dark)
    }
}

struct NotchPillShape: Shape {
    let side: PillSide
    let pillRadius: CGFloat
    let notchRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        let pr = pillRadius
        let nr = notchRadius
        var p = Path()

        if side == .right {
            // Left edge is the notch-facing side.
            // Top-left: flat, at top bezel.
            p.move(to: CGPoint(x: 0, y: 0))
            // Top edge left→right
            p.addLine(to: CGPoint(x: w - pr, y: 0))
            // Top-right corner
            p.addArc(center: CGPoint(x: w - pr, y: pr), radius: pr,
                     startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: false)
            // Right edge down
            p.addLine(to: CGPoint(x: w, y: h - pr))
            // Bottom-right corner
            p.addArc(center: CGPoint(x: w - pr, y: h - pr), radius: pr,
                     startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
            // Bottom edge right→left to notch curve start
            p.addLine(to: CGPoint(x: nr, y: h))
            // Fill notch bottom-right corner gap:
            // Notch corner center in pill local: (0, h-nr)
            // Arc follows notch contour from (nr, h) up to (0, h-nr)
            p.addArc(center: CGPoint(x: 0, y: h - nr), radius: nr,
                     startAngle: .degrees(90), endAngle: .degrees(0), clockwise: true)
            // Left edge (notch-facing) straight up to top
            p.addLine(to: CGPoint(x: 0, y: 0))
        } else {
            // Right edge is the notch-facing side.
            p.move(to: CGPoint(x: w, y: 0))
            // Top edge right→left
            p.addLine(to: CGPoint(x: pr, y: 0))
            // Top-left corner
            p.addArc(center: CGPoint(x: pr, y: pr), radius: pr,
                     startAngle: .degrees(-90), endAngle: .degrees(180), clockwise: true)
            // Left edge down
            p.addLine(to: CGPoint(x: 0, y: h - pr))
            // Bottom-left corner
            p.addArc(center: CGPoint(x: pr, y: h - pr), radius: pr,
                     startAngle: .degrees(180), endAngle: .degrees(90), clockwise: true)
            // Bottom edge left→right to notch curve start
            p.addLine(to: CGPoint(x: w - nr, y: h))
            // Fill notch bottom-left corner gap:
            // Notch corner center in pill local: (w, h-nr)
            p.addArc(center: CGPoint(x: w, y: h - nr), radius: nr,
                     startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
            // Right edge (notch-facing) straight up to top
            p.addLine(to: CGPoint(x: w, y: 0))
        }

        p.closeSubpath()
        return p
    }
}
