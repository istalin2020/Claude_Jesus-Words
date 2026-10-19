import SwiftUI

/// Reports the language toggle's on-screen frame so the tip can point at it.
struct LanguageToggleFrameKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        let next = nextValue()
        if next != .zero { value = next }
    }
}

/// First-launch tip: the angel artwork is placed so her arrow ends at the real
/// En | த toggle, which shows through a glowing spotlight in the dimmed screen.
struct LanguageTipView: View {
    /// Toggle frame in global coordinates.
    let toggleFrame: CGRect
    let onDismiss: () -> Void

    @State private var appeared = false

    // Artwork geometry, in pixels of LanguageTipArt.png.
    private static let artSize = CGSize(width: 1086, height: 1448)
    private static let artHoleCenter = CGPoint(x: 933, y: 320)
    private static let artHoleWidth: CGFloat = 256

    private let gold = Color(red: 1.0, green: 0.82, blue: 0.4)

    var body: some View {
        GeometryReader { geo in
            let origin = geo.frame(in: .global).origin
            let toggle = toggleFrame.offsetBy(dx: -origin.x, dy: -origin.y)
            let hole = toggle.insetBy(dx: -6, dy: -6)

            // Scale the art so its spotlight gap matches the real toggle,
            // but never wider than the screen.
            let fitScale = (geo.size.width - 12) / Self.artSize.width
            let matchScale = hole.width / Self.artHoleWidth
            let scale = min(matchScale, fitScale)
            let artWidth = Self.artSize.width * scale
            let artHeight = Self.artSize.height * scale
            let rawX = toggle.midX - Self.artHoleCenter.x * scale
            let artX = min(max(rawX, 6), geo.size.width - artWidth - 6)
            let artY = toggle.midY - Self.artHoleCenter.y * scale

            ZStack(alignment: .topLeading) {
                // Dimmed screen with a see-through, tappable hole over the real toggle.
                SpotlightShape(hole: hole)
                    .fill(Color.black.opacity(0.6), style: FillStyle(eoFill: true))
                    .contentShape(SpotlightShape(hole: hole), eoFill: true)
                    .onTapGesture { dismiss() }

                Capsule()
                    .stroke(gold, lineWidth: 2.5)
                    .shadow(color: gold.opacity(0.9), radius: 10)
                    .shadow(color: gold.opacity(0.6), radius: 18)
                    .frame(width: hole.width, height: hole.height)
                    .offset(x: hole.minX, y: hole.minY)
                    .allowsHitTesting(false)

                Image("LanguageTipArt")
                    .resizable()
                    .frame(width: artWidth, height: artHeight)
                    .offset(x: artX, y: artY)
                    .onTapGesture { dismiss() }
                    .accessibilityLabel("Tip: Tap the language button at the top right to view this Bible verse in English or Tamil. Got it.")
                    .accessibilityAddTraits(.isButton)
            }
            .opacity(appeared ? 1 : 0)
            .animation(.easeOut(duration: 0.35), value: appeared)
        }
        .ignoresSafeArea()
        .onAppear { appeared = true }
    }

    private func dismiss() {
        appeared = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { onDismiss() }
    }
}

private struct SpotlightShape: Shape {
    let hole: CGRect

    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.addRect(rect)
        p.addRoundedRect(in: hole, cornerSize: CGSize(width: hole.height / 2, height: hole.height / 2))
        return p
    }
}
