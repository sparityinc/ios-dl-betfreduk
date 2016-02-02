//
//  SPVerificationQuestionsViewController.m
//  WarHorse
//
//  Created by Hiteshwar Vadlamudi on 22/10/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import "SPVerificationQuestionsViewController.h"
#import "ZLAPIWrapper.h"
#import "ZLAppDelegate.h"
#import "WarHorseSingleton.h"

@interface SPVerificationQuestionsViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *questionsarray;
@property (strong, nonatomic) NSMutableDictionary *answersDic;

@property (assign, nonatomic) NSInteger marks;
@property (assign, nonatomic) NSInteger currentQuestionIndex;

@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, strong) IBOutlet UIImageView *questionsImageView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

@property (strong, nonatomic) IBOutlet UILabel *questionlabel;
@property (strong, nonatomic) IBOutlet UIImageView *questionNoImgView;

@property (assign, nonatomic) BOOL isVerificationQuestions;

//Alert View

@property (strong, nonatomic) IBOutlet UILabel *abortRegistrationLabel;
@property (strong, nonatomic) IBOutlet UILabel *quitRegistrationLabel;
@property (strong, nonatomic) IBOutlet UIView *popOverAlertView;

- (IBAction)goToNextView:(id)sender;

@end

@implementation SPVerificationQuestionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - ViewLifeCycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.questionsarray = [[NSMutableArray alloc] initWithCapacity:0];
    self.answersDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    self.currentQuestionIndex = 0;
    [self loadVerificationQuestionsData];
    [self prepareAbortRegistrationAlertView];

    [self.questionlabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:15.0]];
    
    [self.questionNoImgView setHidden:YES];
    [self.questionlabel setHidden:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private API

- (void)prepareAbortRegistrationAlertView
{
    [self.abortRegistrationLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:15.0]];
    [self.quitRegistrationLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:15.0]];
}

- (IBAction)closeRegistration:(id)sender
{
    
    [self.view addSubview:self.popOverAlertView];
}

- (IBAction)cancelAlertView:(id)sender
{
    [self.popOverAlertView removeFromSuperview];
}

- (IBAction)quitRegistration:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];

}


