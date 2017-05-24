//
//  Parser.swift
//  Audio Cast
//
//  Created by Khaled Rahman-Ayon on 10.05.17.
//  Copyright © 2017 Khaled Rahman-Ayon. All rights reserved.
//

import Foundation

class Parser {
    
    func getPodcastData(data: Data) -> (title: String?, imgageURL: String?) {
        
        let xml = SWXMLHash.parse(data)
//        print(xml["rss"]["channel"]["itunes:image"].element?.attribute(by: "href")?.text)
        
//        print(xml["rss"]["channel"]["title"].element?.text)
        
        return (xml["rss"]["channel"]["title"].element?.text, xml["rss"]["channel"]["itunes:image"].element?.attribute(by: "href")?.text)
    }
    
    //get all the episodes for the selected podcast!!!
    func getEpisodes(data: Data) -> [Episode] {
        
        let xml = SWXMLHash.parse(data)
        
        var episodes : [Episode] = []
        
        //getting each episodes from the url
        for item in xml["rss"]["channel"]["item"] {
            let episode = Episode()
            if let title = item["title"].element?.text! {
                episode.title = title
            }
            if let description = item["description"].element?.text! {
                episode.overViewText = description
            }
            if let audioLink = item["enclosure"].element?.attribute(by: "url")?.text {
                episode.audioURL = audioLink
            }
            if let pubDate = item["pubDate"].element?.text {
                if let date = Episode.formatter.date(from: pubDate) {
                    episode.pubDate = date
                    
                }
            }
            
            episodes.append(episode)
           
            
        }
        
       
        return episodes
    }
}

