//
//  CacheManager.swift
//  JImageLoader
//
//  Created by JoeJoe on 2016/7/25.
//  Copyright © 2016年 Joe. All rights reserved.
//

import Foundation


public let JImageLoaderCache:NSCache? = NSCache()

public func set_cache(object: CacheInfo){
    //let cache: NSCache = NSCache()
    
    JImageLoaderCache!.setObject(object, forKey: object.key!)
    //cache_list.addObject(cache)
}

public func set_cache(data: NSData, key: String ){

    let info: CacheInfo = CacheInfo()
    info.data = data
    info.key = key
    JImageLoaderCache!.setObject(info, forKey: info.key!)
}

public func find_cache(key: String)-> CacheInfo?{
    
    if let item = JImageLoaderCache!.objectForKey(key) {
        
        guard let _item: CacheInfo  = item as! CacheInfo else{
            return nil
        }
        return _item
    }
    else{
        return nil
    }

}

public func find_cache(key: String, completion: (cache_info: CacheInfo?)->()){
    if let item = JImageLoaderCache!.objectForKey(key) {
        
        guard let _item: CacheInfo  = item as! CacheInfo else{
            
            completion(cache_info: nil)
            return
        }
        completion(cache_info: _item)
        
    }
    else{
         completion(cache_info: nil)
    }
    
}

public func delect_cache(key: String){
    if find_cache(key) != nil {
        JImageLoaderCache!.removeObjectForKey(key)
    }
}

public func delect_all_cache(){
    if JImageLoaderCache != nil {
        
        JImageLoaderCache?.removeAllObjects()
        
        
    }
}

public func get_size(){
    if JImageLoaderCache != nil {
        
        
        
        
    }
}


public class CacheInfo: NSObject {
    
    public var data: NSData?
    public var data_type: String?
    public var key: String?
}