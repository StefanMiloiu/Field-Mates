//
//  Pages.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 31.01.2025.
//

import Foundation
import DeveloperToolsSupport

struct Page {
    let pageNr: Int
    let title: String
    let content: String
    let image: String?
}

let pages = [
    Page(
        pageNr: 1,
        title: "Find Football \nMatches Nearby ⚽",
        content: "Discover football matches happening near you with ease!\n Swipe through available games, view match details, and instantly join games to meet new teammates.\n Whether you're looking for casual play or competitive matches, Field Mates connects you to the perfect game nearby.",
        image: "StadiumImage" // Replace with a real asset
    ),
    Page(
        pageNr: 2,
        title: "Create & Organize Your Own Game 🏟",
        content: "Take control of your football experience! Create your own games, invite friends or new players, and manage everything effortlessly from one place.\n Customize match details, including date, time, and location, to fit your schedule and preferences.\n Build the perfect game for your team.",
        image: "StadiumRealisticImage"
    ),
//    Page(
//        pageNr: 3,
//        title: "Track Your Stats 📊",
//        content: "Stay ahead of the game with in-depth performance tracking! Record your matches, monitor your goals, assists, and overall improvement. View historical data and insights to understand your strengths and focus on areas to improve. Turn your football journey into measurable success!",
//        image: "MatesImage2"
//    ),
    Page(
        pageNr: 3,
        title: "Connect with\n Other Players 🤝",
        content: "Build your football network and find the perfect teammates!\n Chat with players, and exchange tips to improve your game.\n Whether you’re forming a new squad or making new friends, Field Mates helps you stay connected to a passionate football community.",
        image: "MatesImage"
    )
]
