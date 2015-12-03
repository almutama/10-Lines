//
//  AccountManager.swift
//  TenLines
//
//  Created by Ben-han on 12/3/15.
//  Copyright © 2015 Art Attack. All rights reserved.
//

import Foundation

class AccountManager {
    
    static let sharedManager: AccountManager = AccountManager()
    
    /* Webservice URLs. */
    let loginUrl: String = "http://localhost:3000/login/login"
    let addSketchUrl: String = "http://localhost:3000/data/add_sketch"
    let addLineUrl: String = "http://localhost:3000/data/add_line"
    let syncLinesUrl: String = "http://localhost:3000/data/get_lines"
    
    /* User ID of the currently logged-in user. Nil if not logged in. */
    var userId: Int?
    
    /* Logs the user with the given username and password in. */
    func login(username: String, password: String) {
        ({
            // Make an asynchronous login attempt and set the user id if sucessful.
            let params = "username=\(username)&password=\(password)"
            let request = NSMutableURLRequest(URL: NSURL(string: self.loginUrl)!)
            request.HTTPMethod = "POST"
            request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
            do {
                let result: NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
                let resultString: String = String(data: result!, encoding: NSUTF8StringEncoding)!
                print(resultString)
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
        ~>
        {
            // Nothing to do here.
        })
    }
    
    /* Creates a sketch with the given title for the currently logged-in user. */
    func createSketchWithTitle(title: String) -> Sketch {
        let sketch = Sketch()
        ({
            // Make an asynchronous request to create sketch.
            let params = "user_id=\(self.userId)&title=\(title)"
            let request = NSMutableURLRequest(URL: NSURL(string: self.loginUrl)!)
            request.HTTPMethod = "POST"
            request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
            do {
                let result: NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
                let resultString: String = String(data: result!, encoding: NSUTF8StringEncoding)!
                print(resultString)
                if (result != nil) {
                    let parsedResult: JSON =  JSON(data: result!)
                    if (parsedResult["result"] == "Success") {
                        // TODO: Process.
                    }
                }
            }
            catch {
                // Log warning.
                print("Failed to create new sketch.")
            }
        }
        ~>
        {
            // Nothing to do here.
        })
        return sketch
    }
    
    /* Adds a line to an existing sketch server-side. */
    func addlineToSketch(line: Line, sketch: Sketch) {
        let sketch = Sketch()
        ({
            // Serialize line points.
            var points: String = ""
            do {
                let pointsArray = Line.cocoaArrayFromSwiftArray(line.points)
                try points = String(NSJSONSerialization.dataWithJSONObject(pointsArray, options: NSJSONWritingOptions(rawValue: 0)))
            }
            catch {
                print("Failed to serialize line points.")
            }
            
            // Make an asynchronous request to create line.
            let params = "user_id=\(self.userId)&sketch_id=\(sketch.id!)&color=\(line.color)&width=\(line.width)&points=\(points)"
            let request = NSMutableURLRequest(URL: NSURL(string: self.loginUrl)!)
            request.HTTPMethod = "POST"
            request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
            do {
                let result: NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
                let resultString: String = String(data: result!, encoding: NSUTF8StringEncoding)!
                print(resultString)
                if (result != nil) {
                    let parsedResult: JSON =  JSON(data: result!)
                    if (parsedResult["result"] == "Success") {
                        // TODO: Process.
                    }
                }
            }
            catch {
                // Log warning.
                print("Failed to create new sketch.")
            }
        }
        ~>
        {
            // Nothing to do here.
        })
    }
    
    func syncLinesForSketch(sketch: Sketch) {
        ({
            // Make an asynchronous request to create line.
            let params = "user_id=\(self.userId)&sketch_id=\(sketch.id!)"
            let request = NSMutableURLRequest(URL: NSURL(string: self.loginUrl)!)
            request.HTTPMethod = "POST"
            request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
            do {
                let result: NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
                let resultString: String = String(data: result!, encoding: NSUTF8StringEncoding)!
                print(resultString)
                if (result != nil) {
                    let parsedResult: JSON =  JSON(data: result!)
                    if (parsedResult["result"] == "Success") {
                        // TODO: Deserialize lines.
                    }
                }
            }
            catch {
                // Log warning.
                print("Failed to create new sketch.")
            }
        }
        ~>
        {
            // Nothing to do here.
        })
    }
}