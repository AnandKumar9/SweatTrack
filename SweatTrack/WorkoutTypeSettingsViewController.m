
//  WorkoutTypeSettingsViewController.m
//  SweatIt
//
//  Created by Anand Kumar on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WorkoutTypeSettingsViewController.h"
#import "WorkoutTemplates.h"
#import "DelimiterKeys.h"
#import "GAI.h"

@interface WorkoutTypeSettingsViewController ()

@property (nonatomic) UILabel *labelInWarningRow;
@property (nonatomic, strong) NSMutableDictionary *allTextFields;
@property (nonatomic, strong) NSNumber *hideHiddenWorkouts;

@end

@implementation WorkoutTypeSettingsViewController

@synthesize workoutType = _workoutType;
@synthesize context = _context;
@synthesize labelInWarningRow = _labelInWarningRow;
@synthesize hideHiddenWorkouts = _hideHiddenWorkouts;
@synthesize allTextFields = _allTextFields;

#pragma mark - View life cycle methods

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
    CGRect buttonFrame = CGRectMake(100.0, 9.0, 100.0, 27.0);
    
    if (indexPath.section == 0) {
        UITextField *workoutNameTextField = [[UITextField alloc] initWithFrame:nameFrame];
        workoutNameTextField.backgroundColor = [UIColor clearColor];
        workoutNameTextField.text = self.workoutType.workoutName;
        workoutNameTextField.delegate = self;
        workoutNameTextField.adjustsFontSizeToFitWidth = YES;
        workoutNameTextField.font = [UIFont systemFontOfSize:20.0];
        workoutNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        workoutNameTextField.textAlignment = UITextAlignmentCenter;
        workoutNameTextField.tag = 1;
        
        [self.allTextFields setValue:workoutNameTextField forKey:@"textFieldWorkoutName"];
        
        [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [cell.contentView addSubview:workoutNameTextField];
    } //Row for workout name
    
    if (indexPath.section == 1) {
        cell.textLabel.text = @"Hidden By Default";
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        
        UISwitch *hiddenAttributeSwitch = [[UISwitch alloc] initWithFrame:switchFrame];
        hiddenAttributeSwitch.on = [self.workoutType.workoutHiddenByDefault boolValue];
        hiddenAttributeSwitch.backgroundColor = [UIColor clearColor];
        hiddenAttributeSwitch.tag = 3;
        [hiddenAttributeSwitch addTarget:self action:@selector(hiddenAttributeSwitchSlid:) forControlEvents:UIControlEventValueChanged];
        
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
        workoutMetricDefaultUnitTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        workoutMetricDefaultUnitTextField.tag = (indexPath.row+2)*2;
        
        switch (indexPath.row) {
            case 0:
                workoutMetricNameTextField.text = self.workoutType.workoutMetric1Name;
                workoutMetricDefaultUnitTextField.text = self.workoutType.workoutMetric1DefaultUnit;
                
                [self.allTextFields setValue:workoutMetricNameTextField forKey:@"textFieldMetric1Name"];
                [self.allTextFields setValue:workoutMetricDefaultUnitTextField forKey:@"textFieldMetric1Unit"];
                
                break;
            case 1:
                workoutMetricNameTextField.text = self.workoutType.workoutMetric2Name;
                workoutMetricDefaultUnitTextField.text = self.workoutType.workoutMetric2DefaultUnit;
                
                if ([self.workoutType.workoutMetric1Name caseInsensitiveCompare:@""] == NSOrderedSame) {
                    workoutMetricNameTextField.enabled = NO;
                }
                if ([workoutMetricNameTextField.text caseInsensitiveCompare:@""] == NSOrderedSame) {
                    workoutMetricDefaultUnitTextField.enabled = NO;
                }
                
                [self.allTextFields setValue:workoutMetricNameTextField forKey:@"textFieldMetric2Name"];
                [self.allTextFields setValue:workoutMetricDefaultUnitTextField forKey:@"textFieldMetric2Unit"];
                
                break;                
            case 2:
                workoutMetricNameTextField.text = self.workoutType.workoutMetric3Name;
                workoutMetricDefaultUnitTextField.text = self.workoutType.workoutMetric3DefaultUnit;
                
                if ([self.workoutType.workoutMetric2Name caseInsensitiveCompare:@""] == NSOrderedSame) {
                    workoutMetricNameTextField.enabled = NO;
                }
                if ([workoutMetricNameTextField.text caseInsensitiveCompare:@""] == NSOrderedSame) {
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
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        deleteButton.frame = buttonFrame;
        [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchDown];
        
        [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [cell.contentView addSubview:deleteButton];
    } //Row for delete button
    
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
    if (textField.tag == 1) {
        textField.backgroundColor = [UIColor whiteColor];
    }
    
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
        textField.backgroundColor = [UIColor clearColor];
        if ([enteredText isEqualToString:@""]) {
            textField.text = self.workoutType.workoutName;
            self.labelInWarningRow.text = @"Workout name cannot be blank.";
        }
        else if (![enteredText isEqualToString:self.workoutType.workoutName]) {
            if ([self checkIfWorkoutNameExists:enteredText]) {
                textField.text = self.workoutType.workoutName;
                self.labelInWarningRow.text = @"A workout with that name already exists.";
                }
            else {
                [self renameWorkoutTypeInTemplates:enteredText];
                self.workoutType.workoutName = enteredText;
                [self saveContext];
                }
            }
    } //Workout Name
    
    
    if (textField.tag == 3) {
        if ([enteredText caseInsensitiveCompare:@""] == NSOrderedSame) {
            if ([self.workoutType.workoutMetric2Name caseInsensitiveCompare:@""] == NSOrderedSame) {
                textField.text = self.workoutType.workoutMetric1Name;
                self.labelInWarningRow.text = @"Every workout needs at least one metric.";
            }
            else {
                //Handle metric deletion. This should also reorder the metrics in the table
                self.workoutType.workoutMetric1Name = self.workoutType.workoutMetric2Name;
                self.workoutType.workoutMetric1DefaultUnit = self.workoutType.workoutMetric2DefaultUnit;
                self.workoutType.workoutMetric2Name = self.workoutType.workoutMetric3Name;
                self.workoutType.workoutMetric2DefaultUnit = self.workoutType.workoutMetric3DefaultUnit;
                self.workoutType.workoutMetric3Name = @"";
                self.workoutType.workoutMetric3DefaultUnit = @"";
                [self saveContext];
                [self informAboutMetricDeletion:[NSNumber numberWithInt:1]];
                [self.tableView reloadData];
            }
            
        }
        else if (![enteredText isEqualToString:self.workoutType.workoutMetric1Name]){
            if (([enteredText caseInsensitiveCompare:self.workoutType.workoutMetric2Name] == NSOrderedSame) || 
                ([enteredText caseInsensitiveCompare:self.workoutType.workoutMetric3Name] == NSOrderedSame)) {
                textField.text = self.workoutType.workoutMetric1Name;
                self.labelInWarningRow.text = @"A metric with that name already exists.";
            }
            else {
                self.workoutType.workoutMetric1Name = enteredText;
                [self saveContext];
                [self.tableView reloadData];
            }
        }
    } //Metric1 Name
    
    if (textField.tag == 5) {
        if ([enteredText caseInsensitiveCompare:@""] == NSOrderedSame) {
            //Handle metric deletion. This should also reorder the metrics in the table
            self.workoutType.workoutMetric2Name = self.workoutType.workoutMetric3Name;
            self.workoutType.workoutMetric2DefaultUnit = self.workoutType.workoutMetric3DefaultUnit;
            self.workoutType.workoutMetric3Name = @"";
            self.workoutType.workoutMetric3DefaultUnit = @"";
            [self saveContext];
            [self informAboutMetricDeletion:[NSNumber numberWithInt:2]];
            [self.tableView reloadData];
        }
        else if (![enteredText isEqualToString:self.workoutType.workoutMetric2Name]){
            if (([enteredText caseInsensitiveCompare:self.workoutType.workoutMetric1Name] == NSOrderedSame) || 
                ([enteredText caseInsensitiveCompare:self.workoutType.workoutMetric3Name] == NSOrderedSame)) {
                textField.text = self.workoutType.workoutMetric2Name;
                self.labelInWarningRow.text = @"A metric with that name already exists.";
            }
            else {
                self.workoutType.workoutMetric2Name = enteredText;
                [self saveContext];
                [self.tableView reloadData];
            }
        }
    } //Metric2 Name
    
    if (textField.tag == 7) {
        if ([enteredText caseInsensitiveCompare:@""] == NSOrderedSame) {
            //Handle metric deletion. This should also reorder the metrics in the table
            self.workoutType.workoutMetric3Name = @"";
            self.workoutType.workoutMetric3DefaultUnit = @"";
            [self saveContext];
            [self informAboutMetricDeletion:[NSNumber numberWithInt:3]];
            [self.tableView reloadData];
        }
        else if (![enteredText isEqualToString:self.workoutType.workoutMetric3Name]){
            if (([enteredText caseInsensitiveCompare:self.workoutType.workoutMetric1Name] == NSOrderedSame) || 
                ([enteredText caseInsensitiveCompare:self.workoutType.workoutMetric2Name] == NSOrderedSame)) {
                textField.text = self.workoutType.workoutMetric3Name;
                self.labelInWarningRow.text = @"A metric with that name already exists.";
            }
            else {
                self.workoutType.workoutMetric3Name = enteredText;
                [self saveContext];
                [self.tableView reloadData];
            }
        }
        
    } //Metric3 Name
    
    
    if (textField.tag == 4) {
        if (![enteredText isEqualToString:self.workoutType.workoutMetric1DefaultUnit]){
            self.workoutType.workoutMetric1DefaultUnit = enteredText;
            [self saveContext];
        }
    } //Metric1 Unit
    
    if (textField.tag == 6) {
        if (![enteredText isEqualToString:self.workoutType.workoutMetric2DefaultUnit]){
            self.workoutType.workoutMetric2DefaultUnit = enteredText;
            [self saveContext];
        }
    } //Metric2 Unit
 
    if (textField.tag == 8) {
        if (![enteredText isEqualToString:self.workoutType.workoutMetric3DefaultUnit]){
            self.workoutType.workoutMetric3DefaultUnit = enteredText;
            [self saveContext];
        }
    } //Metric3 Unit
    
    return YES;
}

- (void)informAboutMetricDeletion:(NSNumber *)metricIndex
{
    for (id viewController in self.navigationController.tabBarController.viewControllers) {
        if ([viewController isMemberOfClass:[UINavigationController class]]) {
            if ([[viewController valueForKey:@"topViewController"] isMemberOfClass:[EnterWorkoutDetailsViewController class]]) {
                [[viewController valueForKey:@"topViewController"] performSelector:@selector(updateStateDataWhenMetricIsDeleted:inWorkoutType:) 
                                                                        withObject:metricIndex
                                                                        withObject:self.workoutType];
                break;
            }
        }
    } 
    
    [self rearrangeWorkoutDefaultValuesWhenMetricIsDeleted:metricIndex];
}

#pragma mark - Attribute change methods

- (void)hiddenAttributeSwitchSlid:(UISwitch *)sender
{
    self.workoutType.workoutHiddenByDefault = [NSNumber numberWithBool:sender.isOn];
    [self saveContext];
    self.labelInWarningRow.text = @"";
}

- (void)deleteButtonPressed:(UIButton *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to delete this workout?\n\nThis will also delete all its associated records.\nYou can instead keep it as hidden."
                                        delegate:self
                               cancelButtonTitle:@"Cancel"
                          destructiveButtonTitle:@"Delete"
                               otherButtonTitles:nil];
    
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self deleteWorkoutType];
    }
}

