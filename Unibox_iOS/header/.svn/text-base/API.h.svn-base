//
//  API.h
//  Unibox_iOS
//
//  Created by 刘羽 on 15/10/26.
//  Copyright © 2015年 刘羽. All rights reserved.
//

#ifndef API_h
#define API_h

//#define Host_IP @"www.dev.unibox.com.cn/App"
//登录URL
//参数1:phone   11位数字
//参数2:psd     用户密码md5后的字符串
#define Login_URL @"/Login/login"

//校验手机号URL
//参数:phone    11位数字

#define CheckPhone_URL @"/Login/checkPhone"

//发送验证码
//参数1:phone    11位数字
//参数2:type     1 注册
//              2 找回密码
#define SendVCode_URL @"/VCode/send"

//注册
/*
 ** phone    11位数字
 ** psd1     第一次密码md5后的字符串
 ** psd2     第二次密码md5后的字符串
 ** vcode    验证码
 ** vid      验证码对应唯一ID
 */
#define Register_URL @"/Login/register"

//设置新密码
/*
 **phone    11位数字
 **psd1     第一次密码md5后的字符串
 **psd2     第二次密码md5后的字符串
 **vid      验证码对应唯一ID
 ** vcode       验证码
 */
#define ResetPsd_URL @"/Login/resetPsd"

//获取影片筛选信息
/*
 
 */
#define GetMovieSearchConfig @"/Movie/getSearchConfig"

//获取影片列表
/*
 * 参数：
 ** orderType        排序方式 （传配置中的key）
 ** movieGenre       影片类型（传配置中的key）
 ** titleType        碟片类型（传配置中的key）
 ** movieYear        年份（传配置中的key）
 ** search           搜索关键字
 ** page             页码，从1开始 用于下拉刷新
 ** key              缓存用key，用于下拉刷新，默认传空或不传，下拉刷新时
 传接口上次返回的key
 */
#define GetMovieList_URL @"/Movie/getMovieList"

#define Image_IP @"http://cdn.dev.unibox.com.cn/"
#define Zixun_IP @"http://www.dev.unibox.com.cn/App/News/detail"
#define Huodong_IP @"http://www.dev.unibox.com.cn/App/Act/detail"
#define Prevue_IP @"http://www.dev.unibox.com.cn/App/Prevue/detail"
//images/2015-10-12/561b718c38c8c.jpg
//获取影片详情
/*
 * 控制器：Movie
 * 方法：  getMovieInfo
 * 参数：
 ** titleId        碟片ID
 */
#define GetMovieDetail_URL @"/Movie/getMovieInfo"

//收藏相关

//添加收藏
/*
 * 控制器：Fav
 * 方法：  addUserFav
 * 参数：
 ** titleId          碟片ID
 ** note             备注
 ** _memberId        用户ID
 ** _accessToken     用户accessToken
 * 返回：
 {
 ret : 0:成功； 1：失败
 favId : 收藏唯一ID
 }
 */
#define AddFav_URL @"/Fav/addUserFav"

//获取收藏列表
/*
 * 控制器：Fav
 * 方法：  getUserFav
 * 参数：  ** _memberId        用户ID
 *        * _accessToken     用户accessToken
 * 返回：
 {
 ret : 0:成功； 1：失败
list : [
 {
 favId : 收藏唯一ID，
 titleId : 碟片ID
 movieName : 影片名
 movieImg : 影片图片
 synopsis : 摘要
 blueray : 是否蓝光   0：不是，1：是
 }
 ...
 ]
 }
 */
#define GetFavList_URL @"/Fav/getUserFav"

//删除收藏
/*
 * 控制器：Fav
 * 方法：  deleteUserFav
 * 参数：
 ** favId            收藏唯一ID, 多个用逗号隔开
 ** _memberId        用户ID
 ** _accessToken     用户accessToken
 * 返回：
 {
 ret : 0:成功； 1：失败
 }
 */
#define DelFav_URL @"/Fav/deleteUserFav"

