//
//  EnterWorkoutDetailsViewController.m
//  SweatTrack
//
//  Created by Anand Kumar on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EnterWorkoutDetailsViewController.h"

#import "WorkoutTemplates.h"
#import "WorkoutsDone+Create.h"

#import "DatePickerView.h"
#import "WorkoutTemplatePickerView.h"
#import "WorkoutTypePickerView.h"

#import "DelimiterKeys.h"
#import "WorkoutTemplateDetailsViewController.h"

@interface EnterWorkoutDetailsViewController ()

@property (nonatomic, strong) UILabel *datePickedLabel1;
@property (nonatomic, strong) NSDate *selectedDate1;

@property (nonatomic, strong) UILabel *datePickedLabel2;
@property (nonatomic, strong) NSDate *selectedDate2;

@property (nonatomic, strong) DatePickerView *datePickerView;

@property (nonatomic, strong) UILabel *templatePickedLabel;
@property (nonatomic, strong) WorkoutTemplates *selectedWorkoutTemplate;
@property (nonatomic, strong) NSMutableArray *workoutTypesIncluded;

@property (nonatomic, strong) UILabel *workoutTypePickedLabel;
@property (nonatomic, strong) WorkoutTypes *selectedWorkoutType;

@property (nonatomic, strong) NSArray *workoutTemplatesInStore;
@property (nonatomic, strong) WorkoutTemplatePickerView *workoutTemplatePickerView;

@property (nonatomic, strong) NSArray *workoutTypesInStore;
@property (nonatomic, strong) WorkoutTypePickerView *workoutTypePickerView;

@property (nonatomic, strong) NSMutableArray *allTextFields1;
@property (nonatomic, strong) NSMutableArray *allTextFields2;

@property (nonatomic, strong) NSMutableArray *stateData1;
@property (nonatomic, strong) NSMutableDictionary *stateData2;

@property (nonatomic, strong) NSNumber *keyboardVisible;

@property (nonatomic, strong) NSNumber *currentTextFieldCellSection;
@property (nonatomic, strong) NSNumber *currentTextFieldCellRow;

@end

@implementation EnterWorkoutDetailsViewController

@synthesize switchScreenBarButtonItem = _switchScreenBarButtonItem;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize templateWorkoutScreenShown = _templateWorkoutScreenShown;

@synthesize datePickedLabel1 = _datePickedLabel1;
@synthesize selectedDate1 = _selectedDate1;

@synthesize datePickedLabel2 = _datePickedLabel2;
@synthesize selectedDate2 = _selectedDate2;

@synthesize datePickerView = _datePickerView;

@synthesize templatePickedLabel = _templatePickedLabel;
@synthesize selectedWorkoutTemplate = _selectedWorkoutTemplate;
@synthesize workoutTypesIncluded = workoutTypesIncluded;

@synthesize workoutTypePickedLabel = _workoutTypePickedLabel;
@synthesize selectedWorkoutType = _selectedWorkoutType;

@synthesize workoutTemplatesInStore = _workoutTemplatesInStore;
@synthesize workoutTemplatePickerView = _workoutTemplatePickerView;

@synthesize workoutTypesInStore = _workoutTypesInStore;
@synthesize workoutTypePickerView = _workoutTypePickerView;

@synthesize allTextFields1 = _allTextFields1;
@synthesize allTextFields2 = _allTextFields2;

@synthesize stateData1 = _stateData1;
@synthesize stateData2 = _stateData2;

@synthesize keyboardVisible = _keyboardVisible;

@synthesize currentTextFieldCellSection = _currentTextFieldCellSection;
@synthesize currentTextFieldCellRow = _currentTextFieldCellRow;

#pragma mark - Setter methods

- (void)setSelectedDate1:(NSDate *)selectedDate1
{
    _selectedDate1 = selectedDate1;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    if (self.datePickedLabel1) {
        self.datePickedLabel1.text = [dateFormatter stringFromDate:self.selectedDate1];
    }
}

- (void)setSelectedDate2:(NSDate *)selectedDate2
{
    _selectedDate2 = selectedDate2;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    if (self.datePickedLabel2) {
        self.datePickedLabel2.text = [dateFormatter stringFromDate:self.selectedDate2];
    }
}

#pragma mark - View life cycle methods

- (void)templateWorkoutViewWillAppear
{
    [self getWorkoutTemplatesInStore];
    
    if (!self.selectedWorkoutTemplate.workoutTemplateName){
        if (self.workoutTemplatesInStore.count > 0) {
            self.selectedWorkoutTemplate = [self.workoutTemplatesInStore objectAtIndex:0];
        }
    }
    
    [self addObjectsToStateData1];
    
    self.allTextFields1 = [[NSMutableArray alloc] init];
}

