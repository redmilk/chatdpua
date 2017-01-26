//
//  AddRestaurantTableViewController.swift
//  Restaraunts
//
//  Created by Игорь on 08.12.15.
//  Copyright © 2015 Ihor Malovanyi. All rights reserved.
//

import UIKit
import CoreData
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class SignUpTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    //*** Этот класс мы полностью настроили на запись/прием введенной информации. *** Первым делом добавим аутлеты для всех объектов взаимодействия
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet var nameTextField:UITextField!
    @IBOutlet var emailTextField:UITextField!
    @IBOutlet var pwd1TextField:UITextField!
    @IBOutlet var pwd2TextField:UITextField!
    
    @IBOutlet var yesButton:UIButton!
    @IBOutlet var noButton:UIButton!
    
    var refToStorageWithUsers: FIRStorageReference!
    var refToDataBase: FIRDatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - VIEW DID LOAD
        let storage = FIRStorage.storage().reference(forURL: "gs://chatdpua.appspot.com")
        refToStorageWithUsers = storage.child("users")
        refToDataBase = FIRDatabase.database().reference()
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        pwd1TextField.delegate = self
        pwd2TextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        } else {
            //other cells
            switch indexPath.row {
            case 1:
                nameTextField.becomeFirstResponder()
                break
            case 2:
                emailTextField.becomeFirstResponder()
                break
            case 3:
                pwd1TextField.becomeFirstResponder()
                break
            case 4:
                pwd2TextField.becomeFirstResponder()
                break
            default:
                break
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - UIImagePickerControllerDelegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
    
    ///         SAVE ('Done' button)
    // MARK: - SAVE BUTTON
    @IBAction func save(_ sender:UIBarButtonItem) {
        let name = nameTextField.text!
        let email = emailTextField.text!
        let pwd1 = pwd1TextField.text!
        let pwd2 = pwd2TextField.text!
        let img = imageView.image!
        
        if img == UIImage(named: "photoalbum")! {
            // MARK: - vstavit alert
        }
        
        // Проверка на валидность введенных строк
        guard name != "", email != "", pwd1 != "", pwd2 != "" else {
            // vstavit alert
            // MARK: - vstavit alert
            return
        }
        if pwd1 != pwd2 {
            // vstavit alert
            // MARK: - vstavit alert
            return
        } else {
            FIRAuth.auth()?.createUser(withEmail: email, password: pwd1, completion: { (user, error) in
                
                if error != nil {
                    //vstavit alert
                    // MARK: - vstavit alert
                    //error!.localizedDescription
                    return
                }
                
                if let user = user {
                    // MARK: - new user has been registred
                    let changeRequest = FIRAuth.auth()!.currentUser!.profileChangeRequest()
                    changeRequest.displayName = name
                    changeRequest.commitChanges(completion: nil)
                    //sozdaem ssilku v storage, so znacheniem user id, tam budet hranitsya kartinka, pod imenem id usera
                    let imageRef = self.refToStorageWithUsers.child("\(user.uid)")
                    //szhat kartinku, --> data
                    let imageFromImageView = UIImageJPEGRepresentation(self.imageView.image!, 0.5)
                    //vigruzit ee v hranilishe
                    let uploadTask = imageRef.put(imageFromImageView!, metadata: nil, completion: { (meta, error_) in
                        if error_ != nil {
                            // vstavit alert
                            // MARK: - vstavit alert
                            return
                        }
                        //vzyat ssilku na teper zagruzhennuyu kartinku iz hranilishya
                        imageRef.downloadURL(completion: { (url, error__) in
                            if error__ != nil {
                                // vstavit alert
                                // MARK: - vstabit alert
                                return
                            }
                            if let url = url {
                                //poluchili url na kartinku kotouyu dobavim v map
                                //sozdali infu o yuzere, upakovali v map
                                let userInfo: [String : Any] = ["uid" : user.uid,
                                                                "name" : name,
                                                                "avatar" : url.absoluteString]
                                
                                //sozdaem v data base vkladku users/HjhdSjlK34H8jsd 'userID'
                                //teper nuzhno prikrepit k yuzeru kotoriy tolko chto zaregistrirovalsya eto infu v database
                                self.refToDataBase.child("users").child(user.uid).setValue(userInfo)
                                
                                //perehodim dalshe v osnovnoi view controller
                                let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainVC")
                                self.present(mainVC, animated: true, completion: nil)
                            }
                        })
                    })
                    //nachat zagruzku?
                    uploadTask.resume()
                }
            })
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func toggleBeenHereButton(_ sender: UIButton) {
        // Нажата кнопка Yes
        if sender == yesButton {
            //isVisited = true
            yesButton.backgroundColor = UIColor(red: 235.0/255.0, green: 73.0/255.0, blue: 27.0/255.0, alpha: 1.0)
            noButton.backgroundColor = UIColor.gray
        } else if sender == noButton { //Нажата No
            //isVisited = false
            yesButton.backgroundColor = UIColor.gray
            noButton.backgroundColor = UIColor(red: 235.0/255.0, green: 73.0/255.0, blue: 27.0/255.0, alpha: 1.0)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
