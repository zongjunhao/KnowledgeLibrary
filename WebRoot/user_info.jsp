<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
 
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
					<form class="form-horizontal">
						
						<div class="form-group">
							<label class="col-sm-4 control-label">名称</label>
							<div class="col-sm-8">
								<div class="u_name form-control"></div>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">性别</label>
							<div class="col-sm-8">
								<div class="u_gender form-control"></div>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">年龄</label>
							<div class="col-sm-8">
								<div class="u_age form-control"></div>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">电话</label>
							<div class="col-sm-8">
								<div class="u_phone form-control"></div>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">邮箱</label>
							<div class="col-sm-8">
								<div class="u_email form-control"></div>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">权限</label>
							<div class="col-sm-8">
								<div class="u_role form-control"></div>
							</div>
						</div>
						
					</form>
				</div>
			</div>
			
		</div>
	</div>
  </body>
  <script>
  $(document).ready(function () {
		//监听子页面大小变化，设置父页面iframe的大小
	  if($(document.body).height()<355){
			window.parent.document.getElementById("myiframe").height = 355
		}else{
			window.parent.document.getElementById("myiframe").height=$(document.body).height();
		}
		//window.parent.document.getElementById("myiframe").height=$(document.body).height();
		console.log("setHeight")
		addResizeListener(document.getElementsByTagName("body")[0],function(){
			if($(document.body).height()<355){
				window.parent.document.getElementById("myiframe").height = 355
			}else{
				window.parent.document.getElementById("myiframe").height=$(document.body).height();
			}
		});
	});
  
  $(function(){
	  
	  var id = (getUrlParam("id")==null?$.session.get("u_id"):getUrlParam("id"))
	  console.log("id",id)
	  $.ajax({
		  type:"post",
		  url:"/KnowledgeLibrary/user/viewUserInfo",
		  data:{
			  u_id:id
		  },
		  success:function(res){
			  console.log(res)
			  $(".u_name").text(res.data.u_name)
			  $(".u_gender").text(res.data.u_gender)
			  $(".u_phone").text(res.data.u_phone)
			  console.log(res.data.u_role)
			  $(".u_role").text(res.data.u_role==1?"普通用户":(res.data.u_role==2?"用户管理员":(res.data.u_role==3?"知识管理员":(res.data.u_role==4?"超级管理员":"公司管理员"))))
			  $(".u_age").text(res.data.u_age)
			  $(".u_email").text(res.data.u_email)
		  },
		  error:function(res){
			  console.log(res)
		  }
	  })
  })
  
</script>
</html>