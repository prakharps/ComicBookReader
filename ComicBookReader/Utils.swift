//
//  Util.swift
//  ComicBookReader
//
//  Created by Prakhar Srivastava on 08/08/18.
//  Copyright © 2018 Prakhar Srivastava. All rights reserved.
//

import Foundation
import Alamofire

class Utils {
    
    
    static func getComics(direction:Int,isList:Bool) -> (){
        var baseUrl = "http://xkcd.com/"
        var number = 1
        var postfix = "/info.0.json"
        var startNum = 1
        var endNum = 10
        var comicList = [ComicBook]()
        
        if(direction<0){
            if(isList){
                Globals.listStartNumber = Globals.listStartNumber - 10
                Globals.listEndNumber = Globals.listEndNumber - 10
                startNum = Globals.listStartNumber
                endNum = Globals.listEndNumber
            }else{
                Globals.gridStartNumber = Globals.gridStartNumber - 10
                Globals.gridEndNumber = Globals.gridEndNumber - 10
                startNum = Globals.gridStartNumber
                endNum = Globals.gridEndNumber
            }
        }else{
            if(isList){
                Globals.listEndNumber = Globals.listEndNumber + 10
                Globals.listStartNumber = Globals.listStartNumber + 10
                startNum = Globals.listStartNumber
                endNum = Globals.listEndNumber
            }else{
                Globals.gridEndNumber = Globals.gridEndNumber + 10
                Globals.gridStartNumber = Globals.gridStartNumber + 10
                startNum = Globals.gridStartNumber
                endNum = Globals.gridEndNumber
            }
        }
        if(comicList != nil){
            comicList.removeAll()
        }
        for i in startNum ... endNum{
            number = i
            var url = "\(baseUrl)\(number)\(postfix)"
            Alamofire.request(url).responseJSON{response in
                switch response.result{
                    case .success:
                        
                        let comicData = try? JSONDecoder().decode(ComicBook.self,from: response.data!)
                        guard let comic = comicData else{
                            return
                        }
                        comicList.append(comic)
                        if(isList){
                            Globals.listItems = comicList
                            NotificationCenter.default.post(name: Notification.Name(rawValue: Globals.tableLoadNotificationKey), object: self)
                        }else{
                            Globals.gridItems = comicList
                            NotificationCenter.default.post(name: Notification.Name(rawValue: Globals.collectionLoadNotificationKey), object: self)
                        }
                        
                    break
                    case .failure(let error):
                    //failure callback
                    print(error)
                }
            }
        }
    }
}
