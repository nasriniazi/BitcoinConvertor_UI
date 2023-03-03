//
//  File.swift
//  
//
//  Created by nasrin niazi on 2023-02-21.
//

import Foundation
import Coordinator
import UIKit
import ConvertorCore
import FeatureToggling

protocol ConvertorCoordinatorProtocol: CoordinatorProtocol {
    func showConvertorViewController(manager:FeatureToggleService)
}
public class ConvertorCoordinator: ConvertorCoordinatorProtocol {
   public var DI: [String : Any]?

   weak public var finishDelegate: CoordinatorFinishDelegate?

   public var navigationController: UINavigationController

   public var childCoordinators: [CoordinatorProtocol] = []
   
    public var type: CoordinatorType { .convertor }
    public var repositoryDI :CoinConvertorRepositoryProtocol!

   required public init(_ navigationController: UINavigationController) {
       self.navigationController = navigationController
   
   }
   public func start(){
       if let manager = DI?["manager"] as? FeatureToggleService{
       showConvertorViewController(manager: manager)
       }
   }
   
    func showConvertorViewController(manager:FeatureToggleService){
       let convertorVC: ConvertorViewController = ConvertorViewController.init(nibName: "ConvertorViewController", bundle: Bundle.module)
       let convertorViewModel = ConvertorViewModel(repository: self.repositoryDI,featureManager: manager)
       convertorVC.viewModel = convertorViewModel

       navigationController.pushViewController(convertorVC, animated: true)

   }
}
