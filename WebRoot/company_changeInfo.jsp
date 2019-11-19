<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <meta charset="utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<!-- 添加bootstrap的css样式表 -->
	<link rel="stylesheet" type="text/css" href="lib/css/bootstrap.css">
	<!-- 添加JQ -->
	<script type="text/javascript" src="lib/jq/jquery-3.4.1.js"></script>
	<script type="text/javascript" src="js/jquerySession.js"></script>
	<!-- 添加bootstrap的库 -->
	<script type="text/javascript" src="lib/js/bootstrap.js"></script>
	<!-- 	监听页面窗口大小改变的插件 -->
	<script type="text/javascript" src="lib/js/detect-element-resize.js"></script>
	<!-- 引用阿里的字体图标库 -->
	<link rel="stylesheet" type="text/css" href="http://at.alicdn.com/t/font_1333406_174a1653fij.css">
	<style>
		#userInfo{
			padding-top:20px;
		}
	</style>
</head>
 
  <body>
  <div id="userInfo">
		<div class="container">
			<div class="row">
				<div class="col-md-6 col-md-offset-3">
					<div class="form-horizontal">
						
						<div class="form-group">
							<label class="col-sm-4 control-label">企业名称</label>
							<div class="col-sm-8">
								<!-- <div class="f_name form-control">开元有限公司</div> -->
								<div class="input-group">
      								<input type="text" class="f_name form-control" placeholder="请输入公司名称" />
 									<span class="input-group-btn">
									    <span  class="icon1 iconfont icon-tongguo"></span>
      								</span>
							    </div><!-- /input-group -->
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">企业法人</label>
							<div class="col-sm-8">
								<div class="input-group">
      								<input type="text" class="f_corporation form-control" placeholder="请输入法人名称" />
 									<span class="input-group-btn">
									    <span  class="icon2 iconfont icon-tongguo"></span>
      								</span>
							    </div><!-- /input-group -->
								<!-- <div class="f_corporation form-control">小杨</div> -->
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">统一社会信用代码</label>
							<div class="col-sm-8">
								<div class="input-group">
      								<input type="text" class="f_code form-control" placeholder="请输入统一社会信用代码" />
 									<span class="input-group-btn">
									    <span  class="icon3 iconfont icon-tongguo"></span>
      								</span>
							    </div><!-- /input-group -->
								<!-- <div class="f_code form-control">FHDJHSO123HK</div> -->
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">企业电话</label>
							<div class="col-sm-8">
								<!-- <div class="f_phone form-control">15717172075</div> -->
								<div class="input-group">
      								<input type="text" class="f_phone form-control" placeholder="请输入企业电话" />
 									<span class="input-group-btn">
									    <span  class="icon4 iconfont icon-tongguo"></span>
      								</span>
							    </div><!-- /input-group -->
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">企业邮箱</label>
							<div class="col-sm-8">
								<!-- <div class="f_phone form-control">15717172075</div> -->
								<div class="input-group">
      								<input type="text" class="f_mail form-control" placeholder="请输入企业邮箱" />
 									<span class="input-group-btn">
									    <span  class="icon5 iconfont icon-tongguo"></span>
      								</span>
							    </div><!-- /input-group -->
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">企业地址</label>
							<div class="col-sm-8">
								<!-- <div class="f_address form-control">中南财经政法大学</div> -->
								<div class="input-group">
      								<input type="text" class="f_address form-control" placeholder="请输入企业地址" />
 									<span class="input-group-btn">
									    <span  class="icon6 iconfont icon-tongguo"></span>
      								</span>
							    </div><!-- /input-group -->
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">企业介绍</label>
							<div class="col-sm-8">
								<!-- <div class=" form-control">中南财经政法大学识意小分队</div> -->
								<div class="input-group">
      								<input type="text" class="f_desc form-control" placeholder="请输入企业介绍" />
 									<span class="input-group-btn">
									    <span  class="icon7 iconfont icon-tongguo"></span>
      								</span>
							    </div><!-- /input-group -->
							</div>
						</div>
						<div class="form-group">
							<div class="col-sm-12">
								<button id="modify" class=" btn btn-default text-right" style="float: right;">修改</button>
							</div>
						</div>
					</div>
				</div>
			</div>
			
		</div>
	</div>
  </body>
  <script>
  $(document).ready(function () {
		//监听子页面大小变化，设置父页面iframe的大小
		window.parent.document.getElementById("myiframe").height=$(document.body).height();
		console.log("setHeight")
		addResizeListener(document.getElementsByTagName("body")[0],function(){
			window.parent.document.getElementById("myiframe").height=$(document.body).height();
		});		
	});
  $(function(){
	  $.ajax({
			type:"POST",
			url:"/KnowledgeLibrary/sysAdmin/viewFirmInfo",
			data:{
				f_id:$.session.get("u_firm")
			},
			success: function(res){
				//console.log(res)
				if(res.resultCode=="2006"){
				$(".f_name").val(res.data.f_name)//设置企业名称
				$(".f_corporation").val(res.data.f_corporation)//设置企业法人
				$(".f_code").val(res.data.f_code)//设置统一社会信用代码
				$(".f_phone").val(res.data.f_phone)//设置联系电话
				$(".f_address").val(res.data.f_address)//设置企业地址
				$(".f_mail").val(res.data.f_mail) //设置企业邮箱
				//$("#item7").text(res.data.f_password)//设置密码
				$(".f_desc").val(res.data.f_desc)//设置企业介绍
				//$("#test3").text(res.resultDesc);
				}else if(res.resultCode=="2007"){
					//$("#test3").text(res.resultDesc);
				}else if(res.resultCode=="2011"){
					//$("#test3").text(res.resultDesc);
				}
				},
			error: function(res){
				console.log(res);
				$("#test3").text("请求的页面有问题");
			}
		})
		$("#modify").click(function(){
			if(checkName()&&checkCorporation()&&checkCode()&&checkPhone()&&checkAddress()&&checkEmail()){
				console.log("click")
				$.ajax({
					type:"POST",
					url : "/KnowledgeLibrary/firm/modifyFirmInfo",
					data : {
						f_id : $.session.get("u_firm"),
						newName : $(".f_name").val(),
						newCorporation : $(".f_corporation").val(),
						newCode : $(".f_code").val(),
						newPhone : $(".f_phone").val(),
						newAddress : $(".f_address").val(),
						newMail : $(".f_mail").val(),
						newDesc : $(".f_desc").val()
					},
					success:function(res){
						console.log(res)
						location.href="company_info.jsp"
					},
					error : function(res){
						console.log(res)
					}
				})
			}
		})
			
		$(".icon1").css({"color":"green"});
	    $(".icon2").css({"color":"green"});
	    $(".icon3").css({"color":"green"});
	    $(".icon4").css({"color":"green"});
	    $(".icon5").css({"color":"green"});
	    $(".icon6").css({"color":"green"});
	    $(".icon7").css({"color":"green"});
	    $(".f_name").on("blur",function(){
	          checkName()
		});	
	    $(".f_corporation").on("blur",function(){
	          checkCorporation()
		});	
	    $(".f_code").on("blur",function(){
	          checkCode()
		});	
	    $(".f_phone").on("blur",function(){
	          checkPhone()
		});	
	    $(".f_address").on("blur",function(){
	          checkAddress()
		});	
	    $(".f_mail").on("blur",function(){
	          checkEmail()
		});	
  })
  
  function checkName(){
	  if(($(".f_name").val()=="")){
          $(".icon1").removeClass("icon-tongguo").addClass("icon-jujue").css({"color":"red"});
		  return false;
      }else{
    	  //console.log("not")
    	  $(".icon1").removeClass("icon-jujue").addClass("icon-tongguo").css({"color":"green"});
    	  return true;
      }
  }
  
  function checkCorporation(){
	  if($(".f_corporation").val()==""){
          $(".icon2").removeClass("icon-tongguo").addClass("icon-jujue").css({"color":"red"});
          return false;
      }else{
    	  $(".icon2").removeClass("icon-jujue").addClass("icon-tongguo").css({"color":"green"});
    	  return true;
      }
  }
  
  function checkCode(){
	  if(($(".f_code").val()=="")){
		  //console.log("empty")
          $(".icon3").removeClass("icon-tongguo").addClass("icon-jujue").css({"color":"red"});
		  return false;
      }else{
    	  //console.log("not")
    	  $(".icon3").removeClass("icon-jujue").addClass("icon-tongguo").css({"color":"green"});
    	  return true;
      }
  }
  
  function checkPhone(){
	  var myPho = /^[1][3,4,5,7,8][0-9]{9}$/;
	  if(!myPho.test($(".f_phone").val())){
          $(".icon4").removeClass("icon-tongguo").addClass("icon-jujue").css({"color":"red"});
          return false;
      }else{
    	  $(".icon4").removeClass("icon-jujue").addClass("icon-tongguo").css({"color":"green"});
    	  return true;
      }
  }
  
  function checkAddress(){
	  if($(".f_address").val()==""){
          $(".icon6").removeClass("icon-tongguo").addClass("icon-jujue").css({"color":"red"});
          return false;
      }else{
    	  $(".icon6").removeClass("icon-jujue").addClass("icon-tongguo").css({"color":"green"});
    	  return true;
      }
  }
  
  function checkEmail(){
	  var myReg = /^[a-zA-Z0-9_-]+@([a-zA-Z0-9]+\.)+(com|cn|net|org)$/;
	  if(!myReg.test($(".f_mail").val())){
          $(".icon5").removeClass("icon-tongguo").addClass("icon-jujue").css({"color":"red"});
          return false;
      }else{
    	  $(".icon5").removeClass("icon-jujue").addClass("icon-tongguo").css({"color":"green"});
    	  return true;
      }
  }

  </script>
</html>