//
//  CameraViewController.swift
//  Instagram
//
//  Created by Lin Zhou on 3/7/17.
//  Copyright © 2017 Lin Zhou. All rights reserved.
//

import UIKit
import Parse
//import AFNetworking

protocol CameraDelegate: class{
    func useCamera()
}

class Post: PFObject{
    var image: UIImage?
    var caption: String?
    var author: String?
    
//    var mediaURL: URL?{
//        let file = objectForKey
//        let url =
//        //mediaURL = URL(string: Post.getURL)
//        
//    }
    
    /** Method to add a user post to Parse (uploading image file)
     
     - parameter image: Image that the user wants upload to parse
     - parameter caption: Caption text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    
    class func postUserImage(image: UIImage?, withCaption caption:String?, withCompletion completion: PFBooleanResultBlock?) {
        let post = PFObject(className: "Post")
        
        //add relevant fields
        post["media"] = getPFFileFromImage(image: image) //PFFile column type
        post["author"] = PFUser.current() //Pointer column type that points to PFUser
        post["caption"] = caption
        //post["likesCount"] = 0
        //post["commentsCount"]=0
        
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackground(block: completion)
    
}
    
    /**
     Method to convert UIImage to PFFile
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        if let image = image{
            if let imageData = UIImagePNGRepresentation(image){
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
}

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var myImageView: UIImageView!
    weak var delegate: CameraDelegate?
    var image = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        myImageView.addGestureRecognizer(tap)
        myImageView.isUserInteractionEnabled = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageTapped(_gesture: UITapGestureRecognizer){
        print("image tapped")
        if let delegate = delegate{
            delegate.useCamera()
        }
        
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        //vc.sourceType = UIImagePickerControllerSourceType.camera
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        image = info[UIImagePickerControllerOriginalImage] as! UIImage
        myImageView.image = image
        //let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postImage(_ sender: Any) {
        Post.postUserImage(image: image, withCaption: captionTextField.text) { (success:Bool, error:Error?) in
            if success{
                print("chosen image")
                self.myImageView.image = self.image
//                
                let tabBarController = appDelegate.window?.rootViewController as! UITabBarController

                let postsVC = tabBarController.viewControllers?.first as! PostsViewController
                postsVC.fetchPosts()
//                self.tabBarController?.selectedIndex = 0
//                self.dismiss(animated: true, completion: nil)
                //postsVC.viewDidLoad()
                self.performSegue(withIdentifier: "toHome", sender: nil)
            }
            else{
                print("\(error?.localizedDescription)")
            }
        }
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    func prepare(for segue: UIStoryboardSegue, sender: Any) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let postsVC = segue.destination as! PostsViewController
        
        //postsVC.tableView.reloadData()
        
    }
    

}
