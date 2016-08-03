//
//  UserDefaultsKeys.swift
//  pgorate
//
//  Created by Rowell Heria on 03/08/2016.
//  Copyright © 2016 Rowell Heria. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static let filterBy = DefaultsKey<String>("filterBy")
    static let showNick = DefaultsKey<Bool>("showNick")
    static let initialSetup = DefaultsKey<Bool>("initialSetup")
    static let rememberMe = DefaultsKey<Bool>("rememberMe")
    
    static let googleUsername = DefaultsKey<String?>("googleUsername")
    static let ptcUsername = DefaultsKey<String?>("ptcUsername")
    
    static let trainerName = DefaultsKey<String?>("trainerName")
    static let trainerTeam = DefaultsKey<String?>("trainerTeam")
}