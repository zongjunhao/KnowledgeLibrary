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
 
  <body>
    <div id="page-inner"> 
		<div class="row">
			<div class="col-md-12">
				<div class="panel-default">
					<div class="panel-heading">
						用户列表
					</div>
					<div class="panel-body">
<!-- 						<div class="row"> -->
<!-- 							<div class="col-md-2"> -->
<!-- 							<select class="select form-control"> -->
<!-- 					    	    <option value="1">--普通用户--</option> -->
<!-- 					    	    <option value="2">--用户管理员--</option>  -->
<!-- 					    	    <option value="3">--知识管理员--</option>  -->
<!-- 					    	    <option value="4">--超级管理员--</option>    -->
<!-- 					    	</select> -->
<!-- 							</div> -->
					
<!-- 							<div class="col-md-4"> -->
<!-- 								<button id="search" class=" btn btn-default text-right">查看</button> -->
<!-- 							</div> -->
<!-- 						</div> -->

						<div class="query-div" id="toolbar">
					            <form class="form-inline" role="form" id="query_form">
					                <div class="form-group query-form-group">
					                    <label for="status">员工角色</label>
					                    <select class="select form-control">
					                    	<option value="1">普通用户</option>
								    	    <option value="2">用户管理员</option> 
								    	    <option value="3">知识管理员</option> 
								    	    <option value="4">超级管理员</option>   
								    	    <option value="5">公司管理员</option>   
										</select>
					                </div>
					                <div class="form-group query-form-group">
					                    <button type="button" class="btn btn-default search" id="search">查询</button>
					                </div>
					            </form>
					        </div>
						<div class="">
							<table class="table table-striped table-bordered table-hover" id="dataTables-example">
								<thead>
									<tr>
										<th>ID</th>
										<th>用户名称</th>
										<th>权限</th>
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
 	<script>
 	$(document).ready(function () {
 		$("body").keydown(function() {
 			if (event.keyCode == "13") {//keyCode=13是回车键
 				$('#search').click();
 			}
 		});
 	 	var f_id=($.session.get("role")==2?$.session.get("f_id"):$.session.get("u_firm"));
 	 	var table = $('#dataTables-example').dataTable();//加载table插件
 	 	var userDetail=$.session.get("role")==6?"user_changeUserInfo.html":"user_info.jsp";
 	 	table.fnDestroy()
 	 	$.ajax({
 	 		type:"POST",
 	 		url:"/KnowledgeLibrary/user/viewAllUsers",
 	 		data:{
 	 			f_id:f_id
 	 		},
 	 		success:function(res){
 	 			if(res.resultCode=="2006"){
 	 				console.log(res)
 	 				//查找成功
 	 				var table="";
 	 				var role;
 	 				var tableLength=res.data.length;
 	 				$.each(res.data, function(i,value) {
 	 					role=(value.u_role==1?"普通用户":(value.u_role==2?"用户管理员":(value.u_role==3?"知识管理员":(value.u_role==4?"超级管理员":"公司管理员"))));
 	 					table+="<tr>"+
 	 				    "<td>"+(i+1)+"</td>"+
 	 				    "<td class='user' id="+value.u_id+">"+value.u_name+"</td>"
 	 				    +"<td>"+role+"</td></tr>";
 	 			      });
 	 				 $(".table tbody").append(table);
 	 				$(".user").click(function(){
 	 					location.href=userDetail+"?id="+$(this).attr('id');
 	 				});  
 	 			} else if(res.resultCode=="2007"){
 	 				//查找失败，没有该条记录	
 	 			}
 	 			 console.log("open dataTable")
 	 	 	 	 $('#dataTables-example').dataTable(); 	 
 	 		},
 	 		error:function(res){
 	 			console.log(res)
 	 		}
 	 	});
 	 	
 	 	
 	 	$("#search").click(function(){
 	 		table.fnDestroy()
 	 		$.ajax({
 	 			type:"post",
 	 			url:"/KnowledgeLibrary/user/searchUserByRole",
 	 			data:{
 	 				search_msg:"",
 	 				f_id:f_id,
 	 				u_role:$(".select option:selected").val()
 	 			},
 	 			success:function(res){
 	 				console.log(res)
 	 				$(".table tbody").empty()
 	 				if(res.resultCode=="2006"){//查找成功
 	 	 				//查找成功
 	 	 				 var table="";
 	 	 				var role;
 	 	 				$.each(res.data, function(i,value) {
 	 	 					role=(value.u_role==1?"普通用户":(value.u_role==2?"用户管理员":(value.u_role==3?"知识管理员":(value.u_role==4?"超级管理员":"公司管理员"))));
 	 	 					table+="<tr>"+
 	 	 				    "<td>"+(i+1)+"</td>"+
 	 	 				    "<td class='user' id="+value.u_id+">"+value.u_name+"</td>"
 	 	 				    +"<td>"+role+"</td></tr>";
 	 	 			      });
 	 	 				$(".table tbody").append(table);
 	 	 				$(".user").click(function(){
 	 	 					location.href=userDetail+"?id="+$(this).attr('id');
 	 	 				}); 
 	 				}else{//查找失败
 		    			console.log(res)
 		    		}
 	 	 			 console.log("restart table")
 	 	 	 	 	$('#dataTables-example').dataTable(); 
 	 				
 	 			},
 	 			error:function(res){
 	 				console.log(res)
 	 			}
 	 		})
 	 		
 	 	});
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
  </body>
</html>