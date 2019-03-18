//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Taher on 3/17/19.
//  Copyright © 2019 codepath. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var posts = [PFObject]()
    let commentBar = MessageInputBar()
    var showsBar = false
    var selectedPost: PFObject!
    let refreshControl = UIRefreshControl()
//    var num: Int = 20

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        self.tableView.estimatedRowHeight = 550
        self.tableView?.rowHeight = UITableView.automaticDimension
        
        tableView.keyboardDismissMode = .interactive
        
        let notifCenter = NotificationCenter.default
        notifCenter.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        commentBar.inputTextView.placeholder = "Add a comment"
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
    }
    
    @objc func loadPosts(){
        let query = PFQuery(className: "Posts")
        query.includeKeys(["author", "comments", "comments.author"])
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!.reversed()
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
//    func loadMorePosts(){
//        let query = PFQuery(className: "Posts")
//        query.includeKey("author")
//        num = num + 20
//        query.limit = num
//        
//        query.findObjectsInBackground { (posts, error) in
//            if posts != nil {
//                self.posts = posts!
//                self.tableView.reloadData()
//                self.refreshControl.endRefreshing()
//            }
//        }
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row + 1 == posts.count {
//            loadMorePosts()
//        }
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPosts()
    }
    
    @objc func keyboardWillBeHidden(note: Notification) {
        commentBar.inputTextView.text = nil
        showsBar = false
        becomeFirstResponder()
    }
    
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool{
        return showsBar
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        // Post comment
        let comment = PFObject(className: "Comments")
        comment["text"] = text
        comment["post"] = selectedPost
        comment["author"] = PFUser.current()!
        
        selectedPost.add(comment, forKey: "comments")
        selectedPost.saveInBackground { (success, error) in
            if success {
                print("Saved comment")
            } else {
                print("Failed saving comment")
            }
        }
        tableView.reloadData()
        
        // Clear message bar
        commentBar.inputTextView.text = nil
        showsBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        return comments.count + 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostTableViewCell
            
            let imageFile = post["image"] as! PFFileObject
            let imageURL = URL(string: imageFile.url!)!
            
            cell.userLabel.text = (post["author"] as! PFUser).username
            cell.captionLabel.text = post["caption"] as? String
            cell.photo.af_setImage(withURL: imageURL)
            
            return cell
        } else if indexPath.row <= comments.count {
            let comment = comments[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            
            cell.nameLabel.text = (comment["author"] as! PFUser).username
            cell.commentLabel.text = comment["text"] as? String
            
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == comments.count + 1 {
            showsBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            
            selectedPost = post
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.window?.rootViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
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
