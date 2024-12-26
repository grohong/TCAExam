//
//  SharedFramework.swift
//  AlbumListManifests
//
//  Created by Hong Seong Ho on 12/26/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "SharedFramework",
    targets: [
        .target(
            name: "SharedFramework",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.grohong.SharedFramework",
            deploymentTargets: .iOS(TCAExam.Project.version),
            infoPlist: .default,
            sources: [],
            dependencies: [
                .External.composableArchitecture,
            ]
        )
    ]
)
