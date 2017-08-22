//
//  PurchaseFlowABTest.swift
//  ABTesting
//
//  Created by Raymond Law on 8/22/17.
//  Copyright © 2017 Clean Swift LLC. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {}

class PurchaseFlowABTest: NSObject
{
  var interactorA: VariationABusinessLogic?
  var interactorB: VariationBBusinessLogic?
  var router: HomeRoutingLogic?
  var dataStore: HomeDataStore?
  
  // MARK: Object lifecycle
  
  init(interactorA: VariationABusinessLogic?, interactorB: VariationBBusinessLogic?, router: (HomeRoutingLogic & HomeDataPassing)?)
  {
    self.router = router
    self.dataStore = router?.dataStore
    self.interactorA = interactorA
    self.interactorB = interactorB
  }
  
  // MARK: Pick a variation
  
  enum Variation
  {
    case A, B
    
    func viewController() -> String
    {
      switch self {
      case .A:
        return "A"
      case .B:
        return "B"
      }
    }
  }
  
  func pickVariation() -> Variation
  {
    switch random(2) {
    case 0:
      return Variation.A
    case 1:
      return Variation.B
    default:
      return Variation.A
    }
  }
  
  private func random(_ n: Int) -> Int
  {
    return Int(arc4random_uniform(UInt32(n)))
  }
  
  // MARK: Track conversions
  
  static var variationAViews = 0
  static var variationABuys = 0
  static var variationBViews = 0
  static var variationBBuys = 0
  
  func trackProductView(variation: Variation)
  {
    switch  variation {
    case .A:
      PurchaseFlowABTest.variationAViews += 1
    case .B:
      PurchaseFlowABTest.variationBViews += 1
    }
  }
  
  func trackProductBuy(variation: Variation)
  {
    switch  variation {
    case .A:
      PurchaseFlowABTest.variationABuys += 1
    case .B:
      PurchaseFlowABTest.variationBBuys += 1
    }
  }
}

extension PurchaseFlowABTest: HomeRoutingLogic, HomeDataPassing
{
  
  // MARK: Route to a variation
  
  func routeToProduct(segue: UIStoryboardSegue?)
  {
    let variation = pickVariation()
    switch variation {
    case .A:
      routeToVariationA(segue: segue)
    case .B:
      routeToVariationB(segue: segue)
    }
  }
  
  func routeToVariationA(segue: UIStoryboardSegue?)
  {
    trackProductView(variation: Variation.A)
    router?.routeToVariationA(segue: segue)
  }
  
  func routeToVariationB(segue: UIStoryboardSegue?)
  {
    trackProductView(variation: Variation.B)
    router?.routeToVariationB(segue: segue)
  }
}

extension PurchaseFlowABTest: VariationABusinessLogic
{
  func buy(request: VariationA.Buy.Request)
  {
    trackProductBuy(variation: Variation.A)
    interactorA?.buy(request: request)
  }
}

extension PurchaseFlowABTest: VariationBBusinessLogic
{
  func buy(request: VariationB.Buy.Request)
  {
    trackProductBuy(variation: Variation.B)
    interactorB?.buy(request: request)
  }
}
