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
                .External.composableArchitecture,
                .Project.TCAExamFoundation.TCAExamEntities.tcaExamEntities,
                .Project.TCAExamFoundation.TCAExamShared.tcaExamShared,
                .Project.TCAExamFoundation.TCAExamViews.tcaExamViews
            ],
            settings: .settings(
                base: [
                    "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
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
