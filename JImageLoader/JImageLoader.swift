//
//  JImageLoader.swift
//  JImageLoader
//
//  Created by JoeJoe on 2016/6/16.
//  Copyright © 2016年 Joe. All rights reserved.
//

import Foundation
import UIKit
import ImageIO


private var CircleProgressAssociationKey: UInt8 = 0
private var CompletionAssociationKey: UInt8 = 0
private var ProgressAssociationKey: UInt8 = 0

private var ParameterAssociationKey: UInt8 = 0

private var DispatchQueueKey: UInt8 = 0
private var DispatchQueueShowKey: UInt8 = 0
private var StatusKey: UInt8 = 0

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

class JParameter {
    var JQueue:dispatch_queue_t?
    var JShowViewQueue:dispatch_queue_t?
    var JProgressSet: Bool?
    var JDownloadFinish: Bool?
    var JDataTak: NSURLSessionDataTask?
    var JImageSource: CGImageSourceRef?
    var JData: NSMutableData?
    var JLength: Int?
    var JEffect: Bool?
    
    
}





extension UIImageView: NSURLSessionDataDelegate {
    
    
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
    
    var JQueue: dispatch_queue_t {
        get {
            return (objc_getAssociatedObject(self, &DispatchQueueKey) as? dispatch_queue_t)!
        }
        set(newValue) {
            objc_setAssociatedObject(self, &DispatchQueueKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var JShowViewQueue: dispatch_queue_t {
        get {
            return (objc_getAssociatedObject(self, &DispatchQueueShowKey) as? dispatch_queue_t)!
        }
        set(newValue) {
            objc_setAssociatedObject(self, &DispatchQueueShowKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public var JStatus: String {
        get {
            return (objc_getAssociatedObject(self, &StatusKey) as? String)!
        }
        set(newValue) {
            objc_setAssociatedObject(self, &StatusKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }

    
    var Jparameter: JParameter! {
        get {
            guard let item = objc_getAssociatedObject(self, &ParameterAssociationKey) else{
                return nil
            }
            return item as! JParameter//objc_getAssociatedObject(self, &ParameterAssociationKey) as! JParameter
        }
        set(newValue) {
            objc_setAssociatedObject(self, &ParameterAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public func LoadImageFromUrl(link: String, contentMode mode: UIViewContentMode = .ScaleAspectFit, BackgroundImage image: UIImage = UIImage(), Effect isEffect: Bool = true, progress: (Progress: Float)->(), completion: (Sucess: Bool)->()) {
        guard let url = NSURL(string: link) else { return }
        
        contentMode = mode
        self.image = image
        var session: NSURLSession?

        self.JCompletion = completion
        self.JProgress = progress
        
       
        
        self.Jparameter = JParameter()
        self.Jparameter.JEffect = isEffect
        
        self.Jparameter.JProgressSet = true
        self.Jparameter.JImageSource = CGImageSourceCreateIncremental(nil)
        self.Jparameter.JData = NSMutableData()
        self.Jparameter.JLength = 0
        self.Jparameter.JDownloadFinish = false
        
        self.JQueue = dispatch_queue_create(link, DISPATCH_QUEUE_SERIAL)
        self.JShowViewQueue = dispatch_queue_create(link, DISPATCH_QUEUE_SERIAL)
        //self.JDataTak = NSURLSessionDataTask()
        
        
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
        //session?.downloadTaskWithURL(url).resume()
        //session?.dataTaskWithURL(url).resume()
        
        self.Jparameter.JDataTak = (session?.dataTaskWithURL(url))!//.resume()
        self.Jparameter.JDataTak!.resume()

    }
    
    public func LoadImageFromUrl(link: String, contentMode mode: UIViewContentMode = .ScaleAspectFit, BackgroundImage image: UIImage = UIImage(), Effect isEffect: Bool = true, CircleProgressViewParameters: CircleProgressParameters, progress: (Progress: Float)->(), completion: (Sucess: Bool)->()) {
        guard let url = NSURL(string: link) else { return }
        
        contentMode = mode
        self.image = image
        var session: NSURLSession?
        
        self.JCompletion = completion
        self.JProgress = progress
        
        
        
        self.Jparameter = JParameter()
        self.Jparameter.JEffect = isEffect
        
        self.Jparameter.JProgressSet = true
        self.Jparameter.JImageSource = CGImageSourceCreateIncremental(nil)
        self.Jparameter.JData = NSMutableData()
        self.Jparameter.JLength = 0
        self.Jparameter.JDownloadFinish = false
        self.Jparameter.JQueue = dispatch_queue_create(link, DISPATCH_QUEUE_SERIAL)
        self.Jparameter.JShowViewQueue = dispatch_queue_create(link, DISPATCH_QUEUE_SERIAL)
        
        
        if let item = find_cache(link) {
            self.image = UIImage(data: item.data!)
            return
        }
        else{
            
        }
       
        
        
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
        
        
        
        session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration(), delegate: self, delegateQueue: NSOperationQueue.mainQueue())

        self.Jparameter.JDataTak = (session?.dataTaskWithURL(url))!//.resume()
        self.Jparameter.JDataTak!.resume()
        
    }
    
    public func LoadImageFromUrl(link: String, contentMode mode: UIViewContentMode = .ScaleAspectFit, BackgroundImage image: UIImage = UIImage(), Effect isEffect: Bool = true) {
        guard let url = NSURL(string: link) else { return }
        
        contentMode = mode
        self.image = image
        
        self.Jparameter = JParameter()
        self.Jparameter.JEffect = isEffect
        
        self.Jparameter.JProgressSet = false
        self.Jparameter.JImageSource = CGImageSourceCreateIncremental(nil)
        self.Jparameter.JData = NSMutableData()
        self.Jparameter.JLength = 0
        self.Jparameter.JDownloadFinish = false
        
        
        self.JQueue = dispatch_queue_create(link, DISPATCH_QUEUE_SERIAL)
        self.JShowViewQueue = dispatch_queue_create(link, DISPATCH_QUEUE_SERIAL)
       
        
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
        
        self.Jparameter.JDataTak = (session?.dataTaskWithURL(url))!//.resume()
        self.Jparameter.JDataTak!.resume()
    }
    
    public func LoadImageFromUrl(link: String, contentMode mode: UIViewContentMode = .ScaleAspectFit, BackgroundImage image: UIImage = UIImage(), Effect isEffect: Bool = true, CircleProgressViewParameters: CircleProgressParameters) {
        guard let url = NSURL(string: link) else { return }
        
        contentMode = mode
        self.image = image
        
        self.Jparameter = JParameter()
        self.Jparameter.JProgressSet = false
        self.Jparameter.JEffect = isEffect
        self.Jparameter.JImageSource = CGImageSourceCreateIncremental(nil)
        self.Jparameter.JData = NSMutableData()
        self.Jparameter.JLength = 0
        self.Jparameter.JDownloadFinish = false
        
        self.JQueue = dispatch_queue_create(link, DISPATCH_QUEUE_SERIAL)
        self.JShowViewQueue = dispatch_queue_create(link, DISPATCH_QUEUE_SERIAL)
        
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
        self.Jparameter.JDataTak = (session?.dataTaskWithURL(url))!//.resume()
        self.Jparameter.JDataTak!.resume()
        
    }



//    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
//        dispatch_async(dispatch_get_main_queue()) { () -> Void in
//            
//            
//            if self.JBool!{
//                self.JProgress(Progress:(Float)(totalBytesWritten)/(Float)(totalBytesExpectedToWrite))
//            }
//            
//            self.JCircleProgressView.progress = ((CGFloat)(totalBytesWritten)/(CGFloat)(totalBytesExpectedToWrite))
//        }
//        
//    }
    
//    public func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
//        var imageSource: CGImageSourceRef = CGImageSourceCreateIncremental(nil)
//        CGImageSourceUpdateData(imageSource, data, false)
//        
//    }
    
    
//    public func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
//        print("received data")
//    }
    
    
    
    private func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        print(response.expectedContentLength)
        self.Jparameter.JLength = Int(response.expectedContentLength)
        self.JStatus = "Start"
         completionHandler(.Allow)
        
        
    }
    
    private func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
       
        dispatch_async(self.Jparameter.JQueue!, { () -> Void in

        self.Jparameter.JData!.appendData(data)
        
        if self.Jparameter.JData!.length == self.Jparameter.JLength{
            self.Jparameter.JDownloadFinish = true
        }
        
        if !self.Jparameter.JDownloadFinish! {
//            CGImageSourceUpdateData(self.Jparameter.JImageSource!,  self.Jparameter.JData!, self.Jparameter.JDownloadFinish!)
//            guard let imageRef:CGImageRef = CGImageSourceCreateImageAtIndex(self.Jparameter.JImageSource!, 0, nil)else{
//                return
//                
//            }
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                if self.Jparameter.JProgressSet!{
                    self.JProgress(Progress:(Float)(self.Jparameter.JData!.length)/(Float)(self.Jparameter.JLength!))
                }
                
                
                self.JCircleProgressView.progress = ((CGFloat)(self.Jparameter.JData!.length)/(CGFloat)(self.Jparameter.JLength!))
                self.JStatus = "Loading"
//                if(self.Jparameter.JEffect != true){
//                   self.image =  UIImage(CGImage: imageRef)
//                }
            }
            
        }
        
        })
    
    
    }


    private func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {

        
    }
    
    

    private func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError!) {
        
        if(error != nil) {
            session.invalidateAndCancel()
            
        } else {
            
            dispatch_async(self.Jparameter.JQueue!, { () -> Void in
                
                //dispatch_async(dispatch_get_main_queue()) { () -> Void in
                
                if self.Jparameter.JData!.length == self.Jparameter.JLength{
                    
                    CGImageSourceUpdateData(self.Jparameter.JImageSource!,  self.Jparameter.JData!, true)
                    guard let imageRef:CGImageRef = CGImageSourceCreateImageAtIndex(self.Jparameter.JImageSource!, 0, nil)else{
                        return
                        
                    }
                    
                    var info:CacheInfo = CacheInfo()
                    info.key = task.currentRequest?.URL?.absoluteString
                    info.data = self.Jparameter.JData
                    
                    set_cache(info)
                    
                    
                    dispatch_async(self.Jparameter.JShowViewQueue!, { () -> Void in
                        //
                        usleep((uint)(0.2*1000000))
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                            if self.Jparameter.JProgressSet!{
                                self.JProgress(Progress:(Float)(self.Jparameter.JData!.length)/(Float)(self.Jparameter.JLength!))
                            }
                            
                            self.JCircleProgressView.progress = ((CGFloat)(self.Jparameter.JData!.length)/(CGFloat)(self.Jparameter.JLength!))

                            self.JCircleProgressView.hidden = true
                            
                        }
                        
                        
                       
                    })
                    
                    dispatch_async(self.Jparameter.JShowViewQueue!, { () -> Void in
                        usleep((uint)(0.2*1000000))
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                            if(self.Jparameter.JEffect == true){
                            UIView.transitionWithView(self, duration: 3, options:
                                [.CurveEaseOut, .TransitionCrossDissolve], animations: {
                                    
                                    self.image =  UIImage(CGImage: imageRef)
                                    
                                }, completion: {_ in
                                   self.JStatus = "Complete"
                                    if self.Jparameter.JProgressSet! {
                                        self.JCompletion(Success: true)
                                    }
                                }
                            )
                           }else{
                                
                              self.image =  UIImage(CGImage: imageRef)
                              self.JStatus = "Complete"
                                if self.Jparameter.JProgressSet! {
                                    self.JCompletion(Success: true)
                                }
                            }
                        }
                            
                    })
                    
                   
                    
                }
            
            
            
            })
            
            
            
            
            }
        
        
        
        
    }
    
    public func suspend(){
        if self.Jparameter != nil {
            self.Jparameter.JDataTak!.suspend()
        }
    }
    
    public func resume(){
        if self.Jparameter.JDataTak != nil {
         self.Jparameter.JDataTak!.resume()
        }
    }
    
    public func cancel(){
        if self.Jparameter.JDataTak != nil {
           self.Jparameter.JDataTak!.cancel()
            self.image = nil
            self.JCircleProgressView.hidden = true
        }
        
    }
}


