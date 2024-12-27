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

        public enum Features {

            public enum AlbumList {

                static let path = "Projects/Features/AlbumList"

                public static let albumList: TargetDependency = .project(target: "AlbumList", path: .relativeToRoot(path))
                public static let tests: TargetDependency = .project(target: "AlbumListTests", path: .relativeToRoot(path))
                public static let example: TargetDependency = .project(target: "AlbumListExample", path: .relativeToRoot(path))
            }

            public enum Album {

                static let path = "Projects/Features/Album"

                public static let album: TargetDependency = .project(target: "Album", path: .relativeToRoot(path))
                public static let example: TargetDependency = .project(target: "AlbumExample", path: .relativeToRoot(path))
            }

            public enum MusicPlayer {

                static let path = "Projects/Features/MusicPlayer"

                public static let musicPlayer: TargetDependency = .project(target: "MusicPlayer", path: .relativeToRoot(path))
                public static let tests: TargetDependency = .project(target: "MusicPlayerTests", path: .relativeToRoot(path))
                public static let example: TargetDependency = .project(target: "MusicPlayerExample", path: .relativeToRoot(path))
            }
        }

        public enum Manager {

            public enum MusicPlayerManager {

                static let path = "Projects/Manager/MusicPlayerManager"

                public static let musicPlayerManager: TargetDependency = .project(target: "MusicPlayerManager", path: .relativeToRoot(path))
                public static let tests: TargetDependency = .project(target: "MusicPlayerManagerTests", path: .relativeToRoot(path))
            }
        }

        public enum Shared {

            public enum Framework {

                static let path = "Projects/Shared/Framework"

                public static let sharedFramework: TargetDependency = .project(target: "SharedFramework", path: .relativeToRoot(path))
            }

            public enum Mock {

                static let path = "Projects/Shared/Mock"

                public static let sharedMock: TargetDependency = .project(target: "SharedMock", path: .relativeToRoot(path))
            }
        }
    }
}
