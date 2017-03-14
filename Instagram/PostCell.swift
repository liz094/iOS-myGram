//
//  PostCell.swift
//  Instagram
//
//  Created by Lin Zhou on 3/13/17.
//  Copyright © 2017 Lin Zhou. All rights reserved.
//

import UIKit
import Parse

class PostCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    var post :PFObject!{
        didSet{
            print("post object set")
            
            if let postImage = post["media"] as? PFFile{
                postImage.getDataInBackground({ (imageData:Data?, error:Error?) in
                    if let imageData = imageData{
                        self.postImageView.image = UIImage(data: imageData)
                    }
                })
            }
            
            //self.postImageView = post["media"] as? UIImageView
            self.captionLabel.text = post["caption"] as? String
            self.authorLabel.text = post["author"] as? String
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
