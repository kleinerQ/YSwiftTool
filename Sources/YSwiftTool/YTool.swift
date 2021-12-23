//
//  YTool.swift
//  YTool
//
//  Created by Yen on 2021/9/10.
//

import Foundation
import AVKit
let YToolProgressBarViewSize: CGFloat = 300
public class YTool {
    
    public static func countDownEffect(label: UILabel, completeHandler: @escaping ()->Void) {
        
        DispatchQueue.main.async {
            YTool.playSound()
            label.text = "3"
            label.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                label.text = "2"
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    label.text = "1"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        label.text = "0"
                        label.isHidden = true
                        completeHandler()
                    }
                }
            }
        }
    }
    
    static private var player: AVAudioPlayer?
    static private func playSound() {
        guard let url = Bundle.main.url(forResource: "countDown321", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            player?.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    public static var isPhone: Bool {
        get{
            if UIDevice.current.userInterfaceIdiom == .phone {
                return true
            }else {
                return false
            }
        }
    }
    
    public static var isPad: Bool {
        get{
            if UIDevice.current.userInterfaceIdiom == .pad {
                return true
            }else {
                return false
            }
        }
    }
}


//ui
extension YTool {
    public static func addEndEditingTap(view: UIView) {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(YTool.tapEndEditingAction(sender:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc static private func tapEndEditingAction(sender: UITapGestureRecognizer) {
        sender.view?.endEditing(true)
    }
    
    public static func showLoading(enable: Bool) {
        DispatchQueue.main.async {
            let currentWindow: UIWindow? = UIApplication.shared.windows.first
            if enable {
                
                for sub in currentWindow?.subviews ?? [] {
                    if sub.tag == 99 {
                        sub.removeFromSuperview()
                    }
                }
                
                let backgroundGrayView: UILabel = {
                    let v = UILabel()
                    v.isUserInteractionEnabled = true
                    v.font = v.font.withSize(100)
                    v.adjustsFontSizeToFitWidth = true
                    v.tag = 99
                    v.textAlignment = .center
                    v.text = "Processing..."
                    v.translatesAutoresizingMaskIntoConstraints = false
                    v.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.7)
                    return v
                }()
                
                currentWindow?.addSubview(backgroundGrayView)
                
                NSLayoutConstraint(item: backgroundGrayView, attribute: .top, relatedBy: .equal, toItem: backgroundGrayView.superview, attribute: .top, multiplier: 1, constant: 0).isActive = true
                NSLayoutConstraint(item: backgroundGrayView, attribute: .trailing, relatedBy: .equal, toItem: backgroundGrayView.superview, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
                NSLayoutConstraint(item: backgroundGrayView, attribute: .leading, relatedBy: .equal, toItem: backgroundGrayView.superview, attribute: .leading, multiplier: 1, constant: 0).isActive = true
                NSLayoutConstraint(item: backgroundGrayView, attribute: .bottom, relatedBy: .equal, toItem: backgroundGrayView.superview, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
            }else {
                for sub in currentWindow?.subviews ?? [] {
                    if sub.tag == 99 {
                        sub.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    private static let backgroundGrayView: UIView = {
        let v = UIView()
        v.tag = 90
        v.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 0.75)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private static let circularProgressBarView : CircleProgressView = {
        let v = CircleProgressView(size: YToolProgressBarViewSize)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    // if percentage is set, just update progress
    public static func showProgressView(enable: Bool = true, percentage: Float? = nil) {
        
        func remove(complete: (()-> Void)? = nil) {
            DispatchQueue.main.async {
                let currentWindow: UIWindow? = UIApplication.shared.windows.first
                for sub in currentWindow?.subviews ?? [] {
                    if sub.tag == 90 {
                        sub.removeFromSuperview()
                        for sub2 in sub.subviews {
                            sub2.removeFromSuperview()
                        }
                    }  // backgroundGrayView
                }
                complete?()
            }
        }
        
        func add() {
            DispatchQueue.main.async {
                remove {
                    let currentWindow: UIWindow? = UIApplication.shared.windows.first
                    currentWindow?.addSubview(YTool.backgroundGrayView)
                    YTool.backgroundGrayView.addSubview(YTool.circularProgressBarView)
                    
                    var targetView: UIView = YTool.backgroundGrayView
                    NSLayoutConstraint(item: targetView, attribute: .top, relatedBy: .equal, toItem: targetView.superview, attribute: .top, multiplier: 1, constant: 0).isActive = true
                    NSLayoutConstraint(item: targetView, attribute: .trailing, relatedBy: .equal, toItem: targetView.superview, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
                    NSLayoutConstraint(item: targetView, attribute: .leading, relatedBy: .equal, toItem: targetView.superview, attribute: .leading, multiplier: 1, constant: 0).isActive = true
                    NSLayoutConstraint(item: targetView, attribute: .bottom, relatedBy: .equal, toItem: targetView.superview, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
                    
                    targetView = YTool.circularProgressBarView
                    NSLayoutConstraint(item: targetView, attribute: .centerX, relatedBy: .equal, toItem: targetView.superview, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
                    NSLayoutConstraint(item: targetView, attribute: .centerY, relatedBy: .equal, toItem: targetView.superview, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
                    NSLayoutConstraint(item: targetView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: YToolProgressBarViewSize).isActive = true
                    NSLayoutConstraint(item: targetView, attribute: .width, relatedBy: .equal, toItem: targetView, attribute: .height, multiplier: 1, constant: 0).isActive = true
                    // align to the center of the screen
                    YTool.circularProgressBarView.progressAnimation(progess: 0, isFromZero: true)
                }
            }
            
        }
        
        if enable {
            
            if let percentage = percentage {
                if YTool.circularProgressBarView.superview == nil{
                    add()
                }
                YTool.circularProgressBarView.progressAnimation(progess: percentage)
            }else {
                add()
            }
            
        }else {
            remove()
        }
        
    }
}


//matrix
extension YTool {
    public static func multiply( _ matrixA:[[Float]], _ matrixB:[[Float]]) -> [[Float]] {
        
        if matrixA.count == 0 {
            
            print( "Empty matrix dimensions!" )
            return [[]] // returns empty matrix
        }
        
        if matrixA[ 0 ].count != matrixB.count {
            
            print( "Illegal matrix dimensions!" )
            return [[]] // returns empty matrix
        }
        
        let resultRowsize = matrixA.count
        let resultColumnsize = matrixB[0].count
        var result:[[Float]] = [[Float]]( repeating: [Float]( repeating: 0, count: resultColumnsize ), count: resultRowsize )
        
        for i in 0 ..< resultRowsize {
            
            for j in 0 ..< resultColumnsize {
                
                for k in 0 ..< matrixA[0].count {
                    result[ i ][ j ] += matrixA[ i ][ k ] * matrixB[ k ][ j ]
                }
            }
        }
        return result
    }
    
    public static func transposedArray(array: [[Float]] )-> [[Float]]{
        if array.count == 0 {
            return []
        }else {
            var transposedArray = [[Float]]()
            for i in stride(from: 0, to: array[0].count, by: 1)
            {
                var subArray = [Float]()
                for j in stride(from: 0, to: array.count, by: 1)
                {
                    subArray.append(array[j][i])
                }
                transposedArray.append(subArray)
            }
            return transposedArray
        }
    }
}


public extension Array where Element == Int {

    func sum() -> Int {
        return self.reduce(0, +)
    }
    
    func avg() -> Float32 {
        return Float32(self.sum()) / Float32(self.count)
    }
    
    func calculateLast201Median() -> Int {
        let targetIndex = (self.count - 201) >= 0 ? (self.count - 201) : 0
        let sorted = self[targetIndex..<self.count].sorted()
        
        if sorted.count % 2 == 0 {
            return sorted[(sorted.count / 2) - 1]
        } else {
            return sorted[(sorted.count - 1) / 2]
        }
    }
    
    func sumOfElementsquare()->Int {
        var sum: Int = 0
        for e in self {
            sum += e * e
        }
        return sum
    }
}

public extension Array where Element == Float32 {
    func minAndAboveZero()-> Float32 {
        var min: Float32 = 10000
        for e in self{
            if e < min {
                min = e
            }
        }
        return Swift.max(min, 0)
    }
    
    func sum() -> Float32 {
        return self.reduce(0, +)
    }
    
    func avg() -> Float32 {
        return self.sum() / Element(self.count)
    }
    
    func std() -> Float32 {
        let mean = self.avg()
        let v = self.reduce(0, { $0 + ($1-mean)*($1-mean) })
        return sqrt(v / (Float32(self.count)))
    }
    
    func calculateLast200Median() -> Float {
        let targetIndex = (self.count - 200) >= 0 ? (self.count - 200) : 0
        let sorted = self[targetIndex..<self.count].sorted()
        
        if sorted.count % 2 == 0 {
            return Float((sorted[(sorted.count / 2)] + sorted[(sorted.count / 2) - 1])) / 2
        } else {
            return Float(sorted[(sorted.count - 1) / 2])
        }
    }
    
    func sumOfElementsquare()->Float32 {
        var sum: Float32 = 0
        for e in self {
            sum += e * e
        }
        return sum
    }
}

public extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * .pi / 180
    }
}



public class CircleProgressView: UIView {
    
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)
    private var fromValue: Float = 0
    
    private var progressLb: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textColor = .black
        v.textAlignment = .center
        return v
    }()
    public init(size: CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        createCircularPath()
        self.addSubview(progressLb)
        NSLayoutConstraint(item: progressLb, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: progressLb, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: progressLb, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: progressLb, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func createCircularPath() {
        // created circularPath for circleLayer and progressLayer
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 80, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        // circleLayer path defined to circularPath
        circleLayer.path = circularPath.cgPath
        // ui edits
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 20.0
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = UIColor.white.cgColor
        // added circleLayer to layer
        layer.addSublayer(circleLayer)
        // progressLayer path defined to circularPath
        progressLayer.path = circularPath.cgPath
        // ui edits
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 10.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.green.cgColor
        // added progressLayer to layer
        layer.addSublayer(progressLayer)
    }
    
    public func progressAnimation(duration: TimeInterval) {
        // created circularProgressAnimation with keyPath
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        // set the end time
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 1.0
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
    
    public func progressAnimation(progess: Float, isFromZero: Bool = false) {
        
        // created circularProgressAnimation with keyPath
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        // set the end time
        if isFromZero {
            self.fromValue = 0
        }
        circularProgressAnimation.duration = 0.3
        circularProgressAnimation.fromValue = self.fromValue
        self.fromValue = progess
        circularProgressAnimation.toValue = progess
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
        progressLb.text = "\(Int(progess * 100.0)) %"
    }
}





public class TimecodeLabel: UILabel {

    
    let timer = RepeatingTimer(timeInterval: TimeInterval(0.01))
    
    public init(framePerSecond: Int) {
        super.init(frame: .zero)
        self.font = UIFont(name:"Courier", size: 30)
        self.adjustsFontSizeToFitWidth = true
        self.timer.eventHandler = {
            let currentTime = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: currentTime)
            let minute = calendar.component(.minute, from: currentTime)
            let second = calendar.component(.second, from: currentTime)
            let frameCount = Int(Double(calendar.component(.nanosecond, from: currentTime)) / (Double(1000000000)/Double(framePerSecond)))
            DispatchQueue.main.async {
                self.text = "\(String(format: "%02d", hour)):\(String(format: "%02d", minute)):\(String(format: "%02d", second)).\(String(format: "%02d", frameCount))"
            }
        }
        self.timer.resume()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}


public class RepeatingTimer {

    let timeInterval: TimeInterval
    
    public init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now() + self.timeInterval, repeating: self.timeInterval)
        t.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
        })
        return t
    }()

    public var eventHandler: (() -> Void)?

    private enum State {
        case suspended
        case resumed
    }

    private var state: State = .suspended

    deinit {
        timer.setEventHandler {}
        timer.cancel()
        /*
         If the timer is suspended, calling cancel without resuming
         triggers a crash. This is documented here https://forums.developer.apple.com/thread/15902
         */
        resume()
        eventHandler = nil
    }

    public func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }

    public func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
}
