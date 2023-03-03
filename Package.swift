// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BitcoinConvertor_UI",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "BitcoinConvertor_UI",
            targets: ["BitcoinConvertor_UI"]),
    ],
    dependencies: [.package(url: "https://github.com/nasriniazi/ConvertorCore.git", branch: "main"),.package(url: "https://github.com/nasriniazi/FeatureToggling.git", branch: "main"),
        .package(url: "https://github.com/nasriniazi/Coordinator.git", branch: "main")  ,.package(url:"https://github.com/nasriniazi/Theme.git", branch: "main"),.package(url:"https://github.com/ReactiveX/RxSwift.git", .exact("6.5.0") )
    ],
    targets: [
        .target(
            name: "BitcoinConvertor_UI",
            dependencies: [.product(name:"ConvertorCore",package:"ConvertorCore"),.product(name: "FeatureToggling", package: "FeatureToggling"),.product(name: "Coordinator", package: "Coordinator"),.product(name: "Theme", package: "Theme"),.product(name: "RxSwift", package: "RxSwift"),.product(name: "RxCocoa", package: "RxSwift")]),
        .testTarget(
            name: "BitcoinConvertor_UITests",
            dependencies: ["BitcoinConvertor_UI"]),
    ]
)