- (BOOL)checkIfWorkoutNameExists:(NSString *)workoutNameToBeChecked
{
    if ([workoutNameToBeChecked caseInsensitiveCompare:self.workoutType.workoutName] == NSOrderedSame) {
        return  NO;     
    }//implies that the user just wants to change case of the name, allow him to do so.
    
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

- (void)deleteWorkoutType
{
    NSManagedObjectID *objectIDOfCurrentManagedObject = [self.workoutType objectID];

    for (id viewController in self.navigationController.tabBarController.viewControllers) {
        if ([viewController isMemberOfClass:[UINavigationController class]]) {
            if ([[viewController valueForKey:@"topViewController"] isMemberOfClass:[EditWorkoutDetailsViewController class]]) {
                if ([[viewController valueForKey:@"topViewController"] valueForKey:@"workoutDone"]) {
                    NSManagedObjectID *objectIDOfOtherManagedObject = [[[[viewController valueForKey:@"topViewController"] valueForKey:@"workoutDone"] valueForKey:@"workoutType"] valueForKey:@"objectID"];
                    if ([[objectIDOfCurrentManagedObject URIRepresentation] isEqual:[objectIDOfOtherManagedObject URIRepresentation]]) {
                        [viewController popViewControllerAnimated:NO];
                    }
                }
            }
            
            if ([[viewController valueForKey:@"topViewController"] isMemberOfClass:[WorkoutTemplateDefaultValuesViewController class]]) {
                if ([[viewController valueForKey:@"topViewController"] valueForKey:@"workoutType"]) {
                    NSManagedObjectID *objectIDOfOtherManagedObject = [[[viewController valueForKey:@"topViewController"] valueForKey:@"workoutType"] valueForKey:@"objectID"];
                    if ([[objectIDOfCurrentManagedObject URIRepresentation] isEqual:[objectIDOfOtherManagedObject URIRepresentation]]) {
                        [viewController popViewControllerAnimated:NO];
                    }
                }
            }
        }
    }
    
    [self removeWorkoutTypeFromWorkoutsOrderInWorkoutTemplates];
    [self removeWorkoutTypeFromWorkoutDefaultValuesInWorkoutTemplates];
    
    [self.context deleteObject:self.workoutType];
    [self saveContext];
    [self.navigationController popViewControllerAnimated:YES];
    self.allTextFields = nil;
}

- (void)removeWorkoutTypeFromWorkoutsOrderInWorkoutTemplates
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"WorkoutTemplates" inManagedObjectContext:self.context];
	[fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
    NSSortDescriptor *workoutTemplateNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"workoutTemplateName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:workoutTemplateNameDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
	NSArray *fetchResults = [self.context executeFetchRequest:fetchRequest error:&error];
    
    for (WorkoutTemplates *workoutTemplate in fetchResults) {
        NSMutableArray *workoutTypesOrder = [NSMutableArray arrayWithArray:[workoutTemplate.workoutTypesOrder componentsSeparatedByString:WORKOUTORDER_DELIMITER]];
        
        if ([workoutTypesOrder containsObject:self.workoutType.workoutName]) {
            [workoutTypesOrder removeObject:self.workoutType.workoutName];
            workoutTemplate.workoutTypesOrder = [workoutTypesOrder componentsJoinedByString:WORKOUTORDER_DELIMITER];
        }
    }
}

