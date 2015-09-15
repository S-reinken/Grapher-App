//
//  GraphingScreenViewController.m
//  Grapherator
//
//  Created by Schuyler Reinken on 9/4/15.
//  Copyright (c) 2015 Harmonic. All rights reserved.
//

#import "GraphingScreenViewController.h"
#import "CustomView.h"
#import "Function.h"
#import "SWRevealViewController.h"

@interface GraphingScreenViewController ()

@property (weak, nonatomic) IBOutlet UIButton *graphButton;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property IBOutlet CustomView *graphView;
@property Function *function;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (strong, nonatomic) IBOutlet UINavigationItem *toolbar;

@end

@implementation GraphingScreenViewController

- (void)viewDidLoad {
    
    
    
    double width = 300;
    _graphView = [[CustomView alloc]initWithFrame:CGRectMake(50, 150, width, width)];
    _graphView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_graphView];
    
    [super viewDidLoad];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.menuButton setTarget: self.revealViewController];
        [self.menuButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [_graphButton addTarget:self action:@selector(drawGraph:) forControlEvents:UIControlEventTouchDown];
    
    _function = [[Function alloc] init:@"" withWindowWidth:width zoom:10];
    
    //NSLog(@"\nValue is: %f", [function eval:@"2^(x)" currentTotal:0 withValue:4]);
    
}

- (IBAction)drawGraph:(id)sender {
    
    NSString *string = [NSString stringWithFormat:@"y = %@", _textField.text];
    _label.text = string;
    [_function setFunctionString:_textField.text];
    _graphView.function = _function;
    _graphView.value = true;
    [_graphView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
