//
//  SuperTableViewCell.swift
//  chatdpua
//
//  Created by Artem on 1/24/17.
//  Copyright © 2017 ApiqA. All rights reserved.
//

import UIKit

class SuperTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var labelVS: UILabel!
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var comments = [String]()
    var postID: String!
    
    var header: String!
    var labelOne: String!
    var labelTwo: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Initialization code
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        if inputTextField.text != "" {
            let keyToComment = ref.child("vs").child("posts").childByAutoId().key
            ref.child("vs").child("posts").child(postID).observeSingleEvent(of: .value, with: { (snapshot) in
                 if let postSnapshot = snapshot.value as? [String : AnyObject] {
                    let updateComments: [String : Any] = ["comments/\(keyToComment)": self.inputTextField.text!]
                    ref.child("vs").child("posts").child(self.postID).updateChildValues(updateComments)
                    self.comments.append(self.inputTextField.text!)
                }
                self.tableView.reloadData()
            })
            ref.removeAllObservers()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (comments.count != 0) ? comments.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SuperCommentTableViewCell
        cell.commentLabel.text = comments[indexPath.row]
        return cell
    }
    
}
