//
//  ArticleStocks.swift
//  RSS-READER
//
//  Created by 東原与生 on 2016/08/14.
//  Copyright © 2016年 yoki. All rights reserved.
//

import UIKit

class ArticleStocks: NSObject {
    static let sharedInstance = ArticleStocks()
    var myArticles: Array<Article>  = []
    
    func addArticleStocks (_ article: Article) {
        self.myArticles.insert(article,at: 0)
        self.saveArticle()
        
    }
    
    func saveArticle () {
        var tmpArticles: Array<Dictionary<String,AnyObject>> = []
        for myArticle in self.myArticles {
            let articleDic = ArticleStocks.convertDictionary(myArticle)
            tmpArticles.append(articleDic)
        }
        
        let defaults = UserDefaults.standard
        defaults.set(tmpArticles, forKey: "myArticles")
        defaults.synchronize()
        
    }
    
    
    func getMyArticles(){
        let defaults = UserDefaults.standard
        if let articles = defaults.object(forKey: "myArticles") as? Array<Dictionary<String,String>> {
            for dic in articles {
                let article = ArticleStocks.convertArticleMode(dic as Dictionary<String, AnyObject>)
                self.myArticles.append(article)
            }
            
        }
    }
    
    class func convertArticleMode (_ dic: Dictionary<String,AnyObject>) -> Article {
        let article = Article()
        article.title = dic["title"] as! String
        article.descript = dic["descript"] as! String
        article.date = dic["date"] as! String
        article.link = dic["link"]! as! String
        
        return article
        
        
    }
    
    
     class func convertDictionary (_ article: Article) -> Dictionary<String,AnyObject> {
        var dic = Dictionary<String,AnyObject>()
        dic["title"] = article.title as AnyObject?
        dic ["descript"] = article.descript as AnyObject?
        dic["date"] = article.date as AnyObject?
        dic["link"] = article.link as AnyObject?
        
        return dic
    }
    
    func removeMyArticle  (_ index: Int) {
        self.myArticles.remove(at: index)
        saveArticle()
    }

}
