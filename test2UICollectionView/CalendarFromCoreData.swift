//
//  CalendarFromCoreData.swift
//  test2UICollectionView
//
//  Created by Владимир on 22.01.16.
//  Copyright © 2016 Gorelovskiy. All rights reserved.
//

import Foundation
class CalendarFromCoreData {
    
    var year = 1
    var mouth = 1
    var day = 1
    var starttraining = ""
    var endtraining = ""
    var training = false
    var weave = ""
    var rate = ""
    var comment = ""
    var photo: Data
    var additional = ""
    
  
    
    
    
    init(year: Int,mouth: Int, day: Int, starttraining: String, endtraining: String, training: Bool, weave: String, rate: String, comment: String, photo: Data, additional: String){
        self.year = year
        self.mouth = mouth
        self.day = day
        self.starttraining = starttraining
        self.endtraining = endtraining
        self.training = training
        self.weave = weave
        self.rate = rate
        self.comment = comment
        self.photo = photo
        self.additional = additional
     
        
    }
}
