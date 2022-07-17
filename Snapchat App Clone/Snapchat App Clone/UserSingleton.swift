//
//  UserSingleton.swift
//  Snapchat App Clone
//
//  Created by Yavuz Güner on 16.07.2022.
//

import Foundation

class UserSingleton {
    
    //Tek obje oluşturmak için yaptık bunu. Foursquare clone videosunu izlicem.
    static let sharedUserInfo = UserSingleton()
    
    var email = ""
    var username = ""
    
    private init(){
        
    }
}
