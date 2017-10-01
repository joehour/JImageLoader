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

typealias CompletionHandler = (_ Success:Bool) -> Void

class CompletionWrapper {
    var Completion: (CompletionHandler)?
    
    init(_ Completion: (CompletionHandler)?) {
        self.Completion = Completion
    }
}

typealias ProgressHandler = (_ Progress: Float)->()

class ProgressWrapper {
    var Progress: (ProgressHandler)?
    
    init(_ Progress: (ProgressHandler)?) {
        self.Progress = Progress
    }
}

class JParameter {
    var JQueue:DispatchQueue?
    var JShowViewQueue:DispatchQueue?
    var JProgressSet: Bool?
    var JDownloadFinish: Bool?
    var JDataTak: URLSessionDataTask?
    var JImageSource: CGImageSource?
    var JData: NSMutableData?
    var JLength: Int?
    var JEffect: Bool?
    
    
}





extension UIImageView: URLSessionDataDelegate {
    
    
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
    
    var JQueue: DispatchQueue {
        get {
            return (objc_getAssociatedObject(self, &DispatchQueueKey) as? DispatchQueue)!
        }
        set(newValue) {
            objc_setAssociatedObject(self, &DispatchQueueKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var JShowViewQueue: DispatchQueue {
        get {
            return (objc_getAssociatedObject(self, &DispatchQueueShowKey) as? DispatchQueue)!
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
    
    public func LoadImageFromUrl(_ link: String, contentMode mode: UIViewContentMode = .scaleAspectFit, BackgroundImage image: UIImage = UIImage(), Effect isEffect: Bool = true, progress: @escaping (_ Progress: Float)->(), completion: @escaping (_ Sucess: Bool)->()) {
        guard let url = URL(string: link) else { return }
        
        contentMode = mode
        self.image = image
        var session: Foundation.URLSession?

        self.JCompletion = completion
        self.JProgress = progress
        
       
        
        self.Jparameter = JParameter()
        self.Jparameter.JEffect = isEffect
        
        self.Jparameter.JProgressSet = true
        self.Jparameter.JImageSource = CGImageSourceCreateIncremental(nil)
        self.Jparameter.JData = NSMutableData()
        self.Jparameter.JLength = 0
        self.Jparameter.JDownloadFinish = false
        
        self.Jparameter.JQueue = DispatchQueue(label: link, attributes: [])
        self.Jparameter.JShowViewQueue = DispatchQueue(label: link, attributes: [])
        //self.JDataTak = NSURLSessionDataTask()
        
        
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        DispatchQueue.main.async { () -> Void in
           
            
            self.JCircleProgressView = CircleProgressView(frame: CGRect(x: 0, y: 0, width: self.bounds.width*0.15, height: self.bounds.width*0.15))
            self.JCircleProgressView.isHidden = false
            self.JCircleProgressView.autoresizingMask = [.flexibleBottomMargin, .flexibleHeight, .flexibleLeftMargin ,.flexibleRightMargin, .flexibleTopMargin, .flexibleWidth]
            
            self.JCircleProgressView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
            self.addSubview(self.JCircleProgressView)
            self.JCircleProgressView.progress = -1
        }
        
        
        
        session = Foundation.URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        //session?.downloadTaskWithURL(url).resume()
        //session?.dataTaskWithURL(url).resume()
        
        self.Jparameter.JDataTak = (session?.dataTask(with: url))!//.resume()
        self.Jparameter.JDataTak!.resume()

    }
    
    public func LoadImageFromUrl(_ link: String, contentMode mode: UIViewContentMode = .scaleAspectFit, BackgroundImage image: UIImage = UIImage(), Effect isEffect: Bool = true, CircleProgressViewParameters: CircleProgressParameters, progress: @escaping (_ Progress: Float)->(), completion: @escaping (_ Sucess: Bool)->()) {
        guard let url = URL(string: link) else { return }
        
        contentMode = mode
        self.image = image
        var session: Foundation.URLSession?
        
        self.JCompletion = completion
        self.JProgress = progress
        
        
        
        self.Jparameter = JParameter()
        self.Jparameter.JEffect = isEffect
        
        self.Jparameter.JProgressSet = true
        self.Jparameter.JImageSource = CGImageSourceCreateIncremental(nil)
        self.Jparameter.JData = NSMutableData()
        self.Jparameter.JLength = 0
        self.Jparameter.JDownloadFinish = false
        self.Jparameter.JQueue = DispatchQueue(label: link, attributes: [])
        self.Jparameter.JShowViewQueue = DispatchQueue(label: link, attributes: [])
        
        
        if let item = find_cache(key: link) {
            self.image = UIImage(data: item.data! as Data)
            return
        }
        else{
            
        }
       
        
        
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        DispatchQueue.main.async { () -> Void in
            
            
            self.JCircleProgressView = CircleProgressView(frame: CGRect(x: 0, y: 0, width: CircleProgressViewParameters.width, height: CircleProgressViewParameters.height))
            self.JCircleProgressView.isHidden = false
            self.JCircleProgressView.autoresizingMask = [.flexibleBottomMargin, .flexibleHeight, .flexibleLeftMargin ,.flexibleRightMargin, .flexibleTopMargin, .flexibleWidth]
            
            self.JCircleProgressView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
            self.JCircleProgressView.progress = -1
            self.JCircleProgressView.lineWidth = CircleProgressViewParameters.linewidth
            self.JCircleProgressView.backgroundColor = CircleProgressViewParameters.backgroundColor
            self.JCircleProgressView.fillColor = CircleProgressViewParameters.fillColor.cgColor
            self.JCircleProgressView.strokeColor = CircleProgressViewParameters.strokeColor.cgColor
            self.JCircleProgressView.alpha = CircleProgressViewParameters.alpha
            
            self.addSubview(self.JCircleProgressView)
            
        }
        
        
        
        session = Foundation.URLSession(configuration: URLSessionConfiguration.ephemeral, delegate: self, delegateQueue: OperationQueue.main)

        self.Jparameter.JDataTak = (session?.dataTask(with: url))!//.resume()
        self.Jparameter.JDataTak!.resume()
        
    }
    
    public func LoadImageFromUrl(_ link: String, contentMode mode: UIViewContentMode = .scaleAspectFit, BackgroundImage image: UIImage = UIImage(), Effect isEffect: Bool = true) {
        guard let url = URL(string: link) else { return }
        
        contentMode = mode
        self.image = image
        
        self.Jparameter = JParameter()
        self.Jparameter.JEffect = isEffect
        
        self.Jparameter.JProgressSet = false
        self.Jparameter.JImageSource = CGImageSourceCreateIncremental(nil)
        self.Jparameter.JData = NSMutableData()
        self.Jparameter.JLength = 0
        self.Jparameter.JDownloadFinish = false
        
        
        self.Jparameter.JQueue = DispatchQueue(label: link, attributes: [])
        self.Jparameter.JShowViewQueue = DispatchQueue(label: link, attributes: [])
       
        
        var session: Foundation.URLSession?
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        DispatchQueue.main.async { () -> Void in
            
            self.JCircleProgressView = CircleProgressView(frame: CGRect(x: 0, y: 0, width: self.bounds.width*0.15, height: self.bounds.width*0.15))
            self.JCircleProgressView.isHidden = false
            self.JCircleProgressView.autoresizingMask = [.flexibleBottomMargin, .flexibleHeight, .flexibleLeftMargin ,.flexibleRightMargin, .flexibleTopMargin, .flexibleWidth]
            
            self.JCircleProgressView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
            self.addSubview(self.JCircleProgressView)
            self.JCircleProgressView.progress = -1
       
        }

        session = Foundation.URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        
        self.Jparameter.JDataTak = (session?.dataTask(with: url))!//.resume()
        self.Jparameter.JDataTak!.resume()
    }
    
    public func LoadImageFromUrl(_ link: String, contentMode mode: UIViewContentMode = .scaleAspectFit, BackgroundImage image: UIImage = UIImage(), Effect isEffect: Bool = true, CircleProgressViewParameters: CircleProgressParameters) {
        guard let url = URL(string: link) else { return }
        
        contentMode = mode
        self.image = image
        
        self.Jparameter = JParameter()
        self.Jparameter.JProgressSet = false
        self.Jparameter.JEffect = isEffect
        self.Jparameter.JImageSource = CGImageSourceCreateIncremental(nil)
        self.Jparameter.JData = NSMutableData()
        self.Jparameter.JLength = 0
        self.Jparameter.JDownloadFinish = false
        
        self.Jparameter.JQueue = DispatchQueue(label: link, attributes: [])
        self.Jparameter.JShowViewQueue = DispatchQueue(label: link, attributes: [])
        
        var session: Foundation.URLSession?

        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        DispatchQueue.main.async { () -> Void in
            
            
            self.JCircleProgressView = CircleProgressView(frame: CGRect(x: 0, y: 0, width: CircleProgressViewParameters.width, height: CircleProgressViewParameters.height))
            self.JCircleProgressView.isHidden = false
            self.JCircleProgressView.autoresizingMask = [.flexibleBottomMargin, .flexibleHeight, .flexibleLeftMargin ,.flexibleRightMargin, .flexibleTopMargin, .flexibleWidth]
            
            self.JCircleProgressView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
            self.JCircleProgressView.progress = -1
            self.JCircleProgressView.lineWidth = CircleProgressViewParameters.linewidth
            self.JCircleProgressView.backgroundColor = CircleProgressViewParameters.backgroundColor
            self.JCircleProgressView.fillColor = CircleProgressViewParameters.fillColor.cgColor
            self.JCircleProgressView.strokeColor = CircleProgressViewParameters.strokeColor.cgColor
            self.JCircleProgressView.alpha = CircleProgressViewParameters.alpha
            
            self.addSubview(self.JCircleProgressView)
            
        }
        
        
        
        session = Foundation.URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        self.Jparameter.JDataTak = (session?.dataTask(with: url))!//.resume()
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
    
    
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        print(response.expectedContentLength)
        self.Jparameter.JLength = Int(response.expectedContentLength)
        self.JStatus = "Start"
         completionHandler(.allow)
        
        
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
       
        self.Jparameter.JQueue!.async(execute: { () -> Void in

        self.Jparameter.JData!.append(data)
        
        if self.Jparameter.JData!.length == self.Jparameter.JLength{
            self.Jparameter.JDownloadFinish = true
        }
        
        if !self.Jparameter.JDownloadFinish! {
//            CGImageSourceUpdateData(self.Jparameter.JImageSource!,  self.Jparameter.JData!, self.Jparameter.JDownloadFinish!)
//            guard let imageRef:CGImageRef = CGImageSourceCreateImageAtIndex(self.Jparameter.JImageSource!, 0, nil)else{
//                return
//                
//            }
            DispatchQueue.main.async { () -> Void in
                if self.Jparameter.JProgressSet!{
                    self.JProgress((Float)(self.Jparameter.JData!.length)/(Float)(self.Jparameter.JLength!))
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


    public func URLSession(_ session: Foundation.URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {

        
    }
    
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if(error != nil) {
            session.invalidateAndCancel()
            
        } else {
            
            self.Jparameter.JQueue!.async(execute: { () -> Void in
                
                //dispatch_async(dispatch_get_main_queue()) { () -> Void in
                
                if self.Jparameter.JData!.length == self.Jparameter.JLength{
                    
                    CGImageSourceUpdateData(self.Jparameter.JImageSource!,  self.Jparameter.JData!, true)
                    guard let imageRef:CGImage = CGImageSourceCreateImageAtIndex(self.Jparameter.JImageSource!, 0, nil)else{
                        return
                        
                    }
                    
                    let info:CacheInfo = CacheInfo()
                    info.key = task.currentRequest?.url?.absoluteString
                    info.data = self.Jparameter.JData as NSData?
                    
                    set_cache(object: info)
                    
                    
                    self.Jparameter.JShowViewQueue!.async(execute: { () -> Void in
                        //
                        usleep((uint)(0.2*1000000))
                        DispatchQueue.main.async { () -> Void in
                            if self.Jparameter.JProgressSet!{
                                self.JProgress((Float)(self.Jparameter.JData!.length)/(Float)(self.Jparameter.JLength!))
                            }
                            
                            self.JCircleProgressView.progress = ((CGFloat)(self.Jparameter.JData!.length)/(CGFloat)(self.Jparameter.JLength!))

                            self.JCircleProgressView.isHidden = true
                            
                        }
                        
                        
                       
                    })
                    
                    self.Jparameter.JShowViewQueue!.async(execute: { () -> Void in
                        usleep((uint)(0.2*1000000))
                        DispatchQueue.main.async { () -> Void in
                            if(self.Jparameter.JEffect == true){
                            UIView.transition(with: self, duration: 3, options:
                                [.curveEaseOut, .transitionCrossDissolve], animations: {
                                    
                                    self.image =  UIImage(cgImage: imageRef)
                                    
                                }, completion: {_ in
                                   self.JStatus = "Complete"
                                    if self.Jparameter.JProgressSet! {
                                        self.JCompletion(true)
                                    }
                                }
                            )
                           }else{
                                
                              self.image =  UIImage(cgImage: imageRef)
                              self.JStatus = "Complete"
                                if self.Jparameter.JProgressSet! {
                                    self.JCompletion(true)
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
            self.JCircleProgressView.isHidden = true
        }
        
    }
}


