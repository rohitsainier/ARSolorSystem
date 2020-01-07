//
//  Planet.swift
//  SolorSystem
//
//  Created by Rohit Saini on 24/07/19.
//  Copyright © 2019 Rohit Saini. All rights reserved.
//

import UIKit

class Planet{
    var name: String
    var radius: CGFloat
    var rotation: CGFloat
    var color: UIColor
    var sunDistance: Float
    
    init(name: String,radius: CGFloat,rotation: CGFloat,color: UIColor,sunDistance: Float){
        self.name = name
        self.radius = radius
        self.rotation = rotation
        self.color = color
        self.sunDistance = sunDistance
    }
}
