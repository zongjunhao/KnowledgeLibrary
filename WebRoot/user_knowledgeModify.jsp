<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>知识修改</title>
  <script type="text/javascript" src = "js/jquery.js"></script>
  <script type="text/javascript" src = "js/jquerySession.js"></script> 
  <!-- 	监听页面窗口大小改变的插件 -->
	<script type="text/javascript" src="lib/js/detect-element-resize.js"></script>   
  <style>
  img{
	height:60px;
	width:60px;
	margin-left:30px;
	margin-top:20px;
  }
  
  .title{
    font-size:1.5em;
    text-align:center;
    font-family:Microsoft YaHei;
    margin-bottom:1em;
  }
  .body {
		width: 75%;
		margin: 0 auto;
	}
  
  .name{
    font-size:1.2em;
  }
  .name input:disabled{
/* 	border:1px solid #DDD; */
/* 	background-color:#F5F5F5; */
	background-color:white;
	color:black;
	border:none;
	}
  .name input{
  	margin-left:20px;
    font-size:1.0em;
    border: 1px solid #ccc;
    border-radius: 3px;
	transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
	width:70%;
	height:35px;
  }
  
  input:focus{
    border:none;
    box-shadow: inset 0 1px 1px rgba(0,0,0,.075),0 0 8px rgba(102,175,233,.6);
  }
  
  .type{
    display:flex;
    font-size:1.2em;
    margin:1em 0;
  }
  
  .type p{
    margin:auto 0.3em;
  }
  
  .content{
    font-size:1.2em;
    
  }
  
  .content div{
    width:100%;
    height:200px;
    margin:0.5em 0;
    color:grey;
    border: 1px solid #ccc;
    border-radius: 5px;
	box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
	transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
  }
  
  button{
    float:right;
    padding: 4px;
    width: 70px;
    font-size: 1em;
    border: 1px solid  #ccc;
    height: 40px;
    background-color:white;
    font-family:Microsoft YaHei;
  	border-radius: 5px;
  }
  
  button:focus{
    border:none;
    box-shadow: inset 0 1px 1px rgba(0,0,0,.075),0 0 8px rgba(102,175,233,.6);
  }
  .name1 input{
  	 background-color:white;
  	 font-size:0.8em;
  }
  .notify {
		border: 1px solid #ccc;
		padding: 7px 0px;
		border-radius: 5px;
		padding-left: 5px;
		box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
		transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
		height: 400px;
		width: 100%;
	}
  </style>
</head>
<body>
  <img id="return" alt="返回" src="./image/返回.png">
  <div class="title">知识修改</div>
  <div class="body">
  <div class="name">
    	知识名称:<input class="name1">
  </div> 
      <div id="item1" style="color:red;width:220px;">请输入知识名称！</div>
    <div class="type type1">
      <div class="type2">知识类别：</div>
    </div>
    <table id="label" width="600" height="100" cellpadding="0"  cellspacing="0">
	</table>
	
	    <div>
			<iframe style="margin-top: 10px;" class="notify" ></iframe>
		</div>
		
    <div id="test" style="color: red;margin:1em auto;text-align:center">请至少选择一个标签</div>
    <button id="modify">修改</button>
  </div>
</body>
<script>
$("#test").hide();
window.parent.document.getElementById("myiframe").height = 900
	//标签列表
	$("#label").hide();
	$.ajax({
		type : "POST",
		url : "/KnowledgeLibrary/user/viewLabels",
		data:{
			f_id:$.session.get("u_firm")
		},
		success:function(res){
			//console.log(res)
			if(res.resultCode=="2006"){//查询成功
				var label="";
				$.each(res.data,function(i,value){
					if((i%5)==0){
						label+="<tr><td><input type='checkbox' name='check' id='"+value.l_id+"' /></td><td name="+value.l_id+" name1="+value.l_name+">"+value.l_name+"</td>";
					}else if(((i%5)==4)||(i==(res.data.length-1))){
						label+="<td><input type='checkbox' name='check' id='"+value.l_id+"' /></td><td name="+value.l_id+" name1="+value.l_name+">"+value.l_name+"</td></tr>";
					}else{
						label+="<td><input type='checkbox' name='check' id='"+value.l_id+"' /></td><td name="+value.l_id+" name1="+value.l_name+">"+value.l_name+"</td>";
					}
				})
				//console.log(label)
				$("#label").append(label)
			} else {
				//查询失败
				console.log(res)
				$("#label").append("<tr><td>当前还没有知识类别哦~</td></tr>")
			}
		},
		error:function(res){
			console.log(res)
		}
	});
	
	//传递过来的文件内容
	var id=getUrlParam("id");
	$(function(){
		window.parent.document.getElementById("myiframe").height=900;
 		$.ajax({
 			type:"POST",
 			url:"/KnowledgeLibrary/user/viewSpecificKnowledge",
 			data:{
 				k_id:id,
 				u_id:$.session.get("u_id")
 			},
 			success: function(res){
 				//console.log(res)
 				$(".name1").val(res.data.knowledge.k_name)//设置知识名称
 				$(".notify").attr("src",res.data.knowledge.k_newPath)
 				var labels="<div>知识类别：</div>";
 				$.each(res.data.labels,function(i,value){//添加知识类别的标签
 					//console.log(value.l_name)
 					labels+="<p>"+value.l_name+"</p>";
 				});
 				$(".type1").html(labels);
 				
 			},
 			error: function(res){
 				console.log(res)
 			}
 		})
 		
 	});
	
	//修改内容
	$("#item1").hide();
	$(".name1").attr("disabled",true);
	$("#modify").click(function(){
		if($("#modify").text()=="修改"){
			$('.name1').attr("disabled",false);
			$(this).text("提交");
			$("#label").show();
			$(".type p").remove();
		}else if(($("#modify").text()=="提交")&&($(".name1").val()!="")){
			$(".name1").attr("disabled",false);
			$("#label").show();
			var l_id="[";
			var length=$("input:checkbox[name='check']:checked").length;
	 		if(length!=0){
	 			$("input:checkbox[name='check']:checked").each(function(i,index){
	 				//操作
	 				console.log($(this).attr("id"))
	 				if(i<length-1){
	 					l_id+=$(this).attr("id")+","
	 				} else {
	 					l_id+=$(this).attr("id")+"]"
	 				}
	 			});
// 	 			$("#l_id").val($.parseJSON(l_id))
	 	 		$.ajax({
	 			type:"POST",
	 			url:"/KnowledgeLibrary/user/modifyKnowledge",
	 			dataType: "json",
	 			traditional:true,
	 			data:{
	 				k_id:id,
	 				k_name:$(".name1").val(),
	 				k_typeId:$.parseJSON(l_id)
	 			},
	 			
	 			success:function(res){
	 				if(res.resultCode=="5000"){
	 					location.href="user_myKnowledge.jsp";
	 				}
	 				else alert(res.resultCode);
	 			},
	 			error:function(res){
	 				console.log(res);
	 			}
	 		})
	 		}else{
	 			$("#test").show();
	 		}
			
		}
		
	});
	$(".name1").on("blur",function(){
	      if(($(".name1").val()=="")){
	        $("#item1").show();
	      }else{
	        $("#item1").hide();
	      }
	    });
	$("#return").click(function(){location.href="user_myKnowledge.jsp"})
</script>
</html>