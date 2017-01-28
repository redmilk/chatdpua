//
//  SuperTableViewController.swift
//  chatdpua
//
//  Created by Artem on 1/24/17.
//  Copyright © 2017 ApiqA. All rights reserved.
//

import UIKit
import FirebaseDatabase


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


class SuperTableViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataBaseHandle: FIRDatabaseHandle?
    
    var vsPosts = [VS]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        retrieveVSPosts()
        
        ///ref.removeAllObservers()
        dataBaseHandle = ref!.child("vs").child("posts").observe(.childAdded, with: { (snapshot) in
            //add listener to our Posts, of event child Added
            //take the value from snapshot
            
            
            /// HE PA6OTAET
            let posts = snapshot.value as? [String : AnyObject]
            if let actualPosts = posts {
                for(_, post) in actualPosts {
                    if let author = post["author"] as? String, let header = post["header"] as? String, let userID = post["userID"] as? String, let likes = post["likes"] as? Int, let image1 = post["pathToImage1"] as? String, let image2 = post["pathToImage2"] as? String, let postID = post["postID"] as? String {
                        
                        let vsPost = VS()
                        vsPost.author = author
                        vsPost.header = header
                        vsPost.userID = userID
                        vsPost.likes = likes
                        vsPost.pathToImage1 = image1
                        vsPost.pathToImage2 = image2
                        vsPost.postID = postID
                        vsPost.comments.append("My commentary from observe")
                        vsPost.comments.append("Commentary number two from observe adding")
                        self.vsPosts.append(vsPost)
                        self.tableView.reloadData()
                    }
                }
            }
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (vsPosts.count != 0) ? vsPosts.count : 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SuperTableViewCell
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
    
    
    
    @IBAction func backPressed(_ sender: UIButton) {
        print("back button pressed")
    }
    
    func backToThisController(segue: UIStoryboardSegue) {
        
    }
    
    func retrieveVSPosts() {
        ref.child("vs").child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
            //all posts
            let postsSnap = snap.value as! [String : AnyObject]
            //loop through posts
            for(_, post) in postsSnap {
                //create new Post object
                let vsPost = VS()
                //take another properties from post
                if let author = post["author"] as? String, let header = post["header"] as? String, let userID = post["userID"] as? String, let likes = post["likes"] as? Int, let image1 = post["pathToImage1"] as? String, let image2 = post["pathToImage2"] as? String, let postID = post["postID"] as? String {
                    //fill Post object
                    vsPost.author = author
                    vsPost.header = header
                    vsPost.userID = userID
                    vsPost.likes = likes
                    vsPost.pathToImage1 = image1
                    vsPost.pathToImage2 = image2
                    vsPost.postID = postID
                    
                    if let comments = post["comments"] as? [String : AnyObject] {
                        for(_, comment) in comments {
                            vsPost.comments.append(comment as! String)
                        }
                    }
                    //add that Post object into self [Post] array
                    self.vsPosts.append(vsPost)
                }
            }
            self.tableView.reloadData()
        })
        //refresh table/collection view≥
        ref.child("vs").removeAllObservers()
    }
    
    public func appendToArrayAndReloadTableView(vsPost: VS) {
        vsPosts.append(vsPost)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMakeVS" {
            let destination = segue.destination as! MakeVSViewController
            destination.appendAndReloadClosure = self.appendToArrayAndReloadTableView
        }
    }
}
