//
//  CameraViewController.swift
//  Parstagram
//
//  Created by Taher on 3/17/19.
//  Copyright © 2019 codepath. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var commentField: UITextField!
    let sourceDialog = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sourceDialog.addAction(UIAlertAction(title: "Launch camera", style: .default, handler: { (UIAlertAction) in
            self.sourceDialog.dismiss(animated: true, completion: {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = true
                picker.sourceType = .camera
                
                self.present(picker, animated: true, completion: nil)
            })
        }))
        sourceDialog.addAction(UIAlertAction(title: "Choose from Photo Library", style: .default, handler: { (UIAlertAction) in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            
            self.present(picker, animated: true, completion: nil)
        }))
    }
    

    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCapture(_ sender: Any) {
        present(sourceDialog, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
