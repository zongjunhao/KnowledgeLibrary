<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
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
		#userInfo {
			padding-top: 20px;
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
							<label class="col-sm-2 control-label">用户名</label>
							<div class="col-sm-10">
								<div class="name form-control">1</div>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">密码</label>
							<div class="col-sm-10">
								<div class="password form-control">1</div>
							</div>
						</div>
					</div>
				</div>
			</div>

		</div>
	</div>

</body>
<script type="text/javascript">
//   $(document).ready(function () {
// 		//监听子页面大小变化，设置父页面iframe的大小
// 	  if($(document.body).height()<355){
// 			window.parent.document.getElementById("myiframe").height = 355
// 		}else{
// 			window.parent.document.getElementById("myiframe").height=$(document.body).height();
// 		}
// 		//window.parent.document.getElementById("myiframe").height=$(document.body).height();
// 		console.log("setHeight")
// 		addResizeListener(document.getElementsByTagName("body")[0],function(){
// 			if($(document.body).height()<355){
// 				window.parent.document.getElementById("myiframe").height = 355
// 			}else{
// 				window.parent.document.getElementById("myiframe").height=$(document.body).height();
// 			}
// 		});
// 		$(".name").text($.session.get("a_account"));
// 		$(".password").text($.session.get("a_pwd"));
// 	});


</script>

</html>