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
        ),
        Wallpaper(
            id: "wallpaper_tree_of_life",
            name: "Tree of Life",
            tamilName: "வாழ்வின் மரம்",
            subtitle: "Heavenly golden tree with waterfalls",
            tamilSubtitle: "நீர்வீழ்ச்சிகளுடன் வானுலகப் பொன் மரம்",
            imageName: "WallpaperTreeOfLife"
        ),
        Wallpaper(
            id: "wallpaper_new_jerusalem",
            name: "New Jerusalem",
            tamilName: "புதிய எருசலேம்",
            subtitle: "Golden heavenly city above the clouds",
            tamilSubtitle: "மேகங்களுக்கு மேல் பொன்னான வானக நகரம்",
            imageName: "WallpaperNewJerusalem"
        ),
        Wallpaper(
            id: "wallpaper_still_waters",
            name: "Still Waters",
            tamilName: "அமைதியான நீர்",
            subtitle: "A peaceful lake at sunrise",
            tamilSubtitle: "விடியலில் அமைதியான ஏரி",
            imageName: "WallpaperStillWaters"
        ),
        Wallpaper(
            id: "wallpaper_star_of_bethlehem",
            name: "Star of Bethlehem",
            tamilName: "பெத்லகேமின் விண்மீன்",
            subtitle: "A radiant star over Bethlehem",
            tamilSubtitle: "பெத்லகேமின் மேல் ஒளிவீசும் விண்மீன்",
            imageName: "WallpaperStarOfBethlehem"
        ),
        Wallpaper(
            id: "wallpaper_rainbow_promise",
            name: "Rainbow Promise",
            tamilName: "வானவில் வாக்குறுதி",
            subtitle: "God's promise over the valley",
            tamilSubtitle: "பள்ளத்தாக்கின் மேல் இறைவனின் வாக்குறுதி",
            imageName: "WallpaperRainbowPromise"
        ),
        Wallpaper(
            id: "wallpaper_easter_dawn",
            name: "Easter Dawn",
            tamilName: "உயிர்த்தெழுதலின் விடியல்",
            subtitle: "The tomb at sunrise",
            tamilSubtitle: "விடியலில் வெற்றுக் கல்லறை",
            imageName: "WallpaperEasterDawn"
        ),
        Wallpaper(
            id: "wallpaper_crystal_paradise",
            name: "Crystal Paradise",
            tamilName: "படிகப் பரதீசு",
            subtitle: "Clear waters of paradise",
            tamilSubtitle: "பரதீசின் தெளிவான நீர்",
            imageName: "WallpaperCrystalParadise"
        ),
        Wallpaper(
            id: "wallpaper_pentecost_light",
            name: "Pentecost Light",
            tamilName: "பெந்தெகொஸ்தே ஒளி",
            subtitle: "Spirit descending in glory",
            tamilSubtitle: "மகிமையில் இறங்கும் தூய ஆவி",
            imageName: "WallpaperPentecostLight"
        )
    ]

    init() {
        self.selectedWallpaperId = UserDefaults.standard.string(forKey: storageKey) ?? "wallpaper_gates_of_heaven"
    }
}