- (void)loadVerificationQuestionsData
{
    
    self.isVerificationQuestions = YES;
    
    self.imagesArray = [[NSArray alloc] initWithObjects:@"question1.png",@"question2.png",@"question3.png",@"question4.png",@"question5.png",@"question6.png", nil];
    
    self.questionsImageView.image = [UIImage imageNamed:[self.imagesArray objectAtIndex:self.currentQuestionIndex]];

    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
     [ZLAppDelegate showLoadingView];
    
    ZLAPIWrapper *apiwrapper = [ZLAppDelegate getApiWrapper];
        
    NSDictionary *argumentsDic = @{@"stage_num":@"1",
                                  @"reference":[self.userDetailsDic valueForKey:@"reference"]};
    
    [apiwrapper getIdologyWithParameters:argumentsDic success:^(NSDictionary *_userInfo) {
        
         [ZLAppDelegate hideLoadingView];
        [self.questionNoImgView setHidden:NO];
        [self.questionlabel setHidden:NO];
        
        if ([[_userInfo valueForKey:@"verificationResponse"] valueForKey:@"valid"]) {
            [self.questionsarray setArray:[[_userInfo valueForKey:@"verificationResponse"] valueForKey:@"questions"]];
            
            
            [self prepareViewForQuestion:self.currentQuestionIndex];
            [self.answersDic setValue:@"2" forKey:@"stage_num"];
            [self.answersDic setValue:[self.userDetailsDic valueForKey:@"reference"] forKey:@"reference"];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error in getting questions, please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
            
        
    } failure:^(NSError *error) {
         [ZLAppDelegate hideLoadingView];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error in getting questions, please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }];
    
    
}

- (void)submitAnswers
{
    ZLAPIWrapper *apiwrapper = [ZLAppDelegate getApiWrapper];
    
    [self.questionlabel setText:@""];
    
    [self.questionNoImgView setHidden:YES];
    [self.questionlabel setHidden:YES];
    
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
     [ZLAppDelegate showLoadingView];
    [apiwrapper getIdologyWithParameters:self.answersDic success:^(NSDictionary *_userInfo) {
        
         [ZLAppDelegate hideLoadingView];
        if (![[_userInfo valueForKey:@"verificationResponse"] valueForKey:@"valid"]) {
        
            [self.nextButton setEnabled:YES];
            self.currentQuestionIndex = 0;
            if (self.isVerificationQuestions == YES) {
                
                [self loadChallengeQuestionsData];
            }
            else
            {
                [self registerUser];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error from Server" message:@"Error in submitting Answers" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failure:^(NSError *error) {
         [ZLAppDelegate hideLoadingView];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error in Submitting Answers, please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }];
}

- (void)loadChallengeQuestionsData
{
    
    self.isVerificationQuestions = NO;
    
    [self.questionsImageView setFrame:CGRectMake(108, 54, 104, 37)];
    
    self.imagesArray = [[NSArray alloc] initWithObjects:@"challengeQuestion1.png",@"challengeQuestion2.png",@"challengeQuestion3.png", nil];
    
    self.questionsImageView.image = [UIImage imageNamed:[self.imagesArray objectAtIndex:self.currentQuestionIndex]];
    
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [ZLAppDelegate showLoadingView];
    ZLAPIWrapper *apiwrapper = [ZLAppDelegate getApiWrapper];
    
    NSDictionary *argumentsDic = @{@"stage_num":@"3",
                                   @"reference":[self.userDetailsDic valueForKey:@"reference"]};
    
    [apiwrapper getIdologyWithParameters:argumentsDic success:^(NSDictionary *_userInfo) {
        
         [ZLAppDelegate hideLoadingView];
        
        [self.questionNoImgView setHidden:NO];
        [self.questionlabel setHidden:NO];
        
        if ([[_userInfo valueForKey:@"verificationResponse"] valueForKey:@"valid"]) {
        
        [self.questionsarray setArray:[[_userInfo valueForKey:@"verificationResponse"] valueForKey:@"questions"]];
        
        [self.nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
        [self prepareViewForQuestion:self.currentQuestionIndex];
        
        if (self.answersDic != nil) {
            self.answersDic = nil;
            self.answersDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        }
        
        [self.answersDic setValue:@"4" forKey:@"stage_num"];
        [self.answersDic setValue:[self.userDetailsDic valueForKey:@"reference"] forKey:@"reference"];
        
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error in getting questions, please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failure:^(NSError *error) {
        
         [ZLAppDelegate hideLoadingView];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error in getting questions, please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }];
    
    
}

- (void)registerUser
{
    [self.scrollView setHidden:YES];
    [self.nextButton setHidden:YES];
    
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
     [ZLAppDelegate showLoadingView];
    ZLAPIWrapper *apiwrapper = [ZLAppDelegate getApiWrapper];
    
    NSDictionary *argumentsDic = @{@"user_name":[self.userDetailsDic valueForKey:@"username"],
                                   @"user_password":[self.userDetailsDic valueForKey:@"password"],
                                   @"reference":[self.userDetailsDic valueForKey:@"reference"],
                                   @"action":@"confrm"};
    
    [apiwrapper registerAdwUserWithDetails:argumentsDic success:^(NSDictionary *_userInfo) {
         [ZLAppDelegate hideLoadingView];
         if ([[_userInfo valueForKey:@"verificationResponse"] valueForKey:@"valid"]) {
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"User successfully registered" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
         }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Unable to register user" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        }
        
    } failure:^(NSError *error) {
        
         [ZLAppDelegate hideLoadingView];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Unable to register user" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }];
    
}

- (void)prepareViewForQuestion:(NSInteger)questionno
{
    self.questionlabel.text = [[self.questionsarray objectAtIndex:questionno] valueForKey:@"question"];
    
    CGSize maximumquestionlabelSize = CGSizeMake(245,9999);
    CGSize expectedquestionlabelSize=  [self.questionlabel.text boundingRectWithSize: maximumquestionlabelSize options: NSStringDrawingUsesLineFragmentOrigin attributes: @{ NSFontAttributeName: self.questionlabel.font } context: nil].size;
//Deprecated sizeWithFont
//    CGSize expectedquestionlabelSize = [self.questionlabel.text sizeWithFont:self.questionlabel.font constrainedToSize:maximumquestionlabelSize lineBreakMode:self.questionlabel.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect questionlabelNewFrame = self.questionlabel.frame;
    questionlabelNewFrame.size.height = expectedquestionlabelSize.height;
    self.questionlabel.frame = questionlabelNewFrame;
    
    NSArray *optionsArray = [[NSArray alloc] initWithArray:[[self.questionsarray objectAtIndex:questionno] valueForKey:@"answers"]];
        
   [optionsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      
       NSString *str = [NSString stringWithFormat:@"%d. %@",idx,obj];
              
       UILabel *optionsLabel =  [[UILabel alloc] initWithFrame:CGRectMake(55, 0, 245, 0)];
       [optionsLabel setTag:idx + 10];
       [optionsLabel setText:[optionsArray objectAtIndex:0]];
       [optionsLabel setBackgroundColor:[UIColor clearColor]];
       [optionsLabel setText:str];
       [optionsLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:14.0]];
       [optionsLabel sizeToFit];
       optionsLabel.lineBreakMode = NSLineBreakByWordWrapping;
       optionsLabel.numberOfLines = 10;
       [self.scrollView addSubview:optionsLabel];
       
       UIButton *optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       [optionBtn setFrame:CGRectMake(6, 0, 30, 30)];
       [optionBtn setBackgroundImage:[UIImage imageNamed:@"walletTermsAndConditionsNormal.png"] forState:UIControlStateNormal];
       [optionBtn setBackgroundImage:[UIImage imageNamed:@"walletTermsAndConditionsSelect.png"] forState:UIControlStateSelected];
       [optionBtn setTag:idx + 20];
       [optionBtn addTarget:self action:@selector(selectOption:) forControlEvents:UIControlEventTouchUpInside];
       [self.scrollView addSubview:optionBtn];
       
       UILabel *previousLabel = (UILabel *)[self.scrollView viewWithTag:idx + 9]; // Tag 9 is Questionlabel tag
       
       
       if (idx != 0) {
           UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 1)];
           [separatorLine setBackgroundColor:[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1.0]];
           [separatorLine setTag:idx + 30];
           [self.scrollView addSubview:separatorLine];
           
            [self makeFrameForLabel:optionsLabel basedOnPreviousLabel:previousLabel withOptionBtn:optionBtn andSeparatorLine:separatorLine];
       }
       else
       {
           [self makeFrameForLabel:optionsLabel basedOnPreviousLabel:previousLabel withOptionBtn:optionBtn];
       }
       
       if (idx == [optionsArray count] - 1) {

           UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 1)];
           [separatorLine setBackgroundColor:[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1.0]];
           [separatorLine setTag:[optionsArray count] + 30];
           [self.scrollView addSubview:separatorLine];

           CGRect separatorLineFrame = separatorLine.frame;
           separatorLineFrame.origin.y = optionsLabel.frame.origin.y + optionsLabel.frame.size.height + 9;
           separatorLine.frame = separatorLineFrame;
           
           CGRect nextBtnFrame = self.nextButton.frame;
           
           if (IS_IPHONE5) {
               
               if (!(optionsLabel.frame.origin.y + optionsLabel.frame.size.height + 25 < 404)) {
                   nextBtnFrame.origin.y = optionsLabel.frame.origin.y + optionsLabel.frame.size.height + 25;
               }
           }
           else
           {
               if (!(optionsLabel.frame.origin.y + optionsLabel.frame.size.height + 25 < 316)) {
                   nextBtnFrame.origin.y = optionsLabel.frame.origin.y + optionsLabel.frame.size.height + 25;
               }
           }
           
           self.nextButton.frame = nextBtnFrame;
           
           [self.scrollView setContentSize:CGSizeMake(320, self.nextButton.frame.origin.y + self.nextButton.frame.size.height + 10)];
       }
       
   }];
    
    self.questionsImageView.image = [UIImage imageNamed:[self.imagesArray objectAtIndex:self.currentQuestionIndex]];
    
    [self.nextButton setEnabled:NO];
}

- (void)makeFrameForLabel:(UILabel *)newLabel basedOnPreviousLabel:(UILabel *)oldLabel withOptionBtn:(UIButton *)optionBtn
{
    CGSize maximumquestionlabelSize = CGSizeMake(232,9999);
    
    [oldLabel sizeToFit];
    [newLabel sizeToFit];
    
    CGSize expectedquestionlabelSize=  [oldLabel.text boundingRectWithSize: maximumquestionlabelSize options: NSStringDrawingUsesLineFragmentOrigin attributes: @{ NSFontAttributeName: oldLabel.font } context: nil].size;
//Deprecated sizeWithFont
//    CGSize expectedquestionlabelSize = [oldLabel.text sizeWithFont:oldLabel.font constrainedToSize:maximumquestionlabelSize lineBreakMode:oldLabel.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect newLabelFrame = newLabel.frame;
    if (oldLabel == self.questionlabel) {
        
        if (oldLabel.frame.size.height <= 21) {
            newLabelFrame.origin.y = oldLabel.frame.origin.y + oldLabel.frame.size.height + 30;
        }
        else
        {
            newLabelFrame.origin.y = oldLabel.frame.origin.y + oldLabel.frame.size.height + 22;
        }
    }
    else
    {
        newLabelFrame.origin.y = oldLabel.frame.origin.y + oldLabel.frame.size.height + 18;
    }
    newLabelFrame.size.height = expectedquestionlabelSize.height;
    newLabel.frame = newLabelFrame;
    
    
    CGRect optionBtnFrame = optionBtn.frame;
    optionBtnFrame.origin.y = newLabelFrame.origin.y - 7;
    optionBtn.frame = optionBtnFrame;
 
    UIView *questionsSeparatorLine = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 2)];
    [questionsSeparatorLine setBackgroundColor:[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1.0]];
    [questionsSeparatorLine setTag:29];
    [self.scrollView addSubview:questionsSeparatorLine];
    
    CGRect questionsSeparatorLineFrame = questionsSeparatorLine.frame;
    questionsSeparatorLineFrame.origin.y = newLabel.frame.origin.y - 10;
    questionsSeparatorLine.frame = questionsSeparatorLineFrame;
    
    
}


