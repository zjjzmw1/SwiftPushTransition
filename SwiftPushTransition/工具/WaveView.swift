//
//  WaveView.swift
//  LLWave
//
//  Created by liping on 2017/9/5.
/*
 正弦型函数解析式：y = A * sin(ωx+φ) + h
 周期T = 2π/ω
 各常数值对函数图像的影响：
 
 φ（初相位）：决定波形与X轴位置关系或横向移动距离（左加右减）
 
 ω：决定周期（最小正周期T=2π/|ω|）
 
 A：决定峰值（即纵向拉伸压缩的倍数）
 
 h：表示波形在Y轴的位置关系或纵向移动距离（上加下减）
 
 */
import UIKit

class WaveView: UIView {
    
    private lazy var waveLayer1: CAShapeLayer = CAShapeLayer()
    private lazy var waveLayer2: CAShapeLayer = CAShapeLayer()
    private var  timer: CADisplayLink?
    private var rate: CGFloat = 0
    //波浪位移 φ
    private var offsetX: CGFloat = 0
    //波浪高度
    private var waveHeight: CGFloat = 0 {
        didSet {
            layoutIfNeeded()
            rate = waveHeight / bounds.size.height
        }
    }
    //波长里面几个波曲线（波峰和波谷为一个波曲线，比如在0~2π里面有个2个波曲线）
    public var wave: CGFloat = 1.5
    //波纹振幅
    public var waveAmplitude: CGFloat = 0
    //波纹周期 T = 2 *pi /|ω|
    public var waveCycle: CGFloat = 0
    //波纹速度，用来累加到相位φ
    public var waveSpeed: CGFloat = 3
    //波浪颜色
    public var color1: UIColor = UIColor.orange {
        didSet {
            wavelayer(waveLayer1, color: color1)
        }
    }
    public var color2: UIColor = UIColor.yellow
    {
        didSet {
            wavelayer(waveLayer2, color: color2)
        }
    }
    
    //析构函数
    deinit {
        stop()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initializerWaveLayer()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializerWaveLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializerWaveLayer()
    {
        rate = 0.5 + 0.3
        waveCycle = wave * .pi / bounds.width
        waveSpeed = 3
        self.layer.addSublayer(waveLayer1)
        self.layer.addSublayer(waveLayer2)
    }
    private func wavelayer(_ layer: CAShapeLayer, color: UIColor)
    {
        layer.frame = self.bounds
        layer.backgroundColor = UIColor.clear.cgColor
        layer.lineWidth = 0.5
        layer.strokeColor = UIColor.clear.cgColor
        layer.fillColor = color.cgColor
        layer.strokeStart = 0
        layer.strokeEnd = 1
    }
    //开启波浪
    public func start()
    {
        wavelayer(self.waveLayer1, color: color1)
        wavelayer(self.waveLayer2, color: color2)
        timer = CADisplayLink.init(target: self, selector:#selector(self.handleTimer))
        timer?.add(to: RunLoop.current, forMode: .commonModes)
    }
    
    /**
     处理displaylink事件，比较要注意的是当循环结束添加line
     wavePath1.addLine(to: CGPoint.init(x: bounds.width, y: bounds.height))
     wavePath1.addLine(to: CGPoint.init(x: 0, y: bounds.height))
     因为我的坐标系是自上而下的，因此注意最后两个点绘制坐标。
     */
    @objc private func handleTimer()
    {
        let wavePath1 = UIBezierPath()
        let wavePath2 = UIBezierPath()
        //振幅系数，振幅越大波峰越陡
        waveAmplitude = bounds.height * rate * 0.1
        //正弦型函数解析式：y = A * sin(ωx+φ) + h  ω 读alpha
        var y1 = (1 - rate) * bounds.height
        var y2 = y1
        wavePath1.move(to: CGPoint.init(x: 0, y: y1))
        wavePath2.move(to: CGPoint.init(x: 0, y: y2))
        //波长里面有几个波曲线可设置
        let a = waveCycle
        //当offsetX趋近CGFloat maxValue值时这个值应减减防止奔溃
        if offsetX >= CGFloat.greatestFiniteMagnitude {
            offsetX = offsetX - waveSpeed
        }else {
            offsetX = offsetX + waveSpeed
        }
        //峰值
        let h = (1 - rate) * bounds.height
        for x in 0...Int(bounds.width) {
            //控制波浪1和波浪2的速度不同形成动画效果
            let f1 =  offsetX / bounds.width * .pi
            let f2 =  0.75 * offsetX / bounds.width * .pi
            y1 = waveAmplitude * CGFloat(sin(Double(a * CGFloat(x) + f1))) + (h - 10)
            y2 = waveAmplitude * CGFloat(sin(Double(a * CGFloat(x) + f2))) + h
            wavePath1.addLine(to: CGPoint.init(x: CGFloat(x), y: y1))
            wavePath2.addLine(to: CGPoint.init(x: CGFloat(x), y: y2))
        }
        wavePath1.addLine(to: CGPoint.init(x: bounds.width, y: bounds.height))
        wavePath1.addLine(to: CGPoint.init(x: 0, y: bounds.height))
        wavePath1.close()
        waveLayer1.path = wavePath1.cgPath
        
        wavePath2.addLine(to: CGPoint.init(x: bounds.width, y: bounds.height))
        wavePath2.addLine(to: CGPoint.init(x: 0, y: bounds.height))
        wavePath2.close()
        waveLayer2.path = wavePath2.cgPath
        
    }
    //停止波浪
    public func stop()
    {
        timer?.remove(from: RunLoop.current, forMode: .commonModes)
        timer?.invalidate()
    }
    
}
