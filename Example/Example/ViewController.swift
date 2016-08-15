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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        testView.LoadImageFromUrl("https://raw.githubusercontent.com/joehour/JImageLoader/master/Example/test.jpg", contentMode: .ScaleAspectFit,CircleProgressViewParameters: CircleProgressParameters(width: 50, height: 50, linewidth: 3, alpha: 0.7, fillColor: UIColor.clearColor(), strokeColor: UIColor.greenColor(), backgroundColor: UIColor.blackColor() ), progress: {(Prograss: Float) in
            
            print(Prograss)
            
            } ,completion: { ( Sucess: Bool) in
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

    @IBAction func Refresh(sender: AnyObject) {
        

        testView.LoadImageFromUrl("https://raw.githubusercontent.com/joehour/JImageLoader/master/Example/test.jpg", contentMode: .ScaleAspectFit,CircleProgressViewParameters: CircleProgressParameters(width: 50, height: 50, linewidth: 3, alpha: 0.7, fillColor: UIColor.clearColor(), strokeColor: UIColor.greenColor(), backgroundColor: UIColor.blackColor() ), progress: {(Prograss: Float) in
            
            print(Prograss)
            
            } ,completion: { ( Sucess: Bool) in
                if(Sucess){
                    dispatch_async(dispatch_get_main_queue(),{
                        
                    })            }
            }
        )

    }

    @IBAction func DeleteCache(sender: UIButton) {
        if testView.JStatus == "Complete" {
            delect_all_cache()
        }
        
    }
    @IBAction func Suspend(sender: AnyObject) {
        testView.suspend()
    }
    @IBAction func Resume(sender: AnyObject) {
        testView.resume()
    }
}

