//
//  ConvertorViewController.swift
//  
//
//  Created by nasrin niazi on 2023-02-21.
//

import UIKit
import Theme
import SwiftUI
import ConvertorCore

class ConvertorViewController: UIViewController {
    
    @IBOutlet weak var dateTimeLabel: SubDisplayLabel!
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        self.viewModel.clearLastDigit()
    }
    @IBOutlet weak var inputLabel: DisplayLabel!
    
    @IBOutlet weak var outputLabel: DisplayLabel!
    var viewModel:ConvertorViewModel!
    
    @IBAction func digitButtonTapped(_ sender: UIButton) {
        guard let digit = sender.currentTitle else {return}
        viewModel.setDigit(digit)
    }
    //_ sender: UIButton
    @IBAction func convertButtonTapped() {
        guard let text = self.inputLabel.text , text != "0" else {return}
        self.viewModel.getCoinPrice(uuid: Constants.BitcoinUuid)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    func setupUI(){
        inputLabel.adjustsFontSizeToFitWidth = true
        inputLabel.minimumScaleFactor = 0.5
        outputLabel.adjustsFontSizeToFitWidth = true
        outputLabel.minimumScaleFactor = 0.5
    }
    func setupBindings(){
        ///check wether Convertor feature is enabled or not, and show proper ui
        self.viewModel.getFeatures()
        self.viewModel.showEmptyView.subscribe{event in
            DispatchQueue.main.async {
            if let value = event.element,  value == true{
                self.view = CustomEmptyView(delegate: self, message: Constants.emptyViewMessage)
                return
            }
            }
        }.disposed(by: viewModel.disposeBag)
        self.viewModel.displayText.asObservable().bind(to: self.inputLabel.rx.text).disposed(by: self.viewModel.disposeBag)
        self.viewModel.lastBitcoinUnitPrice.subscribe{ event in
            DispatchQueue.main.async {
            if let value = event.element{
                if value == nil {
                    self.clearUI()
                }
                else {
                    guard let unitPrice = value?.price , let priceValue = Decimal(string: unitPrice) else {return}
                    guard  let inputDecimal = Decimal(string: self.inputLabel.text!) else {return}
                    self.outputLabel.text = "\(inputDecimal * priceValue)"
                    let date = Date(timeIntervalSince1970: value!.timestamp)
                    
                    self.dateTimeLabel.text = self.formateDate(dateTime: date)
                }
            }
            }
        }.disposed(by: viewModel.disposeBag)
        self.viewModel.convertError.subscribe(onNext : { error in
            DispatchQueue.main.async {
                MessageDisplay.displayMessageRetry(error.message, owner: self, isRetry : error.retry ).subscribe(onNext : { [weak self] isRetry in
                    if(isRetry == true) {
                        self?.convertButtonTapped()
                    }
                }).disposed(by: self.viewModel.disposeBag)
            }
        }).disposed(by: viewModel.disposeBag)
    }
    func clearUI(){
        self.outputLabel.text = "0"
        self.dateTimeLabel.text = ""
    }
    //helper
    func formateDate(dateTime:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE,d MMM"
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.string(from: dateTime)
    }
}


