import Publish

try MikhailAkopov().publish(
    using: [
        .optional(.copyResources()),
        .addMarkdownFiles(),
        .sortItems(by: \.date, order: .descending),
        .generateHTML(withTheme: .maTheme),
        .generateSiteMap(),
    ],
    file: #file
)
