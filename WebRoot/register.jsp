<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <link rel="stylesheet" href="css/register.css" type="text/css" />
  <script type="text/javascript" src = "js/jquery.js"></script>
  <script type="text/javascript" src = "js/jquerySession.js"></script>	
  <title>Register</title>
  
</head>
<body>
  <!-- 公司名称 公司地址 公司邮箱 密码 确认密码
       企业法人  统一社会信用代码   企业介绍-->
    
  <div class="content">
    <div class="title">欢迎注册</div>
    <hr>
    <div class="body">
      <div class="item">
        <input type="text" placeholder="企业名称" class="bg1"/>
      </div>
      <div id="item1" style="color:white;">请输入企业名称！</div>
      <div class="item">
        <input type="text" placeholder="企业法人" class="bg2" />
      </div>
      <div id="item2" style="color:white;">请输入企业法人！</div>
      <div class="item">
        <input type="text" placeholder="统一社会信用代码" class="bg3"  maxlength="20"/>
      </div>
      <div id="item3" style="color:white;">请输入统一信用代码！</div>
      <div class="item">
        <input type="text" placeholder="联系电话" class="bg4" />
      </div>
      <div id="item4" style="color:white;">请输入正确的联系电话！</div>
      <div class="item">
        <input type="text" placeholder="企业地址" class="bg5" />
      </div>
      <div id="item5" style="color:white;">请输入企业地址！</div>
      <div class="item">
        <input type="text" placeholder="企业邮箱"  class="bg6" />
      </div>
      <div id="item6" style="color:white;">请输入正确的企业邮箱！</div> 
      <div class="item" id="confirm">
      	<input type="text" placeholder="请输入验证码" id="confirmCode" />
      	<button id="confirmBtn">获取邮箱验证码</button>
      </div>
      <div class="item">
        <input type="password" placeholder="输入密码" class="bg7"/>
      </div>
      <div id="item7" style="color:white;">请输入密码！</div>
      <div class="item">
        <input type="password" placeholder="确认密码" class="bg8" />
      </div>
      <div id="item8" style="color:white;">请输入相同的密码！</div>
      <div class="item">
        <textarea rows="2" placeholder="企业介绍" class="bg9"></textarea>
      </div>
      <div id="item9" style="color:white;"></div>     
    </div>
    <div>
      <button id="register" class="button1">注册</button>
      <button id="return" class="button2">返回</button>
    </div>    
  </div>
  <script type="text/javascript">
  
    $("#item1").hide();
    $("#item2").hide();
    $("#item3").hide();
    $("#item4").hide();
    $("#item5").hide();
    $("#item6").hide();
    $("#item7").hide();
    $("#item8").hide();
    //企业名称
    $(".bg1").on("blur",function(){
      checkName()
    });
    function checkName(){
    	if(($(".bg1").val()=="")){
            $("#item1").show();
          }else{
            $("#item1").hide();
          }
    }
    //企业法人
    $(".bg2").on("blur",function(){
        checkPeople()
      });
    function checkPeople(){
    	if(($(".bg2").val()=="")){
            $("#item2").show();
          }else{
            $("#item2").hide();
          }
    }
    
  //企业统一社会信用代码
    $(".bg3").on("blur",function(){
        checkCode()
      });
   function checkCode(){
	   if(($(".bg3").val()=="")){
	          $("#item3").show();
	        }else{
	          $("#item3").hide();
	        }
   }
  
  //使用正则表达式判断联系电话
    var myReg = /^1[3456789]\d{9}$/;
    $(".bg4").on("blur",function(){
    	checkPhon()
      });
    
    function checkPhon(){
    	if(myReg.test($(".bg4").val())){
            $("#item4").hide();
          }else{
            $("#item4").show();
          }
    }
  //企业地址
    $(".bg5").on("blur",function(){
    	checkAdd()
      });
  
  function checkAdd(){
	  if(($(".bg5").val()=="")){
          $("#item5").show();
        }else{
          $("#item5").hide();
        }
  }
  
  //使用正则表达式判断企业邮箱
    var myPho = /^[a-zA-Z0-9_-]+@([a-zA-Z0-9]+\.)+(com|cn|net|org)$/;
    $(".bg6").on("blur",function(){
    	checkEmail()
      });
    
    function checkEmail(){
    	if(myPho.test($(".bg6").val())){
            $("#item6").hide();
          }else{
            $("#item6").show();
          }
    }
  //第一次输入密码
    $(".bg7").on("blur",function(){
    	checkPass()
      });
  
  function checkPass(){
	  if(($(".bg7").val()=="")){
          $("#item7").show();
        }else{
          $("#item7").hide();
        }
  }
  //第二次输入密码
    $(".bg8").on("blur",function(){
    	reCheck()
      });
  
  function reCheck(){
	  if(($(".bg8").val()==$(".bg7").val())){
          $("#item8").hide();
        }else{
          $("#item8").show();
        }
  }
    $("#register").click(function() {
    	checkName()
    	checkPeople()
    	checkCode()
    	checkPhon()
    	checkAdd()
    	checkEmail()
    	checkPass()
    	reCheck()
		if (($(".bg1").val()!="") && ($(".bg2").val()!="")&&($(".bg3").val()!="")&&(myReg.test($(".bg4").val()))) {
			if(($(".bg5").val()!="")&&(myPho.test($(".bg6").val()))&&($(".bg7").val()!="")&&($(".bg8").val()!="")){
				$.ajax({
					type : "POST",
					url : "/KnowledgeLibrary/firm/register",
					data : {
						f_name : $(".bg1").val(),
						f_corporation:$(".bg2").val(),
						f_code:$(".bg3").val(),
						f_phone:$(".bg4").val(),
						f_address:$(".bg5").val(),
						f_mail:$(".bg6").val(),
						f_password:$(".bg7").val(),
						f_p_confirm : $(".bg8").val(),
						f_desc :$(".bg9").val(),
						confirmCode : $("#confirmCode").val(),
					},
					success : function(json) {
						if (json.resultCode == "8000") {
							//登录成功
							//alert(json.resultDesc);
							
							window.location.href = "company_login.jsp";
						} else {
							//登录失败
							//alert(json.resultDesc);
							$("#item9").text(json.resultDesc)
						}
					},
					error : function(jqXHR) {
						$("#item9").text("您所请求的页面有异常")
					}
				});
			}
			
		 } 
	});
    $("#confirmBtn").click(function(){
    	$.ajax({
			type : "POST",
			url : "/KnowledgeLibrary/firm/mailConfirm",
			data : {
				f_mail:$(".bg6").val(),
			},
			success : function(json) {
				//if (json.resultCode == "8000") {
					//登录成功
					//alert(json.resultDesc);
					//window.location.href = "company_login.jsp";
				//} else {
					//登录失败
					//alert(json.resultDesc);
					//$("#item9").text(json.resultDesc)
				//}
			},
			error : function(jqXHR) {
				//$("#item9").text("您所请求的页面有异常")
			}
		});
    })
  $("#return").click(function(){location.href="company_login.jsp"})
  </script>
  

</body>
</html>