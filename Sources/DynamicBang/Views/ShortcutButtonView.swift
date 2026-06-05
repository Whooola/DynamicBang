import SwiftUI

struct ShortcutButtonView: View {
    let shortcut: ShortcutItem
    let index: Int
    @State private var isPressed = false
    @State private var appeared = false

    var body: some View {
        Button {
            ActionExecutor.execute(shortcut)
        } label: {
            VStack(spacing: 4) {
                Image(systemName: shortcut.symbolName)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                Text(shortcut.title)
                    .font(.system(size: 9))
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(1)
            }
            .frame(width: 44, height: 44)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(isPressed ? 0.2 : 0.08))
            )
            .scaleEffect(appeared ? 1 : 0.5)
            .opacity(appeared ? 1 : 0)
            .animation(
                .spring(response: 0.4, dampingFraction: 0.6)
                    .delay(Double(index) * 0.03),
                value: appeared
            )
        }
        .buttonStyle(.plain)
        .onAppear { appeared = true }
        .onDisappear { appeared = false }
        .onLongPressGesture(minimumDuration: 0, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}