- (void)makeFrameForLabel:(UILabel *)newLabel basedOnPreviousLabel:(UILabel *)oldLabel withOptionBtn:(UIButton *)optionBtn andSeparatorLine:(UIView *)separatorLine
{
    CGSize maximumquestionlabelSize = CGSizeMake(232,9999);
    
    [oldLabel sizeToFit];
    [newLabel sizeToFit];
    
    CGSize expectedquestionlabelSize=  [oldLabel.text boundingRectWithSize: maximumquestionlabelSize options: NSStringDrawingUsesLineFragmentOrigin attributes: @{ NSFontAttributeName: oldLabel.font } context: nil].size;
//Deprecated sizeWithFont
//    CGSize expectedquestionlabelSize = [oldLabel.text sizeWithFont:oldLabel.font constrainedToSize:maximumquestionlabelSize lineBreakMode:oldLabel.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect newLabelFrame = newLabel.frame;
    if (oldLabel == self.questionlabel) {
        newLabelFrame.origin.y = oldLabel.frame.origin.y + oldLabel.frame.size.height + 22;
    }
    else
    {
        newLabelFrame.origin.y = oldLabel.frame.origin.y + oldLabel.frame.size.height + 18;
    }
    newLabelFrame.size.height = expectedquestionlabelSize.height;
    newLabel.frame = newLabelFrame;
    
    
    CGRect optionBtnFrame = optionBtn.frame;
    optionBtnFrame.origin.y = newLabelFrame.origin.y - 7;
    optionBtn.frame = optionBtnFrame;
    
    if (oldLabel.tag >= 10) {
        CGRect separatorLineFrame = separatorLine.frame;
        separatorLineFrame.origin.y = newLabel.frame.origin.y - 9;
        separatorLine.frame = separatorLineFrame;
    }
   
    
}

