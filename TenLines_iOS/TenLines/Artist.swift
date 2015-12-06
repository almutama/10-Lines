//
//  Artist.swift
//  TenLines
//
//  Created by Ben-han on 11/24/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import Foundation
import UIKit

class Artist {
    var id: Int?
    var username: String?
    var firstname: String?
    var lastname: String?
    var iconUrl: String?
    var icon: UIImage?
    
    /* Loads this artist's icon, SYNCHRONOUSLY. */
    func loadIcon() {
        // Fetch sketch data as base64 string.
        let dataString: String? = AccountManager.sharedManager.getUserPic(self.id!)
        
        // Hacky custom URL-decode
        if (dataString != nil) {
            var urlDecodedString = dataString?.stringByReplacingOccurrencesOfString("_", withString: "/")
            urlDecodedString = urlDecodedString?.stringByReplacingOccurrencesOfString("-", withString: "+")
            let data: NSData? = NSData(base64EncodedString: urlDecodedString!, options: NSDataBase64DecodingOptions(rawValue: 0))
            
            if (data != nil) {
                self.icon = UIImage(data: data!)
            }
        }
    }
    
    /* Creates an artist from a corresponding JSON fragment. */
    static func fromJSONFragment(object: JSON) -> Artist {
        let artist = Artist()
        artist.id = object["id"].int
        artist.username = object["username"].string
        artist.firstname = object["firstname"].string
        artist.lastname = object["lastname"].string
        artist.iconUrl = object["icon"].string
        return artist
    }
    
    /* Creates a list of artists from a corresponding JSON fragment. */
    static func fromJSON(object: JSON) -> Array<Artist> {
        var artists = Array<Artist>()
        for (_, item) in object {
            artists += [fromJSONFragment(item)]
        }
        return artists
    }
}
