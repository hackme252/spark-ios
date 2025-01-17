//
//  IconUIViewTests.swift
//  SparkCore
//
//  Created by Jacklyn Situmorang on 17.07.23.
//  Copyright © 2023 Adevinta. All rights reserved.
//

import XCTest

@testable import Spark
@testable import SparkCore

final class IconUIViewTests: UIKitComponentTestCase {

    //MARK: Tests
    func test_icon_intent() {
        for intent in IconIntent.allCases {
            let iconView = IconUIView(
                iconImage: UIImage(systemName: "lock.circle"),
                theme: SparkTheme.shared,
                intent: intent,
                size: .medium
            )
            assertSnapshotInDarkAndLight(matching: iconView, testName: "\(#function)-\(intent)")
        }
    }

    func test_icon_size() {
        for size in IconSize.allCases {
            let iconView = IconUIView(
                iconImage: UIImage(systemName: "lock.circle"),
                theme: SparkTheme.shared,
                intent: .neutral,
                size: size
            )
            assertSnapshotInDarkAndLight(matching: iconView, testName: "\(#function)-\(size)")
        }
    }
}
