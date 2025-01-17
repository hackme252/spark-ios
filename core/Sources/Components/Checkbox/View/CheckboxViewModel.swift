//
//  CheckboxViewModel.swift
//  SparkCore
//
//  Created by janniklas.freundt.ext on 05.04.23.
//  Copyright © 2023 Adevinta. All rights reserved.
//

import Combine
import SwiftUI
import UIKit

final class CheckboxViewModel: ObservableObject {
    // MARK: - Internal properties

    var text: String?
    var attributedText: NSAttributedString?
    var checkedImage: UIImage

    @Published var state: SelectButtonState {
        didSet {
            guard oldValue != state else { return }

            self.updateColors()
        }
    }

    @Published var theme: Theme {
        didSet {
            self.updateColors()
        }
    }

    @Published var colors: CheckboxColorables

    var colorsUseCase: CheckboxColorsUseCaseable {
        didSet {
            self.updateColors()
        }
    }

    // MARK: - Init

    init(
        text: Either<NSAttributedString, String>,
        checkedImage: UIImage,
        theme: Theme,
        colorsUseCase: CheckboxColorsUseCaseable = CheckboxColorsUseCase(),
        state: SelectButtonState = .enabled
    ) {
        switch text {
        case .left(let attributedString):
            self.attributedText = attributedString
            self.text = attributedString.string
        case .right(let string):
            self.attributedText = nil
            self.text = string
        }
        self.checkedImage = checkedImage
        self.theme = theme
        self.state = state

        self.colorsUseCase = colorsUseCase
        self.colors = colorsUseCase.execute(from: theme, state: state)
    }

    // MARK: - Methods

    private func updateColors() {
        self.colors = self.colorsUseCase.execute(from: self.theme, state: self.state)
    }

    func update(content: Either<NSAttributedString, String>) {
        switch content {
        case .left(let attributedString):
            self.attributedText = attributedString
            self.text = attributedString.string
        case .right(let string):
            self.text = string
            self.attributedText = nil
        }
    }

    // MARK: - Computed properties

    var interactionEnabled: Bool {
        switch state {
        case .disabled:
            return false
        default:
            return true
        }
    }

    var opacity: CGFloat {
        switch self.state {
        case .disabled:
            return self.theme.dims.dim3
        default:
            return 1.0
        }
    }

    var supplementaryMessage: String? {
        switch self.state {
        case .error(let message), .success(let message), .warning(let message):
            return message
        default:
            return nil
        }
    }
}
