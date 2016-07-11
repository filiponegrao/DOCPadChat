//
//  ImageEditionController.swift
//  DOCPadChat
//
//  Created by Fernanda Carvalho on 05/07/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import UIKit

class ImageEditionController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    private var imageEdit : ImageEditionView!
    
    weak var chatController : ChatController!
    
    private var image : UIImage!
    
    var thicknessSelected : Bool!
    
    var colorSelected : Bool!
    
    var pencilSelected : Bool!
    
    var brushSelected : Bool!
    
    var markSelected : Bool!

    var usermodel : UserModel!
    
    //referentes ao traçado
    var brushWidth : CGFloat = 2.0
    
    var lastPoint = CGPoint.zero
    
    var swiped = false
    
    var mainImageView: UIImageView! //drawing so far
    var tempImageView: UIImageView! //temporary image view for the line currently drawing
    
    //array de cores
    
    let colors = [color0, color1, color2, color3, color4, color5, color6, color7, color8, color9, color10, color11]
    
    var cor = color0

    
    init(image: UIImage?, userModel: UserModel!, chatController: ChatController!)
    {
        self.image = image
        self.usermodel = userModel
        self.chatController = chatController
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        let viewFrame = CGRectMake(0, 62, screenWidth, screenHeight - 62)
        self.imageEdit = ImageEditionView(image: self.image, frame: viewFrame, controller: self)
        self.view.addSubview(self.imageEdit)
        
        //referentes ao traçado
        mainImageView = UIImageView(frame:self.imageEdit.imageView.bounds)
        
        self.imageEdit.imageView.addSubview(mainImageView)
        
        tempImageView = UIImageView(frame:self.mainImageView.bounds)
        self.imageEdit.imageView.addSubview(tempImageView)

        
        //AQUI MÉTODO QUE ESCOLHE ESPESSURA
        self.thicknessSelected = true //por padrao começa selecionado
        self.pencilSelected = true //por padrao começa selecionado
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
        
        //collection delegate
        self.imageEdit.collection.delegate = self
        self.imageEdit.collection.dataSource = self
    self.imageEdit.collection.registerClass(ImageEditionCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    /*********************************/
    // ----- testando traçado -----
    /*********************************/
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Sets gesture to false when user touches the screen (but hasn't moved the finger yet)
        swiped = false
        if let touch = touches.first {
            
            // Saves the touch location (so we know where the drawing starts)
            lastPoint = touch.locationInView(self.tempImageView)
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        //draws a line between two points in the temporary view
        UIGraphicsBeginImageContext(tempImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: tempImageView.frame.width, height: tempImageView.frame.height))
        
        //gets the current point and draws a line from lastpoint to currentpoint
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        //parameters for brush size and brush color
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, brushWidth)
        CGContextSetStrokeColorWithColor(context, self.cor.CGColor)

        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        //actually draws the path
        CGContextStrokePath(context)
        
        //wraps up the drawing context to render the new line into the temporary image view
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // sets gesture to true when user moves finger on canvas
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.locationInView(tempImageView)
            //calls method to draw line
            drawLineFrom(lastPoint, toPoint: currentPoint)
            print("touch")
            
            //updates the last point so the next touch starts at the right point
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        //checks if the user is in the middle of a swipe
        if !swiped {
            //if not, draws a single point at touch location
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.drawInRect(CGRect(x:0, y:0, width: mainImageView.frame.width, height: mainImageView.frame.height), blendMode: CGBlendMode.Normal, alpha: 1.0)
        tempImageView.image?.drawInRect(CGRect(x:0, y:0, width: mainImageView.frame.width, height: mainImageView.frame.height), blendMode: CGBlendMode.Normal, alpha: 1.0)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
    }
    // fim do traçado

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*********************************/
    //propriedades e ações dos botões
    /*********************************/
    
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
        
        self.imageEdit.collection.hidden = true
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
        
        self.imageEdit.collection.hidden = false
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
        mainImageView.image = nil

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
        
        brushWidth = CGFloat(2.0)
        print("2.0")
        self.refreshSelectedThickness()
    }
    
    func brushAction()
    {
        self.brushSelected = true
        self.pencilSelected = false
        self.markSelected = false
        self.refreshSelectedThickness()
        
        brushWidth = CGFloat(4.0)
        print("4.0")
        self.refreshSelectedThickness()
    }
    
    func markAction()
    {
        self.markSelected = true
        self.pencilSelected = false
        self.brushSelected = false
        self.refreshSelectedThickness()
        
        brushWidth = CGFloat(8.0)
        print("8.0")
        self.refreshSelectedThickness()
    }
    
    /*********************************/
    //fim propriedade e ações dos botoes
    /*********************************/
    
    
    /*********************************/
    /****** COLLECTION DELEGATE ******/
    /*********************************/
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.colors.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        //sets HEX properties to color array elements
        cor = colors[indexPath.item]
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ImageEditionCell
        
        let color = self.colors[indexPath.item]
        
        cell.imageView.backgroundColor = color
    
        
        cell.frame.size = CGSizeMake(screenWidth/6, screenWidth/6)
        
        return cell
    }
    
    /*********************************/
    /********** FIM DELEGATE *********/
    /*********************************/
    
    func sendImage()
    {
        ChatApplication.sharedInstance.sendImageMessage(nil, toContact: self.usermodel.id, image: image)
        self.navigationController?.popViewControllerAnimated(true)
        self.chatController.navigationController?.popViewControllerAnimated(true)
    }

}
