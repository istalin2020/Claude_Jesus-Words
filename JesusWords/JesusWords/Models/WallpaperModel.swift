import SwiftUI

struct Wallpaper: Identifiable, Equatable {
    let id: String
    let name: String
    let tamilName: String
    let subtitle: String
    let tamilSubtitle: String
    let imageName: String

    static func == (lhs: Wallpaper, rhs: Wallpaper) -> Bool {
        lhs.id == rhs.id
    }
}

class WallpaperManager: ObservableObject {
    static let shared = WallpaperManager()

    private let storageKey = "selectedWallpaperId"

    @Published var selectedWallpaperId: String {
        didSet {
            UserDefaults.standard.set(selectedWallpaperId, forKey: storageKey)
        }
    }

    var selectedWallpaper: Wallpaper {
        allWallpapers.first(where: { $0.id == selectedWallpaperId }) ?? allWallpapers[0]
    }

    let allWallpapers: [Wallpaper] = [
        Wallpaper(
            id: "wallpaper_gates_of_heaven",
            name: "Gates of Heaven",
            tamilName: "விண்ணக வாயில்கள்",
            subtitle: "Pearly gates of glory",
            tamilSubtitle: "மகிமையின் முத்து வாயில்கள்",
            imageName: "Wallpaper1"
        ),
        Wallpaper(
            id: "wallpaper_river_of_life",
            name: "River of Life",
            tamilName: "வாழ்வின் நதி",
            subtitle: "Flowing from the throne",
            tamilSubtitle: "அரியணையிலிருந்து பாயும் நதி",
            imageName: "Wallpaper2"
        ),
        Wallpaper(
            id: "wallpaper_good_shepherd",
            name: "The Good Shepherd",
            tamilName: "நல்ல ஆயன்",
            subtitle: "He leads me beside still waters",
            tamilSubtitle: "அமைதியான நீரருகே வழிநடத்துகிறார்",
            imageName: "Wallpaper3"
        ),
        Wallpaper(
            id: "wallpaper_holy_spirit",
            name: "Holy Spirit Glow",
            tamilName: "தூய ஆவியின் ஒளி",
            subtitle: "Descending in light",
            tamilSubtitle: "ஒளியில் இறங்கும் ஆவி",
            imageName: "Wallpaper4"
        ),
        Wallpaper(
            id: "wallpaper_resurrection",
            name: "Resurrection Glory",
            tamilName: "உயிர்த்தெழுதலின் மகிமை",
            subtitle: "New life at sunrise",
            tamilSubtitle: "விடியலில் புதிய வாழ்வு",
            imageName: "Wallpaper5"
        )
    ]

    init() {
        self.selectedWallpaperId = UserDefaults.standard.string(forKey: storageKey) ?? "wallpaper_gates_of_heaven"
    }
}
