//
//  Project.swift
//  Packages
//
//  Created by Hong Seong Ho on 12/26/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "TCAExamEntities",
    targets: [
        .target(
            name: "TCAExamEntities",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.grohong.TCAExamEntities",
            deploymentTargets: .iOS(TCAExam.Project.version),
            infoPlist: .default,
            sources: ["Sources/**"]
        )
    ]
)
