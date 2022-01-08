//
//  FeedCellTableViewCell.swift
//  InstagramClone
//
//  Created by Doğanay Şahin on 19.09.2021.
//

import UIKit
import Firebase
class FeedCellTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameText: UILabel!
    
    @IBOutlet weak var commentText: UILabel!
    
    @IBOutlet weak var likebutton: UIButton!
    @IBOutlet weak var likeText: UILabel!
    
    @IBOutlet weak var documentIDText: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeClicked(_ sender: Any) {
        
        
        
            
            let firestoreDatabase = Firestore.firestore()
            if let likeCount = Int(likeText.text!) {
                let likeStore = ["likes" : likeCount + 1]
                firestoreDatabase.collection("Posts").document(documentIDText.text!).setData(likeStore, merge: true)
                
            }
        }
            
        

        
        
    
}
