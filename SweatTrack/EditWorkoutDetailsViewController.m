//
//  EditWorkoutDetailsViewController.m
//  SweatTrack
//
//  Created by Anand Kumar on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditWorkoutDetailsViewController.h"
#import "WorkoutTypes.h"
#import "DatePickerView.h"

@interface EditWorkoutDetailsViewController ()

@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) DatePickerView *datePickerView;

@property (nonatomic) UILabel *labelInWarningRow;
@property (nonatomic, strong) UILabel *datePickedLabel;
@property (nonatomic, strong) NSDictionary *allTextFields;
@property (nonatomic, strong) NSNumber *keyboardVisible;

@property (nonatomic) NSMutableDictionary *workoutDeleteAttemptedFromTextField;

@end

@implementation EditWorkoutDetailsViewController

@synthesize selectedDate = _selectedDate;
@synthesize datePickerView = _datePickerView;

@synthesize labelInWarningRow = _labelInWarningRow;
@synthesize datePickedLabel = _datePickedLabel;
@synthesize allTextFields = allTextFields;
@synthesize keyboardVisible = _keyboardVisible;

@synthesize workoutDone = _workoutDone;
@synthesize context = _context;

@synthesize workoutDeleteAttemptedFromTextField = _workoutDeleteAttemptedFromTextField;

