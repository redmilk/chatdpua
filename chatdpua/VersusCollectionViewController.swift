//
//  FeedViewController.swift
//  Marslink
//
//  Created by Artem on 1/30/17.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//

import UIKit
import IGListKit
import FirebaseDatabase
import FirebaseAuth


@IBDesignable class GradientView: UIView {
    @IBInspectable var firstColor: UIColor = UIColor.white
    @IBInspectable var secondColor: UIColor = UIColor.black
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        (layer as! CAGradientLayer).colors = [firstColor.cgColor, secondColor.cgColor]
    }
}


// ////////////////// FEED ///////////////////////
class VersusCollectionViewController: UIViewController {
    
    // MARK: - FIELDS
    lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    } ()
    
    @IBOutlet weak var collectionView: IGListCollectionView!
    
    let generator = VersusGenerator()
    
    
    // MARK: - firebase
    var ref: FIRDatabaseReference?
    var dataBaseHandle: FIRDatabaseHandle?
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationController?.hidesBarsOnSwipe = true
    }
    // MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        //adapter preset
        adapter.collectionView = collectionView
        adapter.dataSource = self
        //generator delegate
        generator.delegate = self
        
        // MARK: - firebase
        ref = FIRDatabase.database().reference()
        dataBaseHandle = ref!.child("vs").child("posts").observe(.childAdded, with: { (snapshot) in
            let foo = snapshot.value as? [String : AnyObject]
            if let post = foo {
                if let author = post["author"] as? String, let header = post["header"] as? String, let likes = post["likes"] as? Int, let image1 = post["pathToImage1"] as? String, let image2 = post["pathToImage2"] as? String, let postID = post["postID"] as? String, let userID = post["userID"] as? String {
                    let vsPost = VS(author: author, header: header, postID: postID, userID: userID, pathToImage1: image1, pathToImage2: image2, date: Date(timeIntervalSinceNow: -100), likes: likes)
                    // it should be at Versus Generator
                    self.generator.versusPosts.append(vsPost)
                    //self.adapter.performUpdates(animated: true, completion: nil)
                }
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        collectionView.backgroundColor = UIColor.black
    }
    
    
    func addVersus() {
        // add versus code
        generator.versusPosts.append(VS(author: "Girl", header: "Select hottest one", postID: "http://www.hollywood-actors.ru/uploads/gallery/852_4.jpg", userID: "http://www.kino-teatr.ru/acter/album/50275/pv_699468.jpg", pathToImage1: "Lips", pathToImage2: "Cuttie", date: Date(timeIntervalSinceNow: 12)))
        adapter.performUpdates(animated: true, completion: nil)
    }
    
    @IBAction func addVersusPostButton(_ sender: UIBarButtonItem) {
        addVersus()
    }
    
}

// ////////////////// DELEG ///////////////////////
extension VersusCollectionViewController: IGListAdapterDataSource {
    
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        // 1
        var items: [IGListDiffable] = generator.versusPosts as [IGListDiffable]
        /*items += posts as [IGListDiffable]
         items += messager.messages as [IGListDiffable]*/
        // 2
        return items.sorted(by: { (left: Any, right: Any) -> Bool in
            if let left = left as? DateSortable, let right = right as? DateSortable {
                return left.date > right.date
            }
            return false
        })
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return VersusSectionController()
        /* if object is Message {
         return MessageSectionController()
         } else if object is Post {
         return PostSectionController()
         } else {
         return VersusSectionController()
         } */
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return nil
    }
}

extension VersusCollectionViewController: VersusGeneratorDelegate {
    func versusDidUpdatePostsArray(generator: VersusGenerator) {
        adapter.performUpdates(animated: true, completion: nil)
    }
}






