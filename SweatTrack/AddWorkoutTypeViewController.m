//
//  AddWorkoutTypeViewController.m
//  SweatTrack
//
//  Created by Anand Kumar on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddWorkoutTypeViewController.h"
#import "GAI.h"

@interface AddWorkoutTypeViewController ()

@property (nonatomic) UILabel *labelInWarningRow;
@property (nonatomic) UISwitch *switchForHiddenAttribute;
@property (nonatomic, strong) NSMutableDictionary *allTextFields;
@property (nonatomic) UIButton *submitButton;

@property (nonatomic, strong) NSMutableDictionary *stateData;

@property (nonatomic) UITextField *textFieldWorkoutTypeName;
@property (nonatomic) UITextField *textFieldMetric1Name;
@property (nonatomic) UITextField *textFieldMetric1Unit;
@property (nonatomic) UITextField *textFieldMetric2Name;
@property (nonatomic) UITextField *textFieldMetric2Unit;
@property (nonatomic) UITextField *textFieldMetric3Name;
@property (nonatomic) UITextField *textFieldMetric3Unit;

@end

@implementation AddWorkoutTypeViewController

@synthesize switchForHiddenAttribute = _switchForHiddenAttribute;
@synthesize labelInWarningRow = _labelInWarningRow;
@synthesize allTextFields = _allTextFields;
@synthesize submitButton = _submitButton;

@synthesize stateData = _stateData;

@synthesize context = _context;

@synthesize textFieldWorkoutTypeName = _textFieldWorkoutTypeName, textFieldMetric1Name = _textFieldMetric1Name, textFieldMetric1Unit = _textFieldMetric1Unit, textFieldMetric2Name = _textFieldMetric2Name, textFieldMetric2Unit = _textFieldMetric2Unit, textFieldMetric3Name = _textFieldMetric3Name, textFieldMetric3Unit = _textFieldMetric3Unit;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.allTextFields) {
        self.allTextFields = [[NSMutableDictionary alloc] init];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.labelInWarningRow.text = @"";
    [super viewWillDisappear:animated];
}

