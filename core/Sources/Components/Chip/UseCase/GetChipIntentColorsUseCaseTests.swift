//
//  GetChipIntentColorsUseCaseTests.swift
//  SparkCoreTests
//
//  Created by michael.zimmermann on 09.05.23.
//  Copyright © 2023 Adevinta. All rights reserved.
//

import XCTest

@testable import SparkCore

final class GetChipIntentColorsUseCaseTests: XCTestCase {

    // MARK: - Properties
    private var sut: GetChipIntentColorsUseCase!
    private var colors: ColorsGeneratedMock!

    // MARK: - Setup
    override func setUpWithError() throws {
        try super.setUpWithError()

        self.sut = GetChipIntentColorsUseCase()
        self.colors = ColorsGeneratedMock()
    }

    // MARK: - Tests
    func test_primary_color() {
        // Given
        let primary = ColorsPrimaryGeneratedMock()
        primary.primary = ColorTokenGeneratedMock(uiColor: .blue)
        primary.onPrimary = ColorTokenGeneratedMock(uiColor: .gray)
        primary.primaryContainer = ColorTokenGeneratedMock(uiColor: .yellow)
        primary.onPrimaryContainer = ColorTokenGeneratedMock(uiColor: .red)

        self.colors.primary = primary

        // When
        let chipIntentColors = self.sut.execute(colors: self.colors, intentColor: .primary)

        // Then
        XCTAssertEqual([chipIntentColors.principal,
                        chipIntentColors.subordinate,
                        chipIntentColors.tintedPrincipal,
                        chipIntentColors.tintedSubordinate].map(\.uiColor),
                       [UIColor.blue, .gray, .yellow, .red])
    }

    func test_secondary_color() {
        // Given
        let secondary = ColorsSecondaryGeneratedMock()
        secondary.secondary = ColorTokenGeneratedMock(uiColor: .blue)
        secondary.onSecondary = ColorTokenGeneratedMock(uiColor: .gray)
        secondary.secondaryContainer = ColorTokenGeneratedMock(uiColor: .yellow)
        secondary.onSecondaryContainer = ColorTokenGeneratedMock(uiColor: .red)

        self.colors.secondary = secondary

        // When
        let chipIntentColors = self.sut.execute(colors: self.colors, intentColor: .secondary)

        // Then
        XCTAssertEqual([chipIntentColors.principal,
                        chipIntentColors.subordinate,
                        chipIntentColors.tintedPrincipal,
                        chipIntentColors.tintedSubordinate].map(\.uiColor),
                       [UIColor.blue, .gray, .yellow, .red])

    }

    func test_surface_colors() {
        // Given
        let base = ColorsBaseGeneratedMock()
        base.surface = ColorTokenGeneratedMock(uiColor: .blue)
        base.onSurface = ColorTokenGeneratedMock(uiColor: .gray)

        self.colors.base = base

        // When
        let chipIntentColors = self.sut.execute(colors: self.colors, intentColor: .surface)

        // Then
        XCTAssertEqual([chipIntentColors.principal,
                        chipIntentColors.subordinate,
                        chipIntentColors.tintedPrincipal,
                        chipIntentColors.tintedSubordinate].map(\.uiColor),
                       [UIColor.blue, .gray, .blue, .gray])


    }

    func test_neutral_colors() {
        // Given
        let feedback = ColorsFeedbackGeneratedMock()
        feedback.neutral = ColorTokenGeneratedMock(uiColor: .blue)
        feedback.onNeutral = ColorTokenGeneratedMock(uiColor: .gray)
        feedback.neutralContainer = ColorTokenGeneratedMock(uiColor: .yellow)
        feedback.onNeutralContainer = ColorTokenGeneratedMock(uiColor: .red)

        self.colors.feedback = feedback

        // When
        let chipIntentColors = self.sut.execute(colors: self.colors, intentColor: .neutral)

        // Then
        XCTAssertEqual([chipIntentColors.principal,
                        chipIntentColors.subordinate,
                        chipIntentColors.tintedPrincipal,
                        chipIntentColors.tintedSubordinate].map(\.uiColor),
                       [UIColor.blue, .gray, .yellow, .red])
    }

