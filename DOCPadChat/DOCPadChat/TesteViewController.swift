//
//  TesteViewController.swift
//  DOCPadChat
//
//  Created by Filipo Negrao on 14/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import UIKit

class TesteViewController: UIViewController {

    private var button : UIButton!
    
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
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func openChat()
    {        
        ChatApplication.sharedInstance.startChatWith(self, channelId: 01, navigationController: false, animated: true)
    }
    
}
