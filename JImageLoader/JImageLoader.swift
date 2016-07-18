//
//  JImageLoader.swift
//  JImageLoader
//
//  Created by JoeJoe on 2016/6/16.
//  Copyright © 2016年 Joe. All rights reserved.
//

import Foundation
import UIKit


private var CircleProgressAssociationKey: UInt8 = 0
private var CompletionAssociationKey: UInt8 = 0
private var ProgressAssociationKey: UInt8 = 0
private var BoolAssociationKey: UInt8 = 0

typealias CompletionHandler = (Success:Bool) -> Void

class CompletionWrapper {
    var Completion: (CompletionHandler)?
    
    init(_ Completion: (CompletionHandler)?) {
        self.Completion = Completion
    }
}

typealias ProgressHandler = (Progress: Float)->()

class ProgressWrapper {
    var Progress: (ProgressHandler)?
    
    init(_ Progress: (ProgressHandler)?) {
        self.Progress = Progress
    }
}






extension UIImageView: NSURLSessionDownloadDelegate {
    
   
    var JCircleProgressView: CircleProgressView! {
        get {
            return objc_getAssociatedObject(self, &CircleProgressAssociationKey) as? CircleProgressView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &CircleProgressAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var JCompletion: CompletionHandler {
        get {
            
            return (objc_getAssociatedObject(self, &CompletionAssociationKey) as? CompletionWrapper)!.Completion!

        }
        set(newValue) {
            objc_setAssociatedObject(self, &CompletionAssociationKey,  CompletionWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var JProgress: ProgressHandler {
        get {
            
            return (objc_getAssociatedObject(self, &ProgressAssociationKey) as? ProgressWrapper)!.Progress!
            
        }
        set(newValue) {
            objc_setAssociatedObject(self, &ProgressAssociationKey,  ProgressWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var JBool: Bool! {
        get {
            return objc_getAssociatedObject(self, &BoolAssociationKey) as? Bool
        }
        set(newValue) {
            objc_setAssociatedObject(self, &BoolAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    
    public func LoadImageFromUrl(link: String, contentMode mode: UIViewContentMode = .ScaleAspectFit, BackgroundImage image: UIImage = UIImage(), progress: (Progress: Float)->(), completion: (Sucess: Bool)->()) {
        guard let url = NSURL(string: link) else { return }
        
        contentMode = mode
        self.image = image
        var session: NSURLSession?

        self.JCompletion = completion
        self.JProgress = progress
        self.JBool = true
     
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
           
            
            self.JCircleProgressView = CircleProgressView(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(self.bounds)*0.15, height: CGRectGetWidth(self.bounds)*0.15))
            self.JCircleProgressView.hidden = false
            self.JCircleProgressView.autoresizingMask = [.FlexibleBottomMargin, .FlexibleHeight, .FlexibleLeftMargin ,.FlexibleRightMargin, .FlexibleTopMargin, .FlexibleWidth]
            
            self.JCircleProgressView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
            self.addSubview(self.JCircleProgressView)
            self.JCircleProgressView.progress = -1
        }
        
        
        
        session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        session?.downloadTaskWithURL(url).resume()
        

    }
    
    public func LoadImageFromUrl(link: String, contentMode mode: UIViewContentMode = .ScaleAspectFit, BackgroundImage image: UIImage = UIImage(), CircleProgressViewParameters: CircleProgressParameters, progress: (Progress: Float)->(), completion: (Sucess: Bool)->()) {
        guard let url = NSURL(string: link) else { return }
        
        contentMode = mode
        self.image = image
        var session: NSURLSession?
        
        self.JCompletion = completion
        self.JProgress = progress
        self.JBool = true
        
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            
            self.JCircleProgressView = CircleProgressView(frame: CGRect(x: 0, y: 0, width: CircleProgressViewParameters.width, height: CircleProgressViewParameters.height))
            self.JCircleProgressView.hidden = false
            self.JCircleProgressView.autoresizingMask = [.FlexibleBottomMargin, .FlexibleHeight, .FlexibleLeftMargin ,.FlexibleRightMargin, .FlexibleTopMargin, .FlexibleWidth]
            
            self.JCircleProgressView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
            self.JCircleProgressView.progress = -1
            self.JCircleProgressView.lineWidth = CircleProgressViewParameters.linewidth
            self.JCircleProgressView.backgroundColor = CircleProgressViewParameters.backgroundColor
            self.JCircleProgressView.fillColor = CircleProgressViewParameters.fillColor.CGColor
            self.JCircleProgressView.strokeColor = CircleProgressViewParameters.strokeColor.CGColor
            self.JCircleProgressView.alpha = CircleProgressViewParameters.alpha
            
            self.addSubview(self.JCircleProgressView)
            
        }
        
        
        
        session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        session?.downloadTaskWithURL(url).resume()
        
    }
    
    public func LoadImageFromUrl(link: String, contentMode mode: UIViewContentMode = .ScaleAspectFit, BackgroundImage image: UIImage = UIImage()) {
        guard let url = NSURL(string: link) else { return }
        
        contentMode = mode
        self.image = image
        self.JBool = false
        
        var session: NSURLSession?
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            self.JCircleProgressView = CircleProgressView(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(self.bounds)*0.15, height: CGRectGetWidth(self.bounds)*0.15))
            self.JCircleProgressView.hidden = false
            self.JCircleProgressView.autoresizingMask = [.FlexibleBottomMargin, .FlexibleHeight, .FlexibleLeftMargin ,.FlexibleRightMargin, .FlexibleTopMargin, .FlexibleWidth]
            
            self.JCircleProgressView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
            self.addSubview(self.JCircleProgressView)
            self.JCircleProgressView.progress = -1
       
        }

        session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        session?.downloadTaskWithURL(url).resume()
    }
    
    public func LoadImageFromUrl(link: String, contentMode mode: UIViewContentMode = .ScaleAspectFit, BackgroundImage image: UIImage = UIImage(), CircleProgressViewParameters: CircleProgressParameters) {
        guard let url = NSURL(string: link) else { return }
        
        contentMode = mode
        self.image = image
        self.JBool = false
        var session: NSURLSession?

        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            
            self.JCircleProgressView = CircleProgressView(frame: CGRect(x: 0, y: 0, width: CircleProgressViewParameters.width, height: CircleProgressViewParameters.height))
            self.JCircleProgressView.hidden = false
            self.JCircleProgressView.autoresizingMask = [.FlexibleBottomMargin, .FlexibleHeight, .FlexibleLeftMargin ,.FlexibleRightMargin, .FlexibleTopMargin, .FlexibleWidth]
            
            self.JCircleProgressView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
            self.JCircleProgressView.progress = -1
            self.JCircleProgressView.lineWidth = CircleProgressViewParameters.linewidth
            self.JCircleProgressView.backgroundColor = CircleProgressViewParameters.backgroundColor
            self.JCircleProgressView.fillColor = CircleProgressViewParameters.fillColor.CGColor
            self.JCircleProgressView.strokeColor = CircleProgressViewParameters.strokeColor.CGColor
            self.JCircleProgressView.alpha = CircleProgressViewParameters.alpha
            
            self.addSubview(self.JCircleProgressView)
            
        }
        
        
        
        session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        session?.downloadTaskWithURL(url).resume()
        
    }


    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        let data = NSData(contentsOfURL: location)
        let image = UIImage(data: data!)
        if JBool! {
            self.JCompletion(Success: true)
        }
        //session.invalidateAndCancel()
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            usleep((uint)(0.2*1000000))
            self.image = image
            self.JCircleProgressView.hidden = true
            
        }

    }
    
    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            if self.JBool!{
                self.JProgress(Progress:(Float)(totalBytesWritten)/(Float)(totalBytesExpectedToWrite))
            }
            
            self.JCircleProgressView.progress = ((CGFloat)(totalBytesWritten)/(CGFloat)(totalBytesExpectedToWrite))
        }
        
    }
    
    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {

        
    }
    
    
//////xcodebuild issue(as different optionality than expected by protocol 'NSURLSessionTaskDelegate'), when I upload this code to to cocoapods; But it work fine without cocoapods; So if you want take the didCompleteWithError event, you can recover this code~

//    public func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError!) {
//        
//        if(error != nil) {
//            session.invalidateAndCancel()
//            
//        } else {
//            
//            
//        }
//        
//    }
    
    
}


