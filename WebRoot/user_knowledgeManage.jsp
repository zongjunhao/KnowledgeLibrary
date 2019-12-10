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
</head>

<body style="overflow-x: hidden">
	<div id="page-inner">
		<div class="row">
			<div class="col-md-12">
				<div class="panel-default">
					<div class="panel-heading">
						审核知识
					</div>
					<div class="panel-body">
						<div class="query-div" id="toolbar">
							<form class="form-inline" role="form" id="query_form">
								<div class="form-group query-form-group">
									<label for="status">知识状态</label>
									<select class="select form-control">
										<option value="1">未审核</option>
										<option value="2">审核通过</option>
										<option value="3">审核未通过</option>
										<option value="4">更新未审核</option>
									</select>
								</div>
								<div class="form-group query-form-group">
									<button id="search" type="button" class="btn btn-default search"
										id="search">查询</button>
								</div>
							</form>
						</div>
						<!-- 							<div class="col-md-4"> -->
						<!-- 								<button id="search" class=" btn btn-default text-right">查看</button> -->
						<!-- 							</div> -->
						<!-- 						</div> -->
						<div class="">
							<table class="table table-striped table-bordered table-hover" id="dataTables-example">
								<thead>
									<tr>
										<th></th>
										<th>ID</th>
										<th>用户名称</th>
										<th>权限</th>
									</tr>
								</thead>
								<tbody>
								</tbody>
							</table>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<button id="update" class=" btn btn-default text-right" style="float: left;">上传</button>
								<button id="delete" class=" btn btn-default text-right"
									style="float: right;">删除</button>
							</div>
						</div>
					</div>

				</div>
				<!--End Advanced Tables -->
			</div>
		</div>
	</div>
</body>
<script>
	var f_id = ($.session.get("role") == 2 ? $.session.get("f_id") : $.session.get("u_firm"));
	var table = $('#dataTables-example').dataTable();//加载table插件
	$("body").keydown(function () {
		if (event.keyCode == "13") {//keyCode=13是回车键
			$('.search').click();
		}
	});
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
	$("#update").click(function () { location.href = "user_updateKnowledge.html?return=user_knowledgeManage.jsp" })
	$(function () {

		manage()

	})


	$("#search").click(function () {
		//var table= $('#dataTables-example').dataTable()
		//table.fnDestroy()
		manage()
	})
	function manage() {
		console.log(f_id)
		table.fnDestroy()
		$.ajax({
			type: "post",
			url: "/KnowledgeLibrary/user/viewKnowledgesByState",
			data: {
				f_id: f_id,
				k_state: $(".select option:selected").val(),
			},
			success: function (res) {
				console.log(res)
				$(".table tbody").empty()
				if (res.resultCode == "2006") {//查找成功
					var table = "";
					var state;
					var tableLength = res.data.length;
					$.each(res.data, function (i, value) {
						state = (value.k_state == "1" ? "未审核" : (value.k_state == "2" ? "审核通过" : (value.k_state == "3" ? "审核未通过" : "更新未审核")));
						table += "<tr><td><input type='checkbox' name='check' id='" + value.k_id + "' /></td>" +
							"<td>" + (i + 1) + "</td>" +
							"<td class='knowledge' id=" + value.k_id + ">" + value.k_name + "</td>" +
							"<td>" + state + "</td></tr>";
					})
					$("table tbody").append(table);

					$(".knowledge").click(function () {
						console.log("select", $(".select option:selected").val())
						location.href = "user_checkKnowledge.jsp?id=" + $(this).attr("id") + "&state=" + $(".select option:selected").val();
					})
				} else {//查找失败
					console.log(res)
				}
				console.log("table loading")
				$('#dataTables-example').dataTable();
			},
			error: function (res) {
				console.log(res)
			}
		})
	}

	$("#delete").click(function () {
		if (confirm("确认删除吗？", "删除提示")) {
			var k_id = ""
			var length = $("input:checkbox[name='check']:checked").length
			if (length != 0) {
				k_id = "[";
				$("input:checkbox[name='check']:checked").each(function (i, index) {
					//操作
					if (i < length - 1) {
						k_id += $(this).attr("id") + ","
					} else {
						k_id += $(this).attr("id") + "]"
					}
				});
				$.ajax({
					type: "post",
					url: "/KnowledgeLibrary/user/deleteKnowledges",
					dataType: "json",
					traditional: true,
					data: {
						k_id: $.parseJSON(k_id)
					},
					success: function (res) {
						console.log(res)
						location.href = "user_knowledgeManage.jsp"
					},
					error: function (res) {
						console.log(res)
					}
				})
			}
		}
	})

</script>

</html>