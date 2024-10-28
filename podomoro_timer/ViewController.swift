//
//  ViewController.swift
//  podomoro_timer
//
//  Created by admin on 25/10/24.
//

import UIKit

class ViewController: UIViewController {
    var countTimer:Timer!
    var counter  = 25*60
    let offset : Int = 55;
    var isPause:Bool=false
    var isAnimationStarted:Bool=false
    let foreProgressLayer = CAShapeLayer()
    let backProgressLayer = CAShapeLayer()
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    var centerPoint :CGPoint = CGPoint(x: 0, y: 0);
    
    
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var timerText: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerPoint = CGPoint(x: view.frame.midX,y:view.frame.midY-CGFloat(offset))
        initUI()
        drawBackLayer();
        drawForLayer();
       
        
    }
    @IBAction func startBtn(_ sender: Any) {
        if(!isPause)
        {
            if(isAnimationStarted){
                resumeAnimation()
            }else{
                startAnimation()
            }
            countTimer = Timer.scheduledTimer(timeInterval: 1,
                                              target: self,
                                              selector: #selector(updateTimer),
                                              userInfo: nil,
                                              repeats: true)
            
            
            startBtn.setTitle("Pause", for: .normal)
            isPause=true;
        }else{
            pauseAnimation()
            countTimer.invalidate()
            startBtn.setTitle("Start", for: .normal)
            isPause = false
        }
    }
    @IBAction func resetBtn(_ sender: Any) {
        counter=25*60
        timerText.text = "25:00"
        stopAnimation()
        if isPause
        {
            startAnimation()
        }
        

    }
    @objc func updateTimer() {
        if counter > 0 {
            counter -= 1
            updateTimerLabel()
        } else {
            countTimer.invalidate()
        }
    }
    
    func updateTimerLabel() {
        let minutes = counter / 60
        let seconds = counter % 60
        timerText.text = String(format: "%02d:%02d", minutes, seconds)
    }
    func initUI(){
        startBtn.setTitle("Start", for: .normal)
        resetBtn.setTitle("Reset", for: .normal)
        startBtn.setTitleColor(.black, for: .normal)
        timerText.textColor = .white
        timerText.text = "25:00"
        timerText.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    func drawBackLayer(){
        backProgressLayer.path = UIBezierPath(arcCenter: CGPoint(x: centerPoint.x,y:centerPoint.y), radius: 105, startAngle: -90.degreestoRadians, endAngle: 270.degreestoRadians, clockwise: true).cgPath
        backProgressLayer.strokeColor = UIColor.orange.cgColor
        backProgressLayer.fillColor = UIColor.clear.cgColor
        backProgressLayer.lineWidth = 5
        view.layer.addSublayer(backProgressLayer)
        
    }
    func drawForLayer(){
        foreProgressLayer.path = UIBezierPath(arcCenter: CGPoint(x: centerPoint.x,y:centerPoint.y), radius: 105, startAngle: -90.degreestoRadians, endAngle: 270.degreestoRadians, clockwise: true).cgPath
        foreProgressLayer.strokeColor = UIColor.gray.cgColor
        foreProgressLayer.fillColor = UIColor.clear.cgColor
        foreProgressLayer.lineWidth = 5
      
        
    }
    
    func startAnimation(){
        view.layer.addSublayer(foreProgressLayer)
        resetAnimation()
        foreProgressLayer.strokeEnd = 0.0
        animation.keyPath = "strokeEnd"
        animation.fromValue = 0.0
        animation.toValue=1
        animation .duration=25*60
        animation.isRemovedOnCompletion = false
        animation.isAdditive=true;
        animation.fillMode = CAMediaTimingFillMode.forwards
        foreProgressLayer.add(animation, forKey: "strokeEnd")
        isAnimationStarted=true
    }
    func resetAnimation(){
        
        foreProgressLayer.speed = 1
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        foreProgressLayer.strokeEnd = 0.0
        isAnimationStarted = false
    }
    func resumeAnimation(){
        let pausedTime = foreProgressLayer.timeOffset
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        let timeSincePaused = foreProgressLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        foreProgressLayer.beginTime = timeSincePaused
        
    }
    func pauseAnimation(){
        let pausedTime = foreProgressLayer.convertTime(CACurrentMediaTime(), from: nil)
        foreProgressLayer.speed = 0.0
        foreProgressLayer.timeOffset = pausedTime
    }
    
    func stopAnimation(){
        foreProgressLayer.speed=1;
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        foreProgressLayer.removeAllAnimations()
        isAnimationStarted = false
    }
    
    
}


extension Int{
    var degreestoRadians :  CGFloat{
        return CGFloat(self) * .pi/180
    }
}
