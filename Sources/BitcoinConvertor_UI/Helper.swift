//
//  File.swift
//  
//
//  Created by nasrin niazi on 2023-02-27.
//

import Foundation
import Theme
import RxSwift
import UIKit

extension MessageDisplay {
    public class func displayMessageRetry(_ txtMessage: String, owner: UIViewController, isRetry : Bool = true, onlyRetry : Bool = false) -> Observable<Bool> {
         
         return Observable.create { observer in
             let alertController = UIAlertController(title: "", message: txtMessage, preferredStyle: UIAlertController.Style.alert)
             
             if(onlyRetry == false){
                 let okAction = UIAlertAction(title: Constants.alert_CloseBtn_Title, style: .default, handler: { action in
                     observer.onNext(false)
                     observer.onCompleted()
                 })
                 alertController.addAction(okAction)
             }
             
             if(isRetry == true){
                 let retryAction = UIAlertAction(title: Constants.alert_RetryBtn_Title, style: .default, handler: { action in
                     observer.onNext(true)
                     observer.onCompleted()
                 })
                 alertController.addAction(retryAction)
             }
             owner.present(alertController, animated: true, completion: nil)
             return Disposables.create { alertController.dismiss(animated: true, completion: nil) }
         }
     }

}
