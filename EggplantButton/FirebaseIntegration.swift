//
//  Firebase.swift
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 4/7/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

import Foundation
import Firebase

@objc class FirebaseAPIClient: NSObject {
    
    // Test Function that calls all other functions to test
    func testFirebaseFunctions () {
        
        print("Running Firebase test functions.")
        
        getAllUsersWithCompletion { (allUsernames) in
            if allUsernames.isEmpty {
                print("No usernames were returned.")
            } else {
                print("This is the test function calling for all usernames:\n\(allUsernames)")
            }
        }
        
        checkIfUsernameIsUniqueWithUsername("testy") { (isUnique) in
            if isUnique {
                print("testy is a unique username.")
            } else {
                print("testy is not a unique username.")
            }
        }
        
        checkIfUsernameIsUniqueWithUsername("testy1") { (isUnique) in
            if isUnique {
                print("testy1 is a unique username.")
            } else {
                print("testy1 is not a unique username.")
            }
        }
        
//        // Set reference to root Firebase location
//        let ref = Firebase(url:firebaseRootRef)
//        
//        var userRef : Firebase
//        
//        // Check if a user is currently logged in
//        if ref.childByAppendingPath("users").childByAppendingPath(ref.authData.uid) != nil {
//            
//            // If a user is currently logged in, set reference to current user
//            userRef = ref.childByAppendingPath("users").childByAppendingPath(ref.authData.uid)
//            
//            // Check if test user is logged in
//            if userRef.valueForKey("email") != nil && (userRef.valueForKey("email")?.isEqualToString("test@test.com"))!  {
//                
//                // Remove test user from Firebase
//                removeUserFromFirebaseWithEmail("test@test.com", password: "whatever", competion: { (result: Bool) in
//                    
//                    let reomvalResult = result ? "User removed successfully." : "User was not removed."
//                    
//                    print(reomvalResult)
//                })
//            }
//
//        }
//        
//        
//        // Make sure no user is logged in
//        logOutUser()
//        
//        // Create new test user
//        let newUser : User = User.init(email: "test@test.com", username: "testy")
//        
//        // Register new test user
//        registerNewUserWithUser(newUser, password: "whatever") { result in
//            
//            let wereGood = result ? "We good." : "We bad."
//            
//            print(wereGood)
//            
//            self.loginUserWithEmail("test@test.com", password: "whatever")
//            
//            if ref.authData != nil {
//                
//                self.createUserObjectFromFirebaseWithUserID(ref.authData.uid) { (user) in
//                    print("User object created for \(user.username).")
//                }
//                
//            } else {
//                print("No authData retrived in user registration.")
//            }
//        }
    }
    
    
    // TODO: Global save function which calls appropriate API save function based on type of data passed in
    
    // Login and authenticate user given email and password
    func loginUserWithEmail(email:String, password:String) {
        
        print("Attempting to log in user with email: \(email)")
        
        // Set base
        let ref = Firebase(url:firebaseRootRef)
        
        // Attempt user login
        ref.authUser(email, password: password) {
            error, authData in
            
            print("inAUTHUSER Closure--- error: \(error), authData: \(authData)")
            
            
            if error != nil {
                print("An error occurred while attempting login: \(error.description)")
            } else {
                print("User is logged in, checking authData for data")
            }
            if authData.auth != nil {
                print("authData has data!")
            } else {
                print("authData has no data :(")
            }
        }
    }
    
