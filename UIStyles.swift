#if canImport(SwiftUI)
import SwiftUI

struct AppBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color.black,
                Color(red: 0.08, green: 0.04, blue: 0.18),
                Color.black
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay(
            RadialGradient(
                colors: [
                    Color.purple.opacity(0.3),
                    Color.clear
                ],
                center: .topTrailing,
                startRadius: 20,
                endRadius: 320
            )
        )
        .ignoresSafeArea()
    }
}

struct GlassCardModifier: ViewModifier {
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color.white.opacity(0.06))
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 6)
    }
}

extension View {
    func glassCard(cornerRadius: CGFloat = 16) -> some View {
        modifier(GlassCardModifier(cornerRadius: cornerRadius))
    }
}

#endif
