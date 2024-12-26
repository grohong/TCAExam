//
//  ProjectDependencies.swift
//  Packages
//
//  Created by Hong Seong Ho on 12/26/24.
//

import ProjectDescription

public extension TargetDependency {

    enum Project {

        public enum TCAExamFoundation {

            public enum TCAExamEntities {

                static let path = "Projects/TCAExamFoundation/TCAExamEntities"

                public static let tcaExamEntities: TargetDependency = .project(target: "TCAExamEntities", path: .relativeToRoot(path))
            }

            public enum TCAExamShared {

                static let path = "Projects/TCAExamFoundation/TCAExamShared"

                public static let tcaExamShared: TargetDependency = .project(target: "TCAExamShared", path: .relativeToRoot(path))
                public static let tests: TargetDependency = .project(target: "TCAExamSharedTests", path: .relativeToRoot(path))
            }

            public enum TCAExamViews {

                static let path = "Projects/TCAExamFoundation/TCAExamViews"

                public static let tcaExamViews: TargetDependency = .project(target: "TCAExamViews", path: .relativeToRoot(path))
                public static let tests: TargetDependency = .project(target: "TCAExamViewsTests", path: .relativeToRoot(path))
                public static let example: TargetDependency = .project(target: "TCAExamViewsExample", path: .relativeToRoot(path))
            }
        }
    }
}
