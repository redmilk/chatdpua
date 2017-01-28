//
//  MakeVSViewController.swift
//  chatdpua
//
//  Created by Artem on 1/27/17.
//  Copyright © 2017 ApiqA. All rights reserved.
//

import UIKit
import FirebaseAuth

class MakeVSViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerTextField: UITextField!
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var imageViewOne: UIImageView!
    @IBOutlet weak var imageViewTwo: UIImageView!
    @IBOutlet weak var labelVS: UILabel!
    @IBOutlet weak var textFieldOne: UITextField!
    @IBOutlet weak var textFieldTwo: UITextField!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonDone: UIButton!
    
    var imagePickerOne = UIImagePickerController()
    var imagePickerTwo = UIImagePickerController()
    
    var appendAndReloadClosure: ((_ vsPost: VS) -> ())!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerOne.delegate = self
        imagePickerTwo.delegate = self
        
        let tapGestureRecognizerOne = UITapGestureRecognizer(target:self, action:#selector(imageOneTapped(img:)))
        let tapGestureRecognizerTwo = UITapGestureRecognizer(target:self, action:#selector(imageTwoTapped(img:)))
        imageViewOne.isUserInteractionEnabled = true
        imageViewTwo.isUserInteractionEnabled = true
        imageViewOne.addGestureRecognizer(tapGestureRecognizerOne)
        imageViewTwo.addGestureRecognizer(tapGestureRecognizerTwo)
        
    }
    
    func imageOneTapped(img: AnyObject) {
        print("image One tapped")
        imagePickerOne.sourceType = .photoLibrary
        self.present(imagePickerOne, animated: true, completion:  nil)
    }
    
    func imageTwoTapped(img: AnyObject) {
        print("image Two tapped")
        imagePickerTwo.sourceType = .photoLibrary
        self.present(imagePickerTwo, animated: true, completion:  nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if picker == imagePickerOne {
                imageViewOne.image = image
            } else if picker == imagePickerTwo {
                imageViewTwo.image = image
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        AppDelegate.instance().showActivityIndicator()
        // MARK: - done button (saving)
        // id tekushego yuzera
        let uid = FIRAuth.auth()!.currentUser!.uid
        //budushiy klyuch posta v baze
        let key = ref.child("vs").child("posts").childByAutoId().key
        // v hranilishe pod Posts --> currentuser id --> klyuch nogo posta.jpg, eto budushyaya ssilka na kartinku
        let imageRef1 = storage.child("posts").child(uid).child("\(key)_1.jpg")
        let imageRef2 = storage.child("posts").child(uid).child("\(key)_2.jpg")
        //konvert image to data
        let data1 = UIImageJPEGRepresentation(self.imageViewOne.image!, 0.6)
        let data2 = UIImageJPEGRepresentation(self.imageViewTwo.image!, 0.6)
        //in image future adress we put our data
        
        let uploadTask1 = imageRef1.put(data1!, metadata: nil, completion: { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            //if no error, we can take futher this img url
            imageRef1.downloadURL(completion: { (url, err) in
                //if url exists
                if let url = url {
                    let uploadTask2 = imageRef2.put(data2!, metadata: nil, completion: { (metadata_, error_) in
                        if error_ != nil {
                            print(error_!.localizedDescription)
                            return
                        }
                        //if no error, we can take futher this img url
                        imageRef2.downloadURL(completion: { (url_, err_) in
                            //if url exists
                            if let url_ = url_ {
                                let vsPostInfo = ["header" : self.headerLabel.text!,
                                                  "labelOne" : self.textFieldOne.text!,
                                                  "labelTwo" : self.textFieldTwo.text!,
                                                  "userID" : uid,
                                                  "pathToImage1" : url.absoluteString,
                                                  "pathToImage2" : url_.absoluteString,
                                                  "likes" : 0,
                                                  "author" : FIRAuth.auth()?.currentUser!.displayName! as Any,
                                                  "postID" : key] as [String : Any]
                                
                                //post feed for database
                                let postFeed = ["\(key)" : vsPostInfo]
                                //insert in posts -> post feed
                                ref.child("vs").child("posts").updateChildValues(postFeed)
                                AppDelegate.instance().dismissActivityIndicator()
                                self.dismiss(animated: true, completion: nil)
                            }
                        })
                    })
                    uploadTask2.resume()
                }
            })
        })
        uploadTask1.resume()
        
                /**/
        //creating our post's data
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
