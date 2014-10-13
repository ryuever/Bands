//
//  ViewController.h
//  Bands
//
//  Created by ryu on 2014/10/10.
//  Copyright (c) 2014年 ryu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBABand.h"

@interface ViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) WBABand *bandObject;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextView *notesTextView;
@property (nonatomic, weak) IBOutlet UIButton *saveNotesButton;
@property (nonatomic, weak) IBOutlet UIStepper *ratingStepper;
@property (nonatomic, weak) IBOutlet UILabel *ratingValueLabel;
@property (nonatomic, weak) IBOutlet UISegmentedControl *touringStatusSegmentedControl;
@property (nonatomic, weak) IBOutlet UISwitch *haveSeenLiveSwitch;

- (IBAction)saveNotesButtonTouched:(id)sender;
- (IBAction)ratingStepperValueChanged:(id)sender;
- (IBAction)tourStatusSegmentedControlValuechanged:(id)sender;
- (IBAction)haveSeenLiveSwitchValueChanged:(id)sender;
- (IBAction)deleteButtonTouched:(id)sender;

- (void)saveBandObject;
- (void)loadBandObject;
- (void)setUserInterfaceValues;
@end

