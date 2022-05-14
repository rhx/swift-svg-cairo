// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "SVGCairo",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SVGCairo",
            targets: ["SVGCairo"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        .systemLibrary(
            name: "CSVGCairo",
            pkgConfig: "libsvg-cairo",
            providers: [
                .brew(["libsvg-cairo", "libsvg", "cairo", "glib", "glib-networking", "gobject-introspection"]),
                .apt(["libsvg-cairo-dev", "libsvg-dev", "libcairo2-dev", "libglib2.0-dev", "glib-networking", "gobject-introspection", "libgirepository1.0-dev"])
            ]
        ),
        .target(
            name: "SVGCairo",
            dependencies: ["CSVGCairo"]
        ),
        .testTarget(
            name: "SVGCairoTests",
            dependencies: ["SVGCairo"]
        ),
    ]
)
