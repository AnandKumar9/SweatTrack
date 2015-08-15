//
//  WorkoutTemplateDetailsViewController.m
//  SweatTrack
//
//  Created by Anand Kumar on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WorkoutTemplateDetailsViewController.h"
#import "WorkoutTypes.h"
#import "WorkoutTemplates+Create.h"
#import "DelimiterKeys.h"

@interface WorkoutTemplateDetailsViewController ()

@property (nonatomic, strong) NSArray *fetchResults;
@property (nonatomic, strong) NSMutableArray *modifiedFetchResults;
@property (nonatomic, strong) UILabel *labelInWarningRow;
@property (nonatomic, strong) NSNumber *hideHiddenWorkouts;
@property (nonatomic, strong) NSString *sourceSegueIdentifier;
@property (nonatomic, strong) NSMutableArray *rowMovements;
@property (nonatomic, strong) NSIndexPath *indexPathOfSwipedCell;
@property (nonatomic, strong) NSNumber *templateEnabled;

@end

@implementation WorkoutTemplateDetailsViewController

@synthesize fetchResults = _fetchResults;
@synthesize modifiedFetchResults = _modifiedFetchResults;
@synthesize labelInWarningRow = _labelInWarningRow;
@synthesize hideHiddenWorkouts = _hideHiddenWorkouts;
@synthesize sourceSegueIdentifier = _sourceSegueIdentifier;
@synthesize rowMovements = _rowMovements;
@synthesize indexPathOfSwipedCell = _indexPathOfSwipedCell;
@synthesize templateEnabled = _templateEnabled;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize workoutTemplate = _workoutTemplate;

- (void)executeFetch
{

    //Create and configure a fetch request with the Book entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WorkoutTypes" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
        
    // Create the sort descriptors array.
    NSSortDescriptor *workoutTypeNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"workoutName" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:workoutTypeNameDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    if (self.hideHiddenWorkouts.boolValue == YES) {
        if (self.workoutTemplate) {
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(workoutHiddenByDefault == NO) OR (workoutTemplatesReferredToIn CONTAINS %@)", self.workoutTemplate];
        }
        else {
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(workoutHiddenByDefault == NO)"];
        } // When the sourceSegueIdentifier is "Add Workout Template"
    }

    NSError *error = nil;
    self.fetchResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //Take care of any duplicate objects that may have been returned by the fetch request
    self.modifiedFetchResults = [[NSMutableArray alloc] init];
    for (WorkoutTypes *workoutTypeInFetchResults in self.fetchResults) {
        BOOL workoutTypeAlreadyIncluded = NO;
        for (WorkoutTypes *workoutTypeInModifiedFetchResults in self.modifiedFetchResults) {
            if ([workoutTypeInFetchResults.workoutName isEqualToString:workoutTypeInModifiedFetchResults.workoutName]) {
                workoutTypeAlreadyIncluded = YES;
                break;
            }
        }
        if (workoutTypeAlreadyIncluded == NO) {
            [self.modifiedFetchResults addObject:workoutTypeInFetchResults];
        }
    }
    
    //Form includedWorkoutTypesInModifiedFetchResults and excludedWorkoutTypesInModifiedFetchResults arrays
    NSMutableArray *includedWorkoutTypesInModifiedFetchResults = [[NSMutableArray alloc] init];
    NSMutableArray *excludedWorkoutTypesInModifiedFetchResults = [[NSMutableArray alloc] init];
    
    for (WorkoutTypes *workoutTypeInModifiedFetchResults in self.modifiedFetchResults) {
        if ([self.workoutTemplate.workoutTypesIncluded containsObject:workoutTypeInModifiedFetchResults]){
            [includedWorkoutTypesInModifiedFetchResults addObject:workoutTypeInModifiedFetchResults];
        }
        else {
            [excludedWorkoutTypesInModifiedFetchResults addObject:workoutTypeInModifiedFetchResults];
        }
    }
    
    //Form orderedIncludedWorkoutTypesInModifiedFetchResults array
    NSMutableArray *workoutTypesOrder = [NSMutableArray arrayWithArray:[self.workoutTemplate.workoutTypesOrder componentsSeparatedByString:WORKOUTORDER_DELIMITER]];
    NSMutableArray *orderedIncludedWorkoutTypesInModifiedFetchResults = [[NSMutableArray alloc] init];
    
    for (NSString *workoutName in workoutTypesOrder) {
        for (WorkoutTypes *workoutType in includedWorkoutTypesInModifiedFetchResults) {
            if ([workoutType.workoutName isEqualToString:workoutName]) {
                [orderedIncludedWorkoutTypesInModifiedFetchResults addObject:workoutType];
            }
        }
    }
    
    
    [self.modifiedFetchResults removeAllObjects];
    [self.modifiedFetchResults addObjectsFromArray:orderedIncludedWorkoutTypesInModifiedFetchResults];
    [self.modifiedFetchResults addObjectsFromArray:excludedWorkoutTypesInModifiedFetchResults];
    
}


