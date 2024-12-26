//
//  Project.swift
//  Packages
//
//  Created by Hong Seong Ho on 12/26/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "AlbumList",
    targets: [
        .target(
            name: "AlbumList",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.grohong.AlbumList",
            deploymentTargets: .iOS(TCAExam.Project.version),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .External.composableArchitecture,
                .Project.TCAExamFoundation.TCAExamEntities.tcaExamEntities,
                .Project.TCAExamFoundation.TCAExamShared.tcaExamShared,
                .Project.TCAExamFoundation.TCAExamViews.tcaExamViews
            ],
            settings: .swift6
        ),
        .target(
            name: "AlbumListTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.grohong.AlbumListTests",
            deploymentTargets: .iOS(TCAExam.Project.version),
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "AlbumList")]
        ),
        .target(
            name: "AlbumListExample",
            destinations: .iOS,
            product: .app,
            bundleId: "com.grohong.AlbumListExample",
            deploymentTargets: .iOS(TCAExam.Project.version),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "NSAppleMusicUsageDescription": "이 앱은 사용자의 Apple Music 데이터에 접근하여 앨범 정보를 제공합니다."
                ]
            ),
            sources: ["Example/Sources/**"],
            dependencies: [
                .target(name: "AlbumList")
            ],
            settings: .swift6
        )
    ]
)
