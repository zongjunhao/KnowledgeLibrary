<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>

<head>
	<title>知识主页</title>
	<meta charset="utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<!-- 添加bootstrap的css样式表 -->
	<link rel="stylesheet" type="text/css" href="lib/css/bootstrap.css">
	<link rel="stylesheet" type="text/css" href="lib/dataTables/dataTables.bootstrap.css">
	<!-- 添加JQ -->
	<script type="text/javascript" src="lib/jq/jquery-3.4.1.js"></script>
	<!-- 添加bootstrap的库 -->
	<script type="text/javascript" src="lib/js/bootstrap.js"></script>
	<!-- 	监听页面窗口大小改变的插件 -->
	<script type="text/javascript" src="lib/js/detect-element-resize.js"></script>
	<script type="text/javascript" src="lib/dataTables/jquery.dataTables.js"></script>
	<script type="text/javascript" src="lib/dataTables/dataTables.bootstrap.js"></script>
	<script type="text/javascript" src="js/jquerySession.js"></script>
</head>
<style>
	body {
		overflow-x: hidden;
	}

	.com_input {
		border: 1px solid #ccc;
		padding: 7px 0px;
		border-radius: 5px;
		padding-left: 5px;
		box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
		transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
		height: 36px;
		width: 300px;
	}

	.flex_row {
		display: flex;
		flex-direction: row;
		justify-content: space-around;
		width: 480px;
		margin: 0px;
	}

	img {
		height: 22px;
		width: 22px;
	}

	.table-responsive {
		overflow-x: hidden;
	}
</style>

<body>
	<div id="page-inner">
		<div class="row">
			<div class="col-md-12">
				<div class="panel-default">
					<div class="panel-heading">
						知识类别管理
					</div>
					<div class="panel-body">
						<div class="table-responsive">
							<div class="query-div" id="toolbar">
								<div class="form-inline" role="form" id="query_form">
									<div class="form-group query-form-group">
										<div class="flex_row">
											<div>
												<input class="com_input" type="text" placeholder="请输入知识的名称..." size="25"
													maxlength="20">
											</div>
											<select class="form-control select_user" id="com">
												<option value="k_click">点击量</option>
												<option value="k_collect">收藏量</option>
												<option value="k_download">下载量</option>
											</select>
											<div class="form-group query-form-group search">
												<button type="button" class="btn btn-default search"
													id="with_query">查询</button>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="row" style="padding-top:20px">
								<div class="col-md-10">
									<div id="table">
										<div class="panel panel-default">
											<div class="panel-body">
												请输入搜索内容~
											</div>
										</div>

									</div>
								</div>
								<div class="col-md-2">
									<div id="label">

									</div>
								</div>
							</div>

						</div>
					</div>
				</div>
				<!-- 				End Advanced Tables -->
			</div>
		</div>
	</div>

