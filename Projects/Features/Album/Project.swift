//
//  Project.swift
//  AlbumManifests
//
//  Created by Hong Seong Ho on 12/26/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Album",
    targets: [
        .target(
            name: "Album",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.grohong.Album",
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
            name: "AlbumExample",
            destinations: .iOS,
            product: .app,
            bundleId: "com.grohong.AlbumExample",
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
                .target(name: "Album")
            ],
            settings: .swift6
        )
    ]
)
