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
    var username: String = ""
    var firstname: String = ""
    var lastname: String = ""
    var iconUrl: String = ""
    var icon: UIImage?
    
    /* Loads this artist's icon, SYNCHRONOUSLY. */
    func loadIcon() {
        let data = NSData(contentsOfURL: NSURL(string: iconUrl)!)
        icon = UIImage(data: data!)
    }
    
    /* Creates an artist from a corresponding JSON fragment. */
    static func fromJSONFragment(object: JSON) -> Artist {
        let artist = Artist()
        artist.username = object["username"].string!
        artist.firstname = object["firstname"].string!
        artist.lastname = object["lastname"].string!
        artist.iconUrl = object["icon"].string!
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
