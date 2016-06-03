//
//  ReceivedImageView.swift
//  DOCPadChat
//
//  Created by Fernanda Carvalho on 02/06/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import UIKit

class ReceivedImageView: UIView, UIScrollViewDelegate
{
    var controller : ChatController!
    
    var image : UIImage!
    
    var receivedImage : UIImageView!
    
    var editButton : UIButton!
    
    var backButton : UIButton!
    
    var scrollView : UIScrollView!

    init(image: UIImage, frame: CGRect, requester : ChatController)
    {
        super.init(frame: frame)
        
        self.image = image
        self.controller = requester
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.backButton = UIButton(frame: CGRectMake(0, 20, 70, 50))
        self.backButton.setTitle("Voltar", forState: .Normal)
        self.backButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        self.backButton.addTarget(self, action: #selector(self.back), forControlEvents: .TouchUpInside)
        self.addSubview(self.backButton)
        
        self.editButton = UIButton(frame: CGRectMake(screenWidth - 70, 20, 70, 50))
        self.editButton.setTitle("Editar", forState: .Normal)
        self.editButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        self.editButton.addTarget(self, action: #selector(self.openEdition), forControlEvents: .TouchUpInside)
        self.addSubview(self.editButton)
        
        self.receivedImage = UIImageView(frame: CGRectMake(0, 0, image.size.width, image.size.height))
        self.receivedImage.image = image
        
        self.scrollView = UIScrollView(frame: CGRectMake(0, 65, screenWidth, screenHeight - 65))
        self.scrollView.backgroundColor = UIColor.whiteColor()
        self.scrollView.delegate = self
        self.scrollView.addSubview(self.receivedImage)
        self.scrollView.contentSize = self.image.size
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(self.scrollView)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReceivedImageView.scrollViewDoubleTapped(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        self.scrollView.addGestureRecognizer(doubleTapRecognizer)
        
        self.scrollView.maximumZoomScale = 1.0
        
        updateMinZoomScale()
        centerScrollViewContents()
    }
    
    /*********************************/
    /***** SCROLL VIEW DELEGATE ******/
    /*********************************/
    
    func updateMinZoomScale()
    {
        let scrollViewFrame = self.scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / self.receivedImage.frame.size.width
        let scaleHeight = scrollViewFrame.size.height / self.receivedImage.frame.size.height
        let minScale = min(scaleWidth, scaleHeight)
        self.scrollView.minimumZoomScale = minScale
        
        self.scrollView.setZoomScale(minScale, animated: false)
        self.scrollView.zoomScale = minScale
    }
    
    func centerScrollViewContents()
    {
        let boundsSize = self.scrollView.bounds.size
        var contentsFrame = self.receivedImage.frame
        
        if contentsFrame.size.width < boundsSize.width
        {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        }
        else
        {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height
        {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        }
        else
        {
            contentsFrame.origin.y = 0.0
        }
        
        self.receivedImage.frame = contentsFrame
    }

    func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer)
    {
//        // 1
//        let pointInView = recognizer.locationInView(self.receivedImage)
//        
//        // 2
//        var newZoomScale = self.scrollView.zoomScale * 1.5
//        newZoomScale = min(newZoomScale, self.scrollView.maximumZoomScale)
//        
//        // 3
//        let scrollViewSize = self.scrollView.bounds.size
//        let w = scrollViewSize.width / newZoomScale
//        let h = scrollViewSize.height / newZoomScale
//        let x = pointInView.x - (w / 2.0)
//        let y = pointInView.y - (h / 2.0)
//        
//        let rectToZoomTo = CGRectMake(x, y, w, h);
//        
//        // 4
//        scrollView.zoomToRect(rectToZoomTo, animated: true)
        
        
        if (self.scrollView.zoomScale > self.scrollView.minimumZoomScale)
        {
            self.scrollView.setZoomScale(self.scrollView.minimumZoomScale, animated: true)
        }
        else
        {
            let touch = recognizer.locationInView(self.receivedImage)
            
            let scrollViewSize = self.scrollView.bounds.size;
            
            let w = scrollViewSize.width / self.scrollView.maximumZoomScale;
            let h = scrollViewSize.height / self.scrollView.maximumZoomScale;
            let x = touch.x-(w/2.0);
            let y = touch.y-(h/2.0);
            
            let rectTozoom = CGRectMake(x, y, w, h);
            self.scrollView.zoomToRect(rectTozoom, animated: true)
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        return self.receivedImage
    }

    func scrollViewDidZoom(scrollView: UIScrollView)
    {
        centerScrollViewContents()
    }
    
    /*********************************/
    /********** FIM DELEGATE *********/
    /*********************************/
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func back()
    {
        removeFromSuperview()
    }
    
    func openEdition()
    {
        
    }
}
