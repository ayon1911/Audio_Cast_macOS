//
//  EpisodesViewController.swift
//  Audio Cast
//
//  Created by Khaled Rahman-Ayon on 24.05.17.
//  Copyright © 2017 Khaled Rahman-Ayon. All rights reserved.
//

import Cocoa
import AVFoundation

class EpisodesViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var playPauseButton: NSButton!
    @IBOutlet weak var deleteBtn: NSButton!
    
    @IBOutlet weak var tableView: NSTableView!
    
    
    var podcast: Podcast? = nil
    var podcastsVC: PodCastViewController? = nil
    
    var episodes: [Episode] = []
    
    var player: AVPlayer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        updateView()
    }
    
    func updateView() {
        //updating the podcast split view
        if podcast != nil {
            titleLabel.stringValue = (podcast?.title)!
        } else {
            titleLabel.stringValue = ""
            
        }
        if podcast?.imageURL != nil {
            let url = URL(string: (podcast?.imageURL)!)
            let image = NSImage(byReferencing: url!)
            imageView.image = image
        } else {
            imageView.image = nil
        }
        
        playPauseButton.isHidden = true
        
        //creating a new parser variable so that we can call the getEpisode func to view all the data
        getEpisodes()
        
        if podcast != nil {
            tableView.isHidden = false
            deleteBtn.isHidden = false
        } else {
            tableView.isHidden = true
            deleteBtn.isHidden = true
        }
        
    }
    
    func getEpisodes() {
        
        if podcast?.rssURL != nil {
            if let url = URL(string: (podcast?.rssURL)!) {
                URLSession.shared.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                    
                    if error != nil {
                        print(error.debugDescription)
                    } else {
                        
                        if data != nil {
                            let parser = Parser()
                            
                            //getting data from the PArser Class
                            self.episodes = parser.getEpisodes(data: data!)
                            //                            print(self.episodes)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            
                        }
                        
                    }
                    
                }).resume()
                
            }
        }
    }
    
    @IBAction func deleteBtnClicked(_ sender: Any) {
        //Deleting podcast from tabel
        if podcast != nil {
            
            if let appDelegate = NSApplication.shared().delegate as? AppDelegate {
                let context = appDelegate.persistentContainer.viewContext
                context.delete(podcast!)
                appDelegate.saveAction(nil)
                
                podcastsVC?.fetchData()
                
                podcast = nil
                
                updateView()
            }
        }
    }
    
    @IBAction func playPauseBtnClicked(_ sender: Any) {
        if playPauseButton.title == "Pause" {
            player?.pause()
            playPauseButton.title = "Play"
        } else {
            player?.play()
            playPauseButton.title = "Pause"
        }
        
    }
    //making our table cell views
    func numberOfRows(in tableView: NSTableView) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let episode = episodes[row]
        let cell = tableView.make(withIdentifier: "episodeCell", owner: self) as? EpisodeCell
        cell?.episodeLabel.stringValue = episode.title
        
        cell?.overView.mainFrame.loadHTMLString(episode.overViewText, baseURL: nil)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        cell?.pubDateLabel.stringValue = dateFormatter.string(from: episode.pubDate)
        
        return cell
        
        
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if tableView.selectedRow >= 0 {
            let episode = episodes[tableView.selectedRow]
            
            if let url = URL(string: episode.audioURL) {
                player?.pause()
                player = nil
                player = AVPlayer(url: url)
                player?.play()
            }
            
            playPauseButton.isHidden = false
            playPauseButton.title = "Pause"
            
        }
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 100
    }
    
    
    
    
    
    
}
