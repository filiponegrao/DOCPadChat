//
//  TesteViewController.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 14/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import UIKit

class TesteViewController: UIViewController
{

    private var button : UIButton!
    
    private var login : UITextField!
    
    private var friend : UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()

        self.button = UIButton(frame: CGRectMake(0,0,screenWidth/1.5, screenWidth/6))
        self.button.center = self.view.center
        self.button.setTitle("Acessar Chat", forState: .Normal)
        self.button.backgroundColor = blueColor
        self.button.addTarget(self, action: #selector(self.openChat), forControlEvents: .TouchUpInside)
        self.button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.view.addSubview(self.button)
        
        self.login = UITextField(frame: CGRectMake(0,0,screenWidth/2, 44))
        self.login.placeholder = "Login"
        self.login.center = CGPointMake(screenWidth/2, screenHeight/5)
        self.login.autocorrectionType = .No
        self.login.autocapitalizationType = .None
//        self.view.addSubview(self.login)
        
        self.friend = UITextField(frame: CGRectMake(self.login.frame.origin.x, self.login.bounds.height, screenWidth/2, 44))
        self.friend.placeholder = "Friend"
        self.friend.autocorrectionType = .No
        self.friend.autocapitalizationType = .None
//        self.view.addSubview(self.friend)
 
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func openChat()
    {
        let ip = "52.67.65.109"
        
        let username =  "test1" //self.login.text!
        
        let friend = "test2" // self.friend.text!
        
        let model = UserModel(id: "\(friend)@\(ip)", name: friend, profileImage: UIImage(named: "channelTemplate")!)
        
        ChatApplication.sharedInstance.serverConfigure("\(username)@\(ip)", username: username, password: "1234", profileImage: nil)
        
        ChatApplication.sharedInstance.startChatWith(self, userModel: model, navigationController: false, animated: true, completion: nil)
    }
}
