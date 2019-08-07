//
//  Constants.swift
//  iOSToDoApp
//
//  Created by Tomek on 05/08/2019.
//  Copyright © 2019 ITCraft. All rights reserved.
//

import Foundation

struct Constants {
    static let MY_INSTANCE_ADDRESS = "itcraft-demo.de1a.cloud.realm.io"
    
    static let AUTH_URL  = URL(string: "https://\(MY_INSTANCE_ADDRESS)")!
    static let REALM_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/ToDo")!
}
