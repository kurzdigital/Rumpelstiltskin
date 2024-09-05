// swift-tools-version: 5.5

import PackageDescription

let package: Package = Package(
    name: "Rumpelstiltskin",
    defaultLocalization: "en",
    products: [
        .library(name: "Rumpelstiltskin",targets: ["Rumpelstiltskin"]),
        .plugin(name: "RumpelstiltskinBuildPlugin", targets: ["RumpelstiltskinBuildPlugin"])
    ],
    targets: [
        .executableTarget(
            name: "RumpelstiltskinBin",
            path: ".",
            exclude: ["Example"],
            sources: ["main.swift"]
        ),
        .plugin(
            name: "RumpelstiltskinBuildPlugin",
            capability: .buildTool(),
            dependencies: ["RumpelstiltskinBin"],
            path: "Plugins",
            exclude: ["../Example"]
        ),
        .target(
            name: "Rumpelstiltskin",
            exclude: ["../../Example"],
            plugins: [
                .plugin(name: "RumpelstiltskinBuildPlugin")
            ]
        )
    ]
)