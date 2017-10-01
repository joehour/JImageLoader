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

        
        testView.LoadImageFromUrl("https://raw.githubusercontent.com/joehour/JImageLoader/master/Example/test.jpg", contentMode: .scaleAspectFit,CircleProgressViewParameters: CircleProgressParameters(width: 50, height: 50, linewidth: 3, alpha: 0.7, fillColor: UIColor.clear, strokeColor: UIColor.green, backgroundColor: UIColor.black )        )
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Refresh(_ sender: AnyObject) {
        

        testView.LoadImageFromUrl("https://raw.githubusercontent.com/joehour/JImageLoader/master/Example/test.jpg", contentMode: .scaleAspectFit,CircleProgressViewParameters: CircleProgressParameters(width: 50, height: 50, linewidth: 3, alpha: 0.7, fillColor: UIColor.clear, strokeColor: UIColor.green, backgroundColor: UIColor.black ), progress: {(Prograss: Float) in
            
            print(Prograss)
            
            } ,completion: { ( Sucess: Bool) in
                if(Sucess){
                    DispatchQueue.main.async {
                        
                    }
                }
            }
        )
        
       
    }

    @IBAction func DeleteCache(_ sender: UIButton) {
        if testView.JStatus == "Complete" {
            delect_all_cache()
        }
        
    }
    @IBAction func Suspend(_ sender: AnyObject) {
        testView.suspend()
    }
    @IBAction func Resume(_ sender: AnyObject) {
        testView.resume()
    }
}

