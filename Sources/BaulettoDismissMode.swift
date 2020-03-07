//
//  BaulettoDismissMode.swift
//  
//
//  Created by Gianpiero Spinelli on 06/03/2020.
//

import Foundation

public enum BaulettoDismissMode: Equatable {
    /// Hide the banner view after the default duration.
    case automatic
    
    /// Disables automatic hiding of the message view.
    case never
    
    /// Custom duration.
    case custom(seconds: TimeInterval)
    
    public var duration: TimeInterval {
        switch self {
        case .automatic: return 4
        case .never: return 0
        case .custom(let seconds): return seconds
        }
    }
}
