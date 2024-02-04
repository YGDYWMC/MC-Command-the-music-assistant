require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "layout"
import "AndLua"
import "xfc"
import "xfq"
import "gy"
import "main1"
import "android.content.Context"
import "android.provider.Settings"
import "android.animation.ObjectAnimator"
import "android.animation.ArgbEvaluator"
import "android.animation.ValueAnimator"
import "android.graphics.Color"
import "android.content.Intent"
import "android.net.Uri"
import "android.graphics.PixelFormat"
import "android.view.animation.AnimationSet"
import "android.view.animation.LayoutAnimationController"
import "android.view.animation.AlphaAnimation"
import "android.view.animation.TranslateAnimation"
import "android.content.*"

activity.setTheme(R.Theme_Blue)
activity.setTitle("命令音乐助手")
activity.setContentView(loadlayout(layout))

隐藏标题栏()
沉浸状态栏()
窗口全屏()
--获取悬浮窗权限
if Build.VERSION.SDK_INT >= Build.VERSION_CODES.M&&!Settings.canDrawOverlays(this) then
  print("没有悬浮窗权限悬，请打开权限")
  intent=Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION)
  intent.setData(Uri.parse("package:" .. activity.getPackageName()));
  activity.startActivityForResult(intent, 100)
  os.exit()
 else
end



function 判断悬浮窗权限()
  if Settings.canDrawOverlays(this)==false then
    AlertDialog.Builder(this)
    .setTitle("没有悬浮窗权限！")
    .setMessage("检测到没有给予悬浮窗权限，请先给予悬浮窗权限。")
    .setPositiveButton("点击授权悬浮窗权限",{onClick=function(v)
        import "android.net.Uri"
        import "android.content.Intent"
        import "android.provider.Settings"
        intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION);
        intent.setData(Uri.parse("package:" .. activity.getPackageName()));
        activity.startActivityForResult(intent, 100);
      end})
    .show()
  end
end
判断悬浮窗权限()





窗口 = activity.getSystemService(Context.WINDOW_SERVICE)
窗口容器 = WindowManager.LayoutParams()
if Build.VERSION.SDK_INT >= 26 then
  窗口容器.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
 else
  窗口容器.type = WindowManager.LayoutParams.TYPE_SYSTEM_ALERT
end
窗口容器.flags = WindowManager.LayoutParams().FLAG_NOT_FOCUSABLE
窗口容器.gravity = Gravity.LEFT | Gravity.TOP
窗口容器.format = 1
窗口容器.y = activity.getWidth()/2
窗口容器.width = WindowManager.LayoutParams.WRAP_CONTENT
窗口容器.height = WindowManager.LayoutParams.WRAP_CONTENT
悬浮窗=loadlayout(xfc)
悬浮球=loadlayout(xfq)

local 坐标={x=2,y=2}
local 动画对象 = AnimationSet(true)
local 动画容器 = LayoutAnimationController(动画对象,0.2)
local 渐变动画 = AlphaAnimation(0,1)
local 下滑动画 = TranslateAnimation(0, 0, 55, 0)
动画容器.setOrder(LayoutAnimationController.ORDER_NORMAL)
渐变动画.setDuration(500)
下滑动画.setDuration(600)
动画对象.addAnimation(渐变动画)
动画对象.addAnimation(下滑动画)
function 载入悬浮球()
  if(fb==false)then
    --[[坐标.x = 0
    坐标.y = activity.getWidth()/2
    窗口容器.x = 坐标.x
    窗口容器.y = 坐标.y]]
    悬浮球.setLayoutAnimation(动画容器)
    窗口.addView(悬浮球,窗口容器)
    fb = true
  end
end
function 关闭悬浮球()
  开启悬浮窗.setText("关闭悬浮")
  if(fb==true)then
    窗口.removeView(悬浮球)
    fb = false
  end
end
function 载入悬浮窗()
  local 坐标={x=2,y=2}
  local 动画对象 = AnimationSet(true)
  local 动画容器 = LayoutAnimationController(动画对象,0.2)
  local 渐变动画 = AlphaAnimation(0,1)
  local 滑入动画 = TranslateAnimation(-100,0,0,0)
  动画容器.setOrder(LayoutAnimationController.ORDER_NORMAL)
  渐变动画.setDuration(500)
  滑入动画.setDuration(600)
  动画对象.addAnimation(渐变动画)
  动画对象.addAnimation(滑入动画)
  if(fw==false)then
    悬浮窗.setLayoutAnimation(动画容器)
    窗口.addView(悬浮窗,窗口容器)
    关闭悬浮球()
    fw = true
  end
