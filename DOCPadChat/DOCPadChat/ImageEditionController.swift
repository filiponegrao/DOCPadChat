//
//  ImageEditionController.swift
//  DOCPadChat
//
//  Created by Fernanda Carvalho on 05/07/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import UIKit

class ImageEditionController: UIViewController
{
    private var imageEdit : ImageEditionView!
    
    private var image : UIImage!
    
//    init(image: UIImage?)
//    {
//        self.image = image
//        
//        super.init(nibName: "ImageEditionController", bundle: nil)
//    }
    
//    required init?(coder aDecoder: NSCoder)
//    {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.clearColor()
        
        let image = UIImage(named: "alter01")
        self.image = image
        
        
        self.imageEdit = ImageEditionView(image: self.image, controller: self)
        self.imageEdit.frame = CGRectMake(0, 70, screenWidth, screenHeight - 70)
        self.view.addSubview(self.imageEdit)
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendImage()
    {
        
    }

}
