//
//  AccountManager.swift
//  TenLines
//
//  Created by Ben-han on 12/3/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import Foundation
import UIKit

class AccountManager {
    
    static let sharedManager: AccountManager = AccountManager()
    
    /* Webservice URLs. */
    private static let baseIpAddress: String = NSUserDefaults.standardUserDefaults().stringForKey("server_ip")!
    
    private static let loginUrl: String = "http://\(baseIpAddress):3000/login/login"
    private static let registerUrl: String = "http://\(baseIpAddress):3000/login/create"
    
    private static let addSketchUrl: String = "http://\(baseIpAddress):3000/data/add_sketch"
    private static let addLineUrl: String = "http://\(baseIpAddress):3000/data/add_line"
    private static let removeLineUrl: String = "http://\(baseIpAddress):3000/data/remove_line"
    private static let addCommentUrl: String = "http://\(baseIpAddress):3000/data/add_comment"
    private static let addScreenshotUrl: String = "http://\(baseIpAddress):3000/data/add_screenshot"
    
    private static let getUserPicUrl: String = "http://\(baseIpAddress):3000/data/get_user_pic"
    private static let getSketchUrl: String = "http://\(baseIpAddress):3000/data/get_sketch"
    private static let getSketchesUrl: String = "http://\(baseIpAddress):3000/data/get_sketches"
    private static let getInvitesUrl: String = "http://\(baseIpAddress):3000/data/get_invites"
    private static let getCommentsUrl: String = "http://\(baseIpAddress):3000/data/get_comments"
    private static let getUsersUrl: String = "http://\(baseIpAddress):3000/data/get_users"
    
    private static let syncLinesUrl: String = "http://\(baseIpAddress):3000/data/get_lines"
    private static let inviteUrl: String = "http://\(baseIpAddress):3000/data/invite"
    
    /* User ID of the currently logged-in user. Nil if not logged in. */
    private var userId: Int?
    var username: String?
    var firstname: String?
    var lastname: String?
    
    /* Logs the user with the given username and password in. */
    func login(username: String, password: String) -> Bool {
        // Make a login attempt and set the user id if sucessful.
        let params = "username=\(username)&password=\(password)"
        let request = NSMutableURLRequest(URL: NSURL(string: AccountManager.loginUrl)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        do {
            let result: NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            let resultString: String = String(data: result!, encoding: NSUTF8StringEncoding)!
            print("login: \(resultString)")
            if (result != nil) {
                let parsedResult: JSON =  JSON(data: result!)
                if (parsedResult["result"] == "Success") {
                    self.userId = parsedResult["user_id"].int
                    self.username = parsedResult["username"].string
                    self.firstname = parsedResult["firstname"].string
                    self.lastname = parsedResult["lastname"].string
                    return true
                }
            }
        }
        catch {
            // Log warning.
            print("Failed to login.")
        }
        return false
    }
    
    /* Registers the user with the given username and password. */
    func register(username: String, password: String, image: UIImage?) -> Bool {
        // Serialize image.
        let data: NSData? = UIImagePNGRepresentation(image!)
        var base64ImgString: String? = data?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: .allZeros))
        
        // Hacky custom URL-encode
        base64ImgString = base64ImgString?.stringByReplacingOccurrencesOfString("/", withString: "_")
        base64ImgString = base64ImgString?.stringByReplacingOccurrencesOfString("+", withString: "-")
        
        // Make a registration attempt and set the user id if sucessful.
        let params = "username=\(username)&password=\(password)&image=\(base64ImgString!)"
        let request = NSMutableURLRequest(URL: NSURL(string: AccountManager.registerUrl)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        do {
            let result: NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            let resultString: String = String(data: result!, encoding: NSUTF8StringEncoding)!
            print("login: \(resultString)")
            if (result != nil) {
                let parsedResult: JSON =  JSON(data: result!)
                if (parsedResult["result"] == "Success") {
                    self.userId = parsedResult["user_id"].int
                    return true
                }
            }
        }
        catch {
            // Log warning.
            print("Failed to login.")
        }
        return false
    }
    
