//
//  Calendar.swift
//  Surfers calendar
//
//  Created by Владимир on 17.01.16.
//  Copyright © 2016 Gorelovskiy. All rights reserved.
//

import Foundation
class Calendar {
    var year = 1
    var mouth = 1
    var namberDay = 1
    var weekDay = 1

    
    
    init(year: Int,mouth: Int, namberDay: Int, weekDay: Int){
        self.year = year
        self.mouth = mouth
        self.namberDay  = namberDay
        self.weekDay = weekDay
        
    }
}