//
//  TypographyDefault.swift
//  SparkCore
//
//  Created by louis.borlee on 23/02/2023.
//  Copyright © 2023 Adevinta. All rights reserved.
//

import SwiftUI
import UIKit

public struct TypographyDefault: Typography {

    // MARK: - Properties

    public let display1: TypographyFont
    public let display2: TypographyFont
    public let display3: TypographyFont

    public let headline1: TypographyFont
    public let headline2: TypographyFont

    public let subhead: TypographyFont

    public let body1: TypographyFont
    public let body1Highlight: TypographyFont

    public let body2: TypographyFont
    public let body2Highlight: TypographyFont

    public let caption: TypographyFont
    public let captionHighlight: TypographyFont

    public let small: TypographyFont
    public let smallHighlight: TypographyFont

    public let callout: TypographyFont

    // MARK: - Initialization

    public init(display1: TypographyFont,
                display2: TypographyFont,
                display3: TypographyFont,
                headline1: TypographyFont,
                headline2: TypographyFont,
                subhead: TypographyFont,
                body1: TypographyFont,
                body1Highlight: TypographyFont,
                body2: TypographyFont,
                body2Highlight: TypographyFont,
                caption: TypographyFont,
                captionHighlight: TypographyFont,
                small: TypographyFont,
                smallHighlight: TypographyFont,
                callout: TypographyFont) {
        self.display1 = display1
        self.display2 = display2
        self.display3 = display3
        self.headline1 = headline1
        self.headline2 = headline2
        self.subhead = subhead
        self.body1 = body1
        self.body1Highlight = body1Highlight
        self.body2 = body2
        self.body2Highlight = body2Highlight
        self.caption = caption
        self.captionHighlight = captionHighlight
        self.small = small
        self.smallHighlight = smallHighlight
        self.callout = callout
    }
}

// MARK: - Font

public struct TypographyFontDefault: TypographyFont {

    // MARK: - Properties

    private let fontName: String
    private let fontSize: CGFloat
    private let fontWeight: UIFont.Weight
    private let fontTextStyle: Font.TextStyle

    public var uiFont: UIFont {
        return UIFont(name: self.fontName, size: self.fontSize) ?? .systemFont(ofSize: self.fontSize, weight: self.fontWeight)
    }
    
    public var swiftUIFont: Font {
        return Font.custom(self.fontName,
                           size: self.fontSize,
                           relativeTo: self.fontTextStyle)
    }

    // MARK: - Initialization

    public init(named fontName: String,
                size: CGFloat,
                weight: UIFont.Weight,
                textStyle: Font.TextStyle) {
        self.fontName = fontName
        self.fontSize = size
        self.fontWeight = weight
        self.fontTextStyle = textStyle
    }
}
