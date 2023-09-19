//
//  CustomFonts.swift
//  BoilEasy
//
//  Created by SHIN MIKHAIL on 20.09.2023.
//

import Foundation
import UIKit

extension UIFont {
    static func SFUITextBold(ofSize size: CGFloat) -> UIFont? {
        return UIFont(name: "SFUIText-Bold", size: size)
    }
    static func SFUITextHeavy(ofSize size: CGFloat) -> UIFont? {
        return UIFont(name: "SFUIText-Heavy", size: size)
    }
    static func SFUITextLight(ofSize size: CGFloat) -> UIFont? {
        return UIFont(name: "SFUIText-Light", size: size)
    }
    static func SFUITextMedium(ofSize size: CGFloat) -> UIFont? {
        return UIFont(name: "SFUIText-Medium", size: size)
    }
    static func SFUITextRegular(ofSize size: CGFloat) -> UIFont? {
        return UIFont(name: "SFUIText-Regular", size: size)
    }
}
