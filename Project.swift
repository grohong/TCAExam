import ProjectDescription

let project = Project(
    name: "TCAExam",
    targets: [
        .target(
            name: "TCAExam",
            destinations: .iOS,
            product: .app,
            bundleId: "com.grohong.TCAExam",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["TCAExam/Sources/**"],
            resources: ["TCAExam/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "TCAExamTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.grohong.TCAExamTests",
            infoPlist: .default,
            sources: ["TCAExam/Tests/**"],
            resources: [],
            dependencies: [.target(name: "TCAExam")]
        ),
    ]
)
