//
//  Project.swift
//  AlbumListManifests
//
//  Created by Hong Seong Ho on 12/27/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "SharedMock",
    targets: [
        .target(
            name: "SharedMock",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.grohong.SharedMock",
            deploymentTargets: .iOS(TCAExam.Project.version),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .Project.TCAExamFoundation.TCAExamEntities.tcaExamEntities
            ]
        )
    ]
)
