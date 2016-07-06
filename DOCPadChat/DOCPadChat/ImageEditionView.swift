//
//  ImageEditionView.swift
//  DOCPadChat
//
//  Created by Fernanda Carvalho on 05/07/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import UIKit

class ImageEditionView: UIView
{
    var imageView : UIImageView!
    
    var collection : UICollectionView!
    
    var thicknessButton : UIButton!
    
    var colorButton : UIButton!
    
    var undoButton : UIButton!
    
    var cleanButton : UIButton!
    
    var chooseColorView : UIView!
    
    var pencilButton : UIButton!
    
    var brushButton : UIButton!
    
    var markButton : UIButton!
    
    var pencilStroke : UIImageView!
    
    var brushStroke : UIImageView!
    
    var markStroke : UIImageView!
    
    weak private var controller : ImageEditionController!
    
    init(image: UIImage, controller: ImageEditionController)
    {
        self.controller = controller
        super.init(frame: CGRectMake(0, 70, screenWidth, screenHeight-70))
        
        self.backgroundColor = UIColor.whiteColor()
        
//        let nav = self.controller.navigationController!.navigationBar
        
        //IMAGEVIEW QUE CONTÉM A IMAGEM QUE SERÁ ENVIADA
        self.imageView = UIImageView(frame: CGRectMake(0, 0, screenWidth, self.frame.size.height - screenWidth/2 - 15))
        self.imageView.image = image
        self.imageView.contentMode = .ScaleAspectFit
        
        self.imageView.backgroundColor = UIColor.clearColor()
//        self.imageView.layer.borderWidth = 1
//        self.imageView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.addSubview(self.imageView)
        
        //BOTOES DE EDIÇÃO:
        
        //botao de espessura
        self.thicknessButton = UIButton(frame: CGRectMake(0, frame.size.height - screenWidth/2 - 10, screenWidth/4, screenWidth/6))
        self.thicknessButton.backgroundColor = UIColor.clearColor()
        self.thicknessButton.setImage(UIImage(named: "paintThickness_selected"), forState: .Normal)
        self.thicknessButton.contentMode = .Center
        self.addSubview(self.thicknessButton)
        
        //botao de cor
        self.colorButton = UIButton(frame: CGRectMake(screenWidth/4, frame.size.height - screenWidth/2 - 10, screenWidth/4,screenWidth/6))
        self.colorButton.backgroundColor = UIColor.clearColor()
        self.colorButton.setImage(UIImage(named: "paintColor"), forState: .Normal)
        self.colorButton.contentMode = .Center
        self.addSubview(self.colorButton)
        
        //botao reverter
        self.undoButton = UIButton(frame: CGRectMake(screenWidth/2, frame.size.height - screenWidth/2 - 10, screenWidth/4, screenWidth/6))
        self.undoButton.backgroundColor = UIColor.clearColor()
        self.undoButton.setImage(UIImage.init(named: "paintUndo"), forState: .Normal)
        self.undoButton.contentMode = .Center
        self.addSubview(self.undoButton)
        
        //botao limpar tudo
        self.cleanButton = UIButton(frame: CGRectMake(screenWidth - screenWidth/4, frame.size.height - screenWidth/2 - 10, screenWidth/4, screenWidth/6))
        self.cleanButton.backgroundColor = UIColor.clearColor()
        self.cleanButton.setImage(UIImage.init(named: "paintClean"), forState: .Normal)
        self.cleanButton.contentMode = .Center
        self.addSubview(self.cleanButton)
        
        //fim BOTOES DE EDIÇÃO
        
        //EDIÇÃO ESPESSURA:
        
        //view por trás das canetas
        self.chooseColorView = UIView(frame: CGRectMake(0, self.frame.size.height - screenWidth/3, screenWidth, screenWidth/3))
        self.chooseColorView.backgroundColor = grayColor
        self.addSubview(self.chooseColorView)
        
        //botao espessura lapis
        self.pencilButton = UIButton(frame: CGRectMake(screenWidth/2 - screenWidth/6 * 1.5, self.frame.size.height - self.chooseColorView.frame.size.height/8 * 5 + 10, screenWidth/6, self.chooseColorView.frame.size.height/8 * 5))
        self.pencilButton.backgroundColor = UIColor.clearColor()
        self.pencilButton.setImage(UIImage.init(named: "pencilSelected"), forState: .Normal)
        self.pencilButton.contentMode = .Center
        self.addSubview(self.pencilButton)
        
        //imageview exemplo espessura lapis
        self.pencilStroke = UIImageView(frame: CGRectMake(screenWidth/2 - screenWidth/6 * 1.5, self.frame.size.height - screenWidth/3, screenWidth/6, self.chooseColorView.frame.size.height/8 * 3))
        self.pencilStroke.backgroundColor = UIColor.clearColor()
        self.pencilStroke.image = UIImage.init(named: "pencilStrokeSelected")
        self.pencilStroke.contentMode = .Center
        self.addSubview(self.pencilStroke)
        
        //botao espessura pincel
        self.brushButton = UIButton(frame: CGRectMake(screenWidth/2 - screenWidth/12, self.frame.size.height - self.chooseColorView.frame.size.height/8 * 5 + 10, screenWidth/6, self.chooseColorView.frame.size.height/8 * 5))
        self.brushButton.backgroundColor = UIColor.clearColor()
        self.brushButton.setImage(UIImage.init(named: "brush"), forState: .Normal)
        self.brushButton.contentMode = .Center
        self.addSubview(self.brushButton)
        
        //imageview exemplo espessura pincel
        self.brushStroke = UIImageView(frame: CGRectMake(screenWidth/2 - screenWidth/12, self.frame.size.height - screenWidth/3, screenWidth/6, self.chooseColorView.frame.size.height/8 * 3))
        self.brushStroke.backgroundColor = UIColor.clearColor()
        self.brushStroke.image = UIImage.init(named: "brushStroke")
        self.brushStroke.contentMode = .Center
        self.addSubview(self.brushStroke)
        
        //botao espessura marcador
        self.markButton = UIButton(frame: CGRectMake(screenWidth/2 + screenWidth/6 * 0.5, self.frame.size.height - self.chooseColorView.frame.size.height/8 * 5 + 10, screenWidth/6, self.chooseColorView.frame.size.height/8 * 5))
        self.markButton.backgroundColor = UIColor.clearColor()
        self.markButton.setImage(UIImage.init(named: "mark"), forState: .Normal)
        self.markButton.contentMode = .Center
        self.addSubview(self.markButton)
        
        //imageview exemplo espessura marcador
        self.markStroke = UIImageView(frame: CGRectMake(screenWidth/2 + screenWidth/6 * 0.5, self.frame.size.height - screenWidth/3, screenWidth/6, self.chooseColorView.frame.size.height/8 * 3))
        self.markStroke.backgroundColor = UIColor.clearColor()
        self.markStroke.image = UIImage.init(named: "markStroke")
        self.markStroke.contentMode = .Center
        self.addSubview(self.markStroke)
        
        //fim EDIÇÃO ESPESSURA
        
        //EDIÇÃO COR:
        
        //layout da collection
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/6, height: screenWidth/6)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0 //espaçamento entre uma celula de baixo com a de cima
        layout.headerReferenceSize = CGSizeZero

        
        //collection view das cores
        self.collection = UICollectionView(frame: CGRectMake(0, self.frame.size.height - screenWidth/3, screenWidth, screenWidth/3), collectionViewLayout: layout)
        self.collection.backgroundColor = UIColor.darkGrayColor()
        self.collection.showsVerticalScrollIndicator = false
        self.collection.layer.borderColor = UIColor.darkGrayColor().CGColor
        self.collection.layer.borderWidth = 0.5
        self.collection.hidden = true
        self.addSubview(self.collection)
        
        //fim EDIÇÃO COR
        
        //Navigation
        let right = UIBarButtonItem(title: "Enviar", style: .Plain, target: controller, action: #selector(self.controller.sendImage))
        self.controller.navigationItem.rightBarButtonItem = right
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