    /* Creates a sketch with the given title for the currently logged-in user. */
    func createSketchWithTitle(title: String, ispublic: Bool) -> Sketch {
        let sketch = Sketch()
        
        // Make a request to create sketch.
        var params = "user_id=\(self.userId!)&title=\(title)"
        if (ispublic) {
            params += "&public=\(true)"
        }
        let request = NSMutableURLRequest(URL: NSURL(string: AccountManager.addSketchUrl)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        do {
            let result: NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            let resultString: String = String(data: result!, encoding: NSUTF8StringEncoding)!
            print("createSketchWithTitle: \(resultString)")
            if (result != nil) {
                let parsedResult: JSON =  JSON(data: result!)
                if (parsedResult["result"] == "Success") {
                    sketch.id = parsedResult["sketch_id"].int
                }
            }
        }
        catch {
            // Log warning.
            print("Failed to create new sketch.")
        }
        return sketch
    }
    
    /* Adds a line to an existing sketch server-side. */
    func addlineToSketch(line: Line, sketch: Sketch) {
        // Serialize line.
        var points: NSString = ""
        var color: NSString = ""
        do {
            points = try Line.serializePoints(line.points)!
            color = try Line.serializeColor(line.color)!
        }
        catch {
            print("Failed to serialize line points.")
        }
        
        // Make a request to create line.
        let params = "user_id=\(self.userId!)&sketch_id=\(sketch.id!)&color=\(color)&width=\(line.width)&points=\(points)"
        let request = NSMutableURLRequest(URL: NSURL(string: AccountManager.addLineUrl)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        do {
            let result: NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            let resultString: String = String(data: result!, encoding: NSUTF8StringEncoding)!
            print("addLineToSketch: \(resultString)")
            if (result != nil) {
                let parsedResult: JSON =  JSON(data: result!)
                if (parsedResult["result"] == "Success") {
                    line.id = parsedResult["line_id"].int!;
                }
            }
        }
        catch {
            // Log warning.
            print("Failed to add line to sketch.")
        }
    }
    
    /* Removes a line from an existing sketch server-side. */
    func removeLineFromSketch(line: Line, sketch: Sketch) {
        // Make a request to remove line.
        let params = "user_id=\(self.userId!)&sketch_id=\(sketch.id!)&line_id=\(line.id!)"
        let request = NSMutableURLRequest(URL: NSURL(string: AccountManager.removeLineUrl)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        do {
            let result: NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            let resultString: String = String(data: result!, encoding: NSUTF8StringEncoding)!
            print("removeLineFromSketch: \(resultString)")
            if (result != nil) {
                let parsedResult: JSON =  JSON(data: result!)
                if (parsedResult["result"] == "Success") {
                    // TODO: Process.
                }
            }
        }
        catch {
            // Log warning.
            print("Failed to remove line from sketch.")
        }
    }
    
    /* Adds a comment to a sketch. */
    func addCommentForSketch(comment: String, sketch: Sketch) {
        // Make a request to create line.
        let comment: String? = comment.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let params = "user_id=\(self.userId!)&sketch_id=\(sketch.id!)&comment=\(comment!)"
        let request = NSMutableURLRequest(URL: NSURL(string: AccountManager.addCommentUrl)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        do {
            let result: NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            let resultString: String = String(data: result!, encoding: NSUTF8StringEncoding)!
            print("addCommentForSketch: \(resultString)")
        }
        catch {
            // Log warning.
            print("Failed to add comment to sketch.")
        }
    }
    
    /* Gets existing comments for a sketch. */
    func getCommentsForSketch(sketch: Sketch) -> Array<Comment> {
        var comments: Array<Comment> = Array<Comment>()
        
        // Make a request to create line.
        let params = "user_id=\(self.userId!)&sketch_id=\(sketch.id!)"
        let request = NSMutableURLRequest(URL: NSURL(string: AccountManager.getCommentsUrl)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        do {
            let result: NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            let resultString: String = String(data: result!, encoding: NSUTF8StringEncoding)!
            print("getCommentsForSketch: \(resultString)")
            if (result != nil) {
                let parsedResult: JSON =  JSON(data: result!)
                comments = Comment.fromJSON(parsedResult)
            }
        }
        catch {
            // Log warning.
            print("Failed to get comments for sketch.")
        }
        
        return comments
    }
    
    /* Adds a screenshot of an existing sketch to the server. */
    func addScreenshotForSketch(screenshot: UIImage, sketch: Sketch) {
        // Serialize image.
        let data: NSData? = UIImagePNGRepresentation(screenshot)
        var base64ImgString: String? = data?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: .allZeros))
        
        // Hacky custom URL-encode
        base64ImgString = base64ImgString?.stringByReplacingOccurrencesOfString("/", withString: "_")
        base64ImgString = base64ImgString?.stringByReplacingOccurrencesOfString("+", withString: "-")
 
        // Make a request to submit screenshot.
        let params = "user_id=\(self.userId!)&sketch_id=\(sketch.id!)&screenshot=\(base64ImgString!)"
        let request = NSMutableURLRequest(URL: NSURL(string: AccountManager.addScreenshotUrl)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        do {
            let result: NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            let resultString: String = String(data: result!, encoding: NSUTF8StringEncoding)!
            print("addScreenshotForSketch: \(resultString)")
        }
        catch {
            // Log warning.
            print("Failed to submit screenshot for sketch.")
        }
    }
    
    /* Syncs the local copy of a sketch's lines with the remote copy. */
    func syncLinesForSketch(sketch: Sketch) {
        // Make an asynchronous request to sync lines.
        let params = "user_id=\(self.userId!)&sketch_id=\(sketch.id!)"
        let request = NSMutableURLRequest(URL: NSURL(string: AccountManager.syncLinesUrl)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        do {
            let result: NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            let resultString: String = String(data: result!, encoding: NSUTF8StringEncoding)!
            print("syncLinesForSketch: \(resultString)")
            if (result != nil) {
                let parsedResult: JSON =  JSON(data: result!)
                let lineData: Array<Line> = Line.fromJSON(parsedResult)
                sketch.lineData = lineData
            }
        }
        catch {
            // Log warning.
            print("Failed to sync sketch lines.")
        }
    }
    
    /* Gets the image data for a single sketch, as a base64 string. */
    func getSketch(sketchId: Int) -> String? {
        var sketch: String?
        
        // Make an asynchronous request to get sketches.
        let params = "sketch_id=\(sketchId)"
        let request = NSMutableURLRequest(URL: NSURL(string: AccountManager.getSketchUrl)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        do {
            let result: NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            if (result != nil) {
                let parsedResult: JSON =  JSON(data: result!)
                sketch = parsedResult[0].string
            }
        }
        catch {
            // Log warning.
            print("Failed to get user sketches.")
        }
        
        return sketch
    }
    
    /* Gets the image data for a user pic, as a base64 string. */
    func getUserPic(userId: Int) -> String? {
        var sketch: String?
        
        // Make an asynchronous request to get sketches.
        let params = "user_id=\(userId)"
        let request = NSMutableURLRequest(URL: NSURL(string: AccountManager.getUserPicUrl)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        do {
            let result: NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            if (result != nil) {
                let parsedResult: JSON =  JSON(data: result!)
                sketch = parsedResult[0].string
            }
        }
        catch {
            // Log warning.
            print("Failed to get user sketches.")
        }
        
        return sketch
    }
    
    /* Gets all sketches belonging to the current user. */
    func getSketches() -> Array<Sketch>  {
        var sketches: Array<Sketch> = Array<Sketch>()
        
        // Make an asynchronous request to get sketches.
        let params = "user_id=\(self.userId!)"
        let request = NSMutableURLRequest(URL: NSURL(string: AccountManager.getSketchesUrl)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        do {
            let result: NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            let resultString: String = String(data: result!, encoding: NSUTF8StringEncoding)!
            print("getSketches: \(resultString)")
            if (result != nil) {
                let parsedResult: JSON =  JSON(data: result!)
                sketches = Sketch.fromJSON(parsedResult)
            }
        }
        catch {
            // Log warning.
            print("Failed to get user sketches.")
        }
        
        return sketches
    }
    
    /* Gets all public sketches. */
    func getPublicSketches() -> Array<Sketch>  {
        var sketches: Array<Sketch> = Array<Sketch>()
        
        // Make an asynchronous request to get sketches.
        let params = "public=\(true)"
        let request = NSMutableURLRequest(URL: NSURL(string: AccountManager.getSketchesUrl)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        do {
            let result: NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            let resultString: String = String(data: result!, encoding: NSUTF8StringEncoding)!
            print("getPublicSketches: \(resultString)")
            if (result != nil) {
                let parsedResult: JSON =  JSON(data: result!)
                sketches = Sketch.fromJSON(parsedResult)
            }
        }
        catch {
            // Log warning.
            print("Failed to get public sketches.")
        }
        
        return sketches
    }
    
    /* Gets all sketches. */
    func getAllSketches() -> Array<Sketch>  {
        var sketches: Array<Sketch> = Array<Sketch>()
        
        // Make an asynchronous request to get sketches.
        let request = NSMutableURLRequest(URL: NSURL(string: AccountManager.getSketchesUrl)!)
        do {
            let result: NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            let resultString: String = String(data: result!, encoding: NSUTF8StringEncoding)!
            print("getSketches: \(resultString)")
            if (result != nil) {
                let parsedResult: JSON =  JSON(data: result!)
                sketches = Sketch.fromJSON(parsedResult)
            }
        }
        catch {
            // Log warning.
            print("Failed to get all sketches.")
        }
        
        return sketches
    }
    
    /* Gets all invites received by the current user. */
    func getInvites() -> Array<Sketch> {
        var invites: Array<Sketch> = Array<Sketch>()
        
        // Make an asynchronous request to get sketches.
        let params = "user_id=\(self.userId!)"
        let request = NSMutableURLRequest(URL: NSURL(string: AccountManager.getInvitesUrl)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        do {
            let result: NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            let resultString: String = String(data: result!, encoding: NSUTF8StringEncoding)!
            print("getInvites: \(resultString)")
            if (result != nil) {
                let parsedResult: JSON =  JSON(data: result!)
                invites = Sketch.fromJSON(parsedResult)
            }
        }
        catch {
            // Log warning.
            print("Failed to get invites.")
        }
        
        return invites
    }
    
    /* Invite another user to join a sketch. */
    func inviteUser(user: Int, toSketch sketch: Sketch) {
        // Make an asynchronous request to invite another user by ID.
        let params = "user_id=\(self.userId!)&sketch_id=\(sketch.id!)&guest_id=\(user)"
        let request = NSMutableURLRequest(URL: NSURL(string: AccountManager.inviteUrl)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        do {
            let result: NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            let resultString: String = String(data: result!, encoding: NSUTF8StringEncoding)!
            print("inviteUser: \(resultString)")
            if (result != nil) {
                let parsedResult: JSON =  JSON(data: result!)
                if (parsedResult["result"] == "Success") {
                    // TODO: Deserialize lines.
                }
            }
        }
        catch {
            // Log warning.
            print("Failed to invite user.")
        }
    }
    
    /* Gets all registered users. */
    func getUsers() -> Array<Artist> {
        var users: Array<Artist> = Array<Artist>()
        
        // Make an asynchronous request to get all other users.
        let params = "user_id=\(self.userId!)"
        let request = NSMutableURLRequest(URL: NSURL(string: AccountManager.getUsersUrl)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        do {
            let result: NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            let resultString: String = String(data: result!, encoding: NSUTF8StringEncoding)!
            print("getUsers: \(resultString)")
            if (result != nil) {
                let parsedResult: JSON =  JSON(data: result!)
                users = Artist.fromJSON(parsedResult)
            }
        }
        catch {
            // Log warning.
            print("Failed to get all users.")
        }
        
        return users;
    }
}