# WandioCoreComponents

[![Version](https://img.shields.io/cocoapods/v/WandioCoreComponents.svg?style=flat)](https://cocoapods.org/pods/WandioCoreComponents)
[![License](https://img.shields.io/cocoapods/l/WandioCoreComponents.svg?style=flat)](https://cocoapods.org/pods/WandioCoreComponents)
[![Platform](https://img.shields.io/cocoapods/p/WandioCoreComponents.svg?style=flat)](https://cocoapods.org/pods/WandioCoreComponents)

Collection of custom UI Components.

*Create a shadowed view with corner radius on both the content and shadow*
* **RoundedShadowedView**
* **RoundedShadowedButton**
* **RoundedShadowedControl**
* **RoundedShadowedTextField**


![](https://github.com/kakhikiknadze26/KKUIComponents/blob/main/Images/shadowedButtonPreview.png?raw=true)

## Example

To run the example project, clone the repo and build WandioCoreComponentsExample target.

## Installation
WandioCoreComponents is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```
pod 'WandioCoreComponents'
```

## Usage

First of all import `WandioCoreComponents`
```Swift
import WandioCoreComponents
```

#### RoundedShadowedView
```Swift
let shadowedView = RoundedShadowedView(frame: CGRect(x: 40, y: 40, width: 200, height: 100))
shadowedView.backgroundLayerColor = .red
shadowedView.backgroundLayerLineWidth = 4
shadowedView.backgroundLayerStrokeColor = .yellow
shadowedView.shadowColor = .black
shadowedView.shadowAlpha = 0.7
shadowedView.shadowRadius = 24
shadowedView.cornerRadius = 20
shadowedView.shadowOffset = CGSize(width: 3, height: 8)
view.addSubview(shadowedView)
```
> Or set the values in storyboard\
> You can multiply those values by `screenFactor` to fit them on all devices. If so, you need to set the `screenFactor` first. E.g. when app finishes launching. Default value of screenFactor is 1.0.
* **RoundedShadowedButton, RoundedShadowedControl, RoundedShadowedTextField**\
Use same steps as for `RoundedShadowedView`.

#### CustomIntensityVisualEffectView

Visual Effect View with custom intensity value. You can initialize it as its parent UIVisualEffectView. Only difference is that you can provide intensity value for effect.

#### OTPView
You can initialize One Time Passcode View providing number of textfields you'd like and it handles all the switching between textfields, autofill, paste, returns current OTP string, notifies if all fields are filled and more.

You can also subclass ```OTPTextField``` and register your custom field:
```Swift
class CustomField: OTPTextField {
	// Create your custom textfield
}

class ViewController: UIViewController {
	
    let otpView = OTPView()
    
    override func viewDidLoad() {
    	super.viewDidLoad()
        otpView.register(CustomField.self)
    }
    
}
```
```OTPTextField``` is subclass of ```RoundedShadowedTextField``` so you can give it shadow with corner radius as well.

You can give textfields horizontal, vertical paddings and spacing between each other
```
otpView.spacing = 8
otpView.verticalPadding = 12
otpView.horizontalPadding = 20
```
```verticalPadding``` is divided by two and result is assigned to fields' ```y``` origin. So is ```horizontalPadding``` but its result is assigned to the first field's ```x``` origin. 

You can set ```delegate``` for ```OTPView``` and implement methods. They are called when delegate is set or by explicitly calling ```reload()``` on ```OTPView```
```
func otpView(_ view: OTPView, didChangeValidity isValid: Bool, otp: String) // is valid if all fields are filled
func otpView(_ view: OTPView, textField field: OTPTextField, at index: Int) // returns the field at corresponding index and you can make some special modifications there.
```

By calling ```remakeFields()``` explicitly, all of the current fields are removed and new are created using number of fields provided.

You can get current OTP string by calling ```getOTP()```, show/hide keyboard by calling ```showKeyboard()``` or ```hideKeyboard()```(show keyboard focuses on first field) and reset OTP string by calling ```reset()```

By calling ```func updateState(_ state: OTPTextFieldState)``` on ```OTPView``` you can trigger ```updateState``` on each field giving ```.normal``` or ```.error``` state.

#### OTPTextField
```OTPTextField``` has ```weak```references to ```previousTextField``` and ```nextTextField```.

It also has state ```OTPTextFieldState``` with cases ```.normal``` and ```.error```. You can change state by calling ```updateState(.error)``` for example and by default it will set stroke color to ```.red``` and make border's line width ```2``` but of course you can create your own UI logic by subclassing ```OTPTextField``` and overriding ```func updateState(_ state: OTPTextFieldState)``` method.

#### WandioBottomSheet

Expandable/Collapsable Bottom sheet consists of three main content: Background view, Handler area and content view. You can pan handle area or content view to expand, collapse or dismiss sheet. Tapping background also triggers dismiss.

You can subclass ```WandioBottomSheet```, make your own handler and content instances. You can use ```WandioBottomSheetHandlerView``` as your handler area or make your own custom view. Handler area can be ignored by not providing it and you can use only content view. 

```swift
class BottomSheetContent: UIView {
    
    let child = UIView()
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(child)
        child.backgroundColor = .clear
        child.translatesAutoresizingMaskIntoConstraints = false
        child.heightAnchor.constraint(equalToConstant: 360).isActive = true
        child.topAnchor.constraint(equalTo: topAnchor).isActive = true
        child.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        child.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        child.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.text = "Content"
        label.translatesAutoresizingMaskIntoConstraints = false
        child.addSubview(label)
        label.centerXAnchor.constraint(equalTo: child.centerXAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: child.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

class CustomBottomSheet: WandioBottomSheet {
    
    private let handler = WandioBottomSheetHandlerView()
    private let content = BottomSheetContent()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        contentHeight = 300 * screenFactor // setting contentHeight will fix content height by given value and ignore its original height
        addHandle(handler)
        addContent(content)
    }
    
}

class YourViewController: UIViewController {
  
  // Present bottom sheet by calling present on view controller or view itself

    @objc private func presentDefaultWandioBottomSheet() {
        DefaultWandioBottomSheet().present(on: self)
    }
    
    @objc private func presentCustomBottomSheet() {
        CustomBottomSheet().present(on: self)
    }
    
}
```

By setting bottom sheet's ```delegate``` you can implement these methods and add your own custom logic while pan is happening. e.g. add some extra animations on your view controller or elsewhere.

```swift
/// Tells the delegate that bottom sheet pan gesture began
func bottomSheet(_ sheet: WandioBottomSheet, didBeginPanGesture recognizer: UIPanGestureRecognizer)
/// Tells the delegate that bottom sheet pan gesture changed
func bottomSheet(_ sheet: WandioBottomSheet, didChangePanGesture recognizer: UIPanGestureRecognizer)
/// Tells the delegate that bottom sheet pan gesture ended
func bottomSheet(_ sheet: WandioBottomSheet, didEndPanGesture recognizer: UIPanGestureRecognizer)
```

You can override those methods called during pan gesture in your ```WandioBottomSheet``` subclass to customize behaviour.

```swift
open func beganPanGesture(_ recognizer: UIPanGestureRecognizer)

open func changedPanGesture(_ recognizer: UIPanGestureRecognizer)

open func endedPanGesture(_ recognizer: UIPanGestureRecognizer)
```

You can add content and handle area's subviews by calling

```Swift
func addContent(_ content: UIView, at index: Int? = nil)
func addHandle(_ handle: UIView, at index: Int? = nil)
```

#### ImageLoader

Download image from network or load it from cache. With simple extension on ```UIImageView``` you can load ```UIImage``` and set it.

```swift
let imageView = UIImageView()
let url = URL(string: "www.yourimageurl.com")!
imageView.setImage(from: url, placeholderImage: UIImage(named: "youtImage"), cachePolicy: .useProtocolCachePolicy, completion: nil)
```

#### LoaderView

```UIView``` subclass with ```isLoading``` property alongside ```start()``` and ```stop()``` methods that set ```isLoading``` to true or false. Subclass ```LoaderView``` and create your own custom loader. Override ```start``` and ```stop``` methods an trigger your own custom animations and stuff. Once your custom loader is done, you can assign it on ```LoaderView.shared``` and by simply calling ```startLoader()``` and ```stopLoader()``` either on your view controller or view will start or stop your custom loading animation. Alternatively, you can have your custom loader instance in your controller or view and send it as a parameter. e.g. ```startLoader(YourCustomLoader())``` 

Assuming you have your custom loader class

```swift
class MyLoader: LoaderView {
    
    let indicator = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.red.withAlphaComponent(0.5)
        addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        indicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    override func start() {
        super.start()
        indicator.startAnimating()
    }
    
    override func stop() {
        super.stop()
        indicator.stopAnimating()
    }
    
}
```

Set your loader as ```LoaderView.shared``` instance and calling loading methods without parameters will result presenting your custom loader

```swift
class ViewController: UIViewController {
  
    let loader = MyLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoaderView.shared = loader
    }

    @IBAction func buttonTap(_ sender: UIButton) {
        startLoader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.stopLoader()
        }
    }
    
}

```

Or if you want to present different kind of loader for some special cases you can have your loader instance stored in your class and send it as a parameter

```swift
class ViewController: UIViewController {
  
    let loader = MyLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoaderView.shared = loader
    }

    @IBAction func buttonTap(_ sender: UIButton) {
        startLoader(loader)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.stopLoader(loader)
        }
    }
    
}
```



## Author

Kakhi Kiknadze, kakhi.kiknadze@wandio.com

## License
WandioCoreComponents is available under the [MIT](https://choosealicense.com/licenses/mit/) license. See the LICENSE file for more info.
