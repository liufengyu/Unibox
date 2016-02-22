//
//  HelpDetailController.m
//  Unibox_iOS
//
//  Created by 刘羽 on 15/10/28.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#import "HelpDetailController.h"
#import "Header.h"
#import "UIImage+Extension.h"

@interface HelpDetailController ()

@end

@implementation HelpDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.navTitle;
    self.view.backgroundColor = [UIColor colorWithHexString:@"ededed"];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth- 20, kScreenHeight - kStatus_Height - kNav_Height - 10)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    if (self.type == 0) {
        UIImageView *imageView = [MyControl createImageViewFrame:CGRectMake(0, 0, bgView.width, 354) imageName:@"help01"];
        [bgView addSubview:imageView];
    }
    else if (self.type == 3)
    {
        UIScrollView *sc = [[UIScrollView alloc]initWithFrame:bgView.bounds];
        sc.showsVerticalScrollIndicator = NO;
        sc.bounces = NO;
        UILabel *label1 = [MyControl createLabelWithFrame:CGRectMake(5, 0, kScreenWidth-20-10, 50) Font:12.0f Text:@"一、什么是优博卡\n优博卡代表的是优博会员身份，购买不同面值的优博卡可享受不同的权益和优惠。\n二、优博卡的购买和激活\n方法一：在就近的优博卡代销商店购买。在优博网站www.unibox.com.cn上注册优博帐号并绑定优博卡，或者在租赁机上插入优博卡后即时注册。\n方法二：在优博网站www.unibox.com.cn上注册优博帐号后，在线购买优博卡。购买成功后，会立刻生成唯一的优博卡号，即可开始租碟。在线购买的优博卡会以邮寄的方式寄送给您。一般在3~7天之内就可以送达，运费由优尼博思承担。\n*买卡不退，充值可退！\n三、优博卡级别图示"];
        [label1 sizeToFit];
        [sc addSubview:label1];
        
        UIImageView *firstImage = [MyControl createImageViewFrame:CGRectMake((bgView.width - 455/2)/2, CGRectGetMaxY(label1.frame), 455.0/2, 59.0) imageName:@"help02"];
        [sc addSubview:firstImage];
        
        UILabel *label2 = [MyControl createLabelWithFrame:CGRectMake(5, CGRectGetMaxY(firstImage.frame), kScreenWidth - 30, 50) Font:12.0f Text:@"说明：购买面值100元的银卡，即成为银卡会员；购买面值150元的金卡，即成为金卡会员；购买200元的白金卡，即成为白金会员。\n四、优博卡级别资格和享有的服务"];
        [label2 sizeToFit];
        [sc addSubview:label2];
        
        //632 287
        UIImageView *secondImage = [MyControl createImageViewFrame:CGRectMake((bgView.width - 632/2)/2, CGRectGetMaxY(label2.frame) + 10, 632.0/2, 287.0/2) imageName:@"help03"];
        [sc addSubview:secondImage];
        
        UILabel *label3 = [MyControl createLabelWithFrame:CGRectMake(5, CGRectGetMaxY(secondImage.frame) + 5, kScreenWidth - 30, 50) Font:12.0f Text:@"*免租金碟片只限于DVD格式的碟片，蓝光碟不在免租金范围内。蓝光碟片押金可退！\n会员服务详细说明：\n\n一、银卡会员\n会员资格：任何愿意使用优博租赁服务，且购买面值100元的优博卡（银卡）的用户。\n权益：每次可免费租赁一张DVD类型的碟片，但超过24小时仍未还碟时，将开始收取次日的租金费用，以此类推！当租金费用累积超过碟片价格时，将视为您已购买此碟片。 银卡会员不能租赁蓝光碟片。\n升级：银卡会员只需缴纳50元升级费用，即可在账户中心里直接升级为金卡会员。\n充值：购买优博卡的会员费只是购买了会员资格，不代表充值金额。优博卡充值应另外购买充值卡，或在线充值！充值金额可退！\n有效期：会员卡的有效期为1年。有效期满后，您可以选择续费后继续使用。\n\n二、金卡会员\n会员资格：任何愿意使用优博租赁服务，且购买面值150元的优博卡（金卡)的用户。\n权益：每次可免费租赁两张DVD类型的碟片，但超过24小时仍未还碟时，将开始收取次日的租赁费用，以此类推！当租金费用累积超过碟片价格时，将视为您已购买此碟片。金卡用户每次可租赁1张蓝光碟片，还碟时退还押金。\n升级：金卡会员只需缴纳50元升级费用，即可在账户中心里直接升级为白金会员。\n充值：购买优博卡的会员费只是购买了会员资格，不代表充值金额。优博卡充值应另外购买充值卡，或在线充值！充值金额可退！\n有效期：会员卡的有效期为1年。有效期满后，您可以选择续费后继续使用。\n\n三、白金卡会员\n会员资格：任何愿意使用优博租赁服务，且购买面值200元的优博卡（白金卡)的用户。\n权益：每次可免费租赁三张DVD类型的碟片，但超过24小时仍未还碟时，将开始收取次日的租赁费用，以此类推！ 当租金费用累积超过碟片价格时，将视为您已购买此碟片。金卡用户每次可租赁1张蓝光碟片，还碟时退还押金。\n升级：白金卡会员为最高级会员，不能升级。\n充值：购买优博卡的会员费只是购买了会员资格，不代表充值金额。优博卡充值应另外购买充值卡，或在线充值！充值金额可退！\n有效期：会员卡的有效期为1年。有效期满后，您可以选择续费后继续使用。\n二、金卡会员\n会员资格：任何愿意使用优博租赁服务，且购买面值150元的优博卡（金卡)的用户。\n权益：每次可免费租赁两张DVD类型的碟片，但超过24小时仍未还碟时，将开始收取次日的租赁费用，以此类推！当租金费用累积超过碟片价格时，将视为您已购买此碟片。金卡用户每次可租赁1张蓝光碟片，还碟时退还押金。\n升级：金卡会员只需缴纳50元升级费用，即可在账户中心\n\n权益：每次可免费租赁两张DVD类型的碟片，但超过24小时仍未还碟时，将开始收取次日的租赁费用，以此类推！当租金费用累积超过碟片价格时，将视为您已购买此碟片。金卡用户每次可租赁1张蓝光碟片，还碟时退还押金。\n升级：金卡会员只需缴纳50元升级费用，即可在账户中心里直接升级为白金会员。\n充值：购买优博卡的会员费只是购买了会员资格，不代表充值金额。优博卡充值应另外购买充值卡，或在线充值！充值金额可退！\n有效期：会员卡的有效期为1年。有效期满后，您可以选择续费后继续使用。\n三、白金卡会员\n会员资格：任何愿意使用优博租赁服务，且购买面值200元的优博卡（白金卡)的用户。\n权益：每次可免费租赁三张DVD类型的碟片，但超过24小时仍未还碟时，将开始收取次日的租赁费用，以此类推！ 当租金费用累积超过碟片价格时，将视为您已购买此碟片。金卡用户每次可租赁1张蓝光碟片，还碟时退还押金。\n升级：白金卡会员为最高级会员，不能升级。\n充值：购买优博卡的会员费只是购买了会员资格，不代表充值金额。优博卡充值应另外购买充值卡，或在线充值！有效期：会员卡的有效期为1年。有效期满后，您可以选择续费后继续使用。\n温馨提示：退款周期仅供您参考，具体退款周期可能会受银行、支付机构等相关因素影响。\n*出于对消费者的信任，我们不以任何方式收取DVD碟的租金费用。 为了使广大消费者都能及时看到好的电影，也为了减少您的租金费用，请您及时归还碟片！"];
        [label3 sizeToFit];
        [sc addSubview:label3];
        
        sc.contentSize = CGSizeMake(bgView.width, CGRectGetMaxY(label3.frame) + 10);
        [bgView addSubview:sc];
    }
    else{
        
        NSString *urlString = [[NSBundle mainBundle] pathForAuxiliaryExecutable:[NSString stringWithFormat:@"%ld.rtf",self.type]];
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *requestUrl = [NSURL URLWithString:urlString];
        UITextView *textView = [[UITextView alloc]initWithFrame:bgView.bounds];
        textView.text = [NSString stringWithContentsOfURL:requestUrl encoding:0x80000631 error:nil];
        
        [bgView addSubview:textView];
        
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:requestUrl];
        UIWebView *webView = [[UIWebView alloc]initWithFrame:bgView.bounds];
        webView.scrollView.showsVerticalScrollIndicator = NO;
        webView.scrollView.bounces = NO;
        [webView loadRequest:request];
        [bgView addSubview:webView];
    }
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
