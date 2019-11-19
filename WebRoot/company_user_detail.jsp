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
    <title>用户详情</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta content=”text/html;charset=utf-8″ />
	<script type="text/javascript" src = "js/jquery.js"></script>
    <script type="text/javascript" src = "js/jquerySession.js"></script>
	<link rel="stylesheet" type="text/css" href="css/design.css">
    <style>
    
      .td{
        width:100px;
      }
      tr td{
        border:none;
      }
      tr td input{
        font-size:1.2em;
        padding:10px;
        border:solid 1px;
        width:300px;
      } 
      
      select:disabled{
        background-color:white;
      }
      input:disabled{
        background-color:white;
      }
      .row{
        display:block;
        width:450px;
        margin:1em auto;
      }
      .com_list_title{
        margin-top:0px;
      }
      .select{
        width:300px;
        font-size:1.2em;
        padding:10px;
        border:solid 1px black;
        -webkit-appearance: none; /*for chrome*/
        
      }
      .select_user{
      width:100%;
      font-size: 16px;
      border: 1px solid;
      background-color:white;
   	  margin:0;
      }

      
      button:focus{
    border:none;
    box-shadow: inset 0 1px 1px rgba(0,0,0,.075),0 0 8px rgba(102,175,233,.6);
  }
      
    </style>
   </head>
  <body>
    <center>
    <div class="flex_column">
    	<div>
    		<img id="return" class="icon" src="image/return.png"/>
    	</div>
    	<div class="com_list_title">
			个人信息
		</div>
	  	<table  border="2" bgcolor="white" cellpadding="5"  cellspacing="10">
		<tr>
			<td class="td">姓名</td>
			<td><input class="name" type="text"></td>
			<td id="item1" style="color:red;width:100px;">
			  	用户名不能为空！
			</td>
		</tr>
		<tr>
			<td class="td">性别</td>
			<td>
			  <select id="sex" class="select">
		    	    <option value="男">男</option>
		    	    <option value="女">女</option> 
		    	</select>
			</td>
		</tr>
		<tr>
			<td class="td">电话</td>
			<td>
			  <input class="phon" type="text">
			</td>
			<td id="item3" style="color:red;width:100px;">
			  	请填入正确的电话！
			</td>
		</tr>
		<tr>
			<td class="td">权限</td>
			<td>
				<select id="role" class="select">
			    	<option value="1">普通用户</option>
			    	<option value="2">用户管理员</option> 
			    	<option value="3">知识管理员</option> 
			    	<option value="4">超级管理员</option>   
			    </select>
			</td>
		</tr>
		<tr>
			<td class="td">年龄</td>
			<td>
			  <input class="age" type="text">
			</td>
			<td id="item5" style="color:red;width:100px;">
			  	年龄不能为空！
			</td>
		</tr>
		<tr>
			<td class="td">邮箱</td>
			<td>
			  <input class="email" type="text">
			</td>
			<td id="item6" style="color:red;width:100px;">
			  	请填入正确的邮箱！
			</td>			
		</tr>
		</table>
		<div class="row">
		   <button id="modify" class="modify">修改</button>
		</div>	
    </div>
 	<script>
 	  $("#item1").hide();
 	  $("#item2").hide();
 	  $("#item3").hide();
 	  $("#item4").hide();
 	  $("#item5").hide();
 	  $("#item6").hide();
 	  $(".name").attr("disabled",true);
 	  $("#sex").attr("disabled",true);
 	  $(".phon").attr("disabled",true);
 	  $("#role").attr("disabled",true);
 	  $(".age").attr("disabled",true);
 	  $(".email").attr("disabled",true);
 	$.ajax({
		  type:"post",
		  url:"/KnowledgeLibrary/user/viewUserInfo",
		  data:{
			  u_id:getUrlParam("id")
		  },
		  success:function(res){
			  //console.log(res)
			  $(".name").val(res.data.u_name);
			  if(res.data.u_gender=="男"){
				  $("#sex").val("男");
			  }else 
				  $("#sex").val("女");
			  $(".phon").val(res.data.u_phone);
			  if(res.data.u_role=="1"){
				  $("#role").val(1);
				  //$("#role").find("option[text='普通用户']").attr("selected",true);
			  }else if(res.data.u_role=="2"){
				  $("#role").val(2);
				  //$("#role").find("option[text='知识管理员']").attr("selected",true);
			  }else if(res.data.u_role=="3"){
				  $("#role").val(3);
				  //$("#role").find("option[text='用户管理员']").attr("selected",true);
			  }else if(res.data.u_role=="4"){
				  $("#role").val(4);
				  //$("#role").find("option[text='超级管理员']").attr("selected",true);
			  }
			  $(".age").val(res.data.u_age)
			  $(".email").val(res.data.u_email)
		  },
		  error:function(res){
			  console.log(res)
		  }
	  })
 	$("#role").attr("disabled",true);
 	$("#modify").click(function(){
 		if($(this).text()=="修改"){
 		
 	 	$("#role").attr("disabled",false);

 		$(this).text("提交");
 		}else{
 			if($("#modify").text()=="提交"){
 	 			if (($('.name').val() == '')) {
 					$("#item1").show();
 				} else {
 					$("#item1").hide();
 				}
 				if (($('#sex').val() == '')) {
 					$("#item2").show();
 				} else {
 					$("#item2").hide();
 				}
 				if (($('.phon').val() == '')) {
 					$("#item3").show();
 				} else {
 					$("#item3").hide();
 				}
 				if (($('.age').val() == '')) {
 					$("#item5").show();
 				} else {
 					$("#item5").hide();
 				}
 				if (($('.email').val() == '')) {
 					$("#item6").show();
 				} else {
 					$("#item6").hide();
 				}
 				
 				if (($('.name').val() != '') && ($('.sex').val() != '')&&($('.phon').val() != '')&&
 						($('.age').val() != '') && ($('.email').val() != '')) { 
 					$.ajax({
 						type : "POST",
 						url : "/KnowledgeLibrary/firm/modifyUserInfo",
 						data : {
 							u_id :getUrlParam("id"),
 							u_name : $(".name").val(),
 							u_role : $("#role option:selected").val(),
 							u_gender : $("#sex").val(),
 							u_phone : $(".phon").val(),
 							u_age : $(".age").val(),
 							u_mail : $(".email").val()
 						},
 						success : function(json) {
 							if (json.resultCode == "5000") {
 								//修改成功
 								//alert(json.resultDesc);
 								$("#test3").text(json.resultDesc);
 								window.location.href = "userlist.jsp";
 								 
 							} else {
 								//修改失败
 								//alert(json.resultDesc);
 								$("#test3").text(json.resultDesc);
 								window.location.href = "userlist.jsp";
 							}
 						},
 						error : function(jqXHR) {
 							//alert(json.resultDesc);
 							$("#test3").text("您所请求的页面有异常");
 							window.location.href = "userlist.jsp";
 						}
 					});
 				 }
 				
 	 		}
 		}
 	})
 	
 	 $(".name").on("blur",function(){
      if(($(".name").val()=="")){
        $("#item1").show();
      }else{
        $("#item1").hide();
      }
    });
  $("#sex").on("blur",function(){
      if(($("#input2").val()=="")){
        $("#item2").show();
      }else{
        $("#item2").hide();
      }
    });
  var myReg1 = /^1[3-9]+\d{9}$/;
  $(".phon").on("blur",function(){
      if(myReg1.test($("#input3").val())){
        $("#item3").show();
      }else{
        $("#item3").hide();
      }
    });
  $(".age").on("blur",function(){
      if(($(".age").val()=="")){
        $("#item5").show();
      }else{
        $("#item5").hide();
      }
    });
  var myReg = /^[a-zA-Z0-9_-]+@([a-zA-Z0-9]+\.)+(com|cn|net|org)$/;
  $(".email").on("blur",function(){
      if(myReg.test($(".email").val())){
        $("#item6").show();
      }else{
        $("#item6").hide();
      }
    });

 	
    $("#return").click(function(){location.href="userlist.jsp"})
  	</script>
  </center>
  </body>
</html>