- (void)rearrangeWorkoutDefaultValuesWhenMetricIsDeleted:(NSNumber *)metricIndex
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"WorkoutTemplates" inManagedObjectContext:self.context];
	[fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
    NSSortDescriptor *workoutTemplateNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"workoutTemplateName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:workoutTemplateNameDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
	NSArray *fetchResults = [self.context executeFetchRequest:fetchRequest error:&error];
    
    for (WorkoutTemplates *workoutTemplate in fetchResults) {
        NSMutableArray *workoutTypesDefaultValues = [NSMutableArray arrayWithArray:[workoutTemplate.workoutTypesDefaultValues componentsSeparatedByString:WORKOUTORDER_DELIMITER]];
        
        if ([workoutTypesDefaultValues containsObject:self.workoutType.workoutName]) {
            
            NSInteger index = [workoutTypesDefaultValues indexOfObject:self.workoutType.workoutName];
            
            switch ([metricIndex intValue]) {
                case 1:
                    [workoutTypesDefaultValues removeObjectAtIndex:(index+1)];
                    [workoutTypesDefaultValues insertObject:@"" atIndex:(index+3)];
                    break;
                case 2:
                    [workoutTypesDefaultValues removeObjectAtIndex:(index+2)];
                    [workoutTypesDefaultValues insertObject:@"" atIndex:(index+3)];
                case 3:
                    [workoutTypesDefaultValues insertObject:@"" atIndex:(index+3)];
                default:
                    break;
            }
            
            workoutTemplate.workoutTypesDefaultValues = [workoutTypesDefaultValues componentsJoinedByString:WORKOUTORDER_DELIMITER];
        }
    }
}

