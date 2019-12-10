<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>

<head>
	<base href="<%=basePath%>">
	<title>企业添加用户</title>
	<script type="text/javascript" src="js/jquery.js"></script>
	<script type="text/javascript" src="js/jquerySession.js"></script>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta content=”text/html;charset=utf-8″ />

	<link rel="stylesheet" type="text/css" href="css/design.css">
	<style>
		img {
			height: 60px;
			width: 60px;
			margin-left: 30px;
			margin-top: 20px;
		}

		tr td {
			border: none;
		}

		.td {
			width: 60px;
		}

		input {
			width: 270px;
			font-size: 1.2em;
			padding: 10px;
		}

		input:disabled {
			background-color: white;
		}

		select:disabled {
			background-color: white;
		}

		.content {
			width: 60%;
			margin: auto;

		}

		.row {
			width: 450px;
			margin: 1em auto;
		}

		.select {
			width: 270px;
			font-size: 1.2em;
			padding: 10px;
			border: solid 1px #ccc;
			-webkit-appearance: none;
			/*for chrome*/

		}

		.select_user {
			width: 95%;
			font-size: 16px;
			border: 1px solid;
			background-color: white;
			margin: 0;
		}

		.com_list_title {
			margin-top: 0px;
		}
	</style>

<body>
	<img id="return" alt="返回" src="./image/返回.png">
	<center>
		<div class="com_list_title">
			添加用户
		</div>
		<table border="2" bgcolor="white" cellpadding="5" cellspacing="10">
			<tr>
				<td class="td">姓名</td>
				<td>
					<input id="input1" type="text" value="">
				</td>
				<td id="item1" style="color:red;width:155px;">
					用户名不能为空！
				</td>
			</tr>
			<tr>
				<td class="td">性别</td>
				<td>
					<select id="input2" class="select">
						<option value="">男</option>
						<option value="">女</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="td">电话</td>
				<td>
					<input id="input3" type="text" value="">
				</td>
				<td id="item3" style="color:red;width:100px;">
					请填入正确的电话！
				</td>
			</tr>
			<tr>
				<td class="td">权限</td>
				<td>
					<select id="input4" class="select">
						<option value="1">普通员工</option>
						<option value="2">用户管理员</option>
						<option value="3">知识管理员</option>
						<option value="4">超级管理员</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="td">年龄</td>
				<td>
					<input id="input5" type="text" value="">
				</td>
				<td id="item5" style="color:red;width:100px;">
					年龄不能为空！
				</td>
			</tr>
			<tr>
				<td class="td">邮箱</td>
				<td>
					<input id="input6" type="text" value="">
				</td>
				<td id="item6" style="color:red;width:100px;">
					请填入正确的邮箱！
				</td>
			</tr>
		</table>
		<div id="test3" style="color: red; margin-top:20px;"></div>
		<div class="row" style="width:550px;">
			<button id="add" class="modify">添加</button>
			<!-- 		  <input id="add" class="modify" style="margin-bottom:20px;" type="button" value="添加" > -->
		</div>

	</center>
</body>
<script>
	$("#item1").hide();
	$("#item3").hide();
	$("#item5").hide();
	$("#item6").hide();

	$("#input1").on("blur", function () {
		checkName()
	});
	function checkName() {
		if (($("#input1").val() == "")) {
			$("#item1").show();
		} else {
			$("#item1").hide();
		}
	}
	var myReg1 = /^[1][3,4,5,7,8][0-9]{9}$/;
	$("#input3").on("blur", function () {
		checkPhon()
	});

	function checkPhon() {
		if (myReg1.test($("#input3").val())) {
			$("#item3").hide();
		} else {
			$("#item3").show();
		}
	}
	$("#input5").on("blur", function () {
		checkAge()
	});
	function checkAge() {
		if (($("#input5").val() == "")) {
			$("#item5").show();
		} else {
			$("#item5").hide();
		}
	}

	var myReg = /^[a-zA-Z0-9_-]+@([a-zA-Z0-9]+\.)+(com|cn|net|org)$/;
	$("#input6").on("blur", function () {
		checkEmail()
	});

	function checkEmail() {
		if (myReg.test($("#input6").val())) {
			$("#item6").hide();
		} else {
			$("#item6").show();
		}
	}

	$("#add").click(function () {
		checkPhon();
		checkAge();
		checkEmail();
		if (($('#input1').val() != '') && ($('#input3').val() != '') &&
			($('#input5').val() != '') && ($('#input6').val() != '')) {
			$.ajax({
				type: "POST",
				url: "/KnowledgeLibrary/firm/addUser",
				data: {
					u_name: $("#input1").val(),
					u_gender: $("#input2 option:selected").text(),
					u_phone: $("#input3").val(),
					u_role: $("#input4 option:selected").val(),
					u_age: $("#input5").val(),
					u_mail: $("#input6").val(),
					u_firm: $.session.get("f_id")
				},
				success: function (json) {
					if (json.resultCode == "2012") {
						//添加成功
						$("#test3").text(json.resultDesc);
						window.location.href = "userlist.jsp";

					} else {
						//添加失败
						$("#test3").text(json.resultDesc);
						// 							window.location.href = "userlist.jsp";
					}
				},
				error: function (jqXHR) {
					$("#test3").text("您所请求的页面有异常");
					window.location.href = "userlist.jsp";
				}
			});
		}

	});

	$("#return").click(function () { location.href = "userlist.jsp" })
</script>

</html>