</body>
<script>

	$(document).ready(function () {
		//监听子页面大小变化，设置父页面iframe的大小
		// if($(document.body).height()<355){
		// 	window.parent.document.getElementById("myiframe").height = 355
		// }else{
		// 	window.parent.document.getElementById("myiframe").height=$(document.body).height();
		// }
		// //window.parent.document.getElementById("myiframe").height=$(document.body).height();
		// console.log("setHeight")
		// addResizeListener(document.getElementsByTagName("body")[0],function(){
		// 	if($(document.body).height()<355){
		// 		window.parent.document.getElementById("myiframe").height = 355
		// 	}else{
		// 		window.parent.document.getElementById("myiframe").height=$(document.body).height();
		// 	}
		// });
		search()
		//搜索知识
		$("body").keydown(function () {
			if (event.keyCode == "13") {//keyCode=13是回车键
				$('#with_query').click();
			}
		});
		$(".search").click(function () {
			search()
			//location.href="knowledge_searchAll.jsp?search_msg="+$(".com_input").val()+"&order="+$(".select_user option:selected").val();
		})

		var f_id = ($.session.get("role") == 1 ? $.session.get("f_id") : $.session.get("u_firm"));
		$.ajax({
			type: "POST",
			url: "/KnowledgeLibrary/user/viewLabels",
			data: {
				f_id: f_id
			},
			success: function (res) {
				if (res.resultCode == "2006") {//查询成功
					var label = "<ul class='list-group'>";
					$.each(res.data, function (i, value) {//<ul class="list-group">
						label += "<li class='list-group-item know_table' id=" + value.l_id + " name1=" + value.l_name +
							">" + value.l_name + "</li>"
					})
					label += "</ul>"
					//console.log(label)
					$("#label").append(label)
					$(".know_table").click(function () {
						console.log($(this).attr("name1"));
						location.href = "knowledge_page.jsp?l_id=" + $(this).attr("id") + "&name1=" + $(this).attr("name1");
					})
				} else {
					//查询失败
					console.log(res)
					$("#label").append("<div>当前还没有知识类别哦~</div>")
				}
			},
			error: function (res) {
				console.log(res)
			}
		})


		//$("#knowledge").click(function(){location.href="knowledge_page.jsp"})

	});

	function search() {
		$.ajax({
			type: "POST",
			url: "/KnowledgeLibrary/user/searchKnowledges",
			data: {
				search_msg: $(".com_input").val(),
				f_id: $.session.get("u_firm"),
				order: $(".select_user option:selected").val(),
				u_id: $.session.get("u_id")
			},
			success: function (res) {
				console.log(res)
				if (res.resultCode == "2006") {//查找成功
					$("#table").empty();
					var table1 = "";
					var src = "./image/收藏1.png"
					$.each(res.data, function (i, value) {
						console.log("res", i, value, value.knowledge)
						if (value.isCollect == "1") {
							src = "./image/收藏2.png"
						} else {
							src = "./image/收藏1.png"
						}
						if (value.knowledge != null) {
							table1 += "<div class='panel panel-default' name1=" + value.l_name +
								"><div class='panel-body '><p class='knowledge'id=" + value.knowledge.k_id + ">" + value.k_name + "</p>";
							if (value.k_text != null)
								table1 += "<p id='" + value.knowledge.k_id + "'>内容：" + value.k_text + "</p>";
							table1 += "<p>" + "<span>点击量：" + value.knowledge.k_click + "&nbsp&nbsp&nbsp</span>" +
								"<span>收藏量：" + value.knowledge.k_collect + "&nbsp&nbsp&nbsp</span>" +
								"<span>下载量：" + value.knowledge.k_download + "&nbsp&nbsp&nbsp</span>" +
								"</p><p>收藏：<img class='img1' src='" + src + "' id=" + value.knowledge.k_id + "></img></p></div></div>";
						}
					});
					$("#table").append(table1);
					$(".img1").click(function () {
						console.log($(this).attr('src'))
						var that = this;
						if ($(this).attr('src') == "./image/收藏1.png") {

							$.ajax({
								type: "POST",
								url: "/KnowledgeLibrary/user/collect",
								data: {
									u_id: $.session.get("u_id"),
									k_id: $(this).attr('id')
								},
								success: function (json) {
									if (json.resultCode == "2025") {
										$(that).attr('src', './image/收藏2.png');
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
									k_id: k_id
								},
								success: function (json) {
									if (json.resultCode == "2009") {
										$(that).attr('src', './image/收藏1.png');
										console.log("取消收藏")
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

					$(".knowledge").click(function () {
						console.log("k_id", $(this).attr("id"))
						location.href = "knowledge_detail.jsp?id=" + $(this).attr('id') + "&return=knowledge_mainpage.jsp";
					});
					//isShow();
				} else {//查找失败
					$("#table").empty().append("<div class='panel panel-default'><div class='panel-body'>没有匹配数据~</div></div>")//isShow();
				}
			},
			error: function (res) {
				console.log(res)
			}
		})
	}



</script>

</html>