//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

let token = ""

let api = BySykkelAPI(token: token)
let vm = BySykkelViewModel(api: api)
let vc = BySykkelViewController(viewModel: vm)
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = vc

PlaygroundPage.current.needsIndefiniteExecution = true
