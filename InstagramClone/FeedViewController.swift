//
//  FeedViewController.swift
//  InstagramClone
//
//  Created by Doğanay Şahin on 18.09.2021.
//

import UIKit
import Firebase
import SDWebImage
class FeedViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArray = [String]()
    var postedByArray = [String]()
    var commentArray = [String]()
    var likeArray = [Int]()
    var imageArray = [String]()
    var documentIDArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getDataFromFireStore()
        // Do any additional setup after loading the view.
    }
    

    func getDataFromFireStore(){
        let fireStoreDatabase = Firestore.firestore()
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            
        
            if error != nil {
                print("err")
            }
            else{
                if snapshot?.isEmpty != true && snapshot != nil {
                    self.commentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.postedByArray.removeAll(keepingCapacity: false)
                    self.imageArray.removeAll(keepingCapacity: false)
                    self.documentIDArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents{
                        let documentID = document.documentID
                        self.documentIDArray.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String{
                            self.postedByArray.append(postedBy)
                        }
                        
                        if let comment = document.get("postComment") as? String{
                            self.commentArray.append(comment)
                        }
                        if let like = document.get("likes") as? Int{
                            self.likeArray.append(like)
                        }
                        if let imageUrl = document.get("imageUrl") as? String{
                            self.imageArray.append(imageUrl)
                        }
                    }
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postedByArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCellTableViewCell
        

        
        cell.commentText.text = commentArray[indexPath.row]
        cell.likeText.text = String(likeArray[indexPath.row])
        cell.usernameText.text = postedByArray[indexPath.row]
        cell.userImageView.sd_setImage(with: URL(string: self.imageArray[indexPath.row]))
        cell.documentIDText.text = documentIDArray[indexPath.row]
        return cell
    }
    

}
