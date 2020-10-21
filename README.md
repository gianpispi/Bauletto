![Bauletto](Assets/github.png)

<p align="center">
    <img src="https://img.shields.io/badge/Swift-5.1-orange.svg" />
    <img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage" />
    <a href="https://swift.org/package-manager">
        <img src="https://img.shields.io/badge/swiftpm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    </a>
     <img src="https://img.shields.io/badge/platforms-iOS-brightgreen.svg?style=flat" alt="iOS" />
    <a href="https://twitter.com/gianpispi">
        <img src="https://img.shields.io/badge/twitter-@gianpispi-blue.svg?style=flat" alt="Twitter: @gianpispi" />
    </a>
</p>

#### Lightweight iOS 13 badge like with ease.

## Preview
<p align="center">
	<img src="Assets/movie.gif" alt="Bauletto">
</p>

## Features
- Highly customizable ✅
- iPhone, iPhone X, & iPad Support ✅
- Orientation change support ✅
- Haptic feeback support ✅

## Requirements

 - iOS 10.0+
 - Xcode 10.0+

## Installation

### Carthage

In order to use Bauletto via Carthage simply add this line to your `Cartfile`:

#### Swift 5
```swift
github "gianpispi/Bauletto"
```
Then add `Bauletto.framework` in your project.

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding Bauletto as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
.package(url: "https://github.com/gianpispi/Bauletto.git", from: "1.0.6")
]
```


## Usage

Creating a Bauletto is simple as this:

```swift
let settings = BaulettoSettings(icon: UIImage(systemName: "checkmark.seal.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), title: "It works")
Bauletto.show(withSettings: settings)
```

If you want to change the tint color of the Bauletto, just use the `tintColor` value in the BaulettoSettings declaration as follows:

```swift
let settings = BaulettoSettings(icon: UIImage(systemName: "checkmark.seal.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), title: "It works", tintColor: .red)
Bauletto.show(withSettings: settings)
```

To change the background blur effect, add the `backgroundStyle`:

```swift
let settings = BaulettoSettings(icon: UIImage(systemName: "checkmark.seal.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), title: "It works", backgroundStyle: .dark)
Bauletto.show(withSettings: settings)
```

You can even change the dismissMode, which can be `.never`, `automatic` or `.custom(seconds: 2)`. By default it uses the automatic.

```swift
let settings = BaulettoSettings(icon: UIImage(systemName: "checkmark.seal.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), title: "It works", dismissMode: .never)
Bauletto.show(withSettings: settings)
```

You can also change the duration of the show animation. By default it uses 1.0 second.

```swift
let settings = BaulettoSettings(icon: UIImage(systemName: "checkmark.seal.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), title: "It works", dismissMode: .never, fadeInDuration: 2.0)
Bauletto.show(withSettings: settings)
```

Bauletto has a personal queue for the banners that will show up. When you show a banner you can select where in the queue it will be put. By default it is `.end`.

```swift
public enum QueuePosition {
	case beginning, end
}

Bauletto.show(withSettings: settings, queuePosition: .beginning)
```

When you want to show up a new message immediately, add it by using the `show()` function, and then use:
```swift
Bauletto.shared.forceShowNext()
```

Do you have a bunch of settings in the queue and you want to remove them? No problem.
```swift
Bauletto.shared.removeBannersInQueue()
```

## Haptic Feedback Support
You can also set a haptic feedback when the Bauletto shows up. By default, no haptic feedback will be generated. The types of haptic feedback are as follows:

```swift
public enum HapticStyle {
    case notificationError
    case notificationWarning
    case notificationSuccess
    
    case light
    case medium
    case heavy
    case none
    
    case soft
    case rigid
}
```

To change the style of haptic feedback, simply declare it in the BaulettoSettings initialization:

```swift
let settings = BaulettoSettings(icon: UIImage(systemName: "checkmark.seal.fill"), title: "It works", backgroundStyle: .systemChromeMaterial, dismissMode: .automatic, hapticStyle: .notificationSuccess)
```

## Feature Requests
I'd love to know improve Bauletto as much as I can. Feel free to open an issue and I'll do everything I can to accomodate that request if it is in the library's best interest. Or just create a pull request and I'll check it out. 

## Author
Gianpiero Spinelli, gianpiero@grspinelli.it

## License
Bauletto is available under the MIT license. See the LICENSE file for more info.
