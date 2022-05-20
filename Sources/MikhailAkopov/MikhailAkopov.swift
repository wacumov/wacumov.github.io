import Foundation
import Plot
import Publish

struct MikhailAkopov: Website {
    enum SectionID: String, WebsiteSectionID {
        case apps
        case about
    }

    struct ItemMetadata: WebsiteItemMetadata {
        let icon: String
        let appid: Int
        let categories: [String]
        let sortOrder: Int
    }

    var url = URL(string: "https://wacumov.github.io")!
    var name = "Mikhail Akopov"
    var description = "An iOS developer's personal website."
    var language: Language { .english }
    var imagePath: Path? { nil }

    struct SocialLink {
        let name: String
        let url: String
    }

    let socialLinks: [SocialLink] =
        [.init(name: "github", url: "https://github.com/wacumov"),
         .init(name: "linkedin", url: "https://www.linkedin.com/in/mikhail-akopov-ios"),
         .init(name: "twitter", url: "https://twitter.com/Wacumov")]
}
