//window.$ = require('../js/jquery')
window.wemeetCommon = {
    wemeetSdkId: "",
    wemeetAppId: "",
    wemeetSignUrl: "",
    userHeaderImageUrl: "",
    wemeet_alert_left_buttChange: true,
    wemeet_code: "",
    wemeet_open_url: "",
    chartObj: null,
    userObj: null,
    init: function (type,chartObj,userObj) {
        if(type == "editor"){
            wemeetCommon.chartObj = chartObj;
            wemeetCommon.userObj = userObj;
            wemeetCommon.eidtorWemeetHandle();
            
        }else if(type == "personal"){
            if(navigator.userAgent.indexOf("app/tencent_wemeet") > -1) {
                wemeetCommon.personalWemeetHandle();
            }  
        }else if(type == "homeWeb"){
            if(navigator.userAgent.indexOf("app/tencent_wemeet") > -1) {
                wemeetCommon.homeWebWebmeetHandle();
            }  
        }
        
    },
    //编辑器引用腾讯会议
    eidtorWemeetHandle: function(){
        wemeetCommon.addUI();
        wemeetCommon.getUserHeaderImage();
        wemeetCommon.editorAddWemeet();
        wemeetCommon.addWemeetAuthListen();
        wemeetCommon.getWemeetParamsUrl();
        if(navigator.userAgent.indexOf("app/tencent_wemeet") > -1) {
            wemeetCommon.wemeetOpenCurrentWindow();
            wemeetCommon.wemeetFileShare();
            setTimeout(() => {
                wemeetCommon.windowIgnoreFullScreen();
            }, 500);
            wemeetCommon.getInsertPay();//重写支付弹窗
        }
    },
    //个人文件页相关引用通讯会议
    personalWemeetHandle: function(){
        wemeetCommon.wemeetOpenCurrentWindow(); 
    },
    //主页模板预览引用腾讯会议
    homeWebWebmeetHandle:function(){
        wemeetCommon.wemeetOpenCurrentWindow(); 
    },
   //编辑器里调用腾讯会议
   editorAddWemeet: function () {
            //思维导图编辑器添加腾讯会议发起按钮
            if($("#open_wemeet").length){
                $("#open_wemeet").remove();
            }
            if($("#open_wemeet_alert").length){
                $("#open_wemeet_alert").remove();
            }
            if (location.href.indexOf("mind") > -1) {
                let divStr = `<div id='open_wemeet' style='display:none;' class='po-tool-button' original-title='腾讯会议'>
                                <i class='ol-icons po-diagraming-icons'>&#xe817;</i>
                            </div>
                            <div id='open_wemeet_alert' style='display:none;' class='po-tool-button' original-title='腾讯会议'>
                                <img src='/assets/images/wemeet/wemeetLoading.gif' style='height:22px'/>
                            </div>
                            `
                $(".mind-header-right .po-tool-button[tit=present]").after(divStr);
            }else if (location.href.indexOf("outline") > -1) {
                let divStr = `<a id='open_wemeet' style='display:none;' class='nav-i' original-title='腾讯会议'>
                                <i class='ol-icons po-diagraming-icons'>&#xe817;</i>
                            </a>
                            <a id='open_wemeet_alert'style='display:none;' class='nav-i' original-title='腾讯会议'>
                                <i>
                                <img src='/assets/images/wemeet/wemeetLoading.gif' style='height:22px;'/>
                                </i>
                            </a>
                            `
                            console.log($(".head-right-nav #btn_colla_share").length)
                $(".head-right-nav #btn_colla_share").after(divStr);
            }
            else {
                let divStr = `<div id='open_wemeet' style='display:none;margin-right:8px' class='po-tool-button' original-title='腾讯会议'>
                                <i class='ol-icons po-diagraming-icons'>&#xe817;</i>
                            </div>
                            <div id='open_wemeet_alert' style='display:none;margin-right:8px' class='po-tool-button' original-title='腾讯会议'>
                                <img src='/assets/images/wemeet/wemeetLoading.gif' style='height:22px'/>
                            </div>
                            `
                $(".po-flow-header-right #header-export").after(divStr);
            }
            wemeetCommon.addDomEvent();
    },
     //屏蔽支付弹窗
     wemeetScreenPay: function (type,callback) {
        if ((wemeetCommon.isMac() || wemeetCommon.isIos() == 'ios') && navigator.userAgent.indexOf("app/tencent_wemeet") > -1) {
            wemeetCommon.addConfirmAlert();
            $(".wemeet_poupe_pay_right_butt,.wemeet_poupe_pay_delect").on("click", function () {
                $(".wemeet_poupe_pay").hide();
            })
            $(".wemeet_address_copy").on("click",function () {
                if(type == "personal"){
                    let copyStr = $(".wemeet_address_blue").text();
                    VueRoot.$copyToClip(copyStr, '复制成功'); 
                }else if(type == "homeWeb" || type == "editor"){
                    $("body").append('<input type="text" value="'+ $(".wemeet_address_blue").text()+'" class="cururl" style="position: fixed;left:-20000px;z-index:-999">');
                    if(!$('.cururl').val()){return;}
                    $('.cururl').select();
                    try{
                        if(document.execCommand('copy', false, null)){
                          $.toast({
                            type: 'success',
                            text:'链接复制成功',
                            target: $(".wemeet_poupe_pay")
                        })
                        setTimeout(function(){
                           $(".cururl").remove()
                        },1000)
                    }else{}
                   }catch(e){}
                }
            })
            // 按钮点击埋点
            try {
                callback();
            }
            catch (e) {
            }
            return 'macios'
        }
        //return ""
    },
    //文件分享
    wemeetFileShare: function (fileTitle, fileShareLink, callback) {
        //隐藏文件编辑器分享协作按钮，添加腾讯会议按钮
        let shareContenButt = `
            <div class='wemeet_file_share_content'>
                <div id='wemeet_file_share_link' class='wemeet_file_share_item'>
                    <img class='wemeet_file_share_image' src="/assets/images/wemeet/wemeet_open_share.svg"/>
                    <span class='wemeet_file_share_text'>协作参会人</span>
                </div>
                <div id='wemeet_file_share_manage' class='wemeet_file_share_item'>
                     <img class='wemeet_file_share_image' src="/assets/images/wemeet/wemeet_share_shezhi.svg"/>
                     <span class='wemeet_file_share_text'>协作权限管理</span>
                </div>
            </div>`
        if (wemeetCommon.chartObj && wemeetCommon.chartObj.category.indexOf("mind") > -1) {
            $(".po-clb-btn").css("display", "none");
            //$(".mind-header-right .po-mind-nav").before("<div id='wemeet_btn_share' class='po-tool-button' original-title='文件分享'><img src='/assets/images/wemeet/wemeet_open_share.svg' style='width:22px;height:22px'/></div>");
            $(".mind-header-right .po-mind-nav").before("<div id='wemeet_file_share_butt' class='po-button po-clb-btn primary' tit='colla' style='position: relative;'>分享协作 "+shareContenButt+" </div>");
            //$(".mind-header-right .po-mind-nav").before("<div id='wemeet_btn_share' class='po-tool-button' original-title='文件分享'><img src='/assets/images/wemeet/wemeet_share_white.svg' style='width:22px;height:22px'/></div>");
        } 
        else if (wemeetCommon.chartObj && wemeetCommon.chartObj.category.indexOf("outline") > -1) {
            $("#btn_colla_share").css("display", "none");
            $(".head-right-nav #top-search-colla-btn").before("<a id='wemeet_file_share_butt' class='nav-i' class='icon-button header-item' style='position: relative;'>"+shareContenButt+"<i class='ol-icons'>&#xe60b;</i></a>");
           
            //$(".head-right-nav #top-search-colla-btn").before("<a id='wemeet_btn_share' class='nav-i' original-title='文件分享'><span class='ol-icons'><img  src='/assets/images/wemeet/wemeet_open_share.svg' style='width:20px;height:20px;margin-top: 8px;'/></span></a>");
            //$(".head-right-nav #top-search-colla-btn").before("<a id='wemeet_btn_share' class='nav-i' original-title='文件分享'><span class='ol-icons'><img  src='/assets/images/wemeet/wemeet_share_white.svg' style='width:22px;height:22px;margin-top: 5px;'/></span></a>");

        }
        else{//flow和其他类型
            $("#po-clb-button").css("display", "none");
            $(".po-flow-header-right #header-export").before("<div id='wemeet_file_share_butt' class='po-button po-clb-buttom primary' style='position: relative;'>分享协作 "+shareContenButt+" </div>");
            //$(".po-flow-header-right #header-export").before("<div id='wemeet_btn_share' class='po-tool-button' original-title='文件分享' style='margin-right: 8px;'><img src='/assets/images/wemeet/wemeet_open_share.svg' style='width:22px;height:22px'/></div>");
            //$(".po-flow-header-right #header-export").before("<div id='wemeet_file_share_butt' class='po-button po-clb-buttom primary' style='position: relative;'>分享文件 "+shareContenButt+" </div>");
        }
        $("#wemeet_btn_share").on('click',function(){
            if(typeof wemeet == "undefined"){
                var data = {
                    js:["https://cdn.meeting.tencent.com/jssdk/wemeet-js-sdk-1.0.19.js"]
                };
                bigPipe.render(data,function(){
                    wemeetCommon.creatShareLink(function(result){
                        wemeetCommon.getWemeetAppShare(result); 
                    })
                });
            }else{
                wemeetCommon.creatShareLink(function(result){
                    wemeetCommon.getWemeetAppShare(result); 
                })
            }  
        })
        $("#wemeet_file_share_butt").on('click',function(){
            $(".wemeet_file_share_content").show();
        })
        $("#wemeet_file_share_link").on('click',function(){
            setTimeout(() => {
                $(".wemeet_file_share_content").hide();
            }, 1000);
            if(typeof wemeet == "undefined"){
                var data = {
                    js:["https://cdn.meeting.tencent.com/jssdk/wemeet-js-sdk-1.0.19.js"]
                };
                bigPipe.render(data,function(){
                    wemeetCommon.creatShareLink(function(result){
                        wemeetCommon.getWemeetAppShare(result); 
                    })
                });
            }else{
                wemeetCommon.creatShareLink(function(result){
                    wemeetCommon.getWemeetAppShare(result); 
                })
            }  
        })
        $("#wemeet_file_share_manage").on('click',function(){
            setTimeout(() => {
                $(".wemeet_file_share_content").hide();
            }, 1000);
            insert.share.init();

        })
    },
    //创建分享链接
    creatShareLink:function(calllback){
        Util.ajax({
            url: '/api/personal/collaboration/v3/create/link',
            type: "post",
            data: {type: "chart",id: wemeetCommon.chartObj.chartId,auth:"all_view",expire:"",signup_ticket:"",randst:""},
            success: function (data) {
                calllback(data.shareCollaId); 
            }
        });
    },
    //调用腾讯会议分享api
    getWemeetAppShare: function (filesLinkId) {
        let fileShareLink = window.location.origin + "/v/"+ filesLinkId;
        wemeet.app.setShareOpenAppConfig({
            shareEnable: false, // webview顶部栏分享按键是否可见
            title: "文件分享", //IM消息卡片标题
            desc: wemeetCommon.chartObj.title,    // IM消息卡片描述
            notifyDesc: "有分享文件到达", //会中消息通知文案
            confirmBtnText: "确定", //会中消息通知确认按钮文案
            pcUrl: fileShareLink,  //桌面端分享url
            mobileUrl: fileShareLink,//移动端分享url
        }).then(function (res) {
        }).catch(function (e) {
            console.error(e);
        });
        wemeet.app.shareOpenApp().then(function (res) {
        }).catch(function (e) {
            console.error(e);
        });
    },
    //window 屏蔽全屏功能
    windowIgnoreFullScreen:function(){
        if(wemeetCommon.isWindow()){
            if($(".po-tool-button[tit=full]").length){
                $(".po-tool-button[tit=full]").css("display","none");
            }
            if($("#enter-fullscreen").length){
                $("#enter-fullscreen").css("display","none");
            }
        }      
    },
    //编辑页退出时恢复腾讯会议自己的分享
    getWemeetOldShareFunction: function(){
        window.addEventListener('pagehide',function (event){
			wemeet.app.setShareOpenAppConfig({//显示腾讯会议顶部分享按钮
				shareEnable: true, // webview顶部栏分享按键是否可见
			}).then( function(res)  {
			})
		})
		window.onbeforeunload = function(){
			wemeet.app.setShareOpenAppConfig({//显示腾讯会议顶部分享按钮
				shareEnable: true, // webview顶部栏分享按键是否可见
			}).then( function(res)  {
				console.log('wemeetShareShow3', res);
			})
		}
    },
    //添加元素事件
    addDomEvent: function () {
        if(navigator.userAgent.indexOf("app/tencent_wemeet") > -1) {
            // 腾讯会议
            $('#open_wemeet').hide();//关闭会议按钮
            $('#open_wemeet_alert').hide();
        }else{
            //只有拥有者可以创建会议
            if(wemeetCommon.chartObj.owner.userId == wemeetCommon.userObj.userId){
                $('#open_wemeet').show();
            }else {
                $('#open_wemeet').hide();
            }
        }
        //腾讯会议按钮
        $('#open_wemeet').off("click").on("click", function () {
            wemeetCommon.zhuGeWemeetOpen();
            $('.wemeet_poupe').show();
        })
        $('#open_wemeet_alert').off("click").on("click", function () {
            $('.wemeet_left_alert').show();
        })
        $('.w_p_b_cancel').click(function () {
            $('.wemeet_poupe').hide();
        })
        $('.wemeet_delect_image').click(function () {
            $('.wemeet_poupe').hide();
        })
        //确定按钮点击打开腾讯会议
        $('.w_p_b_confirm').click(function () {
            wemeetCommon.zhuGePoupeConfirm();
            //wemeetCommon.ownerAlertView();
            wemeetCommon.getWemeetAuth();
        })
        $('.wemeet_alert_delect_image').click(function () {
            $('.wemeet_left_alert').hide();
        })
        $('.wemeet_alert_left_butt_l').click(function () {
            $('.wemeet_left_alert').hide();
        })
        $('.wemeet_alert_left_butt_r').click(function () {
            wemeetCommon.zhuGeAlertJoinWemeet();//诸葛埋点
            wemeetCommon.joinWemeetRoom();//加入会议
        })
        $('.wemeet_alert_copy').click(function () {
            var copyText = $(".wemeet_alert_black_text"); //获取对象
            var input = document.createElement('input');
            document.body.appendChild(input);
            input.setAttribute('value', copyText.text());
            input.select();
            if (document.execCommand('copy')) {
                document.execCommand('copy');
                wemeetCommon.showTip("会议ID复制成功");
            }
            document.body.removeChild(input);
        })
        if (navigator.userAgent.indexOf("app/tencent_wemeet") > -1) {
            $('#open_wemeet').hide();
            $('#open_wemeet_alert').hide();
        } else {
            wemeetCommon.windowRefreshUI();//从其他界面进来本页面，没及时推送的,或者刷新界面
        }

    },
    //刷新后根据保存的会议信息更新UI
    windowRefreshUI: function () {
        wemeetCommon.queryWemeetInfo(function (queryWemeetResult) {
                if (queryWemeetResult) {
                    //如果有会议信息
                    //var wemeetDict = queryWemeetResult.thirdAudio;
                    wemeetCommon.wemeet_open_url = queryWemeetResult.meetingLink;
                    wemeetCommon.wemeet_code = queryWemeetResult.meetingNum;
                    //var userIdSave = wemeetDict.userId;
                    var fullName_get = queryWemeetResult.fullName;
                    wemeetCommon.getUserHeaderImage(wemeetCommon.chartObj.owner.userId);//更新头像信息
                    if (wemeetCommon.userObj.userId == wemeetCommon.chartObj.owner.userId) {
                        //发起者
                        wemeetCommon.ownerAlertView();
                    } else {
                        var susNoticeStr = window.sessionStorage.getItem("SUS_NOTICE");
                        if (susNoticeStr == "YES") {
                            return;
                        }
                        //协作者
                        var dataDict = {
                            "content": {
                                "userHeaderImageUrl": wemeetCommon.userHeaderImageUrl,
                                "fullName": fullName_get,
                                "wemeet_code": wemeetCommon.wemeet_code,
                                "wemeetUrl": wemeetCommon.wemeet_open_url,
                            }
                        }
                        wemeetCommon.collaboratorAlertView(dataDict);
                    }
                } else {
                }
            
        })

    },
    //拥有者消息弹框
    ownerAlertView: function () {
        var creatWemeetContent = JSON.stringify({ "content": { "type": wemeetWebSocket.WEMEET_TYPE.CREAT_NOTICE, "wemeet_code": wemeetCommon.wemeet_code, "userHeaderImageUrl": wemeetCommon.userHeaderImageUrl, "fullName": wemeetCommon.userObj.fullName, "wemeetUrl": wemeetCommon.wemeet_open_url } });
        poWebSocket.send(creatWemeetContent);
        $('.wemeet_poupe').hide();
        $('#open_wemeet').hide();
        $('#open_wemeet_alert').show();
        $('.wemeet_left_alert_userHeader').attr('src', wemeetCommon.userHeaderImageUrl);
        $('.wemeet_alert_b_text_name').text('我');
        $('.wemeet_alert_b_text').text('正在邀请协作者们加入视频会议');
        $('.wemeet_alert_black_text').text(wemeetCommon.wemeet_code);
        $('.wemeet_alert_left_butt_l').text('暂停通知');
        $('.wemeet_alert_left_butt_l').off("click").on("click", function () {
            if (wemeetCommon.wemeet_alert_left_buttChange) {
                wemeetCommon.zhuGeSusWemeetNotice();
                $('.wemeet_alert_left_butt_l').text('通知已暂停,点我恢复');
                var susNoticeContent = JSON.stringify({ "content": { "type": wemeetWebSocket.WEMEET_TYPE.SUS_NOTICE, "wemeet_code": wemeetCommon.wemeet_code, "userHeaderImageUrl": wemeetCommon.userHeaderImageUrl, "fullName": wemeetCommon.userObj.fullName, "wemeetUrl": wemeetCommon.wemeet_open_url } });
                poWebSocket.send(susNoticeContent);
            } else {
                wemeetCommon.zhuGeRecWemeetNotice();
                $('.wemeet_alert_left_butt_l').text('暂停通知');
                var recNoticeContent = JSON.stringify({ "content": { "type": wemeetWebSocket.WEMEET_TYPE.REC_NOTICE, "wemeet_code": wemeetCommon.wemeet_code, "userHeaderImageUrl": wemeetCommon.userHeaderImageUrl, "fullName": wemeetCommon.userObj.fullName, "wemeetUrl": wemeetCommon.wemeet_open_url } })
                poWebSocket.send(recNoticeContent);
            }
            wemeetCommon.wemeet_alert_left_buttChange = !wemeetCommon.wemeet_alert_left_buttChange;
        })
    },
    //协作者消息弹框
    collaboratorAlertView: function (data) {
        if (navigator.userAgent.indexOf("app/tencent_wemeet") > -1) {
            return; //腾讯会议内部不显示弹框
        }
        var susNoticeStr = window.sessionStorage.getItem("SUS_NOTICE");
        if (susNoticeStr == "YES") {
            return;
        }
        var userHeaderImageUrl_get = data.content.userHeaderImageUrl,
            fullName_get = data.content.fullName,
            wemeet_code_get = data.content.wemeet_code,
            wemeetUrl_get = data.content.wemeetUrl;
            wemeetCommon.wemeet_open_url = wemeetUrl_get;
        $('#open_wemeet').hide();
        $('#open_wemeet_alert').show();
        $('.wemeet_left_alert_userHeader').attr('src', userHeaderImageUrl_get);
        $('.wemeet_alert_b_text_name').text(fullName_get);
        $('.wemeet_alert_b_text').text('正在邀请你加入视频会议');
        $('.wemeet_alert_left_butt_l').text('不再提醒');
        $('.wemeet_alert_black_text').text(wemeet_code_get);
        $('.wemeet_left_alert').show();
        $('.wemeet_alert_left_butt_l').off("click").on("click", function () {
            //$('#open_wemeet_alert').hide();
            $('.wemeet_left_alert').hide();
        })
    },
    //协作者消息隐藏
    collaboratorAlertViewHide: function () {
        $('#open_wemeet').hide();
        $('#open_wemeet_alert').hide();
        $('.wemeet_left_alert').hide();
    },
    //提示文字
    showTip: function (tipText) {
        $(".wemeet_toast").css("display", "table");
        $(".wemeet_toast").show();
        $(".wemeet_toast").text(tipText);
        setTimeout(function () {
            $(".wemeet_toast").hide();
        }, 2500)
    },
    //诸葛点击按钮发起腾讯会议埋点
    zhuGeWemeetOpen: function () {
       wemeetCommon.backUserComeAndUserType(function (result) {
            poCollect('发起会议_按钮点击', { '按钮名称': '会议/会议通话', '用户来源': result.userCome, "用户类型": result.userType });
        })
    },
    //诸葛点击弹框确定按钮埋点
    zhuGePoupeConfirm: function () {
       wemeetCommon.backUserComeAndUserType(function (result) {
            poCollect('发起会议_按钮点击', { '按钮名称': '会议/会议通话_确定', '用户来源': result.userCome, "用户类型": result.userType });
        })
    },
    //诸葛点击加入会议按钮
    zhuGeAlertJoinWemeet: function () {
        wemeetCommon.backJoinWemeetUserComeAndUserType(function (result) {
            poCollect('加入会议_按钮点击', { '按钮名称': '加入会议', '用户来源': result.userCome, "用户类型": result.userType });
        })
    },
    //诸葛暂停通知
    zhuGeSusWemeetNotice: function () {
        wemeetCommon.backJoinWemeetUserComeAndUserType(function (result) {
            poCollect('暂停通知_按钮点击', { '按钮名称': '暂停通知', '用户来源': result.userCome, "用户类型": result.userType });
        })
    },
    //诸葛恢复通知
    zhuGeRecWemeetNotice: function () {
        wemeetCommon.backJoinWemeetUserComeAndUserType(function (result) {
            poCollect('恢复通知_按钮点击', { '按钮名称': '恢复通知', '用户来源': result.userCome, "用户类型": result.userType });
        })
    },
    //组合返回用户来源和用户类型
   backUserComeAndUserType: function (callback) {
        var userDict = {
            "userCome": '',
            "uerType": ''
        }
        if (wemeetCommon.chartObj.category.indexOf("mind") >= 0) {
            userDict.userCome = "思维导图";
            //userDict.userType = memberObj.member ? "会员用户" : "免费用户";
        } else if (wemeetCommon.chartObj.category.indexOf("flow") >= 0) {
            userDict.userCome = "流程图";
            //userDict.userType = flowIsMember ? "会员用户" : "免费用户";
        } else if (wemeetCommon.chartObj.category.indexOf("ui") >= 0) {
            userDict.userCome = "原型图";
            //userDict.userType = flowIsMember ? "会员用户" : "免费用户";
        } else if (wemeetCommon.chartObj.category.indexOf("outline") >= 0) {
            userDict.userCome = "思维笔记";
            //userDict.userType = outlineUI.member ? "会员用户" : "免费用户";
        }
        userDict.userType = editorGlobalConfig.isMember ? "会员用户" : "免费用户";
        if (callback) {
            callback(userDict);
        }
    },
    //组合返回加入会议用户来源和用户类型
    backJoinWemeetUserComeAndUserType: function (callback) {
        var userWemeetDict = {
            "userCome": '',
            "userType": ''
        }
        if (wemeetCommon.chartObj.category.indexOf("mind") >= 0) {
            userWemeetDict.userCome = "思维导图";
        } else if (wemeetCommon.chartObj.category.indexOf("flow") >= 0) {
            userWemeetDict.userCome = "流程图";
        } else if (wemeetCommon.chartObj.category.indexOf("ui") >= 0) {
            userWemeetDict.userCome = "原型图";
        } else if (wemeetCommon.chartObj.category.indexOf("outline") >= 0) {
            userWemeetDict.userCome = "思维笔记";
        }
        userWemeetDict.userType = wemeetCommon.chartObj.collaRole == 'owner' ? "创建者" : "协作者";
        if (callback) {
            callback(userWemeetDict);
        }
    },
    //获取用户头像
    getUserHeaderImage(userIdGet) {
        var userNow = '';
        if (userIdGet) {
            userNow = userIdGet;
        } else {
            userNow = wemeetCommon.userObj.userId;
        }

        var userlogo = "https://user-photo.ks3-cn-beijing.ksyuncs.com";
	    var serverName = location.origin.toLowerCase();
	    var endIndex = serverName.indexOf("processon.com");
	    if(endIndex < 0){
		    userlogo = "";
	    }
	
        wemeetCommon.userHeaderImageUrl =  userlogo + '/' + userNow + '.png';
	
        /*var serverName = location.origin.toLowerCase();
        if(serverName.indexOf("processon.com") >= 0 && serverName.indexOf("test") < 0){
            return location.origin + '/barrage/user_photo?d=' + Date.now();
        }
        wemeetCommon.userHeaderImageUrl = location.origin + '/photo/' + userNow + '.png?d=' + Date.now();
        var url = '/photo/' + userNow + '.png';
        wemeetCommon.userHeaderImageUrl = window.location.origin + url;*/
    },
    /**
    * 腾讯会议授权
    */
    getWemeetAuth: function () {
        var corp_id = wemeetCommon.wemeetAppId;
        var sdk_id = wemeetCommon.wemeetSdkId;
        var redirect_uri = wemeetCommon.wemeetSignUrl;
        var state = "comeFromProcessOn";
        var wemeetAuthUrl = "https://meeting.tencent.com/marketplace/authorize.html" + "?corp_id=" + corp_id + "&sdk_id=" + sdk_id + "&redirect_uri=" + redirect_uri + "&state=" + state;
        window.open(wemeetAuthUrl, '_blank', 'width=860,height=785,menubar=no,toolbar=no, status=no,scrollbars=yes')
    },
    /**
      * 监听腾讯会议回调授权
    */
    addWemeetAuthListen: function () {
        window.addEventListener("message", function (e) {
            var origin = e.origin; // 消息来源
            var data = e.data; // 消息数据
            var windowUrl = wemeetCommon.wemeetSignUrl.replace("/wemeet", "");
            if (origin != windowUrl || data.type_wemeet != "wemeet" || !data.type_wemeet) {
                return;
            }
            wemeetCommon.isBindWemeet(data.auth_code);
        });
    },
    /**
      * 是否绑定腾讯会议
    */
    isBindWemeet: function (authCodeData) {
        Util.ajax({
            url: '/api/personal/wemeet/get_wemeet_openId',
            type: "post",
            data: {},
            isErr: true,
            success: function (data) {
                if (data.code === '200') {
                    wemeetCommon.getAccessToken(authCodeData);
                } else if (data.code === "403") {
                    //notbind
                    wemeetCommon.bindWemeet(authCodeData);
                }
            }
        });
    },
    /**
 *账户绑定腾讯会议
 */
    bindWemeet: function (auth_code) {
        Util.ajax({
            url: "/api/personal/wemeet/thirdBinding",
            type: 'post',
            data: { type: "wemeet", auth_code: auth_code },
            success: function (data) {
                wemeetCommon.creatTencentWemeetRoom(data.openId);
                /*if (data.code == "200") {
                    //getAccessToken(auth_code);
                    wemeetCommon.creatTencentWemeetRoom(data.data.openId);
                } else {
                    wemeetCommon.showTip(data.msg);
                }*/
            }
        });
    },
    /**
     * 获取accesstoken
     */
    getAccessToken: function (auth_code) {
        Util.ajax({
            url: '/api/personal/wemeet/get_openid_orlogin',
            type: "post",
            data: { auth_code: auth_code, type: 'wemeet',meetingId:"",openId:"", loginFlag: "nologin" },
            success: function (data) {
                //if (data.code === '200') {
                wemeetCommon.creatTencentWemeetRoom(data.openId);
                //}
                /* else if (data.result == "659") {
                    wemeetCommon.showTip("当前浏览器绑定的腾讯会议账号已绑定其他ProcessOn账号，请更换其他腾讯会议账号再次尝试");
                } else {
                    wemeetCommon.showTip(data.msg);
                }*/
            }
        });
    },
    /**
     * 创建腾讯会议room
     */
    creatTencentWemeetRoom: function (openId) {
        Util.ajax({
            url: '/api/personal/wemeet/creat_meeting',
            type: "post",
            data: { subject: wemeetCommon.chartObj.title,password:"", chartId: wemeetCommon.chartObj.chartId, chartType: wemeetCommon.chartObj.category, openId: openId,start_time:"",end_time:"" },
            success: function (data) {
                //if (data.code == '200') {
                    poCollect('发起会议_操作结果', { '结果': '成功' });
                    wemeetCommon.wemeet_code = data.meeting_info_list[0].meeting_code;
                    wemeetCommon.wemeet_open_url = data.meeting_info_list[0].join_url;
                    wemeetCommon.ownerAlertView();
                    var wemeetUrl = data.meeting_info_list[0].join_url;
                    window.open(wemeetUrl, '_blank', 'width=860,height=785,menubar=no,toolbar=no, status=no,scrollbars=yes');
                    wemeetCommon.saveMeetInfomation(data);
                /*} else {
                    wemeetCommon.showTip(data.msg);
                    poCollect('发起会议_操作结果', { '结果': '失败' });
                }*/
            }
        });
    },
    /**
     * 加入会议
     */
    joinWemeetRoom: function () {
        poCollect('加入会议_操作结果', { '结果': '成功' });
        window.open(wemeetCommon.wemeet_open_url, '_blank', 'width=860,height=785,menubar=no,toolbar=no, status=no,scrollbars=yes');
    },
    /**
     * 保留腾讯会议room
     */
    saveMeetInfomation: function (wemeetInfo) {
        var meeting_link = wemeetInfo.meeting_info_list[0].join_url;
        var meeting_code = wemeetInfo.meeting_info_list[0].meeting_code;
        Util.ajax({
            url: '/api/personal/wemeet/thirdAudio/save',
            type: "post",
            data: { notice: wemeetCommon.chartObj.title, chartId: wemeetCommon.chartObj.chartId, audioType: wemeetCommon.chartObj.category, meetingLink: meeting_link, meetingNum: meeting_code,meetingPassWord:"" },
            success: function (data) {
            }
        });
    },
    /**
     * 搜索腾讯会议room
     */
    queryWemeetInfo: function (callback) {
        Util.ajax({
            url: '/api/personal/wemeet/thirdAudio/query/'+wemeetCommon.chartObj.chartId,
            type: "get",
            //data: { chartId: wemeetCommon.chartObj.chartId },
            success: function (data) {
                if (callback) {
                    if(data){
                     callback(data);
                    }else{
                        callback();
                    } 
                }
            }
        });
    },
    /**
     * 删除腾讯会议room
     */
    delWemeetInfo: function () {
        Util.ajax({
            url: '/api/personal/wemeet/thirdAudio/del/'+ wemeetCommon.chartObj.chartId,
            type: "get",
            //data: { chartId: wemeetCommon.chartObj.chartId },
            success: function () {
            }
        });
    },
     //只有一个窗口进行操作
    wemeetOpenCurrentWindow: function(){
        window.open = function(url) {
            window.location.href = url;
        }
        document.addEventListener('click', e=> {
            const target = e.target;
            if(target && target.nodeName == "A" && target.getAttribute('target') == "_blank"){
                target.setAttribute('target', "_self");
            } 
        });        
    },
    //添加视图
    addUI: function () {
        $('body').append('<div class="wemeet_poupe">' +
            '<div class="w_p_content">' +
            '<div class="wemeet_p_top">' +
            '<div class="wemeet_title">发起视频通话</div>' +
            '<img src="/assets/images/wemeet/wemeet_right_delect.svg" class="wemeet_delect_image">' +
            '</div>' +
            '<div class="wemeet_p_middle">' +
            '<img src="/assets/images/wemeet/wemeet_poupe_logo.svg" class="wemeet_m_logo">' +
            '<div class="wemeet_right_textContent">' +
            '<div class="wemeet_r_black_text">腾讯会议</div>' +
            '<div class="wemeet_r_light_text">发起视频会议，邀请当前文档在线协作者共同进行语音/视频协作</div>' +
            '</div>' +
            '</div>' +
            '<div class="wemeet_p_bottom">' +
            '<span class="w_p_b_cancel">取消</span>' +
            '<span class="w_p_b_confirm">确定</span>' +
            '</div>' +
            '</div>' +
            '</div>')
        $('body').append(
            '<div class="wemeet_left_alert">' +
            '<div class="wemeet_alert_top_content">' +
            '<div class="wemeet_alert_title">视频通话邀请</div>' +
            '<img src="/assets/images/wemeet/wemeet_right_delect.svg" class="wemeet_alert_delect_image">' +
            '</div>' +
            '<div class="wemeet_left_alert_middle_content">' +
            '<div class="wemeet_alert_middle_text_one">' +
            '<img src="" class="wemeet_left_alert_userHeader">' +
            '<span class="wemeet_alert_b_text_name">我</span>' +
            '<span class="wemeet_alert_b_text">正在邀请协作者们加入视频会议</span>' +
            '</div>' +
            '<div class="wemeet_alert_middle_text_two">' +
            '<span class="wemeet_alert_lignt_text">本次会议结束前可随时在</span>' +
            '<img src="/assets/images/wemeet/wemeet_middle_logo.svg" class="wemeet_alert_logo">' +
            '<span class="wemeet_alert_blue_text">腾讯会议</span>' +
            '<span class="wemeet_alert_lignt_text">中加入</span>' +
            '</div>' +
            '<div class="wemeet_alert_middle_text_three">' +
            '<span class="wemeet_alert_lignt_text">会议ID:</span>' +
            '<span class="wemeet_alert_black_text">9999999</span>' +
            '<img src="/assets/images/wemeet/wemeet_copy.svg" class="wemeet_alert_copy">' +
            '</div>' +
            '</div>' +
            '<div class="wemeet_alert_bottom">' +
            '<span class="wemeet_alert_left_butt_l">结束通知</span>' +
            '<span class="wemeet_alert_left_butt_r">加入会议</span>' +
            '</div>' +
            '</div>')
        $('body').append('<div class="wemeet_toast">' +
            '</div>')
    },
    //获取腾讯会议参数
    getWemeetParamsUrl: function () {
        Util.ajax({
            url: '/api/personal/wemeet/getSignUrl',
            type: "post",
            data: {},
            success: function (data) {
                wemeetCommon.wemeetSignUrl = data.signUrl;
                wemeetCommon.wemeetSdkId = data.sdkId;
                wemeetCommon.wemeetAppId = data.appId;   
            }
        })
    },
    isMac: function () {
        return /macintosh|mac os x/i.test(navigator.userAgent);
    },
    isIos: function () {
        var u = navigator.userAgent;
        var isAndroid = u.indexOf('Android') > -1 || u.indexOf('Adr') > -1; //android终端
        var isiOS = !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/); //ios终端
        if (isiOS) {
            return 'ios';
        } else if (isAndroid) {
            return 'isAndroid';
        }
    },
    isWindow: function(){
        var agent = navigator.userAgent.toLowerCase();
        if (agent.indexOf("win32") >= 0 || agent.indexOf("wow32") >= 0 || agent.indexOf("win64") >= 0 || agent.indexOf("wow64") >= 0) {
            return true
        }else{
            return false
        }
    },
    addConfirmAlert: function () {
        if($(".wemeet_poupe_pay").length){
            $(".wemeet_poupe_pay").show();
        }else{
            $('body').append(
                '<div class="wemeet_poupe_pay">' +
                '<div class="wemeet_poupe_pay_content">' +
                '<div class="wemeet_poupe_pay_title">温馨提示</div>' +
                '<div class="wemeet_poupe_pay_delect"><img src="/assets/images/wemeet/wemeet_right_top_delect.svg"/></div>' +
                '<div class="wemeet_poupe_pay_middle_text">'+
                '<span>请移步浏览器进入ProcessOn官网</span>'+
                '<span>（</span>'+
                '<span class="wemeet_address_blue">www.processon.com</span>'+
                '<div class="wemeet_address_copy"><img src="/assets/images/wemeet/wemeet_copy.svg"/></div>' +
                '<span>）</span>'+
                '<span>继续操作</span>'+
                '</div>' +
                '<div class="wemeet_poupe_pay_right_butt">知道了</div>' +
                '</div>' +
                '</div>'
            )
            $(".wemeet_poupe_pay").show();
        }
        
    },
    getInsertPay:function(){
        if(insert){
            insert.pay.init = function(){
                wemeetCommon.wemeetScreenPay("editor");
            }
        }
    }
}
var wemeetWebSocket = {
    WEMEET_TYPE: {
        CREAT_NOTICE: "CREAT_NOTICE",//开始通知
        SUS_NOTICE: "SUS_NOTICE",//暂停通知
        REC_NOTICE: "REC_NOTICE",//恢复通知
        NO_NOTICE: "NO_NOTICE",//不再提醒
    },
    msg: function (data) {
        if (data.content.type == this.WEMEET_TYPE.CREAT_NOTICE) {
            wemeetCommon.collaboratorAlertView(data)
        } else if (data.content.type == this.WEMEET_TYPE.SUS_NOTICE) {
            window.sessionStorage.setItem("SUS_NOTICE", "YES");
            wemeetCommon.collaboratorAlertViewHide()
        } else if (data.content.type == this.WEMEET_TYPE.REC_NOTICE) {
            window.sessionStorage.setItem("SUS_NOTICE", "NO");
            wemeetCommon.collaboratorAlertView(data)
        }
    }
}