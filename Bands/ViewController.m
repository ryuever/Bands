//
//  ViewController.m
//  Bands
//
//  Created by ryu on 2014/10/10.
//  Copyright (c) 2014年 ryu. All rights reserved.
//

#import "ViewController.h"
#import "WBABand.h"
static NSString *bandObjectKey = @"BABandObjectKey";
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.bandObject = [[WBABand alloc]init];
    
//    self.nameTextField.tag = 1;
//    self.nameTextField2.tag = 2;
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"titleLabel.text = %@", self.titleLabel.text);
    [self loadBandObject];
    if (!self.bandObject) {
        self.bandObject = [[WBABand alloc]init];
    }
    [self setUserInterfaceValues];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    
    // identify multiple textField
//    if (textField.tag == 1) {
//        NSLog(@"textFieldShouldBeginEditing");
//        return NO;
//    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.bandObject.name = textField.text;
    [self saveBandObject];
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.bandObject.name = textField.text;
//    [self saveBandObject];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.saveNotesButton.enabled = YES;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    self.bandObject.notes = textView.text;
    [self saveBandObject];
    self.saveNotesButton.enabled = NO;
    NSLog(@"from textViewShouldEndEditing");
    [textView resignFirstResponder];
    return YES;
}

- (IBAction)saveNotesButtonTouched:(id)sender
{
    // invork textViewShouldEndEditing function to finish writing.
    [self textViewShouldEndEditing:self.notesTextView];
}

- (IBAction)ratingStepperValueChanged:(id)sender
{
    self.ratingValueLabel.text = [NSString stringWithFormat:@"%g", self.ratingStepper.value];
    self.bandObject.rating = (NSInteger)self.ratingStepper.value;
    [self saveBandObject];
}

- (IBAction)tourStatusSegmentedControlValuechanged:(id)sender
{
    self.bandObject.touringStatus = self.touringStatusSegmentedControl.selectedSegmentIndex;
    NSLog(@"The value of touringStatus is %d", self.bandObject.touringStatus);
    [self saveBandObject];
}

- (IBAction)haveSeenLiveSwitchValueChanged:(id)sender
{
    self.bandObject.haveSeenLive = self.haveSeenLiveSwitch.on;
    NSLog(@"haveSeenLiveSwitch is %d", self.bandObject.haveSeenLive);
    [self saveBandObject];
}

- (void)saveBandObject
{
    NSData *bandObjectData = [NSKeyedArchiver archivedDataWithRootObject:self.bandObject];
//    NSData *bandObjectData = [NSKeyedArchiver archiveRootObject:self.bandObject toFile:@"~/Desktop/temp.plist"];
//    BOOL verifySaving= [NSKeyedArchiver archiveRootObject:self.bandObject toFile:@"/Users/ryuyutyo/Desktop/temp.plist"];

//    NSLog(@"bandObjectData is %@", bandObjectData);
    [[NSUserDefaults standardUserDefaults]setObject:bandObjectData forKey:bandObjectKey];
    NSLog(@"bandObjectKey is %@", bandObjectKey);
    
//    NSString *udid = [[UIDevice currentDevice] uniqueIdentifier];
//    NSLog(@"udid is %@", udid);
}

- (void)loadBandObject
{
    NSData * bandObjectData = [[NSUserDefaults standardUserDefaults]objectForKey:bandObjectKey];
    if (bandObjectData) {
        self.bandObject = [NSKeyedUnarchiver unarchiveObjectWithData:bandObjectData];
    }
}

- (void)setUserInterfaceValues
{
    self.nameTextField.text = self.bandObject.name;
    self.notesTextView.text = self.bandObject.notes;
    self.ratingStepper.value = self.bandObject.rating;
    self.ratingValueLabel.text = [NSString stringWithFormat:@"%g", self.ratingStepper.value];
    self.touringStatusSegmentedControl.selectedSegmentIndex = self.bandObject.touringStatus;
    self.haveSeenLiveSwitch.on = self.bandObject.haveSeenLive;
}

- (IBAction)deleteButtonTouched:(id)sender
{
    UIActionSheet *promptDeleteDataActionSheet = [[UIActionSheet alloc]
                                                  initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel"
                                                  destructiveButtonTitle:@"Delete Band" otherButtonTitles:nil, nil];
    [promptDeleteDataActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.destructiveButtonIndex == buttonIndex) {
        self.bandObject = nil;
        [self setUserInterfaceValues];
        
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:bandObjectKey];
    }
}

@end