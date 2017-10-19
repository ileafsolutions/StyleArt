# StyleArt
Style Art is a library that process images using COREML with a set of pre trained machine learning models and convert them to Art style.

<img src="./Asset/art.png?raw=true">

## Preview
<img src="./Asset/preview.png?raw=true">

## Installation

### Compatibility

-  iOS 11.0+ 

- Xcode 9.0+, Swift 4+

#### Manual installation
Download and drop the 'StyleArt' folder into your Xcode project. 

## Usage

```swift
 StyleArt.shared.process(image: imageView.image, style: .Candy) { (result) in
            
  }
```
#### Sytles Available
```swift
enum ArtStyle{
    
    case Mosaic
    case scream
    case Muse
    case Udanie
    case Candy
    case Feathers
}
```
More usage info can found on the example project.

## Author
iLeaf Solutions
 [http://www.ileafsolutions.com](http://www.ileafsolutions.com)