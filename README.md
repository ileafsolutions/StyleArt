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
Ileaf Solutions
 [http://www.ileafsolutions.com](http://www.ileafsolutions.com)