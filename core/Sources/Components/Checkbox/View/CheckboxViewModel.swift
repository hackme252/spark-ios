//
//  CheckboxViewModel.swift
//  SparkCore
//
//  Created by janniklas.freundt.ext on 05.04.23.
//  Copyright © 2023 Adevinta. All rights reserved.
//

import Foundation

final class CheckboxViewModel: ObservableObject {
    // MARK: - Internal properties

    var text: String

    @Published var theming: Theme
    @Published var state: SelectButtonState
    @Published private(set) var colors: CheckboxColorables

    // MARK: - Private properties

    private let colorsUseCase: CheckboxColorsUseCaseable

    // MARK: - Init

    init(
        text: String,
        theming: Theme,
        colorsUseCase: CheckboxColorsUseCaseable = CheckboxColorsUseCase(),
        state: SelectButtonState = .enabled
    ) {
        self.text = text
        self.theming = theming
        self.state = state

        self.colorsUseCase = colorsUseCase
        self.colors = colorsUseCase.execute(from: theming, state: state)
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
            return self.theming.dims.dim3
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
