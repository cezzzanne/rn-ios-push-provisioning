import Foundation
import UIKit

@objc(RNRedButtonManager)
class RNRedButtonManager: RCTViewManager {
  override func view() -> UIView! {
    return RNRedButton()
  }
}

@objc(RNRedButton)
class RNRedButton: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    let button = UIButton(type: .system)
    button.frame = self.bounds
    button.backgroundColor = .red
    button.setTitle("Red Button", for: .normal)
    button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    self.addSubview(button)
  }
  
  @objc func buttonPressed() {
    print("Red button was pressed!")
  }
}
