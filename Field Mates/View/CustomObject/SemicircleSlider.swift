//
//  SemicircleSlider.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 03.02.2025.
//
import SwiftUI
import CoreGraphics

// MARK: - Semicircular Slider
struct SemicircleSlider: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Binding var selectedIndex: Int
    let labels: [String]
    
    private let totalPositions = 5
    private let radius: CGFloat = 100
    private let textOffset: CGFloat = 20  // Push labels outward
    @State private var dragPosition: CGPoint? = nil
    @State private var profilePictureURL: URL?
    
    var body: some View {
        GeometryReader { geo in
            let centerX = geo.size.width / 2
            let centerY = radius
            let center = CGPoint(x: centerX, y: centerY)
            
            ZStack {
                // Draw the semicircle
                Path { path in
                    path.addArc(center: center,
                                radius: radius,
                                startAngle: .degrees(360),
                                endAngle: .degrees(0),
                                clockwise: false)
                }
                .stroke(Color.gray, lineWidth: 6)
                
                // Skill level indicators (labels)
                ForEach(0..<totalPositions, id: \.self) { index in
                    let angle = angleForIndex(index)
                    let position = pointForAngle(angle, center: center, radius: radius + textOffset + 10) // Move text outward
                    
                    Text(labels[index])
                        .font(.caption)
                        .bold()
                        .foregroundColor(.primary)
                        .padding(6)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.2)) // Subtle background
                        )
                        .position(position)
                }
                
                // Draggable Indicator
                let angle = angleForIndex(selectedIndex)
                let position = dragPosition ?? pointForAngle(angle, center: center, radius: radius)
                
                Circle()
                    .fill(Color.red)
                    .frame(width: 24, height: 24)
                    .position(position)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragPosition = value.location
                            }
                            .onEnded { value in
                                selectedIndex = closestIndex(to: value.location, center: center)
                                dragPosition = nil  // Reset so it snaps correctly
                            }
                    )
                
                
                // Dacă NU am selectat încă local, dar avem un URL ->
                if labels.first == "Goalkeeper" {
                    if selectedIndex == 0 {
                        Image(systemName: "figure.rugby")
                            .resizable()
                            .frame(width: 85, height: 85)
                    } else if selectedIndex == 1 {
                        Image(systemName: "figure.soccer")
                            .resizable()
                            .frame(width: 85, height: 85)
                    } else if selectedIndex == 2 {
                        Image(systemName: "figure.soccer")
                            .resizable()
                            .frame(width: 85, height: 85)
                    } else if selectedIndex == 3 {
                        Image(systemName: "figure.australian.football")
                            .resizable()
                            .frame(width: 85, height: 85)
                    }
                } else {
                    if let url = profilePictureURL {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            case .failure(_):
                                placeholderImage
                            @unknown default:
                                placeholderImage
                            }
                        }
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .padding(8)
                        
                        // Niciun URL, niciun selectedImage -> placeholder
                    } else {
                        placeholderImage
                            .padding(8)
                    }
                }
            }
        }
        .onAppear {
            if let profilePicture = userViewModel.user?.profilePicture {
                do {
                    self.profilePictureURL = try Data.fileURL(for: profilePicture)
                } catch {
                    print("Got error while trying to load local image: \(error)")
                }
            }
        }
        .frame(height: radius * 2)
    }
    
    
    // MARK: - Helper Functions
    private var placeholderImage: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 65, height: 65)
            .clipShape(Circle())
    }
    
    private func angleForIndex(_ index: Int) -> Double {
        return Double(180 - (index * 72))
    }
    
    private func pointForAngle(_ angle: Double, center: CGPoint, radius: CGFloat) -> CGPoint {
        let radians = angle * .pi / 180
        return CGPoint(x: center.x + cos(radians) * radius,
                       y: center.y - sin(radians) * radius)
    }
    
    private func closestIndex(to point: CGPoint, center: CGPoint) -> Int {
        let distances = (0..<totalPositions).map { index -> (Int, CGFloat) in
            let position = pointForAngle(angleForIndex(index), center: center, radius: radius)
            let distance = hypot(position.x - point.x, position.y - point.y)
            return (index, distance)
        }
        return distances.min { $0.1 < $1.1 }?.0 ?? 0
    }
}
