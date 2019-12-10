<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
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
						我的知识
					</div>
					<div class="panel-body">
						<div>

							<table class="table table-striped table-bordered table-hover" id="dataTables-example">
								<thead>
									<tr>
										<th></th>
										<th>ID</th>
										<th>知识名称</th>
										<th>点击量</th>
										<th>收藏量</th>
										<th>下载量</th>
									</tr>
								</thead>
								<tbody>

								</tbody>
							</table>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<button id="down" class=" btn btn-default text-right" style="float: left;">下载</button>
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
	var table = $('#dataTables-example').dataTable();//加载table插件
	//   $(document).ready(function () {
	// 		//加载table插件
	// 		$('#dataTables-example').dataTable();
	// 		//监听子页面大小变化，设置父页面iframe的大小
	// 		//setHeight()
	// 		if($(document.body).height()<355){
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
		collection();
	})


	function collection() {
		table.fnDestroy()
		$.ajax({
			type: "POST",
			url: "/KnowledgeLibrary/user/searchKnowledgesInCollection",
			data: {
				u_id: $.session.get("u_id"),
				search_msg: ""
			},
			success: function (res) {
				//console.log(res)
				//$("#knowledgeList").html("<thead><tr ><td width='50px'></td><td width='50px'>ID</td><td width='400px'>知识名称</td><td width='70px'>点击量</td><td width='70px'>收藏量</td><td width='70px'>下载量</td></tr></thead>")
				if (res.resultCode == "2006") {
					//查找成功
					var table = "";
					var tableLength = res.data.length;
					$.each(res.data, function (i, value) {
						table += "<tr>" +
							"<td><input type='checkbox' name='check' id='" + value.k_id + "' /></td>" +
							"<td>" + (i + 1) + "</td>" +
							"<td class='knowledge' id=" + value.k_id + ">" + value.k_name + "</td>" +
							"<td>" + value.k_click + "</td>" +
							"<td>" + value.k_collect + "</td>" +
							"<td>" + value.k_download + "</td>" + "</tr>";
					});
					$(".table tbody").append(table);
					$(".knowledge").click(function () {
						//console.log($(this).attr("id"))
						location.href = "knowledge_detail.jsp?id=" + $(this).attr('id') + "&return=user_collection.jsp";
					});
				} else if (res.resultCode == "2007") {
					//查找失败，没有该条记录	
				}
				$('#dataTables-example').dataTable();

			},
			error: function (res) {
				console.log(res)
			}
		});
	}

	$("#down").click(function () {
		var k_id = labels();
		if (k_id != "") {
			$.ajax({
				type: "post",
				url: "/KnowledgeLibrary/user/downloadKnowledge",
				dataType: "json",
				traditional: true,
				data: {
					k_ids: $.parseJSON(k_id)
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
		}

	})

	function download(name, href) {
		var a = document.createElement("a"), //创建a标签
			e = document.createEvent("MouseEvents"); //创建鼠标事件对象
		e.initEvent("click", false, false); //初始化事件对象
		a.href = href; //设置下载地址
		a.download = name; //设置下载文件名
		a.dispatchEvent(e); //给指定的元素，执行事件click事件 
	}

	$("#delete").click(function () {
		if (confirm("确认删除吗？", "删除提示")) {
			var k_id = labels();
			if (k_id != "") {
				$.ajax({
					type: "post",
					url: "/KnowledgeLibrary/user/deleteCollections",
					dataType: "json",
					traditional: true,
					data: {
						u_id: $.session.get("u_id"),
						k_id: $.parseJSON(k_id)
					},
					success: function (res) {
						console.log(res)
						location.href = "user_collection.jsp"
					},
					error: function (res) {
						console.log(res)
					}
				})
			}
		}
	})

	function labels() {
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
		}
		return k_id
	}
</script>

</html>