//
//  ChipComponent.swift
//  SparkDemo
//
//  Created by michael.zimmermann on 17.07.23.
//  Copyright © 2023 Adevinta. All rights reserved.
//

import Spark
import SparkCore
import SwiftUI

struct ChipComponent: View {
    @ObservedObject private var themePublisher = SparkThemePublisher.shared

    var theme: Theme {
        self.themePublisher.theme
    }

    @State private var versionSheetIsPresented = false
    @State var version: ComponentVersion = .uiKit

    @State var intent: ChipIntent = .main
    @State var isIntentPresented = false
    @State var variant: ChipVariant = .filled
    @State var isVariantPresented = false
    @State var showLabel = CheckboxSelectionState.selected
    @State var showIcon = CheckboxSelectionState.selected
    @State var withAction = CheckboxSelectionState.unselected
    @State var withComponent = CheckboxSelectionState.unselected
    @State var showingAlert = false

    private var component = UIImageView(image: UIImage.strokedCheckmark).withTint(.red)
    private let label = "Label"
    private let icon = UIImage(imageLiteralResourceName: "alert")

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Configuration")
                .font(.title2)
                .bold()
                .padding(.bottom, 6)
            VStack(alignment: .leading, spacing: 8) {
                HStack() {
                    Text("Version: ").bold()
                    Button(self.version.name) {
                        self.versionSheetIsPresented = true
                    }
                    .confirmationDialog("Select a version",
                                        isPresented: self.$versionSheetIsPresented) {
                        ForEach(ComponentVersion.allCases, id: \.self) { version in
                            Button(version.name) {
                                self.version = version
                            }
                        }
                    }
                    Spacer()
                }
                HStack() {
                    Text("Intent: ").bold()
                    Button(self.intent.name) {
                        self.isIntentPresented = true
                    }
                    .confirmationDialog("Select an intent", isPresented: self.$isIntentPresented) {
                        ForEach(ChipIntent.allCases, id: \.self) { intent in
                            Button(intent.name) {
                                self.intent = intent
                            }
                        }
                    }
                }
                HStack() {
                    Text("Chip Variant: ").bold()
                    Button(self.variant.name) {
                        self.isVariantPresented = true
                    }
                    .confirmationDialog("Select a variant", isPresented: self.$isVariantPresented) {
                        ForEach(ChipVariant.allCases, id: \.self) { variant in
                            Button(variant.name) {
                                self.variant = variant
                            }
                        }
                    }
                }

                CheckboxView(
                    text: "With Label",
                    checkedImage: DemoIconography.shared.checkmark,
                    theme: theme,
                    state: .enabled,
                    selectionState: self.$showLabel
                )

                CheckboxView(
                    text: "With Icon",
                    checkedImage: DemoIconography.shared.checkmark,
                    theme: theme,
                    state: .enabled,
                    selectionState: self.$showIcon
                )

                CheckboxView(
                    text: "With Action",
                    checkedImage: DemoIconography.shared.checkmark,
                    theme: theme,
                    state: .enabled,
                    selectionState: self.$withAction
                )

                CheckboxView(
                    text: "With Extra Component",
                    checkedImage: DemoIconography.shared.checkmark,
                    theme: theme,
                    state: .enabled,
                    selectionState: self.$withComponent
                )
            }

            Divider()

            Text("Integration")
                .font(.title2)
                .bold()

            if (version == .swiftUI) {
                Text("Not available yet!!")
            } else {
                ChipComponentUIView(
                    theme: self.theme,
                    intent: self.intent,
                    variant: self.variant,
                    label: self.showLabel == .selected ? self.label : nil,
                    icon: self.showIcon == .selected ? self.icon : nil,
                    component: self.withComponent == .selected ? self.component : nil,
                    action: self.withAction == .selected ? { self.showingAlert = true} : nil)
                .alert("Chip Pressed", isPresented: self.$showingAlert) {
                    Button("OK", role: .cancel) { }
                }
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .navigationBarTitle(Text("Chip"))
    }
}

struct ChipComponent_Previews: PreviewProvider {
    static var previews: some View {
        ChipComponent()
    }
}

private extension UIView {
    func withTint(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }
}
