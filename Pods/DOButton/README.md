# DOButton
[![CI Status](https://travis-ci.org/tbaranes/DOButton.svg)](https://travis-ci.org/tbaranes/DOButton)
![Language](https://img.shields.io/badge/language-Swift%203.0-orange.svg)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/DOButton.svg)](https://img.shields.io/cocoapods/v/DOButton.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/DOButton.svg?style=flat)](http://cocoadocs.org/docsets/DOButton)
[![License](https://img.shields.io/cocoapods/l/DOButton.svg?style=flat)](http://cocoapods.org/pods/DOButton)

**Note:** This project is a maintained clone of the original [DOFavoriteButton](https://github.com/okmr-d/DOFavoriteButton).

Cute Animated Button written in Swift.
It could be just right for favorite buttons!
![Demo](Assets/demo.gif)

## Requirements
* iOS 7.0+
* Swift 1.2

## Installation

#### CocoaPods
Add the following line to your `Podfile`:
```
pod 'DOButton'
```
#### Carthage
Add the following line to your `Cartfile`:
```
github "tbaranes/DOButton"
```

#### Manual
Just drag DOButton.swift to your project.

## How to use
#### 1. Add a flat icon image
![Flat Icon Image](Assets/flatIconImage.png)

#### 2. Create a button
##### ・By coding
```swift
let button = DOButton(frame: CGRectMake(0, 0, 44, 44), image: UIImage(named: "star.png"))
self.view.addSubview(button)
```

##### ・By using Storyboard or XIB
1. Add Button object and set Custom Class `DOButton`  
![via Storyboard](Assets/storyboard.png)

2. Connect Outlet  
![connect outlet](Assets/connect.png)

#### 3. Add tapped function
```swift
button.addTarget(self, action: Selector("tapped:"), forControlEvents: .TouchUpInside)
```
```swift
func tapped(sender: DOButton) {
    if sender.selected {
        // deselect
        sender.deselect()
    } else {
        // select with animation
        sender.select()
    }
}
```

## Customize
You can change button color & animation duration:
```swift
button.imageColorOff = UIColor.brownColor()
button.imageColorOn = UIColor.redColor()
button.circleColor = UIColor.greenColor()
button.lineColor = UIColor.blueColor()
button.duration = 3.0 // default: 1.0
```
Result:  
![Customize](Assets/changeColor.gif)

## DEMO
There is a demo project added to this repository, so you can see how it works.

## Credit/Inspiration
DOButton was inspired by [Twitter's iOS App](https://itunes.apple.com/us/app/twitter/id333903271).

## License
This software is released under the MIT License.
