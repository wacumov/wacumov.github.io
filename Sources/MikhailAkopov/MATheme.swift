import Plot
import Publish

extension Theme where Site == MikhailAkopov {
    static var maTheme: Self {
        Theme(
            htmlFactory: MAThemeHTMLFactory(),
            resourcePaths: ["Sources/MATheme/styles.css"]
        )
    }
}

private struct MAThemeHTMLFactory: HTMLFactory {
    func makeIndexHTML(for index: Index,
                       context: PublishingContext<MikhailAkopov>) throws -> HTML
    {
        HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(
                    .itemList(
                        for: context.allItems(
                            sortedBy: \.metadata.sortOrder,
                            order: .ascending
                        ),
                        on: context.site
                    )
                ),
                .footer(for: context.site)
            )
        )
    }

    func makeSectionHTML(for section: Section<MikhailAkopov>,
                         context: PublishingContext<MikhailAkopov>) throws -> HTML
    {
        HTML(
            .lang(context.site.language),
            .head(for: section, on: context.site),
            .body(
                .header(for: context, selectedSection: section.id),
                .wrapper(
                    .itemList(for: section.items.sorted {
                        $0.metadata.sortOrder < $1.metadata.sortOrder
                    }, on: context.site)
                ),
                .footer(for: context.site)
            )
        )
    }

    func makeItemHTML(for item: Item<MikhailAkopov>,
                      context: PublishingContext<MikhailAkopov>) throws -> HTML
    {
        HTML(
            .lang(context.site.language),
            .head(for: item, on: context.site),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(.div(.class("page-content"),
                              .contentBody(item.body),
                              .appStoreBadge(for: item))),
                .footer(for: context.site)
            )
        )
    }

    func makePageHTML(for page: Page,
                      context: PublishingContext<MikhailAkopov>) throws -> HTML
    {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(.div(.class("page-content"),
                              .contentBody(page.body))),
                .footer(for: context.site)
            )
        )
    }

    func makeTagListHTML(for page: TagListPage,
                         context: PublishingContext<MikhailAkopov>) throws -> HTML?
    {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(),
                .footer(for: context.site)
            )
        )
    }

    func makeTagDetailsHTML(for page: TagDetailsPage,
                            context: PublishingContext<MikhailAkopov>) throws -> HTML?
    {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(),
                .footer(for: context.site)
            )
        )
    }
}

private extension Node where Context == HTML.BodyContext {
    static func wrapper(_ nodes: Node...) -> Node {
        .div(.class("wrapper"), .group(nodes))
    }

    static func header(
        for context: PublishingContext<MikhailAkopov>,
        selectedSection: MikhailAkopov.SectionID?
    ) -> Node {
        let sectionIDs = [MikhailAkopov.SectionID.about]

        return .header(
            .wrapper(
                .a(.class("site-name"), .href("/"), .text(context.site.name)),
                .if(sectionIDs.count > 0,
                    .nav(
                        .ul(.forEach(sectionIDs) { section in
                            .li(.a(
                                .class(section == selectedSection ? "selected" : ""),
                                .href(context.sections[section].path),
                                .text(context.sections[section].title)
                            ))
                        })
                    ))
            )
        )
    }

    static func itemList(for items: [Item<MikhailAkopov>], on site: MikhailAkopov) -> Node {
        .ul(
            .class("cards"),
            .forEach(items) { item in
                .li(.class("cards-item"),
                    .itemCard(for: item, on: site))
            }
        )
    }

    private static func itemCard(for item: Item<MikhailAkopov>, on site: MikhailAkopov) -> Node {
        .div(.class("card"),
             .div(.class("card-content"),
                  .itemCardHeader(for: item, on: site),
                  .div(.class("card-text"),
                       .p(.text(item.description))),
                  .appStoreBadge(for: item)))
    }

    static func appStoreBadge(for item: Item<MikhailAkopov>) -> Node {
        .a(.href("https://apps.apple.com/app/id\(item.metadata.appid)"),
           .img(.class("app-store-badge"),
                .src("/images/app-store-badge.svg"),
                .alt("Download on the App Store")))
    }

    private static func itemCardHeader(for item: Item<MikhailAkopov>, on _: MikhailAkopov) -> Node {
        .div(.class("card-header-container"),
             .div(.class("card-icon"),
                  .img(.alt("\(item.title) icon"),
                       .src("/images/\(item.metadata.icon)"))),
             .div(.class("card-header"),
                  .h2(.a(.href(item.path),
                         .text(item.title))),
                  .categoryList(for: item)))
    }

    static func categoryList(for item: Item<MikhailAkopov>) -> Node {
        .ul(.class("category-list"), .forEach(item.metadata.categories) { category in
            .li(.class("category"),
                .text(category))
        })
    }

    static func footer(for site: MikhailAkopov) -> Node {
        .footer(
            .socialLinksList(for: site),
            .p(.class("generated-using"),
               .text("Generated using "),
               .a(
                   .text("Publish"),
                   .href("https://github.com/johnsundell/publish")
               ))
        )
    }

    private static func socialLinksList(for site: MikhailAkopov) -> Node {
        .ul(.class("social-links-list"), .forEach(site.socialLinks) { link in
            .li(.class("social-link"),
                .a(.text(link.name),
                   .href(link.url)))
        })
    }
}
