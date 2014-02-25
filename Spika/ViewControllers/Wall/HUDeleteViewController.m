//
//  HUDeleteViewController.m
//  Spika
//
//  Created by Alex on 21.02.2014..
//
//

#import "HUDeleteViewController.h"
#import "HUBaseViewController+Style.h"
#import "DatabaseManager.h"
#import "HUWallViewController.h"
#import "AppDelegate.h"

@interface HUDeleteViewController ()

@property (strong, nonatomic) NSArray *buttons;
@property int deleteTypeOld;
@property int deleteType;

@end

@implementation HUDeleteViewController {
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    self.buttons = [NSArray arrayWithObjects:deleteDontButton,deleteNowButton,deleteIn5MinButton,deleteAfterDayButton,deleteAfterWeekButton,deleteAfterReadButton,nil];
    int deleteType = self.message.deleteType;
    
    self.deleteType = deleteType;
    self.deleteTypeOld = deleteType;
    
    NSLog(@"delete type ??? %d", deleteType);
    
    UIButton *button = [self.buttons objectAtIndex:deleteType];
    [self setButtonSelection:button selected:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClick:(id)sender {
    
    UIButton *pressedButton = (UIButton*)sender;
    
    for (int i = 0; i < [self.buttons count]; i++) {
        UIButton *button = [_buttons objectAtIndex:i];
        
        if ([pressedButton isEqual:button]) {
            self.deleteType = i;
            [self setButtonSelection:button selected:YES];
        }
        else {
            [self setButtonSelection:button selected:NO];
        }
    }
    
    for (UIButton *button in self.buttons) {
        
        
    }
}

- (void)setButtonSelection:(UIButton*)button selected:(bool)selected {
    [button setSelected:selected];
    if (selected) {
        [button setBackgroundColor:[HUBaseViewController colorWithSharedColorType:HUSharedColorTypeRed]];
    }
    else {
        [button setBackgroundColor:[UIColor grayColor]];
    }
}

- (void)onClose {
    if (_deleteType != _deleteTypeOld) {
        [[DatabaseManager defaultManager] setDeleteOnMessageId:self.message._id
                                                    deleteType:self.deleteType
                                                       success:^(id result) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               NSLog(@"RELOAD");
                                                               UINavigationController *navController = [AppDelegate getInstance].navigationController;
                                                               HUBaseViewController *baseVC = navController.viewControllers[navController.viewControllers.count - 1];
                                                               if (baseVC) {
                                                                   if ([baseVC isKindOfClass:[HUWallViewController class]]) {
                                                                       HUWallViewController *parent = (HUWallViewController *)baseVC;
                                                                       [parent reloadAll];
                                                                   }
                                                               }
                                                           });
                                                       }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end