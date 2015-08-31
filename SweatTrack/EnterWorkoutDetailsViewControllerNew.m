//
//  EnterWorkoutDetailsViewControllerNewViewController.m
//  SweatTrack
//
//  Created by Anand Kumar 5 on 8/27/15.
//
//

#import "EnterWorkoutDetailsViewControllerNew.h"
#import "EnterWorkoutSampleCell.h"
#import "EnterWorkoutButtonsCell.h"
#import "EnterWorkoutPickerViewCell.h"

@interface EnterWorkoutDetailsViewControllerNew () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) IBOutlet UIPickerView *templatePickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation EnterWorkoutDetailsViewControllerNew

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.templatePickerView.hidden = YES;
    self.datePicker.hidden = YES;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"EnterWorkoutSampleCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"EnterWorkoutButtonsCell" bundle:nil] forCellWithReuseIdentifier:@"Cell1"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"EnterWorkoutPickerViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell2"];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.flowLayout.itemSize = CGSizeMake(self.view.frame.size.width, 50.0);
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView.scrollsToTop = YES;
//    self.collectionView.collectionViewLayout = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*r
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {

    NSInteger numberOfItems;
    if (section == 0) {
        numberOfItems = 3;
    }
    else {
        numberOfItems = 10;
    }
    
    return numberOfItems;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = (EnterWorkoutButtonsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell1" forIndexPath:indexPath];
        }
        else if (indexPath.row == 1) {
            cell = (EnterWorkoutPickerViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell2" forIndexPath:indexPath];
        }
        else if (indexPath.row == 2) {
            cell = (EnterWorkoutPickerViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell2" forIndexPath:indexPath];
        }
    }
    
//    EnterWorkoutSampleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell1" forIndexPath:indexPath];
    return cell;
}

/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        if (self.datePicker.hidden) {
            self.templatePickerView.hidden = YES;
            self.datePicker.hidden = NO;
        }
        else {
            self.datePicker.hidden = YES;
        }
    }
    else if (indexPath.section == 0 && indexPath.row == 2) {
        if (self.templatePickerView.hidden) {
            self.datePicker.hidden = YES;
            self.templatePickerView.hidden = NO;
        }
        else {
            self.templatePickerView.hidden = YES;
        }
    }
    
    NSLog(@"Selected");
}

@end