- (void)removeWorkoutTypeFromWorkoutDefaultValuesInWorkoutTemplates
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"WorkoutTemplates" inManagedObjectContext:self.context];
	[fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
    NSSortDescriptor *workoutTemplateNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"workoutTemplateName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:workoutTemplateNameDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
	NSArray *fetchResults = [self.context executeFetchRequest:fetchRequest error:&error];
    
    for (WorkoutTemplates *workoutTemplate in fetchResults) {
        NSMutableArray *workoutTypesDefaultValues = [NSMutableArray arrayWithArray:[workoutTemplate.workoutTypesDefaultValues componentsSeparatedByString:WORKOUTORDER_DELIMITER]];
        
        if ([workoutTypesDefaultValues containsObject:self.workoutType.workoutName]) {
            
            NSInteger index = [workoutTypesDefaultValues indexOfObject:self.workoutType.workoutName];
            NSMutableIndexSet *indexesToBeRemoved = [NSMutableIndexSet indexSetWithIndex:index];
            [indexesToBeRemoved addIndex:(index+1)];
            [indexesToBeRemoved addIndex:(index+2)];
            [indexesToBeRemoved addIndex:(index+3)];
            
            [workoutTypesDefaultValues removeObjectsAtIndexes:indexesToBeRemoved];
            workoutTemplate.workoutTypesDefaultValues = [workoutTypesDefaultValues componentsJoinedByString:WORKOUTORDER_DELIMITER];
        }
    }
}

