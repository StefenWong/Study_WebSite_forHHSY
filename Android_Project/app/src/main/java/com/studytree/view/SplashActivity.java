package com.studytree.view;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.view.WindowManager;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.animation.AnimationSet;
import android.view.animation.LinearInterpolator;
import android.view.animation.ScaleAnimation;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.airbnb.lottie.L;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.studytree.R;
import com.studytree.bean.InitBean;
import com.studytree.http.HttpResultCallback;
import com.studytree.http.logic.InitLogic;
import com.studytree.log.Logger;
import com.studytree.utils.DevicesUtils;
import com.studytree.utils.permissions.PermissionConfig;
import com.studytree.view.base.BaseActivity;
import com.studytree.view.widget.LoadingDialog;
import com.studytree.view.widget.LoadingView;
import android.animation.ValueAnimator;

import java.util.List;

/**
 * 闪屏页
 * Title: SplashActivity
 * @date 2018/6/25 16:59
 * @author Freedom0013
 */
public class SplashActivity extends BaseActivity {
    public static final String TAG = SplashActivity.class.getSimpleName();
    /** 广告ImageView */
    private ImageView splash_advert_image;
    /** 标题logo根节点 */
    private LinearLayout splash_logo_root;
    /** 更新信息 */
    private InitBean initbean;

    private static final int CODE_MUST_UPDATE_DIALOG = 1;
    private static final int CODE_UPDATE_DIALOG = 2;
    private static final int CODE_ENTER_HOME = 3;
    private static final int CODE_ANIMATION_END = 8;

    private Handler handler = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what){
                case CODE_UPDATE_DIALOG:            //有app更新
                    showUpdataDialog(initbean);
                    break;
                case CODE_ENTER_HOME:               //进入下一步

                    break;
                case CODE_ANIMATION_END:            //

                    break;
                default:

                    break;
            }
        }
    };


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash);
        //去除ActionBar和界面占满屏幕
        getSupportActionBar().hide();
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);

        initView();
        checkingUpdata();
    }

    /** 初始化界面 */
    private void initView() {
        Message message = Message.obtain();
        splash_advert_image = findViewById(R.id.splash_advert_image);
        splash_logo_root = findViewById(R.id.splash_logo_root);

        LoadingDialog dialog = LoadingDialog.showDialog(SplashActivity.this);
        dialog.show();

        //动画集合
        AnimationSet animationSet = new AnimationSet(false);
        //渐变动画
        AlphaAnimation alphaAnimation = new AlphaAnimation(0.2f,1.0f);
        alphaAnimation.setDuration(1000);
        //缩放动画
        ScaleAnimation scaleAnimation = new ScaleAnimation(0.7f,1.0f,0.7f,1.0f, Animation.RELATIVE_TO_SELF,0.5f,Animation.RELATIVE_TO_SELF,0.5f);
        scaleAnimation.setDuration(400);
        animationSet.addAnimation(alphaAnimation);
        animationSet.addAnimation(scaleAnimation);
        //设置动画监听
        animationSet.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {
            }
            @Override
            public void onAnimationRepeat(Animation animation) {
            }
            @Override
            public void onAnimationEnd(Animation animation) {
                analysisAutoLogin();
            }
        });
        splash_advert_image.startAnimation(animationSet);
    }

    /**
     * 检查更新
     */
    private void checkingUpdata() {
        //网络请求
        InitLogic initLogic = InitLogic.getInstance();
        initLogic.getUpdataInfo(new HttpResultCallback() {
            @Override
            public void onSuccess(int action, Object obj) {
                Gson gson = new Gson();
                JsonObject data = new JsonParser().parse(obj.toString()+"").getAsJsonObject();
                JsonObject info = data.get("data").getAsJsonObject();
                initbean = new InitBean(info);
                Logger.d(TAG, initbean.toString());
                //更新逻辑
                Message message = Message.obtain();
                if(initbean.updata_visionCode > DevicesUtils.getVersionCode()){     //有版本更新
                    message.what = CODE_UPDATE_DIALOG;
                } else {    //没有版本更新
                    message.what = CODE_ENTER_HOME;
                }
                handler.sendMessage(message);
            }

            @Override
            public void onFail(int action, int responseCode, String responseMsg) {
                Logger.d(TAG,"接口请求失败！responseMsg = "+responseMsg);
                showToast("网络异常！接口请求失败！");
            }
        });
    }

    /**
     * 检查登录状态
     */
    private void analysisAutoLogin() {
        preAutoLogin();
    }

    /**
     * 检查权限
     */
    private void preAutoLogin() {
        //权限组检查
        String[] permissions = {
                PermissionConfig.PERMISSION_READ_PHONE_STATE,
                PermissionConfig.PERMISSION_WRITE_EXTERNAL_STORAGE };
        List<String> permissionslist = super.permissionsutils.hasPermissionsAllGranted(permissions, SplashActivity.this);
        if (permissionslist.size() != 0) {
            //调用BaseActivity检查权限工具类
            super.permissionsutils.Requestpermission(permissions, PermissionConfig.REQUEST_SOME_PERMISSIONS, "需要请求一些必要权限！", SplashActivity.this);
        }
    }

    /**
     * 用户权限授权回调
     * @param requestCode 请求码
     * @param permissions 权限列表
     * @param grantResults 授权结果码
     */
    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        super.permissionsutils.handleSingleRequestPermissionsResult(requestCode,permissions,grantResults);
    }

    /**
     * 弹出正常更新Dialog
     * @param initbean 更新信息
     */
    public void showUpdataDialog(InitBean initbean) {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("发现新版本：" + initbean.updata_title);
        if (initbean.UpdataMessage != null && initbean.UpdataMessage.size() >= 0) {
            StringBuffer msgstr = new StringBuffer();
            msgstr.append("更新内容如下：");
            for (int i = 0; i < initbean.UpdataMessage.size(); i++) {
                msgstr.append((i+1) + ".");
                msgstr.append(initbean.UpdataMessage.get(i));
                msgstr.append("\n");
            }
            builder.setMessage(msgstr.toString());
            msgstr.delete(0, msgstr.length());
        } else {
            builder.setMessage("欢迎更新至最新版本！");
        }
        builder.setPositiveButton("立即更新！", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                showToast("立即更新！");
            }
        });
        if (!initbean.ismust_updata_flag) {
            builder.setNegativeButton("以后再说", null);
            //Dialog取消监听
            builder.setOnCancelListener(new DialogInterface.OnCancelListener() {
                @Override
                public void onCancel(DialogInterface dialog) {
                    //进入Main
                }
            });
        } else {
            builder.setCancelable(false);   //禁用返回键，尽量不用
        }
        builder.show();
    }
}