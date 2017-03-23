//
//  QuickSortViewController.swift
//  visualgoSwift
//
//  Created by Jarvan on 2017/3/22.
//  Copyright © 2017年 Jarvan. All rights reserved.
//

import UIKit

let JVMaxNumber:UInt32 = 50  //产生随机数的最大值

let sleepTime:UInt32 = 300000    //1 sec = 1000000 休眠时间

let numberCount=13   //多少个待排序的数

let normalColor:UIColor = UIColor.init(red: 172/255, green: 216/255, blue: 231/255, alpha: 1.0)

let pivotColor:UIColor = UIColor.init(red: 255/255, green: 255/255, blue: 2/255, alpha: 1.0)

let currentColor:UIColor = UIColor.init(red: 220/255, green: 20/255, blue: 60/255, alpha: 1.0)

let minColor:UIColor = UIColor.init(red: 60/255, green: 179/255, blue: 113/255, alpha: 1.0)

let maxColor:UIColor = UIColor.init(red: 153/255, green: 51/255, blue: 204/255, alpha: 1.0)

let endColor:UIColor = UIColor.init(red: 255/255, green: 165/255, blue: 0/255, alpha: 1.0)



class QuickSortViewController: UIViewController {
    
    var dataArray=Array<Int>()
    var grahpView:JVgraphView?=nil
    
    let stateLabel:UILabel=UILabel()
    
//    当前图表的状态  0 为默认 1 为正在排序 3为完成
   dynamic var gvState:UInt = 0
    
    var myContext:NSObject!

    
//    MARK: - lift cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        grahpView=JVgraphView.init(frame: CGRect.init(x: 5, y: 10, width: self.view.frame.width-10, height: self.view.frame.height-200))
        
        self.view.addSubview(grahpView!)
        
        stateLabel.frame=CGRect.init(origin:CGPoint.zero, size: CGSize.init(width: 80, height: 30))
        
        stateLabel.center = CGPoint.init(x: (grahpView?.center.x)!, y: (grahpView?.frame.maxY)!+40)
        
        stateLabel.textColor=UIColor.init(red: 167/255, green: 212/255, blue: 31/255, alpha: 1.0)
        stateLabel.textAlignment = .center
        
        self.view.addSubview(stateLabel)
        
        self.createDataWithLayoutUI()
        
//        add block
        grahpView?.finishAction={
                self.gvState=2
        }
//        add KVO 
        self.addObserver(self, forKeyPath: "gvState", options: .new, context: &myContext)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    MARK: - init UI Data
    func createDataWithLayoutUI(){
        dataArray.removeAll();
        for _ in 0..<numberCount {
            dataArray.append(Int(self.random()))
        }
        grahpView?.drawGraph(array: dataArray)
        print("hello Array "+String(describing: dataArray))
    }
    
//    MARK: - private Event
    @IBAction func reCreateClick(_ sender: UIButton) {
        if self.gvState == 1{
            return
        }
        self.createDataWithLayoutUI()
        self.gvState=0
    }

    
    @IBAction func startSort(_ sender: UIButton) {

        if self.gvState == 1{
            return
        }
        self.gvState=1
        grahpView?.startSort()
    }
    
    
//    MARK: - KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        
        if context == &myContext {
            
            
        DispatchQueue.main.async(execute: {
            if let newValue:UInt = change?[NSKeyValueChangeKey.newKey] as! UInt? {
                switch newValue {
                case 1:
                    self.stateLabel.text="working"
                case 2:
                    self.stateLabel.text="Success"
                default:
                    self.stateLabel.text=""
                }
            }
        })
            
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    
//    MARK: - tool Method
    func random() -> UInt32 {
        let max: UInt32 = JVMaxNumber
        let min: UInt32 = 8
        return arc4random_uniform(max-min) + min
    }
}