- (void)renameWorkoutTypeInTemplates:(NSString *)workoutNewName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"WorkoutTemplates" inManagedObjectContext:self.context];
	[fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
    NSSortDescriptor *workoutTemplateNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"workoutTemplateName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:workoutTemplateNameDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
	NSArray *fetchResults = [self.context executeFetchRequest:fetchRequest error:&error];
    
    for (WorkoutTemplates *workoutTemplate in fetchResults) {
        
        NSMutableArray *workoutTypesOrder = [NSMutableArray arrayWithArray:[workoutTemplate.workoutTypesOrder componentsSeparatedByString:WORKOUTORDER_DELIMITER]];
        
        if ([workoutTypesOrder containsObject:self.workoutType.workoutName]) {
            NSInteger index = [workoutTypesOrder indexOfObject:self.workoutType.workoutName];
            [workoutTypesOrder removeObjectAtIndex:index];
            [workoutTypesOrder insertObject:workoutNewName atIndex:index];
            
            workoutTemplate.workoutTypesOrder = [workoutTypesOrder componentsJoinedByString:WORKOUTORDER_DELIMITER];
        }
        
        NSMutableArray *workoutTypesDefaultValues = [NSMutableArray arrayWithArray:[workoutTemplate.workoutTypesDefaultValues componentsSeparatedByString:WORKOUTORDER_DELIMITER]];
        
        if ([workoutTypesDefaultValues containsObject:self.workoutType.workoutName]) {
            NSInteger index = [workoutTypesDefaultValues indexOfObject:self.workoutType.workoutName];
            [workoutTypesDefaultValues removeObjectAtIndex:index];
            [workoutTypesDefaultValues insertObject:workoutNewName atIndex:index];
            
            workoutTemplate.workoutTypesDefaultValues = [workoutTypesDefaultValues componentsJoinedByString:WORKOUTORDER_DELIMITER];
        }
            
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
    
    if (![defaults objectForKey:@"analyticsEditWorkoutSettings"]) {
        [[[GAI sharedInstance] defaultTracker] trackView:@"Edit Workout Settings"];
        [defaults setObject:[NSDate date] forKey:@"analyticsEditWorkoutSettings"];
    }
    else {
        NSDate *analyticsLastPostDate = [defaults objectForKey:@"analyticsEditWorkoutSettings"];
        NSDate *currentDate = [NSDate date];
        
        NSInteger analyticsLastPostDateDay = [[[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:analyticsLastPostDate] day];
        NSInteger currentDateDay = [[[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:currentDate] day];
        
        if (analyticsLastPostDateDay != currentDateDay) {
            [[[GAI sharedInstance] defaultTracker] trackView:@"Edit Workout Settings"];
            [defaults setObject:[NSDate date] forKey:@"analyticsEditWorkoutSettings"];
        }
    }
    
    [defaults synchronize];
}

@end
