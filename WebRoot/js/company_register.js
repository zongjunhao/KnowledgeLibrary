function check_firm_name(){
    if(($("#corp_name").val()=="")){
        $("#corp_name").css("border-color", "#F05A5A");
        $("#corp_name_tip").text("请输入正确的企业名");
        $("#corp_name_tip").css("color", "#F05A5A");
        return false;
    }else{
        firm_name_recovery();
        return true;
    }
}
function firm_name_recovery(){
    $("#corp_name").css("border-color", "#C7C7C7");
    $("#corp_name_tip").text("请填写企业、政府或组织名称");
    $("#corp_name_tip").css("color", "#7F7F7F");
}


function check_legal_person_name(){
    if(($("#legal_person_name").val()=="")){
        $("#legal_person_name").css("border-color", "#F05A5A");
        $("#legal_person_name_tip").text("请输入正确的法人姓名");
        $("#legal_person_name_tip").css("color", "#F05A5A");
        return false;
    }else{
        firm_name_recovery();
        return true;
    }
}
function legal_person_name_recovery(){
    $("#legal_person_name").css("border-color", "#C7C7C7");
    $("#legal_person_name_tip").text("请填写企业法人的姓名");
    $("#legal_person_name_tip").css("color", "#7F7F7F");
}


function check_admin_name(){
    if(($("#admin_name").val()=="")){
        $("#admin_name").css("border-color", "#F05A5A");
        $("#admin_name_tip").text("请输入正确的管理员姓名");
        $("#admin_name_tip").css("color", "#F05A5A");
        return false;
    }else{
        admin_name_recovery();
        return true;
    }
}
function admin_name_recovery(){
    $("#admin_name").css("border-color", "#C7C7C7");
    $("#admin_name_tip").text("请填写企业的管理员姓名");
    $("#admin_name_tip").css("color", "#7F7F7F");
}


function check_mail(){
    var email = $("#mail").val();
    // console.log(email)
    var myReg = /^[a-zA-Z0-9_-]+@([a-zA-Z0-9]+\.)+(com|cn|net|org)$/;
    if(!myReg.test(email)){
        if(!$("#mail").is(":focus")){
            $("#mail").css("border-color", "#F05A5A");
            $("#mail_tip").text("请输入正确的邮箱地址");
            $("#mail_tip").css("color", "#F05A5A");
        }
        $("#smscode").attr("disabled",true);
        $("#get_smscode").attr("disabled",true);
        return false;
    }else{
        mail_recovery();
        $("#smscode").attr("disabled",false);
        $("#get_smscode").attr("disabled",false);
        return true;
    }
}
function mail_recovery(){
    $("#mail").css("border-color", "#C7C7C7");
    $("#mail_tip").text("请输入你的邮箱");
    $("#mail_tip").css("color", "#7F7F7F");
}

function check_smscode(){
    var email = $("#smscode").val();
    // console.log(email)
    var myReg = /^\d{6}$/;
    if(!myReg.test(email)){
        $("#smscode").css("border-color", "#F05A5A");
        $("#smscode_tip").text("请填写正确的验证码");
        $("#smscode_tip").css("color", "#F05A5A");
        return false;
    }else{
        smscode_recovery();
        return true;
    }
}
function smscode_recovery(){
    $("#smscode").css("border-color", "#C7C7C7");
    $("#smscode_tip").text("请输入邮箱收到的6位验证码");
    $("#smscode_tip").css("color", "#7F7F7F");
}

function check_password(){
    if($("#password").val()==""){
        $("#password").css("border-color", "#F05A5A");
        $("#password_tip").css("color", "#F05A5A");
        return false;
    }else{
        password_recovery();
        return true;
    }
}
function password_recovery(){
    $("#password").css("border-color", "#C7C7C7");
    $("#password_tip").css("color", "#7F7F7F");
}

function check_confirm_password(){
    if($("#password").val()!=$("#password_confirm").val()){
        $("#password_confirm").css("border-color", "#F05A5A");
        $("#confirm_tip").text("两次输入密码不一致，请重新输入");
        $("#confirm_tip").css("color", "#F05A5A");
        return false;
    }else{
        confirm_recovery();
        return true;
    }
}
function confirm_recovery(){
    $("#password_confirm").css("border-color", "#C7C7C7");
    $("#confirm_tip").text("再次输入密码");
    $("#confirm_tip").css("color", "#7F7F7F");
}

function get_smscode(){
    console.log("获取验证码")
    $.ajax({
        type : "POST",
        url : "/KnowledgeLibrary/firm/mailConfirm",
        data : {
            f_mail : $("#mail").val(),
        },
        success : function(json) {

        },
        error : function(jqXHR) {

        }
    });
}

function submit(){
    var flag = check_firm_name();
    flag = check_legal_person_name() && flag;
    flag = check_admin_name() && flag;
    flag = check_mail() && flag;
    flag = check_smscode() && flag;
    flag = check_password() && flag;
    flag = check_confirm_password() &&flag;
    if(flag){
        console.log("全部填写")
        $.ajax({
            type : "POST",
            url : "/KnowledgeLibrary/firm/register",
            data : {
                f_name : $("#corp_name").val(),
                f_corporation : $("#legal_person_name").val(),
                u_name : $("#admin_name").val(),
                u_mail : $("#mail").val(),
                confirmCode : $("#smscode").val(),
                u_pwd : $("#password").val()
            },
            success : function(json) {
                if (json.resultCode == "8000"){
                    window.location.href = "login.html";
                } else {
                    // alert("您所请求的页面有异常");
                    console.log(json.resultCode)
                    console.log("状态码错误")
                    $("#submit_tip").text(json.resultDesc)
                }
            },
            error : function(jqXHR) {
                // alert("您所请求的页面有异常");
                console.log("错误")
                $("#submit_tip").text("您所请求的页面有异常")
            }
        })
    }else{
        console.log("未全部填写")
    }
}