//
//  EpisodeCell.swift
//  Audio Cast
//
//  Created by Khaled Rahman-Ayon on 24.05.17.
//  Copyright © 2017 Khaled Rahman-Ayon. All rights reserved.
//

import Cocoa
import WebKit

class EpisodeCell: NSTableCellView {

    @IBOutlet weak var episodeLabel: NSTextField!
    @IBOutlet weak var pubDateLabel: NSTextField!
    @IBOutlet weak var overView: WebView!
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
