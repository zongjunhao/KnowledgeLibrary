<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%-- <%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%> --%>
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
 
  <body>
  <div id="page-inner"> 
		<div class="row">
			<div class="col-md-12">
				<div class="panel-default">
					<div class="panel-heading">
						公司列表
					</div>
					<div class="panel-body">
						<div class="table-responsive">
							
							<table class="table table-striped table-bordered table-hover" id="dataTables-example">
								<thead>
									<tr>
										<th>ID</th>
										<th>公司名称</th>
									</tr>
								</thead>
								<tbody>
									
								</tbody>
							</table>
						</div>

					</div>
				</div>
				<!--End Advanced Tables -->
			</div>
		</div>
	</div>

  </body>
  <script>
  var table=$('#dataTables-example').dataTable();
  table.fnDestroy()
  $.ajax({
		type:"POST",
		url:"/KnowledgeLibrary/sysAdmin/searchFirmsByAuditState",
		data:{
			audit_state : 2
		},
		success:function(res){
			console.log(res);
//			$("#dataTables-example").html("<thead><tr><td width='40px'>ID</td><td width='400px'>公司名称</td></tr></thead>");
			if(res.resultCode=="2006"){
				//查找成功
				var table1="";
				var state;
				var href;
					$.each(res.data, function(i,value) {
						console.log(value)
						state=(value.f_state=="1"?"未审核":(value.f_state=="2"?"审核通过":"审核未通过"));
						table1+="<tr>"+
					    "<td>"+(i+1)+"</td>"+
					    "<td class='company' id="+value.f_id+">"+value.f_name+"</td>"+"</tr>"
"</tr>";
				      });
					$(".table tbody").empty();
					$("#dataTables-example").append(table1);
					$("#test3").text(" ");
					
				$(".company").click(function(){
					if($("#com option:selected").val()=="1"){
						href="admin_com_detail.jsp?f_id="+$(this).attr('id')+"&checkCom=yes"+"&return=admin_mainpage.jsp";
					}else {
						href="admin_com_detail.jsp?f_id="+$(this).attr('id')+"&return=admin_mainpage.jsp";
					}
					console.log(href)
					location.href=href;
				});
			} else {
				//查找失败，没有该条记录	
				//$(".comList").empty();
			}
			$("#dataTables-example").dataTable();
		},
		error:function(res){
			alert("请求的页面有错误");
		}
	});
  
  $(document).ready(function () {
		//加载table插件
		//监听子页面大小变化，设置父页面iframe的大小
		//setHeight()
	  	if($(document.body).height()<355){
			window.parent.document.getElementById("myiframe").height = 355
		}else{
			window.parent.document.getElementById("myiframe").height=$(document.body).height();
		}
		//window.parent.document.getElementById("myiframe").height=$(document.body).height();
		console.log("setHeight")
		addResizeListener(document.getElementsByTagName("body")[0],function(){
			if($(document.body).height()<355){
				window.parent.document.getElementById("myiframe").height = 355
			}else{
				window.parent.document.getElementById("myiframe").height=$(document.body).height();
			}
		});
	});
  
  
  
  
	
  </script>
</html>