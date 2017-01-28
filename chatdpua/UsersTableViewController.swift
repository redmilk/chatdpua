//
//  UsersTableViewController.swift
//  chatdpua
//
//  Created by Artem on 1/26/17.
//  Copyright © 2017 ApiqA. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

extension UIImageView {
    func downloadImage(from imgURL: String!) {
        
        let url = URLRequest(url: URL(string: imgURL)!)
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
            
        })
        task.resume()
    }
}


class UsersTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var users = [User]()
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - view did load
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.retrieveUsers()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (users.count != 0) ? users.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // MARK: - cell for row at..
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UsersTableViewCell
        cell.userName.text = users[indexPath.row].name
        cell.userImage.downloadImage(from: users[indexPath.row].avatar)
        cell.userInfo.text = users[indexPath.row].name
        
        return cell
    }
    
    
    // MARK: - methods
    func retrieveUsers() {
        // MARK: - retrieve from firebase
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            self.users.removeAll()
            let users = snapshot.value as! [String : AnyObject]
            for(_, user) in users {
                if let uid = user["uid"] as? String {
                    if uid != FIRAuth.auth()!.currentUser!.uid {
                        let userToShow = User()
                        if let name = user["name"] as? String, let avatar = user["avatar"] as? String{
                            // MARK: - filling user's fields
                            userToShow.userID = uid
                            userToShow.name = name
                            userToShow.avatar = avatar
                            self.users.append(userToShow)
                        }
                    }
                }
            }
            self.tableView.reloadData()
        })
        ref.removeAllObservers()
    }
}
