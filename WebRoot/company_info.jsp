<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
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
					<form class="form-horizontal">

						<div class="form-group">
							<label class="col-sm-4 control-label">企业名称</label>
							<div class="col-sm-8">
								<div class="f_name form-control">开元有限公司</div>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">企业法人</label>
							<div class="col-sm-8">
								<div class="f_corporation form-control">小杨</div>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">统一社会信用代码</label>
							<div class="col-sm-8">
								<div class="f_code form-control">FHDJHSO123HK</div>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">企业电话</label>
							<div class="col-sm-8">
								<div class="f_phone form-control">15717172075</div>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">企业邮箱</label>
							<div class="col-sm-8">
								<div class="f_mail form-control">15717172075@qq.com</div>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">企业地址</label>
							<div class="col-sm-8">
								<div class="f_address form-control">中南财经政法大学</div>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">企业介绍</label>
							<div class="col-sm-8">
								<div class="f_desc form-control">中南财经政法大学识意小分队</div>
							</div>
						</div>
					</form>
				</div>
			</div>

		</div>
	</div>
</body>
<script>
	//   $(document).ready(function () {
	// 		//监听子页面大小变化，设置父页面iframe的大小
	// 		if($(document.body).height()<355){
	// 			window.parent.document.getElementById("myiframe").height = 355
	// 		}else{
	// 			window.parent.document.getElementById("myiframe").height=$(document.body).height();
	// 		}


	// 		console.log("setHeight")
	// 		addResizeListener(document.getElementsByTagName("body")[0],function(){
	// 			window.parent.document.getElementById("myiframe").height=$(document.body).height();
	// 		});		
	// 	});

	$(function () {
		$.ajax({
			type: "POST",
			url: "/KnowledgeLibrary/sysAdmin/viewFirmInfo",
			data: {
				f_id: $.session.get("u_firm")
			},
			success: function (res) {
				//console.log(res)
				if (res.resultCode == "2006") {
					$(".f_name").text(res.data.f_name)//设置企业名称
					$(".f_corporation").text(res.data.f_corporation)//设置企业法人
					$(".f_code").text(res.data.f_code)//设置统一社会信用代码
					$(".f_phone").text(res.data.f_phone)//设置联系电话
					$(".f_address").text(res.data.f_address)//设置企业地址
					$(".f_mail").text(res.data.f_mail)//设置企业邮箱
					//$("#item7").text(res.data.f_password)//设置密码
					$(".f_desc").text(res.data.f_desc)//设置企业介绍
					//$("#test3").text(res.resultDesc);
				} else if (res.resultCode == "2007") {
					//$("#test3").text(res.resultDesc);
				} else if (res.resultCode == "2011") {
					//$("#test3").text(res.resultDesc);
				}
			},
			error: function (res) {
				console.log(res);
				$("#test3").text("请求的页面有问题");
			}
		})
	})

  //发请求

</script>

</html>