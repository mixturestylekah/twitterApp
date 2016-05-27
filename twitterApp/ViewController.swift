//
//  ViewController.swift
//  twitterApp
//
//  Created by kentaro on 2016/05/27.
//  Copyright © 2016年 kentaro aoki. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileimageView: UIImageView!
    @IBOutlet weak var headerScrollView: UIScrollView!
    
    var backTweetView: UIView!
    var textField: UITextField!
    var textView: UITextView!
    
    var tweetArray: Array<Dictionary<String, String>> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource  = self
        
        self.tableView.estimatedRowHeight = 78
        tableView.rowHeight = UITableViewAutomaticDimension
        
        headerScrollView.contentSize = CGSize(width: self.view.frame.width*2, height: headerScrollView.frame.height)
        //ImageViewの装飾
        setProfileImageView()
        
        let profileLabel = makeProfileLabel()
        headerScrollView.addSubview(profileLabel)
        
        headerScrollView.pagingEnabled = true
        headerScrollView.delegate = self
    }
    
    //スクロールビュー
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //デバックエリアにScrollViewのcontentOffsetを出力
        print("contentOffset: \(headerScrollView.contentOffset)")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //-------------TableViewの処理------------------
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "myCell")
        let tweet = tweetArray[indexPath.row]
        
        let nameLabel = cell.viewWithTag(1) as! UILabel
        nameLabel.text = tweet["name"]
        nameLabel.font = UIFont(name: "HirakakuProN-W6", size: 13)
        
        let textLabel = cell.viewWithTag(2) as! UILabel
        textLabel.text = tweet["text"]
        textLabel.font = UIFont(name: "HirakakuProN-W6", size: 18)
        textLabel.numberOfLines = 0
        
        let timeLabel = cell.viewWithTag(3) as! UILabel
        timeLabel.text = tweet["time"]
        timeLabel.font = UIFont(name: "HirakakuProN-W3", size: 10)
        timeLabel.textColor = UIColor.grayColor()
        
        let myImageView = cell.viewWithTag(4) as! UIImageView
        myImageView.image = UIImage(named: "pug")
        myImageView.layer.cornerRadius = 3
        myImageView.layer.masksToBounds = true
        
        return cell
    }
    
    
    //-------------ボタンがタップされた時の処理---------
    @IBAction func tapTweetBtn(sender: UIButton) {
        //関数の返り値を変数に代入
        let backTweetView = makeBackTweetView()
        self.view.addSubview(backTweetView)
        
        let tweetView = makeTweetView()
        backTweetView.addSubview(tweetView)
        
        let textField = makeTextField()
        tweetView.addSubview(textField)
        
        let textView = makeTextView()
        tweetView.addSubview(textView)
        
        let nameLabel = makeLabel("名前", y: 5)
        tweetView.addSubview(nameLabel)
        
        let tweetLabel = makeLabel("ツイート内容", y: 85)
        tweetView.addSubview(tweetLabel)
        
        let cancelBtn = makeCancelBtn(tweetView)
        tweetView.addSubview(cancelBtn)
        
        let submitBtn = makeSubmitBtn()
        tweetView.addSubview(submitBtn)
    }
    
    func tappedCancelBtn(sender: AnyObject){
        backTweetView.removeFromSuperview()
    }
    
    func tappedSubmitBtn(sender :AnyObject){
        if (textField.text!.isEmpty) || (textView.text.isEmpty){
            let alertController = UIAlertController(title: "Error", message: "'name' or 'text' is empty", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(action)
            presentViewController(alertController, animated: true, completion: nil)
        } else {
        let name = textField.text!
        let tweet = textView.text
        print("名前:\(name)、ツイート内容:\(tweet)")
        
        var tweetDic: Dictionary<String, String> = [:]
        tweetDic["name"] = textField.text!
        tweetDic["text"] = textView.text
        tweetDic["time"] = getCurrentTime()
        tweetArray.insert(tweetDic, atIndex: 0)

        
        backTweetView.removeFromSuperview()
        textField.text = ""
        textView.text = ""
        
        tableView.reloadData()
        }
    }
    
    //現在時刻を取得
    func getCurrentTime() -> String {
        let now = NSDate() // 現在日時の取得
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .ShortStyle
        let currentTime = dateFormatter.stringFromDate(now)
        return currentTime
    }

    //-------------部品生成のための処理----------------
    //backTweetViewを生成してサイズや色など細かい設定をし、返り値としてbackTweetViewを返すための関数
    func makeBackTweetView() -> UIView {
        backTweetView = UIView()
        backTweetView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        backTweetView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        return backTweetView
    }
    
    func makeTweetView() -> UIView {
        let tweetView = UIView()
        tweetView.frame.size = CGSizeMake(300, 300)
        tweetView.center.x = self.view.center.x
        tweetView.center.y = 250
        tweetView.backgroundColor = UIColor.whiteColor()
        tweetView.layer.shadowOpacity = 0.3
        tweetView.layer.cornerRadius = 3
        return tweetView
    }
    
    func makeTextField() -> UITextField {
        textField = UITextField()
        textField.frame = CGRectMake(10, 40, 280, 40)
        textField.font = UIFont(name: "HiraKakuProN-W6", size: 15)
        textField.borderStyle = UITextBorderStyle.RoundedRect
        return textField
    }
    
    func makeTextView() -> UITextView {
        textView = UITextView()
        textView.frame = CGRectMake(10, 120, 280, 110)
        textView.font = UIFont(name: "HiraKakuProN-W6", size: 15)
        textView.layer.cornerRadius = 8
        textView.layer.borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0).CGColor
        textView.layer.borderWidth = 1
        return textView
    }
    
    func makeLabel(text: String, y: CGFloat) -> UILabel {
        let label = UILabel(frame: CGRectMake(10, y, 280, 40))
        label.text = text
        label.font = UIFont(name: "HiraKakuProN-W6", size: 15)
        return label
    }
    
    func makeCancelBtn(tweetView: UIView) -> UIButton {
        let cancelBtn = UIButton()
        cancelBtn.frame.size = CGSizeMake(20, 20)
        cancelBtn.center.x = tweetView.frame.width-15
        cancelBtn.center.y = 15
        cancelBtn.setBackgroundImage(UIImage(named: "cancel.png"), forState: .Normal)
        cancelBtn.backgroundColor = UIColor(red: 0.14, green: 0.3, blue: 0.68, alpha: 1.0)
        cancelBtn.layer.cornerRadius = cancelBtn.frame.width / 2
        cancelBtn.addTarget(self, action: #selector(ViewController.tappedCancelBtn(_:)), forControlEvents:.TouchUpInside)
        return cancelBtn
    }
    
    func makeSubmitBtn() -> UIButton {
        let submitBtn = UIButton()
        submitBtn.frame = CGRectMake(10, 250, 280, 40)
        submitBtn.setTitle("送信", forState: .Normal)
        submitBtn.titleLabel?.font = UIFont(name: "HiraKakuProN-W6", size: 15)
        submitBtn.backgroundColor = UIColor(red: 0.14, green: 0.3, blue: 0.68, alpha: 1.0)
        submitBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        submitBtn.layer.cornerRadius = 7
        return submitBtn
    }
    
    func setProfileImageView() {
        profileimageView.layer.cornerRadius = 5
        profileimageView.layer.borderWidth = 2
        profileimageView.layer.borderColor = UIColor.whiteColor().CGColor
    }

    func makeProfileLabel() -> UILabel {
        let profileLabel = UILabel()
        profileLabel.frame.size = CGSizeMake(200, 100)
        profileLabel.center.x = self.view.frame.width*3/2
        profileLabel.center.y = headerScrollView.center.y-64
        profileLabel.text = "きのこだよ。好きなきのこはしめじで、嫌いなきのこはアミウダケです。よろしくね。"
        profileLabel.font = UIFont(name: "HirakakuProN-W6", size: 13)
        profileLabel.textColor = UIColor.whiteColor()
        profileLabel.textAlignment = NSTextAlignment.Center
        profileLabel.numberOfLines = 0
        return profileLabel
    }
}

