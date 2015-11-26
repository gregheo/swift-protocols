/*:
### BooleanType examples

by @gregheo

Check out the full article on [swiftunboxed.com](http://swiftunboxed.com/protocols/BooleanType/).

If you find this useful, please let me know and share the post!
*/
import Cocoa
//: C-style behavior where 0 is `false` and everything else is `true`
extension Int: BooleanType {
  public var boolValue: Bool {
    return self != 0
  }
}

if (42) {
  print("42 is the truth!")
}

if (0) {
  // will not execute
} else {
  print("Sorry, 0 is not true :(")
}

//: Swift 1 behavior where `nil` (aka Optional.None) acts like `false`.
extension Optional: BooleanType {
  public var boolValue: Bool {
    switch self {
    case .Some:
      return true
    case .None:
      return false
    }
  }
}

let opt1: String? = nil
let opt2: String? = "Hello"

if opt1 {
  print("opt 1 appears true!")
}

if opt2 {
  print("opt 2 appears true!")
}

//: Non-empty arrays are `true`.
extension Array: BooleanType {
  public var boolValue: Bool {
    return self.count > 0
  }
}

if [0, 1, 2] {
  print("non-empty arrays are true!")
}

let emptyArray = [Double]()

if emptyArray {
  print("will not be run :(")
}
