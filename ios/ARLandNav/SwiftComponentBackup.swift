import UIKit

class SwiftComponent: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let label = UILabel(frame: self.bounds)
        label.textAlignment = .center
        label.text = "SWIFT CODE HERE"
        self.addSubview(label)
    }
    
}