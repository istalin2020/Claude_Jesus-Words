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
                // Angel floats above the card and overlaps its top-left corner,
                // with her pointing arm extending toward the language toggle.
                tipCardWithAngel
                    .padding(.horizontal, 20)
                    .padding(.top, 80)

                Spacer()
            }
            .opacity(appeared ? 1 : 0)
            .scaleEffect(appeared ? 1.0 : 0.9)
            .animation(.spring(response: 0.5, dampingFraction: 0.75), value: appeared)
        }
        .onAppear { appeared = true }
    }

    // MARK: - Card + angel assembly

    private var tipCardWithAngel: some View {
        tipCard
            .overlay(alignment: .topLeading) {
                Image("TipAngel")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 150)
                    // Pull up and slightly left so she perches on the top-left of the card
                    .offset(x: -20, y: -90)
                    .shadow(color: goldDark.opacity(0.4), radius: 10, y: 4)
                    .accessibilityHidden(true)
            }
    }

    // MARK: - Tip card

    private var tipCard: some View {
        VStack(spacing: 14) {
            // Leave visual room for the angel's head over the top-left corner
            HStack(spacing: 10) {
                Spacer().frame(width: 60) // reserved for angel
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 26))
                    .foregroundColor(goldDark)
                Text(tipLabel)
                    .font(.system(size: 24, weight: .bold, design: .serif))
                    .foregroundColor(goldDark)
                Spacer(minLength: 0)
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
        .padding(.top, 32)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(cream)
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
                .shadow(color: goldDark.opacity(0.35), radius: 24, y: 10)
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
