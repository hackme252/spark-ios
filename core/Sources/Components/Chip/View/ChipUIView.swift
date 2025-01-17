//
//  ChipUIView.swift
//  SparkCore
//
//  Created by michael.zimmermann on 02.05.23.
//  Copyright © 2023 Adevinta. All rights reserved.
//

import Combine
import UIKit

public final class ChipUIView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let imageSize: CGFloat = 13.33
        static let height: CGFloat = 32
        static let borderWidth: CGFloat = 1
        static let dashLength: CGFloat = 1.9
    }

    //MARK: - Public properties
    /// An optional icon on the Chip. The icon is always rendered to the left of the text
    public var icon: UIImage? {
        set {
            self.imageView.image = newValue
            if (newValue != nil) {
                self.stackView.insertArrangedSubview(self.imageView, at: 0)
            } else {
                self.stackView.removeArrangedSubview(self.imageView)
            }
        }
        get {
            return self.imageView.image
        }
    }

    /// An optional text shown on the Chip. The text is rendered to the right of the icon.
    public var text: String? {
        set {
            self.textLabel.text = newValue
            if (newValue != nil) {
                self.stackView.addArrangedSubview(self.textLabel)
            } else {
                self.stackView.removeArrangedSubview(self.textLabel)
            }
        }
        get {
            return self.textLabel.text
        }
    }

    /// An optional action. If the action is given, the Chip will act like a button and have a pressed state.
    public var action: (() -> ())? {
        didSet {
            setupButtonActions()
        }
    }

    /// The intent of the chip.
    public var intent: ChipIntent {
        set {
            self.viewModel.set(intent: newValue)
        }
        get {
            return self.viewModel.intent
        }
    }

    /// The variant of the chip
    public var variant: ChipVariant {
        set {
            self.viewModel.set(variant: newValue)
        }
        get {
            return self.viewModel.variant
        }
    }

    /// The theme.
    public var theme: Theme {
        set {
            self.viewModel.set(theme: newValue)
        }
        get {
            return self.viewModel.theme
        }
    }

    /// Optional component whicl will be rendered to the right of the label.
    /// Note: the client must be responsible, that it fits within the chip which has a height of 32pts
    public var component: UIView? {
        willSet {
            self.component?.removeFromSuperview()
            if let component = self.component {
                self.stackView.removeArrangedSubview(component)
            }
        }
        didSet {
            if let component = self.component {
                self.stackView.addArrangedSubview(component)
            }
        }
    }

    //MARK: - Private properties
    private let viewModel: ChipViewModel

    private var dashBorder: CAShapeLayer?

    @ScaledUIMetric private var imageSize = Constants.imageSize
    @ScaledUIMetric private var height = Constants.height
    @ScaledUIMetric private var borderWidth = Constants.borderWidth
    @ScaledUIMetric private var dashLength = Constants.dashLength
    @ScaledUIMetric private var spacing: CGFloat
    @ScaledUIMetric private var padding: CGFloat
    @ScaledUIMetric private var borderRadius: CGFloat

    private let textLabel: UILabel = {
        let label = UILabel()
        label.isAccessibilityElement = false
        label.contentMode = .scaleAspectFit
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.defaultHigh,
                                                      for: .horizontal)
        label.setContentCompressionResistancePriority(.required,
                                                      for: .vertical)
        return label
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isAccessibilityElement = false
        imageView.setContentCompressionResistancePriority(.required,
                                                          for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required,
                                                          for: .vertical)
        return imageView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let button: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = true
        button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return button
    }()

    private var sizeConstraints: [NSLayoutConstraint] = []
    private var heightConstraint: NSLayoutConstraint?
    private var subscriptions = Set<AnyCancellable>()

    //MARK: - Initializers

    /// Initializer of a chip containing only an icon.
    ///
    /// Parameters:
    /// - theme: The theme.
    /// - intent: The intent of the chip, e.g. main, support
    /// - variant: The chip variant, e.g. outlined, filled
    /// - iconImage: An icon
    public convenience init(theme: Theme,
                            intent: ChipIntent,
                            variant: ChipVariant,
                            iconImage: UIImage) {
        self.init(theme: theme, intent: intent, variant: variant, optionalLabel: nil, optionalIconImage: iconImage)
    }

    /// Initializer of a chip containing only a text.
    ///
    /// Parameters:
    /// - theme: The theme.
    /// - intent: The intent of the chip, e.g. main, support
    /// - variant: The chip variant, e.g. outlined, filled
    /// - text: The text label
    public convenience init(theme: Theme,
                            intent: ChipIntent,
                            variant: ChipVariant,
                            label: String) {
        self.init(theme: theme, intent: intent, variant: variant, optionalLabel: label, optionalIconImage: nil)
    }

    /// Initializer of a chip containing both a text and an icon.
    ///
    /// Parameters:
    /// - theme: The theme.
    /// - intent: The intent of the chip, e.g. main, support
    /// - variant: The chip variant, e.g. outlined, filled
    /// - text: The text label
    /// - iconImage: An icon
    public convenience init(theme: Theme,
                            intent: ChipIntent,
                            variant: ChipVariant,
                            label: String,
                            iconImage: UIImage) {
        self.init(theme: theme, intent: intent, variant: variant, optionalLabel: label , optionalIconImage: iconImage)
    }

    init(theme: Theme,
         intent: ChipIntent,
         variant: ChipVariant,
         optionalLabel: String?,
         optionalIconImage: UIImage?) {

        self.viewModel = ChipViewModel(theme: theme, variant: variant, intent: intent)
        self.spacing = self.viewModel.spacing
        self.padding = self.viewModel.padding
        self.borderRadius = self.viewModel.borderRadius

        super.init(frame: CGRect.zero)

        self.icon = optionalIconImage
        self.text = optionalLabel
        self.textLabel.sizeToFit()

        self.setupView()

    }

    /// Function traitCollectionDidChange: all dynamic sizing and padding will be recalculated here
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        self.updateScaledMetrics()

        self.sizeConstraints.forEach{
            $0.constant = self.imageSize
        }

        self.stackView.spacing = self.spacing
        self.heightConstraint?.constant = self.height

        self.updateLayoutMargins()
        self.updateBorder()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.removeDashedBorder()

        if self.viewModel.isBorderDashed {
            self.addDashedBorder(borderColor: self.viewModel.colors.default.border)
        }
    }

    //MARK: - Private functions
    /// Update all colors used
    private func setChipColors(_ chipColors: ChipStateColors) {
        self.stackView.backgroundColor = chipColors.background.uiColor
        self.textLabel.textColor = chipColors.foreground.uiColor
        self.imageView.tintColor = chipColors.foreground.uiColor

        self.removeDashedBorder()

        if self.viewModel.isBorderDashed {
            self.addDashedBorder(borderColor: chipColors.border)
        } else if viewModel.isBordered {
            self.stackView.layer.borderWidth = self.borderWidth
            self.stackView.layer.borderColor = chipColors.border.uiColor.cgColor
        } else {
            self.stackView.layer.borderWidth = 0
            self.stackView.layer.borderColor = nil
        }
    }

    /// Update all scaled metrics
    private func updateScaledMetrics() {
        self._imageSize.update(traitCollection: self.traitCollection)
        self._height.update(traitCollection: self.traitCollection)
        self._spacing.update(traitCollection: self.traitCollection)
        self._padding.update(traitCollection: self.traitCollection)
        self._borderRadius.update(traitCollection: self.traitCollection)
        self._borderWidth.update(traitCollection: self.traitCollection)
        self._dashLength.update(traitCollection: self.traitCollection)
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(self.stackView)
        self.addSubview(self.button)
        self.button.frame = self.bounds

        self.updateFont()
        self.updateSpacing()
        self.updateLayoutMargins()

        self.setupConstraints()
        self.setChipColors(self.viewModel.colors.default)
        self.setupSubscriptions()
    }

    private func updateLayoutMargins() {
        self.stackView.layoutMargins = UIEdgeInsets(top: 0, left: self.padding, bottom: 0, right: self.padding)
    }

    private func updateSpacing() {
        self.stackView.spacing = self.spacing
    }

    private func updateBorder() {
        self.stackView.layer.cornerRadius = self.borderRadius
        self.removeDashedBorder()
        self.stackView.layer.borderWidth = 0

        if self.viewModel.isBorderDashed {
            self.addDashedBorder(borderColor: self.viewModel.colors.default.border)
        } else if self.viewModel.isBordered {
            self.stackView.layer.borderWidth = self.borderWidth
        }
    }

    private func removeDashedBorder() {
        self.dashBorder?.removeFromSuperlayer()
        self.dashBorder = nil
    }

    private func updateFont() {
        self.textLabel.font = self.viewModel.font.uiFont
    }

    private func setupConstraints() {
        let heightConstraint = self.stackView.heightAnchor.constraint(equalToConstant: self.height)

        let sizeConstraints = [
            self.imageView.heightAnchor.constraint(equalToConstant: self.imageSize),
            self.imageView.widthAnchor.constraint(equalToConstant: self.imageSize)
        ]

        let stackConstraints = [
            self.stackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            heightConstraint,
            self.stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ]

        NSLayoutConstraint.activate(stackConstraints)

        self.stackView.layer.cornerRadius = self.borderRadius
        self.stackView.layer.masksToBounds = true

        self.sizeConstraints = sizeConstraints
        self.heightConstraint = heightConstraint

        if self.icon == nil {
            self.imageView.isHidden = true
        } else {
            NSLayoutConstraint.activate(sizeConstraints)
        }

        if self.text == nil {
            self.textLabel.isHidden = true
        }
    }

    private func setupSubscriptions() {
        self.viewModel.$colors.subscribe(in: &self.subscriptions) { [weak self] colors in
            self?.setChipColors(colors.default)
        }

        self.viewModel.$spacing.subscribe(in: &self.subscriptions) { [weak self] spacing in
            guard let self else { return }
            self.spacing = spacing
            self.updateSpacing()
        }

        self.viewModel.$padding.subscribe(in: &self.subscriptions) { [weak self] padding in
            guard let self else { return }
            self.padding = padding
            self.updateLayoutMargins()
        }
        
        self.viewModel.$borderRadius.subscribe(in: &self.subscriptions) { [weak self] borderRadius in
            guard let self else { return }
            self.borderRadius = borderRadius
            self.updateBorder()
        }

        self.viewModel.$font.subscribe(in: &self.subscriptions) { [weak self] _ in
            self?.updateFont()
        }
    }

    private func addDashedBorder(borderColor: any ColorToken) {
        let dashBorder = CAShapeLayer()
        let bounds = self.stackView.bounds
        dashBorder.lineWidth = self.borderWidth
        dashBorder.strokeColor = borderColor.uiColor.cgColor
        dashBorder.lineDashPattern = [self.dashLength, self.dashLength] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil

        if borderRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: self.borderRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        self.stackView.layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }

    //MARK: Button actions
    private func setupButtonActions() {
        let actions: [(selector: Selector, event: UIControl.Event)] = [
            (#selector(actionTapped(sender:)), .touchUpInside),
            (#selector(actionTouchDown(sender:)), .touchDown),
            (#selector(actionTouchUp(sender:)), .touchUpOutside),
            (#selector(actionTouchUp(sender:)), .touchCancel)
        ]

        if self.action == nil {
            actions.forEach { self.button.removeTarget(self, action: $0.selector, for: $0.event)}
        } else {
            actions.forEach { self.button.addTarget(self, action: $0.selector, for: $0.event)}
        }
    }

    @IBAction func actionTapped(sender: UIButton)  {
        self.setChipColors(self.viewModel.colors.default)
        self.action?()
    }

    @IBAction func actionTouchDown(sender: UIButton)  {
        self.setChipColors(self.viewModel.colors.pressed)
    }

    @IBAction func actionTouchUp(sender: UIButton)  {
        self.setChipColors(self.viewModel.colors.default)
    }

}

// MARK: - Label priorities
public extension ChipUIView {
    func setLabelContentCompressionResistancePriority(_ priority: UILayoutPriority,
                                                      for axis: NSLayoutConstraint.Axis) {
        self.textLabel.setContentCompressionResistancePriority(priority,
                                                               for: axis)
    }

    func setLabelContentHuggingPriority(_ priority: UILayoutPriority,
                                        for axis: NSLayoutConstraint.Axis) {
        self.textLabel.setContentHuggingPriority(priority,
                                                 for: axis)
    }
}
