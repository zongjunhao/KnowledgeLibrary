<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>

<head>
	<base href="<%=basePath%>">
	<title>知识审核</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta content="text/html;charset=utf-8" />
	<link rel="stylesheet" type="text/css" href="css/design.css">
	<link rel="stylesheet" href="http://cdn.bootcss.com/bootstrap/3.2.0/css/bootstrap.min.css">
	<script type="text/javascript" src="js/jquery.js"></script>
	<script type="text/javascript" src="js/jquerySession.js"></script>
	<script type="text/javascript" src="lib/js/detect-element-resize.js"></script>

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
			width: 75%;
		}
	</style>
</head>

<body>
	<center>
		<div class="flex_column">
			<div>
				<img id="return" class="icon" src="image/return.png" />
			</div>
			<div class="body">
				<div class="name">知识名称：</div>
				<br>
				<div class="type type1">
					<div>知识类别：</div>
				</div>
				<div class="type" id="author">
					<div>知识作者：小杨</div>
				</div>
				<div class="type">
					<div class="left">
						<span id="click"> 点击量：20</span>
						<span id="collection">收藏量：10</span>
						<span id="download">下载量：10</span>
					</div>
					<div>
						<span>点击收藏:</span>
						<img class="img1" src='./image/收藏1.png'></img>
					</div>
				</div>
			</div>
			<div>
				<iframe style="margin-top: 10px;" class="notify" allowfullscreen></iframe>
			</div>
			<font style="font-size:1.2em; margin-top:1em;">评论区</font>
			<div class="comment1">
			</div>
			<div id="myComment">
				<font style="font-size:1.2em;width:75%;">我的评论</font>
				<div>
					<textarea id="text" style="margin-top: 20px;" class="comment" name="username"
						placeholder="请输入评论内容..." size="25"></textarea>
					<div id="comment" style="color:red;">发布的评论不能为空！</div>
				</div>
			</div>
			<div style="width:75%; margin:1em auto;">
				<button id="down">下载</button>
				<button id="send">发送</button>
			</div>
		</div>
		<script>
			var id = getUrlParam("id");
			console.log(id)
			var name1 = getUrlParam("name1");
			if ($.session.get("role") == "2") {
				$("#myComment").hide();
				$("#send").hide();
			} else {
				$("#myComment").show();
				$("#send").show();
			}

			$(function () {
				$.ajax({
					type: "POST",
					url: "/KnowledgeLibrary/user/viewSpecificKnowledge",
					data: {
						k_id: id,
						u_id: $.session.get("u_id")
					},
					success: function (res) {
						console.log(res)
						$(".name").text("知识名称：" + res.data.knowledge.k_name)//设置知识名称
						$("#click").text("点击量：" + res.data.knowledge.k_click);//设置点击量
						$("#collection").text("收藏量:" + res.data.knowledge.k_collect);//设置收藏量
						$("#download").text("下载量：" + res.data.knowledge.k_download);//设置下载量
						$("#author").text("知识作者：" + res.data.authorName);//设置作者
						$(".notify").attr("src", res.data.knowledge.k_newPath)
						if (res.data.isCollect == 0) {
							$(".img1").attr('src', './image/收藏1.png');
						} else $(".img1").attr('src', './image/收藏2.png');
						var labels = "<div>知识类别：</div>";
						$.each(res.data.labels, function (i, value) {//添加知识类别的标签
							//console.log(value.l_name)
							labels += "<p>" + value.l_name + "</p>";
						});
						$(".type1").html(labels);
						//添加评论
						var comment = "";
						if (res.data.comment.length == 0) {
							$(".comment1").html("<div>当前还没有评论哦~</div>");
						} else {
							$.each(res.data.comment, function (i, value) {
								//console.log(value);
								comment += "<div style='margin:5px 10px;'>" + "<span style='color:blue'>" + value.u_name + ":" + "</span>" + "<span>" + value.com_desc + "</span>" + "</div>";
							})
							$(".comment1").html(comment);
						}
					},
					error: function (res) {
						console.log(res)
					}
				})

			})
			$("#return").click(function () { location.href = getUrlParam("return") + "?id=" + id + "&name1=" + name1 + "&l_id=" + getUrlParam("l_id"); })
			//检查评论区是否为空
			$("#comment").hide();
			$("#send").click(function () {
				if ($("#text").val() == "") {
					$("#comment").text("发布的评论不能为空！");
					$("#comment").show();
				} else {
					$("#comment").hide();
					$.ajax({
						type: "POST",
						url: "/KnowledgeLibrary/user/comment",
						data: {
							u_id: $.session.get("u_id"),
							k_id: id,
							com_msg: $("#text").val()
						},
						success: function (res) {
							$("#comment").hide();
							console.log(res)
							if (res.resultCode == "2017") {
								location.href = "knowledge_detail.jsp?id=" + id + "&return=" + getUrlParam("return");
							} else {
								$("#comment").text(res.resultDesc);
								$("#comment").show();
							}
						},
						error: function (res) {
							console.log(res)
							$("#comment").text("您所请求的页面有异常")
						}
					})

				}
			})

			$(".img1").click(function () {
				console.log($(this).attr('src'))
				var that = this;
				if ($(this).attr('src') == "./image/收藏1.png") {
					$.ajax({
						type: "POST",
						url: "/KnowledgeLibrary/user/collect",
						data: {
							u_id: $.session.get("u_id"),
							k_id: id
						},
						success: function (json) {
							if (json.resultCode == "2025") {
								$(that).attr('src', './image/收藏2.png');
								location.href = "knowledge_detail.jsp?id=" + id + "&return=" + getUrlParam("return");
							} else {
								alert("收藏失败");
							}
						},
						error: function (jqXHR) {
							alert("请求页面错误");
						}
					})
				} else if ($(this).attr('src') == "./image/收藏2.png") {
					var k_id = [$(this).attr('id')];
					$.ajax({
						type: "POST",
						url: "/KnowledgeLibrary/user/deleteCollections",
						dataType: "json",
						traditional: true,
						data: {
							u_id: $.session.get("u_id"),
							k_id: id
						},
						success: function (json) {
							if (json.resultCode == "2009") {
								$(that).attr('src', './image/收藏1.png');
								location.href = "knowledge_detail.jsp?id=" + id + "&return=" + getUrlParam("return");
							} else {
								console.log("取消收藏失败");
							}
						},
						error: function (jqXHR) {
							console.log("请求页面错误");
						}
					})
				}
			})

			$("#down").click(function () {
				$.ajax({
					type: "post",
					url: "/KnowledgeLibrary/user/downloadKnowledge",
					dataType: "json",
					traditional: true,
					data: {
						k_ids: [id]
					},
					success: function (res) {
						$.each(res.data, function (i, value) {
							download(value.fileName, value.filePath)
						})
					},
					error: function (res) {
						console.log(res)
					}

				})
			})
			function download(name, href) {
				var a = document.createElement("a"), //创建a标签
					e = document.createEvent("MouseEvents"); //创建鼠标事件对象
				e.initEvent("click", false, false); //初始化事件对象
				a.href = href; //设置下载地址
				a.download = name; //设置下载文件名
				a.addEventListener('click', function (res) {
					console.log("-------a--------")
					console.log(res)
				}, false);
				a.addEventListener('request', function (res) {
					console.log("-------b--------")
					console.log(res)
				}, false);
				a.addEventListener('get', function (res) {
					console.log("-------c--------")
					console.log(res)
				}, false);
				//         e.addEventListener('click',function(res){
				//         	console.log("------e---------")
				//         	console.log(res)
				//          },false);   
				a.dispatchEvent(e); //给指定的元素，执行事件click事件 

			}

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
		</script>
	</center>
</body>

</html>