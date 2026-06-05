import SwiftUI

struct PillContentView: View {
    let viewModel: PillViewModel

    var body: some View {
        ZStack {
            notchFacingRectangle
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
            width: viewModel.effectiveIsExpanded
                ? viewModel.appearance.expandedWidth
                : viewModel.appearance.collapsedWidth,
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

    private var notchFacingRectangle: some Shape {
        let r = viewModel.appearance.cornerRadius
        if viewModel.side == .right {
            return UnevenRoundedRectangle(
                topLeadingRadius: 0,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: r,
                topTrailingRadius: r
            )
        } else {
            return UnevenRoundedRectangle(
                topLeadingRadius: r,
                bottomLeadingRadius: r,
                bottomTrailingRadius: 0,
                topTrailingRadius: 0
            )
        }
    }
}
