//
//  JVgraphItemView.swift
//  visualgoSwift
//
//  Created by Jarvan on 2017/3/22.
//  Copyright © 2017年 Jarvan. All rights reserved.
//

import UIKit





enum GIoptionState:Int{
    case normal,pivot,current,min,max,end
}

class JVgraphItemView: UIView {
    
    let critical:Int = 25
    
    let labelHeight:CGFloat = 30
    
    var oneHeight:CGFloat = 0
    
    var number = 0
    
//    var testState:GIoptionState = .normal
    
//MARK: - UI Control
    let valueLabel = UILabel()
    let ghView = UIView()
//MARK: - init
    init(frame: CGRect,itemValue:Int) {
        super.init(frame: frame)
        number=itemValue
        oneHeight=self.frame.height/CGFloat(JVMaxNumber)
        let gHeight=oneHeight*CGFloat(itemValue)
        let y = self.frame.height-gHeight
        ghView.frame=CGRect.init(x: 0, y: y, width: self.frame.width, height: gHeight)
        self.addSubview(ghView)
        if itemValue>critical {
            valueLabel.frame=CGRect.init(x: 0, y: y, width: self.frame.width, height: labelHeight)
        }else{
            valueLabel.frame=CGRect.init(x: 0, y: y-labelHeight, width: self.frame.width, height: labelHeight)
        }
        valueLabel.text=String(itemValue)
        valueLabel.textColor=UIColor.black
        valueLabel.textAlignment=NSTextAlignment.center
        self.addSubview(valueLabel)
        
        self.ghView.backgroundColor=normalColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK:- function
    func changeState(state:GIoptionState) {
        
        DispatchQueue.main.async(execute: {
            switch state {
            case .normal:
                self.ghView.backgroundColor=normalColor
            case .current:
                self.ghView.backgroundColor=currentColor
            case .pivot:
                self.ghView.backgroundColor=pivotColor
            case .min:
                self.ghView.backgroundColor=minColor
            case .max:
                self.ghView.backgroundColor=maxColor
            default:
                self.ghView.backgroundColor=endColor
            }
        })
    }
 
}
