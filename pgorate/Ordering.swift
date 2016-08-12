//
//  Ordering.swift
//  pgorate
//
//  Created by Rowell Heria on 12/08/2016.
//  Copyright © 2016 Rowell Heria. All rights reserved.
//

import Foundation
public enum Ordering: String, CustomStringConvertible {
    case CP = "CP"
    case IVAttack = "IV - Attack"
    case IVDefense = "IV - Defence"
    case IVStamina = "IV - Stamina"
    case IVPerfection = "IV Perfection"
    case Level = "Level"
    case Name = "Name"
    case Number = "Number"
    
    public var description: String {
        return self.rawValue
    }
}