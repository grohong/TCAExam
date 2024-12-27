//
//  Project.swift
//  Config
//
//  Created by Hong Seong Ho on 12/26/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "TCAExam",
    targets: [
        .target(
            name: "TCAExam",
            destinations: .iOS,
            product: .app,
            bundleId: "com.grohong.TCAExam",
            deploymentTargets: .iOS(TCAExam.Project.version),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .Project.Features.AlbumList.albumList,
                .Project.Features.Album.album,
                .Project.Features.MusicPlayer.musicPlayer
            ],
            settings: .settings(
                base: [
                    "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
                    "SWIFT_VERSION": "6.0"
                ]
            )
        ),
        .target(
            name: "TCAExamTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.grohong.TCAExamTests",
            deploymentTargets: .iOS(TCAExam.Project.version),
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "TCAExam")]
        ),
    ]
)
