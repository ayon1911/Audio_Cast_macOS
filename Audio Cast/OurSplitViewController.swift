//
//  OurSplitViewController.swift
//  Audio Cast
//
//  Created by Khaled Rahman-Ayon on 24.05.17.
//  Copyright © 2017 Khaled Rahman-Ayon. All rights reserved.
//

import Cocoa

class OurSplitViewController: NSSplitViewController {

    @IBOutlet weak var podcastSplitItem: NSSplitViewItem!
    
    @IBOutlet weak var episodesSplitItem: NSSplitViewItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        if let podcastVC = podcastSplitItem.viewController as? PodCastViewController {
            if let episodesVC = episodesSplitItem.viewController as? EpisodesViewController {
                
                podcastVC.episodesVC = episodesVC
                episodesVC.podcastsVC = podcastVC
            }
        }
        
    }
    
}
