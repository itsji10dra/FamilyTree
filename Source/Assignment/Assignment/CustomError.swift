//
//  CustomError.swift
//  Assignment
//
//  Created by Jitendra on 23/04/17.
//  Copyright © 2017 Infinix. All rights reserved.
//

import Foundation

//Custom Error for handling server error in case of status code == 200.

protocol CustomErrorProtocol: Error {
    
    var localizedDescription: String { get }
}

struct CustomError: CustomErrorProtocol {
    
    var localizedDescription: String
    
    init(localizedDescription: String) {
        self.localizedDescription = localizedDescription
    }
}
