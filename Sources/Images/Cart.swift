import UIKit
import Photos

public protocol CartDelegate: class {
  func cart(_ cart: Cart, didAdd image: ImageItem, newlyTaken: Bool)
  func cart(_ cart: Cart, didRemove image: ImageItem)
  func cartDidReload(_ cart: Cart)
}

/// Cart holds selected images and videos information
public class Cart {

  public var images: [ImageItem] = []
  public var video: Video?
  var delegates: NSHashTable<AnyObject> = NSHashTable.weakObjects()

  // MARK: - Initialization

  init() {

  }

  // MARK: - Delegate

  public func add(delegate: CartDelegate) {
    delegates.add(delegate)
  }

  // MARK: - Logic

  public func add(_ image: ImageItem, newlyTaken: Bool = false) {
    guard !images.contains(image) else { return }

    images.append(image)

    for case let delegate as CartDelegate in delegates.allObjects {
      delegate.cart(self, didAdd: image, newlyTaken: newlyTaken)
    }
  }

  public func remove(_ image: ImageItem) {
    guard let index = images.firstIndex(of: image) else { return }

    images.remove(at: index)

    for case let delegate as CartDelegate in delegates.allObjects {
      delegate.cart(self, didRemove: image)
    }
  }

  public func reload(_ images: [ImageItem]) {
    self.images = images

    for case let delegate as CartDelegate in delegates.allObjects {
      delegate.cartDidReload(self)
    }
  }

  // MARK: - Reset

  public func reset() {
    video = nil
    images.removeAll()
    delegates.removeAllObjects()
  }
}
