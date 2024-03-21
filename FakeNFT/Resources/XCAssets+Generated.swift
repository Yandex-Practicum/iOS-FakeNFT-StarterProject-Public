// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let accentColor = ColorAsset(name: "AccentColor")
  internal enum Colors {
    internal enum Universal {
      internal static let ypUniBG = ColorAsset(name: "ypUniBG")
      internal static let ypUniBlack = ColorAsset(name: "ypUniBlack")
      internal static let ypUniBlue = ColorAsset(name: "ypUniBlue")
      internal static let ypUniGray = ColorAsset(name: "ypUniGray")
      internal static let ypUniGreen = ColorAsset(name: "ypUniGreen")
      internal static let ypUniRed = ColorAsset(name: "ypUniRed")
      internal static let ypUniWhite = ColorAsset(name: "ypUniWhite")
      internal static let ypUniYellow = ColorAsset(name: "ypUniYellow")
    }
    internal static let ypBlack = ColorAsset(name: "ypBlack")
    internal static let ypLightGray = ColorAsset(name: "ypLightGray")
    internal static let ypWhite = ColorAsset(name: "ypWhite")
  }
  internal enum MockImages {
    internal enum Beige {
      internal enum April {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Aurora {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Bimbo {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Biscuit {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Breena {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Buster {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Corbin {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Cupid {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Dingo {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Ellsa {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Finn {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Gus {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Lark {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Lucky {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Melvin {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Nala {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Penny {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Ralph {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Salena {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Simba {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Whisper {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
    }
    internal enum Blue {
      internal enum Bonnie {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Clover {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Diana {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Loki {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Ollie {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
    }
    internal enum Brown {
      internal enum Bitsy {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Charlie {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Emma {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Iggy {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Rosie {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Stella {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Toast {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Zeus {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
    }
    internal enum CollectionCovers {
      internal static let beige = ImageAsset(name: "Beige")
      internal static let blue = ImageAsset(name: "Blue")
      internal static let brown = ImageAsset(name: "Brown")
      internal static let gray = ImageAsset(name: "Gray")
      internal static let green = ImageAsset(name: "Green")
      internal static let peach = ImageAsset(name: "Peach")
      internal static let pink = ImageAsset(name: "Pink")
      internal static let white = ImageAsset(name: "White")
      internal static let yellow = ImageAsset(name: "Yellow")
    }
    internal enum Gray {
      internal enum Arlena {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Bethany {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Big {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Butter {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Chip {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Devin {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Dominique {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Elliot {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Flash {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Grace {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Josie {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Kaydan {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Lanka {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Larson {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Lipton {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Piper {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Rocky {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Tucker {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Zac {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
    }
    internal enum Green {
      internal enum Gwen {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Lina {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Melissa {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Spring {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
    }
    internal enum Peach {
      internal enum Archie {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Art {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Biscuit {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Daisy {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Nacho {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Oreo {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Pixi {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Ruby {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Susan {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Tater {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Zoe {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
    }
    internal enum Pink {
      internal enum Ariana {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Calder {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Cashew {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Charity {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Flower {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Jerry {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Lilo {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Lucy {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Milo {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Moose {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Oscar {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Patton {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Rufus {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Salena {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
    }
    internal enum White {
      internal enum Arielle {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Barney {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Iron {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Logan {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Lumpy {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Paddy {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Vulcan {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
    }
    internal enum Yellow {
      internal enum Florine {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Helga {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Luna {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Mowgli {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Olaf {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Pumpkin {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Willow {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
      internal enum Winnie {
        internal static let _1 = ImageAsset(name: "1")
        internal static let _2 = ImageAsset(name: "2")
        internal static let _3 = ImageAsset(name: "3")
      }
    }
  }
  internal static let close = ImageAsset(name: "close")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
