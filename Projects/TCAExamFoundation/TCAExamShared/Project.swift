//
//  Project.swift
//  Packages
//
//  Created by Hong Seong Ho on 12/26/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "TCAExamShared",
    targets: [
        .target(
            name: "TCAExamShared",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.grohong.TCAExamShared",
            deploymentTargets: .iOS(TCAExam.Project.version),
            infoPlist: .default,
            sources: ["Sources/**"],
            settings: .swift6
        ),
        .target(
            name: "TCAExamSharedTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.grohong.TCAExamSharedTests",
            deploymentTargets: .iOS(TCAExam.Project.version),
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "TCAExamShared")]
        )
    ]
)
