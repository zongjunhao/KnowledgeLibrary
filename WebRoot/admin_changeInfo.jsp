<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
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
							<label class="col-sm-4 control-label">用户名</label>
							<div class="col-sm-8">
								<div class="input-group">
									<input type="text" class="name form-control" placeholder="请输入用户名" />
									<span class="input-group-btn">
										<span class="icon1 iconfont icon-tongguo"></span>
									</span>
								</div><!-- /input-group -->

							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">原密码</label>
							<div class="col-sm-8">
								<div class="input-group">
									<input type="password" class="password1 form-control" placeholder="请输入原密码" />
									<span class="input-group-btn">
										<span class="icon2 iconfont icon-jujue"></span>
									</span>
								</div><!-- /input-group -->
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">新密码</label>
							<div class="col-sm-8">
								<div class="input-group">
									<input type="password" class="password2 form-control" placeholder="请输入新密码" />
									<span class="input-group-btn">
										<span class="icon3 iconfont icon-jujue"></span>
									</span>
								</div><!-- /input-group -->
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">确认密码</label>
							<div class="col-sm-8">
								<div class="input-group">
									<input type="password" class="password form-control" placeholder="请确认密码" />
									<span class="input-group-btn">
										<span class="icon4 iconfont icon-jujue">
										</span>
								</div><!-- /input-group -->

							</div>
						</div>
						<div class="form-group">
							<div class="col-sm-12">
								<button id="modify" class=" btn btn-default text-right"
									style="float: right;">修改</button>
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
	// 	});

	$(function () {
		$(".name").val($.session.get("a_account"))
		$("#modify").click(function () {
			if (checkName() && checkOldPass() && checkNewPass() && checkNewPass1()) {
				console.log("click")
				$.ajax({
					type: "POST",
					url: "/KnowledgeLibrary/sysAdmin/modifyAdminInfo",
					data: {
						a_id: $.session.get("a_id"),
						newAccount: $(".name").val(),
						newPwd: $(".password").val()
					},
					success: function (res) {
						console.log(res)
						console.log("成功修改")
						$.session.set("a_account", $(".name").val())
						$.session.set("a_pwd", $(".password").val())
						location.href = "admin_info.jsp";
					},
					error: function (res) {
						console.log(res)
					}
				})
			}
		})

		$(".icon1").css({ "color": "green" });
		$(".icon2").css({ "color": "red" });
		$(".icon3").css({ "color": "red" });
		$(".icon4").css({ "color": "red" });
		$(".name").on("blur", function () {
			checkName()
		});
		$(".password1").on("blur", function () {
			checkOldPass()
		});
		$(".password2").on("blur", function () {
			checkNewPass()
		});
		$(".password").on("blur", function () {
			checkNewPass1()
		});
	})

	function checkInfo() {
		console.log(checkName())
		console.log(checkOldPass())
		if (checkName() && checkOldPass()) {
			console.log("1")
		} else {
			console.log(2)
		}

	}


	function checkName() {
		if (($(".name").val() == "")) {
			//console.log("empty")
			$(".icon1").removeClass("icon-tongguo").addClass("icon-jujue").css({ "color": "red" });
			return false;
		} else {
			console.log("not")
			$(".icon1").removeClass("icon-jujue").addClass("icon-tongguo").css({ "color": "green" });
			return true;
		}
	}

	function checkOldPass() {
		if ($(".password1").val() == "" || $(".password1").val() != $.session.get("a_pwd")) {
			$(".icon2").removeClass("icon-tongguo").addClass("icon-jujue").css({ "color": "red" });
			return false;
		} else {
			$(".icon2").removeClass("icon-jujue").addClass("icon-tongguo").css({ "color": "green" });
			return true;
		}
	}

	function checkNewPass() {
		if (($(".password2").val() == "")) {
			//console.log("empty")
			$(".icon3").removeClass("icon-tongguo").addClass("icon-jujue").css({ "color": "red" });
			return false;
		} else {
			//console.log("not")
			$(".icon3").removeClass("icon-jujue").addClass("icon-tongguo").css({ "color": "green" });
			return true;
		}
	}

	function checkNewPass1() {
		if ($(".password").val() == "" || $(".password").val() != $(".password2").val()) {
			$(".icon4").removeClass("icon-tongguo").addClass("icon-jujue").css({ "color": "red" });
			return false;
		} else {
			$(".icon4").removeClass("icon-jujue").addClass("icon-tongguo").css({ "color": "green" });
			return true;
		}
	}




</script>

</html>