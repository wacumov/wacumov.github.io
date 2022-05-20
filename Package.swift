// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "MikhailAkopov",
    platforms: [.macOS(.v12)],
    products: [
        .executable(name: "MikhailAkopov", targets: ["MikhailAkopov"]),
    ],
    dependencies: [
        .package(url: "https://github.com/johnsundell/publish.git", from: "0.9.0"),
    ],
    targets: [
        .executableTarget(
            name: "MikhailAkopov",
            dependencies: [.product(name: "Publish", package: "publish")]
        ),
    ]
)
