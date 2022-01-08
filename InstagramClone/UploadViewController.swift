//
//  UploadViewController.swift
//  InstagramClone
//
//  Created by Doğanay Şahin on 18.09.2021.
//

import UIKit
import Firebase
class UploadViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(selectImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @IBAction func uploadButton(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data, metadata: nil) { storageMetadata, error in
                if error != nil{
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Something went wrong during upload.")
                }else {
                    imageReference.downloadURL { url, error in
                        if error == nil{
                            
                            let imageUrl = url?.absoluteString
                            
                            
                            //Database part
                            
                            let fireStoreDatabase = Firestore.firestore()
                            
                            let documentReference : DocumentReference? = nil
                            
                            let fireStorePost = [
                                "imageUrl" : imageUrl!,
                                "postedBy" : Auth.auth().currentUser!.email!,
                                "postComment" : self.commentField.text!,
                                "date" : FieldValue.serverTimestamp(),
                                "likes" : 0] as [String : Any]
                            
                            fireStoreDatabase.collection("Posts").addDocument(data: fireStorePost) { error in
                                if error != nil {
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                }else{
                                    self.imageView.image = UIImage(systemName: "square.and.arrow.down.on.square")
                                    self.commentField.text = ""
                                    
                                    self.tabBarController?.selectedIndex = 0
                                }
                            }
                            
                            
                        }
                    }
                }
            }
        }
        
        

    }
    
    @objc func selectImage(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeAlert(title : String , message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
