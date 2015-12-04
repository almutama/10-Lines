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
    private static let addSketchUrl: String = "http://\(baseIpAddress):3000/data/add_sketch"
    private static let addLineUrl: String = "http://\(baseIpAddress):3000/data/add_line"
    private static let addScreenshotUrl: String = "http://\(baseIpAddress):3000/data/add_screenshot"
    private static let syncLinesUrl: String = "http://\(baseIpAddress):3000/data/get_lines"
    private static let getSketchesUrl: String = "http://\(baseIpAddress):3000/data/get_sketches"
    private static let getInvitesUrl: String = "http://\(baseIpAddress):3000/data/get_invites"
    private static let getUsersUrl: String = "http://\(baseIpAddress):3000/data/get_users"
    private static let inviteUrl: String = "http://\(baseIpAddress):3000/data/invite"
    
    /* User ID of the currently logged-in user. Nil if not logged in. */
    private var userId: Int?
    
    /* Logs the user with the given username and password in. */
    func login(username: String, password: String) {
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
                }
            }
        }
        catch {
            // Log warning.
            print("Failed to login.")
        }
    }
    
    /* Creates a sketch with the given title for the currently logged-in user. */
    func createSketchWithTitle(title: String) -> Sketch {
        let sketch = Sketch()
        
        // Make a request to create sketch.
        let params = "user_id=\(self.userId!)&title=\(title)"
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
                    // TODO: Process.
                }
            }
        }
        catch {
            // Log warning.
            print("Failed to add line to sketch.")
        }
    }
    
    /* Adds a screenshot of an existing sketch to the server. */
    func addScreenshotForSketch(screenshot: UIImage, sketch: Sketch) {
        // Serialize image.
        let data: NSData? = UIImagePNGRepresentation(screenshot)
        let base64ImgString: String? = data?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithCarriageReturn)
 
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
            print("Failed to submit screenshot.")
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
        
        // Make an asynchronous request to invite another user by ID.
        let request = NSMutableURLRequest(URL: NSURL(string: AccountManager.getUsersUrl)!)
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