//
//  StorageController.swift
//  LeahIOS
//
//  Created by Mario Fernando Paucar Gutierrez on 6/16/19.
//  Copyright © 2019 Tecsup. All rights reserved.
//

import Foundation

class StorageController {
    private let userFileURL = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)
        .first!
        .appendingPathComponent("User")
        .appendingPathExtension("plist")
    
    init() {
        guard fetchUser() == nil else {
            return
        }
    }
    
    func fetchUser() -> User? {
        guard let data = try? Data(contentsOf: userFileURL) else {
            return nil
        }
        let decoder = PropertyListDecoder()
        return try? decoder.decode(User.self, from: data)
    }
    
    func save(_ user: User) {
        let encoder = PropertyListEncoder()
        if let data = try? encoder.encode(user) {
            try? data.write(to: userFileURL)
        }
    }
}
