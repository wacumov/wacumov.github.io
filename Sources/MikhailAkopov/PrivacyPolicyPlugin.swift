import Plot
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
    static func makePrivacyPolicy(_ title: String) -> Self {
        let html = HTML(
            .body(
                .h2("Privacy Policy"),
                .p("Mikhail Akopov built \(title) app as a Commercial app. This app is provided by Mikhail Akopov and is intended for use as is."),
                .p("This policy applies to all information collected or submitted using the app."),

                .h3("Information the App Collects"),
                .p("The app does not collect any information. All information added to the app resides within the app itself."),

                .h3("Analytics"),
                .p("The current app version and later does not use any first or third party analytics other than the Apple App Analytics, which you may optionally opt into on your device. These are covered by Apple’s (Apple Inc.) privacy policy which can be found under the privacy settings on the iOS device. The key reason these analytics are used by the app is to be able to detect app crashes and fix them."),

                .h3("Your Consent"),
                .p("By using the app, you consent to this privacy policy."),

                .h3("Contact Info"),
                .p("If you have questions regarding this privacy policy, you may email the developer using the email address you can find at this website.")
            )
        )
        let htmlString = html.render()
        return Content.Body(html: htmlString)
    }
}
