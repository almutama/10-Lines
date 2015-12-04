//
//  Comment.swift
//  TenLines
//
//  Created by Ben-han on 11/24/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import Foundation

class Comment {
    var username: String?
    var firstname: String?
    var lastname: String?
    var text: String?
    
    /* Creates a comment from a corresponding JSON fragment. */
    static func fromJSONFragment(object: JSON) -> Comment {
        let comment = Comment()
        comment.username = object["username"].string
        comment.firstname = object["firstname"].string
        comment.lastname = object["lastname"].string
        comment.text = object["text"].string
        return comment
    }
    
    /* Creates a list of comments from a corresponding JSON fragment. */
    static func fromJSON(object: JSON) -> Array<Comment> {
        var comments = Array<Comment>()
        for (_, item) in object {
            comments += [fromJSONFragment(item)]
        }
        return comments
    }
}