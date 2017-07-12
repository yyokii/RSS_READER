//
//  ViewController.swift
//  RSS-READER
//
//  Created by 東原与生 on 2016/08/06.
//  Copyright © 2016年 yoki. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController,UIScrollViewDelegate,ArticleTableViewDelegate {
    @IBOutlet weak var sitesScrollView: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    
    var tabButtons: Array<UIButton> = []
    
    let wiredURL = "http://wired.jp/rssfeeder/"
    let shikiURL =  "http://www.100shiki.com/feed"
    let cinraURL =   "http://www.cinra.net/feed"
    
    let wired = "WIRED"
    let shiki = "100SHIKI"
    let cinra = "CINRA.NET"
    
    let wiredImageName = "wired_top_image.png"
    let shikiImageName = "100shiki_top_image.png"
    let cinraImageName = "cinra_top_image.png"
    
    let blue = UIColor(red: 92.0 / 255, green: 192.0 / 255, blue: 210.0 / 255, alpha: 1.0)
    let yellow = UIColor(red: 105.0 / 255, green: 207.0 / 255, blue: 153.0 / 255, alpha: 1.0)
    let red = UIColor(red: 195.0 / 255, green: 123.0 / 255, blue: 175.0 / 255, alpha: 1.0)
    let black = UIColor(red: 50.0 / 255, green: 56.0 / 255, blue: 60.0/255, alpha:1.0)
    
    
    var currentSelectedArticle : Article?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.performSegueWithIdentifier("showToArticleWebViewController", sender: nil)
        
        sitesScrollView.delegate = self
        
        self.sitesScrollView.contentSize = CGSize(width: self.view.frame.width*3, height: self.sitesScrollView.frame.height)
        self.sitesScrollView.isPagingEnabled = true
    

        setArticleTableView(0, siteName: wired, siteImageName: wiredImageName, color: blue,siteURL: wiredURL)
        setArticleTableView(self.view.frame.width, siteName: shiki, siteImageName: shikiImageName, color: yellow, siteURL: shikiURL)
        setArticleTableView(self.view.frame.width*2, siteName: cinra, siteImageName: cinraImageName, color: red, siteURL: cinraURL)
        
        setTabButton(self.view.center.x/2, text: "W", color: blue,tag: 1)
        setTabButton(self.view.center.x, text: "100", color: yellow,tag: 2)
        setTabButton(self.view.center.x*3/2, text: "C", color: red,tag: 3)
        
        setSelectedButton(tabButtons[0], selected: true)
        
        ArticleStocks.sharedInstance.getMyArticles()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    
    func setArticleTableView(_ x:CGFloat,siteName: String,siteImageName:String,color:UIColor, siteURL: String){
        let frame = CGRect(x: x, y: 0, width: self.view.frame.width, height: sitesScrollView.frame.height)
        let articleTableView = ArticleTableView(frame: frame,style: UITableViewStyle.plain)
        articleTableView.customDelegate = self
        articleTableView.loadRSS(siteURL)
        articleTableView.siteName = siteName
        articleTableView.siteImageName = siteImageName
        articleTableView.color = color
        self.sitesScrollView.addSubview(articleTableView)
    }
    
    
    func setTabButton(_ x:CGFloat, text: String, color: UIColor, tag: Int){
        let tabButton = UIButton()
        tabButton.frame.size = CGSize(width: 36, height: 36)
        tabButton.center = CGPoint(x: x, y: 44)
        tabButton.setTitle(text, for: UIControlState())
        tabButton.setTitleColor(color, for: UIControlState.selected)
        tabButton.setTitleColor(UIColor.white, for: UIControlState())
        tabButton.titleLabel?.font = UIFont(name: "HirakakuPron-W6",size: 13)
        tabButton.backgroundColor  = black
        tabButton.tag = tag
        tabButton.addTarget(self, action: #selector(ArticleViewController.tapTabButton(_:)), for: UIControlEvents.touchUpInside)
        tabButton.layer.cornerRadius = 18
        tabButton.layer.borderColor = UIColor.white.cgColor
        tabButton.layer.borderWidth = 1
        tabButton.layer.masksToBounds = true
        self.headerView.addSubview(tabButton)
        tabButtons.append(tabButton)
        
    }
    
    func tapTabButton(_ sender:UIButton){
        let pointX = self.view.frame.width * CGFloat(sender.tag-1)
        sitesScrollView.setContentOffset(CGPoint(x: pointX, y: 0), animated: true)
        
    }
    
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x/self.view.frame.width
        
        for num in 0..<3 {
            if page == CGFloat(num){
                setSelectedButton(tabButtons[num], selected: true)
            }else  {
                setSelectedButton(tabButtons[num], selected: false)
            }
        }

    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x/self.view.frame.width
        
        for num in 0..<3 {
            if page == CGFloat(num){
                setSelectedButton(tabButtons[num], selected: true)
            }else  {
                setSelectedButton(tabButtons[num], selected: false)
            }
        }
       
    }
    
    
    func setSelectedButton(_ button: UIButton, selected: Bool){
        button.isSelected = selected
        button.layer.borderColor = button.titleLabel?.textColor.cgColor
    }
    
    
    func didSelectedTableViewCell(_ article: Article) {
        self.currentSelectedArticle = article
        self.performSegue(withIdentifier: "showToArticleWebViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let articleWebViewController = segue.destination as! ArticleWebViewController
        articleWebViewController.article = currentSelectedArticle
        
    }
    
    
     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    


}