    // Register a new user in firebase given a User object and password
    func registerNewUserWithUser(user : User, password : String, completion: (Bool) -> ()) {
        
        print("Attempting to register user: \(user.username)")
        
        // Set reference for firebase account
        let ref = Firebase(url:firebaseRootRef)
        
        print("user email = \(user.email)")
        print("password = \(password)")
        print("ref = \(ref)")
        
        
        // Create user with email from user object and password string
        ref.createUser(user.email, password: password, withValueCompletionBlock: { error, result in
            
            
            guard let uid = result["uid"] as? String else { completion(false); fatalError("Back from firebase, uid is NIL not good.") }
            
            
            print("In the creatuserCLOSURE ---- error: \(error), result: \(result)")
            
            if error != nil {
                print("There was an error creating the user: \(error.description)")
            } else {
                
                
                print("Successfully created user account with uid: \(uid)")
                
                // Set references for new user
                let usersRef = ref.childByAppendingPath("users")
                let userRef = usersRef.childByAppendingPath(uid)
                
                // Set properties for new user account
                userRef.setValue([
                    "userID" : uid,
                    "username" : user.username,
                    "email" : user.email,
                    "bio" : user.bio,
                    "location" : user.location,
                    "saved itineraries" : user.savedItineraries,
                    "preferences" : user.preferences,
                    "ratings" : user.ratings,
                    "tips" : user.tips,
                    "reputation" : user.reputation,
                    "profilePhoto" : user.profilePhoto
                    ])
                
                // We should actually call firebase to pull values for new user and make sure everything was set correctly
                print("Registered new user: \(userRef)")
            }
            
            
            completion(true)
            
        })
    }
    
