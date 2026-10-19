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

/// Reports each tab-bar button's on-screen frame, keyed by tab tag.
struct TabButtonFramesKey: PreferenceKey {
    static var defaultValue: [Int: CGRect] = [:]
    static func reduce(value: inout [Int: CGRect], nextValue: () -> [Int: CGRect]) {
        value.merge(nextValue()) { $1 }
    }
}

/// First-launch tip shown after the language tip: the angel points down at the
/// real Themes tab, which glows through a spotlight in the dimmed screen.
struct ThemesTipView: View {
    /// Themes tab button frame in global coordinates.
    let tabFrame: CGRect
    let isTamil: Bool
    let onDismiss: () -> Void

    @State private var appeared = false

    private let cream = Color(red: 1.0, green: 0.98, blue: 0.92)
    private let gold = Color(red: 0.86, green: 0.64, blue: 0.22)
    private let goldLight = Color(red: 0.98, green: 0.82, blue: 0.42)
    private let goldDark = Color(red: 0.72, green: 0.50, blue: 0.14)
    private let purple = Color(red: 0.55, green: 0.18, blue: 0.75)

    var body: some View {
        GeometryReader { geo in
            let origin = geo.frame(in: .global).origin
            let tab = tabFrame.offsetBy(dx: -origin.x, dy: -origin.y)
            let side = max(tab.width, tab.height) + 16
            let hole = CGRect(x: tab.midX - side / 2, y: tab.midY - side / 2, width: side, height: side)
            let cardBottom = hole.minY - 64
            let cardWidth = min(geo.size.width - 48, 380)
            let arrowStart = CGPoint(x: geo.size.width / 2 - 40, y: cardBottom + 6)
            let arrowEnd = CGPoint(x: hole.midX, y: hole.minY - 4)

            ZStack(alignment: .topLeading) {
                SpotlightShape(hole: hole, circular: true)
                    .fill(Color.black.opacity(0.6), style: FillStyle(eoFill: true))
                    .contentShape(SpotlightShape(hole: hole, circular: true), eoFill: true)
                    .onTapGesture { dismiss() }

                Circle()
                    .stroke(goldLight, lineWidth: 2.5)
                    .shadow(color: goldLight.opacity(0.9), radius: 10)
                    .shadow(color: goldLight.opacity(0.6), radius: 20)
                    .frame(width: hole.width, height: hole.height)
                    .offset(x: hole.minX, y: hole.minY)
                    .allowsHitTesting(false)

                CurvedArrow(start: arrowStart, end: arrowEnd)
                    .stroke(cream, style: StrokeStyle(lineWidth: 3.5, lineCap: .round, lineJoin: .round))
                    .shadow(color: goldLight, radius: 6)
                    .allowsHitTesting(false)

                VStack {
                    Spacer(minLength: 0)
                    card
                        .frame(width: cardWidth)
                        .overlay(alignment: .topLeading) {
                            Image("TipAngel")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 130)
                                .offset(x: -30, y: -92)
                                .shadow(color: goldLight.opacity(0.6), radius: 10)
                                .allowsHitTesting(false)
                        }
                        .padding(.bottom, geo.size.height - cardBottom)
                }
                .frame(width: geo.size.width)
            }
            .opacity(appeared ? 1 : 0)
            .animation(.easeOut(duration: 0.35), value: appeared)
        }
        .ignoresSafeArea()
        .onAppear { appeared = true }
    }

    private var message: Text {
        if isTamil {
            return Text("உங்கள் தினசரி வேதவசனங்களுக்கான அழகிய புதிய தீம்களைக் கண்டறிய கீழே உள்ள ")
                + Text("தீம்கள்").foregroundColor(purple).bold()
                + Text(" தாவலைப் பாருங்கள்.")
        }
        return Text("Explore the ")
            + Text("Themes").foregroundColor(purple).bold()
            + Text(" tab below to discover beautiful new themes for your daily Bible verses.")
    }

    private var card: some View {
        VStack(spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "sparkle").font(.system(size: 14))
                Text(isTamil ? "குறிப்பு:" : "Tip:")
                    .font(.system(size: 30, weight: .bold, design: .serif))
                Image(systemName: "sparkle").font(.system(size: 14))
            }
            .foregroundColor(goldDark)
            .padding(.leading, 40) // room for the angel

            message
                .font(.system(size: 17, weight: .medium, design: .serif))
                .foregroundColor(Color(red: 0.25, green: 0.17, blue: 0.08))
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)

            Button(action: dismiss) {
                Text(isTamil ? "புரிந்தது" : "Got it")
                    .font(.system(size: 20, weight: .bold, design: .serif))
                    .foregroundColor(.white)
                    .frame(maxWidth: 220)
                    .padding(.vertical, 12)
                    .background(
                        Capsule()
                            .fill(LinearGradient(colors: [goldLight, goldDark], startPoint: .top, endPoint: .bottom))
                            .shadow(color: goldDark.opacity(0.5), radius: 6, y: 3)
                    )
                    .overlay(Capsule().stroke(goldLight, lineWidth: 1.5))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 22)
        .padding(.top, 22)
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(cream)
                .overlay(
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .stroke(LinearGradient(colors: [goldLight, gold], startPoint: .top, endPoint: .bottom), lineWidth: 2.5)
                )
                .shadow(color: goldLight.opacity(0.7), radius: 22)
        )
    }

    private func dismiss() {
        appeared = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { onDismiss() }
    }
}

/// A gently curving arrow from `start` to `end`, with an arrowhead at `end`.
private struct CurvedArrow: Shape {
    let start: CGPoint
    let end: CGPoint

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let control = CGPoint(x: start.x - 10, y: end.y - 10)
        p.move(to: start)
        p.addQuadCurve(to: end, control: control)
        // Arrowhead aligned with the curve's final direction (control -> end).
        let angle = atan2(end.y - control.y, end.x - control.x)
        let len: CGFloat = 14, spread: CGFloat = .pi / 6
        p.move(to: end)
        p.addLine(to: CGPoint(x: end.x - len * cos(angle - spread), y: end.y - len * sin(angle - spread)))
        p.move(to: end)
        p.addLine(to: CGPoint(x: end.x - len * cos(angle + spread), y: end.y - len * sin(angle + spread)))
        return p
    }
}

private struct SpotlightShape: Shape {
    let hole: CGRect
    var circular = false

    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.addRect(rect)
        if circular {
            p.addEllipse(in: hole)
        } else {
            p.addRoundedRect(in: hole, cornerSize: CGSize(width: hole.height / 2, height: hole.height / 2))
        }
        return p
    }
}
