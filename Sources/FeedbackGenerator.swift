//
//  FeedbackGenerator.swift
//  
//
//  Created by Gianpiero Spinelli on 06/03/2020.
//

import Foundation
import UIKit

public class FeedbackGenerator: NSObject {
    public enum HapticStyle {
        case notificationError, notificationWarning, notificationSuccess
        case light, medium, heavy
        case none
        
        @available(iOS 13, *)
        case soft, rigid
        
        fileprivate var impactGenerator: UIImpactFeedbackGenerator.FeedbackStyle? {
            switch self {
            case .light: return .light
            case .medium: return .medium
            case .heavy: return .heavy
            case .soft:
                if #available(iOS 13, *) {
                    return .soft
                } else {
                    return nil
                }
            case .rigid:
                if #available(iOS 13, *) {
                    return .rigid
                } else {
                   return nil
               }
            default: return nil
            }
        }
    }
    
    public class func generate(withStyle style: HapticStyle) {
        switch style {
        case .notificationError:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            
        case .notificationSuccess:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
        case .notificationWarning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
            
        case .light, .medium, .heavy, .soft, .rigid:
            if let style = style.impactGenerator {
                let generator = UIImpactFeedbackGenerator(style: style)
                generator.impactOccurred()
            }
            
        case .none: break
        }
    }
}
