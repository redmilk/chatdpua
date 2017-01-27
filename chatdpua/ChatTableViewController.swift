//
//  ChatTableViewController.swift
//  chatdpua
//
//  Created by Artem on 1/24/17.
//  Copyright © 2017 ApiqA. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChatTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //future
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    //current
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    //properties
    var posts = [Post]()
    
    ///methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //self-resizing cells
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        retrievePosts()
        
       
        
        /*NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [tableView beginUpdates];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [tableView endUpdates]; */
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .fade)
        tableView.endUpdates()

    }
    
    ///delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("DEBUG: \(posts.count) - numberOfRowsInSection")
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ChatTableViewCell
        
        cell!.name.text = posts[indexPath.row].author
        cell!.message.text = posts[indexPath.row].message
        // user image
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //knopka DELETE ALL (ex share)
        let share = UITableViewRowAction(style: .default, title: "Delete All", handler: { (action, indexPath)-> Void in
            
            self.deleteAllPostsFromDatabaseAndTableView()
            
            ///activity controller
            //self.activityControllerInit()
        })
        
        //knopka udalit' post
        let delete = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) -> Void in
            
            ///delete from database
            refToDataBaseWithPosts.child(self.posts[indexPath.row].postID).removeValue()
            
            ///delete from app
            self.posts.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        })
        
        share.backgroundColor = UIColor.black
        delete.backgroundColor = UIColor.magenta
        
        return [share, delete]
    }

    
    
    // MARK: - other methods
    
    func deleteAllPostsFromDatabaseAndTableView() {
        //delete all posts
        refToDataBaseWithPosts.setValue(nil)
        self.posts.removeAll()
        self.tableView.reloadData()
    }
    
    /// actions
    @IBAction func sendPressed(_ sender: UIButton) {
        guard textField.text != "" else {return}
        let currentUser = FIRAuth.auth()!.currentUser!
        let uid = currentUser.uid
        let key = refToDataBaseWithPosts.childByAutoId().key
        
        let postInfo: [String : Any] = [
            "postID" : key,
            "userID" : uid,
            "message": textField!.text as Any,
            "author" : currentUser.displayName!]
        let newPost = ["\(key)" : postInfo]
        refToDataBaseWithPosts.updateChildValues(newPost)
        
        let post = Post()
        post.author = currentUser.displayName!
        post.message = textField!.text
        post.postID = key
        post.userID = uid
        posts.append(post)
        tableView.reloadData()
        textField.text = ""
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
    }
    
    // MARK: - retrieve posts
    func retrievePosts() {
        /*refToDataBaseWithPosts*/
        ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            self.posts.removeAll()
            
            let posts = snapshot.value as! [String : AnyObject]
            for(_, value) in posts {
                if let retrievedPost = value as? [String : Any] {
                    if let author = retrievedPost["author"] as? String, let postID = retrievedPost["postID"] as? String, let message = retrievedPost["message"] as? String, let userID = retrievedPost["userID"] as? String {
                        let post = Post()
                        post.author = author
                        post.postID = postID
                        post.message = message
                        post.userID = userID
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
        ref.removeAllObservers()
    }
}
