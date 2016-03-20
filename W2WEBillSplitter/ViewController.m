//
//  ViewController.m
//  W2WEBillSplitter
//
//  Created by Karlo Pagtakhan on 03/20/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *billAmount;
@property (strong, nonatomic) IBOutlet UITextField *tipPercentage;
@property (strong, nonatomic) IBOutlet UISlider *peopleSplittingSlider;
@property (strong, nonatomic) IBOutlet UILabel *splitAmount;
@property (strong, nonatomic) IBOutlet UILabel *sliderLabel;

@end

@implementation ViewController
//MARK: View methods
- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  self.billAmount.delegate = self;
  self.tipPercentage.delegate = self;
  
  [self updateSliderLabel];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
//MARK: IBOutlets
- (IBAction)sliderMoved:(id)sender {
  [self updateSliderLabel];
  [self calculateValues];
}
- (IBAction)calculateSplitAmount:(id)sender {
  [self calculateValues];
}

- (IBAction)tipPercentageEntered:(UITextField *)sender {
  
  NSDecimalNumber *amount =[NSDecimalNumber decimalNumberWithString:sender.text];
  if (amount != [NSDecimalNumber notANumber]) {
    amount = [amount decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"100.0"]];
    
    NSNumberFormatter *numberFormatPercentage = [[NSNumberFormatter alloc] init];
    [numberFormatPercentage setPercentSymbol:@"%"];
    [numberFormatPercentage setNumberStyle:NSNumberFormatterPercentStyle];
    
    sender.text = [numberFormatPercentage stringFromNumber:amount];
    
    [self calculateValues];
  }
  
}
- (IBAction)textFieldChanging:(UITextField *)sender {
  
  NSDecimalNumber *amount =[NSDecimalNumber decimalNumberWithString:sender.text];
  if (amount != [NSDecimalNumber notANumber]) {
    NSNumberFormatter *numberFormat2Decimals = [[NSNumberFormatter alloc] init];
    [numberFormat2Decimals setMinimumFractionDigits:2];
    [numberFormat2Decimals setMaximumFractionDigits:2];
    [numberFormat2Decimals setCurrencySymbol:@"$"];
    [numberFormat2Decimals setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    sender.text = [numberFormat2Decimals stringFromNumber:amount];
  }
}
//MARK: Text Field delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
  [textField resignFirstResponder];
  return YES;
}
//MARK: Calculations
-(void)calculateValues{
  
  NSNumberFormatter *numberFormat2Decimals = [[NSNumberFormatter alloc] init];
  [numberFormat2Decimals setMinimumFractionDigits:2];
  [numberFormat2Decimals setMaximumFractionDigits:2];
  [numberFormat2Decimals setNumberStyle:NSNumberFormatterCurrencyStyle];
  
  NSDecimalNumber *billAmount = [NSDecimalNumber alloc];
  NSString *amountString = [[numberFormat2Decimals numberFromString:self.billAmount.text] stringValue];
  if (amountString){
    billAmount = [NSDecimalNumber decimalNumberWithString:amountString];
  } else{
    billAmount = [NSDecimalNumber decimalNumberWithString:self.billAmount.text];
  }
  
  NSDecimalNumber *tipPercentage =[NSDecimalNumber decimalNumberWithString:self.tipPercentage.text];
  NSDecimalNumber *peopleSplittingSlider =[NSDecimalNumber decimalNumberWithString:[@(self.peopleSplittingSlider.value) stringValue]];
  NSDecimalNumber *splitAmount =[NSDecimalNumber decimalNumberWithString:self.splitAmount.text];
  
  if ( billAmount != [NSDecimalNumber notANumber]){
    if (tipPercentage != [NSDecimalNumber notANumber]) {
      tipPercentage = [tipPercentage decimalNumberByDividingBy: [NSDecimalNumber decimalNumberWithString:@"100.0"]];
    } else {
      tipPercentage =[NSDecimalNumber decimalNumberWithString:@"0"];
    }

    tipPercentage = [tipPercentage decimalNumberByAdding: [NSDecimalNumber decimalNumberWithString:@"1"]];
    splitAmount = [[billAmount decimalNumberByMultiplyingBy:tipPercentage] decimalNumberByDividingBy:peopleSplittingSlider];
    
    NSNumberFormatter *splitAmountFormat = [[NSNumberFormatter alloc] init];
    [splitAmountFormat setMinimumFractionDigits:2];
    [splitAmountFormat setMaximumFractionDigits:2];
    [splitAmountFormat setNumberStyle:NSNumberFormatterCurrencyStyle];

    self.splitAmount.text = [splitAmountFormat stringFromNumber:splitAmount];
  } else {
    splitAmount = [NSDecimalNumber decimalNumberWithString:@"0"];
    
    NSNumberFormatter *splitAmountFormat = [[NSNumberFormatter alloc] init];
    [splitAmountFormat setMinimumFractionDigits:2];
    [splitAmountFormat setMaximumFractionDigits:2];
    [splitAmountFormat setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    self.splitAmount.text = [splitAmountFormat stringFromNumber:splitAmount];
  }
  
}
//MARK: Update views
-(void)updateSliderLabel{
  float sliderValue = self.peopleSplittingSlider.value;
  self.peopleSplittingSlider.value = ceilf(sliderValue);
  self.sliderLabel.text = @"split by ";
  self.sliderLabel.text = [ self.sliderLabel.text stringByAppendingString:[@(self.peopleSplittingSlider.value) stringValue]];}

@end
