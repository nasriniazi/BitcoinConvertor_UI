//
//  File.swift
//  
//
//  Created by nasrin niazi on 2023-02-21.
//

import Foundation
import ConvertorCore
import RxSwift
import RxCocoa
import FeatureToggling

public class ConvertorViewModel {
    var repository :CoinConvertorRepositoryProtocol
    private var featureManager: FeatureToggleService
    
    lazy var inputNumberStr:String = "0"{
        didSet{
            self.displayText.accept(inputNumberStr)
            setClear = false
        }
    }
    var setClear = true
    var displayText = BehaviorRelay<String?>(value: nil)
    var showEmptyView = BehaviorRelay<Bool>(value: false)
    let lastBitcoinUnitPrice = PublishSubject<Models.GetPrice?>()
    var convertError = PublishSubject<ServerError>()
    let disposeBag = DisposeBag()
    
    init(repository : CoinConvertorRepositoryProtocol,featureManager:FeatureToggleService){
        self.featureManager = featureManager
        self.repository = repository
        
    }
    func getFeatures(){
        if featureManager.isEnabled("Convertor") {
            self.showEmptyView.accept(false)
        }
        else{
            self.showEmptyView.accept(true)
        }
    }
    
    func setDigit(_ digitStr:String){
        ///if decimall pressed
        if digitStr == "." {
            if setClear {
                inputNumberStr = "0."
            }
            else{
                if displayText.value != nil && !containsDecimal{
                    inputNumberStr = inputNumberStr + digitStr
                    return
                }
            }
            guard let input = Int(digitStr) else {return}
            if input == 0 && displayText.value == "0" {return}
        }
        ///if zero selected and input decimalvalue is zero , check for . to decide ignore/add zero
        if digitStr == "0" && Decimal(string:inputNumberStr) == 0{
            if containsDecimal{
                inputNumberStr = inputNumberStr+digitStr
            }
            return
        }
        if setClear {
            inputNumberStr = digitStr
        }
        else{
            inputNumberStr = inputNumberStr+digitStr
        }
    }
    private var containsDecimal: Bool {
        return inputNumberStr.contains(".")
    }
    ///clear last
    func clearLastDigit(){
        if !setClear  && inputNumberStr.count > 0 {
            self.inputNumberStr.removeLast()
            if inputNumberStr.count == 0 {
                self.displayText.accept("")
                self.lastBitcoinUnitPrice.onNext(nil)
            }
        }
    }
    /// call getBitCoinPrice from ConvertorCore to perform networking and convert bitcoin currency to us dollar
    func getCoinPrice(uuid:String,referenceCurrencyUuid :String?="",timeStamp:Double?=nil){
        self.repository.getBitCoinPrice(uuid: uuid, referenceCurrencyUuid: nil, timeStamp: nil).asSingle().subscribe (onSuccess: {[weak self] (retrievedData) in
            if let value = retrievedData.value {
                if let result = value.data {
                    self?.lastBitcoinUnitPrice.onNext(result)
                }
            }
        }) { (error) in
            self.handleError(error: error)
        }.disposed(by: disposeBag)
    }
    func handleError(error : Error){
        if let err = error as? ServerError {
            convertError.onNext(err)
        }
    }
}
