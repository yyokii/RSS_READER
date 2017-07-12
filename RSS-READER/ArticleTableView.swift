//
//  ArticleTableView.swift
//  RSS-READER
//
//  Created by 東原与生 on 2016/08/07.
//  Copyright © 2016年 yoki. All rights reserved.
//

import UIKit

@objc protocol ArticleTableViewDelegate{
    func didSelectedTableViewCell(_ artiicle: Article)
}

class ArticleTableView: UITableView ,UITableViewDelegate,UITableViewDataSource,XMLParserDelegate{
    
    weak var customDelegate : ArticleTableViewDelegate?
    
    var elementName = ""
    var articles :Array<Article> = []
    
    var siteName: String!
    var siteImageName: String!
    var color: UIColor!
    
    
    override init(frame: CGRect,style: UITableViewStyle){
        super.init(frame: frame, style: style)
        
        self.delegate = self
        self.dataSource = self
        
        self.register(UINib(nibName: "SiteTopTableViewCell", bundle: nil), forCellReuseIdentifier: "SiteTopTableViewCell")
        self.register(UINib(nibName: "ArticleTableViewCell",bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if section == 0{
            return 1
        }else{
            return self.articles.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SiteTopTableViewCell", for: indexPath) as! SiteTopTableViewCell
            
            cell.siteImageView.image = UIImage(named: self.siteImageName)
            cell.siteName.text = self.siteName
            cell.imageMaskView.backgroundColor = self.color
            
            
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as! ArticleTableViewCell
            
            let article = self.articles[(indexPath as NSIndexPath).row]
            cell.title.text  = article.title
            cell.descript.text = article.descript
            let date: Date = Date.convertDateFromString(article.date)
            cell.date.text = date.convertStringFromDate()
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 0{
            return 200
        }else{
            return 85
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section != 0{
            let article = articles[(indexPath as NSIndexPath).row]
            self.customDelegate?.didSelectedTableViewCell(article)
        }
    }
    
    
    func loadRSS(_ siteURL: String) {
        if let url = URL(string: siteURL) {
            let request = URLRequest(url: url)
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: {
                (data, response, error) -> Void in
                let parser = XMLParser(data: data!)
                parser.delegate = self
                parser.parse()
         
            })
            task.resume()
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
    
        self.elementName = elementName
        if self.elementName == "item" {
            let article = Article()
            self.articles.append(article)
        }
        

    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let lastArticle = self.articles.last
        if self.elementName == "title"{
            
            lastArticle?.title += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
        } else if self.elementName == "description"{
            
            lastArticle?.descript += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
        } else if self.elementName == "pubDate"{
            
            lastArticle?.date += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
        } else if self.elementName == "link"{
            
            lastArticle?.link += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
        DispatchQueue.main.async(execute: {
            self.reloadData()
        })
    }
    
    func conversionDateFormat(_ dateString:String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "EEE, dd MMM yyyy  HH:mm:ss Z"
        inputFormatter.locale = Locale(identifier: "en_US")
        let date:Date! = inputFormatter.date(from: dateString)
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyy/MM/dd HH:mm"
        let outPutDateString:String = outputFormatter.string(from: date)
        return outPutDateString
    }
        
    
    

}







