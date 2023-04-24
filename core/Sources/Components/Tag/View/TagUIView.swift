//
//  TagUIView.swift
//  SparkCore
//
//  Created by robin.lemaire on 17/04/2023.
//  Copyright © 2023 Adevinta. All rights reserved.
//

import UIKit

public final class TagUIView: UIView {

    // MARK: - Type alias

    private typealias AccessibilityIdentifier = TagAccessibilityIdentifier

    // MARK: - Components

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews:
                                        [
                                            self.iconImageView,
                                            self.textLabel
                                        ])
        stackView.axis = .horizontal
        return stackView
    }()

    private var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.accessibilityIdentifier = AccessibilityIdentifier.iconImage
        return imageView
    }()

    private var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = AccessibilityIdentifier.text
        return label
    }()

    // MARK: - Public Properties

    public var theme: Theme {
        didSet {
            self._colors = self.getColorsFromUseCase()
            self.reloadUIFromTheme()
        }
    }

    public var intentColor: TagIntentColor {
        didSet {
            self._colors = self.getColorsFromUseCase()
        }
    }
    
    public var variant: TagVariant {
        didSet {
            self._colors = self.getColorsFromUseCase()
        }
    }

    public var iconImage: UIImage? {
        didSet {
            self.reloadIconImageView()
        }
    }

    public var text: String? {
        didSet {
            self.reloadTextLabel()
        }
    }

    // MARK: - Private Properties

    private var heightConstraint: NSLayoutConstraint?

    private var contentStackViewLeadingConstraint: NSLayoutConstraint?
    private var contentStackViewTopConstraint: NSLayoutConstraint?
    private var contentStackViewTrailingConstraint: NSLayoutConstraint?
    private var contentStackViewBottomConstraint: NSLayoutConstraint?

    private var _height: CGFloat? {
        didSet {
            self.reloadUIFromHeight()
        }
    }
    private var height: CGFloat {
        // Init value from use case only if value is nil
        guard let height = self._height else {
            let height = self.getHeightFromUseCase()
            self._height = height
            return height
        }

        return height
    }

    private var _colors: TagColorables? {
        didSet {
            self.reloadUIFromColors()
        }
    }
    private var colors: TagColorables {
        // Init value from use case only if value is nil
        guard let colors = self._colors else {
            let colors = self.getColorsFromUseCase()
            self._colors = colors
            return colors
        }

        return colors
    }

    private let getColorsUseCase: TagGetColorsUseCaseable
    private let getHeightUseCase: TagGetHeightUseCaseable

    // MARK: - Initialization

    public convenience init(theme: Theme,
                            intentColor: TagIntentColor,
                            variant: TagVariant,
                            iconImage: UIImage) {
        self.init(theme,
                  intentColor: intentColor,
                  variant: variant,
                  iconImage: iconImage,
                  text: nil)
    }

    public convenience init(theme: Theme,
                            intentColor: TagIntentColor,
                            variant: TagVariant,
                            text: String) {
        self.init(theme,
                  intentColor: intentColor,
                  variant: variant,
                  iconImage: nil,
                  text: text)
    }

    public convenience init(theme: Theme,
                            intentColor: TagIntentColor,
                            variant: TagVariant,
                            iconImage: UIImage,
                            text: String) {
        self.init(theme,
                  intentColor: intentColor,
                  variant: variant,
                  iconImage: iconImage,
                  text: text)
    }

    private init(_ theme: Theme,
                 intentColor: TagIntentColor,
                 variant: TagVariant,
                 iconImage: UIImage?,
                 text: String?,
                 getColorsUseCase: TagGetColorsUseCaseable = TagGetColorsUseCase(),
                 getHeightUseCase: TagGetHeightUseCaseable = TagGetHeightUseCase()) {
        self.theme = theme
        self.intentColor = intentColor
        self.variant = variant
        self.iconImage = iconImage
        self.text = text
        self.getColorsUseCase = getColorsUseCase
        self.getHeightUseCase = getHeightUseCase

        super.init(frame: .zero)

        self.setupView()
        self.loadUI()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View setup

    private func setupView() {
        // Add subview
        self.addSubview(self.contentStackView)

        // Setup constraints
        self.setupConstraints()
    }

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        self.setCornerRadius(self.theme.border.radius.full)
    }

    // MARK: - Load UI

    private func loadUI() {
        self.reloadIconImageView()
        self.reloadTextLabel()
        self.reloadUIFromTheme()
        self.reloadUIFromColors()
        self.reloadUIFromHeight()
    }

    private func reloadIconImageView() {
        self.iconImageView.image = self.iconImage
        self.iconImageView.isHidden = (self.iconImage == nil)
    }

    private func reloadTextLabel() {
        self.textLabel.text = self.text
        self.textLabel.isHidden = (self.text == nil)
    }

    private func reloadUIFromTheme() {
        // View
        self.setBorderWidth(self.theme.border.width.small)
        self.setMasksToBounds(true)

        // Subviews
        self.contentStackView.spacing = self.theme.layout.spacing.small
        self.textLabel.font = self.theme.typography.captionHighlight.uiFont

        // Constraint
        self.contentStackViewLeadingConstraint?.constant = self.theme.layout.spacing.medium
        self.contentStackViewTopConstraint?.constant = self.theme.layout.spacing.small
        self.contentStackViewTrailingConstraint?.constant = -self.theme.layout.spacing.medium
        self.contentStackViewBottomConstraint?.constant = -self.theme.layout.spacing.small
        self.contentStackView.layoutIfNeeded()
    }

    private func reloadUIFromColors() {
        // View
        self.backgroundColor = self.colors.backgroundColor.uiColor
        self.setBorderColor(from: self.colors.borderColor)

        // Subviews
        self.iconImageView.tintColor = self.colors.foregroundColor.uiColor
        self.textLabel.textColor = self.colors.foregroundColor.uiColor
    }

    private func reloadUIFromHeight() {
        // Reload height only if value changed
        if self.height != self.heightConstraint?.constant {
            self.heightConstraint?.constant = self.height
            self.layoutIfNeeded()
        }
    }

    // MARK: - Constraints

    private func setupConstraints() {
        self.setupViewConstraints()
        self.setupContentStackViewConstraints()
        self.setupIconImageViewConstraints()
    }

    private func setupViewConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false

        self.heightConstraint = self.heightAnchor.constraint(equalToConstant: self.height)
        self.heightConstraint?.isActive = true
    }

    private func setupContentStackViewConstraints() {
        self.contentStackView.translatesAutoresizingMaskIntoConstraints = false

        self.contentStackViewLeadingConstraint = self.contentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        self.contentStackViewTopConstraint = self.contentStackView.topAnchor.constraint(equalTo: self.topAnchor)
        self.contentStackViewTrailingConstraint = self.contentStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        self.contentStackViewBottomConstraint = self.contentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)

        self.contentStackViewLeadingConstraint?.isActive = true
        self.contentStackViewTopConstraint?.isActive = true
        self.contentStackViewTrailingConstraint?.isActive = true
        self.contentStackViewBottomConstraint?.isActive = true
    }

    private func setupIconImageViewConstraints() {
        self.iconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.iconImageView.widthAnchor.constraint(equalTo: self.contentStackView.heightAnchor).isActive = true
    }

    // MARK: - Getter

    private func getColorsFromUseCase() -> TagColorables {
        return self.getColorsUseCase.execute(from: self.theme,
                                             intentColor: self.intentColor,
                                             variant: self.variant)
    }

    private func getHeightFromUseCase() -> CGFloat {
        return self.getHeightUseCase.execute(from: self.traitCollection.preferredContentSizeCategory)
    }

    // MARK: - Trait Collection

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        // Reload colors ?
        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            self.reloadUIFromColors()
        }

        // Update height content ?
        if self.traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
            self._height = self.getHeightFromUseCase()
        }
    }
}
