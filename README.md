# Rumpelstiltskin

[![Version](https://img.shields.io/cocoapods/v/Rumpelstiltskin.svg?style=flat)](https://cocoapods.org/pods/Rumpelstiltskin)
[![Platform](https://img.shields.io/cocoapods/p/Rumpelstiltskin.svg?style=flat)](https://cocoapods.org/pods/Rumpelstiltskin)

<div align="center"><img src="https://github.com/kurzdigital/Rumpelstiltskin/blob/master/Logo.png" width="150"/></div>

Rumpelstiltskin will turn your localization file looking like this:

```
"Accessibility.Example1" = "Accessibility";
"Accessibility.ThumbnailImage" = "Thumbnail %d with name %@";
```

Into a swift struct looking like this:
```swift
struct Localizations {
    struct Accessibility {

        /// Base translation: Accessibility
        public static let Example1 = NSLocalizedString("Accessibility.Example1", tableName: nil, bundle: Bundle.main, value: "", comment: "")

        /// Base translation: Thumbnail %d with name %@
        public static func ThumbnailImage(value1: Int, _ value2: String) -> String {
            return String(format: NSLocalizedString("Accessibility.ThumbnailImage", tableName: nil, bundle: Bundle.main, value: "", comment: "")
            , value1, value2)
        }
    }
}
```
It is built to be a drop in replacement for the [Laurine - Storyboard Generator Script](https://github.com/JiriTrecak/Laurine) which unfortunately stopped being maintained in 2017.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
* Swift 5.*

## Setup

Create a new run script phase whithin your Xcode project build phases.

```
echo "Rumpelstiltskin begins to dance around fire"
# Get base path to project
BASE_PATH="$PROJECT_DIR/$PROJECT_NAME"

# Get path to Generator script
GENERATOR_PATH="${PODS_ROOT}/Rumpelstiltskin/main.swift"

# Get path to main localization file (usually english).
SOURCE_PATH="$BASE_PATH/Supporting Files/Base.lproj/Localizable.strings"

OUTPUT_PATH="$BASE_PATH/Utils/Localizations.swift"

# Add permission to generator for script execution
chmod 755 "$GENERATOR_PATH"

# Will only re-generate script if something changed
if [ ! -f "$OUTPUT_PATH" ] || [ "$SOURCE_PATH" -nt "$OUTPUT_PATH" ]; then
    # Create the Localizations.swift-file if it doesn't exist yet
    if [ ! -f "$OUTPUT_PATH" ]; then
        touch "$OUTPUT_PATH"
    fi
    "$GENERATOR_PATH" "$SOURCE_PATH" "$OUTPUT_PATH"
    echo "Regenerated strings structure"
fi
```

You may have to change `SOURCE_PATH` and `OUTPUT_PATH` to your needs.

If you run Rumpelstiltskin for the first time you will have to add the newly generated `Localizations.swift` to your 
project. From then on the file will be updated automatically whenever the `Localizable.strings` file is changed.

## Usage
We assume that you already have a `Localizable.strings` file in place.

### Generate nested structures by seperating them with a `.`

```
# Localizable.strings
"MainStructure.NestedStructure.ConcreteValue" = "This needs to be localized";
```

```swift
// Code
label.text = Localizations.MainStructure.NestedStructure.ConcreteValue
```

### Use functions to build strings. (Currently supported are Int, Float and String)
```
// %@: String, %d: Int, %f: float 
"Buttons.TextWithVariables" = "Awesome %@, press me %d times!";
```

```swift
// Code
label.text = Localizations.Buttons.TextWithVariables(value1: "App", value2: 10)
```

### Currently not supported
* Multiline strings: Please use `\n` to format your strings within your `Localizable.strings` file


## Installation

Rumpelstiltskin is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Rumpelstiltskin'
```

## Author

Christian Braun

## License

Rumpelstiltskin is available under the MIT license. See the LICENSE file for more info.