//添加到购物车
/*
 * 控制器：Cart
 * 方法：  addUserCart
 * 参数：
 ** titleId          碟片ID
 ** _memberId        用户ID
 ** _accessToken     用户accessToken
 * 返回：
 {
 ret : 0:成功；
 }
 */
#define AddCart_URL @"/Cart/addUserCart"

//获取用户购物车列表
/*
 * 控制器：Cart
 * 方法：  getUserCart
 * 参数：
 ** _memberId        用户ID
 ** _accessToken     用户accessToken
 * 返回：
 {
 ret : 0:成功;
 fav : [
 {
 recId : 购物车唯一ID，
 titleId : 碟片ID
 addTime : 添加时间，例：2015-10-27 20:00:00
 movieName : 影片名
 movieImg : 影片图片
 dailyFee : 每日租金
 deposit  : 押金
 }
 ...
 ]
 }
 */
#define GetUserCart_URL @"/Cart/getUserCart"

//删除购物车
/*
 * 控制器：Cart
 * 方法：  deleteUserCart
 * 参数：
 ** _memberId        用户ID
 ** _accessToken     用户accessToken
 ** recId            购物车唯一ID, 多个用逗号隔开
 * 返回：
 {
 ret : 0:成功； 1：失败
 }
 */
#define DelUserCart @"/Cart/deleteUserCart"

//计算购物车商品价格
/*参数
 *titleId          碟片ID，多个用逗号隔开
 */
#define calTotalDeposit @"/Cart/calDeposit"
//www.dev.unibox.com.cn/App


//获取评论列表
#define GetCommentList @"/Comment/getCommentList"

//获取租赁机列表
#define GetKioskList @"/Kiosk/getKioskList"
//选择租赁机
//参数  kioskId   租赁机ID
#define SelectKiosk @"/Kiosk/selectKiosk"

//提交订单
#define SubmitRental @"/Rental/rental"

//获取订单列表
/*
 ** type :   all:全部（默认）
 reserve : 已预订
 rental : 已取碟
 complete : 已还碟
 cancel ： 已取消
 ** page : 第几页，用于下拉功能，默认1
 */
#define getRentalList @"/Rental/getRentalList"


/**
 取消订单
 rentalId   订单ID
 */
#define cancelRental @"/Rental/cancelRental"

/**
 删除订单
 rentalId  订单ID
 */
#define deleteRnetal @"/Rental/deleteRental"

//二维码扫描
#define QrCode @"/QrCode/scan"

//获取用户个人资料
#define getMemberProfile @"/Profile/getMemberProfile"

//更新用户个人资料
/*
 ** nickName : 用户昵称，为空则忽略
 ** sex : 性别, 1:男; 2:女， 为空则忽略
 ** birth: 生日，例:2015-01-01，位空则忽略
 ** state : 省份名, 为空则忽略
 ** city : 城市名, 为空则忽略
 ** interest : 兴趣Id，多个用逗号隔开
 */
/*
 ret 0:成功 1:无效的用户 2:无效的参数 3:系统错误
 */
#define updateMemberProfile @"/Profile/updateMemberProfile"

//修改密码
/*
 ** oldPsd : 旧密码
 ** psd1 : 新密码
 ** psd2 : 确认密码
 */
/*
 ret 0:成功, 1:参数错误, 2:两次密码不一致 4:旧密码错误 5:系统错误
 */
#define changePsd @"/Login/changePsd"

//退出登录
/*
 ret 0:成功
 */
#define logout @"/Login/logout"

//获取用户个人信息(我的页面)
/**
 *_memberId
 *_accessToken
 */
#define getAccountInfo @"/Member/account"

//首页数据
#define indexList @"/index/index"
//首页猜你喜欢数据
#define getLike @"/index/getLike"

//获取充值charge
/*
 ** channel ： 支付方式, eg: wx, alipay
 ** paymentSubject : 商品名
 ** paymentBody : 商品描述
 ** amount : 充值金额，类型为充值时要传的参数
 */
