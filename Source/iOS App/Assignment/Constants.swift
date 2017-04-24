//
//  Constants.swift
//  Assignment
//
//  Created by Jitendra on 22/04/17.
//  Copyright © 2017 Infinix. All rights reserved.
//

//Constants
let kSuccess = "success"
let kFailure = "failure"
let kNotAvailable = "NA"
let kSavedSSNKey = "kSavedSSN"

//Networking

let username = "admin"
let password = "admin12345"

let baseURL = "localhost:8000"
let apiVersion = "/api/v1/"

let fullURL = "http://" + username + ":" + password + "@" + baseURL + apiVersion

let personAPI   = fullURL + "person/"
let relationAPI = fullURL + "relation/"
