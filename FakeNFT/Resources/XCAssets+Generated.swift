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
  internal enum CatalogImages {
    internal static let filterIcon = ImageAsset(name: "filterIcon")
  }
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
        internal static let _1 = ImageAsset(name: "Beige/April/1")
        internal static let _2 = ImageAsset(name: "Beige/April/2")
        internal static let _3 = ImageAsset(name: "Beige/April/3")
      }
      internal enum Aurora {
        internal static let _1 = ImageAsset(name: "Beige/Aurora/1")
        internal static let _2 = ImageAsset(name: "Beige/Aurora/2")
        internal static let _3 = ImageAsset(name: "Beige/Aurora/3")
      }
      internal enum Bimbo {
        internal static let _1 = ImageAsset(name: "Beige/Bimbo/1")
        internal static let _2 = ImageAsset(name: "Beige/Bimbo/2")
        internal static let _3 = ImageAsset(name: "Beige/Bimbo/3")
      }
      internal enum Biscuit {
        internal static let _1 = ImageAsset(name: "Beige/Biscuit/1")
        internal static let _2 = ImageAsset(name: "Beige/Biscuit/2")
        internal static let _3 = ImageAsset(name: "Beige/Biscuit/3")
      }
      internal enum Breena {
        internal static let _1 = ImageAsset(name: "Beige/Breena/1")
        internal static let _2 = ImageAsset(name: "Beige/Breena/2")
        internal static let _3 = ImageAsset(name: "Beige/Breena/3")
      }
      internal enum Buster {
        internal static let _1 = ImageAsset(name: "Beige/Buster/1")
        internal static let _2 = ImageAsset(name: "Beige/Buster/2")
        internal static let _3 = ImageAsset(name: "Beige/Buster/3")
      }
      internal enum Corbin {
        internal static let _1 = ImageAsset(name: "Beige/Corbin/1")
        internal static let _2 = ImageAsset(name: "Beige/Corbin/2")
        internal static let _3 = ImageAsset(name: "Beige/Corbin/3")
      }
      internal enum Cupid {
        internal static let _1 = ImageAsset(name: "Beige/Cupid/1")
        internal static let _2 = ImageAsset(name: "Beige/Cupid/2")
        internal static let _3 = ImageAsset(name: "Beige/Cupid/3")
      }
      internal enum Dingo {
        internal static let _1 = ImageAsset(name: "Beige/Dingo/1")
        internal static let _2 = ImageAsset(name: "Beige/Dingo/2")
        internal static let _3 = ImageAsset(name: "Beige/Dingo/3")
      }
      internal enum Ellsa {
        internal static let _1 = ImageAsset(name: "Beige/Ellsa/1")
        internal static let _2 = ImageAsset(name: "Beige/Ellsa/2")
        internal static let _3 = ImageAsset(name: "Beige/Ellsa/3")
      }
      internal enum Finn {
        internal static let _1 = ImageAsset(name: "Beige/Finn/1")
        internal static let _2 = ImageAsset(name: "Beige/Finn/2")
        internal static let _3 = ImageAsset(name: "Beige/Finn/3")
      }
      internal enum Gus {
        internal static let _1 = ImageAsset(name: "Beige/Gus/1")
        internal static let _2 = ImageAsset(name: "Beige/Gus/2")
        internal static let _3 = ImageAsset(name: "Beige/Gus/3")
      }
      internal enum Lark {
        internal static let _1 = ImageAsset(name: "Beige/Lark/1")
        internal static let _2 = ImageAsset(name: "Beige/Lark/2")
        internal static let _3 = ImageAsset(name: "Beige/Lark/3")
      }
      internal enum Lucky {
        internal static let _1 = ImageAsset(name: "Beige/Lucky/1")
        internal static let _2 = ImageAsset(name: "Beige/Lucky/2")
        internal static let _3 = ImageAsset(name: "Beige/Lucky/3")
      }
      internal enum Melvin {
        internal static let _1 = ImageAsset(name: "Beige/Melvin/1")
        internal static let _2 = ImageAsset(name: "Beige/Melvin/2")
        internal static let _3 = ImageAsset(name: "Beige/Melvin/3")
      }
      internal enum Nala {
        internal static let _1 = ImageAsset(name: "Beige/Nala/1")
        internal static let _2 = ImageAsset(name: "Beige/Nala/2")
        internal static let _3 = ImageAsset(name: "Beige/Nala/3")
      }
      internal enum Penny {
        internal static let _1 = ImageAsset(name: "Beige/Penny/1")
        internal static let _2 = ImageAsset(name: "Beige/Penny/2")
        internal static let _3 = ImageAsset(name: "Beige/Penny/3")
      }
      internal enum Ralph {
        internal static let _1 = ImageAsset(name: "Beige/Ralph/1")
        internal static let _2 = ImageAsset(name: "Beige/Ralph/2")
        internal static let _3 = ImageAsset(name: "Beige/Ralph/3")
      }
      internal enum Salena {
        internal static let _1 = ImageAsset(name: "Beige/Salena/1")
        internal static let _2 = ImageAsset(name: "Beige/Salena/2")
        internal static let _3 = ImageAsset(name: "Beige/Salena/3")
      }
      internal enum Simba {
        internal static let _1 = ImageAsset(name: "Beige/Simba/1")
        internal static let _2 = ImageAsset(name: "Beige/Simba/2")
        internal static let _3 = ImageAsset(name: "Beige/Simba/3")
      }
      internal enum Whisper {
        internal static let _1 = ImageAsset(name: "Beige/Whisper/1")
        internal static let _2 = ImageAsset(name: "Beige/Whisper/2")
        internal static let _3 = ImageAsset(name: "Beige/Whisper/3")
      }
    }
    internal enum Blue {
      internal enum Bonnie {
        internal static let _1 = ImageAsset(name: "Blue/Bonnie/1")
        internal static let _2 = ImageAsset(name: "Blue/Bonnie/2")
        internal static let _3 = ImageAsset(name: "Blue/Bonnie/3")
      }
      internal enum Clover {
        internal static let _1 = ImageAsset(name: "Blue/Clover/1")
        internal static let _2 = ImageAsset(name: "Blue/Clover/2")
        internal static let _3 = ImageAsset(name: "Blue/Clover/3")
      }
      internal enum Diana {
        internal static let _1 = ImageAsset(name: "Blue/Diana/1")
        internal static let _2 = ImageAsset(name: "Blue/Diana/2")
        internal static let _3 = ImageAsset(name: "Blue/Diana/3")
      }
      internal enum Loki {
        internal static let _1 = ImageAsset(name: "Blue/Loki/1")
        internal static let _2 = ImageAsset(name: "Blue/Loki/2")
        internal static let _3 = ImageAsset(name: "Blue/Loki/3")
      }
      internal enum Ollie {
        internal static let _1 = ImageAsset(name: "Blue/Ollie/1")
        internal static let _2 = ImageAsset(name: "Blue/Ollie/2")
        internal static let _3 = ImageAsset(name: "Blue/Ollie/3")
      }
    }
    internal enum Brown {
      internal enum Bitsy {
        internal static let _1 = ImageAsset(name: "Brown/Bitsy/1")
        internal static let _2 = ImageAsset(name: "Brown/Bitsy/2")
        internal static let _3 = ImageAsset(name: "Brown/Bitsy/3")
      }
      internal enum Charlie {
        internal static let _1 = ImageAsset(name: "Brown/Charlie/1")
        internal static let _2 = ImageAsset(name: "Brown/Charlie/2")
        internal static let _3 = ImageAsset(name: "Brown/Charlie/3")
      }
      internal enum Emma {
        internal static let _1 = ImageAsset(name: "Brown/Emma/1")
        internal static let _2 = ImageAsset(name: "Brown/Emma/2")
        internal static let _3 = ImageAsset(name: "Brown/Emma/3")
      }
      internal enum Iggy {
        internal static let _1 = ImageAsset(name: "Brown/Iggy/1")
        internal static let _2 = ImageAsset(name: "Brown/Iggy/2")
        internal static let _3 = ImageAsset(name: "Brown/Iggy/3")
      }
      internal enum Rosie {
        internal static let _1 = ImageAsset(name: "Brown/Rosie/1")
        internal static let _2 = ImageAsset(name: "Brown/Rosie/2")
        internal static let _3 = ImageAsset(name: "Brown/Rosie/3")
      }
      internal enum Stella {
        internal static let _1 = ImageAsset(name: "Brown/Stella/1")
        internal static let _2 = ImageAsset(name: "Brown/Stella/2")
        internal static let _3 = ImageAsset(name: "Brown/Stella/3")
      }
      internal enum Toast {
        internal static let _1 = ImageAsset(name: "Brown/Toast/1")
        internal static let _2 = ImageAsset(name: "Brown/Toast/2")
        internal static let _3 = ImageAsset(name: "Brown/Toast/3")
      }
      internal enum Zeus {
        internal static let _1 = ImageAsset(name: "Brown/Zeus/1")
        internal static let _2 = ImageAsset(name: "Brown/Zeus/2")
        internal static let _3 = ImageAsset(name: "Brown/Zeus/3")
      }
    }
    internal enum CollectionCovers {
      internal static let beige = ImageAsset(name: "Collection covers/Beige")
      internal static let blue = ImageAsset(name: "Collection covers/Blue")
      internal static let brown = ImageAsset(name: "Collection covers/Brown")
      internal static let gray = ImageAsset(name: "Collection covers/Gray")
      internal static let green = ImageAsset(name: "Collection covers/Green")
      internal static let peach = ImageAsset(name: "Collection covers/Peach")
      internal static let pink = ImageAsset(name: "Collection covers/Pink")
      internal static let white = ImageAsset(name: "Collection covers/White")
      internal static let yellow = ImageAsset(name: "Collection covers/Yellow")
    }
    internal enum Gray {
      internal enum Arlena {
        internal static let _1 = ImageAsset(name: "Gray/Arlena/1")
        internal static let _2 = ImageAsset(name: "Gray/Arlena/2")
        internal static let _3 = ImageAsset(name: "Gray/Arlena/3")
      }
      internal enum Bethany {
        internal static let _1 = ImageAsset(name: "Gray/Bethany/1")
        internal static let _2 = ImageAsset(name: "Gray/Bethany/2")
        internal static let _3 = ImageAsset(name: "Gray/Bethany/3")
      }
      internal enum Big {
        internal static let _1 = ImageAsset(name: "Gray/Big/1")
        internal static let _2 = ImageAsset(name: "Gray/Big/2")
        internal static let _3 = ImageAsset(name: "Gray/Big/3")
      }
      internal enum Butter {
        internal static let _1 = ImageAsset(name: "Gray/Butter/1")
        internal static let _2 = ImageAsset(name: "Gray/Butter/2")
        internal static let _3 = ImageAsset(name: "Gray/Butter/3")
      }
      internal enum Chip {
        internal static let _1 = ImageAsset(name: "Gray/Chip/1")
        internal static let _2 = ImageAsset(name: "Gray/Chip/2")
        internal static let _3 = ImageAsset(name: "Gray/Chip/3")
      }
      internal enum Devin {
        internal static let _1 = ImageAsset(name: "Gray/Devin/1")
        internal static let _2 = ImageAsset(name: "Gray/Devin/2")
        internal static let _3 = ImageAsset(name: "Gray/Devin/3")
      }
      internal enum Dominique {
        internal static let _1 = ImageAsset(name: "Gray/Dominique/1")
        internal static let _2 = ImageAsset(name: "Gray/Dominique/2")
        internal static let _3 = ImageAsset(name: "Gray/Dominique/3")
      }
      internal enum Elliot {
        internal static let _1 = ImageAsset(name: "Gray/Elliot/1")
        internal static let _2 = ImageAsset(name: "Gray/Elliot/2")
        internal static let _3 = ImageAsset(name: "Gray/Elliot/3")
      }
      internal enum Flash {
        internal static let _1 = ImageAsset(name: "Gray/Flash/1")
        internal static let _2 = ImageAsset(name: "Gray/Flash/2")
        internal static let _3 = ImageAsset(name: "Gray/Flash/3")
      }
      internal enum Grace {
        internal static let _1 = ImageAsset(name: "Gray/Grace/1")
        internal static let _2 = ImageAsset(name: "Gray/Grace/2")
        internal static let _3 = ImageAsset(name: "Gray/Grace/3")
      }
      internal enum Josie {
        internal static let _1 = ImageAsset(name: "Gray/Josie/1")
        internal static let _2 = ImageAsset(name: "Gray/Josie/2")
        internal static let _3 = ImageAsset(name: "Gray/Josie/3")
      }
      internal enum Kaydan {
        internal static let _1 = ImageAsset(name: "Gray/Kaydan/1")
        internal static let _2 = ImageAsset(name: "Gray/Kaydan/2")
        internal static let _3 = ImageAsset(name: "Gray/Kaydan/3")
      }
      internal enum Lanka {
        internal static let _1 = ImageAsset(name: "Gray/Lanka/1")
        internal static let _2 = ImageAsset(name: "Gray/Lanka/2")
        internal static let _3 = ImageAsset(name: "Gray/Lanka/3")
      }
      internal enum Larson {
        internal static let _1 = ImageAsset(name: "Gray/Larson/1")
        internal static let _2 = ImageAsset(name: "Gray/Larson/2")
        internal static let _3 = ImageAsset(name: "Gray/Larson/3")
      }
      internal enum Lipton {
        internal static let _1 = ImageAsset(name: "Gray/Lipton/1")
        internal static let _2 = ImageAsset(name: "Gray/Lipton/2")
        internal static let _3 = ImageAsset(name: "Gray/Lipton/3")
      }
      internal enum Piper {
        internal static let _1 = ImageAsset(name: "Gray/Piper/1")
        internal static let _2 = ImageAsset(name: "Gray/Piper/2")
        internal static let _3 = ImageAsset(name: "Gray/Piper/3")
      }
      internal enum Rocky {
        internal static let _1 = ImageAsset(name: "Gray/Rocky/1")
        internal static let _2 = ImageAsset(name: "Gray/Rocky/2")
        internal static let _3 = ImageAsset(name: "Gray/Rocky/3")
      }
      internal enum Tucker {
        internal static let _1 = ImageAsset(name: "Gray/Tucker/1")
        internal static let _2 = ImageAsset(name: "Gray/Tucker/2")
        internal static let _3 = ImageAsset(name: "Gray/Tucker/3")
      }
      internal enum Zac {
        internal static let _1 = ImageAsset(name: "Gray/Zac/1")
        internal static let _2 = ImageAsset(name: "Gray/Zac/2")
        internal static let _3 = ImageAsset(name: "Gray/Zac/3")
      }
    }
    internal enum Green {
      internal enum Gwen {
        internal static let _1 = ImageAsset(name: "Green/Gwen/1")
        internal static let _2 = ImageAsset(name: "Green/Gwen/2")
        internal static let _3 = ImageAsset(name: "Green/Gwen/3")
      }
      internal enum Lina {
        internal static let _1 = ImageAsset(name: "Green/Lina/1")
        internal static let _2 = ImageAsset(name: "Green/Lina/2")
        internal static let _3 = ImageAsset(name: "Green/Lina/3")
      }
      internal enum Melissa {
        internal static let _1 = ImageAsset(name: "Green/Melissa/1")
        internal static let _2 = ImageAsset(name: "Green/Melissa/2")
        internal static let _3 = ImageAsset(name: "Green/Melissa/3")
      }
      internal enum Spring {
        internal static let _1 = ImageAsset(name: "Green/Spring/1")
        internal static let _2 = ImageAsset(name: "Green/Spring/2")
        internal static let _3 = ImageAsset(name: "Green/Spring/3")
      }
    }
    internal enum Peach {
      internal enum Archie {
        internal static let _1 = ImageAsset(name: "Peach/Archie/1")
        internal static let _2 = ImageAsset(name: "Peach/Archie/2")
        internal static let _3 = ImageAsset(name: "Peach/Archie/3")
      }
      internal enum Art {
        internal static let _1 = ImageAsset(name: "Peach/Art/1")
        internal static let _2 = ImageAsset(name: "Peach/Art/2")
        internal static let _3 = ImageAsset(name: "Peach/Art/3")
      }
      internal enum Biscuit {
        internal static let _1 = ImageAsset(name: "Peach/Biscuit/1")
        internal static let _2 = ImageAsset(name: "Peach/Biscuit/2")
        internal static let _3 = ImageAsset(name: "Peach/Biscuit/3")
      }
      internal enum Daisy {
        internal static let _1 = ImageAsset(name: "Peach/Daisy/1")
        internal static let _2 = ImageAsset(name: "Peach/Daisy/2")
        internal static let _3 = ImageAsset(name: "Peach/Daisy/3")
      }
      internal enum Nacho {
        internal static let _1 = ImageAsset(name: "Peach/Nacho/1")
        internal static let _2 = ImageAsset(name: "Peach/Nacho/2")
        internal static let _3 = ImageAsset(name: "Peach/Nacho/3")
      }
      internal enum Oreo {
        internal static let _1 = ImageAsset(name: "Peach/Oreo/1")
        internal static let _2 = ImageAsset(name: "Peach/Oreo/2")
        internal static let _3 = ImageAsset(name: "Peach/Oreo/3")
      }
      internal enum Pixi {
        internal static let _1 = ImageAsset(name: "Peach/Pixi/1")
        internal static let _2 = ImageAsset(name: "Peach/Pixi/2")
        internal static let _3 = ImageAsset(name: "Peach/Pixi/3")
      }
      internal enum Ruby {
        internal static let _1 = ImageAsset(name: "Peach/Ruby/1")
        internal static let _2 = ImageAsset(name: "Peach/Ruby/2")
        internal static let _3 = ImageAsset(name: "Peach/Ruby/3")
      }
      internal enum Susan {
        internal static let _1 = ImageAsset(name: "Peach/Susan/1")
        internal static let _2 = ImageAsset(name: "Peach/Susan/2")
        internal static let _3 = ImageAsset(name: "Peach/Susan/3")
      }
      internal enum Tater {
        internal static let _1 = ImageAsset(name: "Peach/Tater/1")
        internal static let _2 = ImageAsset(name: "Peach/Tater/2")
        internal static let _3 = ImageAsset(name: "Peach/Tater/3")
      }
      internal enum Zoe {
        internal static let _1 = ImageAsset(name: "Peach/Zoe/1")
        internal static let _2 = ImageAsset(name: "Peach/Zoe/2")
        internal static let _3 = ImageAsset(name: "Peach/Zoe/3")
      }
    }
    internal enum Pink {
      internal enum Ariana {
        internal static let _1 = ImageAsset(name: "Pink/Ariana/1")
        internal static let _2 = ImageAsset(name: "Pink/Ariana/2")
        internal static let _3 = ImageAsset(name: "Pink/Ariana/3")
      }
      internal enum Calder {
        internal static let _1 = ImageAsset(name: "Pink/Calder/1")
        internal static let _2 = ImageAsset(name: "Pink/Calder/2")
        internal static let _3 = ImageAsset(name: "Pink/Calder/3")
      }
      internal enum Cashew {
        internal static let _1 = ImageAsset(name: "Pink/Cashew/1")
        internal static let _2 = ImageAsset(name: "Pink/Cashew/2")
        internal static let _3 = ImageAsset(name: "Pink/Cashew/3")
      }
      internal enum Charity {
        internal static let _1 = ImageAsset(name: "Pink/Charity/1")
        internal static let _2 = ImageAsset(name: "Pink/Charity/2")
        internal static let _3 = ImageAsset(name: "Pink/Charity/3")
      }
      internal enum Flower {
        internal static let _1 = ImageAsset(name: "Pink/Flower/1")
        internal static let _2 = ImageAsset(name: "Pink/Flower/2")
        internal static let _3 = ImageAsset(name: "Pink/Flower/3")
      }
      internal enum Jerry {
        internal static let _1 = ImageAsset(name: "Pink/Jerry/1")
        internal static let _2 = ImageAsset(name: "Pink/Jerry/2")
        internal static let _3 = ImageAsset(name: "Pink/Jerry/3")
      }
      internal enum Lilo {
        internal static let _1 = ImageAsset(name: "Pink/Lilo/1")
        internal static let _2 = ImageAsset(name: "Pink/Lilo/2")
        internal static let _3 = ImageAsset(name: "Pink/Lilo/3")
      }
      internal enum Lucy {
        internal static let _1 = ImageAsset(name: "Pink/Lucy/1")
        internal static let _2 = ImageAsset(name: "Pink/Lucy/2")
        internal static let _3 = ImageAsset(name: "Pink/Lucy/3")
      }
      internal enum Milo {
        internal static let _1 = ImageAsset(name: "Pink/Milo/1")
        internal static let _2 = ImageAsset(name: "Pink/Milo/2")
        internal static let _3 = ImageAsset(name: "Pink/Milo/3")
      }
      internal enum Moose {
        internal static let _1 = ImageAsset(name: "Pink/Moose/1")
        internal static let _2 = ImageAsset(name: "Pink/Moose/2")
        internal static let _3 = ImageAsset(name: "Pink/Moose/3")
      }
      internal enum Oscar {
        internal static let _1 = ImageAsset(name: "Pink/Oscar/1")
        internal static let _2 = ImageAsset(name: "Pink/Oscar/2")
        internal static let _3 = ImageAsset(name: "Pink/Oscar/3")
      }
      internal enum Patton {
        internal static let _1 = ImageAsset(name: "Pink/Patton/1")
        internal static let _2 = ImageAsset(name: "Pink/Patton/2")
        internal static let _3 = ImageAsset(name: "Pink/Patton/3")
      }
      internal enum Rufus {
        internal static let _1 = ImageAsset(name: "Pink/Rufus/1")
        internal static let _2 = ImageAsset(name: "Pink/Rufus/2")
        internal static let _3 = ImageAsset(name: "Pink/Rufus/3")
      }
      internal enum Salena {
        internal static let _1 = ImageAsset(name: "Pink/Salena/1")
        internal static let _2 = ImageAsset(name: "Pink/Salena/2")
        internal static let _3 = ImageAsset(name: "Pink/Salena/3")
      }
    }
    internal enum White {
      internal enum Arielle {
        internal static let _1 = ImageAsset(name: "White/Arielle/1")
        internal static let _2 = ImageAsset(name: "White/Arielle/2")
        internal static let _3 = ImageAsset(name: "White/Arielle/3")
      }
      internal enum Barney {
        internal static let _1 = ImageAsset(name: "White/Barney/1")
        internal static let _2 = ImageAsset(name: "White/Barney/2")
        internal static let _3 = ImageAsset(name: "White/Barney/3")
      }
      internal enum Iron {
        internal static let _1 = ImageAsset(name: "White/Iron/1")
        internal static let _2 = ImageAsset(name: "White/Iron/2")
        internal static let _3 = ImageAsset(name: "White/Iron/3")
      }
      internal enum Logan {
        internal static let _1 = ImageAsset(name: "White/Logan/1")
        internal static let _2 = ImageAsset(name: "White/Logan/2")
        internal static let _3 = ImageAsset(name: "White/Logan/3")
      }
      internal enum Lumpy {
        internal static let _1 = ImageAsset(name: "White/Lumpy/1")
        internal static let _2 = ImageAsset(name: "White/Lumpy/2")
        internal static let _3 = ImageAsset(name: "White/Lumpy/3")
      }
      internal enum Paddy {
        internal static let _1 = ImageAsset(name: "White/Paddy/1")
        internal static let _2 = ImageAsset(name: "White/Paddy/2")
        internal static let _3 = ImageAsset(name: "White/Paddy/3")
      }
      internal enum Vulcan {
        internal static let _1 = ImageAsset(name: "White/Vulcan/1")
        internal static let _2 = ImageAsset(name: "White/Vulcan/2")
        internal static let _3 = ImageAsset(name: "White/Vulcan/3")
      }
    }
    internal enum Yellow {
      internal enum Florine {
        internal static let _1 = ImageAsset(name: "Yellow/Florine/1")
        internal static let _2 = ImageAsset(name: "Yellow/Florine/2")
        internal static let _3 = ImageAsset(name: "Yellow/Florine/3")
      }
      internal enum Helga {
        internal static let _1 = ImageAsset(name: "Yellow/Helga/1")
        internal static let _2 = ImageAsset(name: "Yellow/Helga/2")
        internal static let _3 = ImageAsset(name: "Yellow/Helga/3")
      }
      internal enum Luna {
        internal static let _1 = ImageAsset(name: "Yellow/Luna/1")
        internal static let _2 = ImageAsset(name: "Yellow/Luna/2")
        internal static let _3 = ImageAsset(name: "Yellow/Luna/3")
      }
      internal enum Mowgli {
        internal static let _1 = ImageAsset(name: "Yellow/Mowgli/1")
        internal static let _2 = ImageAsset(name: "Yellow/Mowgli/2")
        internal static let _3 = ImageAsset(name: "Yellow/Mowgli/3")
      }
      internal enum Olaf {
        internal static let _1 = ImageAsset(name: "Yellow/Olaf/1")
        internal static let _2 = ImageAsset(name: "Yellow/Olaf/2")
        internal static let _3 = ImageAsset(name: "Yellow/Olaf/3")
      }
      internal enum Pumpkin {
        internal static let _1 = ImageAsset(name: "Yellow/Pumpkin/1")
        internal static let _2 = ImageAsset(name: "Yellow/Pumpkin/2")
        internal static let _3 = ImageAsset(name: "Yellow/Pumpkin/3")
      }
      internal enum Willow {
        internal static let _1 = ImageAsset(name: "Yellow/Willow/1")
        internal static let _2 = ImageAsset(name: "Yellow/Willow/2")
        internal static let _3 = ImageAsset(name: "Yellow/Willow/3")
      }
      internal enum Winnie {
        internal static let _1 = ImageAsset(name: "Yellow/Winnie/1")
        internal static let _2 = ImageAsset(name: "Yellow/Winnie/2")
        internal static let _3 = ImageAsset(name: "Yellow/Winnie/3")
      }
    }
  }
  internal enum StartPages {
    internal static let ypLogo = ImageAsset(name: "YPLogo")
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
