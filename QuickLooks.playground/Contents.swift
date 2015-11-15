/*:
### CustomPlaygroundQuickLookable examples

by @gregheo

Check out the full article on [swiftunboxed.com](http://swiftunboxed.com/protocols/CustomPlaygroundQuickLookable/).

If you find this useful, please let me know and share the post!

You'll find an example implementation for some of the quick look types followed by a sample instance. You can see the results in the sidebar, and you can also hover the mouse pointer over there for a quick look icon to click.
*/
import AppKit
import SpriteKit
/*:
`Text` is pretty simple: just return a string.
*/
struct TextExample: CustomPlaygroundQuickLookable  {
  var text: String

  func customPlaygroundQuickLook() -> PlaygroundQuickLook {
    return .Text("Plain text: \(text)")
  }
}

let textExample = TextExample(text: "Hello")

/*:
`AttributedString` example
*/
struct AttributedTextExample: CustomPlaygroundQuickLookable  {
  var text: String
  var isBold: Bool

  func customPlaygroundQuickLook() -> PlaygroundQuickLook {
    let font = isBold ? NSFont.boldSystemFontOfSize(16) : NSFont.systemFontOfSize(16)
    let attr = NSAttributedString(string: text, attributes: [NSFontAttributeName: font])
    return .AttributedString(attr)
  }
}

let attrExample = AttributedTextExample(text: "Hello", isBold: true)

/*:
`Color` example.
*/
struct Paint: CustomPlaygroundQuickLookable {
  var viscosity: Double
  var color: NSColor
  func customPlaygroundQuickLook() -> PlaygroundQuickLook {
    return .Color(color)
  }
}

let wallPaint = Paint(viscosity: 0.9, color: NSColor(red: 0.2, green: 1.0, blue: 0.5, alpha: 1.0))

/*:
`Image` example. I've included a test image in the resources for this playground.
*/
struct ImageExample: CustomPlaygroundQuickLookable {
  var name: String
  func customPlaygroundQuickLook() -> PlaygroundQuickLook {
    if let image = NSImage(named: name) {
      return .Image(image)
    } else {
      return .Text("Image unavailable :(")
    }
  }
}

let imageExample = ImageExample(name: "swift")

/*:
`BezierPath` example.
*/
struct BezierExample: CustomPlaygroundQuickLookable {
  var radius: CGFloat

  func customPlaygroundQuickLook() -> PlaygroundQuickLook {
    return .BezierPath(NSBezierPath(roundedRect: NSRect(x: 0, y: 0, width: 100, height: 100), xRadius: radius, yRadius: radius))
  }
}

let bezierExample = BezierExample(radius: 8)

/*:
`Rectangle` example.

As the docs state, the associated values are explicit numbers to avoid having to wrap a `CGRect`.
*/
struct RectExample: CustomPlaygroundQuickLookable {
  var ratio: Double

  func customPlaygroundQuickLook() -> PlaygroundQuickLook {
    let sideLength: Double = 1000
    // x, y, width, height.
    return .Rectangle(0, 0, sideLength * ratio, sideLength)
  }
}

let rectExample = RectExample(ratio: 1.618)

/*:
`Size` example.
*/
struct SizeExample: CustomPlaygroundQuickLookable {
  var ratio: Double

  func customPlaygroundQuickLook() -> PlaygroundQuickLook {
    let sideLength: Double = 1000
    // width, height.
    return .Size(sideLength * ratio, sideLength)
  }
}

let sizeExample = SizeExample(ratio: 1.618)

/*:
`Point` example
*/
struct PointExample: CustomPlaygroundQuickLookable {
  var x: Double
  var y: Double

  func customPlaygroundQuickLook() -> PlaygroundQuickLook {
    // x, y
    return .Point(x, y)
  }
}

let pointExample = PointExample(x: 36.5, y: 42)

/*:
`View` example. The struct only holds a background and foreground color; to show this, the private `RenderView` class draws a background field with a square in the foreground as the custom quick look view.
*/
struct TestView: CustomPlaygroundQuickLookable {
  var backgroundColor: NSColor
  var foregroundColor: NSColor

  private class RenderView: NSView {
    var backgroundColor: NSColor = NSColor.whiteColor()
    var foregroundColor: NSColor = NSColor.blackColor()

    private override func drawRect(dirtyRect: NSRect) {
      backgroundColor.set()
      NSRectFill(bounds)

      foregroundColor.set()
      NSRectFill(NSInsetRect(bounds, bounds.size.width * 0.25, bounds.size.height * 0.25))
    }
  }

  func customPlaygroundQuickLook() -> PlaygroundQuickLook {
    let size: CGFloat = 100

    let view = RenderView(frame: NSRect(x: 0, y: 0, width: size, height: size))
    view.backgroundColor = backgroundColor
    view.foregroundColor = foregroundColor

    return .View(view)
  }
}

let testView = TestView(backgroundColor: NSColor.greenColor(), foregroundColor: NSColor.whiteColor())

/*:
The following two don't seem to render property. :(

`URL` example.
*/
struct URLExample: CustomPlaygroundQuickLookable {
  var url: NSURL

  func customPlaygroundQuickLook() -> PlaygroundQuickLook {
    return .URL(url.absoluteString)
  }
}

let urlExample = URLExample(url: NSURL(string: "http://swiftunboxed.com")!)

/*:
`Range` example.
*/
struct RangeExample: CustomPlaygroundQuickLookable {
  var start: UInt
  var length: UInt

  func customPlaygroundQuickLook() -> PlaygroundQuickLook {
    // start, length
    return .Range(UInt64(start), UInt64(length))
  }
}

let rangeExample = RangeExample(start: 10, length: 36)

/*:
These final two give quick look errors in the sidebar. I assume this is because it's not receiving the correct type, but I'm not sure what type it's expecting!

`Sprite` example. Using the same .png file as with the image example, but this time loaded in as a Sprite Kit sprite. Works when you pass an `NSImage` object but then I'm unsure what the difference is between `Image` and `Sprite`!
*/
struct SpriteExample: CustomPlaygroundQuickLookable {
  var name: String

  func customPlaygroundQuickLook() -> PlaygroundQuickLook {
    let node = SKSpriteNode(imageNamed: name)
    return .Sprite(node)
  }
}

let spriteExample = SpriteExample(name: "swift")

/*:
`Sound` example. I've included a test audio file in the resources for this playground.

I tried the system sound C API, `NSSound`, `AVAudioPlayer`, and `ExtAudioFileOpenURL` with no luck. If you figure it out, please let me know!
*/
struct SoundExample: CustomPlaygroundQuickLookable {
  var name: String

  func customPlaygroundQuickLook() -> PlaygroundQuickLook {
    if let path = NSBundle.mainBundle().pathForResource(name, ofType: "caf"), sound = NSSound(contentsOfFile: path, byReference: true) {
      return .Sound(sound)
    } else {
      return .Text("Sound unavailable :(")
    }
  }
}

let soundExample = SoundExample(name: "developers")
