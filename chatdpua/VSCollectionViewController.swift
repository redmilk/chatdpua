//
//  SuperTableViewController.swift
//  chatdpua
//
//  Created by Artem on 1/24/17.
//  Copyright © 2017 ApiqA. All rights reserved.
//

import UIKit
import FirebaseDatabase
import IGListKit

/*
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


class VSCollectionViewController: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataBaseHandle: FIRDatabaseHandle?
    
    var vsPosts = [VS]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        retrieveVSPosts()
        
        ///ref.removeAllObservers()
        dataBaseHandle = ref!.child("vs").child("posts").observe(.childAdded, with: { (snapshot) in
            //add listener to our Posts, of event child Added
            //take the value from snapshot
            
            /// HE PA6OTAET //sobitie pri dobavlenii posta
            let check = snapshot.value as? [String : AnyObject]
            if let posts = check {
                for(_, post) in posts {
                    if let author = post["author"] as? String, let header = post["header"] as? String, let userID = post["userID"] as? String, let likes = post["likes"] as? Int, let image1 = post["pathToImage1"] as? String, let image2 = post["pathToImage2"] as? String, let postID = post["postID"] as? String {
                        
                        let vsPost = VS(author: author, header: header, postID: postID, userID: userID, pathToImage1: image1, pathToImage2: image2, date: Date(timeIntervalSinceNow: -100), likes: likes)
                        vsPost.comments.append("My commentary from observe")
                        vsPost.comments.append("Commentary number two from observe adding")
                        self.vsPosts.append(vsPost)
                        //self.collectionView.reloadData()
                    }
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        print("back button pressed")
    }
    
    
    func retrieveVSPosts() {
        ref.child("vs").child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
            //all posts
            let postsSnap = snap.value as! [String : AnyObject]
            //loop through posts
            for(_, post) in postsSnap {
                //take another properties from post
                if let author = post["author"] as? String, let header = post["header"] as? String, let userID = post["userID"] as? String, let likes = post["likes"] as? Int, let image1 = post["pathToImage1"] as? String, let image2 = post["pathToImage2"] as? String, let postID = post["postID"] as? String {
                    // create new post
                    let vsPost = VS(author: author, header: header, postID: postID, userID: userID, pathToImage1: image1, pathToImage2: image2, date: Date(timeIntervalSinceNow: -100), likes: likes)
                    //fetch comments
                    if let comments = post["comments"] as? [String : AnyObject] {
                        for(_, comment) in comments {
                            vsPost.comments.append(comment as! String)
                        }
                    }
                    //add that Post object into self [Post] array
                    self.vsPosts.append(vsPost)
                }
            }
            /// adapter update
            //  adapter update
            //self.collectionView.reloadData()
        })
        ref.child("vs").removeAllObservers()
    }
    
    public func appendToArrayAndReloadTableView(vsPost: VS) {
        vsPosts.append(vsPost)
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMakeVS" {
            let destination = segue.destination as! MakeVSViewController
            destination.appendAndReloadClosure = self.appendToArrayAndReloadTableView
        }
    }
    
    //numberOfSections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vsPosts.count
    }
    
    //cellForItemAtindexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! VSCollectionViewCell
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SuperTableViewCell
        cell.firstImageView.downloadImage(from: vsPosts[indexPath.row].pathToImage1)
        cell.secondImageView.downloadImage(from: vsPosts[indexPath.row].pathToImage2)
        //table view v yacheike table view eto vsegolish peredat massiv v yacheiku. lol
        cell.comments = vsPosts[indexPath.row].comments
        cell.header = vsPosts[indexPath.row].header
        cell.labelOne = vsPosts[indexPath.row].labelOne
        cell.labelTwo = vsPosts[indexPath.row].labelTwo
        //inner use
        cell.postID = vsPosts[indexPath.row].postID
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.blue.cgColor, UIColor.red.cgColor]
        gradient.locations = [0.0 , 0.5]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: cell.contentView.frame.size.width, height: cell.contentView.frame.size.height)
        gradient.zPosition = -10
        cell.gradient = gradient
        cell.contentView.layer.addSublayer(gradient)
        
        
        
        return cell
    }
}
 
 */
