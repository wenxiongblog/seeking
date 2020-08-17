//
//  MacroDefine.h
//  Project
//
//  Created by XuWen on 2020/1/7.
//  Copyright © 2020 xuwen. All rights reserved.
//

#ifndef MacroDefine_h
#define MacroDefine_h

/**
*  屏幕尺寸相关
*/
#define kIS_iPAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)
#define kIS_iPhoneX             ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIS_iPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)
#define kIS_iPhoneXS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)
#define kIS_iPhoneXS_MAX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)
#define kIS_IPhoneX_All ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)

#define kStatusBarHeight       (kIS_IPhoneX_All ? 44.f : 20.f)
#define kNavigationBarHeight   44.f
#define kTabbarHeight          (kIS_IPhoneX_All ? (49.f+34.f) : 49.f)
#define kSafeAreaBottomHeight  (kIS_IPhoneX_All ? 34.f : 0.f)
#define kStatusBarAndNavigationBarHeight  (kIS_IPhoneX_All ? 88.f : 64.f)
#define KBaseNavi_Height        56

#define kSCREEN_BOUNDS  ([UIScreen mainScreen].bounds)
#define kSCREEN_WIDTH   ([UIScreen mainScreen].bounds.size.width)
#define kSCREEN_HEIGHT  ([UIScreen mainScreen].bounds.size.height)
#define kSCREEN_SCALE   [[UIScreen mainScreen] scale] //屏幕的分辨率

//适配（以iPhone7屏幕为基准）
#define XW(v)              kSCREEN_WIDTH*v/375.f
#define YH(v)              kSCREEN_HEIGHT*v/667.f

// View 坐标(x,y)和宽高(width,height)
#define X(v)               (v).frame.origin.x
#define Y(v)               (v).frame.origin.y
#define W(v)               (v).frame.size.width
#define H(v)               (v).frame.size.height

//通知
#define NOTICENTER       ([NSNotificationCenter defaultCenter])

/**
 *  颜色
 */

//RGB颜色转换
#define RGB16(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

//------------------- 字体 ---------------------
#define Font(A)                 [UIFont systemFontOfSize:(A)]
#define FontBold(A)             [UIFont boldSystemFontOfSize:(A)]
#define FontMediun(A)           [UIFont fontWithName:@"PingFang-SC-Medium" size:(A)]
#define FontName(name,size)     [UIFont fontWithName:(name) size:(size)]

/**
 *  常用对象
 */
#define theStandardUserDefaults ([NSUserDefaults standardUserDefaults])

#define theUserDefaults  ([[NSUserDefaults alloc] initWithSuiteName:[theStandardUserDefaults objectForKey:@"userId"]])

#define theAppDelegate   ((AppDelegate *)[UIApplication sharedApplication].delegate)

/**
*  图片
*/
#define XWImageName(name)          [UIImage imageNamed:(name)]

//弱引用
#define weak(v) try{}@finally{} __weak __typeof(v) weak##v = v;
#define WeakObj(o) try{}@finally{} __weak typeof(o) o##Weak = o;
#define StrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;
#define kXWWeakSelf(weakName)   __weak typeof(self) weakName = self
#define kXWWeak(name,weakName)  __weak typeof(name) weakName = name

//语言本地化
#define kLanguage(language) NSLocalizedString(language, nil)



#endif /* MacroDefine_h */
