//
//  BaulettoSettings.swift
//  
//
//  Created by Gianpiero Spinelli on 06/03/2020.
//

import Foundation
import UIKit

public struct BaulettoSettings {
    /// Icon that goes at the left of the text.
    public var icon: UIImage?
    
    /// Text that goes at the right of the image.
    public var title: String?
    
    /// Tint color for icon and title.
    public var tintColor: UIColor!
    
    /// Style of the background UIVisualEffectView.
    public var backgroundStyle: UIBlurEffect.Style! = .regular
    
    /// Dismiss mode. Default is automatic
    public var dismissMode: BaulettoDismissMode = .automatic
    
    /// Type of the haptic feedback fired when the banner is shown. None by default.
    public var hapticStyle: FeedbackGenerator.HapticStyle = .none
    
    /// Duration of the fade in animation
    public var fadeInDuration: TimeInterval = 1
    
    /// The optional action that needs to be performed when the view is tapped.
    public var action: (() -> Void)?
    
    public init(icon: UIImage?, title: String?, backgroundStyle: UIBlurEffect.Style = .regular, dismissMode: BaulettoDismissMode = .automatic, hapticStyle: FeedbackGenerator.HapticStyle = .none, action: (() -> Void)? = nil, fadeInDuration: TimeInterval = 1) {
        self.icon = icon
        self.title = title
        self.backgroundStyle = backgroundStyle
        self.dismissMode = dismissMode
        self.hapticStyle = hapticStyle
        self.action = action
        self.fadeInDuration = fadeInDuration
    }
    
    public init(icon: UIImage?, title: String?, tintColor: UIColor, backgroundStyle: UIBlurEffect.Style = .regular, dismissMode: BaulettoDismissMode = .automatic, hapticStyle: FeedbackGenerator.HapticStyle = .none, action: (() -> Void)? = nil, fadeInDuration: TimeInterval = 1) {
        self.icon = icon
        self.title = title
        self.tintColor = tintColor
        self.backgroundStyle = backgroundStyle
        self.dismissMode = dismissMode
        self.hapticStyle = hapticStyle
        self.action = action
        self.fadeInDuration = fadeInDuration
    }
}
