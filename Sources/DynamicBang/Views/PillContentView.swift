import SwiftUI

struct PillContentView: View {
    let viewModel: PillViewModel

    var body: some View {
        ZStack {
            VisualEffectView(material: viewModel.appearance.blurMaterial.nsMaterial)
                .clipShape(RoundedRectangle(cornerRadius: viewModel.appearance.cornerRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: viewModel.appearance.cornerRadius)
                        .stroke(Color.white.opacity(0.15), lineWidth: 0.5)
                )

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
}

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = .behindWindow
        view.state = .active
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
    }
}