#define getCharge @"/pay/topup"

//获取会员升级支付
/*
 *type 类型： bevip:成为vip
 *channel ： 支付方式，eg: wx, alipay, (余额支付：account)
 *paymentSubject : 商品名
 *paymentBody : 商品描述
 *rank : vip等级,类型是成为vip的时候要传的参数
 *couponId : 会员抵用券ID, 类型是成为vip时要穿的参数
 *ubiCount: 使用优币的数量
 */
/*
 返回：ret: 0: 余额支付表示成功， 其他获取charge进行支付 -1:成功，不需要支付， 其他失败
 charge: ping++需要的charge对象
 */
#define payPay @"/pay/pay"

//请求资讯广告位数据
#define getHotNews @"/News/getHotNews"
//请求资讯列表数据
/*
 ** page : 1, 页码,从1开始,用于用户下拉获取更多 当返回list位空时表示没有更多了
 */
#define getNews @"/News/getNews"

//获取活动页广告列表
#define getActAdList @"/Act/getActAdList"
//获取活动页在线活动列表
#define getOnlineAct @"/Act/getOnlineAct"
//获取往期活动列表
#define getOfflineAct @"/Act/getOfflineAct"
//获取预告片广告
#define getHotPrevue @"/Prevue/getHotPrevue"
//获取预告片列表
#define getPrevueList @"/Prevue/getPrevueList"

//获取对账单列表
/*参数
 ** _memberId        用户ID
 ** _accessToken     用户accessToken
 */
#define getBillList @"/Bill/getBillList"

//获取对账单详情
/*参数
 ** _memberId        用户ID
 ** _accessToken     用户accessToken
 ** billId           订单id
 */
#define getBillInfo @"/Bill/getBillInfo"

//获取用户资讯收藏列表
#define getNewsList @"/FavNews/getUserFav"

//添加资讯收藏
/*参数：
 ** newsId : newsID
 */
#define addNewsFav @"/FavNews/addUserFav"

//删除资讯收藏
#define deleteNewsFav @"/FavNews/deleteUserFav"

//获取用户预告片收藏列表
#define getFavPrevueList @"/FavPrevue/getUserFav"

//添加预告片收藏
#define addPrevueFav @"/FavPrevue/addUserFav"

//删除预告片收藏
/*参数
 ** favId : 收藏ID
 */
#define deletePrevueFav @"/FavPrevue/deleteUserFav"

/**
 获取订单详情
 */
#define getRentailInfo @"/Rental/getRentalInfo"

/**
 添加影片评论
 */
#define addComment @"/Comment/addComment"

/**
 *计算升级vip价格
 *rank: vip等级, 类型是成为vip的时候要传的参数
 *couponId : 会员抵用券ID
 *ubi: 是否使用ub   1使用, 0不使用
 */
/*
 *返回
 *ret : 0 成功; 其他失败
 *price: vip 价格
 *money : 当前可用余额
 *points : 当前优币
 */
#define calVipPrice @"/pay/calVipPrice"

/**
 获取全部可提现先金额
 */
#define getMaxWithdrawMoney @"/Pay/getMaxWithdrawMoney"

/**
 提现
 */
#define tixian_URL @"/pay/withdraw"

/**
 *获取优币收支明细
 */
#define getPointList @"/Wallet/getPointList"

/**
 *获取购物车数量
 */
#define getUserCartCount @"/Cart/getUserCartCount"

/**
 *获取优惠券列表
 */
#define getUserCoupon @"/Member/getUserCoupon"

/**
 *获取验证码图片
 */
#define getPCode @"/VCode/getPCode"

/**
 *使用会员码升级会员
 */
/*参数
 *card :会员码
 *pCode : 验证码
 */
#define useCard @"/Member/useCard"

/**
 *获取会员抵用券列表
 */
#define getCardCouponList @"/Member/getCardCouponList"

/**
 *获取用户当前金钱
 */
#define getUserWallet @"/Wallet/getUserWallet"

#endif /* API_h */
