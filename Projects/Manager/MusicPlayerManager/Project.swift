//
//  Project.swift
//  MusicPlayerManagerManifests
//
//  Created by Hong Seong Ho on 12/27/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "MusicPlayerManager",
    targets: [
        .target(
            name: "MusicPlayerManager",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.grohong.MusicPlayerManager",
            deploymentTargets: .iOS(TCAExam.Project.version),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .Project.Shared.Framework.sharedFramework,
                .Project.TCAExamFoundation.TCAExamEntities.tcaExamEntities,
                .Project.TCAExamFoundation.TCAExamShared.tcaExamShared
            ],
            settings: .swift6
        ),
        .target(
            name: "MusicPlayerManagerTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.grohong.MusicPlayerManagerTests",
            deploymentTargets: .iOS(TCAExam.Project.version),
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "MusicPlayerManager")]
        ),
    ]
)

