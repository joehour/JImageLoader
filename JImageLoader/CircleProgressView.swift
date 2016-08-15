//
//  CircleProgressView.swift
//  JImageLoader
//
//  Created by JoeJoe on 2016/7/4.
//  Copyright © 2016年 Joe. All rights reserved.
//

import Foundation
import UIKit


public struct CircleProgressParameters {
    public let width, height, linewidth: CGFloat
    public var alpha: CGFloat = 0.7
    public var fillColor: UIColor = UIColor.clearColor()
    public var strokeColor: UIColor = UIColor.whiteColor()
    public var backgroundColor: UIColor = UIColor.blackColor()
    
    public init(width: CGFloat, height: CGFloat, linewidth: CGFloat) {
        self.width   = width
        self.height = height
        self.linewidth = linewidth
        
    }
    public init(width: CGFloat, height: CGFloat, linewidth: CGFloat, alpha: CGFloat,
                fillColor: UIColor, strokeColor: UIColor, backgroundColor: UIColor) {
        self.width   = width
        self.height = height
        self.linewidth = linewidth
        self.alpha = alpha
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.backgroundColor = backgroundColor
    }

}




public class CircleProgressView: UIView{
    
    let CirclePathLayer = CAShapeLayer()
    //let CircleRadius: CGFloat = 50.0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.Init()
}
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    func Init(){
        
        CirclePathLayer.frame = bounds
        CirclePathLayer.lineWidth = 3
        CirclePathLayer.fillColor = UIColor.clearColor().CGColor
        CirclePathLayer.strokeColor = UIColor.whiteColor().CGColor
        
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = true;
        
        layer.addSublayer(CirclePathLayer)
        backgroundColor = UIColor.blackColor()
        alpha = 0.7
        
    }
    
    func CircleFrame() -> CGRect {
        var CircleFrame = CGRect(x: 0, y: 0, width: 1 * frame.width, height: 1 * frame.height)
        CircleFrame.origin.x = CGRectGetMidX(CirclePathLayer.bounds) - CGRectGetMidX(CircleFrame)
        CircleFrame.origin.y = CGRectGetMidY(CirclePathLayer.bounds) - CGRectGetMidY(CircleFrame)
        return CircleFrame
    }
    
    func CirclePath() -> UIBezierPath {
        return UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width )/3, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat((M_PI * 2.0) - M_PI_2), clockwise: true)
    }
    
    var progress: CGFloat {
        get {
            return CirclePathLayer.strokeEnd
        }
        set {
            if (newValue > 1) {
                CirclePathLayer.strokeEnd = 1
            } else if (newValue < 0) {
                CirclePathLayer.strokeEnd = 0
            } else {
                self.CirclePathLayer.strokeEnd = newValue
                
                //self.CirclePathLayer.drawInContext(<#T##ctx: CGContext##CGContext#>)
                //CirclePathLayer.fillColor = UIColor.whiteColor().CGColor
            }
        }
    }
    
    var lineWidth: CGFloat {
        get {
            return CirclePathLayer.lineWidth
        }
        set {
            self.CirclePathLayer.lineWidth = newValue
        }
    }
    
    var fillColor: CGColor {
        get {
            return CirclePathLayer.fillColor!
        }
        set {
            self.CirclePathLayer.fillColor = newValue
        }
    }
    
    var strokeColor: CGColor {
        get {
            return CirclePathLayer.strokeColor!
        }
        set {
            self.CirclePathLayer.strokeColor = newValue
        }
    }
    
    
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        CirclePathLayer.frame = bounds
        CirclePathLayer.path = CirclePath().CGPath
    }
    
    
    
}