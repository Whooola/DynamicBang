import SwiftUI

struct ExpandedStateView: View {
    let viewModel: PillViewModel

    var body: some View {
        HStack(spacing: 8) {
            ForEach(Array(viewModel.shortcuts.enumerated()), id: \.element.id) { index, shortcut in
                ShortcutButtonView(shortcut: shortcut, index: index)
            }
        }
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
