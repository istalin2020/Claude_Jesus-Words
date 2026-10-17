import SwiftUI

struct LanguageTipView: View {
    let isTamil: Bool
    let onDismiss: () -> Void

    @State private var appeared = false

    private var tipText: String {
        isTamil
            ? "இந்த வேதவசனத்தை ஆங்கிலத்திலோ தமிழிலோ காண மேல் வலதுபுறத்தில் உள்ள மொழி பொத்தானைத் தட்டுங்கள்."
            : "Tap the language button at the top right to view this Bible verse in English or Tamil."
    }

    private var tipLabel: String {
        isTamil ? "குறிப்பு:" : "Tip:"
    }

    private var gotItLabel: String {
        isTamil ? "புரிந்தது" : "Got it"
    }

    private let cream = Color(red: 1.0, green: 0.98, blue: 0.92)
    private let gold = Color(red: 0.78, green: 0.55, blue: 0.15)
    private let goldLight = Color(red: 0.95, green: 0.75, blue: 0.35)
    private let goldDark = Color(red: 0.78, green: 0.52, blue: 0.15)

    var body: some View {
        ZStack {
            Color.black.opacity(0.55)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }

            VStack(spacing: 0) {
                arrowToToggle
                    .padding(.trailing, 36)
                    .padding(.top, 4)

                tipCard
                    .padding(.horizontal, 24)
                    .padding(.top, 20)

                Spacer()
            }
            .padding(.top, 60)
            .opacity(appeared ? 1 : 0)
            .scaleEffect(appeared ? 1.0 : 0.9)
            .animation(.spring(response: 0.5, dampingFraction: 0.75), value: appeared)
        }
        .onAppear { appeared = true }
    }

    // MARK: - Arrow

    private var arrowToToggle: some View {
        HStack {
            Spacer()
            CurvedArrowShape()
                .stroke(
                    LinearGradient(
                        colors: [goldLight, goldDark],
                        startPoint: .bottomLeading, endPoint: .topTrailing
                    ),
                    style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round)
                )
                .frame(width: 140, height: 110)
                .overlay(
                    // arrowhead
                    Image(systemName: "arrowtriangle.right.fill")
                        .foregroundColor(goldDark)
                        .font(.system(size: 18))
                        .rotationEffect(.degrees(-50))
                        .offset(x: 60, y: -40)
                )
                .shadow(color: goldDark.opacity(0.5), radius: 6)
        }
    }

    // MARK: - Tip card

    private var tipCard: some View {
        VStack(spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 26))
                    .foregroundColor(goldDark)
                Text(tipLabel)
                    .font(.system(size: 24, weight: .bold, design: .serif))
                    .foregroundColor(goldDark)
            }
            .padding(.top, 4)

            Text(tipText)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color.black.opacity(0.78))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 10)

            HStack(spacing: 10) {
                Capsule().fill(gold.opacity(0.4)).frame(width: 40, height: 2)
                LatinCrossIcon(size: 14)
                    .foregroundColor(gold.opacity(0.7))
                Capsule().fill(gold.opacity(0.4)).frame(width: 40, height: 2)
            }
            .padding(.vertical, 4)

            Button(action: dismiss) {
                HStack(spacing: 8) {
                    Text(gotItLabel)
                        .font(.system(size: 17, weight: .bold))
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .bold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 46)
                .padding(.vertical, 14)
                .background(
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [goldLight, goldDark],
                                startPoint: .top, endPoint: .bottom
                            )
                        )
                        .shadow(color: goldDark.opacity(0.45), radius: 6, y: 3)
                )
            }
            .padding(.bottom, 4)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(cream)
                .shadow(color: goldDark.opacity(0.35), radius: 24, y: 10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [goldLight, gold.opacity(0.4)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
    }

    private func dismiss() {
        withAnimation(.easeOut(duration: 0.25)) {
            appeared = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            onDismiss()
        }
    }
}

// Curved arrow from the card up and to the right (toward the language toggle)
private struct CurvedArrowShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let start = CGPoint(x: rect.minX, y: rect.maxY)
        let end = CGPoint(x: rect.maxX - 10, y: rect.minY + 10)
        let control1 = CGPoint(x: rect.minX + rect.width * 0.1, y: rect.minY + rect.height * 0.1)
        let control2 = CGPoint(x: rect.midX, y: rect.minY)
        p.move(to: start)
        p.addCurve(to: end, control1: control1, control2: control2)
        return p
    }
}
