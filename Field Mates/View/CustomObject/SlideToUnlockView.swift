//
//  SliderButton.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 02.02.2025.
//
import SwiftUI

struct SlideToUnlockView: View {
    /// Markăm o legătură (binding) spre un Bool care indică dacă slider-ul a ajuns la final
    @Binding var isUnlocked: Bool
    
    var isForMatch: Bool = false
    
    /// Lățimea totală a "track"-ului
    private let sliderWidth: CGFloat = UIScreen.main.bounds.width * 0.8
    /// Înălțimea slider-ului
    private let sliderHeight: CGFloat = 60
    /// Diametrul butonului care alunecă
    private let knobDiameter: CGFloat = 60
    
    /// Pozitia curentă pe axa X a butonului
    @State private var dragOffset: CGFloat = 0
    /// Reprezintă dacă animația de revenire (când nu ajunge la capăt) este în desfășurare
    @State private var isAnimatingBack = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            /// Fundalul ("track"-ul)
            RoundedRectangle(cornerRadius: sliderHeight / 2)
                .fill(Color.gray.opacity(0.2))
                .frame(width: sliderWidth, height: sliderHeight)
            /// Track-ul de progres (il colorăm cu un albastru transparent,
            ///    a cărui lățime e = dragOffset + jumătate din diametrul knob-ului
            ///    ca să fie puțin „sub cerc”)
            RoundedRectangle(cornerRadius: sliderHeight / 2)
                .fill(Color.gray.opacity(0.5)) // Ajustează opacitatea cum îți place
                .frame(width: knobDiameter / 2 + dragOffset + knobDiameter / 2, height: sliderHeight)
            
            /// Eticheta "Slide to unlock" (poți folosi text, iconițe, ce dorești)
            Text(isForMatch ? "Slide to go further" : "Slide to confirm")
                .foregroundColor(.gray)
                .font(.system(size: 16, weight: .medium))
                .position(x: sliderWidth / 2,
                          y: sliderHeight / 2)
                .allowsHitTesting(false) // Să nu influențeze gesturile
            
            /// Butonul (knob-ul) pe care îl glisăm
            Group {
                if isForMatch {
                    Image("Ball")
                        .resizable()
                        .frame(width: knobDiameter, height: knobDiameter)
                        .offset(x: dragOffset)
                        .shadow(radius: 3)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    // Dacă este încă în animație de revenire, oprim reacția la gesturi
                                    guard !isAnimatingBack else { return }
                                    
                                    // Calculează noua poziție, asigurându-te că nu iese în afara track-ului
                                    let translation = value.translation.width
                                    let newOffset = max(0, min(sliderWidth - knobDiameter, translation))
                                    dragOffset = newOffset
                                }
                                .onEnded { _ in
                                    let threshold = sliderWidth - knobDiameter - 10
                                    if dragOffset >= threshold {
                                        // Marchez slider-ul ca deblocat
                                        isUnlocked = true
                                        print(isUnlocked)
                                    } else {
                                        // Animatează revenirea butonului la poziția inițială
                                        withAnimation(.easeOut(duration: 0.3)) {
                                            isAnimatingBack = true
                                            dragOffset = 0
                                        }
                                        // După ce animația s-a încheiat, permite din nou gesturile
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            isAnimatingBack = false
                                        }
                                    }
                                }
                        )
                } else {
                    Circle()
                        .fill(Color.appLightGray)
                        .frame(width: knobDiameter, height: knobDiameter)
                        .offset(x: dragOffset)
                        .shadow(radius: 3)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    // Dacă este încă în animație de revenire, oprim reacția la gesturi
                                    guard !isAnimatingBack else { return }
                                    
                                    // Calculează noua poziție, asigurându-te că nu iese în afara track-ului
                                    let translation = value.translation.width
                                    let newOffset = max(0, min(sliderWidth - knobDiameter, translation))
                                    dragOffset = newOffset
                                }
                                .onEnded { _ in
                                    let threshold = sliderWidth - knobDiameter - 10
                                    if dragOffset >= threshold {
                                        // Marchez slider-ul ca deblocat
                                        isUnlocked = true
                                        print(isUnlocked)
                                    } else {
                                        // Animatează revenirea butonului la poziția inițială
                                        withAnimation(.easeOut(duration: 0.3)) {
                                            isAnimatingBack = true
                                            dragOffset = 0
                                        }
                                        // După ce animația s-a încheiat, permite din nou gesturile
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            isAnimatingBack = false
                                        }
                                    }
                                }
                        )
                }
            }
        }
        .onChange(of: isUnlocked) {
            if !isUnlocked {
                resetSlider()
            }
        }
        // Setezi fix dimensiunea slider-ului
        .frame(width: sliderWidth, height: sliderHeight)
        // Extinzi containerul pe tot ecranul și îl aliniez center
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
    static func getPercentageDragged(from dragOffset: CGFloat, in sliderWidth: CGFloat) -> CGFloat {
        return dragOffset / sliderWidth
    }
    
    private func resetSlider() {
        withAnimation(.easeOut(duration: 0.3)) {
            isAnimatingBack = true
            dragOffset = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isAnimatingBack = false
        }
    }
}

#Preview {
    SlideToUnlockView(isUnlocked: .constant(true))
}
