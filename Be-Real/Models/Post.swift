//  Post.swift
//  Be-Real
//
//  Created by Joel Ezan on 9/20/24.
//

import Foundation
import ParseSwift

struct Post: ParseObject {
    init() {}
    
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // Your custom properties
    var user: User?
    var caption: String?
    var imageFile: ParseFile?
    var latitude: Double?
    var longitude: Double?

    // Custom initializer
    init(caption: String, user: User, imageFile: ParseFile, latitude: Double?, longitude: Double?) {
        self.caption = caption
        self.user = user
        self.imageFile = imageFile
        self.latitude = latitude
        self.longitude = longitude
    }
}
