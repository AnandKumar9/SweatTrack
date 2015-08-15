//
//  AppDelegate.m
//  SweatTrack
//
//  Created by Anand Kumar on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "WorkoutTypes+Create.h"
#import "WorkoutsDone+Create.h"
#import "WorkoutTemplates+Create.h"
#import "WorkoutTypesViewController.h"
#import "SelectedMonthDetailsViewController.h"
#import "EnterWorkoutDetailsViewController.h"
#import "WorkoutTemplatesViewController.h"
#import "DelimiterKeys.h"
#import "GAI.h"


@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (NSMutableDictionary *)generateDefaultData
{
    NSMutableDictionary *defaultData = [[NSMutableDictionary alloc] init];

    NSMutableArray *workoutTypes = [[NSMutableArray alloc] init];
    if (1) {
        [workoutTypes addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"Bench Press", @"name", 
                                 @"Weight", @"metric1", 
                                 @"lbs", @"unit1", 
                                 @"Sets", @"metric2",
                                 @"sets", @"unit2", 
                                 @"", @"metric3",
                                 @"", @"unit3", 
                                 [NSNumber numberWithBool:NO], @"hidden", nil]];
        [workoutTypes addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"Push Up", @"name", 
                                 @"Sets", @"metric1", 
                                 @"", @"unit1", 
                                 @"", @"metric2",
                                 @"", @"unit2", 
                                 @"", @"metric3",
                                 @"", @"unit3", 
                                 [NSNumber numberWithBool:NO], @"hidden", nil]];
        [workoutTypes addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"Treadmill", @"name", 
                                 @"Ran At", @"metric1", 
                                 @"mph", @"unit1", 
                                 @"Burnt", @"metric2",
                                 @"cal", @"unit2", 
                                 @"Ran For", @"metric3",
                                 @"mins", @"unit3",  
                                 [NSNumber numberWithBool:NO], @"hidden", nil]];
        [workoutTypes addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"Squat", @"name", 
                                 @"Weight", @"metric1", 
                                 @"lbs", @"unit1", 
                                 @"Sets", @"metric2",
                                 @"", @"unit2", 
                                 @"", @"metric3",
                                 @"", @"unit3",  
                                 [NSNumber numberWithBool:NO], @"hidden", nil]];
        [workoutTypes addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"Crunch", @"name", 
                                 @"Sets", @"metric1", 
                                 @"", @"unit1", 
                                 @"", @"metric2",
                                 @"", @"unit2", 
                                 @"", @"metric3",
                                 @"", @"unit3", 
                                 [NSNumber numberWithBool:YES], @"hidden", nil]];
        [workoutTypes addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"Lunge", @"name", 
                                 @"Sets", @"metric1", 
                                 @"", @"unit1", 
                                 @"", @"metric2",
                                 @"", @"unit2", 
                                 @"", @"metric3",
                                 @"", @"unit3", 
                                 [NSNumber numberWithBool:YES], @"hidden", nil]];
    } //Add some default workoutTypes objects
    [defaultData setValue:workoutTypes forKey:@"workoutTypes"];
    
    NSMutableArray *workoutsDone = [[NSMutableArray alloc] init];
    [defaultData setValue:workoutsDone forKey:@"workoutsDone"];
    
    NSMutableString *defaultValuesForTemplate1 = [[NSMutableString alloc] init];
    if (1) {
        defaultValuesForTemplate1 = (NSMutableString *)[defaultValuesForTemplate1 stringByAppendingString:@"Push Up"];
        defaultValuesForTemplate1 = (NSMutableString *)[defaultValuesForTemplate1 stringByAppendingString:WORKOUTORDER_DELIMITER];
        defaultValuesForTemplate1 = (NSMutableString *)[defaultValuesForTemplate1 stringByAppendingString:@""];
        defaultValuesForTemplate1 = (NSMutableString *)[defaultValuesForTemplate1 stringByAppendingString:WORKOUTORDER_DELIMITER];
        defaultValuesForTemplate1 = (NSMutableString *)[defaultValuesForTemplate1 stringByAppendingString:@""];
        defaultValuesForTemplate1 = (NSMutableString *)[defaultValuesForTemplate1 stringByAppendingString:WORKOUTORDER_DELIMITER];
        defaultValuesForTemplate1 = (NSMutableString *)[defaultValuesForTemplate1 stringByAppendingString:@""];
        defaultValuesForTemplate1 = (NSMutableString *)[defaultValuesForTemplate1 stringByAppendingString:WORKOUTORDER_DELIMITER];
        defaultValuesForTemplate1 = (NSMutableString *)[defaultValuesForTemplate1 stringByAppendingString:@"Treadmill"];
        defaultValuesForTemplate1 = (NSMutableString *)[defaultValuesForTemplate1 stringByAppendingString:WORKOUTORDER_DELIMITER];
        defaultValuesForTemplate1 = (NSMutableString *)[defaultValuesForTemplate1 stringByAppendingString:@""];
        defaultValuesForTemplate1 = (NSMutableString *)[defaultValuesForTemplate1 stringByAppendingString:WORKOUTORDER_DELIMITER];
        defaultValuesForTemplate1 = (NSMutableString *)[defaultValuesForTemplate1 stringByAppendingString:@""];
        defaultValuesForTemplate1 = (NSMutableString *)[defaultValuesForTemplate1 stringByAppendingString:WORKOUTORDER_DELIMITER];
        defaultValuesForTemplate1 = (NSMutableString *)[defaultValuesForTemplate1 stringByAppendingString:@""];
        defaultValuesForTemplate1 = (NSMutableString *)[defaultValuesForTemplate1 stringByAppendingString:WORKOUTORDER_DELIMITER];
        defaultValuesForTemplate1 = (NSMutableString *)[defaultValuesForTemplate1 stringByAppendingString:@"Lunge"];
        defaultValuesForTemplate1 = (NSMutableString *)[defaultValuesForTemplate1 stringByAppendingString:WORKOUTORDER_DELIMITER];
        defaultValuesForTemplate1 = (NSMutableString *)[defaultValuesForTemplate1 stringByAppendingString:@""];
        defaultValuesForTemplate1 = (NSMutableString *)[defaultValuesForTemplate1 stringByAppendingString:WORKOUTORDER_DELIMITER];
        defaultValuesForTemplate1 = (NSMutableString *)[defaultValuesForTemplate1 stringByAppendingString:@""];
        defaultValuesForTemplate1 = (NSMutableString *)[defaultValuesForTemplate1 stringByAppendingString:WORKOUTORDER_DELIMITER];
        defaultValuesForTemplate1 = (NSMutableString *)[defaultValuesForTemplate1 stringByAppendingString:@""];
    } //Set the default values for the default template
    NSMutableString *workoutsOrderForTemplate1 = [[NSMutableString alloc] init];
    if (1) {
        workoutsOrderForTemplate1 = (NSMutableString *)[workoutsOrderForTemplate1 stringByAppendingString:@"Push Up"];
        workoutsOrderForTemplate1 = (NSMutableString *)[workoutsOrderForTemplate1 stringByAppendingString:WORKOUTORDER_DELIMITER];
        workoutsOrderForTemplate1 = (NSMutableString *)[workoutsOrderForTemplate1 stringByAppendingString:@"Lunge"];
        workoutsOrderForTemplate1 = (NSMutableString *)[workoutsOrderForTemplate1 stringByAppendingString:WORKOUTORDER_DELIMITER];
        workoutsOrderForTemplate1 = (NSMutableString *)[workoutsOrderForTemplate1 stringByAppendingString:@"Treadmill"];
    } //Set the order for the default template
    NSMutableArray *workoutTemplates = [[NSMutableArray alloc] init];
    if (1) {
        [workoutTemplates addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                     @"Basic Exercises", @"name",
                                     [NSSet setWithObjects:@"Push Up", @"Treadmill", @"Lunge", nil], @"workoutTypes",
                                     workoutsOrderForTemplate1, @"workoutsOrder", 
                                     defaultValuesForTemplate1, @"workoutsDefaultValues", nil]];
    } //Add a default workoutTemplates objects
    [defaultData setValue:workoutTemplates forKey:@"workoutTemplates"];
    
    return defaultData;
}

