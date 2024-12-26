//
//  ExternalDependencies.swift
//  Config
//
//  Created by Hong Seong Ho on 12/26/24.
//

import ProjectDescription

public extension TargetDependency {

    enum External {

        public static let composableArchitecture: TargetDependency = .external(name: "ComposableArchitecture")
    }
}