#pragma mark - TableView Datasource and Delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{   
    if (!self.stateData) {
        self.stateData = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"", @"textFieldWorkoutName", [NSNumber numberWithBool:NO], @"switchHiddenByDefault", @"", @"textFieldMetric1Name", @"", @"textFieldMetric1Unit", @"", @"textFieldMetric2Name", @"", @"textFieldMetric2Unit", @"", @"textFieldMetric3Name", @"", @"textFieldMetric3Unit", nil];
    }
    
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
    
    CGRect nameFrame = CGRectMake(70.0, 9.0, 160.0, 27.0);
    CGRect switchFrame = CGRectMake(192.0, 4.0, 100.0, 27.0);
    CGRect metricNameFrame = CGRectMake(8.0, 4.0, 180.0, 27.0);
    CGRect metricDefaultUnitFrame = CGRectMake(192.0, 4.0, 100.0, 27.0);
    CGRect warningFrame = CGRectMake(10.0, 9.0, 280.0, 27.0);
    CGRect clearButtonFrame = CGRectMake(10.0, 9.0, 100.0, 27.0);
    CGRect submitButtonFrame = CGRectMake(190.0, 9.0, 100.0, 27.0); //100.0, 9.0, 100.0, 27.0
    
    if (indexPath.section == 0) {
        UITextField *workoutNameTextField = [[UITextField alloc] initWithFrame:nameFrame];
        workoutNameTextField.backgroundColor = [UIColor whiteColor];
        workoutNameTextField.borderStyle = UITextBorderStyleRoundedRect;
        workoutNameTextField.text = [self.stateData valueForKey:@"textFieldWorkoutName"];
        workoutNameTextField.font = [UIFont systemFontOfSize:20.0];
        workoutNameTextField.delegate = self;
        workoutNameTextField.adjustsFontSizeToFitWidth = YES;
        workoutNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        workoutNameTextField.textAlignment = UITextAlignmentCenter;
        workoutNameTextField.tag = 1;
        
        if ([[self.stateData valueForKey:@"textFieldWorkoutName"] isEqualToString:@""]) {
            
        }
        
        [self.allTextFields setValue:workoutNameTextField forKey:@"textFieldWorkoutName"];
        
        [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [cell.contentView addSubview:workoutNameTextField];
        
    } //Row for workout name
    
    if (indexPath.section == 1) {
        cell.textLabel.text = @"Hidden By Default";
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        
        UISwitch *hiddenAttributeSwitch = [[UISwitch alloc] initWithFrame:switchFrame];
        hiddenAttributeSwitch.on = [[self.stateData valueForKey:@"switchHiddenByDefault"] boolValue];
        hiddenAttributeSwitch.backgroundColor = [UIColor clearColor];
        hiddenAttributeSwitch.tag = 3;
        
        [hiddenAttributeSwitch addTarget:self action:@selector(hiddenAttributeSwitchSlid:) forControlEvents:UIControlEventValueChanged];
        
        self.switchForHiddenAttribute = hiddenAttributeSwitch;
        
        [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [cell.contentView addSubview:hiddenAttributeSwitch];
    } //Row for 'hidden by default' switch
    
    if (indexPath.section == 2) {
        UITextField *workoutMetricNameTextField = [[UITextField alloc] initWithFrame:metricNameFrame];
        workoutMetricNameTextField.backgroundColor = [UIColor whiteColor];
        workoutMetricNameTextField.delegate = self;
        workoutMetricNameTextField.adjustsFontSizeToFitWidth = YES;
        workoutMetricNameTextField.font = [UIFont systemFontOfSize:15.0];
        workoutMetricNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        workoutMetricNameTextField.textAlignment = UITextAlignmentLeft;
        workoutMetricNameTextField.tag = (indexPath.row+2)*2 - 1;
        
        UITextField *workoutMetricDefaultUnitTextField = [[UITextField alloc] initWithFrame:metricDefaultUnitFrame];
        workoutMetricDefaultUnitTextField.backgroundColor = [UIColor whiteColor];
        workoutMetricDefaultUnitTextField.delegate = self;
        workoutMetricDefaultUnitTextField.adjustsFontSizeToFitWidth = YES;
        workoutMetricDefaultUnitTextField.font = [UIFont systemFontOfSize:15.0];
        workoutMetricDefaultUnitTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        workoutMetricDefaultUnitTextField.textAlignment = UITextAlignmentLeft;
        workoutMetricDefaultUnitTextField.tag = (indexPath.row+2)*2;
        
        switch (indexPath.row) {
            case 0:
                workoutMetricNameTextField.text = [self.stateData valueForKey:@"textFieldMetric1Name"];
                workoutMetricDefaultUnitTextField.text = [self.stateData valueForKey:@"textFieldMetric1Unit"];
                
                if ([[self.stateData valueForKey:@"textFieldMetric1Name"] isEqualToString:@""]) {
                    workoutMetricDefaultUnitTextField.enabled = NO;
                }
                
                [self.allTextFields setValue:workoutMetricNameTextField forKey:@"textFieldMetric1Name"];
                [self.allTextFields setValue:workoutMetricDefaultUnitTextField forKey:@"textFieldMetric1Unit"];
                break;
            case 1:
                workoutMetricNameTextField.text = [self.stateData valueForKey:@"textFieldMetric2Name"];
                workoutMetricDefaultUnitTextField.text = [self.stateData valueForKey:@"textFieldMetric2Unit"];
                
                if ([[self.stateData valueForKey:@"textFieldMetric1Name"] isEqualToString:@""]) {
                    workoutMetricNameTextField.enabled = NO;
                }
                
                if ([[self.stateData valueForKey:@"textFieldMetric2Name"] isEqualToString:@""]) {
                    workoutMetricDefaultUnitTextField.enabled = NO;
                }
                
                [self.allTextFields setValue:workoutMetricNameTextField forKey:@"textFieldMetric2Name"];
                [self.allTextFields setValue:workoutMetricDefaultUnitTextField forKey:@"textFieldMetric2Unit"];
                break;
            case 2:
                workoutMetricNameTextField.text = [self.stateData valueForKey:@"textFieldMetric3Name"];
                workoutMetricDefaultUnitTextField.text = [self.stateData valueForKey:@"textFieldMetric3Unit"];
                
                if ([[self.stateData valueForKey:@"textFieldMetric2Name"] isEqualToString:@""]) {
                    workoutMetricNameTextField.enabled = NO;
                }
                
                if ([[self.stateData valueForKey:@"textFieldMetric3Name"] isEqualToString:@""]) {
                    workoutMetricDefaultUnitTextField.enabled = NO;
                }
                
                [self.allTextFields setValue:workoutMetricNameTextField forKey:@"textFieldMetric3Name"];
                [self.allTextFields setValue:workoutMetricDefaultUnitTextField forKey:@"textFieldMetric3Unit"];
                break;
        }
        
        [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [cell.contentView addSubview:workoutMetricNameTextField];
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
        UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        clearButton.frame = clearButtonFrame;
        [clearButton setTitle:@"Clear" forState:UIControlStateNormal];
        [clearButton addTarget:self action:@selector(clearButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        submitButton.frame = submitButtonFrame;
        [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
        [submitButton addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [cell.contentView addSubview:clearButton];
        [cell.contentView addSubview:submitButton];
    } //Row for submit button
    
    if (indexPath.section != 2) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
        backView.backgroundColor = [UIColor clearColor];
        cell.backgroundView = backView;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

#pragma mark - Subviews' delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    for (NSString *otherTextFieldKey in self.allTextFields) {
        UITextField *otherTextField = [self.allTextFields valueForKey:otherTextFieldKey];
        if (otherTextField.tag != textField.tag) {
            otherTextField.userInteractionEnabled = NO;
        }
    }
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
        if (![enteredText isEqualToString:@""]) {
            if ([self checkIfWorkoutNameExists:enteredText] == YES) {
                textField.text = @"";
                self.labelInWarningRow.text = @"A workout with that name already exists.";
            }
            else {
                [self.stateData setValue:enteredText forKey:@"textFieldWorkoutName"];
            }
        }
    } //Workout Name
    
        
    if (textField.tag == 3) {
        if (![enteredText isEqualToString:@""]) {
            if (([enteredText caseInsensitiveCompare:[self.stateData valueForKey:@"textFieldMetric2Name"]] == NSOrderedSame) ||
                ([enteredText caseInsensitiveCompare:[self.stateData valueForKey:@"textFieldMetric3Name"]] == NSOrderedSame)) {
                textField.text = [self.stateData valueForKey:@"textFieldMetric1Name"];
                self.labelInWarningRow.text = @"A metric with that name already exists.";
            }
            else {
                [self.stateData setValue:enteredText forKey:@"textFieldMetric1Name"];

                UITextField *textFieldMetric1Unit = [self.allTextFields valueForKey:@"textFieldMetric1Unit"];
                textFieldMetric1Unit.enabled = YES;

                UITextField *textFieldMetric2Name = [self.allTextFields valueForKey:@"textFieldMetric2Name"];
                textFieldMetric2Name.enabled = YES;
            }
        }
        else {
            [self.stateData setValue:[self.stateData valueForKey:@"textFieldMetric2Name"] forKey:@"textFieldMetric1Name"];
            [self.stateData setValue:[self.stateData valueForKey:@"textFieldMetric2Unit"] forKey:@"textFieldMetric1Unit"];
            [self.stateData setValue:[self.stateData valueForKey:@"textFieldMetric3Name"] forKey:@"textFieldMetric2Name"];
            [self.stateData setValue:[self.stateData valueForKey:@"textFieldMetric3Unit"] forKey:@"textFieldMetric2Unit"];
            [self.stateData setValue:@"" forKey:@"textFieldMetric3Name"];
            [self.stateData setValue:@"" forKey:@"textFieldMetric3Unit"];
            [self.tableView reloadData];
        }
    } //Metric1 Name
    
    if (textField.tag == 5) {
        if (![enteredText isEqualToString:@""]) {
            if (([enteredText caseInsensitiveCompare:[self.stateData valueForKey:@"textFieldMetric1Name"]] == NSOrderedSame) ||
                ([enteredText caseInsensitiveCompare:[self.stateData valueForKey:@"textFieldMetric3Name"]] == NSOrderedSame)) {
                textField.text = [self.stateData valueForKey:@"textFieldMetric2Name"];
                self.labelInWarningRow.text = @"A metric with that name already exists.";
            }
            else {
                [self.stateData setValue:enteredText forKey:@"textFieldMetric2Name"];
                
                UITextField *textFieldMetric2Unit = [self.allTextFields valueForKey:@"textFieldMetric2Unit"];
                textFieldMetric2Unit.enabled = YES;
                
                UITextField *textFieldMetric3Name = [self.allTextFields valueForKey:@"textFieldMetric3Name"];
                textFieldMetric3Name.enabled = YES;
            }
        }
        else {
            [self.stateData setValue:[self.stateData valueForKey:@"textFieldMetric3Name"] forKey:@"textFieldMetric2Name"];
            [self.stateData setValue:[self.stateData valueForKey:@"textFieldMetric3Unit"] forKey:@"textFieldMetric2Unit"];
            [self.stateData setValue:@"" forKey:@"textFieldMetric3Name"];
            [self.stateData setValue:@"" forKey:@"textFieldMetric3Unit"];
            [self.tableView reloadData];
        }
    } //Metric2 Name
    
    if (textField.tag == 7) {
        if (![enteredText isEqualToString:@""]) {
            if (([enteredText caseInsensitiveCompare:[self.stateData valueForKey:@"textFieldMetric1Name"]] == NSOrderedSame) ||
                ([enteredText caseInsensitiveCompare:[self.stateData valueForKey:@"textFieldMetric2Name"]] == NSOrderedSame)) {
                textField.text = [self.stateData valueForKey:@"textFieldMetric3Name"];
                self.labelInWarningRow.text = @"A metric with that name already exists.";
            }
            else {
                [self.stateData setValue:enteredText forKey:@"textFieldMetric3Name"];
                
                UITextField *textFieldMetric3Unit = [self.allTextFields valueForKey:@"textFieldMetric3Unit"];
                textFieldMetric3Unit.enabled = YES;
            }
        }
        else {
            [self.stateData setValue:@"" forKey:@"textFieldMetric3Name"];
            [self.stateData setValue:@"" forKey:@"textFieldMetric3Unit"];
            [self.tableView reloadData];
        }
    } //Metric3 Name
    
    
    if (textField.tag == 4) {
        [self.stateData setValue:enteredText forKey:@"textFieldMetric1Unit"];
    } //Metric1 Unit
    
    if (textField.tag == 6) {
        [self.stateData setValue:enteredText forKey:@"textFieldMetric2Unit"];
    } //Metric2 Unit
    
    if (textField.tag == 8) {
        [self.stateData setValue:enteredText forKey:@"textFieldMetric3Unit"];
    } //Metric3 Unit
    
    return YES;
}

#pragma mark - Attribute change methods

- (void)hiddenAttributeSwitchSlid:(UISwitch *)sender
{
    [self.stateData setValue:[NSNumber numberWithBool:sender.isOn] forKey:@"switchHiddenByDefault"];
}

- (void)clearButtonPressed:(UIButton *)sender
{
    self.stateData = nil;
    [self.tableView reloadData];
}

- (void)submitButtonPressed:(UIButton *)sender
{
    if ([[self.stateData valueForKey:@"textFieldWorkoutName"] isEqualToString:@""] ||
        [[self.stateData valueForKey:@"textFieldMetric1Name"] isEqualToString:@""]) {
        if ([[self.stateData valueForKey:@"textFieldWorkoutName"] isEqualToString:@""] && [[self.stateData valueForKey:@"textFieldMetric1Name"] isEqualToString:@""]) {
            self.labelInWarningRow.text = @"Enter a workout name and metric";
        }
        else if ([[self.stateData valueForKey:@"textFieldWorkoutName"] isEqualToString:@""]) {
            self.labelInWarningRow.text = @"Enter a workout name.";
        }
        else if ([[self.stateData valueForKey:@"textFieldMetric1Name"] isEqualToString:@""]) {
            self.labelInWarningRow.text = @"Enter a metric.";
        }
    }
    else {
        sender.enabled = NO;
        [WorkoutTypes workoutTypeWithName:[self.stateData valueForKey:@"textFieldWorkoutName"]
                              metric1Name:[self.stateData valueForKey:@"textFieldMetric1Name"]
                       metric1DefaultUnit:[self.stateData valueForKey:@"textFieldMetric1Unit"]
                              metric2Name:[self.stateData valueForKey:@"textFieldMetric2Name"]
                       metric2DefaultUnit:[self.stateData valueForKey:@"textFieldMetric2Unit"]
                              metric3Name:[self.stateData valueForKey:@"textFieldMetric3Name"]
                       metric3DefaultUnit:[self.stateData valueForKey:@"textFieldMetric3Unit"]
                         hidddenByDefault:[NSNumber numberWithBool:self.switchForHiddenAttribute.isOn]
                   inManagedObjectContext:self.context];
        
        [self saveContext];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)checkIfWorkoutNameExists:(NSString *)workoutNameToBeChecked
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"WorkoutTypes" inManagedObjectContext:self.context];
	[fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
    NSSortDescriptor *workoutNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"workoutName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:workoutNameDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"workoutName = [cd] %@", workoutNameToBeChecked];
    
    NSError *error = nil;
	NSArray *fetchResults = [self.context executeFetchRequest:fetchRequest error:&error];
	if (fetchResults == nil) {
        //handle error
        return YES;
	}
	else {
        if (fetchResults.count > 0)
            return YES;
        else
            return NO;
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
    if (ANALYTICS_TRACKING == TRUE) {
        [self sendAnalyticsData];
    }
}

#pragma mark - Analytics method

- (void)sendAnalyticsData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults objectForKey:@"analyticsAddWorkoutType"]) {
        [[[GAI sharedInstance] defaultTracker] trackView:@"Add Workout Type"];
        [defaults setObject:[NSDate date] forKey:@"analyticsAddWorkoutType"];
    }
    else {
        NSDate *analyticsLastPostDate = [defaults objectForKey:@"analyticsAddWorkoutType"];
        NSDate *currentDate = [NSDate date];
        
        NSInteger analyticsLastPostDateDay = [[[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:analyticsLastPostDate] day];
        NSInteger currentDateDay = [[[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:currentDate] day];
        
        if (analyticsLastPostDateDay != currentDateDay) {
            [[[GAI sharedInstance] defaultTracker] trackView:@"Add Workout Type"];
            [defaults setObject:[NSDate date] forKey:@"analyticsAddWorkoutType"];
        }
    }
    
    [defaults synchronize];
}

@end
