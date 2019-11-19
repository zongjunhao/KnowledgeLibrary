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
						标签列表
					</div>
					<div class="panel-body">
						<div>
							<table class="table table-striped table-bordered table-hover" id="dataTables-example">
								<thead>
									<tr>
										<th></th>
										<th>ID</th>
										<th>类别名称</th>
										<th>修改</th>
									</tr>
								</thead>
								<tbody>
									
								</tbody>
							</table>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<button id="add" class=" btn btn-default text-right" style="float: left;">添加</button>
								<button id="delete" class=" btn btn-default text-right" style="float: right;">删除</button>
							</div>
						</div>

					</div>
					
				</div>
				<!--End Advanced Tables -->
			</div>
		</div>
	</div>

		<!-- <div class="bottom">
		    <button id="add" class="left">添加</button>
		    <button id="delete" class="right">删除</button>	
		</div> -->

  </body>
  <script>
  var table = $('#dataTables-example').dataTable();//加载table插件
 	$(document).ready(function () {
 		$("#dataTables-example").dataTable();  
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
 	})
 	$(function(){
 		table.fnDestroy()
 		$.ajax({
 	    	type:"POST",
 	    	url:"/KnowledgeLibrary/user/viewLabels",
 	    	data:{
 	    		f_id:$.session.get("u_firm")
 	    	},
 	    	success:function(res){
//  	    		$("#labels").html("<thead><tr><td width='50px'></td><td width='50px'>ID</td><td width='300px'>类别名称</td><td width='70px'>修改</td></tr></thead>")
 	    		console.log(res)
 	    		//$(".table tbody").empty()
 	    		if(res.resultCode=="2006"){
 	    			var table2="";
 	 	    		tableID=res.data.length;
 	 	    		var tableLength=res.data.length;
 	 	    		//console.log(tableID)
 	 	    		$.each(res.data,function(i,value){
 	 	    			//console.log(value.l_name)
 	 	    			table2+="<tr><td><input type='checkbox' name='check' id='"+value.l_id+"' /></td>"+
 	 	    			"<td>"+(i+1)+"</td>"+
 	 	    			"<td>"+value.l_name+"</td>"+
 	 	    			"<td class='update' id='"+value.l_id+"'>修改</td></td>";
 	 	    		})
 	 	    		//console.log(table)
 	 	    		$(".table tbody").append(table2);
 	 	    		
 	 	    		$(".update").click(function(){
 	 	    			if($(this).text()=="修改"){
 	 	    				$("#delete").attr("disabled",true)
 	 	    				$("#add").attr("disabled",true)
 	 	    				var label=$(this).parent().children("td").eq(2)
 	 	 	    			var labelName=label.text()
 	 	 	    			label.html("<input class='labelName  form-control' type='text'/>")
 	 	 	    			$(".labelName").val(labelName)
 	 	 	    			//$(".labelName").css("color","#d60fec")
  	 	 	    			//$(".labelName").css("font-weight","bold")
 	 	 	    			$(this).text("提交")
 	 	    			}else{
 	 	    				
 	 	    				console.log("flag1")
 	 	    				if($(".labelName").val()!=""){
 	 	    					table.fnDestroy()
 	 	    					$.ajax({
 	 	    						type:"post",
 	 	    						url:"/KnowledgeLibrary/user/modifyLabel",
 	 	    						data:{
 	 	    							l_id:$(this).attr("id"),
 	 	    							newTagName:$(".labelName").val()
 	 	    						},
 	 	    						success:function(res){
 	 	    							if(res.resultCode=="2039"){
 	 	    								location.href="user_labelManage.jsp"
 	 	    							}else{
 	 	    								$("#result").text(res.resultDesc)
 	 	    							}
 	 	    						}
 	 	    					})
 	 	    				}
 	 	    				
 	 	    			}
 	 	    			$("#dataTables-example").dataTable();
 	 	    			
 	 	    		})
 	    		}
 	    		$("#dataTables-example").dataTable();
 	    		
 	    	},
 	    	error:function(res){
 	    		console.log(res)
 	    	}
 	    })
 	})
    
    
    $("#add").click(function(){
    	
    	var table1;
    	table1="<tr><td><input type='checkbox' name='check' /></td>"+
			"<td>"+(++tableID)+"</td>"+
			"<td><input class='labelName form-control' type='text'   placeholder='请输入添加的类别名称...'/></td>"+
			"<td class='addlabel'>提交</td></td>"
		//$("#labels").append(table1)
		$(".table tbody").append(table1);
		
    	$(this).attr("disabled",true)
    	$("#delete").attr("disabled",true)
    	$(".addlabel").click(function(){
    		console.log("addLabel")
    		console.log($(".labelName").val())
    		const addLabelName = $(".labelName").val()
    	if($(".labelName").val()!=""){
    		table.fnDestroy()
    		$.ajax({
    			type:"post",
    			url:"/KnowledgeLibrary/user/addLabel",
    			data:{
    				l_f_id:$.session.get("u_firm"),
    				tag:addLabelName
    			},
    			success:function(res){
    				console.log(res)
    				if(res.resultCode=="2032"){
    					location.href="user_labelManage.jsp"
    				}else{
//     					$("#result").text(res.resultDesc)
    				}
    			},
    			error:function(res){
    				console.log(res)
    			}
    		})
    		$("#dataTables-example").dataTable();
    	}
    	
    })
    })
    
    
    $("#delete").click(function(){
    	var l_id=""
 	 		var length=$("input:checkbox[name='check']:checked").length
 	 		if(length!=0){
 	 			if(confirm("确认删除吗？","删除提示")){
 	 			l_id="[";
 	 			$("input:checkbox[name='check']:checked").each(function(i,index){
 	 				//操作
 	 				if(i<length-1){
 	 					l_id+=$(this).attr("id")+","
 	 				} else {
 	 					l_id+=$(this).attr("id")+"]"
 	 				}
 	 			});
 	 			console.log(l_id)
 	 			$.ajax({
 	 				type:"post",
 	 				url:"/KnowledgeLibrary/user/deleteLabel",
 	 				dataType:"json",
 	 				traditional:true,
 	 				data:{
 	 					l_id:$.parseJSON(l_id)
 	 				},
 	 				success:function(res){
 	 					console.log(res)
 	 					if(res.resultCode=="2035"){
 	 						location.href="user_labelManage.jsp"
 	 					}else{
//  	 						$("#result").text(res.resultDesc)
 	 					}
 	 					$("#dataTables-example").dataTable();
 	 				},
 	 				error:function(res){
 	 					console.log(res)
 	 				}
 	 			})
 	 		}
 	 		}
    })
  	</script>
</html>