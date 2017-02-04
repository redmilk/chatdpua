//
//  VersusGenerator.swift
//  chatdpua
//
//  Created by Artem on 2/4/17.
//  Copyright © 2017 ApiqA. All rights reserved.
//

import Foundation



protocol VersusGeneratorDelegate: class {
    func versusDidUpdatePostsArray(generator: VersusGenerator)
}

class VersusGenerator {
    
    weak var delegate: VersusGeneratorDelegate?
    
    var versusPosts: [VS] = {
        var versusPosts = [VS]()
        //versusPosts.append(VersusPost(name: "Girl", header: "Beauty", imageOne: "1", imageTwo: "2", titleOne: "Chick", titleTwo: "Hottie", date: Date(timeIntervalSinceNow: -100)))
        //versusPosts.append(VersusPost())
        return versusPosts
        }() {
        didSet {
            delegate?.versusDidUpdatePostsArray(generator: self)
        }
    }
}
