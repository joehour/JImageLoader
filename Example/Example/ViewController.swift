//
//  ViewController.swift
//  Example
//
//  Created by JoeJoe on 2016/6/23.
//  Copyright © 2016年 Joe. All rights reserved.
//

import UIKit
import JImageLoader

class ViewController: UIViewController {

    @IBOutlet weak var testView: UIImageView!
    @IBOutlet weak var testView2: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        testView.LoadImageFromUrl("https://cdn.spacetelescope.org/archives/images/screen/heic1509a.jpg")

        testView2.LoadImageFromUrl("https://cdn.spacetelescope.org/archives/images/screen/heic1509a.jpg", contentMode: .ScaleAspectFit, CircleProgressViewParameters: CircleProgressParameters(width: 30, height: 30, linewidth: 2), progress: {(Prograss: Float) in
            
                      print(Prograss)
                
            }
            , completion: { ( Sucess: Bool) in
            if(Sucess){
                dispatch_async(dispatch_get_main_queue(),{
                    
                })            }
            }
        )
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func ActionButton(sender: AnyObject) {
        

        testView.LoadImageFromUrl("https://cdn.spacetelescope.org/archives/images/screen/heic1509a.jpg", contentMode: .ScaleAspectFit,CircleProgressViewParameters: CircleProgressParameters(width: 50, height: 50, linewidth: 3, alpha: 0.7, fillColor: UIColor.clearColor(), strokeColor: UIColor.greenColor(), backgroundColor: UIColor.blackColor() ), progress: {(Prograss: Float) in
            
            print(Prograss)
            
            } ,completion: { ( Sucess: Bool) in
                if(Sucess){
                    dispatch_async(dispatch_get_main_queue(),{
                        
                    })            }
            }
        )
        
        
        
        testView2.LoadImageFromUrl("https://cdn.spacetelescope.org/archives/images/screen/heic1509a.jpg", contentMode: .ScaleAspectFit, CircleProgressViewParameters: CircleProgressParameters(width: 30, height: 30, linewidth: 2), progress: {(Prograss: Float) in
            
            print(Prograss)
            
            }
            , completion: { ( Sucess: Bool) in
                if(Sucess){
                    dispatch_async(dispatch_get_main_queue(),{
                        
                    })            }
            }
        )
    }

}

