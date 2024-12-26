//
//  Project.swift
//  Packages
//
//  Created by Hong Seong Ho on 12/26/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "TCAExamViews",
    targets: [
        .target(
            name: "TCAExamViews",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.grohong.TCAExamViews",
            deploymentTargets: .iOS(TCAExam.Project.version),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .Project.TCAExamFoundation.TCAExamEntities.tcaExamEntities,
                .Project.TCAExamFoundation.TCAExamShared.tcaExamShared
            ],
            settings: .swift6
        ),
        .target(
            name: "TCAExamViewsTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.grohong.TCAExamViewsTests",
            deploymentTargets: .iOS(TCAExam.Project.version),
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "TCAExamViews")],
            settings: .swift6
        ),
        .target(
            name: "TCAExamViewsExample",
            destinations: .iOS,
            product: .app,
            bundleId: "com.grohong.TCAExamViewsExample",
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
                .target(name: "TCAExamViews"),
                .Project.Shared.Mock.sharedMock
            ]
        )
    ]
)
