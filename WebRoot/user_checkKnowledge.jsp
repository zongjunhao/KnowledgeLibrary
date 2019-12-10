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
	<link rel="stylesheet" type="text/css" href="lib/dataTables/dataTables.bootstrap.css">
	<!-- 添加JQ -->
	<script type="text/javascript" src="lib/jq/jquery-3.4.1.js"></script>
	<script type="text/javascript" src="js/jquerySession.js"></script>
	<!-- 添加bootstrap的库 -->
	<script type="text/javascript" src="lib/js/bootstrap.js"></script>
	<!-- 	监听页面窗口大小改变的插件 -->
	<script type="text/javascript" src="lib/js/detect-element-resize.js"></script>
	<script type="text/javascript" src="lib/dataTables/jquery.dataTables.js"></script>
	<script type="text/javascript" src="lib/dataTables/dataTables.bootstrap.js"></script>
	<link rel="stylesheet" type="text/css" href="css/design.css">
	<link rel="stylesheet" href="http://cdn.bootcss.com/bootstrap/3.2.0/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="css/design.css">
	<style>
		.title {
			font-size: 1.5em;
			text-align: center;
			font-family: Microsoft YaHei;
			margin-bottom: 1em;
		}

		.body {
			width: 75%;
			margin: 0 auto;
		}

		.name {
			font-size: 1.2em;
			float: left;
			display: block;
		}

		.name input {
			font-size: 1.2em;
			border: 1px solid #ccc;
			border-radius: 5px;
			box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
			transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
		}

		input:focus {
			border: none;
			box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075), 0 0 8px rgba(102, 175, 233, .6);
		}

		.type {
			display: flex;
			font-size: 1.2em;
			margin: 1em 0;
		}

		.type p {
			margin: auto 0.3em;
		}

		.content {
			font-size: 1.2em;
		}

		.content div {
			width: 100%;
			height: 200px;
			margin: 0.5em 0;
			color: grey;
			border: 1px solid #ccc;
			border-radius: 5px;
			box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
			transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
		}

		.left span {
			display: inline-block;
			margin-right: 1.5em;
		}

		img {
			height: 22px;
			width: 22px;
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
			margin: 5px;
			margin-bottom: 12px;
		}

		button:focus {
			border: none;
			box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075), 0 0 8px rgba(102, 175, 233, .6);
		}

		#down {
			float: left;
		}

		.comment1 {
			margin: 20px auto;
			text-align: left;
			border: solid 1px #ccc;
			width: 75%;
			border-radius: 5px;
		}

		.notify {
			border: 1px solid #ccc;
			padding: 7px 0px;
			border-radius: 5px;
			padding-left: 5px;
			box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
			transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
			height: 600px;
			width: 100%;
		}
	</style>
</head>

<body>
	<div class="flex_column">
		<div>
			<img id="return" class="icon" src="image/return.png" />
		</div>
		<div class="title">知识审核</div>
		<div class="body">
			<div class="name">知识名称： </div>
			<br>
			<div class="type type1">
				<div>知识类别：</div>
			</div>
			<div class="type" id="author">
				<div>知识作者：</div>
			</div>
			<div class="type">知识内容:
			</div>
			<div>
				<iframe class="notify" style="margin-top: 10px;" allowfullscreen></iframe>
			</div>

			<div class="bottom">
				<button id="unpass">不通过</button>
				<button id="pass">通过</button>
			</div>
		</div>
	</div>

</body>
<script>
	// $(document).ready(function () {
	// 	//监听子页面大小变化，设置父页面iframe的大小
	// 	if($(document.body).height()<355){
	// 		window.parent.document.getElementById("myiframe").height = 355
	// 	}else{
	// 		window.parent.document.getElementById("myiframe").height=$(document.body).height();
	// 	}
	// 	//window.parent.document.getElementById("myiframe").height=$(document.body).height();
	// 	console.log("setHeight")
	// 	addResizeListener(document.getElementsByTagName("body")[0],function(){
	// 		if($(document.body).height()<355){
	// 			window.parent.document.getElementById("myiframe").height = 355
	// 		}else{
	// 			window.parent.document.getElementById("myiframe").height=$(document.body).height();
	// 		}
	// 	});
	// });
	var id = getUrlParam("id");
	console.log("state", getUrlParam("state"))
	if (getUrlParam("state") == "1" || getUrlParam("state") == "4") {
		$(".bottom").show();
	} else {
		$(".bottom").hide();
	}
	$(function () {
		$.ajax({
			type: "POST",
			url: "/KnowledgeLibrary/user/viewSpecificKnowledge",
			data: {
				k_id: id
			},
			success: function (res) {
				//console.log(res)
				$(".name").text("知识名称：" + res.data.knowledge.k_name)//设置知识名称
				$(".notify").attr("src", res.data.knowledge.k_newPath)
				$("#author").text("知识作者：" + res.data.authorName)
				var labels = "<div>知识类别：</div>";
				$.each(res.data.labels, function (i, value) {//添加知识类别的标签
					//console.log(value.l_name)
					labels += "<p>" + value.l_name + "</p>";
				});
				$(".type1").html(labels)

			},
			error: function (res) {
				console.log(res)
			}
		})

	})
	$(".bottom button").click(function () {
		//console.log($(this).text())
		var state = ($(this).text() == "通过" ? 2 : 3)
		//console.log(state)
		$.ajax({
			type: "post",
			url: "/KnowledgeLibrary/user/modifyKnowledgeState",
			data: {
				k_id: id,
				k_state: state
			},
			success: function (res) {
				console.log(res)
				location.href = "user_knowledgeManage.jsp?state=" + state;
			},
			error: function (res) {
				console.log(res)
			}

		})
	})
	$("#return").click(function () { location.href = "user_knowledgeManage.jsp?state=" + getUrlParam("state"); }) 
</script>

</html>