#pragma mark - View life cycle methods

- (void)viewWillAppear:(BOOL)animated
{  
    [super viewWillAppear:animated];
    self.title = self.workoutTemplate.workoutTemplateName;

    if (!self.hideHiddenWorkouts) {
//        self.hideHiddenWorkouts = [NSNumber numberWithBool:NO];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (![defaults objectForKey:@"hideHiddenWorkoutsInWorkoutTemplateDetailsView"]) {
            [defaults setObject:[NSNumber numberWithBool:NO] forKey:@"hideHiddenWorkoutsInWorkoutTemplateDetailsView"];
            [defaults synchronize];
        }
        self.hideHiddenWorkouts = [defaults objectForKey:@"hideHiddenWorkoutsInWorkoutTemplateDetailsView"];
    }   
    
    [self executeFetch];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.tableView.editing == YES) {
        [self.tableView setEditing:NO animated:NO];
        [self updateTemplateOrder];
    }

    self.rowMovements = nil;
    [super viewWillDisappear:animated];
}

#pragma mark - TableView Datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{   
    int numberOfSections = 0;
    
    if ([self.sourceSegueIdentifier isEqualToString:@"Add Workout Template"]) {
        numberOfSections = 4;
    }
    else if ([self.sourceSegueIdentifier isEqualToString:@"Show Workout Template Details"]) {
        numberOfSections = 5;
    }
    
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowsCount;
    
    if (section != 3 ) {
        rowsCount = 1;
    }
    else {
        rowsCount = self.modifiedFetchResults.count;
    }
    
    return  rowsCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 30.00;
        case 1:
            return 23.00;
        case 2:
            return 30.00;
        case 4:
            return 50.00;
        default:
            return 40.00;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    // Configure the cell...
    
    CGRect nameFrame = CGRectMake(70.0, 9.0, 160.0, 27.0);
    CGRect warningFrame = CGRectMake(10.0, 3.0, 280.0, 20.0);
    CGRect hiddenAttributeButtonFrame = CGRectMake(10.0, 3.0, 100.0, 28.0);
    CGRect reorderButtonFrame = CGRectMake(180.0, 3.0, 100.0, 28.0);
    CGRect deleteButtonFrame = CGRectMake(100.0, 9.0, 100.0, 27.0);
    
