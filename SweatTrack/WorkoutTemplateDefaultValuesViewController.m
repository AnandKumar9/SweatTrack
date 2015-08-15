//
//  WorkoutTemplateDeafultValuesViewController.m
//  SweatTrack
//
//  Created by Anand Kumar on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WorkoutTemplateDefaultValuesViewController.h"
#import "DelimiterKeys.h"

@interface WorkoutTemplateDefaultValuesViewController ()

@property (nonatomic, strong) NSMutableArray *allTextFields;
@property (nonatomic, strong) NSNumber *keyboardVisible;

@end

@implementation WorkoutTemplateDefaultValuesViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize workoutTemplate = _workoutTemplate;
@synthesize workoutType = _workoutType;

@synthesize allTextFields = _allTextFields;
@synthesize keyboardVisible = _keyboardVisible;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.allTextFields) {
        self.allTextFields = [[NSMutableArray alloc] init];
    }
    
    UISwipeGestureRecognizer *swipeGesturerecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showNextWorkoutTypeDefaultValues)];
    swipeGesturerecognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeGesturerecognizerLeft];
    
    UISwipeGestureRecognizer *swipeGesturerecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showPreviousWorkoutTypeDefaultValues)];
    swipeGesturerecognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesturerecognizerRight];
    
    self.keyboardVisible = [NSNumber numberWithBool:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];   //Unregister from keyboard notification, else they may start piling
    
    [super viewWillDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int sectionsForWorkoutTypes;

    if (self.workoutType.workoutName) {
        sectionsForWorkoutTypes = 1;
    }
    else {
        sectionsForWorkoutTypes = 0;
    }

    return (2 + sectionsForWorkoutTypes);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowsCount = 1;
    
    if (section == 2) {
        int metricsCount = 0;
        
        if (![self.workoutType.workoutMetric1Name isEqualToString:@""]) {
            metricsCount++;
        }
        if (![self.workoutType.workoutMetric2Name isEqualToString:@""]) {
            metricsCount++;
        }
        if (![self.workoutType.workoutMetric3Name isEqualToString:@""]) {
            metricsCount++;
        }
        
        rowsCount = metricsCount;
    }

    return rowsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    CGRect labelFrame = CGRectMake(5.0, 9.0, 280.0, 27.0);
    
    if (indexPath.section == 0) {
        UILabel *workoutNameLabel = [[UILabel alloc] initWithFrame:labelFrame];
        workoutNameLabel.text = self.workoutType.workoutName;
        workoutNameLabel.backgroundColor = [UIColor clearColor];
        workoutNameLabel.font = [UIFont systemFontOfSize:25.0];
        workoutNameLabel.textAlignment = UITextAlignmentCenter;
        
        [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [cell.contentView addSubview:workoutNameLabel];
    }
    
    if (indexPath.section == 1) {
        UILabel *templateNameLabel = [[UILabel alloc] initWithFrame:labelFrame];
        templateNameLabel.text = [@"Default values for " stringByAppendingString:self.workoutTemplate.workoutTemplateName];
        templateNameLabel.backgroundColor = [UIColor clearColor];
        templateNameLabel.font = [UIFont systemFontOfSize:18.0];
        templateNameLabel.textAlignment = UITextAlignmentCenter;
        
        [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [cell.contentView addSubview:templateNameLabel];
    }
    
    if (indexPath.section == 2) {
        NSString *metricName, *metricDefaultUnit;
        
        switch (indexPath.row) {
            case 0:
                metricName = self.workoutType.workoutMetric1Name;
                metricDefaultUnit = self.workoutType.workoutMetric1DefaultUnit;
                break;
                
            case 1:
                metricName = self.workoutType.workoutMetric2Name;
                metricDefaultUnit = self.workoutType.workoutMetric2DefaultUnit;
                break;
                
            case 2:
                metricName = self.workoutType.workoutMetric3Name;
                metricDefaultUnit = self.workoutType.workoutMetric3DefaultUnit;
                break;
                
            default:
                metricName = @"";
                metricDefaultUnit = @"";
                break;
        }
        
        cell.textLabel.text = metricName;
        if (![metricDefaultUnit isEqualToString:@""] && ([metricDefaultUnit caseInsensitiveCompare:metricName] != NSOrderedSame)){
            cell.textLabel.text = [cell.textLabel.text stringByAppendingString:@" ("];
            cell.textLabel.text = [cell.textLabel.text stringByAppendingString:metricDefaultUnit];
            cell.textLabel.text = [cell.textLabel.text stringByAppendingString:@")"];
        }
        
        
        UITextField *workoutValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(128.0, 9.0, 160.0, 27.0)];
        workoutValueTextField.delegate = self;
        workoutValueTextField.adjustsFontSizeToFitWidth = YES;
        workoutValueTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        workoutValueTextField.textAlignment = UITextAlignmentRight;
        workoutValueTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        workoutValueTextField.text = @"";
        
        
        
        NSMutableArray *workoutTypesDefaultValues = [NSMutableArray arrayWithArray:[self.workoutTemplate.workoutTypesDefaultValues componentsSeparatedByString:WORKOUTORDER_DELIMITER]];

        NSInteger index = [workoutTypesDefaultValues indexOfObject:self.workoutType.workoutName];
        
        switch (indexPath.row) {
            case 0:
                workoutValueTextField.text = [workoutTypesDefaultValues objectAtIndex:(index+1)];
                break;
            case 1:
                workoutValueTextField.text = [workoutTypesDefaultValues objectAtIndex:(index+2)];
                break;
            case 2:
                workoutValueTextField.text = [workoutTypesDefaultValues objectAtIndex:(index+3)];
                break;
            default:
                break;
        }
        
        [self.allTextFields addObject:workoutValueTextField];
        
        [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [cell addSubview:workoutValueTextField];

    }
    
    if (indexPath.section != 2) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
        backView.backgroundColor = [UIColor clearColor];
        cell.backgroundView = backView;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - TextField delegate methods


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self updateDefaultValueInStore:textField];
}

- (void)updateDefaultValueInStore:(UITextField *)textField
{
    NSString *enteredText = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    UITableViewCell *cell = [textField valueForKey:@"superview"];
    NSUInteger row = [self.tableView indexPathForCell:cell].row;
    
    NSMutableArray *workoutTypesDefaultValues = [NSMutableArray arrayWithArray:[self.workoutTemplate.workoutTypesDefaultValues componentsSeparatedByString:WORKOUTORDER_DELIMITER]];
    
    NSInteger index = [workoutTypesDefaultValues indexOfObject:self.workoutType.workoutName];  
    
    [workoutTypesDefaultValues removeObjectAtIndex:(index+row+1)];
    [workoutTypesDefaultValues insertObject:enteredText atIndex:(index+row+1)];
    
    self.workoutTemplate.workoutTypesDefaultValues = [workoutTypesDefaultValues componentsJoinedByString:WORKOUTORDER_DELIMITER];
    
    [self saveContext];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
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

#pragma mark - Gesture Recognizer and other KVO methods

- (void)showPreviousWorkoutTypeDefaultValues
{
    if ([self.keyboardVisible boolValue] == NO) {
        NSMutableArray *workoutTypesOrder = [NSMutableArray arrayWithArray:[self.workoutTemplate.workoutTypesOrder componentsSeparatedByString:WORKOUTORDER_DELIMITER]];
        
        NSInteger index = [workoutTypesOrder indexOfObject:self.workoutType.workoutName];
        
        NSString *previousWorkoutTypeName;
        
        if (index != 0) {
            previousWorkoutTypeName = [workoutTypesOrder objectAtIndex:(index-1)];
        }
        else {
            previousWorkoutTypeName = [workoutTypesOrder lastObject];
        }
        
        for (WorkoutTypes *workoutType in self.workoutTemplate.workoutTypesIncluded) {
            if ([workoutType.workoutName isEqualToString:previousWorkoutTypeName]) {
                self.workoutType = workoutType;
                [self.tableView reloadData];
                break;
            }
        }
    }
    
}

- (void)showNextWorkoutTypeDefaultValues
{
    if ([self.keyboardVisible boolValue] == NO) {
        NSMutableArray *workoutTypesOrder = [NSMutableArray arrayWithArray:[self.workoutTemplate.workoutTypesOrder componentsSeparatedByString:WORKOUTORDER_DELIMITER]];
        
        NSInteger index = [workoutTypesOrder indexOfObject:self.workoutType.workoutName];
        
        NSString *previousWorkoutTypeName;
        
        if (index != (workoutTypesOrder.count-1)) {
            previousWorkoutTypeName = [workoutTypesOrder objectAtIndex:(index+1)];
        }
        else {
            previousWorkoutTypeName = [workoutTypesOrder objectAtIndex:0];
        }
        
        for (WorkoutTypes *workoutType in self.workoutTemplate.workoutTypesIncluded) {
            if ([workoutType.workoutName isEqualToString:previousWorkoutTypeName]) {
                self.workoutType = workoutType;
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

@end
