//
//  Project.swift
//  MusicPlayerManifests
//
//  Created by Hong Seong Ho on 12/27/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "MusicPlayer",
    targets: [
        .target(
            name: "MusicPlayer",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.grohong.MusicPlayer",
            deploymentTargets: .iOS(TCAExam.Project.version),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .Project.Shared.Framework.sharedFramework,
                .Project.TCAExamFoundation.TCAExamViews.tcaExamViews
            ],
            settings: .swift6
        ),
        .target(
            name: "MusicPlayerTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.grohong.MusicPlayerTests",
            deploymentTargets: .iOS(TCAExam.Project.version),
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "MusicPlayer")]
        ),
        .target(
            name: "MusicPlayerExample",
            destinations: .iOS,
            product: .app,
            bundleId: "com.grohong.MusicPlayerExample",
            deploymentTargets: .iOS(TCAExam.Project.version),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Example/Sources/**"],
            dependencies: [
                .target(name: "MusicPlayer")
            ],
            settings: .swift6
        )
    ]
)

