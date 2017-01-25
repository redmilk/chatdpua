//
//  AddRestaurantTableViewController.swift
//  Restaraunts
//
//  Created by Игорь on 08.12.15.
//  Copyright © 2015 Ihor Malovanyi. All rights reserved.
//

import UIKit
import CoreData

class SignUpTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//*** Этот класс мы полностью настроили на запись/прием введенной информации. *** Первым делом добавим аутлеты для всех объектов взаимодействия
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet var nameTextField:UITextField!
    @IBOutlet var typeTextField:UITextField!
    @IBOutlet var locationTextField:UITextField!
    @IBOutlet var yesButton:UIButton!
    @IBOutlet var noButton:UIButton!
    
    var isVisited = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    // MARK: - Action methods //Добавили кнопки
    @IBAction func save(_ sender:UIBarButtonItem) {
        let name = nameTextField.text
        let type = typeTextField.text
        let location = locationTextField.text
        
        // Проверка на валидность введенных строк
        
        
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func toggleBeenHereButton(_ sender: UIButton) {
        // Нажата кнопка Yes
        if sender == yesButton {
            isVisited = true
            yesButton.backgroundColor = UIColor(red: 235.0/255.0, green: 73.0/255.0, blue: 27.0/255.0, alpha: 1.0)
            noButton.backgroundColor = UIColor.gray
        } else if sender == noButton { //Нажата No
            isVisited = false
            yesButton.backgroundColor = UIColor.gray
            noButton.backgroundColor = UIColor(red: 235.0/255.0, green: 73.0/255.0, blue: 27.0/255.0, alpha: 1.0)
        }
    }
}
