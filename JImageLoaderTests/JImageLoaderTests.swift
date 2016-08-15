//
//  JImageLoaderTests.swift
//  JImageLoaderTests
//
//  Created by JoeJoe on 2016/8/4.
//  Copyright © 2016年 Joe. All rights reserved.
//

import XCTest
import JImageLoader

class JImageLoaderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testLoadImageFromUrl1(){
        
        //self.measureBlock {
        //var theExpectation:XCTestExpectation?
        let expectation = expectationWithDescription("load test")
        let image: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        image.LoadImageFromUrl("https://raw.githubusercontent.com/joehour/JImageLoader/master/Example/test.jpg", contentMode: .ScaleAspectFit,CircleProgressViewParameters: CircleProgressParameters(width: 50, height: 50, linewidth: 3, alpha: 0.7, fillColor: UIColor.clearColor(), strokeColor: UIColor.greenColor(), backgroundColor: UIColor.blackColor() ), progress: {(Prograss: Float) in
            
            print(Prograss)
            
            } ,completion: { ( Sucess: Bool) in
                if(Sucess){
                    dispatch_async(dispatch_get_main_queue(),{
                        expectation.fulfill()
                    })
                }
            }
        )
        waitForExpectationsWithTimeout(5) { error in
                   XCTAssertNil(error)
            	        }
    }
    
    func testLoadImageFromUrl2(){
        
        //self.measureBlock {
        //var theExpectation:XCTestExpectation?
        let expectation = expectationWithDescription("load test")
        let image: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        image.LoadImageFromUrl("https://raw.githubusercontent.com/joehour/JImageLoader/master/Example/test.jpg", Effect: false, contentMode: .ScaleAspectFit,CircleProgressViewParameters: CircleProgressParameters(width: 50, height: 50, linewidth: 3, alpha: 0.7, fillColor: UIColor.clearColor(), strokeColor: UIColor.greenColor(), backgroundColor: UIColor.blackColor() ), progress: {(Prograss: Float) in
            
            print(Prograss)
            
            } ,completion: { ( Sucess: Bool) in
                if(Sucess){
                    dispatch_async(dispatch_get_main_queue(),{
                        expectation.fulfill()
                    })
                }
            }
        )
        waitForExpectationsWithTimeout(5) { error in
            XCTAssertNil(error)
        }
    }
    

    
    func testDeleteCache() {
        delect_all_cache()
    }
    

}
