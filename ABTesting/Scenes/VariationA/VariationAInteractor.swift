//
//  VariationAInteractor.swift
//  ABTesting
//
//  Created by Raymond Law on 8/22/17.
//  Copyright (c) 2017 Clean Swift LLC. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol VariationABusinessLogic
{
  func buy(request: VariationA.Buy.Request)
}

protocol VariationADataStore
{
}

class VariationAInteractor: VariationABusinessLogic, VariationADataStore
{
  var presenter: VariationAPresentationLogic?
  var worker: VariationAWorker?
  
  // MARK: Buy
  
  func buy(request: VariationA.Buy.Request)
  {
    let response = VariationA.Buy.Response()
    presenter?.formatReceipt(response: response)
  }
}