- (void)putDefaultDataIntoStore
{
    id defaultData = [self generateDefaultData];
    id workoutTypes = [defaultData valueForKey:@"workoutTypes"];
    id workoutsDone = [defaultData valueForKey:@"workoutsDone"];
    id workoutTemplates = [defaultData valueForKey:@"workoutTemplates"];
        
    for (id workoutType in workoutTypes) {
        [WorkoutTypes workoutTypeWithName:[workoutType valueForKey:@"name"] 
                              metric1Name:[workoutType valueForKey:@"metric1"]  
                       metric1DefaultUnit:[workoutType valueForKey:@"unit1"]  
                              metric2Name:[workoutType valueForKey:@"metric2"]   
                       metric2DefaultUnit:[workoutType valueForKey:@"unit2"]  
                              metric3Name:[workoutType valueForKey:@"metric3"]   
                       metric3DefaultUnit:[workoutType valueForKey:@"unit3"]   
                         hidddenByDefault:[workoutType valueForKey:@"hidden"]   
                   inManagedObjectContext:self.managedObjectContext];
    }
    
    for (id workoutDone in workoutsDone) {
        [WorkoutsDone workoutDoneIs:[workoutDone valueForKey:@"name"]
                    WithMetric1Name:[workoutDone valueForKey:@"metric1"]
                        metric1Unit:[workoutDone valueForKey:@"unit1"] 
                       metric1Value:[workoutDone valueForKey:@"value1"] 
                        metric2Name:[workoutDone valueForKey:@"metric2"] 
                        metric2Unit:[workoutDone valueForKey:@"unit2"] 
                       metric2Value:[workoutDone valueForKey:@"value2"] 
                        metric3Name:[workoutDone valueForKey:@"metric3"] 
                        metric3Unit:[workoutDone valueForKey:@"unit3"] 
                       metric3Value:[workoutDone valueForKey:@"value3"] 
                             onDate:[workoutDone valueForKey:@"date"] 
             inManagedObjectContext:self.managedObjectContext];
    }
    
    for (id workoutTemplate in workoutTemplates) {
        [WorkoutTemplates templateIs:[workoutTemplate valueForKey:@"name"] 
                    withWorkoutTypes:[workoutTemplate valueForKey:@"workoutTypes"]  
                   workoutTypesOrder:[workoutTemplate valueForKey:@"workoutsOrder"]  
           workoutTypesDefaultValues:[workoutTemplate valueForKey:@"workoutsDefaultValues"]  
              inManagedObjectContext:self.managedObjectContext];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    
    
    UINavigationController *rootNavigationController = (UINavigationController *)[[tabBarController viewControllers] objectAtIndex:0];
    EnterWorkoutDetailsViewController *firstViewController = (EnterWorkoutDetailsViewController *)[rootNavigationController topViewController];

    UINavigationController *secondNavigationController = (UINavigationController *)[[tabBarController viewControllers] objectAtIndex:1];
    SelectedMonthDetailsViewController *secondViewController = (SelectedMonthDetailsViewController *)[secondNavigationController topViewController];
    
    UINavigationController *thirdNavigationController = (UINavigationController *)[[tabBarController viewControllers] objectAtIndex:2];
    WorkoutTypesViewController *thirdViewController = (WorkoutTypesViewController *)[thirdNavigationController topViewController];
    
    UINavigationController *fourthNavigationController = (UINavigationController *)[[tabBarController viewControllers] objectAtIndex:3];
    WorkoutTemplatesViewController *fourthViewController = (WorkoutTemplatesViewController *)[fourthNavigationController topViewController];
    
    
    NSManagedObjectContext *context = [self managedObjectContext];
	if (!context) {
		// Handle the error.
	}
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"appAlreadyInstalled"]) {
        [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"appAlreadyInstalled"];
        [defaults synchronize];
        [self putDefaultDataIntoStore];
        [self saveContext];
    }
    
    firstViewController.managedObjectContext = context;
    secondViewController.managedObjectContext = context;
    thirdViewController.managedObjectContext = context;
    fourthViewController.managedObjectContext = context;
    
    
    if (![defaults objectForKey:@"appLaunchCountSinceLastPrompt"]) {
        [defaults setObject:nil forKey:@"appLastReviewVersion"];
        [defaults setObject:nil forKey:@"appLastReviewDate"];
        [defaults setObject:nil forKey:@"appLastPromptDate"];
        [defaults setObject:[NSNumber numberWithInt:0] forKey:@"appLaunchCountSinceLastPrompt"];
        [defaults setObject:[NSNumber numberWithInt:0] forKey:@"promptCountSinceLastReview"];
        
        [defaults synchronize];
    }
    
    
    NSNumber *appLaunchCountSinceLastPrompt = [defaults objectForKey:@"appLaunchCountSinceLastPrompt"];
    [defaults setObject:[NSNumber numberWithInt:([appLaunchCountSinceLastPrompt intValue]+1)] forKey:@"appLaunchCountSinceLastPrompt"];
    [defaults synchronize];
    
    [self checkAndPromtUserForReviewIfNeeded];
    [self setUpAnalyticsTracking];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self saveContext];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self saveContext];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
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

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SweatTrack" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SweatTrack.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - User Review Prompt methods

