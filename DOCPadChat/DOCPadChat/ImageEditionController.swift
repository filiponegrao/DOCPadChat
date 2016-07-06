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
    
    var pencilSelected : Bool!
    
    var brushSelected : Bool!
    
    var markSelected : Bool!

    
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
        self.thicknessSelected = true //por padrao começa selecionado
        self.imageEdit.thicknessButton.addTarget(self, action: #selector(ImageEditionController.chooseThickness), forControlEvents: .TouchUpInside)
        
        //AQUI MÉTODO QUE ESCOLHE COR
        self.imageEdit.colorButton.addTarget(self, action: #selector(ImageEditionController.chooseColor), forControlEvents: .TouchUpInside)
        
        //AQUI MÉTODO QUE REVERTE UM PASSO
        self.imageEdit.undoButton.addTarget(self, action: #selector(ImageEditionController.undoAction), forControlEvents: .TouchUpInside)
        
        //AQUI MÉTODO QUE REMOVE PINTURA
        self.imageEdit.cleanButton.addTarget(self, action: #selector(ImageEditionController.cleanAllPaint), forControlEvents: .TouchUpInside)
        
        //AÇÃO DO LAPIS
        self.imageEdit.pencilButton.addTarget(self, action: #selector(ImageEditionController.pencilAction), forControlEvents: .TouchUpInside)
        
        //AÇÃO DO PINCEL
        self.imageEdit.brushButton.addTarget(self, action: #selector(ImageEditionController.brushAction), forControlEvents: .TouchUpInside)
        
        //AÇÃO DO MARCADOR
        self.imageEdit.markButton.addTarget(self, action: #selector(ImageEditionController.markAction), forControlEvents: .TouchUpInside)
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
        
        self.imageEdit.chooseColorView.hidden = false
        self.imageEdit.pencilButton.hidden = false
        self.imageEdit.pencilStroke.hidden = false
        self.imageEdit.brushButton.hidden = false
        self.imageEdit.brushStroke.hidden = false
        self.imageEdit.markButton.hidden = false
        self.imageEdit.markStroke.hidden = false
        
        //IMPLEMENTAR MÉTODO QUE DEFINE ESPESSURA DO PINCEL
    }

    func chooseColor()
    {
        self.colorSelected = true
        self.thicknessSelected = false
        self.refreshSelectedButton()
        
        self.imageEdit.chooseColorView.hidden = true
        self.imageEdit.pencilButton.hidden = true
        self.imageEdit.pencilStroke.hidden = true
        self.imageEdit.brushButton.hidden = true
        self.imageEdit.brushStroke.hidden = true
        self.imageEdit.markButton.hidden = true
        self.imageEdit.markStroke.hidden = true
        
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
    
    func refreshSelectedThickness()
    {
        if(self.pencilSelected == true && self.brushSelected == false && self.markSelected == false)
        {
            self.imageEdit.pencilButton.frame.origin.y = self.imageEdit.frame.size.height - self.imageEdit.chooseColorView.frame.size.height/8 * 5
            self.imageEdit.pencilButton.setImage(UIImage.init(named: "pencilSelected"), forState: .Normal)
            self.imageEdit.pencilStroke.image = UIImage.init(named: "pencilStrokeSelected")
            
            self.imageEdit.brushButton.frame.origin.y = self.imageEdit.frame.size.height - self.imageEdit.chooseColorView.frame.size.height/8 * 5 + 10
            self.imageEdit.brushButton.setImage(UIImage.init(named: "brush"), forState: .Normal)
            self.imageEdit.brushStroke.image = UIImage.init(named: "brushStroke")
            
            self.imageEdit.markButton.frame.origin.y
             = self.imageEdit.frame.size.height - self.imageEdit.chooseColorView.frame.size.height/8 * 5 + 10
            self.imageEdit.markButton.setImage(UIImage.init(named: "mark"), forState: .Normal)
            self.imageEdit.markStroke.image = UIImage.init(named: "markStroke")
        }
        else if(self.brushSelected == true && self.pencilSelected == false && self.markSelected == false)
        {
            self.imageEdit.brushButton.frame.origin.y = self.imageEdit.frame.size.height - self.imageEdit.chooseColorView.frame.size.height/8 * 5
            self.imageEdit.brushButton.setImage(UIImage.init(named: "brushSelected"), forState: .Normal)
            self.imageEdit.brushStroke.image = UIImage.init(named: "brushStrokeSelected")
            
            self.imageEdit.pencilButton.frame.origin.y = self.imageEdit.frame.size.height - self.imageEdit.chooseColorView.frame.size.height/8 * 5 + 10
            self.imageEdit.pencilButton.setImage(UIImage.init(named: "pencil"), forState: .Normal)
            self.imageEdit.pencilStroke.image = UIImage.init(named: "pencilStroke")
            
            self.imageEdit.markButton.frame.origin.y
                = self.imageEdit.frame.size.height - self.imageEdit.chooseColorView.frame.size.height/8 * 5 + 10
            self.imageEdit.markButton.setImage(UIImage.init(named: "mark"), forState: .Normal)
            self.imageEdit.markStroke.image = UIImage.init(named: "markStroke")
        }
        else if(self.markSelected == true && self.pencilSelected == false && self.brushSelected == false)
        {
            self.imageEdit.markButton.frame.origin.y
                = self.imageEdit.frame.size.height - self.imageEdit.chooseColorView.frame.size.height/8 * 5
            self.imageEdit.markButton.setImage(UIImage.init(named: "markSelected"), forState: .Normal)
            self.imageEdit.markStroke.image = UIImage.init(named: "markStrokeSelected")
            
            self.imageEdit.pencilButton.frame.origin.y = self.imageEdit.frame.size.height - self.imageEdit.chooseColorView.frame.size.height/8 * 5 + 10
            self.imageEdit.pencilButton.setImage(UIImage.init(named: "pencil"), forState: .Normal)
            self.imageEdit.pencilStroke.image = UIImage.init(named: "pencilStroke")
            
            self.imageEdit.brushButton.frame.origin.y = self.imageEdit.frame.size.height - self.imageEdit.chooseColorView.frame.size.height/8 * 5 + 10
            self.imageEdit.brushButton.setImage(UIImage.init(named: "brush"), forState: .Normal)
            self.imageEdit.brushStroke.image = UIImage.init(named: "brushStroke")
        }
    }
    
    func pencilAction()
    {
        self.pencilSelected = true
        self.brushSelected = false
        self.markSelected = false
        self.refreshSelectedThickness()
    }
    
    func brushAction()
    {
        self.brushSelected = true
        self.pencilSelected = false
        self.markSelected = false
        self.refreshSelectedThickness()
    }
    
    func markAction()
    {
        self.markSelected = true
        self.pencilSelected = false
        self.brushSelected = false
        self.refreshSelectedThickness()
    }
    
    //fim propriedade e ações dos botoes
    /*************/
    
    func sendImage()
    {
        
    }

}
