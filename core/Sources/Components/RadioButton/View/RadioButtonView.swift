//
//  RadioButtonView.swift
//  SparkCore
//
//  Created by michael.zimmermann on 05.04.23.
//  Copyright © 2023 Adevinta. All rights reserved.
//

import SwiftUI

/// RadioButtonView is a single radio button control.
/// Radio buttons are used for selecting a single value from a selection of values.
/// The values from which can be selected need to be ``Equatable`` & ``CustomStringConvertible``.
///
/// The radio buttion is created by providing:
/// - A theme
/// - A unique ID
/// - A label representing the value to be selected
/// - The current selected ID: this is a binding and will change, when the button is selected.
/// - State: see ``SparkSelectButtonState``. The default state is ``.enabled``
///
/// **Example**
/// ```swift
///    @State var selectedID: Int = 1
///    var body: any View {
///       VStack(alignment: .leading) {
///           RadioButtonView(theme: theme, id: 1, label: "label 1", selectedID: self.$selectedID)
///           RadioButtonView(theme: theme, id: 2, label: "label 2", selectedID: self.$selectedID)
///       )
///    }
///  ```
///
///  An alternative to using ``RadioButtonViews`` is to use the ``RadioButtonGroupView``.
public struct RadioButtonView<ID: Equatable & CustomStringConvertible>: View {
    // MARK: - Injected Properties

    @ObservedObject private var viewModel: RadioButtonViewModel<ID>

    // MARK: - Local Properties

    @ScaledMetric private var pressedLineWidth: CGFloat = 4
    @ScaledMetric private var lineWidth: CGFloat = 2
    @ScaledMetric private var size: CGFloat = 20
    @ScaledMetric private var filledSize: CGFloat = 10
    @ScaledMetric private var buttonPadding: CGFloat = RadioButtonConstants.radioButtonPadding

    @State private var isPressed: Bool = false

    private var radioButtonSize: CGFloat {
        return size + pressedLineWidth
    }

    // MARK: - Initialization

    /// - Parameters:
    ///   - theme: The theme used for designing colors and font of the radio button.
    ///   - id: A unique ID identifing the value of the item
    ///   - label: A text describing the value
    ///   - selectedID: A binding to which the id of the radio button will be assigned when selected.
    ///   - state: The current state, default value is `.enabled`
    public init(theme: Theme,
                id: ID,
                label: String,
                selectedID: Binding<ID>,
                state: SparkSelectButtonState = .enabled) {
        let viewModel = RadioButtonViewModel(
            theme: theme,
            id: id,
            label: label,
            selectedID: selectedID,
            state: state)
        self.init(viewModel: viewModel)
    }

    init(viewModel: RadioButtonViewModel<ID>) {
        self.viewModel = viewModel
    }

    // MARK: - Content

    public var body: some View {
        Button(action: {
            self.viewModel.setSelected()
        }, label: {
            self.buttonAndLabel()
        })
        .disabled(self.viewModel.isDisabled)
        .opacity(self.viewModel.opacity)
        .buttonStyle(RadioButtonButtonStyle(isPressed: self.$isPressed))
        .padding(buttonPadding)
        .accessibilityIdentifier(RadioButtonAccessibilityIdentifier.radioButton)
        .accessibilityLabel(self.viewModel.label)
        .accessibilityValue(self.viewModel.id.description)
    }

    // MARK: - Private Functions
    
    private func buttonAndLabel() -> some View{
        HStack(alignment: .top, spacing: self.viewModel.spacing) {
            self.radioButton()
                .animation(.easeIn(duration: 0.1), value: self.viewModel.selectedID)

            VStack(alignment: .leading) {
                Text(self.viewModel.label)
                    .font(self.viewModel.font)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(self.viewModel.surfaceColor)

                if let suplementaryLabel = self.viewModel.suplementaryText {
                    Text(suplementaryLabel)
                        .font(self.viewModel.suplemetaryFont)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(self.viewModel.colors.subLabel?.color)
                }
            }
            .padding(.top, self.lineWidth)
        }
    }

    @ViewBuilder
    private func radioButton() -> some View {
        let colors = self.viewModel.colors

        ZStack {
            Circle()
                .strokeBorder(
                    isPressed ? colors.halo.color : .clear,
                    lineWidth: self.pressedLineWidth
                )

            Circle()
                .strokeBorder(
                    colors.button.color,
                    lineWidth: self.lineWidth
                )
                .frame(width: self.size, height: self.size)

            if let fillColor = colors.fill {
                Circle()
                    .fill()
                    .foregroundColor(fillColor.color)
                    .frame(width: self.filledSize, height: self.filledSize)
            }
        }
        .frame(width: self.radioButtonSize,
               height: self.radioButtonSize)
    }

    // MARK: - Button Style

    private struct RadioButtonButtonStyle: ButtonStyle {
        @Binding var isPressed: Bool

        func makeBody(configuration: Self.Configuration) -> some View {
            if configuration.isPressed != self.isPressed {
                DispatchQueue.main.async {
                    self.isPressed = configuration.isPressed
                }
            }
            return configuration.label
                .animation(.easeOut(duration: 0.2), value: self.isPressed)
        }
    }
}
