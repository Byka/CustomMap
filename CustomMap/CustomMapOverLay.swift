//
//  CustomMapOverLay.swift
//  CustomMap
//
//  Created by Suresh Reddy Yerasi on 18/07/18.
//  Copyright © 2018 Delta Technology And Management Services Private Limited. All rights reserved.
//

import Foundation
import MapKit

class CustomMapOverLay: MKTileOverlay {
    
    override func url(forTilePath path: MKTileOverlayPath) -> URL {
        print("requested tile\tz:\(path.z)\tx:\(path.x)\ty:\(path.y)")
//        let tileUrl = "https://tile.openstreetmap.org/\(path.z)/\(path.x)/\(path.y).png"
//        return URL(string: tileUrl)!
        
        print("requested tile\tz:\(path.z)\tx:\(path.x)\ty:\(path.y)")
        let tilePath = Bundle.main.url(
            forResource: "\(path.y)",
            withExtension: "png",
            subdirectory: "tiles/\(path.z)/\(path.x)",
            localization: nil)
        
        guard let tile = tilePath else {
            
            return Bundle.main.url(
                forResource: "parchment",
                withExtension: "png",
                subdirectory: "tiles",
                localization: nil)!
        }
        return tile
 
    }
}