- (void)selectOption:(UIButton *)sender
{
    [self.nextButton setEnabled:YES];

    [[[self.questionsarray objectAtIndex:self.currentQuestionIndex] valueForKey:@"answers"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIButton *btn = (UIButton *)[self.scrollView viewWithTag:idx + 20];
        [btn setSelected:NO];
        
        if (sender.selected == NO) {
            sender.selected = YES;
        }
        
    }];
    
}


- (IBAction)goToNextView:(id)sender {
    
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    [[[self.questionsarray objectAtIndex:self.currentQuestionIndex] valueForKey:@"answers"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        
        UIButton *btn = (UIButton *)[self.scrollView viewWithTag:idx + 20];
        if (btn.selected == YES) {

            [self.answersDic setValue:[[self.questionsarray objectAtIndex:self.currentQuestionIndex] valueForKey:@"type"] forKey:[NSString stringWithFormat:@"type%ld",self.currentQuestionIndex + 1]];
            [self.answersDic setValue:obj forKey:[NSString stringWithFormat:@"answer%ld",self.currentQuestionIndex + 1]];
        
        }
        [btn removeFromSuperview];
        btn = nil;
        
        UILabel *optionsLabel = (UILabel *) [self.scrollView viewWithTag:idx + 10];
        [optionsLabel removeFromSuperview];
        optionsLabel = nil;
            
        UIView *separatorLine = (UIView *) [self.scrollView viewWithTag:idx + 30];
        [separatorLine removeFromSuperview];
        separatorLine = nil;
        
    }];
    
    UIView *separatorLine = (UIView *) [self.scrollView viewWithTag:[[[self.questionsarray objectAtIndex:self.currentQuestionIndex] valueForKey:@"answers"] count] + 30];
    [separatorLine removeFromSuperview];
    separatorLine = nil;
    
    UIView *questionSeparatorLine = (UIView *) [self.scrollView viewWithTag:29];
    [questionSeparatorLine removeFromSuperview];
    questionSeparatorLine = nil;
    
    self.currentQuestionIndex++;
    
    if (self.currentQuestionIndex < [self.questionsarray count]) {
        
        if (self.currentQuestionIndex == [self.questionsarray count] - 1) {
            [self.nextButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
        }
        [self prepareViewForQuestion:self.currentQuestionIndex];
        
    }
    else {
        
        if (self.isVerificationQuestions == YES) {
            [self.questionsImageView setImage:[UIImage imageNamed:[self.imagesArray objectAtIndex:self.currentQuestionIndex]]];
        }
        
        [self.nextButton setEnabled:NO];
        [self submitAnswers];
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
