//
//  ArticleWebViewController.swift
//  RSS-READER
//
//  Created by 東原与生 on 2016/08/09.
//  Copyright © 2016年 yoki. All rights reserved.
//

import UIKit
import WebKit
import Social

class ArticleWebViewController: UIViewController,WKNavigationDelegate {
    
    let black = UIColor(red: 50.0/255, green: 56.0/255, blue: 60.0/255, alpha: 1.0)
    let wkWebView = WKWebView()
    let backgroundView = UIView()
    let shareView = UIView()
    var article : Article!
    
    var articleStocks = ArticleStocks.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(ArticleWebViewController.showActionMenu))
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barTintColor = black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HirakakuProN-W6", size: 15)!,NSForegroundColorAttributeName: UIColor.white]
        
        let URL = Foundation.URL(string: self.article.link)
        let URLReq = URLRequest(url: URL!)
        
        self.wkWebView.navigationDelegate = self
        self.wkWebView.frame = self.view.frame
        self.wkWebView.load(URLReq)
        self.view.addSubview(wkWebView)
        
                                         
        // Do any additional setup after loading the view.
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.navigationItem.title = "読み込み中・・・"
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.navigationItem.title = wkWebView.title
    }
    
    func showActionMenu () {
        
        setBackgroundiew()
        setShareView()
        setShareBtn(self.view.frame.width/8, tag: 1, imageName: "facebook_icon")
        setShareBtn(self.view.frame.width/8*3, tag: 2, imageName: "twitter_icon")
        setShareBtn(self.view.frame.width/8*5, tag: 3, imageName: "safari_icon")
        setShareBtn(self.view.frame.width/8*7, tag: 4, imageName: "bookmark_icon")
        
        
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.shareView.frame.origin = CGPoint(x: 0, y: self.view.frame.height-100)
            })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setBackgroundiew () {
        backgroundView.frame.size = self.view.frame.size
        backgroundView.frame.origin = CGPoint(x: 0, y: 0)
        backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.view.addSubview(backgroundView)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(ArticleWebViewController.tapBackgroundView))
        backgroundView.addGestureRecognizer(gesture)
    }
    
    func tapBackgroundView (){
        backgroundView.removeFromSuperview()
    }
    
    func setShareView () {
        shareView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 100)
        shareView.backgroundColor = UIColor.white
        shareView.layer.cornerRadius = 3
        backgroundView.addSubview(shareView)
    
    }
    
    func setShareBtn (_ x: CGFloat, tag: Int, imageName: String) {
        let shareBtn = UIButton()
        shareBtn.frame.size = CGSize(width: 60,height: 60)
        shareBtn.center = CGPoint(x: x, y: 50)
        shareBtn.setBackgroundImage(UIImage(named: imageName), for: UIControlState())
        shareBtn.layer.cornerRadius = 3
        shareBtn.tag = tag
        shareBtn.addTarget(self, action: #selector(ArticleWebViewController.tapShareBtn(_:)), for: UIControlEvents.touchUpInside)
        shareView.addSubview(shareBtn)
        
    }
    
    func tapShareBtn (_ sender:UIButton) {
        
        if sender.tag == 1 {
            let facebookVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookVC?.setInitialText(wkWebView.title)
            facebookVC?.add(wkWebView.url)
            present(facebookVC!, animated: true, completion: nil)
            
        } else if sender.tag == 2 {
            let twitterVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterVC?.setInitialText(wkWebView.title)
            twitterVC?.add(wkWebView.url)
            present(twitterVC!, animated: true, completion: nil)
            
        } else if sender.tag == 3 {
            UIApplication.shared.openURL(wkWebView.url!)
            
        } else if sender.tag == 4 {
            
            if isStockedArticle(){
                showAlert("すでにブックマークされています！！")
                
            } else {
                self.articleStocks.addArticleStocks(self.article)
                showAlert("登録しました")
            }
            
            
        }
        
    }
    
    func showAlert (_ text: String) {
        let alertController = UIAlertController(title: text, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) ->Void in
            self.backgroundView.removeFromSuperview()
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func isStockedArticle () ->Bool {
        for myArticle in self.articleStocks.myArticles {
            
            if myArticle.link == self.article.link {
                return true
            }
        }
        
        return false
        
    }



}