- (void)viewWillAppear:(BOOL)animated
{   
    if (!self.workoutDone.workoutType) {
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    self.selectedDate = self.workoutDone.workoutDate;
    
    if (!self.allTextFields) {
        self.allTextFields = [[NSMutableDictionary alloc] init];
    }
    
    self.keyboardVisible = [NSNumber numberWithBool:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.tableView reloadData];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (self.datePickerView) {
        self.datePickerView.hidden = YES;
        self.datePickerView = nil;
    }
    
    for (NSString *textFieldKey in self.allTextFields) {
        UITextField *textField = [self.allTextFields valueForKey:textFieldKey];
        textField.userInteractionEnabled = YES;
    }
    
    self.labelInWarningRow.text = @"";
    [[NSNotificationCenter defaultCenter] removeObserver:self];   //Unregister from keyboard notification, else they may start piling
    
    [super viewDidDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{   
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 2:
            return 3;
        default:
            return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 3:
            return 25.00;
        default:
            return 36.00;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    // Configure the cell...
    CGRect workoutNameFrame = CGRectMake(30.0, 9.0, 220.0, 27.0);  //70.0, 9.0, 160.0, 27.0
    CGRect dateFrame = CGRectMake(108.0, 4.0, 180.0, 27.0);  //108.0, 2.0, 180.0, 24.0
    
    CGRect metricNameFrame = CGRectMake(7.0, 4.0, 149.0, 27.0);  //8.0, 4.0, 180.0, 27.0
    CGRect metricValueFrame = CGRectMake(160.0, 4.0, 47.0, 27.0);  //167.0, 3.0, 40.0, 24.0
    CGRect metricDefaultUnitFrame = CGRectMake(211.0, 4.0, 80.0, 27.0);  //211.0, 3.0, 80.0, 24.0
    
    CGRect warningFrame = CGRectMake(10.0, 9.0, 280.0, 27.0);  //10.0, 9.0, 280.0, 24.0
    CGRect deleteButtonFrame = CGRectMake(100.0, 9.0, 100.0, 27.0);  //100.0, 9.0, 100.0, 24.0
    
    if (indexPath.section == 0) {
        UITextField *workoutNameLabel = [[UITextField alloc] initWithFrame:workoutNameFrame];
        workoutNameLabel.backgroundColor = [UIColor clearColor];
        workoutNameLabel.text = self.workoutDone.workoutType.workoutName;
        workoutNameLabel.delegate = self;
        workoutNameLabel.enabled = NO;
        workoutNameLabel.adjustsFontSizeToFitWidth = YES;
        workoutNameLabel.font = [UIFont systemFontOfSize:22.0];
        workoutNameLabel.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        workoutNameLabel.textAlignment = UITextAlignmentCenter;
        workoutNameLabel.tag = 99;
        
        //        [self.allTextFields setValue:workoutNameLabel forKey:@"textFieldWorkoutName"];
        
        [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [cell.contentView addSubview:workoutNameLabel];
    } //Row for workout name
    
    if (indexPath.section == 1) {
        cell.textLabel.text = @"Date";
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        
        self.datePickedLabel = [[UILabel alloc] init];
        self.datePickedLabel = [[UILabel alloc] initWithFrame:dateFrame];
        self.datePickedLabel.backgroundColor = [UIColor clearColor];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        self.datePickedLabel.text = [dateFormatter stringFromDate:self.selectedDate];
        
        [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [cell.contentView addSubview:self.datePickedLabel];
        
    } //Row for workout date
    
    if (indexPath.section == 2) {
        UITextField *workoutMetricNameTextField = [[UITextField alloc] initWithFrame:metricNameFrame];
        workoutMetricNameTextField.backgroundColor = [UIColor whiteColor];
        workoutMetricNameTextField.delegate = self;
        workoutMetricNameTextField.adjustsFontSizeToFitWidth = YES;
        workoutMetricNameTextField.font = [UIFont systemFontOfSize:15.0];
        workoutMetricNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        workoutMetricNameTextField.textAlignment = UITextAlignmentLeft;
        workoutMetricNameTextField.tag = indexPath.row*3 + 1;
        
        UITextField *workoutMetricValueTextField = [[UITextField alloc] initWithFrame:metricValueFrame];
        workoutMetricValueTextField.backgroundColor = [UIColor whiteColor];
        workoutMetricValueTextField.delegate = self;
        workoutMetricValueTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        workoutMetricValueTextField.adjustsFontSizeToFitWidth = YES;
        workoutMetricValueTextField.font = [UIFont systemFontOfSize:15.0];
        workoutMetricValueTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        workoutMetricValueTextField.textAlignment = UITextAlignmentCenter;
        workoutMetricValueTextField.tag = indexPath.row*3 + 2;
        
        UITextField *workoutMetricDefaultUnitTextField = [[UITextField alloc] initWithFrame:metricDefaultUnitFrame];
        workoutMetricDefaultUnitTextField.backgroundColor = [UIColor whiteColor];
        workoutMetricDefaultUnitTextField.delegate = self;
        workoutMetricDefaultUnitTextField.adjustsFontSizeToFitWidth = YES;
        workoutMetricDefaultUnitTextField.font = [UIFont systemFontOfSize:15.0];
        workoutMetricDefaultUnitTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        workoutMetricDefaultUnitTextField.textAlignment = UITextAlignmentLeft;
        workoutMetricDefaultUnitTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        workoutMetricDefaultUnitTextField.tag = indexPath.row*3 + 3;
        
        switch (indexPath.row) {
            case 0:
                workoutMetricNameTextField.text = self.workoutDone.workoutMetric1Name;
                workoutMetricValueTextField.text = self.workoutDone.workoutMetric1Value;
                workoutMetricDefaultUnitTextField.text = self.workoutDone.workoutMetric1Unit;
                
                [self.allTextFields setValue:workoutMetricNameTextField forKey:@"textFieldMetric1Name"];
                [self.allTextFields setValue:workoutMetricValueTextField forKey:@"textFieldMetric1Value"];
                [self.allTextFields setValue:workoutMetricDefaultUnitTextField forKey:@"textFieldMetric1Unit"];
                break;
            case 1:
                workoutMetricNameTextField.text = self.workoutDone.workoutMetric2Name;
                workoutMetricValueTextField.text = self.workoutDone.workoutMetric2Value;
                workoutMetricDefaultUnitTextField.text = self.workoutDone.workoutMetric2Unit;
                
                if ([self.workoutDone.workoutMetric1Name caseInsensitiveCompare:@""] == NSOrderedSame) {
                    workoutMetricNameTextField.enabled = NO;
                    workoutMetricValueTextField.enabled = NO;
                    workoutMetricDefaultUnitTextField.enabled = NO;
                }
                if ([workoutMetricNameTextField.text caseInsensitiveCompare:@""] == NSOrderedSame) {
                    workoutMetricValueTextField.enabled = NO;
                    workoutMetricDefaultUnitTextField.enabled = NO;
                }
                
                [self.allTextFields setValue:workoutMetricNameTextField forKey:@"textFieldMetric2Name"];
                [self.allTextFields setValue:workoutMetricValueTextField forKey:@"textFieldMetric2Value"];
                [self.allTextFields setValue:workoutMetricDefaultUnitTextField forKey:@"textFieldMetric2Unit"];
                break;
            case 2:
                workoutMetricNameTextField.text = self.workoutDone.workoutMetric3Name;
                workoutMetricValueTextField.text = self.workoutDone.workoutMetric3Value;
                workoutMetricDefaultUnitTextField.text = self.workoutDone.workoutMetric3Unit;
                
                if ([self.workoutDone.workoutMetric2Name caseInsensitiveCompare:@""] == NSOrderedSame) {
                    workoutMetricNameTextField.enabled = NO;
                    workoutMetricValueTextField.enabled = NO;
                    workoutMetricDefaultUnitTextField.enabled = NO;
                }
                if ([workoutMetricNameTextField.text caseInsensitiveCompare:@""] == NSOrderedSame) {
                    workoutMetricValueTextField.enabled = NO;
                    workoutMetricDefaultUnitTextField.enabled = NO;
                }
                
                [self.allTextFields setValue:workoutMetricNameTextField forKey:@"textFieldMetric3Name"];
                [self.allTextFields setValue:workoutMetricValueTextField forKey:@"textFieldMetric3Value"];
                [self.allTextFields setValue:workoutMetricDefaultUnitTextField forKey:@"textFieldMetric3Unit"];
                break;
        }
        
        [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [cell.contentView addSubview:workoutMetricNameTextField];
        [cell.contentView addSubview:workoutMetricValueTextField];
        [cell.contentView addSubview:workoutMetricDefaultUnitTextField];
    } //Rows for 3 metrics
    
    if (indexPath.section == 3) {
        UILabel *warningLabel = [[UILabel alloc] initWithFrame:warningFrame];
        warningLabel.text = @"";
        warningLabel.textAlignment = UITextAlignmentCenter;
        warningLabel.enabled = NO;
        warningLabel.font = [UIFont systemFontOfSize:14.0];
        warningLabel.backgroundColor = [UIColor clearColor];
        
        [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [cell.contentView addSubview:warningLabel];
        
        self.labelInWarningRow = warningLabel;
    } //Row for warning label
    
    if (indexPath.section == 4) {
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        deleteButton.frame = deleteButtonFrame;
        [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchDown];
        
        [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [cell.contentView addSubview:deleteButton];
    } //Row for delete button
    
    
    if (indexPath.section != 1 && indexPath.section != 2) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
        backView.backgroundColor = [UIColor clearColor];
        cell.backgroundView = backView;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.tabBarController.selectedIndex == 1) {
            
            [[self.tabBarController.viewControllers objectAtIndex:2] popToRootViewControllerAnimated:NO];
            
            id tempObject = [[self.tabBarController.viewControllers objectAtIndex:2] valueForKey:@"topViewController"];
            [tempObject performSelector:@selector(setWorkoutDoneWhenSeguedFromAnotherTab:) withObject:self.workoutDone];
            [tempObject performSegueWithIdentifier:@"Show Workouts Done for a Type" sender:self];
            
            self.tabBarController.selectedIndex = 2;
        }
    }
    
    if (indexPath.section == 1) {
        if ([self.keyboardVisible boolValue] == NO) {
            //Set up Date Picker
            if (!self.datePickerView) {
                self.datePickerView = [[DatePickerView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.size.height*0.7, self.view.frame.size.width, self.view.frame.size.height*0.3)];
                self.datePickerView.hidden = YES;
                [self.datePickerView addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
                [self.view addSubview:self.datePickerView];
            }
            
            if (self.datePickerView.hidden) {
                [self.datePickerView setDate:self.selectedDate animated:NO];
                self.datePickerView.hidden = NO;
                
                for (NSString *textFieldKey in self.allTextFields) {
                    UITextField *textField = [self.allTextFields valueForKey:textFieldKey];
                    textField.userInteractionEnabled = NO;
                }
            }
            else {
                self.datePickerView.hidden = YES;
                self.datePickerView = nil;
                
                for (NSString *textFieldKey in self.allTextFields) {
                    UITextField *textField = [self.allTextFields valueForKey:textFieldKey];
                    textField.userInteractionEnabled = YES;
                }
            }
        }
    }
}

#pragma mark - 

- (void)keyboardDidShow: (NSNotification *)notification 
{
    self.keyboardVisible = [NSNumber numberWithBool:YES];
}

- (void)keyboardDidHide: (NSNotification *)notification 
{
    self.keyboardVisible = [NSNumber numberWithBool:NO];
}

- (void)datePickerValueChanged:(DatePickerView *)sender
{
    self.selectedDate = sender.date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    self.datePickedLabel.text = [dateFormatter stringFromDate:self.selectedDate];
    
    self.workoutDone.workoutDate = self.selectedDate;
    [self saveContext];
}

#pragma mark - Subviews' delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 7 || textField.tag == 8 || textField.tag ==9) {
        CGFloat height = 50.0;
        self.tableView.contentInset =  UIEdgeInsetsMake(0, 0, height, 0);
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:2] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    for (NSString *otherTextFieldKey in self.allTextFields) {
        UITextField *otherTextField = [self.allTextFields valueForKey:otherTextFieldKey];
        if (otherTextField.tag != textField.tag) {
            otherTextField.userInteractionEnabled = NO;
        }
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.tag == 7 || textField.tag == 8 || textField.tag ==9) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    for (NSString *otherTextFieldKey in self.allTextFields) {
        UITextField *otherTextField = [self.allTextFields valueForKey:otherTextFieldKey];
        otherTextField.userInteractionEnabled = YES;
    }
    
    NSString *enteredText = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    self.labelInWarningRow.text = @"";
    
    if (textField.tag == 1) {
        if ([enteredText isEqualToString:@""]) {
            if ([self.workoutDone.workoutMetric2Value isEqualToString:@""] && [self.workoutDone.workoutMetric3Value isEqualToString:@""]) {
                self.workoutDeleteAttemptedFromTextField = [NSDictionary dictionaryWithObjectsAndKeys:textField, @"textField", 
                                                            self.workoutDone.workoutMetric1Name, @"textFieldValue", nil];
                [self confirmWorkoutDeletionWithText:@"Deleting all metrics will delete the work out.\n Are you sure you want to delete it?"];
            }
            else {
                self.workoutDone.workoutMetric1Name = self.workoutDone.workoutMetric2Name;
                self.workoutDone.workoutMetric1Value = self.workoutDone.workoutMetric2Value;
                self.workoutDone.workoutMetric1Unit = self.workoutDone.workoutMetric2Unit;
                self.workoutDone.workoutMetric2Name = self.workoutDone.workoutMetric3Name;
                self.workoutDone.workoutMetric2Value = self.workoutDone.workoutMetric3Value;
                self.workoutDone.workoutMetric2Unit = self.workoutDone.workoutMetric3Unit;
                self.workoutDone.workoutMetric3Name = @"";
                self.workoutDone.workoutMetric3Value= @"";
                self.workoutDone.workoutMetric3Unit = @"";
                
                [self saveContext];
                [self.tableView reloadData];
            }
        }
        else if (([enteredText caseInsensitiveCompare:self.workoutDone.workoutMetric2Name] == NSOrderedSame) || 
                 ([enteredText caseInsensitiveCompare:self.workoutDone.workoutMetric3Name] == NSOrderedSame)) {
            self.labelInWarningRow.text = @"A metric with that name already exists.";
            textField.text = self.workoutDone.workoutMetric1Name;
        }
        else {
            self.workoutDone.workoutMetric1Name = enteredText;
            [self saveContext];
            [self.tableView reloadData];
        }
    } //Metric1 Name
    
    if (textField.tag == 4) {
        if ([enteredText isEqualToString:@""]) {
            if ([self.workoutDone.workoutMetric1Value isEqualToString:@""] && [self.workoutDone.workoutMetric3Value isEqualToString:@""]) {
                self.workoutDeleteAttemptedFromTextField = [NSDictionary dictionaryWithObjectsAndKeys:textField, @"textField", 
                                                            self.workoutDone.workoutMetric2Name, @"textFieldValue", nil];       
                [self confirmWorkoutDeletionWithText:@"Deleting all metrics will delete the work out.\n Are you sure you want to delete it?"];
            }
            else {
                self.workoutDone.workoutMetric2Name = self.workoutDone.workoutMetric3Name;
                self.workoutDone.workoutMetric2Value = self.workoutDone.workoutMetric3Value;
                self.workoutDone.workoutMetric2Unit = self.workoutDone.workoutMetric3Unit;
                self.workoutDone.workoutMetric3Name = @"";
                self.workoutDone.workoutMetric3Value= @"";
                self.workoutDone.workoutMetric3Unit = @"";
                
                [self saveContext];
                [self.tableView reloadData];
            }
        }
        else if (([enteredText caseInsensitiveCompare:self.workoutDone.workoutMetric1Name] == NSOrderedSame) || 
                 ([enteredText caseInsensitiveCompare:self.workoutDone.workoutMetric3Name] == NSOrderedSame)) {
            self.labelInWarningRow.text = @"A metric with that name already exists.";
            textField.text = self.workoutDone.workoutMetric2Name;
        }
        else {
            self.workoutDone.workoutMetric2Name = enteredText;
            [self saveContext];
            [self.tableView reloadData];
        }
    } //Metric2 Name
    
    if (textField.tag == 7) {
        if ([enteredText isEqualToString:@""]) {
            if ([self.workoutDone.workoutMetric1Value isEqualToString:@""] && [self.workoutDone.workoutMetric2Value isEqualToString:@""]) {
                self.workoutDeleteAttemptedFromTextField = [NSDictionary dictionaryWithObjectsAndKeys:textField, @"textField", 
                                                            self.workoutDone.workoutMetric3Name, @"textFieldValue", nil];
                [self confirmWorkoutDeletionWithText:@"Deleting all metrics will delete the work out.\n Are you sure you want to delete it?"];
                //Restore the value in text field if user choses to cancel
            }
            else {
                self.workoutDone.workoutMetric3Name = @"";
                self.workoutDone.workoutMetric3Value= @"";
                self.workoutDone.workoutMetric3Unit = @"";
                
                [self saveContext];
                [self.tableView reloadData];
            }
        }
        else if (([enteredText caseInsensitiveCompare:self.workoutDone.workoutMetric1Name] == NSOrderedSame) || 
                 ([enteredText caseInsensitiveCompare:self.workoutDone.workoutMetric2Name] == NSOrderedSame)) {
            self.labelInWarningRow.text = @"A metric with that name already exists.";
            textField.text = self.workoutDone.workoutMetric3Name;
        }
        else {
            self.workoutDone.workoutMetric3Name = enteredText;
            [self saveContext];
            [self.tableView reloadData];
        }
    } //Metric3 Name
    
    
    if (textField.tag == 2) {
        if ([enteredText isEqualToString:@""] && 
            ([self.workoutDone.workoutMetric2Value isEqualToString:@""] && [self.workoutDone.workoutMetric3Value isEqualToString:@""])) {
            self.workoutDeleteAttemptedFromTextField = [NSDictionary dictionaryWithObjectsAndKeys:textField, @"textField", 
                                                        self.workoutDone.workoutMetric1Value, @"textFieldValue", nil];
            [self confirmWorkoutDeletionWithText:@"Deleting all metrics will delete the work out.\n Are you sure you want to delete it?"];
            //Restore the value in text field if user choses to cancel
        }
        else {
            self.workoutDone.workoutMetric1Value = enteredText;
            [self saveContext];
            [self.tableView reloadData];
        }
    } //Metric1 Value
    
    if (textField.tag == 5) {
        if ([enteredText isEqualToString:@""] && 
            ([self.workoutDone.workoutMetric1Value isEqualToString:@""] && [self.workoutDone.workoutMetric3Value isEqualToString:@""])) {
            self.workoutDeleteAttemptedFromTextField = [NSDictionary dictionaryWithObjectsAndKeys:textField, @"textField", 
                                                        self.workoutDone.workoutMetric2Value, @"textFieldValue", nil];
            [self confirmWorkoutDeletionWithText:@"Deleting all metrics will delete the work out.\n Are you sure you want to delete it?"];
            //Restore the value in text field if user choses to cancel
        }
        else {
            self.workoutDone.workoutMetric2Value = enteredText;
            [self saveContext];
            [self.tableView reloadData];
        }
    } //Metric2 Value
    
    if (textField.tag == 8) {
        if ([enteredText isEqualToString:@""] && 
            ([self.workoutDone.workoutMetric1Value isEqualToString:@""] && [self.workoutDone.workoutMetric2Value isEqualToString:@""])) {
            self.workoutDeleteAttemptedFromTextField = [NSDictionary dictionaryWithObjectsAndKeys:textField, @"textField", 
                                                        self.workoutDone.workoutMetric3Value, @"textFieldValue", nil];
            [self confirmWorkoutDeletionWithText:@"Deleting all metrics will delete the work out.\n Are you sure you want to delete it?"];
            //Restore the value in text field if user choses to cancel
        }
        else {
            self.workoutDone.workoutMetric3Value = enteredText;
            [self saveContext];
            [self.tableView reloadData];
        }
    } //Metric3 Value
    
    
    if (textField.tag == 3) {
        self.workoutDone.workoutMetric1Unit = enteredText;
        [self saveContext];
        [self.tableView reloadData];
    } //Metric1 Unit
    
    if (textField.tag == 6) {
        self.workoutDone.workoutMetric2Unit = enteredText;
        [self saveContext];
        [self.tableView reloadData];
    } //Metric2 Unit
    
    if (textField.tag == 9) {
        self.workoutDone.workoutMetric3Unit = enteredText;
        [self saveContext];
        [self.tableView reloadData];
    } //Metric3 Unit
    
    return YES;
}

- (void)deleteButtonPressed:(UIButton *)sender
{
    [self confirmWorkoutDeletionWithText:@"The work out will be deleted."];
}

#pragma mark - Methods accessing store

- (void)deleteWorkout
{
    NSManagedObjectID *objectIDOfCurrentManagedObject = [self.workoutDone objectID];
    
    for (id viewController in self.navigationController.tabBarController.viewControllers) {
        if ([viewController isMemberOfClass:[UINavigationController class]]) {
            if ([[viewController valueForKey:@"topViewController"] isMemberOfClass:[EditWorkoutDetailsViewController class]]) {
                if ([viewController valueForKey:@"topViewController"] != self) {
                    if ([[viewController valueForKey:@"topViewController"] valueForKey:@"workoutDone"]) {
                        NSManagedObjectID *objectIDOfOtherManagedObject = [[[viewController valueForKey:@"topViewController"] valueForKey:@"workoutDone"] valueForKey:@"objectID"];
                        if ([[objectIDOfCurrentManagedObject URIRepresentation] isEqual:[objectIDOfOtherManagedObject URIRepresentation]]) {
                            [viewController popViewControllerAnimated:NO];
                        }
                    }
                }
            }
        }
    }
    
    [self.context deleteObject:self.workoutDone];
    [self saveContext];
    
    [self.navigationController popViewControllerAnimated:YES];
    self.allTextFields = nil;
    
}

- (void)confirmWorkoutDeletionWithText:(NSString *)confirmationText
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:confirmationText
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Delete"
                                                    otherButtonTitles:nil];
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self deleteWorkout];
    }
    if (buttonIndex == 1) {
        [[self.workoutDeleteAttemptedFromTextField valueForKey:@"textField"] setValue:[self.workoutDeleteAttemptedFromTextField valueForKey:@"textFieldValue"] forKey:@"text"];
    }
}

- (void)saveContext
{   
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.context;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

@end
