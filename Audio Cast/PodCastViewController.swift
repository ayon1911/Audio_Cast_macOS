//
//  PodCastViewController.swift
//  Audio Cast
//
//  Created by Khaled Rahman-Ayon on 10.05.17.
//  Copyright © 2017 Khaled Rahman-Ayon. All rights reserved.
//

import Cocoa

class PodCastViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var podcastUrlTextField: NSTextField!
    
    var podcasts: [Podcast] = []
    //this variable will be resposible to carry the info from podcastVC to episodes VC with the help of splitViewController
    var episodesVC: EpisodesViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        
        podcastUrlTextField.stringValue = "http://www.espn.com/espnradio/podcast/feeds/itunes/podCast?id=2406595"
        fetchData()
        
    }
    
    func fetchData() {
        //fetching data from coredata
        if let context = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext{
            
            let fetchy = Podcast.fetchRequest() as NSFetchRequest<Podcast>
            fetchy.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            do {
                podcasts = try context.fetch(fetchy)
            }
            catch{}
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    @IBAction func addPodCastClicked(_ sender: Any) {
        
        //getting URL from the textField....
        if let url = URL(string: podcastUrlTextField.stringValue) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                
                if error != nil {
                    print(error.debugDescription)
                } else {
                    
                    if data != nil {
                        let parser = Parser()
                        
                        //getting data from the PArser Class
                        let info = parser.getPodcastData(data: data!)
                        //Checking if the podcast url already exists or not
                        if !self.rssUrlExists(rssUrl: self.podcastUrlTextField.stringValue) {
                            
                            //saving to coredata
                            if let context = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext {
                                let podcast = Podcast(context: context)
                                podcast.rssURL = self.podcastUrlTextField.stringValue
                                podcast.imageURL = info.imgageURL
                                podcast.title = info.title
                                
                                (NSApplication.shared().delegate as? AppDelegate)?.saveAction(nil)
                                self.fetchData()
                                
                                DispatchQueue.main.async {
                                    self.podcastUrlTextField.stringValue = ""
                                }
                            }
                        }
                        
                    }
                    
                }
                
            }).resume()
            
        }
    }
    
    func rssUrlExists(rssUrl: String) -> Bool {
        //checking if the URL Exists then it will tell us the URL exists already
        if let context = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext{
            
            let fetchy = Podcast.fetchRequest() as NSFetchRequest<Podcast>
            fetchy.predicate = NSPredicate(format: "rssURL == %@", rssUrl)
            
            do {
                let matchingPodcast = try context.fetch(fetchy)
                if matchingPodcast.count >= 1 {
                    return true
                } else {
                    return false
                }
            }
            catch{}
        }
        
        return false
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return podcasts.count
        
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let podcast = podcasts[row]
        
        if let cell = tableView.make(withIdentifier: "podCastCell", owner: self) as? NSTableCellView {
            if podcast.title != nil {
                cell.textField?.stringValue = podcast.title!
                
            } else {
                cell.textField?.stringValue = "UNKNOWN TITLE"
            }
            
            cell.textField?.stringValue = podcast.title!
            
            return cell
        }
        
        return NSTableCellView()
    }
    
    //selecting a row of the table
    func tableViewSelectionDidChange(_ notification: Notification) {
        //if none is selected then this table view might give -1 which will crash the program thats why we have to check it 
        if tableView.selectedRow >= 0 {
            let podcast = podcasts[tableView.selectedRow]
            
            episodesVC?.podcast = podcast
            episodesVC?.updateView()
            
        }
    }
    
}
