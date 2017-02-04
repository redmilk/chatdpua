//
//  VS.swift
//  chatdpua
//
//  Created by Artem on 1/27/17.
//  Copyright © 2017 ApiqA. All rights reserved.
//

import Foundation

class VS : NSObject, DateSortable {
    
    var author: String
    var header: String
    var labelOne: String
    var labelTwo: String
    var postID: String
    var userID: String
    var pathToImage1: String
    var pathToImage2: String
    var likes: Int
    var date: Date
    var comments = [String]()
    
    init(author: String,
         header: String,
         postID: String,
         userID: String,
         pathToImage1: String,
         pathToImage2: String,
         date: Date,
         labelOne: String = "Object One",
         labelTwo: String = "Object Two",
         likes: Int = 0
        ) {
        self.author = author
        self.header = header
        self.labelOne = labelOne
        self.labelTwo = labelTwo
        self.postID = postID
        self.userID = userID
        self.pathToImage1 = pathToImage1
        self.pathToImage2 = pathToImage2
        self.date = date
        self.likes = likes
    }
}


/* good randomizer generit po 10 chisel, potom iz nih srednee brat */