//    CGRect frame1 = CGRectMake(18.0, 9.0, 100.0, 27.0);
    
    if (indexPath.section == 0) {
        UITextField *workoutTemplateNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0, cell.frame.size.width, cell.frame.size.height)];
        workoutTemplateNameTextField.frame = nameFrame;
        workoutTemplateNameTextField.text = self.workoutTemplate.workoutTemplateName;
        workoutTemplateNameTextField.delegate = self;
        workoutTemplateNameTextField.adjustsFontSizeToFitWidth = YES;
        workoutTemplateNameTextField.font = [UIFont systemFontOfSize:25.0];
        workoutTemplateNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        workoutTemplateNameTextField.textAlignment = UITextAlignmentCenter;
        
        if ([self.sourceSegueIdentifier isEqualToString:@"Add Workout Template"]) {
            workoutTemplateNameTextField.backgroundColor = [UIColor whiteColor];
            workoutTemplateNameTextField.placeholder = @"Enter name";
            if (!self.templateEnabled) {
                self.templateEnabled = [NSNumber numberWithBool:NO];
            }
        }
        else {
            self.templateEnabled = [NSNumber numberWithBool:YES];
        }
        
        [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [cell.contentView addSubview:workoutTemplateNameTextField];
    }
    
    if (indexPath.section == 1) {
        UILabel *warningLabel = [[UILabel alloc] initWithFrame:warningFrame];
        warningLabel.textAlignment = UITextAlignmentCenter;
        warningLabel.enabled = NO;
        warningLabel.font = [UIFont systemFontOfSize:14.0];
        warningLabel.backgroundColor = [UIColor clearColor];
        
        if ([self.sourceSegueIdentifier isEqualToString:@"Add Workout Template"]) {
            warningLabel.text = @"Enter a template name";
        }
        else {
            warningLabel.text = @"";
        }
        
        [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [cell.contentView addSubview:warningLabel];
        
        self.labelInWarningRow = warningLabel;
    }
    
    if (indexPath.section == 2) {
        UIButton *hiddenAttributeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        hiddenAttributeButton.frame = hiddenAttributeButtonFrame;
        hiddenAttributeButton.titleLabel.textColor = [UIColor whiteColor];
        hiddenAttributeButton.enabled = YES;
        [hiddenAttributeButton addTarget:self action:@selector(hiddenAttributeButtonPressed:) forControlEvents:UIControlEventTouchDown];
        
        if (self.hideHiddenWorkouts.boolValue == YES) {
            [hiddenAttributeButton setTitle:@"Show All" forState:UIControlStateNormal];
        }
        else if (self.hideHiddenWorkouts.boolValue == NO) {
            [hiddenAttributeButton setTitle:@"Hide some" forState:UIControlStateNormal];
        }
        
        UIButton *reorderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        reorderButton.frame = reorderButtonFrame;
        if (self.tableView.editing == NO) {
            [reorderButton setTitle:@"Reorder" forState:UIControlStateNormal];
        }
        else if (self.tableView.editing == YES) {
            [reorderButton setTitle:@"Done" forState:UIControlStateNormal];
        }
        
        reorderButton.titleLabel.textColor = [UIColor whiteColor];
        reorderButton.enabled = YES;
        [reorderButton addTarget:self action:@selector(reorderButtonPressed:) forControlEvents:UIControlEventTouchDown];
        
        hiddenAttributeButton.backgroundColor = [UIColor clearColor]; 
        reorderButton.backgroundColor = [UIColor clearColor];
        
        [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [cell.contentView addSubview:hiddenAttributeButton];
        [cell.contentView addSubview:reorderButton];
    }
    
    if (indexPath.section == 3) {
        WorkoutTypes *workoutType = [self.modifiedFetchResults objectAtIndex:(indexPath.row)];
        cell.textLabel.text = workoutType.workoutName;
        
        if ([self.workoutTemplate.workoutTypesIncluded containsObject:workoutType]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        UISwipeGestureRecognizer *swipeGesturerecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(setTemplateDefaultValues:)];
        swipeGesturerecognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [cell.contentView addGestureRecognizer:swipeGesturerecognizerLeft];
        
        UISwipeGestureRecognizer *swipeGesturerecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(setTemplateDefaultValues:)];
        swipeGesturerecognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
        [cell.contentView addGestureRecognizer:swipeGesturerecognizerRight];
        
//        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(setTemplateDefaultValues:)];
////        longPressGestureRecognizer.minimumPressDuration = 1;
//        [cell.contentView addGestureRecognizer:longPressGestureRecognizer];
    }
    
    if (indexPath.section == 4) {
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        deleteButton.frame = deleteButtonFrame;
        deleteButton.titleLabel.textColor = [UIColor whiteColor];
        deleteButton.enabled = YES;
        [deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
        
        deleteButton.backgroundColor = [UIColor clearColor]; 
        
        [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [cell.contentView addSubview:deleteButton];
    }
    
    if (indexPath.section != 3) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
        backView.backgroundColor = [UIColor clearColor];
        cell.backgroundView = backView;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - TableView delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{  
    if (indexPath.section == 3 && [self.sourceSegueIdentifier isEqualToString:@"Show Workout Template Details"]) {
        
        WorkoutTypes *workoutType = [self.modifiedFetchResults objectAtIndex:(indexPath.row)];
        
        if ([self tableView:self.tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryNone) {
            [self.workoutTemplate addWorkoutTypesIncludedObject:workoutType];

            //Update workoutTypesOrder attribute in data store
            NSMutableArray *workoutTypesOrder = [NSMutableArray arrayWithArray:[self.workoutTemplate.workoutTypesOrder componentsSeparatedByString:WORKOUTORDER_DELIMITER]];
            if ([self.workoutTemplate.workoutTypesOrder isEqualToString:@""]) {
                [workoutTypesOrder removeAllObjects]; 
            }
            
            [workoutTypesOrder addObject:workoutType.workoutName];
            self.workoutTemplate.workoutTypesOrder = [workoutTypesOrder componentsJoinedByString:WORKOUTORDER_DELIMITER];
            
            //Update workoutTypesDefaultValues attribute in data store
            NSMutableArray *workoutTypesDefaultValues = [NSMutableArray arrayWithArray:[self.workoutTemplate.workoutTypesDefaultValues componentsSeparatedByString:WORKOUTORDER_DELIMITER]];
            if ([self.workoutTemplate.workoutTypesDefaultValues isEqualToString:@""]) {
                [workoutTypesDefaultValues removeAllObjects]; 
            }
            
            [workoutTypesDefaultValues addObjectsFromArray:[NSArray arrayWithObjects:workoutType.workoutName, @"", @"", @"", nil]];
            self.workoutTemplate.workoutTypesDefaultValues = [workoutTypesDefaultValues componentsJoinedByString:WORKOUTORDER_DELIMITER];
            
            
            [self saveContext];
            [self executeFetch];
            [self.tableView reloadData];
            
        }
        else if ([self tableView:self.tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark) {
            [self.workoutTemplate removeWorkoutTypesIncludedObject:workoutType];
            
            //Update workoutTypesOrder attribute in data store
            NSMutableArray *workoutTypesOrder = [NSMutableArray arrayWithArray:[self.workoutTemplate.workoutTypesOrder componentsSeparatedByString:WORKOUTORDER_DELIMITER]];
            if ([self.workoutTemplate.workoutTypesOrder isEqualToString:@""]) {
                [workoutTypesOrder removeAllObjects]; 
            }

            [workoutTypesOrder removeObject:workoutType.workoutName];
            self.workoutTemplate.workoutTypesOrder = [workoutTypesOrder componentsJoinedByString:WORKOUTORDER_DELIMITER];
            
            //Update workoutTypesDefaultValues attribute in data store
            NSMutableArray *workoutTypesDefaultValues = [NSMutableArray arrayWithArray:[self.workoutTemplate.workoutTypesDefaultValues componentsSeparatedByString:WORKOUTORDER_DELIMITER]];
            if ([self.workoutTemplate.workoutTypesDefaultValues isEqualToString:@""]) {
                [workoutTypesDefaultValues removeAllObjects];
            }
            
            NSInteger index = [workoutTypesDefaultValues indexOfObject:workoutType.workoutName];
            NSMutableIndexSet *indexesToBeRemoved = [NSMutableIndexSet indexSetWithIndex:index];
            [indexesToBeRemoved addIndex:(index+1)];
            [indexesToBeRemoved addIndex:(index+2)];
            [indexesToBeRemoved addIndex:(index+3)];
            
            [workoutTypesDefaultValues removeObjectsAtIndexes:indexesToBeRemoved];
            self.workoutTemplate.workoutTypesDefaultValues = [workoutTypesDefaultValues componentsJoinedByString:WORKOUTORDER_DELIMITER];
            
                                                      
            [self saveContext];
            [self executeFetch];
            [self.tableView reloadData];
            
        }
    }
}


#pragma mark - TableView Datasource row movemement methods

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if ([self tableView:self.tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark) { 
        return YES;
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [self.rowMovements addObject:[NSDictionary dictionaryWithObjectsAndKeys:sourceIndexPath,@"sourceIndexPath", 
                                                                       destinationIndexPath, @"destinationIndexPath", nil]];

}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if ([self tableView:self.tableView cellForRowAtIndexPath:proposedDestinationIndexPath].accessoryType == UITableViewCellAccessoryCheckmark) { 
        return proposedDestinationIndexPath;
    }
    else {
        return sourceIndexPath;
    }
}


#pragma mark - Text Field's delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.sourceSegueIdentifier isEqualToString:@"Show Workout Template Details"]) {
        textField.backgroundColor = [UIColor whiteColor];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    NSString *enteredText = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([self.sourceSegueIdentifier isEqualToString:@"Show Workout Template Details"]) {
        textField.backgroundColor = [UIColor clearColor];
    }
    
    if ([self.sourceSegueIdentifier isEqualToString:@"Add Workout Template"]) {
        if (![enteredText isEqualToString:@""]) {
            if ([self checkIfWorkoutTemplateNameExists:enteredText]) {
                self.labelInWarningRow.text = @"A template with that name already exists.";
                textField.text = @"";
            }
            else {
                self.labelInWarningRow.text = @"";
                self.workoutTemplate = [WorkoutTemplates templateIs:enteredText 
                                                   withWorkoutTypes:nil
                                                  workoutTypesOrder:@""
                                          workoutTypesDefaultValues:@""
                                             inManagedObjectContext:self.managedObjectContext];
                [self saveContext];
                self.title = enteredText;
                self.sourceSegueIdentifier = @"Show Workout Template Details";
                [self.tableView reloadData];
            }
            
        }
        else {
            textField.text = @"";
            self.labelInWarningRow.text = @"Enter a template name";
        }
    }
    
    else if ([self.sourceSegueIdentifier isEqualToString:@"Show Workout Template Details"]){
        if (![enteredText isEqualToString:@""]) {
            if (![enteredText isEqualToString:self.workoutTemplate.workoutTemplateName]) {
                if ([self checkIfWorkoutTemplateNameExists:enteredText] && 
                    ([enteredText caseInsensitiveCompare:self.workoutTemplate.workoutTemplateName] != NSOrderedSame)) {
                    self.labelInWarningRow.text = @"A template with that name already exists.";
                    textField.text = self.workoutTemplate.workoutTemplateName;
                }
                
                else {
                    self.labelInWarningRow.text = @"";
                    self.workoutTemplate.workoutTemplateName = enteredText;
                    [self saveContext];
                    self.title = textField.text;
                }
            }
        }
        else {
            enteredText = self.workoutTemplate.workoutTemplateName;
            self.labelInWarningRow.text = @"Template name cannot be blank";
        }
        
    }
    
    return YES;
}

- (BOOL)checkIfWorkoutTemplateNameExists:(NSString *)workoutTemplateNameToBeChecked
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"WorkoutTemplates" inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
    NSSortDescriptor *workoutNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"workoutTemplateName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:workoutNameDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"workoutTemplateName = [cd] %@", workoutTemplateNameToBeChecked];
    
    NSError *error = nil;
	NSArray *matchingWorkoutTemplateNames = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	if (matchingWorkoutTemplateNames == nil) {
        //handle error
        return YES;
	}
	else {
        if (matchingWorkoutTemplateNames.count > 0)
            return YES;
        else
            return NO;
    }
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

#pragma mark - Buttons' target-action methods

- (void)hiddenAttributeButtonPressed:(UIButton *)sender
{
    if (self.templateEnabled.boolValue == YES) {
        self.hideHiddenWorkouts = [NSNumber numberWithBool:!self.hideHiddenWorkouts.boolValue];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.hideHiddenWorkouts forKey:@"hideHiddenWorkoutsInWorkoutTemplateDetailsView"];
        [defaults synchronize];
        
        [self executeFetch];
        [self.tableView reloadData];
    }
}

- (void)reorderButtonPressed:(UIButton *)sender
{   
    if (self.templateEnabled.boolValue == YES) {
        if (self.tableView.editing == NO) {
            [sender setTitle:@"Done" forState:UIControlStateNormal];
            [self.tableView setEditing:YES animated:YES];
            self.rowMovements = [[NSMutableArray alloc] init];
        }
        
        else if (self.tableView.editing == YES) {
            [sender setTitle:@"Reorder" forState:UIControlStateNormal];
            [self.tableView setEditing:NO animated:YES];
            [self updateTemplateOrder];
        }
    }
}

- (void)updateTemplateOrder
 {
     if (self.rowMovements) {
         NSMutableArray *workoutTypesOrder = [NSMutableArray arrayWithArray:[self.workoutTemplate.workoutTypesOrder componentsSeparatedByString:WORKOUTORDER_DELIMITER]];
         
         for (NSDictionary *rowMovement in self.rowMovements) {
             NSIndexPath *sourceIndexPath = [rowMovement valueForKey:@"sourceIndexPath"];
             NSIndexPath *destinationIndexPath = [rowMovement valueForKey:@"destinationIndexPath"]; 
             
             int sourceIndex = sourceIndexPath.row;
             int destinationIndex = destinationIndexPath.row;
             
             id tempObject = [workoutTypesOrder objectAtIndex:sourceIndex];
             [workoutTypesOrder removeObjectAtIndex:sourceIndex];
             [workoutTypesOrder insertObject:tempObject atIndex:destinationIndex];
         }
         
         self.workoutTemplate.workoutTypesOrder = [workoutTypesOrder componentsJoinedByString:WORKOUTORDER_DELIMITER];
         
         [self saveContext];
         self.rowMovements = nil;
         
         [self executeFetch];
         [self.tableView reloadData];
     }
 }

- (void)deleteButtonPressed:(UIButton *)sender
{
    [self confirmWorkoutTemplateDeletionWithText:@"Are you sure you want to delete this workout template?"];
}

- (void)confirmWorkoutTemplateDeletionWithText:(NSString *)confirmationText
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
        [self.managedObjectContext deleteObject:self.workoutTemplate];
        [self saveContext];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Gesture Recognizer and Other Observer methods

- (void)setTemplateDefaultValues:(UILongPressGestureRecognizer *)gesture
{
    id swipedCell = gesture.view.superview;
    
    id accessoryTypeOfSwipedCell = [swipedCell valueForKey:@"accessoryType"];
    self.indexPathOfSwipedCell = [self.tableView indexPathForCell:swipedCell];
    
    if ([accessoryTypeOfSwipedCell intValue] == UITableViewCellAccessoryCheckmark && self.tableView.editing == NO) {
        [self performSegueWithIdentifier:@"Set Template Default Values" sender:self];
    }
}

#pragma mark - prepareForSegue:
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    if ([segue.identifier isEqualToString:@"Set Template Default Values"]) {
        if ([segue.destinationViewController respondsToSelector:@selector(setManagedObjectContext:)]) {
            [segue.destinationViewController performSelector:@selector(setManagedObjectContext:) withObject:self.managedObjectContext];
            [segue.destinationViewController performSelector:@selector(setWorkoutTemplate:) withObject:self.workoutTemplate];
            [segue.destinationViewController performSelector:@selector(setWorkoutType:) withObject:[self.modifiedFetchResults objectAtIndex:(self.indexPathOfSwipedCell.row)]];
        }
    }
}

@end