end
local firstX,firstY,wmX,wmY
图标.OnTouchListener = function(v,event)
  if(fw == false)then
    if(event.getAction() == MotionEvent.ACTION_DOWN)then
      firstX = event.getRawX()
      firstY = event.getRawY()
      wmX = 窗口容器.x
      wmY = 窗口容器.y
     elseif(event.getAction() == MotionEvent.ACTION_MOVE)then
      坐标.x = wmX + (event.getRawX() - firstX)
      坐标.y = wmY + (event.getRawY() - firstY)
      窗口容器.x = 坐标.x
      窗口容器.y = 坐标.y
      窗口.updateViewLayout(悬浮球,窗口容器)
     elseif(event.getAction() == MotionEvent.ACTION_UP)then
      窗口.updateViewLayout(悬浮球,窗口容器)
    end
  end
  return false
end
移动.OnTouchListener= function(v,event)
  if event.getAction() == MotionEvent.ACTION_DOWN then
    firstX = event.getRawX()
    firstY = event.getRawY()
    wmX = 窗口容器.x
    wmY = 窗口容器.y
   elseif event.getAction() == MotionEvent.ACTION_MOVE then
    窗口容器.x = wmX + (event.getRawX() - firstX)
    窗口容器.y = wmY + (event.getRawY() - firstY)
    窗口.updateViewLayout(悬浮窗,窗口容器)
   elseif(event.getAction() == MotionEvent.ACTION_UP)then
    窗口.updateViewLayout(悬浮窗,窗口容器)
  end
  return false
end
-----------------------------------------------------------------------------------------------------







-------------------------------------------------点击事件
function 隐藏.onClick()
  if(fw==true)then
    窗口.removeView(悬浮窗)
    载入悬浮球()
    fw = false
  end
end
隐藏.onLongClick=function()
  if(fb==true)then
    窗口.removeView(悬浮球)
    fb = false
  end
  if(fw==true)then
    开启悬浮窗.setText("开启悬浮")
    窗口.removeView(悬浮窗)
    fw = false
  end
end
fw=false
function 图标.onClick
  if(fw==false)then
    载入悬浮窗()
  end
end

fb=false
function 开启悬浮窗.onClick()
  if fb==false then
    载入悬浮球()
    开启悬浮窗.setText("关闭悬浮")
    --MD提示("已开启悬浮",0xFFFFFFFF,0x9C000000,4,10)
    fb=true
   else
    关闭悬浮球()
    开启悬浮窗.setText("开启悬浮")
    --MD提示("已关闭悬浮",0xFFFFFFFF,0x9C000000,4,10)
    fb=false
  end
end

-- 音色部分剪切板

function 音色钢琴.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("/execute at @p run playsound note.harp @p ~ ~ ~ 1 ")
end

function 钟.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("/execute at @p run playsound note.pling @p ~ ~ ~ 1 ")
end

function 电钢琴.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("/execute at @p run playsound note.pling @p ~ ~ ~ 1 ")
end

function 吉他.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("/execute at @p run playsound note.guitar @p ~ ~ ~ 1 ")
end

function 底鼓.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("/execute at @p run playsound note.guitar @p ~ ~ ~ 1 ")
end


-- 音调部剪切板



function 一升升.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("2.8284")
end

function 二升升.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("3.1748")
end

function 三升升.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("3.5635")
end

function 四升升.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("3.7754")
end

function 五升升.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("4.2378")
end

function 六升升.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("4.7568")
end

function 七升升.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("5.3393")
end



function 一升.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("1.4142")
end

function 二升.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("1.5874")
end

function 三升.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("1.7817")
end

function 四升.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("1.8877")
end

function 五升.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("2.1189")
end

function 六升.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("2.3784")
end

function 七升.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("2.6696")
end




function 一音.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("0.7071")
end

function 二音.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("0.7937")
end

function 三音.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("0.8908")
end

function 四音.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("0.9438")
end

function 五音.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("1.0594")
end

function 六音.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("1.1892")
end

function 七音.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("1.3348")
end



function 一减.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("0.35355")
end

function 二减.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("0.39685")
end

function 三减.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("0.44544")
end

function 四减.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("0.47193")
end

function 五减.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("0.5297")
end

function 六减.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("0.5946")
end

function 七减.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("0.6674")
end




function 一减减.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("0.176776")
end

function 二减减.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("0.198425")
end

function 三减减.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("0.222724")
end

function 四减减.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("0.235928")
end

function 五减减.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("0.29486")
end

function 六减减.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("0.2973")
end

function 七减减.onClick()
  -- 获取剪贴板服务
  clipboard = activity.getSystemService(Context.CLIPBOARD_SERVICE)

  -- 设置剪贴板文本
  clipboard.setText("0.3337")
end

function 欣悦阁.onClick()
  跳转QQ群(585584730)
end
function 联机.onClick()
  跳转QQ群(878027770)
end
function 分享交流.onClick()
  跳转QQ群(686665713)
end
function 关于.onClick()
  跳转界面("main1")
end
