//
//  ButtonVariantGhostUseCaseTests.swift
//  SparkCoreTests
//
//  Created by janniklas.freundt.ext on 16.05.23.
//  Copyright © 2023 Adevinta. All rights reserved.
//

import XCTest
import SwiftUI
@testable import SparkCore

final class ButtonVariantGhostUseCaseTests: ButtonVariantUseCaseTests {

    // MARK: - Tests
    func test_primary_colors() throws {
        // Given
        let sut = self.sut()

        // When
        let colors = sut.colors(for: .primary, on: self.theme.colors, dims: self.theme.dims)

        // Then
        XCTAssertEqual(
            [colors.textColor,
             colors.backgroundColor,
             colors.pressedBackgroundColor,
             colors.borderColor,
             colors.pressedBorderColor].map(\.color),
            [self.theme.colors.primary.primary,
             ColorTokenDefault.clear,
             self.theme.colors.primary.primary.opacity(self.theme.dims.dim5),
             ColorTokenDefault.clear,
             ColorTokenDefault.clear
            ].map(\.color))
    }

    func test_secondary_colors() throws {
        // Given
        let sut = self.sut()

        // When
        let colors = sut.colors(for: .secondary, on: self.theme.colors, dims: self.theme.dims)

        // Then
        XCTAssertEqual(
            [colors.textColor,
             colors.backgroundColor,
             colors.pressedBackgroundColor,
             colors.borderColor,
             colors.pressedBorderColor].map(\.color),
            [self.theme.colors.secondary.secondary,
             ColorTokenDefault.clear,
             self.theme.colors.secondary.secondary.opacity(self.theme.dims.dim5),
             ColorTokenDefault.clear,
             ColorTokenDefault.clear
            ].map(\.color))
    }

    func test_neutral_colors() throws {
        // Given
        let sut = self.sut()

        // When
        let colors = sut.colors(for: .neutral, on: self.theme.colors, dims: self.theme.dims)

        // Then
        XCTAssertEqual(
            [colors.textColor,
             colors.backgroundColor,
             colors.pressedBackgroundColor,
             colors.borderColor,
             colors.pressedBorderColor].map(\.color),
            [self.theme.colors.feedback.neutral,
             ColorTokenDefault.clear,
             self.theme.colors.feedback.neutral.opacity(self.theme.dims.dim5),
             ColorTokenDefault.clear,
             ColorTokenDefault.clear
            ].map(\.color))
    }

    func test_alert_colors() throws {
        // Given
        let sut = self.sut()

        // When
        let colors = sut.colors(for: .alert, on: self.theme.colors, dims: self.theme.dims)

        // Then
        XCTAssertEqual(
            [colors.textColor,
             colors.backgroundColor,
             colors.pressedBackgroundColor,
             colors.borderColor,
             colors.pressedBorderColor].map(\.color),
            [self.theme.colors.feedback.alert,
             ColorTokenDefault.clear,
             self.theme.colors.feedback.alert.opacity(self.theme.dims.dim5),
             ColorTokenDefault.clear,
             ColorTokenDefault.clear
            ].map(\.color))
    }

    func test_success_colors() throws {
        // Given
        let sut = self.sut()

        // When
        let colors = sut.colors(for: .success, on: self.theme.colors, dims: self.theme.dims)

        // Then
        XCTAssertEqual(
            [colors.textColor,
             colors.backgroundColor,
             colors.pressedBackgroundColor,
             colors.borderColor,
             colors.pressedBorderColor].map(\.color),
            [self.theme.colors.feedback.success,
             ColorTokenDefault.clear,
             self.theme.colors.feedback.success.opacity(self.theme.dims.dim5),
             ColorTokenDefault.clear,
             ColorTokenDefault.clear
            ].map(\.color))
    }

    func test_danger_colors() throws {
        // Given
        let sut = self.sut()

        // When
        let colors = sut.colors(for: .danger, on: self.theme.colors, dims: self.theme.dims)

        // Then
        XCTAssertEqual(
            [colors.textColor,
             colors.backgroundColor,
             colors.pressedBackgroundColor,
             colors.borderColor,
             colors.pressedBorderColor].map(\.color),
            [self.theme.colors.feedback.error,
             ColorTokenDefault.clear,
             self.theme.colors.feedback.error.opacity(self.theme.dims.dim5),
             ColorTokenDefault.clear,
             ColorTokenDefault.clear
            ].map(\.color))
    }

    func test_surface_colors() throws {
        // Given
        let sut = self.sut()

        // When
        let colors = sut.colors(for: .surface, on: self.theme.colors, dims: self.theme.dims)

        // Then
        XCTAssertEqual(
            [colors.textColor,
             colors.backgroundColor,
             colors.pressedBackgroundColor,
             colors.borderColor,
             colors.pressedBorderColor].map(\.color),
            [self.theme.colors.base.surface,
             ColorTokenDefault.clear,
             self.theme.colors.base.surface.opacity(self.theme.dims.dim5),
             ColorTokenDefault.clear,
             ColorTokenDefault.clear
            ].map(\.color))
    }

    // MARK: - Helper Functions
    func sut() -> ButtonVariantGhostUseCase {
        return ButtonVariantGhostUseCase()
    }
}