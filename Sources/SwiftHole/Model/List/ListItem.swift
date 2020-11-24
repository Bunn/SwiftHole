//
//  ListItem.swift
//  
//
//  Created by Fernando Bunn on 23/11/2020.
//

import Foundation

struct List: Codable {
    let items: [ListItem]
    
    enum CodingKeys: String, CodingKey {
        case items = "data"
    }
}

public struct ListItem: Codable {
    let id, type: Int
    let domain: String
    let enabled, dateAdded, dateModified: Int
    let comment: String?
    let groups: [Int]
    
    enum CodingKeys: String, CodingKey {
        case id, type, domain, enabled
        case dateAdded = "date_added"
        case dateModified = "date_modified"
        case comment, groups
    }
    
    //https://github.com/pi-hole/AdminLTE/blob/a03d1bddf74f0164f637126b06705bb659dfa4e7/scripts/pi-hole/php/database.php#L91
    //$type integer The target type (0 = exact whitelist, 1 = exact blacklist, 2 = regex whitelist, 3 = regex blacklist)
    public var listType: ListType {
        switch type {
        case 0:
            return .whitelist
        case 1:
            return .blacklist
        case 2:
            return .whitelistRegex
        case 3:
            return .blacklistRegex
        default:
            fatalError("It should never have a different type")
        }
    }
}
