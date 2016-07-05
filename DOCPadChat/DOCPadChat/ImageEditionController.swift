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
    
    var thicknessSelected : Bool!
    
    var colorSelected : Bool!

    
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
        
        let image = UIImage(named: "alter02")
        self.image = image
        
        
        self.imageEdit = ImageEditionView(image: self.image, controller: self)
        self.imageEdit.frame = CGRectMake(0, 70, screenWidth, screenHeight - 70)
        self.view.addSubview(self.imageEdit)
        
        //AQUI MÉTODO QUE ESCOLHE ESPESSURA
        self.imageEdit.thicknessButton.addTarget(self, action: #selector(ImageEditionController.chooseThickness), forControlEvents: .TouchUpInside)
        
        //AQUI MÉTODO QUE ESCOLHE COR
        self.imageEdit.colorButton.addTarget(self, action: #selector(ImageEditionController.chooseColor), forControlEvents: .TouchUpInside)
        
        //AQUI MÉTODO QUE REVERTE UM PASSO
        self.imageEdit.undoButton.addTarget(self, action: #selector(ImageEditionController.undoAction), forControlEvents: .TouchUpInside)
        
        //AQUI MÉTODO QUE REMOVE PINTURA
        self.imageEdit.cleanButton.addTarget(self, action: #selector(ImageEditionController.cleanAllPaint), forControlEvents: .TouchUpInside)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**********/
    //propriedades e ações dos botões
    
    func refreshSelectedButton()
    {
        if(self.thicknessSelected == true && self.colorSelected == false)
        {
            self.imageEdit.thicknessButton.setImage(UIImage(named: "paintThickness_selected"), forState: .Normal)
            self.imageEdit.colorButton.setImage(UIImage(named: "paintColor"), forState: .Normal)
        }
        else if(self.thicknessSelected == false && self.colorSelected == true)
        {
            self.imageEdit.thicknessButton.setImage(UIImage(named: "paintThickness"), forState: .Normal)
            self.imageEdit.colorButton.setImage(UIImage(named: "paintColor_selected"), forState: .Normal)
        }
    }

    func chooseThickness()
    {
        self.thicknessSelected = true
        self.colorSelected = false
        self.refreshSelectedButton()
        
        //IMPLEMENTAR MÉTODO QUE DEFINE ESPESSURA DO PINCEL
    }

    func chooseColor()
    {
        self.colorSelected = true
        self.thicknessSelected = false
        self.refreshSelectedButton()
        
        //IMPLEMENTAR MÉTODO QUE DEFINE COR DA PINTURA
    }
    
    func undoAction()
    {
        //IMPLEMENTAR MÉTODO QUE RETROCEDE UMA AÇÃO
    }
    
    func cleanAllPaint()
    {
        //IMPLEMENTAR MÉTODO QUE APAGA PINTURA
    }
    
    //fim propriedade e ações dos botoes
    /*************/
    
    func sendImage()
    {
        
    }

}
