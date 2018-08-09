//
//  Globals.swift
//  ComicBookReader
//
//  Created by Prakhar Srivastava on 08/08/18.
//  Copyright © 2018 Prakhar Srivastava. All rights reserved.
//

import Foundation

class Globals{
    static var listStartNumber = 1
    static var listEndNumber = 10
    static var gridStartNumber = 1
    static var gridEndNumber = 10
    static var listItems:[ComicBook]! = []
    static var gridItems:[ComicBook]! = []
    static let tableLoadNotificationKey = "notifyTable"
    static let collectionLoadNotificationKey = "notifyCollection"
    static var isFetchingList:Bool!
    static var isFetchingGrid:Bool!
}
