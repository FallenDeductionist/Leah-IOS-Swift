//
//  User.swift
//  LeahIOS
//
//  Created by Mario Fernando Paucar Gutierrez on 6/16/19.
//  Copyright © 2019 Tecsup. All rights reserved.
//

import Foundation
import Alamofire

class User {
    static let user = User()
    var URLApi = "https://frozen-citadel-27418.herokuapp.com/"
    var idUser: String
    var token: String
    var userUsage: String
    var appName: String
    var appImagePath: String
    private init() {
    }
    
}
