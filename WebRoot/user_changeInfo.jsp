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
							<label class="col-sm-4 control-label">姓名</label>
							<div class="col-sm-8">
								<div class="input-group">
									<input type="text" class="u_name form-control" placeholder="请输入姓名" />
									<span class="input-group-btn">
										<span class="icon1 iconfont icon-tongguo"></span>
									</span>
								</div><!-- /input-group -->
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">性别</label>
							<div class="col-sm-8">
								<div class=" input-group ">
									<select class="u_gender form-control">
										<option value="女">女</option>
										<option value="男">男</option>
									</select>
									<span class="input-group-btn">
										<span class="icon2 iconfont icon-tongguo"></span>
									</span>
								</div><!-- /input-group -->
								<!-- <div class="f_corporation form-control">小杨</div> -->
							</div>
						</div>

						<div class="form-group">
							<label class="col-sm-4 control-label">年龄</label>
							<div class="col-sm-8">
								<div class="input-group">
									<input type="text" class="u_age form-control" placeholder="请输入年龄" />
									<span class="input-group-btn">
										<span class="icon3 iconfont icon-tongguo"></span>
									</span>
								</div><!-- /input-group -->
								<!-- <div class="f_code form-control">FHDJHSO123HK</div> -->
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">电话</label>
							<div class="col-sm-8">
								<!-- <div class="f_phone form-control">15717172075</div> -->
								<div class="input-group">
									<input type="text" class="u_phone form-control" placeholder="请输入电话" />
									<span class="input-group-btn">
										<span class="icon4 iconfont icon-tongguo"></span>
									</span>
								</div><!-- /input-group -->
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">邮箱</label>
							<div class="col-sm-8">
								<!-- <div class="f_phone form-control">15717172075</div> -->
								<div class="input-group">
									<input type="text" class="u_email form-control" placeholder="请输入邮箱" />
									<span class="input-group-btn">
										<span class="icon5 iconfont icon-tongguo"></span>
									</span>
								</div><!-- /input-group -->
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">权限</label>
							<div class="col-sm-8">
								<!-- <div class=" form-control">中南财经政法大学识意小分队</div>  input-group-->
								<div class="input-group ">
									<select class="u_role form-control" disabled>
										<option value="1">普通员工</option>
										<option value="2">用户管理员</option>
										<option value="3">知识管理员</option>
										<option value="4">超级管理员</option>
										<option value="5">公司管理员</option>
									</select>
									<span class="input-group-btn">
										<span class="icon6 iconfont icon-tongguo"></span>
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
										<span class="icon7 iconfont icon-jujue"></span>
									</span>
								</div><!-- /input-group -->
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-4 control-label">新密码</label>
							<div class="col-sm-8">
								<div class="input-group">
									<input type="password" class="u_pwd password2 form-control" placeholder="请输入新密码" />
									<span class="input-group-btn">
										<span class="icon8 iconfont icon-jujue"></span>
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
										<span class="icon9 iconfont icon-jujue">
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

		$(function () {
			$.ajax({
				type: "post",
				url: "/KnowledgeLibrary/user/viewUserInfo",
				data: {
					u_id: $.session.get("u_id")
				},
				success: function (res) {
					console.log(res)
					$(".u_name").val(res.data.u_name)
					$(".u_gender").val(res.data.u_gender)
					$(".u_phone").val(res.data.u_phone)
					$(".u_age").val(res.data.u_age)
					$(".u_role").val(res.data.u_role)
					$(".u_email").val(res.data.u_email)
				},
				error: function (res) {
					console.log(res)
				}
			})
			$("#modify").click(function () {
				console.log("click")
				if (checkName() && checkOldPass() && checkNewPass() && checkNewPass1() && checkPhone() && checkAge() && checkEmail()) {

					$.ajax({
						type: "POST",
						url: "/KnowledgeLibrary/firm/modifyUserInfo",
						data: {
							u_id: $.session.get("u_id"),
							u_name: $(".u_name").val(),
							u_role: $(".u_role  option:selected").val(),
							u_gender: $(".u_gender").val(),
							u_phone: $(".u_phone").val(),
							u_age: $(".u_age").val(),
							u_mail: $(".u_email").val()
						},
						success: function (res) {
							console.log(res)
							location.href = "user_info.jsp"
						},
						error: function (res) {
							console.log(res)
						}
					})
				}
			})

			$(".icon1").css({ "color": "green" });
			$(".icon2").css({ "color": "green" });
			$(".icon3").css({ "color": "green" });
			$(".icon4").css({ "color": "green" });
			$(".icon5").css({ "color": "green" });
			$(".icon6").css({ "color": "green" });
			//$(".icon7").css({"color":"green"});

			$(".u_name").on("blur", function () {
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
			$(".u_phone").on("blur", function () {
				checkPhone()
			});
			$(".u_age").on("blur", function () {
				checkAge()
			});
			$(".u_mail").on("blur", function () {
				checkEmail()
			});
		})
		function checkName() {
			if (($(".u_name").val() == "")) {
				//console.log("empty")
				$(".icon1").removeClass("icon-tongguo").addClass("icon-jujue").css({ "color": "red" });
				return false;
			} else {
				//console.log("not")
				$(".icon1").removeClass("icon-jujue").addClass("icon-tongguo").css({ "color": "green" });
				return true;
			}
		}
		function checkAge() {
			if (($(".u_age").val() == "")) {
				//console.log("empty")
				$(".icon3").removeClass("icon-tongguo").addClass("icon-jujue").css({ "color": "red" });
				return false;
			} else {
				//console.log("not")
				$(".icon3").removeClass("icon-jujue").addClass("icon-tongguo").css({ "color": "green" });
				return true;
			}
		}
		function checkPhone() {
			var myPho = /^[1][3,4,5,7,8][0-9]{9}$/;
			if (!myPho.test($(".u_phone").val())) {
				$(".icon4").removeClass("icon-tongguo").addClass("icon-jujue").css({ "color": "red" });
				return false;
			} else {
				$(".icon4").removeClass("icon-jujue").addClass("icon-tongguo").css({ "color": "green" });
				return true;
			}
		}


		function checkEmail() {
			var myReg = /^[a-zA-Z0-9_-]+@([a-zA-Z0-9]+\.)+(com|cn|net|org)$/;
			if (!myReg.test($(".u_email").val())) {
				$(".icon5").removeClass("icon-tongguo").addClass("icon-jujue").css({ "color": "red" });
				return false;
			} else {
				$(".icon5").removeClass("icon-jujue").addClass("icon-tongguo").css({ "color": "green" });
				return true;
			}
		}

		function checkOldPass() {
			if ($(".password1").val() == "" || $(".password1").val() != $.session.get("u_pwd")) {
				$(".icon7").removeClass("icon-tongguo").addClass("icon-jujue").css({ "color": "red" });
				return false;
			} else {
				$(".icon7").removeClass("icon-jujue").addClass("icon-tongguo").css({ "color": "green" });
				return true;
			}
		}

		function checkNewPass() {
			if (($(".password1").val() == "")) {
				//console.log("empty")
				$(".icon8").removeClass("icon-tongguo").addClass("icon-jujue").css({ "color": "red" });
				return false;
			} else {
				//console.log("not")
				$(".icon8").removeClass("icon-jujue").addClass("icon-tongguo").css({ "color": "green" });
				return true;
			}
		}

		function checkNewPass1() {
			if ($(".password").val() == "" || $(".password").val() != $(".password1").val()) {
				$(".icon9").removeClass("icon-tongguo").addClass("icon-jujue").css({ "color": "red" });
				return false;
			} else {
				$(".icon9").removeClass("icon-jujue").addClass("icon-tongguo").css({ "color": "green" });
				return true;
			}
		}


	</script>

</body>

</html>