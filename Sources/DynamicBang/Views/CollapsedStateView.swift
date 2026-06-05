import SwiftUI

struct CollapsedStateView: View {
    let viewModel: PillViewModel

    var body: some View {
        HStack(spacing: 10) {
            ForEach(viewModel.statusItems, id: \.0.id) { item, value in
                if item.type == .nowPlaying {
                    NowPlayingBadgeView(viewModel: viewModel)
                } else {
                    StatusBadgeView(title: item.title, value: value, type: item.type)
                }
            }

            if viewModel.statusItems.isEmpty && viewModel.nowPlayingText.isEmpty {
                StatusBadgeView(title: "DynamicBang", value: "", type: .time)
            }
        }
        .padding(.horizontal, 14)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
