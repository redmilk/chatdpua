//
//  VersusSectionController.swift
//  Marslink
//
//  Created by Artem on 2/3/17.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//

import UIKit
import IGListKit

class VersusSectionController: IGListSectionController {
    var versusPost: VS!
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
}

/* init(author: String,
 header: String,
 labelOne: String,
 labelTwo: String,
 postID: String,
 userID: String,
 pathToImage1: String,
 pathToImage2: String,
 date: Date
 ) {
 */

extension VersusSectionController: IGListSectionType {
    func numberOfItems() -> Int {
        return 1
    }
    func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 186.0)
    }
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCellFromStoryboard(withIdentifier: "VersusCell", for: self, at: index) as! VersusCell
        cell.headerLabel.text = self.versusPost.header
        cell.titleOneLabel.text = self.versusPost.labelOne
        cell.titleTwoLabel.text = self.versusPost.labelOne
        
        cell.imageOne.sd_setImage(with: URL(string: self.versusPost.pathToImage1), placeholderImage: UIImage(named: "photoalbum"), options: [.avoidAutoSetImage, .progressiveDownload])
        
        cell.imageTwo.sd_setImage(with: URL(string: self.versusPost.pathToImage2), placeholderImage: UIImage(named: "photoalbum"), options: [.avoidAutoSetImage, .progressiveDownload])
        
        return cell
    }
    func didUpdate(to object: Any) {
        self.versusPost = object as? VS
    }
    func didSelectItem(at index: Int) {
    }
}
