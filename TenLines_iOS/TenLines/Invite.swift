//
//  Invites.swift
//  TenLines
//
//  Created by Ben-han on 12/2/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import Foundation
import UIKit

class Invite {
    var username: String = ""
    var firstname: String = ""
    var lastname: String = ""
    var previewUrl: String = ""
    var preview: UIImage?
    var sketchId: Int = 0
    
    /* Loads this invite's preview, SYNCHRONOUSLY. */
    func loadPreview() {
        let data = NSData(contentsOfURL: NSURL(string: previewUrl)!)
        preview = UIImage(data: data!)
    }
    
    /* Creates an invite from a corresponding JSON fragment. */
    static func fromJSONFragment(object: JSON) -> Invite {
        let invite = Invite()
        invite.username = object["username"].string!
        invite.firstname = object["firstname"].string!
        invite.lastname = object["lastname"].string!
        invite.previewUrl = object["preview"].string!
        invite.sketchId = object["sketch_id"].int!
        return invite
    }
    
    /* Creates a list of invites from a corresponding JSON fragment. */
    static func fromJSON(object: JSON) -> Array<Invite> {
        var invites = Array<Invite>()
        for (_, item) in object {
            invites += [fromJSONFragment(item)]
        }
        return invites
    }
}
