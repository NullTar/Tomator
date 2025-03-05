// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TomatoBar",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .executable(
            name: "TomatoBar",
            targets: ["TomatoBar"]),
    ],
    dependencies: [
        // 如果有外部依赖，可以在这里添加
        // .package(url: "https://github.com/example/example.git", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        .executableTarget(
            name: "TomatoBar",
            dependencies: [],
            path: "Sources",
            exclude: [
                // 排除不需要编译的文件
                "Info.plist",
                "TomatoBar.entitlements"
            ],
            resources: [
                // 包含需要打包的资源
                .process("Assets.xcassets"),
                .process("en.lproj"),
                .process("zh-Hans.lproj")
            ],
            swiftSettings: [
                // 如果需要编译标志，可以在这里添加
                // .define("DEBUG", .when(configuration: .debug))
            ]
        ),
        // 如果需要测试目标，可以添加
        .testTarget(
            name: "TomatoBarTests",
            dependencies: ["TomatoBar"],
            path: "Tests"
        )
    ]
)
