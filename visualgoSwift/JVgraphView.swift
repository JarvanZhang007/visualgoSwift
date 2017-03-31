//
//  JVgraphView.swift
//  visualgoSwift
//
//  Created by Jarvan on 2017/3/22.
//  Copyright © 2017年 Jarvan. All rights reserved.
//

import UIKit

class JVgraphView: UIView {
    
    var count:Int = 0
    var gap:CGFloat = 0
    let itemWidth:CGFloat=30
    var viewArray:Array<JVgraphItemView> = [];
    
    var lastItemDict:Dictionary<JVgraphItemView,Bool> = Dictionary()
    
    
    var finishAction:(()->Void)?
//    MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createBorder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createBorder() {
        self.layer.borderColor = UIColor.init(red: 41/255, green: 182/255, blue: 246/255, alpha: 1.0).cgColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5
    }

    
//    MARK: - private Method
    func clearView(){
        for view:UIView in viewArray {
            view.removeFromSuperview()
        }
        viewArray.removeAll()
    }
    
//    MARK: - draw UI
    func drawGraph(array:Array<Int>) {
        self.clearView()
        count=array.count
        gap=(self.frame.width-CGFloat(count)*itemWidth)/CGFloat(count+1)
        
        for i in 0..<count {
            let item=array[i]
            let view=JVgraphItemView.init(frame: self.getItemRect(item: CGFloat(i)),itemValue: item)
            self.addSubview(view)
            viewArray.append(view)
        }
    }
    
    
    func getItemRect(item:CGFloat) -> CGRect {
        var x:CGFloat=0,y:CGFloat=0,w:CGFloat=0,h:CGFloat=0
        x=item==0 ? gap : (item+1)*gap+item*itemWidth
        y=0
        w=itemWidth
        h=self.frame.height
        return CGRect.init(x: x, y: y, width: w, height: h)
    }
    
//    MARK: - QuckSort
    func startSort(){
        DispatchQueue.global().async {
            self.quickSort(start: 0, end: self.viewArray.count-1)

            if self.finishAction != nil{
                self.finishAction?()
            }
            usleep(sleepTime)
            for item in self.viewArray{
                item.changeState(state: .normal)
            }
        }
    }
    
    
    func quickSort(start:Int,end:Int) {
        
        if start == end{
            usleep(sleepTime)
         self.viewArray[start].changeState(state: .end)
        }
        
        if start>=end {
            return;
        }
        let startItem = self.viewArray[start]
//        改变基准点颜色
        usleep(sleepTime)
        startItem.changeState(state: .pivot)
        
        let pivot:Int=startItem.number
        var i:Int=start+1
        var storeIndex:Int=i
        while i<end+1 {
//            改变之前的颜色
            if lastItemDict.keys.count>0 {
                for item:JVgraphItemView in (lastItemDict.keys) {
                    if (lastItemDict[item])!{
                        usleep(sleepTime)
                        item.changeState(state: .max)
                    }else{
                        usleep(sleepTime)
                        item.changeState(state: .min)
                    }
                }
                lastItemDict.removeAll()
            }
            
            let currentItem=self.viewArray[i]
            usleep(sleepTime)
            currentItem.changeState(state: .current)
            //交换比较小的到大小相邻的位置
            if currentItem.number<pivot {
                self.swap(changeIdx: i, toIdx: storeIndex)
                storeIndex+=1
                lastItemDict.updateValue(false, forKey: currentItem)
            }else{
                lastItemDict.updateValue(true, forKey: currentItem)
            }
            i += 1
        }
        
        self.swap(changeIdx: start, toIdx: storeIndex-1)
        
        
        usleep(sleepTime)
        for (i,item) in self.viewArray.enumerated() {
            if i>=start&&i<=end {
                if item.isEqual(startItem) {
                    item.changeState(state: .end)
                }else{
                    item.changeState(state: .normal)
                }
                
                lastItemDict.removeAll()
            }
        }
        
        
        if (end-start) == 1 {
            usleep(sleepTime)
            viewArray[end].changeState(state: .end)
        }
        
        self.quickSort(start: start, end: storeIndex-2)
        
        self.quickSort(start: storeIndex, end: end)
        
    }
    
    func swap(changeIdx:Int,toIdx:Int){
        if changeIdx==toIdx {
            return
        }
        let view1=self.viewArray[changeIdx]
        let view2=self.viewArray[toIdx]
        let cRT:CGRect=view1.frame
        let tRT:CGRect=view2.frame
        

        let temporary:JVgraphItemView = self.viewArray[changeIdx]
        self.viewArray[changeIdx]=self.viewArray[toIdx]
        self.viewArray[toIdx]=temporary
        
        usleep(sleepTime)
        
        let semaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue.main.sync {
            UIView.animate(withDuration: 0.25, animations: {
                view1.frame=tRT
                view2.frame=cRT
            }, completion: { (finished) in
                semaphore.signal()
            })
        }
        semaphore.wait()
    }

}
