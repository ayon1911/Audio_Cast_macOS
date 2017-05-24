//
//  Episode.swift
//  Audio Cast
//
//  Created by Khaled Rahman-Ayon on 24.05.17.
//  Copyright © 2017 Khaled Rahman-Ayon. All rights reserved.
//

import Foundation
import Cocoa

class Episode {
    // we need a title, date, description and also the url for the audio which we can play
    var title = ""
    var overViewText = ""
    var audioURL = ""
    var pubDate = Date()
    
    //Date formatter for the publication date convertiing to our date object
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
}