    // Return list of all users
    func getAllUsersWithCompletion(completion: Array<String> -> Void) {
    
        print("Getting a list of all users at the users reference in Firebase.")
        
        // Create array for all usernames
        var allUsernames = [String]()
        
        // Set refgerence to root Firebase location
        let ref = Firebase(url:firebaseRootRef)
        
        // Set child references within the root reference
        let usersRef = ref.childByAppendingPath("users")
        
        // Attach a closure to read the data at our posts reference
        usersRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
//            print("This is the snapshot.value:\n\(snapshot.value)")
            
            // Add each username value for each user reference to the allUsernames array
            for child in snapshot.children{
                if let username = child.value["username"] as? String {
                    print("Adding \(username) to the allUsernames array.")
                    allUsernames.append(username.lowercaseString)
                }
            }
            
            print("All usernames inside the observe block:\n\(allUsernames)")
            
            completion(allUsernames)
            
            }, withCancelBlock: { error in
                print("Error retrieving all usernames:\n\(error.description)")
                completion([])
        })
    }
    
    // Compare given username to all usernames in Firebase and return unique-status
    func checkIfUsernameIsUniqueWithUsername(username: String, completion: Bool -> Void) {
        
        print("Checking if username: \(username) is unique.")
        
        // Call function to retrieve all usernames in Firebase
        getAllUsersWithCompletion { (allUsernames) in
            
            print("Filtering returned usernames by \(username).")
            
            // Filter usernames returned from Firebase by the username passed into the check function
            let filteredNames = allUsernames.filter { $0 == username.lowercaseString }
            
            // Pass the appropriate response to the completion block depending on presence of the given username
            if filteredNames.isEmpty {
                print("Username is not already in use.")
                completion(true)
            } else {
                print("Username is already in use.")
                completion(false)
            }
        }
    }
    
    // Return list of all itineraries
    func getAllItinerariesWithCompletion(completion:(success: Bool) -> ()) {
        
        completion(success: true)
    }
    
    func saveNewItineraryWithItinerary(itinerary : Itinerary) -> String {
        
        // Set references for new itinerary
        let ref = Firebase(url:firebaseRootRef)
        let itinerariesRef = ref.childByAppendingPath("itineraries")
        
        // Create firebase reference for given itinerary
        let newItineraryRef = itinerariesRef.childByAutoId()
        
        // Access unique key created for new itinerary reference
        let newItineraryID = newItineraryRef.key
        
        // Set values of the new itinerary reference with properties on the itinerary
        newItineraryRef.setValue([
            "itineraryID" : newItineraryID,
            "creationDate" : convertDateToStringWithDate(itinerary.creationDate),
            "activities" : itinerary.activities,
            "ratings" : itinerary.ratings,
            "tips" : itinerary.tips,
            "photos" : itinerary.photos,
            "userID" : ref.authData.uid,
            "title" : itinerary.title
            ])
        
        print("Added new itinerary with title: \(itinerary.title) and ID: \(newItineraryID)")
        
        // Return the new
        return newItineraryID
    }
    
    // Create a new image reference in Firebase and return its unique ID
    func saveNewImageWithImage(image : UIImage, completion: String -> ()) -> Void {
        
        // Set references for new itinerary
        let ref = Firebase(url:firebaseRootRef)
        let imagesRef = ref.childByAppendingPath("images")
        
        // Create firebase reference for given itinerary
        let newImageRef = imagesRef.childByAutoId()
        
        // Create data from image
        let newImageData : NSData = UIImagePNGRepresentation(image)!
        
        // Convert image data into base 64 string
        let newImageBase64String : NSString! = newImageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        // Set values of the new itinerary reference with properties on the itinerary
        let newImageID = newImageRef.key
        newImageRef.setValue([
            "imageID" : newImageID,
            "imageBase64String" : newImageBase64String // TODO: Values for this key should be the keys for every photo attached to the itinerary, and the photo keys should be created in another function
            ])
        
        print("Image with ImageID: \(newImageID) added to Firebase")
        
        // Return the new image's ID
        completion(newImageID)
    }
    
    // Create a User object from Firebase data using a user ID
    func createUserObjectFromFirebaseWithUserID(userID : String, completion : User -> ()) {
        
        print("Creating user object from user reference: \(userID)")
        
        // Set references to call for user info
        let ref = Firebase(url:firebaseRootRef)
        let usersRef = ref.childByAppendingPath("users")
        let userRef = usersRef.childByAppendingPath(userID)
        
        // Read data at user reference
        userRef.observeEventType(.Value, withBlock: { snapshot in
            let sv = snapshot.value
            print("User ref:\n\(sv)")
            
            // Set User properties based on what data is available from the user reference
            
            var savedItineraries : NSMutableDictionary = [:]
            var tips : NSMutableDictionary = [:]
            var ratings : NSMutableDictionary = [:]
            
            if (sv["savedItineraries"] != nil) {
                savedItineraries = sv["savedItineraries"]! as! NSMutableDictionary
                print("User has itineraries: \(sv["savedItineraries"])")
            }
            
            if (sv["tips"] != nil) {
                tips = sv["tips"]! as! NSMutableDictionary
                print("User has tips: \(sv["tips"])")
            }
            
            if (sv["ratings"] != nil) {
                ratings = sv["ratings"]! as! NSMutableDictionary
                print("User has ratings: \(sv["ratings"])")
            }
            
            // Create new User object
            let newUser : User = User.init(userID: sv["userID"]! as! String, username: sv["username"]! as! String, email: sv["email"]! as! String, bio: sv["bio"]! as! String, location: sv["location"]! as! String, savedItineraries: savedItineraries, preferences: sv["preferences"]! as! NSMutableDictionary, ratings: ratings, tips: tips, profilePhoto: sv["profilePhoto"]! as! NSData, reputation: sv["reputation"]! as! UInt)
            
            print("Created User object for: \(newUser.username)")
            
            completion(newUser)
            
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
    // Convert date objects to strings
    func convertDateToStringWithDate(date:NSDate) -> String {
        
        // Create date formatter and set format style
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Format date into string
        let dateString = dateFormatter.stringFromDate(date)
        
        print("Converted date into: \(dateString)")
        
        // Send back the converted date
        return dateString
    }
    
    func logOutUser() {
        // Set references
        let ref = Firebase(url:firebaseRootRef)
        
//        print("Logging out uid: \(ref.authData.uid)")
        
        ref.unauth()
        
        print("User logged out")
    }
    
    func removeUserFromFirebaseWithEmail(email:String, password:String, competion:(Bool) -> ()) {
        
        print("Attempting to remove user with email \(email)")
        
        // Create a reference to root Firebase location
        let ref = Firebase(url:firebaseRootRef)
        
        print(ref)
        
        ref.removeUser(email, password: password) { (error:NSError!) in
            if error != nil {
                print("Error while removing user: \(error.description)")
            }
        }
        
        competion(true)
    }
}