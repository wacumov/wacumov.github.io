import Publish

try MikhailAkopov().publish(
    using: [
        .optional(.copyResources()),
        .addMarkdownFiles(),
        .sortItems(by: \.date, order: .descending),
        .installPlugin(.addPrivacyPolicies()),
        .generateHTML(withTheme: .maTheme),
        .generateSiteMap(),
    ],
    file: #file
)