    func test_info_colors() {
        // Given
        let feedback = ColorsFeedbackGeneratedMock()
        feedback.info = ColorTokenGeneratedMock(uiColor: .blue)
        feedback.onInfo = ColorTokenGeneratedMock(uiColor: .gray)
        feedback.infoContainer = ColorTokenGeneratedMock(uiColor: .yellow)
        feedback.onInfoContainer = ColorTokenGeneratedMock(uiColor: .red)

        self.colors.feedback = feedback

        // When
        let chipIntentColors = self.sut.execute(colors: self.colors, intentColor: .info)

        // Then
        XCTAssertEqual([chipIntentColors.principal,
                        chipIntentColors.subordinate,
                        chipIntentColors.tintedPrincipal,
                        chipIntentColors.tintedSubordinate].map(\.uiColor),
                       [UIColor.blue, .gray, .yellow, .red])
    }

    func test_success_colors() {
        // Given
        let feedback = ColorsFeedbackGeneratedMock()
        feedback.success = ColorTokenGeneratedMock(uiColor: .blue)
        feedback.onSuccess = ColorTokenGeneratedMock(uiColor: .gray)
        feedback.successContainer = ColorTokenGeneratedMock(uiColor: .yellow)
        feedback.onSuccessContainer = ColorTokenGeneratedMock(uiColor: .red)

        self.colors.feedback = feedback

        // When
        let chipIntentColors = self.sut.execute(colors: self.colors, intentColor: .success)

        // Then
        XCTAssertEqual([chipIntentColors.principal,
                        chipIntentColors.subordinate,
                        chipIntentColors.tintedPrincipal,
                        chipIntentColors.tintedSubordinate].map(\.uiColor),
                       [UIColor.blue, .gray, .yellow, .red])
    }

    func test_alert_colors() {
        // Given
        let feedback = ColorsFeedbackGeneratedMock()
        feedback.alert = ColorTokenGeneratedMock(uiColor: .blue)
        feedback.onAlert = ColorTokenGeneratedMock(uiColor: .gray)
        feedback.alertContainer = ColorTokenGeneratedMock(uiColor: .yellow)
        feedback.onAlertContainer = ColorTokenGeneratedMock(uiColor: .red)

        self.colors.feedback = feedback

        // When
        let chipIntentColors = self.sut.execute(colors: self.colors, intentColor: .alert)

        // Then
        XCTAssertEqual([chipIntentColors.principal,
                        chipIntentColors.subordinate,
                        chipIntentColors.tintedPrincipal,
                        chipIntentColors.tintedSubordinate].map(\.uiColor),
                       [UIColor.blue, .gray, .yellow, .red])
    }

    func test_danger_colors() {
        // Given
        let feedback = ColorsFeedbackGeneratedMock()
        feedback.error = ColorTokenGeneratedMock(uiColor: .blue)
        feedback.onError = ColorTokenGeneratedMock(uiColor: .gray)
        feedback.errorContainer = ColorTokenGeneratedMock(uiColor: .yellow)
        feedback.onErrorContainer = ColorTokenGeneratedMock(uiColor: .red)

        self.colors.feedback = feedback

        // When
        let chipIntentColors = self.sut.execute(colors: self.colors, intentColor: .danger)

        // Then
        XCTAssertEqual([chipIntentColors.principal,
                        chipIntentColors.subordinate,
                        chipIntentColors.tintedPrincipal,
                        chipIntentColors.tintedSubordinate].map(\.uiColor),
                       [UIColor.blue, .gray, .yellow, .red])
    }
}

// MARK: - Private helpers
private extension ColorTokenGeneratedMock {
    convenience init(uiColor: UIColor) {
        self.init()
        self.uiColor = uiColor
    }
}
