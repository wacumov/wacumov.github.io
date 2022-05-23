import Publish

extension Plugin {
    static func addPrivacyPolicies() -> Self {
        Plugin(name: "PrivacyPolicy") { context in
            let allItems = context.allItems(sortedBy: \.date)
            for item in allItems {
                context.addPage(.makePrivacyPolicyPage(item))
            }
        }
    }
}

private extension Page {
    static func makePrivacyPolicyPage<Site: Website>(_ item: Item<Site>) -> Self {
        let title = "\(item.title) Privacy Policy"
        let content = Content(title: title, body: .makePrivacyPolicy(item.title))
        return Page(path: "\(item.path)/privacy-policy", content: content)
    }
}

private extension Content.Body {
    static func makePrivacyPolicy(_: String) -> Self {
        ""
    }
}
