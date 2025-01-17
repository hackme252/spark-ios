//
//  ButtonViewModelDependencies.swift
//  SparkCore
//
//  Created by robin.lemaire on 03/07/2023.
//  Copyright © 2023 Adevinta. All rights reserved.
//

import Foundation

// sourcery: AutoMockable
protocol ButtonViewModelDependenciesProtocol {
    var getBorderUseCase: ButtonGetBorderUseCaseable { get }
    var getColorsUseCase: ButtonGetColorsUseCaseable { get }
    var getContentUseCase: ButtonGetContentUseCaseable { get }
    var getCurrentColorsUseCase: ButtonGetCurrentColorsUseCaseable { get }
    var getIsIconOnlyUseCase: ButtonGetIsOnlyIconUseCaseable { get }
    var getSizesUseCase: ButtonGetSizesUseCaseable { get }
    var getSpacingsUseCase: ButtonGetSpacingsUseCaseable { get }
    var getStateUseCase: ButtonGetStateUseCaseable { get }

    var getDisplayedTextTypeUseCase: GetDisplayedTextTypeUseCaseable { get }
    var getDidDisplayedTextChangeUseCase: GetDidDisplayedTextChangeUseCaseable { get }

    func makeDisplayedTextViewModel(text: String?,
                                    attributedText: AttributedStringEither?) -> DisplayedTextViewModel
}

struct ButtonViewModelDependencies: ButtonViewModelDependenciesProtocol {

    // MARK: - Properties

    let getBorderUseCase: ButtonGetBorderUseCaseable
    let getColorsUseCase: ButtonGetColorsUseCaseable
    let getContentUseCase: ButtonGetContentUseCaseable
    let getCurrentColorsUseCase: ButtonGetCurrentColorsUseCaseable
    let getIsIconOnlyUseCase: ButtonGetIsOnlyIconUseCaseable
    let getSizesUseCase: ButtonGetSizesUseCaseable
    let getSpacingsUseCase: ButtonGetSpacingsUseCaseable
    let getStateUseCase: ButtonGetStateUseCaseable

    let getDisplayedTextTypeUseCase: GetDisplayedTextTypeUseCaseable
    let getDidDisplayedTextChangeUseCase: GetDidDisplayedTextChangeUseCaseable

    // MARK: - Initialization

    init(
        getBorderUseCase: ButtonGetBorderUseCaseable = ButtonGetBorderUseCase(),
        getColorsUseCase: ButtonGetColorsUseCaseable = ButtonGetColorsUseCase(),
        getContentUseCase: ButtonGetContentUseCaseable = ButtonGetContentUseCase(),
        getCurrentColorsUseCase: ButtonGetCurrentColorsUseCaseable = ButtonGetCurrentColorsUseCase(),
        getIsIconOnlyUseCase: ButtonGetIsOnlyIconUseCaseable = ButtonGetIsOnlyIconUseCase(),
        getSizesUseCase: ButtonGetSizesUseCaseable = ButtonGetSizesUseCase(),
        getSpacingsUseCase: ButtonGetSpacingsUseCaseable = ButtonGetSpacingsUseCase(),
        getStateUseCase: ButtonGetStateUseCaseable = ButtonGetStateUseCase(),
        getDisplayedTextTypeUseCase: GetDisplayedTextTypeUseCaseable = GetDisplayedTextTypeUseCase(),
        getDidDisplayedTextChangeUseCase: GetDidDisplayedTextChangeUseCaseable = GetDidDisplayedTextChangeUseCase()
    ) {
        self.getBorderUseCase = getBorderUseCase
        self.getColorsUseCase = getColorsUseCase
        self.getContentUseCase = getContentUseCase
        self.getCurrentColorsUseCase = getCurrentColorsUseCase
        self.getIsIconOnlyUseCase = getIsIconOnlyUseCase
        self.getSizesUseCase = getSizesUseCase
        self.getSpacingsUseCase = getSpacingsUseCase
        self.getStateUseCase = getStateUseCase
        self.getDisplayedTextTypeUseCase = getDisplayedTextTypeUseCase
        self.getDidDisplayedTextChangeUseCase = getDidDisplayedTextChangeUseCase
    }

    // MARK: - Maker

    func makeDisplayedTextViewModel(
        text: String?,
        attributedText: AttributedStringEither?
    ) -> DisplayedTextViewModel {
        return DisplayedTextViewModelDefault(
            text: text,
            attributedText: attributedText
        )
    }
}