- (void)templateWorkoutViewDidAppear
{   
    if (!self.selectedDate1) {
        self.selectedDate1 = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    self.switchScreenBarButtonItem.title = @"Single";
    
    self.datePickedLabel1.text = [dateFormatter stringFromDate:self.selectedDate1];
    
    self.templatePickedLabel.text = self.selectedWorkoutTemplate.workoutTemplateName;
}

- (void)templateWorkoutViewDidDisappear
{
    if (self.datePickerView) {
        self.datePickerView.hidden = YES;
        self.datePickerView = nil;
    }
    if (self.workoutTemplatePickerView) {
        self.workoutTemplatePickerView.hidden = YES;
        self.workoutTemplatePickerView = nil;
    }
    
    for (UITextField *otherTextField in self.allTextFields1) {
        otherTextField.userInteractionEnabled = YES;
    }
    
    self.allTextFields1 = nil;
    
    self.tableView.scrollEnabled = YES;
}


- (void)singleWorkoutViewWillAppear
{
    [self getWorkoutTypesInStore];
    
    if (!self.selectedWorkoutType.workoutName){
        if (self.workoutTypesInStore.count > 0) {
            self.selectedWorkoutType = [self.workoutTypesInStore objectAtIndex:0];
        }
    }
    
    [self addObjectsToStateData2];
    
    self.allTextFields2 = [[NSMutableArray alloc] init];
}

- (void)singleWorkoutViewDidAppear
{
    if (!self.selectedDate2) {
        self.selectedDate2 = [NSDate date];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    self.switchScreenBarButtonItem.title = @"Template";
    
    self.datePickedLabel2.text = [dateFormatter stringFromDate:self.selectedDate2];
    
    self.workoutTypePickedLabel.text = self.selectedWorkoutType.workoutName;
}

- (void)singleWorkoutViewDidDisappear
{
    if (self.datePickerView) {
        self.datePickerView.hidden = YES;
        self.datePickerView = nil;
    }
    if (self.workoutTypePickerView) {
        self.workoutTypePickerView.hidden = YES;
        self.workoutTypePickerView = nil;
    }
    
    for (UITextField *otherTextField in self.allTextFields2) {
        otherTextField.userInteractionEnabled = YES;
    }
    
    self.allTextFields2 = nil;
    
    self.tableView.scrollEnabled = YES;
}


- (IBAction)switchScreen:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    UIViewAnimationOptions animationType;    
    
    typedef void (^customViewWillAppear) ();
    customViewWillAppear customViewToAppear;
    
    if (self.templateWorkoutScreenShown.boolValue == YES) {
        
        for (UITextField *textField in self.allTextFields1) {
            if (textField.editing == YES) {
                [self updateValueInStateData1:textField];
                break;
            }
        }
        
        [self templateWorkoutViewDidDisappear];
        self.templateWorkoutScreenShown = [NSNumber numberWithBool:NO];
        [defaults setObject:self.templateWorkoutScreenShown forKey:@"templateWorkoutScreenShown"];
        [defaults synchronize];
        
        [self singleWorkoutViewWillAppear];
        
        animationType = UIViewAnimationOptionTransitionFlipFromLeft;
        customViewToAppear = ^() {[self singleWorkoutViewDidAppear];};
    }
    
    else if (self.templateWorkoutScreenShown.boolValue == NO) {
        for (UITextField *textField in self.allTextFields2) {
            if (textField.editing == YES) {
                [self updateValueInStateData2:textField];
                break;
            }
        }
        
        [self singleWorkoutViewDidDisappear];
        self.templateWorkoutScreenShown = [NSNumber numberWithBool:YES];
        [defaults setObject:self.templateWorkoutScreenShown forKey:@"templateWorkoutScreenShown"];
        [defaults synchronize];
        
        [self templateWorkoutViewWillAppear];
        
        animationType = UIViewAnimationOptionTransitionFlipFromRight;
        customViewToAppear = ^() {[self templateWorkoutViewDidAppear];};
    }
    
    [UIView transitionWithView:self.view 
                      duration:0.5 
                       options:animationType 
                    animations:^{[self.tableView reloadData];} 
                    completion:^(BOOL finished){customViewToAppear();}];
}


- (void)viewWillAppear:(BOOL)animated
{   
    [super viewWillAppear:animated];
    
    if (!self.templateWorkoutScreenShown) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (![defaults objectForKey:@"templateWorkoutScreenShown"]) {
            [defaults setObject:[NSNumber numberWithBool:NO] forKey:@"templateWorkoutScreenShown"];
            [defaults synchronize];
        }
        self.templateWorkoutScreenShown = [defaults objectForKey:@"templateWorkoutScreenShown"];
    } //Get value of templateWorkoutScreenShown from the NSUserDefaults key
    
    if (self.templateWorkoutScreenShown.boolValue == YES) {
        [self templateWorkoutViewWillAppear];
    }
    else if (self.templateWorkoutScreenShown.boolValue == NO) {
        [self singleWorkoutViewWillAppear];
    } //Call appropriate viewWillAppear method depending on view shown
    
    self.keyboardVisible = [NSNumber numberWithBool:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.tableView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.templateWorkoutScreenShown.boolValue == YES) {
        [self templateWorkoutViewDidAppear];        
    }
    
    else if (self.templateWorkoutScreenShown.boolValue == NO) {
        [self singleWorkoutViewDidAppear];
    }
    
    self.tableView.scrollEnabled = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{       
    if (self.templateWorkoutScreenShown.boolValue == YES) {
        [self templateWorkoutViewDidDisappear];
    }
    
    else if (self.templateWorkoutScreenShown.boolValue == NO) {
        [self singleWorkoutViewDidDisappear];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];   //Unregister from keyboard notification, else they may start piling
    
    [super viewDidDisappear:animated];
}

#pragma mark - TableView Datasource and Delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{   
    for (id viewController in self.navigationController.tabBarController.viewControllers) {
        if ([viewController isMemberOfClass:[UINavigationController class]]) {
            if ([[viewController valueForKey:@"topViewController"] isMemberOfClass:[WorkoutTemplateDetailsViewController class]]) {
                [[viewController valueForKey:@"topViewController"] performSelector:@selector(updateTemplateOrder)];
                break;
            }
        }
    }//Just done as a precaution, so that the change in template order has been commited in WorkoutTemplateDetailsViewController before the table in this view loads. This order should actually commit anyway becuase the updateTemplateOrder method is called in the viewWillDisappear: method of WorkoutTemplateDetailsViewController
    
    int sectionsForWorkoutTypes = 0;
    
    if (self.templateWorkoutScreenShown.boolValue == YES) {
        NSMutableArray *workoutTypesOrder = [NSMutableArray arrayWithArray:[self.selectedWorkoutTemplate.workoutTypesOrder componentsSeparatedByString:WORKOUTORDER_DELIMITER]];
        
        self.workoutTypesIncluded = [[NSMutableArray alloc] init];
        for (NSString *workoutName in workoutTypesOrder) {
            for (WorkoutTypes *workoutType in self.selectedWorkoutTemplate.workoutTypesIncluded) {
                if ([workoutName isEqualToString:workoutType.workoutName]) {
                    [self.workoutTypesIncluded addObject:workoutType];
                    break;
                }
            }
        }//Populate the workoutTypesIncluded array by double checking that the workout types are present in both the template as well as the workoutTypesOrder attribute. (Is this double check really needed?)
        
        [self addObjectsToStateData1];
        sectionsForWorkoutTypes = self.selectedWorkoutTemplate.workoutTypesIncluded.count;
    }
    
    else if (self.templateWorkoutScreenShown.boolValue == NO) {
        [self addObjectsToStateData2];
        if (self.selectedWorkoutType.workoutName) {
            sectionsForWorkoutTypes = 1;
        }
        else {
            sectionsForWorkoutTypes = 0;
        }
    }
    
    return (3 + sectionsForWorkoutTypes);
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowsCount = 1;
    
    if (section > 2) {
        int metricsCount = 0;
        
        if (self.templateWorkoutScreenShown.boolValue == YES) {
            if (![[[self.workoutTypesIncluded objectAtIndex:(section - 3)] valueForKey:@"workoutMetric1Name"] isEqualToString:@""]) {
                metricsCount++;
            }
            if (![[[self.workoutTypesIncluded objectAtIndex:(section - 3)] valueForKey:@"workoutMetric2Name"] isEqualToString:@""]) {
                metricsCount++;
            }
            if (![[[self.workoutTypesIncluded objectAtIndex:(section - 3)] valueForKey:@"workoutMetric3Name"] isEqualToString:@""]) {
                metricsCount++;
            }
        }
        
        else if (self.templateWorkoutScreenShown.boolValue == NO) {
            if (![self.selectedWorkoutType.workoutMetric1Name isEqualToString:@""]) {
                metricsCount++;
            }
            if (![self.selectedWorkoutType.workoutMetric2Name isEqualToString:@""]) {
                metricsCount++;
            }
            if (![self.selectedWorkoutType.workoutMetric3Name isEqualToString:@""]) {
                metricsCount++;
            }
        }
        
        rowsCount = metricsCount;
    }
    
    return rowsCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{   
    NSString *sectionHeader = @"";
    
    if (section > 2) {
        if (self.templateWorkoutScreenShown.boolValue == YES) {
            sectionHeader = [[self.workoutTypesIncluded objectAtIndex:(section - 3)] valueForKey:@"workoutName"];
        }
        
        else if (self.templateWorkoutScreenShown.boolValue == NO) {
            sectionHeader = @"";
        }
    }
    
    return sectionHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    // Configure the cell...
    if (indexPath.section == 0) {
        
        CGRect frame1 = CGRectMake(18.0, 9.0, 100.0, 27.0);
        CGRect frame2 = CGRectMake(178.0, 9.0, 100.0, 27.0);
        
        UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        clearButton.frame = frame1;
        [clearButton setTitle:@"Clear" forState:UIControlStateNormal];
        clearButton.titleLabel.textColor = [UIColor whiteColor];
        clearButton.enabled = YES;
        [clearButton addTarget:self action:@selector(clearButtonPressed:) forControlEvents:UIControlEventTouchDown];
        
        UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        submitButton.frame = frame2;
        [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
        submitButton.titleLabel.textColor = [UIColor whiteColor];
        submitButton.enabled = YES;
        [submitButton addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchDown];
        
        [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [cell.contentView addSubview:clearButton];
        [cell.contentView addSubview:submitButton];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
        backView.backgroundColor = [UIColor clearColor];
        cell.backgroundView = backView;
        
    }
    
    if (indexPath.section == 1) {
        
        cell.textLabel.text = @"Date";
        
        if (self.templateWorkoutScreenShown.boolValue == YES) {
            self.datePickedLabel1 = [[UILabel alloc] init]; 
            CGRect frame = CGRectMake(108.0, 9.0, 180.0, 27.0);
            self.datePickedLabel1 = [[UILabel alloc] initWithFrame:frame];
            self.datePickedLabel1.backgroundColor = [UIColor clearColor];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            self.datePickedLabel1.text = [dateFormatter stringFromDate:self.selectedDate1];
            
            [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [cell.contentView addSubview:self.datePickedLabel1];
        }
        
        else if (self.templateWorkoutScreenShown.boolValue == NO) {
            self.datePickedLabel2 = [[UILabel alloc] init]; 
            CGRect frame = CGRectMake(108.0, 9.0, 180.0, 27.0);
            self.datePickedLabel2 = [[UILabel alloc] initWithFrame:frame];
            self.datePickedLabel2.backgroundColor = [UIColor clearColor];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            self.datePickedLabel2.text = [dateFormatter stringFromDate:self.selectedDate2];
            
            [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [cell.contentView addSubview:self.datePickedLabel2];
        }
    }
    
    if (indexPath.section == 2) {
        
        if (self.templateWorkoutScreenShown.boolValue == YES) {
            cell.textLabel.text = @"Template";
            
            self.templatePickedLabel = [[UILabel alloc] init]; 
            CGRect frame = CGRectMake(108.0, 9.0, 180.0, 27.0);
            self.templatePickedLabel = [[UILabel alloc] initWithFrame:frame];
            self.templatePickedLabel.backgroundColor = [UIColor clearColor];
            
            self.templatePickedLabel.text = self.selectedWorkoutTemplate.workoutTemplateName;
            
            [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [cell.contentView addSubview:self.templatePickedLabel];
        }
        
        else if (self.templateWorkoutScreenShown.boolValue == NO) {
            cell.textLabel.text = @"Workout";
            
            self.workoutTypePickedLabel = [[UILabel alloc] init]; 
            CGRect frame = CGRectMake(108.0, 9.0, 180.0, 27.0);
            self.workoutTypePickedLabel = [[UILabel alloc] initWithFrame:frame];
            self.workoutTypePickedLabel.backgroundColor = [UIColor clearColor];
            
            self.workoutTypePickedLabel.text = self.selectedWorkoutType.workoutName;
            
            [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [cell.contentView addSubview:self.workoutTypePickedLabel];
        }
    }
    
    if (indexPath.section > 2) {
        
        //Populate cell.textLabel.text to show metricName and metricDefaultUnit using self.workoutTypesIncluded
        NSString *metricName, *metricDefaultUnit;
        
        if (self.templateWorkoutScreenShown.boolValue == YES) {
            switch (indexPath.row) {
                case 0:
                    metricName = [[self.workoutTypesIncluded objectAtIndex:(indexPath.section - 3)] valueForKey:@"workoutMetric1Name"];
                    metricDefaultUnit = [[self.workoutTypesIncluded objectAtIndex:(indexPath.section - 3)] valueForKey:@"workoutMetric1DefaultUnit"];
                    break;
                    
                case 1:
                    metricName = [[self.workoutTypesIncluded objectAtIndex:(indexPath.section - 3)] valueForKey:@"workoutMetric2Name"];
                    metricDefaultUnit = [[self.workoutTypesIncluded objectAtIndex:(indexPath.section - 3)] valueForKey:@"workoutMetric2DefaultUnit"];
                    break;
                    
                case 2:
                    metricName = [[self.workoutTypesIncluded objectAtIndex:(indexPath.section - 3)] valueForKey:@"workoutMetric3Name"];
                    metricDefaultUnit = [[self.workoutTypesIncluded objectAtIndex:(indexPath.section - 3)] valueForKey:@"workoutMetric3DefaultUnit"];
                    break;
                    
                default:
                    metricName = @"";
                    metricDefaultUnit = @"";
                    break;
            }
        }
        
        else if (self.templateWorkoutScreenShown.boolValue == NO) {
            switch (indexPath.row) {
                case 0:
                    metricName = self.selectedWorkoutType.workoutMetric1Name;
                    metricDefaultUnit = self.selectedWorkoutType.workoutMetric1DefaultUnit;
                    break;
                    
                case 1:
                    metricName = self.selectedWorkoutType.workoutMetric2Name;
                    metricDefaultUnit = self.selectedWorkoutType.workoutMetric2DefaultUnit;
                    break;
                    
                case 2:
                    metricName = self.selectedWorkoutType.workoutMetric3Name;
                    metricDefaultUnit = self.selectedWorkoutType.workoutMetric3DefaultUnit;
                    break;
                    
                default:
                    metricName = @"";
                    metricDefaultUnit = @"";
                    break;
            }
        }
        
        cell.textLabel.text = metricName;
        if (![metricDefaultUnit isEqualToString:@""] && ([metricDefaultUnit caseInsensitiveCompare:metricName] != NSOrderedSame)){
            cell.textLabel.text = [cell.textLabel.text stringByAppendingString:@" ("];
            cell.textLabel.text = [cell.textLabel.text stringByAppendingString:metricDefaultUnit];
            cell.textLabel.text = [cell.textLabel.text stringByAppendingString:@")"];
        }
        
        
        //Populate workoutValue in cell using workoutName in workoutTypesInclude to match workoutName in any object of stateData
        UITextField *workoutValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(128.0, 9.0, 160.0, 27.0)];
        workoutValueTextField.delegate = self;
        workoutValueTextField.adjustsFontSizeToFitWidth = YES;
        workoutValueTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        workoutValueTextField.textAlignment = UITextAlignmentRight;
        workoutValueTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        workoutValueTextField.text = @"";
        
        if (self.templateWorkoutScreenShown.boolValue == YES) {
            NSString *workoutName = [[self.workoutTypesIncluded objectAtIndex:(indexPath.section - 3)] valueForKey:@"workoutName"];
            
            for (NSMutableDictionary *tempDictionary in self.stateData1) {
                if ([[[tempDictionary valueForKey:@"workoutType"] valueForKey:@"workoutName"] isEqualToString:workoutName]) {
                    switch (indexPath.row) {
                        case 0:
                            workoutValueTextField.text = [tempDictionary valueForKey:@"workoutMetric1Value"];
                            break;
                        case 1:
                            workoutValueTextField.text = [tempDictionary valueForKey:@"workoutMetric2Value"];
                            break;
                        case 2:
                            workoutValueTextField.text = [tempDictionary valueForKey:@"workoutMetric3Value"];
                            break;
                        default:
                            break;
                    }
                }
            }
            
            [self.allTextFields1 addObject:workoutValueTextField];
        }
        
        else if (self.templateWorkoutScreenShown.boolValue == NO) {
            
            switch (indexPath.row) {
                case 0:
                    workoutValueTextField.text = [self.stateData2 valueForKey:@"workoutMetric1Value"];
                    break;
                case 1:
                    workoutValueTextField.text = [self.stateData2 valueForKey:@"workoutMetric2Value"];
                    break;
                case 2:
                    workoutValueTextField.text = [self.stateData2 valueForKey:@"workoutMetric3Value"];
                    break;
                default:
                    break;
            }
            
            [self.allTextFields2 addObject:workoutValueTextField];
        }
        
        [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [cell addSubview:workoutValueTextField];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if ([self.keyboardVisible boolValue] == NO) {
            
            //Set up Date Picker
            if (!self.datePickerView) {
                self.datePickerView = [[DatePickerView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.size.height*0.7, self.view.frame.size.width, self.view.frame.size.height*0.3)];
                self.datePickerView.hidden = YES;
                [self.datePickerView addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
                
                [self.view addSubview:self.datePickerView];
            }
            
            if (self.templateWorkoutScreenShown.boolValue == YES) {
                
                if (self.workoutTemplatePickerView) {
                    self.workoutTemplatePickerView.hidden = YES;
                }
                
                if (self.datePickerView.hidden) {
                    self.tableView.scrollEnabled = NO;
                    [self.datePickerView setDate:self.selectedDate1 animated:NO];
                    self.datePickerView.hidden = NO;
                    
                    for (UITextField *otherTextField in self.allTextFields1) {
                        otherTextField.userInteractionEnabled = NO;
                    }
                }
                else {
                    self.datePickerView.hidden = YES;
                    self.datePickerView = nil;
                    self.tableView.scrollEnabled = YES;
                    
                    for (UITextField *otherTextField in self.allTextFields1) {
                        otherTextField.userInteractionEnabled = YES;
                    }
                }
            }
            
            else if (self.templateWorkoutScreenShown.boolValue == NO) {
                if (self.workoutTypePickerView) {
                    self.workoutTypePickerView.hidden = YES;
                }
                
                if (self.datePickerView.hidden) {
                    self.tableView.scrollEnabled = NO;
                    [self.datePickerView setDate:self.selectedDate2 animated:NO];
                    self.datePickerView.hidden = NO;
                    
                    for (UITextField *otherTextField in self.allTextFields2) {
                        otherTextField.userInteractionEnabled = NO;
                    }
                }
                else {
                    self.datePickerView.hidden = YES;
                    self.datePickerView = nil;
                    self.tableView.scrollEnabled = YES;
                    
                    for (UITextField *otherTextField in self.allTextFields2) {
                        otherTextField.userInteractionEnabled = YES;
                    }
                }
            }
        }
    }
    
    if (indexPath.section == 2) {
        if ([self.keyboardVisible boolValue] == NO) {
            if (self.templateWorkoutScreenShown.boolValue == YES) {
                //Set up Workout Template Picker. 
                if (!self.workoutTemplatePickerView) {
                    self.workoutTemplatePickerView = [[WorkoutTemplatePickerView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.size.height*0.7, self.view.frame.size.width, self.view.frame.size.height*0.3) andContext:self.managedObjectContext];
                    
                    self.workoutTemplatePickerView.dataSource = self.workoutTemplatePickerView;
                    self.workoutTemplatePickerView.delegate = self.workoutTemplatePickerView;
                    self.workoutTemplatePickerView.hidden = YES;
                    
                    [self.workoutTemplatePickerView addObserver:self 
                                                     forKeyPath:@"selectedWorkoutTemplate" 
                                                        options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) 
                                                        context:NULL];
                    
                    
                    [self.view addSubview:self.workoutTemplatePickerView];
                }
                
                if (self.datePickerView) {
                    self.datePickerView.hidden = YES;
                }
                
                if (self.workoutTemplatePickerView.hidden) {
                    self.tableView.scrollEnabled = NO;
                    for (UITextField *textField in self.allTextFields1) {
                        textField.userInteractionEnabled = NO;
                    }
                    [self.workoutTemplatePickerView ifAvailableShowOption:self.selectedWorkoutTemplate.workoutTemplateName];
                    self.workoutTemplatePickerView.hidden = NO;
                }
                else {
                    self.workoutTemplatePickerView.hidden = YES;
                    self.workoutTemplatePickerView = nil;
                    for (UITextField *textField in self.allTextFields1) {
                        textField.userInteractionEnabled = YES;
                    }
                    self.tableView.scrollEnabled = YES;
                }
            }
            
            else if (self.templateWorkoutScreenShown.boolValue == NO) {
                //Set up Workout Type Picker. 
                if (!self.workoutTypePickerView) {
                    self.workoutTypePickerView = [[WorkoutTypePickerView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.size.height*0.7, self.view.frame.size.width, self.view.frame.size.height*0.3) andContext:self.managedObjectContext];
                    
                    self.workoutTypePickerView.dataSource = self.workoutTypePickerView;
                    self.workoutTypePickerView.delegate = self.workoutTypePickerView;
                    self.workoutTypePickerView.hidden = YES;
                    
                    [self.workoutTypePickerView addObserver:self 
                                                 forKeyPath:@"selectedWorkoutType" 
                                                    options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) 
                                                    context:NULL];
                    
                    
                    [self.view addSubview:self.workoutTypePickerView];
                }
                
                if (self.datePickerView) {
                    self.datePickerView.hidden = YES;
                }
                
                if (self.workoutTypePickerView.hidden) {
                    self.tableView.scrollEnabled = NO;
                    for (UITextField *textField in self.allTextFields2) {
                        textField.userInteractionEnabled = NO;
                    }
                    [self.workoutTypePickerView ifAvailableShowOption:self.selectedWorkoutType.workoutName];
                    self.workoutTypePickerView.hidden = NO;
                }
                else {
                    self.workoutTypePickerView.hidden = YES;
                    self.workoutTypePickerView = nil;
                    for (UITextField *textField in self.allTextFields2) {
                        textField.userInteractionEnabled = YES;
                    }
                    self.tableView.scrollEnabled = YES;
                }
            }
        }
    }
    
    if (indexPath.section > 2) {
        
    }
    
}


- (void)datePickerValueChanged:(DatePickerView *)sender
{
    if (self.templateWorkoutScreenShown.boolValue == YES) {
        self.selectedDate1 = sender.date;
    }
    
    else if (self.templateWorkoutScreenShown.boolValue == NO) {
        self.selectedDate2 = sender.date;
    }
    
}


#pragma mark - KVO methods
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"selectedWorkoutTemplate"]) {
        for (WorkoutTemplates *workoutTemplate in self.workoutTemplatesInStore) {
            if ([workoutTemplate.workoutTemplateName isEqualToString:[change objectForKey:NSKeyValueChangeNewKey]]) {
                self.workoutTemplatePickerView.hidden = YES;
                self.selectedWorkoutTemplate = workoutTemplate;
                self.templatePickedLabel.text = [change objectForKey:NSKeyValueChangeNewKey];
                self.tableView.scrollEnabled = YES;
                for (UITextField *textField in self.allTextFields1) {
                    textField.userInteractionEnabled = YES;
                }
                [self addObjectsToStateData1];
                
                [self.tableView reloadData];
                break;
            }
        }
    }
    
    if ([keyPath isEqualToString:@"selectedWorkoutType"]) {
        for (WorkoutTypes *workoutType in self.workoutTypesInStore) {
            if ([workoutType.workoutName isEqualToString:[change objectForKey:NSKeyValueChangeNewKey]]) {
                self.workoutTypePickerView.hidden = YES;
                self.selectedWorkoutType = workoutType;
                self.workoutTypePickedLabel.text = [change objectForKey:NSKeyValueChangeNewKey];
                self.tableView.scrollEnabled = YES;
                for (UITextField *textField in self.allTextFields2) {
                    textField.userInteractionEnabled = YES;
                }
                [self addObjectsToStateData2];
                
                [self.tableView reloadData];
                break;
            }
        }
    }
}

- (void)keyboardDidShow: (NSNotification *)notification
{
    self.keyboardVisible = [NSNumber numberWithBool:YES];
}

- (void)keyboardDidHide: (NSNotification *)notification 
{
    self.keyboardVisible = [NSNumber numberWithBool:NO];
}

#pragma mark - Methods to maintain state

- (void)addObjectsToStateData1
{   
    if (!self.stateData1) {
        self.stateData1 = [[NSMutableArray alloc] init];
    } //If stateData1 does not exist, instantiate it as a NSMutableArray. Every object in this array will later be a mutable dictionary.
    
    NSMutableArray *workoutTypesDefaultValues = [NSMutableArray arrayWithArray:[self.selectedWorkoutTemplate.workoutTypesDefaultValues componentsSeparatedByString:WORKOUTORDER_DELIMITER]];
    
    
    for (WorkoutTypes *workoutTypeInTemplate in self.selectedWorkoutTemplate.workoutTypesIncluded) {
        
        NSInteger index = [workoutTypesDefaultValues indexOfObject:workoutTypeInTemplate.workoutName];
        
        BOOL workoutTypeAlreadyPresentInState1 = NO;
        
        for (NSMutableDictionary *tempDictionary in self.stateData1) {
            if ([[[tempDictionary valueForKey:@"workoutType"] valueForKey:@"workoutName"] isEqualToString:workoutTypeInTemplate.workoutName]) {
                workoutTypeAlreadyPresentInState1 = YES;
                
                NSNumber *workoutMetric1ValueEdited = [tempDictionary valueForKey:@"workoutMetric1ValueEdited"];
                NSNumber *workoutMetric2ValueEdited = [tempDictionary valueForKey:@"workoutMetric2ValueEdited"];
                NSNumber *workoutMetric3ValueEdited = [tempDictionary valueForKey:@"workoutMetric3ValueEdited"];
                
                if (workoutMetric1ValueEdited.boolValue == NO) {
                    [tempDictionary setValue:[workoutTypesDefaultValues objectAtIndex:(index+1)] forKey:@"workoutMetric1Value"];
                }
                if (workoutMetric2ValueEdited.boolValue == NO) {
                    [tempDictionary setValue:[workoutTypesDefaultValues objectAtIndex:(index+2)] forKey:@"workoutMetric2Value"];
                }
                if (workoutMetric3ValueEdited.boolValue == NO) {
                    [tempDictionary setValue:[workoutTypesDefaultValues objectAtIndex:(index+3)] forKey:@"workoutMetric3Value"];
                }
                
                break;
            }
        }//Iterate through all the objects in stateData1 and check if the current workout type has already been added to stateData1. Also if it has been added but any of its metrics not edited, populate that metric with current template's default value.
        
        if (workoutTypeAlreadyPresentInState1 == NO) {
            NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
            [tempDictionary setValue:workoutTypeInTemplate forKey:@"workoutType"];
            [tempDictionary setValue:[workoutTypesDefaultValues objectAtIndex:(index+1)] forKey:@"workoutMetric1Value"];
            [tempDictionary setValue:[NSNumber numberWithBool:NO] forKey:@"workoutMetric1ValueEdited"];
            [tempDictionary setValue:[workoutTypesDefaultValues objectAtIndex:(index+2)] forKey:@"workoutMetric2Value"];
            [tempDictionary setValue:[NSNumber numberWithBool:NO] forKey:@"workoutMetric2ValueEdited"];
            [tempDictionary setValue:[workoutTypesDefaultValues objectAtIndex:(index+3)] forKey:@"workoutMetric3Value"];
            [tempDictionary setValue:[NSNumber numberWithBool:NO] forKey:@"workoutMetric3ValueEdited"];
            
            [self.stateData1 addObject:tempDictionary];
        }//If the current workout type has not been added to stateData1, add it along with the default values
        
    }//Iterate through all workout types in selected workout template
}

- (void)updateValueInStateData1:(UITextField *)textField
{
    NSUInteger section = [self.currentTextFieldCellSection intValue];
    NSUInteger row = [self.currentTextFieldCellRow intValue];
    
    NSString *workoutName = [[self.workoutTypesIncluded objectAtIndex:(section - 3)] valueForKey:@"workoutName"];
    NSString *enteredText = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    for (NSMutableDictionary *tempDictionary in self.stateData1) {
        if ([[[tempDictionary valueForKey:@"workoutType"] valueForKey:@"workoutName"] isEqualToString:workoutName]) {
            switch (row) {
                case 0:
                    [tempDictionary setValue:enteredText forKey:@"workoutMetric1Value"];
                    [tempDictionary setValue:[NSNumber numberWithBool:YES] forKey:@"workoutMetric1ValueEdited"];
                    break;
                case 1:
                    [tempDictionary setValue:enteredText forKey:@"workoutMetric2Value"];
                    [tempDictionary setValue:[NSNumber numberWithBool:YES] forKey:@"workoutMetric2ValueEdited"];
                    break;
                case 2:
                    [tempDictionary setValue:enteredText forKey:@"workoutMetric3Value"];
                    [tempDictionary setValue:[NSNumber numberWithBool:YES] forKey:@"workoutMetric3ValueEdited"];
                    break;
                default:
                    break;
            }
            break;
        }
    }//Iterate through all the objects in stateData1 and for the matching workout type and metric, update the value
    
}

- (void)addObjectsToStateData2
{
    if (!self.stateData2) {
        self.stateData2 = [[NSMutableDictionary alloc] init];
        
        [self.stateData2 setValue:self.selectedWorkoutType forKey:@"workoutType"];
        [self.stateData2 setValue:@"" forKey:@"workoutMetric1Value"];
        [self.stateData2 setValue:@"" forKey:@"workoutMetric2Value"];
        [self.stateData2 setValue:@"" forKey:@"workoutMetric3Value"];
    }
    
    if (![[[self.stateData2 valueForKey:@"workoutType"] valueForKey:@"workoutName"] isEqualToString:self.selectedWorkoutType.workoutName]) {
        [self.stateData2 setValue:self.selectedWorkoutType forKey:@"workoutType"];
        [self.stateData2 setValue:@"" forKey:@"workoutMetric1Value"];
        [self.stateData2 setValue:@"" forKey:@"workoutMetric2Value"];
        [self.stateData2 setValue:@"" forKey:@"workoutMetric3Value"];        
    }
    
}

- (void)updateValueInStateData2:(UITextField *)textField
{
    UITableViewCell *cell = [textField valueForKey:@"superview"];
    
    NSUInteger row = [self.tableView indexPathForCell:cell].row;
    
    NSString *enteredText = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    switch (row) {
        case 0:
            [self.stateData2 setValue:enteredText forKey:@"workoutMetric1Value"];
            break;
        case 1:
            [self.stateData2 setValue:enteredText forKey:@"workoutMetric2Value"];
            break;
        case 2:
            [self.stateData2 setValue:enteredText forKey:@"workoutMetric3Value"];
            break;
        default:
            break;
    }
}

- (void)updateStateDataWhenMetricIsDeleted:(NSNumber *)metricDeleted inWorkoutType:(WorkoutTypes *)workoutType
{
    for (NSMutableDictionary *tempDictionary in self.stateData1) {
        if ([[[tempDictionary valueForKey:@"workoutType"] valueForKey:@"workoutName"] isEqualToString:workoutType.workoutName]) {
            switch ([metricDeleted intValue]) {
                case 1:
                    [tempDictionary setValue:[tempDictionary valueForKey:@"workoutMetric2Value"] forKey:@"workoutMetric1Value"];
                    [tempDictionary setValue:[tempDictionary valueForKey:@"workoutMetric3Value"] forKey:@"workoutMetric2Value"];
                    [tempDictionary setValue:@"" forKey:@"workoutMetric3Value"];
                    [tempDictionary setValue:[tempDictionary valueForKey:@"workoutMetric2ValueEdited"] forKey:@"workoutMetric1ValueEdited"];
                    [tempDictionary setValue:[tempDictionary valueForKey:@"workoutMetric3ValueEdited"] forKey:@"workoutMetric2ValueEdited"];
                    [tempDictionary setValue:nil forKey:@"workoutMetric3ValueEdited"];
                    break;
                case 2:
                    [tempDictionary setValue:[tempDictionary valueForKey:@"workoutMetric3Value"] forKey:@"workoutMetric2Value"];
                    [tempDictionary setValue:@"" forKey:@"workoutMetric3Value"];
                    [tempDictionary setValue:[tempDictionary valueForKey:@"workoutMetric3ValueEdited"] forKey:@"workoutMetric2ValueEdited"];
                    [tempDictionary setValue:nil forKey:@"workoutMetric3ValueEdited"];
                    break;
                case 3:
                    [tempDictionary setValue:@"" forKey:@"workoutMetric3Value"];
                    [tempDictionary setValue:nil forKey:@"workoutMetric3ValueEdited"];
                    break;
                default:
                    break;
            }
            break;
        }
    }
    
    if ([[[self.stateData2 valueForKey:@"workoutType"] valueForKey:@"workoutName"] isEqualToString:workoutType.workoutName]) {
        switch ([metricDeleted intValue]) {
            case 1:
                [self.stateData2 setValue:[self.stateData2 valueForKey:@"workoutMetric2Value"] forKey:@"workoutMetric1Value"];
                [self.stateData2 setValue:[self.stateData2 valueForKey:@"workoutMetric3Value"] forKey:@"workoutMetric2Value"];
                [self.stateData2 setValue:@"" forKey:@"workoutMetric3Value"];
                break;
            case 2:
                [self.stateData2 setValue:[self.stateData2 valueForKey:@"workoutMetric3Value"] forKey:@"workoutMetric2Value"];
                [self.stateData2 setValue:@"" forKey:@"workoutMetric3Value"];
                break;
            case 3:
                [self.stateData2 setValue:@"" forKey:@"workoutMetric3Value"];
                break;
            default:
                break;
        }
    }
}

#pragma mark - Methods accessing data store

- (void)getWorkoutTemplatesInStore
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"WorkoutTemplates" inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
    NSSortDescriptor *workoutNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"workoutTemplateName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:workoutNameDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
	self.workoutTemplatesInStore = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

- (void)getWorkoutTypesInStore
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"WorkoutTypes" inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
    NSSortDescriptor *workoutNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"workoutName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:workoutNameDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
	self.workoutTypesInStore = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - TextField delegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UITableViewCell *cell = [textField valueForKey:@"superview"];
    self.currentTextFieldCellSection = [NSNumber numberWithInt:[self.tableView indexPathForCell:cell].section];
    self.currentTextFieldCellRow = [NSNumber numberWithInt:[self.tableView indexPathForCell:cell].row];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{   
    if (self.templateWorkoutScreenShown.boolValue == YES) {
        [self updateValueInStateData1:textField];
    }
    
    else if (self.templateWorkoutScreenShown.boolValue == NO) {
        [self updateValueInStateData2:textField];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Buttons' responder methods


- (void)submitButtonPressed:(UIButton *)sender
{  

    NSString *workoutName;
    NSString *metric1Name, *metric1DefaultUnit, *metric2Name, *metric2DefaultUnit, *metric3Name, *metric3DefaultUnit;
    NSString *metric1Value, *metric2Value, *metric3Value;
    
    if (self.templateWorkoutScreenShown.boolValue == YES) {
        
        for (UITextField *textField in self.allTextFields1) {
            if (textField.editing == YES) {
                [self updateValueInStateData1:textField];
            }
        }
        
        for (int i = 3; i < [self numberOfSectionsInTableView:self.tableView] ; i++) {
            
            workoutName = [self tableView:self.tableView titleForHeaderInSection:i];
            
            for (NSMutableDictionary *tempDictionary in self.stateData1) {
                if ([[[tempDictionary valueForKey:@"workoutType"] valueForKey:@"workoutName"] isEqualToString:workoutName]) {
                    
                    metric1Name = [[tempDictionary valueForKey:@"workoutType"] valueForKey:@"workoutMetric1Name"];
                    metric1DefaultUnit = [[tempDictionary valueForKey:@"workoutType"] valueForKey:@"workoutMetric1DefaultUnit"];
                    metric1Value = [tempDictionary valueForKey:@"workoutMetric1Value"];
                    
                    metric2Name = [[tempDictionary valueForKey:@"workoutType"] valueForKey:@"workoutMetric2Name"];
                    metric2DefaultUnit = [[tempDictionary valueForKey:@"workoutType"] valueForKey:@"workoutMetric2DefaultUnit"];
                    metric2Value = [tempDictionary valueForKey:@"workoutMetric2Value"];
                    
                    metric3Name = [[tempDictionary valueForKey:@"workoutType"] valueForKey:@"workoutMetric3Name"];
                    metric3DefaultUnit = [[tempDictionary valueForKey:@"workoutType"] valueForKey:@"workoutMetric3DefaultUnit"];
                    metric3Value = [tempDictionary valueForKey:@"workoutMetric3Value"];
                    
                    break;
                }
            }
            
            if ((![metric1Value isEqualToString:@""] || ![metric2Value isEqualToString:@""] || ![metric3Value isEqualToString:@""]) &&
                (metric1Value || metric2Value || metric3Value)) {
                [WorkoutsDone workoutDoneIs:workoutName 
                            WithMetric1Name:metric1Name 
                                metric1Unit:metric1DefaultUnit 
                               metric1Value:metric1Value 
                                metric2Name:metric2Name 
                                metric2Unit:metric2DefaultUnit 
                               metric2Value:metric2Value 
                                metric3Name:metric3Name 
                                metric3Unit:metric3DefaultUnit 
                               metric3Value:metric3Value 
                                     onDate:self.selectedDate1 
                     inManagedObjectContext:self.managedObjectContext];
                
            }
            
        }
        self.stateData1 = nil;
    }
    
    else if (self.templateWorkoutScreenShown.boolValue == NO) {
        
        for (UITextField *textField in self.allTextFields2) {
            if (textField.editing == YES) {
                [self updateValueInStateData2:textField];
            }
        }
        
        workoutName = self.selectedWorkoutType.workoutName;
        
        metric1Name = [[self.stateData2 valueForKey:@"workoutType"] valueForKey:@"workoutMetric1Name"];
        metric1DefaultUnit = [[self.stateData2 valueForKey:@"workoutType"] valueForKey:@"workoutMetric1DefaultUnit"];
        metric1Value = [self.stateData2 valueForKey:@"workoutMetric1Value"];
        
        metric2Name = [[self.stateData2 valueForKey:@"workoutType"] valueForKey:@"workoutMetric2Name"];
        metric2DefaultUnit = [[self.stateData2 valueForKey:@"workoutType"] valueForKey:@"workoutMetric2DefaultUnit"];
        metric2Value = [self.stateData2 valueForKey:@"workoutMetric2Value"];
        
        metric3Name = [[self.stateData2 valueForKey:@"workoutType"] valueForKey:@"workoutMetric3Name"];
        metric3DefaultUnit = [[self.stateData2 valueForKey:@"workoutType"] valueForKey:@"workoutMetric3DefaultUnit"];
        metric3Value = [self.stateData2 valueForKey:@"workoutMetric3Value"];
        
        if ((![metric1Value isEqualToString:@""] || ![metric2Value isEqualToString:@""] || ![metric3Value isEqualToString:@""]) &&
            (metric1Value || metric2Value || metric3Value)) {
            [WorkoutsDone workoutDoneIs:workoutName 
                        WithMetric1Name:metric1Name 
                            metric1Unit:metric1DefaultUnit 
                           metric1Value:metric1Value 
                            metric2Name:metric2Name 
                            metric2Unit:metric2DefaultUnit 
                           metric2Value:metric2Value 
                            metric3Name:metric3Name 
                            metric3Unit:metric3DefaultUnit 
                           metric3Value:metric3Value 
                                 onDate:self.selectedDate2 
                 inManagedObjectContext:self.managedObjectContext];
        }
        
        self.stateData2 = nil;
    }
    
    [self saveContext];
    
    [self.tableView reloadData];

}

- (void)clearButtonPressed:(UIButton *)sender
{
    if (self.templateWorkoutScreenShown.boolValue == YES) {
        self.stateData1 = nil;
    }
    
    else if (self.templateWorkoutScreenShown.boolValue == NO) {
        self.stateData2 = nil;
    }
    
    [self.tableView reloadData];
}

- (void)viewDidUnload {
    [self setSwitchScreenBarButtonItem:nil];
    [super viewDidUnload];
}

@end
