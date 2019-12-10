<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>

<head>
	<title>公司详情</title>

	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta content=”text/html;charset=utf-8″ />
	<!-- 添加bootstrap的css样式表 -->
	<link rel="stylesheet" type="text/css" href="lib/css/bootstrap.css">
	<!-- 添加JQ -->
	<script type="text/javascript" src="lib/jq/jquery-3.4.1.js"></script>
	<script type="text/javascript" src="js/jquerySession.js"></script>
	<!-- 添加bootstrap的库 -->
	<script type="text/javascript" src="lib/js/bootstrap.js"></script>
	<!-- 	监听页面窗口大小改变的插件 -->
	<script type="text/javascript" src="lib/js/detect-element-resize.js"></script>
	<style type="text/css">
		#comInfo {
			padding-top: 20px;
		}

		button {
			float: right;
			padding: 4px;
			width: 70px;
			font-size: 1em;
			border: 1px solid #ccc;
			height: 40px;
			background-color: white;
			font-family: Microsoft YaHei;
			border-radius: 5px;
		}

		.loading {
			position: absolute;
			width: 400px;
			height: 300px;
			top: 90px;
			left: 30%;
			z-index: 100;

		}
	</style>

</head>

<body>
	<div id="comInfo">
		<div class="container">
			<div class="row">
				<div class="col-md-6 col-md-offset-3">
					<div class="form-horizontal">
						<div class="form-group">
							<label class="col-sm-4 control-label">企业名称</label>
							<div class="col-sm-8">
								<div class="f_name form-control"></div>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">企业法人</label>
							<div class="col-sm-8">
								<div class="f_corporation form-control"></div>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">统一社会信用代码</label>
							<div class="col-sm-8">
								<div class="f_code form-control"></div>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">联系电话</label>
							<div class="col-sm-8">
								<div class="f_phone form-control"></div>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">企业地址</label>
							<div class="col-sm-8">
								<div class="f_address form-control"></div>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">企业邮箱</label>
							<div class="col-sm-8">
								<div class="f_mail form-control"></div>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">密码</label>
							<div class="col-sm-8">
								<div class="f_password form-control"></div>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">企业介绍</label>
							<div class="col-sm-8">
								<div class="f_desc form-control"></div>
							</div>
						</div>
						<div class="button form-group">
							<div class="col-sm-12">
								<button id="pass" class=" btn btn-default text-right" style="float: left;">通过</button>
								<button id="unpass" class=" btn btn-default text-right"
									style="float: right;">不通过</button>
							</div>
						</div>
					</div>
					<div id="loading"></div>
				</div>
			</div>

		</div>
	</div>
</body>
<script>
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
	// 	});
	console.log(getUrlParam("checkCom"))

	if (getUrlParam("checkCom") == "yes") {
		$(".button").show()
	} else {
		$(".button").hide()
	}
	var id = getUrlParam("f_id");
	console.log(id)
	$(function () {
		$.ajax({
			type: "POST",
			url: "/KnowledgeLibrary/sysAdmin/viewFirmInfo",
			data: {
				f_id: id
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
					$(".f_password").text(res.data.f_password)//设置密码
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

	});

	$("#pass").click(function () {
		$("#loading").append("<img src='./image/加载动画.gif' class='loading'></img>");
		$.ajax({
			type: "POST",
			url: "/KnowledgeLibrary/sysAdmin/modifyAuditState",
			data: {
				f_id: id,//公司id
				newAuditState: "2"//审核状态2表示通过,3表示不通过
			},
			success: function (json) {
				// 				console.log(json)
				if (json.resultCode == "6000") {
					//成功
					alert("审核成功:审核通过")
					console.log("审核通过")
					$("#loading").remove()
					location.href = "admin_mainpage.jsp";
				} else {
					//审核失败
					console.log("审核失败")
					alert("审核失败")
					$("#loading").remove()
				}
			},
			error: function (jqXHR) {
				$("#loading").remove()
				alert("您所请求的页面有异常")
				$("#test3").text("您所请求的页面有异常");
			}
		});
	});

	$("#unpass").click(function () {
		$("#loading").append("<img src='./image/加载动画.gif' class='loading'></img>");
		$.ajax({
			type: "POST",
			url: "/KnowledgeLibrary/sysAdmin/modifyAuditState",
			data: {
				f_id: id,//公司id
				newAuditState: "3"//3表示不通过
			},
			success: function (json) {
				if (json.resultCode == "6000") {
					//成功
					$("#loading").remove()
					alert("审核成功:审核不通过")
					console.log("审核不通过")
					location.href = "admin_mainpage.jsp";
				} else {
					//登录失败123123412341234
					alert("审核失败")
					$("#loading").remove()
					alert(json.resultDesc);
				}
			},
			error: function (jqXHR) {
				$("#loading").remove()
				alert("您所请求的页面异常")
				alert(json.resultDesc);
			}
		});
	});

	$("#return").click(function () { location.href = getUrlParam("return") })
</script>

</html>