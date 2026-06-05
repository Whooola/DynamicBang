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
            // Pill sits RIGHT of notch.
            // In pill local coords: notch right edge is at x=nr (straight vertical).
            // Notch bottom-right corner: arc centered at (0, h-nr) radius nr
            //   from (0, h) [bottom] clockwise to (nr, h-nr) [notch side].

            // Start at top of notch edge
            p.move(to: CGPoint(x: nr, y: 0))
            // Top edge → right
            p.addLine(to: CGPoint(x: w - pr, y: 0))
            // Top-right rounded corner
            p.addArc(center: CGPoint(x: w - pr, y: pr), radius: pr,
                     startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: false)
            // Right edge ↓
            p.addLine(to: CGPoint(x: w, y: h - pr))
            // Bottom-right rounded corner
            p.addArc(center: CGPoint(x: w - pr, y: h - pr), radius: pr,
                     startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
            // Bottom edge → left to notch curve end
            p.addLine(to: CGPoint(x: 0, y: h))
            // Follow notch corner curve ↑ (from bottom to notch side)
            p.addArc(center: CGPoint(x: 0, y: h - nr), radius: nr,
                     startAngle: .degrees(90), endAngle: .degrees(0), clockwise: true)
            // Straight ↑ along notch's right edge back to top
            p.addLine(to: CGPoint(x: nr, y: 0))
        } else {
            // Pill sits LEFT of notch.
            // In pill local coords: notch left edge is at x=w-nr (straight vertical).
            // Notch bottom-left corner: arc centered at (w, h-nr) radius nr
            //   from (w, h) [bottom] counterclockwise to (w-nr, h-nr) [notch side].

            // Start at top of notch edge
            p.move(to: CGPoint(x: w - nr, y: 0))
            // Top edge → left
            p.addLine(to: CGPoint(x: pr, y: 0))
            // Top-left rounded corner
            p.addArc(center: CGPoint(x: pr, y: pr), radius: pr,
                     startAngle: .degrees(-90), endAngle: .degrees(180), clockwise: true)
            // Left edge ↓
            p.addLine(to: CGPoint(x: 0, y: h - pr))
            // Bottom-left rounded corner
            p.addArc(center: CGPoint(x: pr, y: h - pr), radius: pr,
                     startAngle: .degrees(180), endAngle: .degrees(90), clockwise: true)
            // Bottom edge → right to notch curve end
            p.addLine(to: CGPoint(x: w, y: h))
            // Follow notch corner curve ↑ (from bottom to notch side)
            p.addArc(center: CGPoint(x: w, y: h - nr), radius: nr,
                     startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
            // Straight ↑ along notch's left edge back to top
            p.addLine(to: CGPoint(x: w - nr, y: 0))
        }

        p.closeSubpath()
        return p
    }
}
