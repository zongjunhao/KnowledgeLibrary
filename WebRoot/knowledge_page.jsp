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
    <title>知识页面</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta content=”text/html;charset=utf-8″ />
	<script type="text/javascript" src = "js/jquery.js"></script>
    <script type="text/javascript" src = "js/jquerySession.js"></script>
    <!-- 添加bootstrap的css样式表 -->
	<link rel="stylesheet" type="text/css" href="lib/css/bootstrap.css">
	<link rel="stylesheet" type="text/css" href="lib/dataTables/dataTables.bootstrap.css">
	<!-- 添加bootstrap的库 -->
	<script type="text/javascript" src="lib/js/bootstrap.js"></script>
	<!-- 	监听页面窗口大小改变的插件 -->
	<script type="text/javascript" src="lib/js/detect-element-resize.js"></script>
	<script type="text/javascript" src="lib/dataTables/jquery.dataTables.js"></script>
	<script type="text/javascript" src="lib/dataTables/dataTables.bootstrap.js"></script>

 </head>
 <style>
 img{
 	height:22px;
 	width:22px;
 }
 </style>
  <body>
	    <div id="page-inner"> 
		<div class="row">
			<div class="col-md-12">
				<div class="panel-default">
					<div class="panel-heading">
						知识列表
					</div>
					<div class="panel-body">
						<div class="query-div" id="toolbar">
					            <form class="form-inline" role="form" id="query_form">
					                <div class="form-group query-form-group">
					                    <label for="status">知识筛选</label>
										<select class="select form-control">
								    	    <option value="k_click">点击量</option>
								    	    <option value="k_collect">收藏量</option>  
								    	    <option value="k_download">下载量</option> 
								    	</select>
									</div>
									<div class="form-group query-form-group">
					                    <button id="search" type="button" class="btn btn-default search" id="search">查询</button>
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
										<th>知识名称</th>
										<th>点击量</th>
										<th>收藏量</th>
										<th>下载量</th>
										<th class="img_td">收藏</th>
									</tr>
								</thead>
								<tbody>
								</tbody>
							</table>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<button  id="down"  class=" btn btn-default text-right" style="float: left;">下载</button>
								
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
 	$("body").keydown(function() {
		if (event.keyCode == "13") {//keyCode=13是回车键
			$('.search').click();
		}
	});
 	//获取label的id
 	var l_id=getUrlParam("l_id");
 	var f_id=($.session.get("role")==2?$.session.get("f_id"):$.session.get("u_firm"));
 	var name1=getUrlParam("name1");
 	var u_id=$.session.get("u_id")
 	function isShow(){
 		console.log($.session.get("role"))
 		if($.session.get("role")=="2"){
 	 		  $(".img_td").hide();
 	 	  } else{
 	 		 $(".img_td").show();
 	 	  }
 	}
 	
 	$(".panel-heading").text("知识类别："+name1);
 	
 	//表格加载
 	$(function(){
 		search()
 	})
 	
 	$(".search").click(function(){
 		search()
 	})
 	
 	var table=$('#dataTables-example').dataTable();
 	
 	function search(){
 		table.fnDestroy()
 		$.ajax({
 			type:"post",
 			url:"/KnowledgeLibrary/user/searchKnowledgesByLabel",
 			data:{
 				search_msg:"",
 				f_id:f_id,
 				order:$(".select_user option:selected").val(),
 				l_id:l_id,
 				u_id:u_id
 			},
 			success:function(res){
 				console.log(res)
 				if(res.resultCode=="2006"){//查找成功
 					var table="";
 				    var src="./image/收藏1.png"
 	 				$.each(res.data, function(i,value) {
 	 					if(value.isCollect=="1"){
 	 						src="./image/收藏2.png"
 	 					}else{
 	 						src="./image/收藏1.png"
 	 					}
 	 					table+="<tr>"+
 	 					"<td><input type='checkbox' name='check' id="+value.knowledge.k_id+" /></td>"+
 	 				    "<td>"+(i+1)+"</td>"+
 	 				    "<td class='knowledge' id="+value.knowledge.k_id+">"+value.knowledge.k_name+"</td>"+
 	 					"<td>"+value.knowledge.k_click+"</td>"+
 	 					"<td>"+value.knowledge.k_collect+"</td>"+
 	 					"<td>"+value.knowledge.k_download+"</td>"+
 	 					"<td class='img_td'><img class='img1' src='"+src+"' id="+value.knowledge.k_id+"></img></td>"+"</tr>";
 	 			      });
 				    $(".table tbody").empty();
 	 				$("#dataTables-example").append(table);
 	 				console.log("表格数据添加");
 	 				isShow();
 	 				$(".img1").click(function(){
 	 					console.log($(this).attr('src'))
 	 					var that=this;
 	 					if($(this).attr('src')=="./image/收藏1.png"){
 	 						$.ajax({
 	 							type : "POST",
 	 							url : "/KnowledgeLibrary/user/collect",
 	 							data : {
 	 								u_id : $.session.get("u_id"),
 	 								k_id : $(this).attr('id')
 	 							},
 	 							success : function(json) {
 	 								if (json.resultCode == "2025"){
 	 									$(that).attr('src','./image/收藏2.png');
 	 									location.href="knowledge_page.jsp?l_id="+l_id+"&name1="+name1;
 	 								}else {
 	 									alert("收藏失败");
 	 								}
 	 							},
 	 							error : function(jqXHR) {
 	 								alert("请求页面错误");
 	 							}
 	 						})		
 	 					}else if($(this).attr('src')=="./image/收藏2.png"){
 	 						var k_id=[$(this).attr('id')];
 	 						$.ajax({
 	 							type : "POST",
 	 							url : "/KnowledgeLibrary/user/deleteCollections",
 	 							dataType: "json",
	 							traditional: true,
 	 							data : {
 	 								u_id : u_id,
 	 								k_id : k_id
 	 							},
 	 							success : function(json) {
 	 								if (json.resultCode == "2009"){
 	 									$(that).attr('src','./image/收藏1.png');
 	 									location.href="knowledge_page.jsp?l_id="+l_id+"&name1="+name1;
 	 								}else {
 	 									console.log("取消收藏失败");
 	 								}
 	 							},
 	 							error : function(jqXHR) {
 	 								console.log("请求页面错误");
 	 							}
 	 						})
 	 					}
 	 				})
 	 				$(".knowledge").click(function(){
 	 					//console.log($(this).attr("id"))
 	 					location.href="knowledge_detail.jsp?id="+$(this).attr('id')+"&name1="+name1+"&return=knowledge_page.jsp&l_id="+l_id;
 	 				});
 	 				
 				} else {//查找失败
 					isShow();
 					console.log("是2007")
 				}
 				$("#dataTables-example").dataTable();
 			},
 			error:function(res){
 				console.log(res)
 			}
 			
 		})
 	
 	}
 	
 	//下载知识
    $("#down").click(function(){
    	var k_id="[";
    	var length=$("input:checkbox[name='check']:checked").length
    	console.log(length)
    	//console.log($("input:checkbox[name='check']:checked"))
    	if(length!=0){
    		//console.log("action!")
    		$("input:checkbox[name='check']:checked").each(function(i,value){
    			if(i<length-1){
    				k_id+=$(this).attr("id")+","
    			}else{
    				k_id+=$(this).attr("id")+"]"
    			}
    		})
    		$.ajax({
        		type:"post",
        		url:"/KnowledgeLibrary/user/downloadKnowledge",
        		dataType:"json",
        		traditional:true,
        		data:{
        			k_ids:$.parseJSON( k_id )
        		},
        		success:function(res){
        			//console.log("action!")
        			console.log(res)
        			$.each(res.data,function(i,value){
        				download(value.fileName,value.filePath)
        			})
        			
        		},
        		error:function(res){
        			console.log("action!")
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
        //alert(href);
        a.download = name; //设置下载文件名
        a.dispatchEvent(e); //给指定的元素，执行事件click事件 
    }
    
    $("#return").click(function(){location.href="knowledge_mainpage.jsp"})
  	</script>

</html>