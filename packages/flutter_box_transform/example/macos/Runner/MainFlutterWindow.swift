import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    if #available(macOS 10.13, *) {
        // set defult tool bar for better spacing.
        self.toolbar = NSToolbar()
        self.toolbar?.displayMode = NSToolbar.DisplayMode.iconOnly
        // self.toolbar?.isVisible = false

        var localStyle = self.styleMask;
        localStyle.insert(.fullSizeContentView)
        self.styleMask = localStyle;
        self.titlebarAppearsTransparent = true
        self.titleVisibility = .hidden
        self.isOpaque = false
        self.isMovable = true
        self.setIsZoomed(true)

        // Disable full screen button.
        // let button = self.standardWindowButton(NSWindow.ButtonType.zoomButton)
        // button?.isEnabled = false

    }

    super.awakeFromNib()
  }
}