- (void)checkAndPromtUserForReviewIfNeeded
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSDate *appLastReviewDate = [defaults objectForKey:@"appLastReviewDate"];
    NSDate *appLastPromptDate = [defaults objectForKey:@"appLastPromptDate"];
    NSNumber *appLaunchCountSinceLastPrompt = [defaults objectForKey:@"appLaunchCountSinceLastPrompt"];
    NSNumber *promptCountSinceLastReview = [defaults objectForKey:@"promptCountSinceLastReview"];
    
    int appLaunchLimitBeforePromptingAgain;
    
    if (!appLastReviewDate) {
        if ([promptCountSinceLastReview intValue] < 4)
            appLaunchLimitBeforePromptingAgain = 6;
        else
            appLaunchLimitBeforePromptingAgain = 12;
        
        NSTimeInterval daysSinceLastPrompt = [[NSDate date] timeIntervalSinceDate:appLastPromptDate]/(24*60*60);
        
        BOOL userHasBeenPromptedBefore = YES;
        if (isnan(daysSinceLastPrompt)) {
            userHasBeenPromptedBefore = NO;
        }
        
        if ([appLaunchCountSinceLastPrompt intValue] >= appLaunchLimitBeforePromptingAgain ) {
            if (userHasBeenPromptedBefore == NO || daysSinceLastPrompt >= 5) {
                UIAlertView *alertView = [[UIAlertView alloc] init];
                [alertView setMessage:@"Hi, you've probably been using this app quite a bit. We would love to know what you think about it.\n\nWould you like to rate or review it on App Store?"];
                [alertView setDelegate:self];
                [alertView addButtonWithTitle:@"Not yet."];
                [alertView addButtonWithTitle:@"Yes sure!"];
                [alertView show];
            }
        }
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[NSDate date] forKey:@"appLastPromptDate"];
    [defaults setObject:[NSNumber numberWithInt:0] forKey:@"appLaunchCountSinceLastPrompt"];
    [defaults synchronize];
    
    if (buttonIndex == 1) {
        
        [defaults setObject:[NSNumber numberWithInt:0] forKey:@"appLaunchCountSinceLastPrompt"];
        [defaults setObject:[NSNumber numberWithInt:0] forKey:@"promptCountSinceLastReview"];
        
        [defaults setObject:[NSDate date] forKey:@"appLastReviewDate"];
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                
        [defaults setObject:majorVersion forKey:@"appLastReviewVersion"];
        
        [defaults synchronize];
        
        NSString *appURL = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=536051158";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appURL]];
    }
    
    if (buttonIndex == 0) {
        
        NSNumber *promptCountSinceLastReview = [defaults objectForKey:@"promptCountSinceLastReview"];
        [defaults setObject:[NSNumber numberWithInt:([promptCountSinceLastReview intValue]+1)] forKey:@"promptCountSinceLastReview"];
        
        [defaults synchronize];
    }
}

#pragma mark - Analytics Tracking Set up method

- (void)setUpAnalyticsTracking
{
    [GAI sharedInstance].trackUncaughtExceptions = NO;
    [GAI sharedInstance].dispatchInterval = 30;
    [GAI sharedInstance].debug = NO;
    
    id <GAITracker> analyticsTracker;
    analyticsTracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-37769905-1"];
}

@end
